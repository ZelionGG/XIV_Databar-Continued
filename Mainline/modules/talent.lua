---@class XIVBar
local XIVBar = select(2, ...);
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local C_ClassTalents = C_ClassTalents;
local C_Traits = C_Traits;

local TalentModule = xb:NewModule("TalentModule", 'AceEvent-3.0')
local GetSpecializationInfo = GetSpecializationInfo;
local GetSpecialization = GetSpecialization;

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function TalentModule:GetName()
    return TALENTS;
end

function TalentModule:dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. self:dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- Skin Support for ElvUI/TukUI
-- Make sure to disable "Tooltip" in the Skins section of ElvUI together with
-- unchecking "Use ElvUI for tooltips" in XIV options to not have ElvUI fuck with tooltips
function TalentModule:SkinFrame(frame, name)
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

function TalentModule:OnInitialize()
    self.currentSpecID = 0
    self.currentLootSpecID = 0
    self.loadoutName = ''
    self.specCoords = {
        [1] = {0.00, 0.25, 0, 1},
        [2] = {0.25, 0.50, 0, 1},
        [3] = {0.50, 0.75, 0, 1},
        [4] = {0.75, 1.00, 0, 1}
    }
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
    self.loadoutButtons = {}
    self.specButtons = {}
    self.lootSpecButtons = {}
    self.classIcon = xb.constants.mediaPath .. 'spec\\' .. xb.constants.playerClass
    self.useElvUI = xb.db.profile.general.useElvUI and (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui'))
end

function TalentModule:OnEnable()
    if not xb.db.profile.modules.talent.enabled then
        self:Disable()
        return
    end
    self.currentSpecID = GetSpecialization() -- returns 5 for newly created characters in shadowlands
    if self.currentSpecID == 5 then
        self:Disable()
        return
    end
    self.currentLootSpecID = GetLootSpecialization()
    if self.talentFrame == nil then
        self.talentFrame = CreateFrame("FRAME", "talentFrame", xb:GetFrame('bar'))
        xb:RegisterFrame('talentFrame', self.talentFrame)
    end
    self.talentFrame:Show()

    if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
        self.loadoutName = self:GetCurrentLoadoutName()
        self:CreateLoadoutFrames()
    end
    self:CreateTalentFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function TalentModule:OnDisable()
    if self.talentFrame and self.talentFrame:IsVisible() then
        self.talentFrame:Hide()
    end
    self:UnregisterEvent('TRADE_SKILL_UPDATE')
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('UNIT_SPELLCAST_STOP')
    self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    self:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
    self:UnregisterEvent('PLAYER_LOOT_SPEC_UPDATED')
end

function TalentModule:EnableTalentLoadout()
    self:CreateLoadoutFrames()
    self:Refresh()
    self.loadoutFrame:Show()
end

function TalentModule:DisableTalentLoadout()
    if self.loadoutFrame and self.loadoutFrame:IsVisible() then
        self.loadoutFrame:Hide()
    end
end

function TalentModule:GetCurrentLoadoutName()
    local curSpecID = select(1, GetSpecializationInfo(self.currentSpecID))

    local configs = C_ClassTalents.GetConfigIDsBySpecID(curSpecID);
    local total = #configs;
    local loadoutName;

    if total == 0 then
        self.loadoutName = TALENT_FRAME_DROP_DOWN_DEFAULT;
    else
        local selectedID = C_ClassTalents.GetLastSelectedSavedConfigID(curSpecID);
        if selectedID then
            local info = C_Traits.GetConfigInfo(selectedID);
            loadoutName = info and info.name;
        end

        if loadoutName then
            self.loadoutName = loadoutName
        end
    end
end

function TalentModule:Refresh()
    if not self.talentFrame then return end

    local db = xb.db.profile
    if not db.modules.talent.enabled then
        self:Disable()
        return
    end

    self.currentSpecID = GetSpecialization() or 1
    self.currentLootSpecID = GetLootSpecialization() or 0

    local iconSize = db.text.fontSize + db.general.barPadding
    local _, name = GetSpecializationInfo(self.currentSpecID)
    local textHeight = db.text.fontSize

    if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
        self:GetCurrentLoadoutName()

        -- LOADOUT
        self.loadoutText:SetFont(xb:GetFont(textHeight))
        self.loadoutText:SetTextColor(xb:GetColor('normal'))
        self.loadoutText:SetText(self.loadoutName or "")

        self.loadoutText:ClearAllPoints()
        self.loadoutText:SetPoint('LEFT')

        self.loadoutText:Show()

        if not InCombatLockdown() then
            self.loadoutFrame:SetSize(iconSize + self.loadoutText:GetWidth() + 5, xb:GetHeight())
            self.loadoutFrame:ClearAllPoints()
            self.loadoutFrame:SetPoint('LEFT')

            if self.loadoutFrame:GetWidth() < db.modules.talent.minWidth then
                self.loadoutFrame:SetWidth(db.modules.talent.minWidth)
            end

            self.loadoutFrame:SetSize(self.loadoutFrame:GetWidth(), xb:GetHeight())
        end
    end

    -- TALENTS
    self.specIcon:SetTexture(self.classIcon)
    self.specIcon:SetTexCoord(unpack(self.specCoords[self.currentSpecID]))

    self.specIcon:SetSize(iconSize, iconSize)
    self.specIcon:ClearAllPoints()
    self.specIcon:SetPoint('LEFT')
    self.specIcon:SetVertexColor(xb:GetColor('normal'))

    self.specText:SetFont(xb:GetFont(textHeight))
    self.specText:SetTextColor(xb:GetColor('normal'))
    self.specText:SetText(string.upper(name or ""))

    self.specText:ClearAllPoints()
    self.specText:SetPoint('LEFT', self.specIcon, 'RIGHT', 5, 0)

    self.lootSpecButtons[0].icon:SetTexture(self.classIcon)
    self.lootSpecButtons[0].icon:SetTexCoord(unpack(self.specCoords[self.currentSpecID]))

    self.specText:Show()

    if not InCombatLockdown() then
        self.specFrame:SetSize(iconSize + self.specText:GetWidth() + 5, xb:GetHeight())
        if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
            self.specFrame:ClearAllPoints()
            self.specFrame:SetPoint('LEFT', self.loadoutFrame, 'RIGHT', 0, 0)
        else
            self.specFrame:ClearAllPoints()
            self.specFrame:SetPoint('LEFT')
        end

        if self.specFrame:GetWidth() < db.modules.talent.minWidth then
            self.specFrame:SetWidth(db.modules.talent.minWidth)
        end

        if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
            self.talentFrame:SetSize(self.loadoutFrame:GetWidth() + self.specFrame:GetWidth(), xb:GetHeight())
        else
            self.talentFrame:SetSize(self.specFrame:GetWidth(), xb:GetHeight())
        end

        if xb:ApplyModuleFreePlacement('talent', self.talentFrame) then
            self:CreateLoadoutPopup()
            self:CreateSpecPopup()
            self:CreateLootSpecPopup()
            return
        end

        local relativeAnchorPoint = 'LEFT'
        local xOffset = db.general.moduleSpacing
        local anchorFrame = xb:GetFrame('clockFrame')

        if anchorFrame and anchorFrame:IsVisible() then
            self.talentFrame:ClearAllPoints()
            self.talentFrame:SetPoint('RIGHT', anchorFrame, relativeAnchorPoint, -(xOffset), 0)
        else
            local tradeskillFrame = xb:GetFrame('tradeskillFrame')
            local currencyFrame = xb:GetFrame('currencyFrame')

            if tradeskillFrame and tradeskillFrame:IsVisible() then
                anchorFrame = tradeskillFrame
            elseif currencyFrame and currencyFrame:IsVisible() then
                anchorFrame = currencyFrame
            else
                relativeAnchorPoint = 'RIGHT'
                xOffset = 0
                anchorFrame = xb:GetFrame('bar')
            end

            self.talentFrame:ClearAllPoints()
            self.talentFrame:SetPoint('RIGHT', anchorFrame, relativeAnchorPoint, -(xOffset), 0)
        end
    end

    self:CreateLoadoutPopup()
    self:CreateSpecPopup()
    self:CreateLootSpecPopup()
end

function TalentModule:CreateLoadoutFrames()
    self.loadoutFrame = self.loadoutFrame or CreateFrame('BUTTON', nil, self.talentFrame)
    self.loadoutIcon = self.loadoutIcon or self.loadoutFrame:CreateTexture(nil, 'OVERLAY')
    self.loadoutText = self.loadoutText or self.loadoutFrame:CreateFontString(nil, 'OVERLAY')

    local template = (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
                         (BackdropTemplateMixin and "BackdropTemplate")
    self.loadoutPopup = self.loadoutPopup or CreateFrame('BUTTON', 'loadoutPopup', self.loadoutFrame, template)
    self.loadoutPopup:SetFrameStrata('TOOLTIP')
    xb:RegisterMouseoverHoldFrame(self.loadoutPopup, true)

    if TooltipBackdropTemplateMixin then
        self.loadoutPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.loadoutPopup.NineSlice)

        if GameTooltip.layoutType then
            self.loadoutPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
            self.loadoutPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
        end
    else
        local backdrop = GameTooltip:GetBackdrop()
        if backdrop and (not self.useElvUI) then
            self.loadoutPopup:SetBackdrop(backdrop)
            self.loadoutPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
            self.loadoutPopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
        end
    end
end

function TalentModule:CreateTalentFrames()
    self.specFrame = self.specFrame or CreateFrame('BUTTON', nil, self.talentFrame)
    self.specIcon = self.specIcon or self.specFrame:CreateTexture(nil, 'OVERLAY')
    self.specText = self.specText or self.specFrame:CreateFontString(nil, 'OVERLAY')

    local template = (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
                         (BackdropTemplateMixin and "BackdropTemplate")
    self.specPopup = self.specPopup or CreateFrame('BUTTON', 'SpecPopup', self.specFrame, template)
    self.specPopup:SetFrameStrata('TOOLTIP')
    self.lootSpecPopup = self.lootSpecPopup or CreateFrame('BUTTON', 'LootPopup', self.specFrame, template)
    self.lootSpecPopup:SetFrameStrata('TOOLTIP')
    xb:RegisterMouseoverHoldFrame(self.specPopup, true)
    xb:RegisterMouseoverHoldFrame(self.lootSpecPopup, true)

    if TooltipBackdropTemplateMixin then
        self.specPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.specPopup.NineSlice)

        self.lootSpecPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.lootSpecPopup.NineSlice)

        if GameTooltip.layoutType then
            self.specPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
            self.specPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())

            self.lootSpecPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
            self.lootSpecPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
        end
    end

    self:CreateSpecPopup()
    self:CreateLootSpecPopup()
