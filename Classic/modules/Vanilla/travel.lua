---@class XIVBar
local XIVBar = select(2, ...);
local xb = XIVBar;
local L = XIVBar.L;
local compat = xb.compat

local TravelModule = xb:NewModule("TravelModule", 'AceEvent-3.0')

local function SupportsMagePorts()
    return compat.features and compat.features.travel and compat.features.travel.magePortals
        and xb.constants.playerClass == 'MAGE'
end

function TravelModule:GetName()
    return L["TRAVEL"];
end

function TravelModule:OnInitialize()
    self.hearthstones = {
        184871, -- Dark Portal
        6948 -- Hearthstone
    }
    self.mageButtons = {}
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
end

function TravelModule:OnEnable()
    if self.hearthFrame == nil then
        self.hearthFrame = CreateFrame('FRAME', nil, xb:GetFrame('bar'))
        xb:RegisterFrame('travelFrame', self.hearthFrame)
    end
    self.hearthFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function TravelModule:OnDisable()
    self.hearthFrame:Hide()
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('BAG_UPDATE_DELAYED')
    self:UnregisterEvent('HEARTHSTONE_BOUND')
    if self.mageTooltipTimer then
        self.mageTooltipTimer:Cancel()
        self.mageTooltipTimer = nil
    end
end

function TravelModule:CreateFrames()
    self.hearthButton = self.hearthButton or
                            CreateFrame('BUTTON', 'hearthButton', self.hearthFrame, 'SecureActionButtonTemplate')
    self.hearthIcon = self.hearthIcon or self.hearthButton:CreateTexture(nil, 'OVERLAY')
    self.hearthText = self.hearthText or self.hearthButton:CreateFontString(nil, 'OVERLAY')

    self.mageButton = self.mageButton or
                        CreateFrame('BUTTON', 'mageButton', self.hearthFrame, 'SecureActionButtonTemplate')
    self.mageIcon = self.mageIcon or self.mageButton:CreateTexture(nil, 'OVERLAY')
    self.mageText = self.mageText or self.mageButton:CreateFontString(nil, 'OVERLAY')

    local magePopupTemplate
    if TooltipBackdropTemplateMixin then
        magePopupTemplate = "TooltipBackdropTemplate"
    elseif BackdropTemplateMixin then
        magePopupTemplate = "BackdropTemplate"
    end
    self.magePopup = self.magePopup or
                         CreateFrame('BUTTON', 'magePopup', self.mageButton, magePopupTemplate)
    self.magePopup:SetFrameStrata("TOOLTIP")
    xb:RegisterMouseoverHoldFrame(self.magePopup, true)

    if TooltipBackdropTemplateMixin then
        self.magePopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.magePopup.NineSlice)

        if GameTooltip.layoutType then
            local nineSlice = self.magePopup.NineSlice
            local tooltipNineSlice = GameTooltip.NineSlice

            if nineSlice.SetCenterColor and tooltipNineSlice.GetCenterColor then
                nineSlice:SetCenterColor(tooltipNineSlice:GetCenterColor())
            end
            if nineSlice.SetBorderColor and tooltipNineSlice.GetBorderColor then
                nineSlice:SetBorderColor(tooltipNineSlice:GetBorderColor())
            end
        end
    else
        local backdrop = GameTooltip.GetBackdrop and GameTooltip:GetBackdrop()
        if backdrop then
            self.magePopup:SetBackdrop(backdrop)
            self.magePopup:SetBackdropColor(GameTooltip:GetBackdropColor())
            self.magePopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
        end
    end
end

