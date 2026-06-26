---@class XIVBar
local XIVBar = select(2, ...)
local _G = _G
local xb = XIVBar
local L = XIVBar.L
local compat = XIVBar.compat or {}
local C_EquipmentSet = C_EquipmentSet
local IsAddOnLoaded = (compat and compat.IsAddOnLoaded) or (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded

local ArmorModule = xb:NewModule("ArmorModule", 'AceEvent-3.0')

function ArmorModule:GetName()
    return AUCTION_CATEGORY_ARMOR
end

function ArmorModule:SkinFrame(frame, name)
    if self.useElvUI then
        if frame.StripTextures then
            frame:StripTextures()
        end
        if frame.SetTemplate then
            frame:SetTemplate("Transparent")
        end

        local close = _G[name .. "CloseButton"] or frame.CloseButton
        if close and close.SetAlpha then
            if _G.ElvUI then
                _G.ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
            end

            if _G.Tukui and _G.Tukui[1] and _G.Tukui[1].SkinCloseButton then
                _G.Tukui[1].SkinCloseButton(close)
            end
            close:SetAlpha(1)
        end
    end
end

function ArmorModule:OnInitialize()
    self.iconPath = xb.constants.mediaPath .. 'datatexts\\repair'
    self.durabilityLowest = nil
    self.durabilityList = {
        [INVSLOT_HEAD] = {cur = 0, max = 0, pc = 0, text = HEADSLOT},
        [INVSLOT_SHOULDER] = {cur = 0, max = 0, pc = 0, text = SHOULDERSLOT},
        [INVSLOT_CHEST] = {cur = 0, max = 0, pc = 0, text = CHESTSLOT},
        [INVSLOT_WRIST] = {cur = 0, max = 0, pc = 0, text = WRISTSLOT},
        [INVSLOT_HAND] = {cur = 0, max = 0, pc = 0, text = HANDSSLOT},
        [INVSLOT_WAIST] = {cur = 0, max = 0, pc = 0, text = WAISTSLOT},
        [INVSLOT_LEGS] = {cur = 0, max = 0, pc = 0, text = LEGSSLOT},
        [INVSLOT_FEET] = {cur = 0, max = 0, pc = 0, text = FEETSLOT},
        [INVSLOT_MAINHAND] = {cur = 0, max = 0, pc = 0, text = MAINHANDSLOT},
        [INVSLOT_OFFHAND] = {cur = 0, max = 0, pc = 0, text = SECONDARYHANDSLOT}
    }
    self.slotOrder = {
        INVSLOT_HEAD, INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_WRIST,
        INVSLOT_HAND, INVSLOT_WAIST, INVSLOT_LEGS, INVSLOT_FEET,
        INVSLOT_MAINHAND, INVSLOT_OFFHAND
    }
    self.MapRects = {}
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
    self.equipmentSetButtons = {}
    self.useElvUI = xb.db.profile.general.useElvUI and (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui'))
end

function ArmorModule:OnEnable()
    if self.armorFrame == nil then
        self.armorFrame = CreateFrame("FRAME", AUCTION_CATEGORY_ARMOR, xb:GetFrame('bar'))
        xb:RegisterFrame('armorFrame', self.armorFrame)
    end
    self.armorFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:RegisterCoordTicker()
    self:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'ScheduleEquipmentRefresh')
    self:RegisterEvent('EQUIPMENT_SWAP_FINISHED')
    self:RegisterEvent('UNIT_INVENTORY_CHANGED')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    xb:Refresh()
end

function ArmorModule:OnDisable()
    self:UnregisterEvent('UPDATE_INVENTORY_DURABILITY')
    self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:UnregisterEvent('EQUIPMENT_SWAP_FINISHED')
    self:UnregisterEvent('UNIT_INVENTORY_CHANGED')
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self.equipmentFollowUpToken = (self.equipmentFollowUpToken or 0) + 1
    self.pendingEquipmentSetID = nil
    if self.equipmentRefreshTimer then
        self.equipmentRefreshTimer:Cancel()
        self.equipmentRefreshTimer = nil
    end
    if self.equipmentSetFallbackTimer then
        self.equipmentSetFallbackTimer:Cancel()
        self.equipmentSetFallbackTimer = nil
    end
    self.armorFrame:Hide()
end

function ArmorModule:RefreshAfterEquipmentChange()
    self.equipmentFollowUpToken = (self.equipmentFollowUpToken or 0) + 1
    local token = self.equipmentFollowUpToken
    local delays = {0, 0.15, 0.4, 0.8, 1.5}

    for _, delay in ipairs(delays) do
        C_Timer.After(delay, function()
            if token ~= self.equipmentFollowUpToken or not self:IsEnabled() then
                return
            end
            self:Refresh()
            if GameTooltip:IsOwned(self.armorFrame) then
                self:ShowTooltip()
            end
        end)
    end
end

function ArmorModule:BeginEquipmentSetSwap(setID)
    self.pendingEquipmentSetID = setID

    if self.equipmentSetFallbackTimer then
        self.equipmentSetFallbackTimer:Cancel()
    end

    self.equipmentSetFallbackTimer = C_Timer.NewTimer(2, function()
        self.equipmentSetFallbackTimer = nil
        if not self:IsEnabled() or self.pendingEquipmentSetID ~= setID then
            return
        end
        self.pendingEquipmentSetID = nil
        self:RefreshAfterEquipmentChange()
    end)
end

function ArmorModule:EQUIPMENT_SWAP_FINISHED(_, success)
    if self.equipmentSetFallbackTimer then
        self.equipmentSetFallbackTimer:Cancel()
        self.equipmentSetFallbackTimer = nil
    end
    self.pendingEquipmentSetID = nil

    if success then
        self:RefreshAfterEquipmentChange()
    end
end

function ArmorModule:ScheduleEquipmentRefresh()
    if self.pendingEquipmentSetID then
        return
    end

    if self.equipmentRefreshTimer then
        self.equipmentRefreshTimer:Cancel()
    end

    self.equipmentRefreshTimer = C_Timer.NewTimer(0.15, function()
        self.equipmentRefreshTimer = nil
        if self:IsEnabled() then
            self:Refresh()
        end
    end)
end

function ArmorModule:UNIT_INVENTORY_CHANGED(_, unit)
    if unit == 'player' then
        self:ScheduleEquipmentRefresh()
    end
end

function ArmorModule:PLAYER_ENTERING_WORLD()
    C_Timer.After(0.5, function()
        if self:IsEnabled() then
            self:Refresh()
        end
    end)
end

function ArmorModule:GetSlotDurability(slotId)
    if compat.isMainline then
        return GetInventoryItemDurability(slotId)
    end
    return GetInventoryItemDurability('player', slotId)
end

function ArmorModule:GetCurrentEquipmentSet()
    if not C_EquipmentSet or not C_EquipmentSet.GetEquipmentSetIDs or not C_EquipmentSet.GetEquipmentSetInfo then
        return nil, nil
    end

    local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
    if not setIDs then
        return nil, nil
    end

    for _, setID in ipairs(setIDs) do
        local name, iconFileID, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(setID)
        if isEquipped and name then
            return name, iconFileID
        end
    end

    return nil, nil
end

function ArmorModule:CreateFrames()
    self.armorButton = self.armorButton or CreateFrame('BUTTON', nil, self.armorFrame)
    self.armorIcon = self.armorIcon or self.armorButton:CreateTexture(nil, 'OVERLAY')
    self.armorText = self.armorText or self.armorButton:CreateFontString(nil, 'OVERLAY')
    self.coordText = self.coordText or self.armorButton:CreateFontString(nil, 'OVERLAY')

    local template = (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
                         (BackdropTemplateMixin and "BackdropTemplate")
    self.equipmentSetPopup = self.equipmentSetPopup or CreateFrame('BUTTON', 'EquipmentSetPopup', self.armorButton, template)
    self.equipmentSetPopup:SetFrameStrata('TOOLTIP')
    xb:RegisterMouseoverHoldFrame(self.equipmentSetPopup, true)

    if TooltipBackdropTemplateMixin then
        self.equipmentSetPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.equipmentSetPopup.NineSlice)

        if GameTooltip.layoutType then
            self.equipmentSetPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
            self.equipmentSetPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
        end
    else
        local backdrop = GameTooltip:GetBackdrop()
        if backdrop then
            self.equipmentSetPopup:SetBackdrop(backdrop)
            self.equipmentSetPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
            self.equipmentSetPopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
        end
    end

    self.equipmentSetPopup:Hide()
end

function ArmorModule:RegisterFrameEvents()
    self.armorButton:EnableMouse(true)
    self.armorButton:RegisterForClicks('AnyUp')

    self.armorButton:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return
        end
        self:SetArmorColor()
        if not self.equipmentSetPopup:IsVisible() then
            self:ShowTooltip()
        end
    end)

    self.armorButton:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return
        end
        self:SetArmorColor()
        GameTooltip:Hide()
    end)

    self.armorButton:SetScript('OnClick', function(_, button)
        GameTooltip:Hide()

        if InCombatLockdown() then
            return
        end

        if button == 'LeftButton' then
            if not self.equipmentSetPopup:IsVisible() then
                self:CreateEquipmentSetPopup()
                xb:ShowPopup(self.equipmentSetPopup)
                self:SetArmorColor()
            else
                xb:HidePopup(self.equipmentSetPopup)
                self:SetArmorColor()
                if xb:ShouldShowTooltip() then
                    self:ShowTooltip()
                end
            end
        end
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'microMenuFrame' then
            self:Refresh()
        end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'microMenuFrame' then
            self:Refresh()
        end
    end)