end

function TalentModule:RegisterFrameEvents()
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'Refresh')
    self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'Refresh')
    self:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED', 'Refresh')
    self:RegisterEvent('TRAIT_CONFIG_UPDATED', 'Refresh');
    self:RegisterEvent('TRAIT_CONFIG_LIST_UPDATED', 'Refresh');
    self:RegisterEvent('TRAIT_CONFIG_DELETED', 'Refresh');
    self:RegisterEvent('TRAIT_CONFIG_CREATED', 'Refresh');
    self:RegisterEvent('CONFIG_COMMIT_FAILED', 'Refresh');
    self:RegisterEvent('ACTIVE_COMBAT_CONFIG_CHANGED', 'Refresh');

    self.specFrame:EnableMouse(true)
    self.specFrame:RegisterForClicks('AnyUp')

    if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
        self.loadoutFrame:EnableMouse(true)
        self.loadoutFrame:RegisterForClicks('AnyUp')

        -- LOADOUTS
        self.loadoutFrame:SetScript('OnEnter', function()
            if InCombatLockdown() then
                return
            end
            self.loadoutText:SetTextColor(unpack(xb:HoverColors()))
            if xb.db.profile.modules.talent.showTooltip then
                if (not self.loadoutPopup:IsVisible()) then
                    self:ShowTooltip()
                end
            end
        end)

        self.loadoutFrame:SetScript('OnLeave', function()
            if InCombatLockdown() then
                return
            end
            self.loadoutText:SetTextColor(xb:GetColor('normal'))
            if xb.db.profile.modules.talent.showTooltip then
                GameTooltip:Hide()
            end
        end)

        self.loadoutFrame:SetScript('OnClick', function(_, button)
            GameTooltip:Hide()

            if InCombatLockdown() then
                return
            end

            if button == 'LeftButton' then
                if not self.loadoutPopup:IsVisible() then
                    self:CreateLoadoutPopup()
                    xb:ShowPopup(self.loadoutPopup)
                    xb:HidePopup(self.specPopup)
                    xb:HidePopup(self.lootSpecPopup)
                else
                    xb:HidePopup(self.loadoutPopup)
                    if xb.db.profile.modules.talent.showTooltip then
                        self:ShowTooltip()
                    end
                end
            end
        end)
    end

    -- TALENTS
    self.specFrame:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return
        end
        self.specText:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.talent.showTooltip then
            if (not self.specPopup:IsVisible()) or (not self.lootSpecPopup:IsVisible()) then
                self:ShowTooltip()
            end
        end
    end)

    self.specFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return
        end
        self.specText:SetTextColor(xb:GetColor('normal'))
        if xb.db.profile.modules.talent.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self.specFrame:SetScript('OnClick', function(_, button)
        GameTooltip:Hide()

        if InCombatLockdown() then
            return
        end

        if button == 'LeftButton' then
            if not self.specPopup:IsVisible() then
                xb:HidePopup(self.lootSpecPopup)
                self:CreateSpecPopup()
                xb:ShowPopup(self.specPopup)
                if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
                    xb:HidePopup(self.loadoutPopup)
                end
            else
                xb:HidePopup(self.specPopup)
                if xb.db.profile.modules.talent.showTooltip then
                    self:ShowTooltip()
                end
            end
        elseif button == 'RightButton' then
            if not self.lootSpecPopup:IsVisible() then
                xb:HidePopup(self.specPopup)
                if (xb.db.profile.modules.talent.loadoutSwitcherEnabled) then
                    xb:HidePopup(self.loadoutPopup)
                end
                self:CreateLootSpecPopup()
                xb:ShowPopup(self.lootSpecPopup)
            else
                xb:HidePopup(self.lootSpecPopup)
                if xb.db.profile.modules.talent.showTooltip then
                    self:ShowTooltip()
                end
            end
        end
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'clockFrame' then
            self:Refresh()
        end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'clockFrame' then
            self:Refresh()
        end
    end)