function TravelModule:RegisterFrameEvents()
    self:RegisterEvent('SPELLS_CHANGED', 'Refresh')
    self:RegisterEvent('BAG_UPDATE_DELAYED', 'Refresh')
    self:RegisterEvent('HEARTHSTONE_BOUND', 'Refresh')
    self.hearthButton:EnableMouse(true)
    self.hearthButton:RegisterForClicks('AnyUp')
    self.hearthButton:SetAttribute('type', 'macro')

    self.hearthButton:SetScript('OnEnter', function()
        TravelModule:SetHearthColor()
    end)

    self.hearthButton:SetScript('OnLeave', function()
        TravelModule:SetHearthColor()
    end)

    self.mageButton:EnableMouse(true)
    self.mageButton:RegisterForClicks("AnyUp", "AnyDown")
    self.mageButton:SetAttribute('*type1', 'macro')
    self.mageButton:SetAttribute('*type2', 'mageFunction')

    self.magePopup:EnableMouse(true)
    self.magePopup:RegisterForClicks('RightButtonUp')

    self.mageButton.mageFunction = self.mageButton.mageFunction or function()
        if TravelModule.magePopup:IsVisible() then
            xb:HidePopup(TravelModule.magePopup)
            self:ShowMageTooltip()
        else
            TravelModule:CreateMagePopup()
            xb:ShowPopup(TravelModule.magePopup)
            GameTooltip:Hide()
        end
    end

    self.magePopup:SetScript('OnClick', function(popupFrame, button)
        if button == 'RightButton' then xb:HidePopup(popupFrame) end
    end)

    self.mageButton:SetScript('OnEnter', function()
        self:SetMageColor()
        if not InCombatLockdown() then
            self:ShowMageTooltip()
        end
    end)

    self.mageButton:SetScript('OnLeave', function()
        self:SetMageColor()
        if self.mageTooltipTimer then
            self.mageTooltipTimer:Cancel()
            self.mageTooltipTimer = nil
        end
        GameTooltip:Hide()
    end)
end

function TravelModule:FormatCooldown(cdTime)
    if cdTime <= 0 then return L["READY"] end
    local hours = string.format("%02.f", math.floor(cdTime / 3600))
    local minutes = string.format("%02.f", math.floor(cdTime / 60 - (hours * 60)))
    local seconds = string.format("%02.f", math.floor(cdTime - (hours * 3600) - (minutes * 60)))
    local retString = ''
    if tonumber(hours) ~= 0 then retString = hours .. ':' end
    if tonumber(minutes) ~= 0 or tonumber(hours) ~= 0 then
        retString = retString .. minutes .. ':'
    end
    return retString .. seconds
end

function TravelModule:GetFavoriteMageSpell()
    local favorite = xb.db and xb.db.char and xb.db.char.magePortItem
    local spell = xb.MagePortals:FindKnownSpell(favorite and favorite.spellId)
    if spell then
        return spell
    end
    return xb.MagePortals:GetFirstKnown()
end

function TravelModule:SetMageColor()
    if InCombatLockdown() then return end
    if not self.mageButton then return end

    local db = xb.db.profile
    local spell = self:GetFavoriteMageSpell()
    if spell then
        self.mageButton:SetAttribute("macrotext", "/cast " .. spell.name)
    end

    if self.mageButton:IsMouseOver() then
        self.mageText:SetTextColor(unpack(xb:HoverColors()))
        if db.hideMagePortText then
            self.mageIcon:SetVertexColor(unpack(xb:HoverColors()))
        end
    elseif spell then
        self.mageIcon:SetVertexColor(xb:GetColor('normal'))
        self.mageText:SetTextColor(xb:GetColor('normal'))
    else
        self.mageIcon:SetVertexColor(db.color.inactive.r, db.color.inactive.g,
                                     db.color.inactive.b, db.color.inactive.a)
        self.mageText:SetTextColor(db.color.inactive.r, db.color.inactive.g,
                                   db.color.inactive.b, db.color.inactive.a)
    end
end