end

function ArmorModule:CreateEquipmentSetPopup()
    if not self.equipmentSetPopup then
        return
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    local popupWidth = self.armorFrame:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    local r, g, b, _ = unpack(xb:HoverColors())

    self.equipmentSetOptionString = self.equipmentSetOptionString or self.equipmentSetPopup:CreateFontString(nil, 'OVERLAY')
    self.equipmentSetOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    self.equipmentSetOptionString:SetTextColor(r, g, b, 1)
    self.equipmentSetOptionString:SetText(L["SET_EQUIPMENT_SET"])
    self.equipmentSetOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.equipmentSetOptionString:SetPoint('CENTER')

    for _, button in pairs(self.equipmentSetButtons) do
        button.isSettable = false
        button:Hide()
    end

    local setIDs = {}
    if C_EquipmentSet and C_EquipmentSet.GetEquipmentSetIDs then
        setIDs = C_EquipmentSet.GetEquipmentSetIDs() or {}
    end

    if #setIDs == 0 then
        local button = self.equipmentSetButtons[1]
        if button == nil then
            button = CreateFrame('BUTTON', nil, self.equipmentSetPopup)
            button.text = button:CreateFontString(nil, 'OVERLAY')
            self.equipmentSetButtons[1] = button
        end

        if button.icon then
            button.icon:Hide()
        end

        button.text:SetFont(xb:GetFont(db.text.fontSize))
        button.text:SetTextColor(xb:GetColor('normal'))
        button.text:SetText(L["NO_EQUIPMENT_SETS"])
        button.text:ClearAllPoints()
        button.text:SetPoint('LEFT')
        button:SetSize(button.text:GetStringWidth(), iconSize)
        button:EnableMouse(false)
        button:SetScript('OnEnter', nil)
        button:SetScript('OnLeave', nil)
        button:SetScript('OnClick', nil)
        button.isSettable = true
        button:Show()

        popupWidth = button.text:GetStringWidth()
        changedWidth = true
    else
        for i, setID in ipairs(setIDs) do
            local name, iconFileID, equipmentSetID, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(setID)
            if name then
                local normalR, normalG, normalB = xb:GetColor('normal')
                local button = self.equipmentSetButtons[i]
                if button == nil then
                    button = CreateFrame('BUTTON', nil, self.equipmentSetPopup)
                    button.text = button:CreateFontString(nil, 'OVERLAY')
                    button.icon = button:CreateTexture(nil, 'OVERLAY')
                    self.equipmentSetButtons[i] = button
                end

                button.icon = button.icon or button:CreateTexture(nil, 'OVERLAY')

                button.icon:SetTexture(iconFileID)
                button.icon:SetSize(iconSize, iconSize)
                button.icon:ClearAllPoints()
                button.icon:SetPoint('LEFT')
                button.icon:SetVertexColor(1, 1, 1, 1)
                button.icon:Show()

                button.text:SetFont(xb:GetFont(db.text.fontSize))
                button.text:ClearAllPoints()
                button.text:SetPoint('LEFT', button.icon, 'RIGHT', 5, 0)

                if isEquipped then
                    local activeSetAlpha = 0.7
                    local chevronR = math.min(normalR / activeSetAlpha, 1)
                    local chevronG = math.min(normalG / activeSetAlpha, 1)
                    local chevronB = math.min(normalB / activeSetAlpha, 1)
                    local chevronCode = format(
                        '|c%02X%02X%02X%02X',
                        255,
                        chevronR * 255,
                        chevronG * 255,
                        chevronB * 255
                    )
                    local hoverCode = format(
                        '|c%02X%02X%02X%02X',
                        255,
                        r * 255,
                        g * 255,
                        b * 255
                    )
                    button.text:SetText(
                        chevronCode .. '> |r' .. hoverCode .. name .. '|r' .. chevronCode .. ' <|r'
                    )
                    button.text:SetAlpha(activeSetAlpha)
                    button.icon:SetAlpha(activeSetAlpha)
                    button:EnableMouse(false)
                    button:SetScript('OnEnter', nil)
                    button:SetScript('OnLeave', nil)
                    button:SetScript('OnClick', nil)
                else
                    button.text:SetText(name)
                    button.text:SetTextColor(normalR, normalG, normalB, 1)
                    button.text:SetAlpha(1)
                    button.icon:SetAlpha(1)
                    button:EnableMouse(true)
                    button:RegisterForClicks('AnyUp')

                    button:SetScript('OnEnter', function()
                        button.text:SetTextColor(r, g, b, 1)
                        button.text:SetAlpha(1)
                    end)

                    button:SetScript('OnLeave', function()
                        button.text:SetTextColor(normalR, normalG, normalB, 1)
                        button.text:SetAlpha(1)
                    end)

                    button:SetScript('OnClick', function(clickedButton, mouseButton)
                        if InCombatLockdown() then
                            return
                        end

                        if mouseButton == 'LeftButton' then
                            ArmorModule:BeginEquipmentSetSwap(clickedButton:GetID())
                            C_EquipmentSet.UseEquipmentSet(clickedButton:GetID())
                        end

                        xb:HidePopup(ArmorModule.equipmentSetPopup)
                    end)
                end

                local textWidth = iconSize + 5 + button.text:GetStringWidth()

                button:SetID(equipmentSetID)
                button:SetSize(textWidth, iconSize)
                button.isSettable = true
                button:Show()

                if textWidth > popupWidth then
                    popupWidth = textWidth
                    changedWidth = true
                end
            end
        end
    end

    for _, button in pairs(self.equipmentSetButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        end
    end

    if changedWidth then
        popupWidth = popupWidth + self.extraPadding
    end

    if popupWidth < self.armorFrame:GetWidth() then
        popupWidth = self.armorFrame:GetWidth()
    end

    if popupWidth < (self.equipmentSetOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth = (self.equipmentSetOptionString:GetStringWidth() + self.extraPadding)
    end

    self.equipmentSetPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)
    self.equipmentSetPopup:ClearAllPoints()
    self.equipmentSetPopup:SetPoint(db.general.barPosition, self.armorFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.equipmentSetPopup, "SpecToolTip")
    self.equipmentSetPopup:Hide()
end

function ArmorModule:ShowTooltip()
    if not xb:ShouldShowTooltip() then
        GameTooltip:Hide()
        return
    end

    self:UpdateDurabilityText()

    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:SetOwner(self.armorFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. AUCTION_CATEGORY_ARMOR .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")

    if compat.isMainline then
        self:BuildTooltipMainline(r, g, b)
    else
        self:BuildTooltipClassic(r, g, b)
    end

    local currentSetName, currentSetIcon = self:GetCurrentEquipmentSet()
    if currentSetName then
        GameTooltip:AddLine(" ")
        local setLabel = "|cFFFFFFFF" .. currentSetName .. "|r"
        if currentSetIcon then
            setLabel = format("|T%d:14:14:0:0|t ", currentSetIcon) .. setLabel
        end
        GameTooltip:AddDoubleLine(
            L["CURRENT_EQUIPMENT_SET"],
            setLabel,
            r, g, b, 1, 1, 1
        )
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', L["SET_EQUIPMENT_SET"], r, g, b, 1, 1, 1)
    GameTooltip:Show()
end

function ArmorModule:BuildTooltipMainline(r, g, b)
    for _, slotId in ipairs(self.slotOrder) do
        local v = self.durabilityList[slotId]
        if v.max and v.max > 0 then
            local u20G, u20B = 1, 1
            if v.pc <= 20 then
                u20G, u20B = 0, 0
            end
            GameTooltip:AddDoubleLine(v.text, string.format('%d/%d (%d%%)', v.cur, v.max, v.pc), r, g, b, 1, u20G, u20B)
        end
    end
end

function ArmorModule:BuildTooltipClassic(r, g, b)
    for _, slotId in ipairs(self.slotOrder) do
        local v = self.durabilityList[slotId]
        if v.max and v.max > 0 then
            local u20G, u20B = 1, 1
            if v.pc <= 20 then
                u20G, u20B = 0, 0
            end

            local texture = GetInventoryItemTexture('player', slotId)
            local link = GetInventoryItemLink('player', slotId)
            local leftText = v.text
            if link then
                leftText = format('|T%s:14:14:0:0:64:64:4:60:4:60|t %s', texture or '', link)
            end

            GameTooltip:AddDoubleLine(leftText, string.format('%d/%d (%d%%)', v.cur, v.max, v.pc), r, g, b, 1, u20G, u20B)
        end
    end
end

function ArmorModule:RegisterCoordTicker()
    if xb.db.profile.modules.armor.showCoords then
        self.coordTicker = C_Timer.NewTicker(0.2, function()
            if InCombatLockdown() then
                return
            end
            self:UpdatePlayerCoordinates()
        end)
    end
end

function ArmorModule:SetArmorColor()
    local db = xb.db.profile
    local equipmentSetPopupVisible = self.equipmentSetPopup and self.equipmentSetPopup:IsVisible()
    if self.armorButton:IsMouseOver() and not equipmentSetPopupVisible then
        self.armorText:SetTextColor(unpack(xb:HoverColors()))
        self.coordText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.armorText:SetTextColor(xb:GetColor('normal'))
        self.coordText:SetTextColor(xb:GetColor('normal'))
        if self.durabilityLowest and self.durabilityLowest <= db.modules.armor.warningDurability then
            self.armorIcon:SetVertexColor(1, 0, 0, 1)
        else
            self.armorIcon:SetVertexColor(xb:GetColor('normal'))
        end
    end
end

function ArmorModule:Refresh()
    if self.armorFrame == nil then
        return
    end
    local db = xb.db.profile.modules.armor
    if not db.enabled then
        self:Disable()
        return
    end

    if InCombatLockdown() then
        self:UpdateDurabilityText()
        return
    end

    local iconSize = xb:GetHeight()
    self.armorIcon:SetTexture(self.iconPath)
    self.armorIcon:SetPoint('LEFT')

    self.armorText:SetFont(xb:GetFont(xb.db.profile.text.fontSize))
    self:UpdateDurabilityText()
    self.armorText:SetPoint('LEFT', self.armorIcon, 'RIGHT', 5, 0)

    self.coordText:SetFont(xb:GetFont(xb.db.profile.text.fontSize))
    self.coordText:SetPoint('LEFT', self.armorText, 'RIGHT', 5, 0)

    if self.coordTicker then
        if self.coordTicker:IsCancelled() and db.showCoords then
            self:RegisterCoordTicker()
        end
    elseif db.showCoords then
        self:RegisterCoordTicker()
    end

    self.armorFrame:SetSize(5 + iconSize + self.armorText:GetStringWidth() + self.coordText:GetStringWidth(),
        xb:GetHeight())

    self.armorButton:SetAllPoints()

    if xb:ApplyModuleFreePlacement('armor', self.armorFrame) then
        self:SetArmorColor()
        return
    end

    local relativeAnchorPoint = 'RIGHT'
    local xOffset = xb.db.profile.general.moduleSpacing

    local parentFrame = xb:GetFrame('microMenuFrame')
    if not xb.db.profile.modules.microMenu.enabled then
        parentFrame = self.armorFrame:GetParent()
        relativeAnchorPoint = 'LEFT'
        xOffset = 0
    end

    self.armorFrame:ClearAllPoints()
    self.armorFrame:SetPoint('LEFT', parentFrame, relativeAnchorPoint, xOffset, 0)
    self:SetArmorColor()
end

function ArmorModule:UPDATE_INVENTORY_DURABILITY()
    if not self:IsEnabled() then
        return
    end

    self:UpdateDurabilityText()
    self:SetArmorColor()

    if GameTooltip:IsOwned(self.armorFrame) then
        self:ShowTooltip()
    end
end

function ArmorModule:UpdateDurabilityText()
    local db = xb.db.profile.modules.armor
    local text = ''
    local lowest = 101

    for _, slotId in ipairs(self.slotOrder) do
        local curDur, maxDur = self:GetSlotDurability(slotId)
        local v = self.durabilityList[slotId]
        if curDur and maxDur and maxDur > 0 then
            v.cur = curDur
            v.max = maxDur
            v.pc = math.floor((curDur / maxDur) * 100)
            if v.pc < lowest then
                lowest = v.pc
            end
        else
            v.cur = 0
            v.max = 0
            v.pc = 101
        end
    end

    if lowest <= 100 then
        self.durabilityLowest = lowest
    else
        self.durabilityLowest = nil
    end

    if self.durabilityLowest then
        if self.durabilityLowest <= db.warningDurability then
            text = '|cFFFF0000' .. self.durabilityLowest .. '%|r'
        else
            text = self.durabilityLowest .. '%'
        end
    end

    if db.showIlvl and _G.GetAverageItemLevel then
        local _, equippedIlvl = GetAverageItemLevel()
        local ilvlText = math.floor(equippedIlvl) .. ' ilvl'
        if text ~= '' then
            text = text .. ' ' .. ilvlText
        else
            text = ilvlText
        end
    end

    self.armorText:SetText(text)
end

function ArmorModule:UpdatePlayerCoordinates()
    if not xb.db.profile.modules.armor.showCoords then
        if self.coordTicker then
            self.coordTicker:Cancel()
        end
        self.coordText:Hide()
        return
    end

    if IsInInstance and IsInInstance() then
        self.coordText:Hide()
        return
    end

    self.coordText:Show()
    local map_id = C_Map.GetBestMapForUnit('player')
    if not map_id then
        return
    end

    local rects = self.MapRects[map_id]
    if not rects then
        local _, topleft = C_Map.GetWorldPosFromMapPos(map_id, CreateVector2D(0, 0))
        local _, bottomright = C_Map.GetWorldPosFromMapPos(map_id, CreateVector2D(1, 1))
        bottomright:Subtract(topleft)
        rects = {topleft.x, topleft.y, bottomright.x, bottomright.y}
        self.MapRects[map_id] = rects
    end

    local x, y = UnitPosition('player')
    if not x then
        return
    end
    x = floor(((x - rects[1]) / rects[3]) * 10000) / 100
    y = floor(((y - rects[2]) / rects[4]) * 10000) / 100

    self.coordText:SetText(y .. ', ' .. x)
end

function ArmorModule:GetDefaultOptions()
    return 'armor', {
        enabled = true,
        warningDurability = 20,
        showIlvl = true,
        showCoords = false
    }
end

function ArmorModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.armor.enabled
                end,
                set = function(_, val)
                    xb.db.profile.modules.armor.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                        xb:Refresh()
                    end
                end
            },
            duraMin = {
                name = L["DURABILITY_WARNING_THRESHOLD"],
                type = 'range',
                order = 1,
                min = 0,
                max = 100,
                step = 5,
                get = function()
                    return xb.db.profile.modules.armor.warningDurability
                end,
                set = function(_, val)
                    xb.db.profile.modules.armor.warningDurability = val
                    self:Refresh()
                end
            },
            ilvlShow = {
                name = L["SHOW_ITEM_LEVEL"],
                type = 'toggle',
                order = 2,
                get = function()
                    return xb.db.profile.modules.armor.showIlvl
                end,
                set = function(_, val)
                    xb.db.profile.modules.armor.showIlvl = val
                    self:Refresh()
                end
            },
            coordsShow = {
                name = L["SHOW_COORDINATES"],
                type = 'toggle',
                order = 3,
                get = function()
                    return xb.db.profile.modules.armor.showCoords
                end,
                set = function(_, val)
                    xb.db.profile.modules.armor.showCoords = val
                    self:Refresh()
                end
            }
        }
    }
end