end

function TalentModule:CreateLoadoutPopup()
    if not self.loadoutPopup then
        return;
    end

    local curSpecID = select(1, GetSpecializationInfo(self.currentSpecID))

    local configs = C_ClassTalents.GetConfigIDsBySpecID(curSpecID);
    local total = #configs;
    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.loadoutOptionString = self.loadoutOptionString or self.loadoutPopup:CreateFontString(nil, 'OVERLAY')
    self.loadoutOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.loadoutOptionString:SetTextColor(r, g, b, 1)
    self.loadoutOptionString:SetText(L["SET_LOADOUT"])
    self.loadoutOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.loadoutOptionString:SetPoint('CENTER')

    local popupWidth = self.loadoutPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    for i = 1, total do
        if self.loadoutButtons[i] == nil then
            local configInfo = C_Traits.GetConfigInfo(configs[i])
            local loadoutID = configInfo.ID
            local configName = configInfo.name

            local button = CreateFrame('BUTTON', nil, self.loadoutPopup)
            local buttonText = button:CreateFontString(nil, 'OVERLAY')

            buttonText:SetFont(xb:GetFont(db.text.fontSize))
            buttonText:SetTextColor(xb:GetColor('normal'))
            buttonText:SetText(configName)
            buttonText:SetPoint('LEFT')
            local textWidth = iconSize + 5 + buttonText:GetStringWidth()

            button:SetID(loadoutID)
            button:SetSize(textWidth, iconSize)
            button.isSettable = true

            button:EnableMouse(true)
            button:RegisterForClicks('AnyUp')

            button:SetScript('OnEnter', function()
                buttonText:SetTextColor(r, g, b, 1)
            end)

            button:SetScript('OnLeave', function()
                buttonText:SetTextColor(xb:GetColor('normal'))
            end)

            button:SetScript('OnClick', function(clickedButton, mouseButton)
                if InCombatLockdown() then
                    return;
                end
                if mouseButton == 'LeftButton' then
                    local autoApply = true;
                    local result = C_ClassTalents.LoadConfig(clickedButton:GetID(), autoApply)
                    if result ~= 0 then
                        C_ClassTalents.UpdateLastSelectedSavedConfigID(curSpecID, clickedButton:GetID());
                    end
                end
                TalentModule.loadoutPopup:Hide()
            end)

            self.loadoutButtons[i] = button

            if textWidth > popupWidth then
                popupWidth = textWidth
                changedWidth = true
            end
        end -- if nil
    end -- for ipairs portOptions
    for _, button in pairs(self.loadoutButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end -- for id/button in portButtons
    if changedWidth then
        popupWidth = popupWidth + self.extraPadding
    end

    if popupWidth < self.loadoutFrame:GetWidth() then
        popupWidth = self.loadoutFrame:GetWidth()
    end

    if popupWidth < (self.loadoutOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth = (self.loadoutOptionString:GetStringWidth() + self.extraPadding)
    end
    self.loadoutPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)

    self.loadoutPopup:ClearAllPoints()
    self.loadoutPopup:SetPoint(db.general.barPosition, self.loadoutFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.loadoutPopup, "SpecToolTip")
    self.loadoutPopup:Hide()
end

function TalentModule:CreateSpecPopup()
    if not self.specPopup then
        return;
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.specOptionString = self.specOptionString or self.specPopup:CreateFontString(nil, 'OVERLAY')
    self.specOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.specOptionString:SetTextColor(r, g, b, 1)
    self.specOptionString:SetText(L["SET_SPECIALIZATION"])
    self.specOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.specOptionString:SetPoint('CENTER')

    local popupWidth = self.specPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    for i = 1, GetNumSpecializations() do
        if self.specButtons[i] == nil then

            local _, name, _ = GetSpecializationInfo(i)
            local button = CreateFrame('BUTTON', nil, self.specPopup)
            local buttonText = button:CreateFontString(nil, 'OVERLAY')
            local buttonIcon = button:CreateTexture(nil, 'OVERLAY')

            buttonIcon:SetTexture(self.classIcon)
            buttonIcon:SetTexCoord(unpack(self.specCoords[i]))
            buttonIcon:SetSize(iconSize, iconSize)
            buttonIcon:SetPoint('LEFT')
            buttonIcon:SetVertexColor(xb:GetColor('normal'))

            buttonText:SetFont(xb:GetFont(db.text.fontSize))
            buttonText:SetTextColor(xb:GetColor('normal'))
            buttonText:SetText(name)
            buttonText:SetPoint('LEFT', buttonIcon, 'RIGHT', 5, 0)
            local textWidth = iconSize + 5 + buttonText:GetStringWidth()

            button:SetID(i)
            button:SetSize(textWidth, iconSize)
            button.isSettable = true

            button:EnableMouse(true)
            button:RegisterForClicks('AnyUp')

            button:SetScript('OnEnter', function()
                buttonText:SetTextColor(r, g, b, 1)
            end)

            button:SetScript('OnLeave', function()
                buttonText:SetTextColor(xb:GetColor('normal'))
            end)

            button:SetScript('OnClick', function(clickedButton, mouseButton)
                if InCombatLockdown() then
                    return;
                end
                if mouseButton == 'LeftButton' then
                    C_SpecializationInfo.SetSpecialization(clickedButton:GetID())
                end
                TalentModule.specPopup:Hide()
            end)

            self.specButtons[i] = button

            if textWidth > popupWidth then
                popupWidth = textWidth
                changedWidth = true
            end
        end -- if nil
    end -- for ipairs portOptions
    for _, button in pairs(self.specButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end -- for id/button in portButtons
    if changedWidth then
        popupWidth = popupWidth + self.extraPadding
    end

    if popupWidth < self.specFrame:GetWidth() then
        popupWidth = self.specFrame:GetWidth()
    end

    if popupWidth < (self.specOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth = (self.specOptionString:GetStringWidth() + self.extraPadding)
    end
    self.specPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)

    self.specPopup:ClearAllPoints()
    self.specPopup:SetPoint(db.general.barPosition, self.specFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.specPopup, "SpecToolTip")
    self.specPopup:Hide()
end

function TalentModule:CreateLootSpecPopup()
    if not self.lootSpecPopup then
        return;
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.lootSpecOptionString = self.lootSpecOptionString or self.lootSpecPopup:CreateFontString(nil, 'OVERLAY')
    self.lootSpecOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.lootSpecOptionString:SetTextColor(r, g, b, 1)
    self.lootSpecOptionString:SetText(tostring(L["SET_LOOT_SPECIALIZATION"]))
    self.lootSpecOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.lootSpecOptionString:SetPoint('CENTER')

    local popupWidth = self.lootSpecPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    for i = 0, GetNumSpecializations() do
        if self.lootSpecButtons[i] == nil then
            local specId = i
            local name
            if i == 0 then
                name = L["CURRENT_SPECIALIZATION"];
                specId = self.currentSpecID
            else
                local _, specName, _ = GetSpecializationInfo(i)
                name = specName
            end
            local button = CreateFrame('BUTTON', nil, self.lootSpecPopup)
            local buttonText = button:CreateFontString(nil, 'OVERLAY')
            local buttonIcon = button:CreateTexture(nil, 'OVERLAY')

            buttonIcon:SetTexture(self.classIcon)
            local coords = self.specCoords[specId] or self.specCoords[self.currentSpecID] or self.specCoords[1]
            buttonIcon:SetTexCoord(unpack(coords))
            buttonIcon:SetSize(iconSize, iconSize)
            buttonIcon:SetPoint('LEFT')
            buttonIcon:SetVertexColor(xb:GetColor('normal'))

            buttonText:SetFont(xb:GetFont(db.text.fontSize))
            buttonText:SetTextColor(xb:GetColor('normal'))
            buttonText:SetText(name)
            buttonText:SetPoint('LEFT', buttonIcon, 'RIGHT', 5, 0)
            local textWidth = iconSize + 5 + buttonText:GetStringWidth()

            button:SetID(i)
            button:SetSize(textWidth, iconSize)
            button.isSettable = true
            button.text = buttonText
            button.icon = buttonIcon

            button:EnableMouse(true)
            button:RegisterForClicks('AnyUp')

            button:SetScript('OnEnter', function()
                buttonText:SetTextColor(r, g, b, 1)
            end)

            button:SetScript('OnLeave', function()
                buttonText:SetTextColor(xb:GetColor('normal'))
            end)

            button:SetScript('OnClick', function(clickedButton, mouseButton)
                if InCombatLockdown() then
                    return;
                end
                if mouseButton == 'LeftButton' then
                    local id = 0
                    if clickedButton:GetID() ~= 0 then
                        id = select(1, GetSpecializationInfo(clickedButton:GetID()))
                    else
                        local currentSpecIndex = GetSpecialization()
                        if currentSpecIndex then
                            id = select(1, GetSpecializationInfo(currentSpecIndex))
                        end
                    end
                    SetLootSpecialization(id or 0)
                end
                TalentModule.lootSpecPopup:Hide()
            end)

            self.lootSpecButtons[i] = button

            if textWidth > popupWidth then
                popupWidth = textWidth
                changedWidth = true
            end
        end -- if nil
    end -- for ipairs portOptions
    for _, button in pairs(self.lootSpecButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end -- for id/button in portButtons
    if changedWidth then
        popupWidth = popupWidth + self.extraPadding
    end

    if popupWidth < self.specFrame:GetWidth() then
        popupWidth = self.specFrame:GetWidth()
    end

    if popupWidth < (self.lootSpecOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth = (self.lootSpecOptionString:GetStringWidth() + self.extraPadding)
    end
    self.lootSpecPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)

    self.lootSpecPopup:ClearAllPoints()
    self.lootSpecPopup:SetPoint(db.general.barPosition, self.specFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.lootSpecPopup, "LootSpecToolTip")
    self.lootSpecPopup:Hide()
end

function TalentModule:ShowTooltip()
    local r, g, b, _ = unpack(xb:HoverColors())
    local name

    if self.currentLootSpecID == 0 then
        local _, specName = GetSpecializationInfo(self.currentSpecID)
        name = specName or ''
    else
        local _, specName = GetSpecializationInfoByID(self.currentLootSpecID)
        name = specName or ''
    end

    GameTooltip:SetOwner(self.talentFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. SPECIALIZATION .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["CURRENT_LOOT_SPECIALIZATION"], "|cFFFFFFFF" .. name .. "|r", r, g, b, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', L["SET_SPECIALIZATION"], r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine('<' .. L["RIGHT_CLICK"] .. '>', L["SET_LOOT_SPECIALIZATION"], r, g, b, 1, 1, 1)
    GameTooltip:Show()
end

function TalentModule:GetDefaultOptions()
    return 'talent', {
        enabled = true,
        enableLoadoutSwitcher = true,
        showTooltip = true,
        minWidth = 50
    }
end

function TalentModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.talent.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.talent.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end
            },
            enableLoadoutSwitcher = {
                name = L["ENABLE_LOADOUT_SWITCHER"],
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.talent.loadoutSwitcherEnabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.talent.loadoutSwitcherEnabled = val
                    if val then
                        self:EnableTalentLoadout()
                    else
                        self:DisableTalentLoadout()
                    end
                end
            },
            showTooltip = {
                name = L["SHOW_TOOLTIPS"],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.talent.showTooltip;
                end,
                set = function(_, val)
                    xb.db.profile.modules.talent.showTooltip = val;
                    self:Refresh();
                end
            },
            minWidth = {
                name = L["TALENT_MINIMUM_WIDTH"],
                type = 'range',
                order = 3,
                min = 10,
                max = 200,
                step = 10,
                get = function()
                    return xb.db.profile.modules.talent.minWidth;
                end,
                set = function(info, val)
                    xb.db.profile.modules.talent.minWidth = val;
                    self:Refresh();
                end
            }
        }
    }
end