function TravelModule:CreateMagePopup()
    if not self.magePopup then return end

    local db = xb.db.profile
    local teleports, portals = xb.MagePortals:GetKnownSpells()

    self.mageOptionString = self.mageOptionString or
                                self.magePopup:CreateFontString(nil, 'OVERLAY')
    self.mageOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.mageOptionString:SetTextColor(r, g, b, 1)
    self.mageOptionString:SetText(L["MAGE_PORTALS"])
    self.mageOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.mageOptionString:SetPoint('CENTER')

    self.mageTeleportHeader = self.mageTeleportHeader or
                                  self.magePopup:CreateFontString(nil, 'OVERLAY')
    self.magePortalHeader = self.magePortalHeader or
                                self.magePopup:CreateFontString(nil, 'OVERLAY')

    local function styleHeader(header, text)
        header:SetFont(xb:GetFont(db.text.fontSize))
        header:SetTextColor(r, g, b, 1)
        header:SetText(text)
        header:Show()
    end

    if #teleports > 0 then
        styleHeader(self.mageTeleportHeader, L["MAGE_TELEPORTS"])
    else
        self.mageTeleportHeader:Hide()
    end
    if #portals > 0 then
        styleHeader(self.magePortalHeader, L["MAGE_PORTAL_SPELLS"])
    else
        self.magePortalHeader:Hide()
    end

    local popupWidth = self.magePopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    local favorite = self:GetFavoriteMageSpell()
    local favoriteId = favorite and favorite.spellId

    if not self.mageButtons then self.mageButtons = {} end
    for _, button in pairs(self.mageButtons) do
        button.isSettable = false
        button:Hide()
    end

    local function ensureMageButton(spell)
        local button = self.mageButtons[spell.spellId]
        if button == nil then
            button = CreateFrame('BUTTON', nil, self.magePopup)
            local buttonText = button:CreateFontString(nil, 'OVERLAY')
            buttonText:SetFont(xb:GetFont(db.text.fontSize))
            buttonText:SetTextColor(xb:GetColor('normal'))
            buttonText:SetPoint('LEFT')
            button.textField = buttonText
            button.icon = button:CreateTexture(nil, 'OVERLAY')

            button:EnableMouse(true)
            button:RegisterForClicks('LeftButtonUp')
            button:SetScript('OnEnter', function()
                buttonText:SetTextColor(unpack(xb:HoverColors()))
            end)
            button:SetScript('OnLeave', function()
                buttonText:SetTextColor(xb:GetColor('normal'))
            end)
            button:SetScript('OnClick', function(clickedButton)
                xb.db.char.magePortItem = { spellId = clickedButton.spellId }
                xb:HidePopup(TravelModule.magePopup)
                TravelModule:Refresh()
            end)
            self.mageButtons[spell.spellId] = button
        end

        button.spellId = spell.spellId
        button.isSettable = true
        local label = spell.name
        if favoriteId == spell.spellId then
            label = label .. " |cffffffff(" .. L["SELECTED"] .. ")|r"
        end
        button.textField:SetText(label)
        local iconSize = db.text.fontSize
        local iconPad = db.general.barPadding
        button.icon:SetSize(iconSize, iconSize)
        button.icon:ClearAllPoints()
        button.icon:SetPoint('LEFT')
        button.textField:ClearAllPoints()
        local rowWidth = button.textField:GetStringWidth()
        if spell.icon then
            button.icon:SetTexture(spell.icon)
            button.icon:Show()
            button.textField:SetPoint('LEFT', button.icon, 'RIGHT', iconPad, 0)
            rowWidth = iconSize + iconPad + rowWidth
        else
            button.icon:Hide()
            button.textField:SetPoint('LEFT')
        end
        button:SetSize(rowWidth, db.text.fontSize)
        button:Show()
        if rowWidth > popupWidth then
            popupWidth = rowWidth
            changedWidth = true
        end
        return button
    end

    for i = 1, #teleports do
        ensureMageButton(teleports[i])
    end
    for i = 1, #portals do
        ensureMageButton(portals[i])
    end

    local function addHeader(header)
        if not header:IsShown() then return end
        header:ClearAllPoints()
        header:SetPoint('LEFT', xb.constants.popupPadding, 0)
        header:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
        header:SetPoint('RIGHT')
        popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        local headerWidth = header:GetStringWidth()
        if headerWidth > popupWidth then
            popupWidth = headerWidth
            changedWidth = true
        end
    end

    local function addSpellButtons(list)
        for i = 1, #list do
            local button = self.mageButtons[list[i].spellId]
            if button and button.isSettable then
                button:ClearAllPoints()
                button:SetPoint('LEFT', xb.constants.popupPadding, 0)
                button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
                button:SetPoint('RIGHT')
                popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
            end
        end
    end

    local headers = {
        teleport = self.mageTeleportHeader,
        portal = self.magePortalHeader,
    }
    local categories = xb.MagePortals:GetSortedKnownCategories()
    for i = 1, #categories do
        addHeader(headers[categories[i].kind])
        addSpellButtons(categories[i].list)
    end

    if changedWidth then popupWidth = popupWidth + self.extraPadding end

    if popupWidth < self.mageButton:GetWidth() then
        popupWidth = self.mageButton:GetWidth()
    end

    if popupWidth < (self.mageOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth = (self.mageOptionString:GetStringWidth() + self.extraPadding)
    end
    self.magePopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)
end

function TravelModule:ShowMageTooltip()
    if not self.mageButton then return end
    if self.magePopup and self.magePopup:IsVisible() then return end

    if not xb:ShouldShowTooltip() then
        GameTooltip:Hide()
        return
    end

    GameTooltip:SetOwner(self.mageButton, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. L["MAGE_PORTALS"] .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")

    local favorite = self:GetFavoriteMageSpell()
    if favorite then
        local cdString = self:FormatCooldown(xb.MagePortals:GetCooldownRemaining(favorite.spellId))
        local favoriteLabel = xb.MagePortals:FormatIconLabel(favorite.icon, favorite.name, xb.db.profile.text.fontSize)
        if not xb.db.profile.hideAdditionalTooltipText then
            favoriteLabel = favoriteLabel .. " |cffffffff(" .. L["SELECTED"] .. ")|r"
        end
        GameTooltip:AddDoubleLine(favoriteLabel, cdString, r, g, b, 1, 1, 1)
    end

    local onCooldown = xb.MagePortals:GetOnCooldownSpells(favorite and favorite.spellId)
    for i = 1, #onCooldown do
        local spell = onCooldown[i]
        local label = xb.MagePortals:FormatIconLabel(spell.icon, spell.name, xb.db.profile.text.fontSize)
        GameTooltip:AddDoubleLine(label, self:FormatCooldown(spell.remaining), r, g, b, 1, 1, 1)
    end

    if favorite then
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', xb.MagePortals:FormatIconLabel(favorite.icon, favorite.name, xb.db.profile.text.fontSize), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine('<' .. L["RIGHT_CLICK"] .. '>', L["CHANGE_MAGE_PORT_OPTION"], r, g, b, 1, 1, 1)
    end
    GameTooltip:Show()

    if not self.mageTooltipTimer then
        self.mageTooltipTimer = C_Timer.NewTicker(1, function()
            if GameTooltip:IsOwned(self.mageButton) and not (self.magePopup and self.magePopup:IsVisible()) then
                self:ShowMageTooltip()
            else
                if self.mageTooltipTimer then
                    self.mageTooltipTimer:Cancel()
                    self.mageTooltipTimer = nil
                end
            end
        end)
    end
end

function TravelModule:SetHearthColor()
    if InCombatLockdown() then
        return;
    end

    if self.hearthButton:IsMouseOver() then
        self.hearthText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.hearthIcon:SetVertexColor(xb:GetColor('normal'))
        for _, v in ipairs(self.hearthstones) do
            if IsUsableItem(v) then
                if C_Container.GetItemCooldown(v) == 0 then
                    local hearthName = GetItemInfo(v)
                    if hearthName ~= nil then
                        self.hearthButton:SetAttribute("macrotext", "/cast " .. hearthName)
                        break
                    end
                end
            end -- if toy/item
            if IsPlayerSpell(v) then
                if GetSpellCooldown(v) == 0 then
                    local spellInfo = GetSpellInfo(v)
                    local hearthName = spellInfo and spellInfo.name
                    self.hearthButton:SetAttribute("macrotext", "/cast " .. hearthName)
                end
            end -- if is spell
        end -- for hearthstones
        self.hearthText:SetTextColor(xb:GetColor('normal'))
    end -- else
end

function TravelModule:Refresh()
    if self.hearthFrame == nil then
        return;
    end

    if not xb.db.profile.modules.travel.enabled then
        self:Disable();
        return;
    end

    local db = xb.db.profile
    local supportsMagePorts = SupportsMagePorts()
    local hasMageSpells = supportsMagePorts and xb.MagePortals:HasKnownSpells()

    if InCombatLockdown() then
        self.hearthText:SetText(GetBindLocation())
        self:SetHearthColor()
        if supportsMagePorts and self.mageText then
            local hideMageText = db.hideMagePortText
            local combatMageSpell = self:GetFavoriteMageSpell()
            local combatMageText = combatMageSpell and combatMageSpell.name or ''
            self.mageText:SetText(hideMageText and '' or combatMageText)
            self.mageText:SetShown(not hideMageText)
            self:SetMageColor()
        end
        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding

    self.hearthText:SetFont(xb:GetFont(db.text.fontSize))
    self.hearthText:SetText(GetBindLocation())

    self.hearthButton:SetSize(self.hearthText:GetWidth() + iconSize + db.general.barPadding, xb:GetHeight())
    self.hearthButton:ClearAllPoints()
    self.hearthButton:SetPoint("RIGHT")

    self.hearthText:SetPoint("RIGHT")

    self.hearthIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\hearth')
    self.hearthIcon:SetSize(iconSize, iconSize)

    self.hearthIcon:SetPoint("RIGHT", self.hearthText, "LEFT", -(db.general.barPadding), 0)

    self:SetHearthColor()
    self.hearthButton:Show()

    local totalWidth = self.hearthButton:GetWidth()

    if hasMageSpells and not db.hideMagePortButton then
        local hideMageText = db.hideMagePortText
        local mageSpell = self:GetFavoriteMageSpell()
        local mageText = mageSpell and mageSpell.name or ''

        self.mageButton:Show()
        self.mageText:SetFont(xb:GetFont(db.text.fontSize))
        self.mageText:SetText(hideMageText and '' or mageText)
        self.mageText:SetShown(not hideMageText)

        local mageTextWidth = hideMageText and 0 or self.mageText:GetWidth()
        local mageButtonWidth = hideMageText and iconSize or (mageTextWidth + iconSize + db.general.barPadding)

        self.mageButton:SetSize(mageButtonWidth, xb:GetHeight())
        self.mageButton:ClearAllPoints()
        self.mageButton:SetPoint("RIGHT", self.hearthButton, "LEFT", -(db.general.barPadding), 0)

        self.mageText:SetPoint("RIGHT")
        self.mageIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\mage_portal')
        self.mageIcon:SetSize(iconSize, iconSize)
        self.mageIcon:ClearAllPoints()

        if hideMageText then
            self.mageIcon:SetPoint("RIGHT", self.mageButton, "RIGHT", 0, 0)
        else
            self.mageIcon:SetPoint("RIGHT", self.mageText, "LEFT", -(db.general.barPadding), 0)
        end

        self:SetMageColor()
        self:CreateMagePopup()
        totalWidth = totalWidth + db.general.barPadding + self.mageButton:GetWidth()
    elseif self.mageButton then
        self.mageButton:Hide()
        if self.magePopup then self.magePopup:Hide() end
    end

    if self.magePopup then
        local popupPoint = 'BOTTOMRIGHT'
        local relPoint = 'TOPRIGHT'
        if db.general.barPosition == 'TOP' then
            popupPoint = 'TOPRIGHT'
            relPoint = 'BOTTOMRIGHT'
        end
        self.magePopup:ClearAllPoints()
        self.magePopup:SetPoint(popupPoint, self.mageButton, relPoint, 0, 0)
        self.magePopup:Hide()
    end

    self.hearthFrame:SetSize(totalWidth + db.general.barPadding, xb:GetHeight())

    if xb:ApplyModuleFreePlacement('travel', self.hearthFrame) then
        self.hearthFrame:Show()
        return
    end

    self.hearthFrame:ClearAllPoints()
    self.hearthFrame:SetPoint("RIGHT", -(db.general.barPadding), 0)
    self.hearthFrame:Show()
end

function TravelModule:GetDefaultOptions()
    return 'travel', {
        enabled = true,
        hideMagePortButton = false,
        hideMagePortText = false
    }
end

function TravelModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.travel.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.travel.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            hideMagePortButton = {
                name = L["HIDE_MAGE_PORT_BUTTON"],
                order = 12,
                type = "toggle",
                hidden = function() return not SupportsMagePorts() end,
                get = function()
                    return xb.db.profile.hideMagePortButton;
                end,
                set = function(_, val)
                    xb.db.profile.hideMagePortButton = val;
                    self:Refresh();
                end,
                width = "2"
            },
            hideMagePortText = {
                name = L["HIDE_MAGE_PORT_TEXT"],
                order = 12.5,
                type = "toggle",
                hidden = function() return not SupportsMagePorts() end,
                get = function()
                    return xb.db.profile.hideMagePortText;
                end,
                set = function(_, val)
                    xb.db.profile.hideMagePortText = val;
                    self:Refresh();
                end,
                disabled = function() return xb.db.profile.hideMagePortButton end,
                width = "1"
            }
        }
    }
end
