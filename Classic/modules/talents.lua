local AddOnName, XIVBar = ...
local _G = _G
local xb = XIVBar
local L = XIVBar.L
local compat = XIVBar.compat or {}

local TalentModule = xb:NewModule("TalentModule", 'AceEvent-3.0')
local GetSpecializationInfo = GetSpecializationInfo or GetTalentTabInfo
local GetSpecialization = GetSpecialization or GetPrimaryTalentTree

local IsAddOnLoaded = (compat and compat.IsAddOnLoaded) or (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded
local isVanilla = compat.isClassicOrTBC
local isProgression = compat.isClassicProgression

function TalentModule:GetName()
    return TALENTS
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
            if ElvUI then
                ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
            end

            if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
                Tukui[1].SkinCloseButton(close)
            end
            close:SetAlpha(1)
        end
    end
end

function TalentModule:OnInitialize()
    self.LTip = LibStub('LibQTip-1.0')
    self.currentSpecID = 0
    self.currentLootSpecID = 0
    self.specCoords = {
        [1] = {0.00, 0.25, 0, 1},
        [2] = {0.25, 0.50, 0, 1},
        [3] = {0.50, 0.75, 0, 1},
        [4] = {0.75, 1.00, 0, 1}
    }
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
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

    if isVanilla then
        local highestPoints = 0
        for i = 1, GetNumTalentTabs() do
            local _, _, _, _, pointsSpent = GetTalentTabInfo(i)
            if pointsSpent > highestPoints then
                highestPoints = pointsSpent
                self.currentSpecID = i
            end
        end
    else
        self.currentSpecID = GetSpecialization()
        self.currentLootSpecID = GetLootSpecialization()
    end

    if self.currentSpecID == 5 then
        self:Disable()
        return
    end

    if self.talentFrame == nil then
        self.talentFrame = CreateFrame("FRAME", "talentFrame", xb:GetFrame('bar'))
        xb:RegisterFrame('talentFrame', self.talentFrame)
    end
    self.talentFrame:Show()

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

    if isVanilla then
        self:UnregisterEvent('ACTIVE_PLAYER_SPECIALIZATION_CHANGED')
        self:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
        self:UnregisterEvent('CONFIRM_TALENT_WIPE')
        self:UnregisterEvent('PLAYER_TALENT_UPDATE')
    else
        self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
        self:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
        self:UnregisterEvent('PLAYER_LOOT_SPEC_UPDATED')
    end
end

local function GetVanillaActiveSpec()
    local active = GetActiveTalentGroup()
    local highestPoints1, name1, activeTab1 = 0, "", 1
    local highestPoints2, name2, activeTab2 = 0, "", 1

    local numSpecs = GetNumTalentGroups()

    for i = 1, GetNumTalentTabs() do
        local tabID, _, _, _, pointsSpent = GetTalentTabInfo(i, false, false, 1)
        local _, name = GetSpecializationInfoForSpecID(tabID)
        pointsSpent = tonumber(pointsSpent) or 0
        if pointsSpent > highestPoints1 then
            highestPoints1 = pointsSpent
            name1 = name or "Unknown"
            activeTab1 = i
        end
    end

    if numSpecs > 1 then
        for i = 1, GetNumTalentTabs() do
            local tabID, _, _, _, pointsSpent = GetTalentTabInfo(i, false, false, 2)
            local _, name = GetSpecializationInfoForSpecID(tabID)
            pointsSpent = tonumber(pointsSpent) or 0
            if pointsSpent > highestPoints2 then
                highestPoints2 = pointsSpent
                name2 = name or "Unknown"
                activeTab2 = i
            end
        end
    end

    local name = "Not set"
    local activeTab = 1
    if active == 1 and highestPoints1 > 0 then
        name = name1
        activeTab = activeTab1
    elseif active == 2 and highestPoints2 > 0 then
        name = name2
        activeTab = activeTab2
    end

    return active, name, activeTab
end

function TalentModule:Refresh()
    if InCombatLockdown() then
        return
    end

    local db = xb.db.profile
    if self.talentFrame == nil then
        return
    end
    if not db.modules.talent.enabled then
        self:Disable()
        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    local textHeight = db.text.fontSize

    if isVanilla then
        local active, name, activeTab = GetVanillaActiveSpec()
        self.currentSpecID = active

        self.specIcon:SetTexture(self.classIcon)
        if name == "Not set" then
            self.specIcon:SetTexCoord(unpack(self.specCoords[1]))
        else
            self.specIcon:SetTexCoord(unpack(self.specCoords[activeTab]))
        end

        self.specIcon:SetSize(iconSize, iconSize)
        self.specIcon:SetPoint('LEFT')
        self.specIcon:SetVertexColor(xb:GetColor('normal'))

        self.specText:SetFont(xb:GetFont(textHeight))
        self.specText:SetTextColor(xb:GetColor('normal'))
        self.specText:SetText(string.upper(name or ""))
        self.specText:SetPoint('LEFT', self.specIcon, 'RIGHT', 5, 0)
        self.specText:Show()
    else
        self.currentSpecID = GetSpecialization()
        self.currentLootSpecID = GetLootSpecialization()

        local _, name = GetSpecializationInfo(self.currentSpecID)

        self.specIcon:SetTexture(self.classIcon)
        self.specIcon:SetTexCoord(unpack(self.specCoords[self.currentSpecID]))
        self.specIcon:SetSize(iconSize, iconSize)
        self.specIcon:SetPoint('LEFT')
        self.specIcon:SetVertexColor(xb:GetColor('normal'))

        self.specText:SetFont(xb:GetFont(textHeight))
        self.specText:SetTextColor(xb:GetColor('normal'))
        self.specText:SetText(string.upper(name or ""))
        self.specText:SetPoint('LEFT', self.specIcon, 'RIGHT', 5, 0)

        self.lootSpecButtons[0].icon:SetTexture(self.classIcon)
        self.lootSpecButtons[0].icon:SetTexCoord(unpack(self.specCoords[self.currentSpecID]))

        self.specText:Show()
    end

    self.specFrame:SetSize(iconSize + self.specText:GetWidth() + 5, xb:GetHeight())
    self.specFrame:SetPoint('LEFT')

    if self.specFrame:GetWidth() < db.modules.talent.minWidth then
        self.specFrame:SetWidth(db.modules.talent.minWidth)
    end

    self.talentFrame:SetSize(self.specFrame:GetWidth(), xb:GetHeight())

    local relativeAnchorPoint = 'LEFT'
    local xOffset = db.general.moduleSpacing
    local anchorFrame = xb:GetFrame('clockFrame')
    if not anchorFrame:IsVisible() and not db.modules.clock.enabled then
        if xb:GetFrame('tradeskillFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('tradeskillFrame')
        elseif xb:GetFrame('currencyFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('currencyFrame')
        else
            relativeAnchorPoint = 'RIGHT'
            xOffset = 0
        end
    end
    self.talentFrame:SetPoint('RIGHT', anchorFrame, relativeAnchorPoint, -(xOffset), 0)

    self:CreateSpecPopup()
    if not isVanilla then
        self:CreateLootSpecPopup()
    end
end

function TalentModule:CreateTalentFrames()
    self.specFrame = self.specFrame or CreateFrame('BUTTON', nil, self.talentFrame, 'SecureActionButtonTemplate')
    self.specIcon = self.specIcon or self.specFrame:CreateTexture(nil, 'OVERLAY')
    self.specText = self.specText or self.specFrame:CreateFontString(nil, 'OVERLAY')

    local template = (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
                         (BackdropTemplateMixin and "BackdropTemplate")
    self.specPopup = self.specPopup or CreateFrame('BUTTON', 'SpecPopup', self.specFrame, template)
    self.specPopup:SetFrameStrata('TOOLTIP')

    if not isVanilla then
        self.lootSpecPopup = self.lootSpecPopup or CreateFrame('BUTTON', 'LootPopup', self.specFrame, template)
        self.lootSpecPopup:SetFrameStrata('TOOLTIP')
    end

    if TooltipBackdropTemplateMixin then
        self.specPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.specPopup.NineSlice)

        if GameTooltip.layoutType then
            self.specPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
            self.specPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
        end

        if not isVanilla then
            self.lootSpecPopup.layoutType = GameTooltip.layoutType
            NineSlicePanelMixin.OnLoad(self.lootSpecPopup.NineSlice)

            if GameTooltip.layoutType then
                self.lootSpecPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
                self.lootSpecPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
            end
        end
    else
        local backdrop = GameTooltip:GetBackdrop()
        if backdrop and (not self.useElvUI) then
            self.specPopup:SetBackdrop(backdrop)
            self.specPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
            self.specPopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
            if not isVanilla then
                self.lootSpecPopup:SetBackdrop(backdrop)
                self.lootSpecPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
                self.lootSpecPopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
            end
        end
    end

    self:CreateSpecPopup()
    if not isVanilla then
        self:CreateLootSpecPopup()
    end
end

function TalentModule:RegisterFrameEvents()
    if isVanilla then
        self:RegisterEvent('ACTIVE_PLAYER_SPECIALIZATION_CHANGED', 'Refresh')
        self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'Refresh')
        self:RegisterEvent('CONFIRM_TALENT_WIPE', 'Refresh')
        self:RegisterEvent('PLAYER_TALENT_UPDATE', 'Refresh')
    else
        self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'Refresh')
        self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'Refresh')
        self:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED', 'Refresh')
    end

    self.specFrame:EnableMouse(true)
    self.specFrame:RegisterForClicks('AnyUp')

    self.specFrame:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return
        end
        self.specText:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.talent.showTooltip then
            if (not self.specPopup:IsVisible()) or (self.lootSpecPopup and not self.lootSpecPopup:IsVisible()) then
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
            if self.LTip:IsAcquired("TalentTooltip") then
                self.LTip:Release(self.LTip:Acquire("TalentTooltip"))
            end
        end
    end)

    self.specFrame:SetScript('OnClick', function(_, button)
        if self.LTip:IsAcquired("TalentTooltip") then
            self.LTip:Release(self.LTip:Acquire("TalentTooltip"))
        end

        if InCombatLockdown() then
            return
        end

        if button == 'LeftButton' then
            if not self.specPopup:IsVisible() then
                if self.lootSpecPopup then
                    self.lootSpecPopup:Hide()
                end
                self:CreateSpecPopup()
                self.specPopup:Show()
            else
                self.specPopup:Hide()
                if xb.db.profile.modules.talent.showTooltip then
                    self:ShowTooltip()
                end
            end
        elseif button == 'RightButton' and self.lootSpecPopup then
            if not self.lootSpecPopup:IsVisible() then
                self.specPopup:Hide()
                self:CreateLootSpecPopup()
                self.lootSpecPopup:Show()
            else
                self.lootSpecPopup:Hide()
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

function TalentModule:CreateSpecPopup()
    if isVanilla then
        return self:CreateSpecPopupVanilla()
    end

    return self:CreateSpecPopupProgression()
end

function TalentModule:CreateSpecPopupProgression()
    if not self.specPopup then
        return
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.specOptionString = self.specOptionString or self.specPopup:CreateFontString(nil, 'OVERLAY')
    self.specOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.specOptionString:SetTextColor(r, g, b, 1)
    self.specOptionString:SetText(L['Set Specialization'])
    self.specOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.specOptionString:SetPoint('CENTER')

    local popupWidth = self.specPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    for i = 1, GetNumSpecializations() do
        if self.specButtons[i] == nil then
            local _, name = GetSpecializationInfo(i)
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

            button:SetScript('OnClick', function(self, button)
                if InCombatLockdown() then
                    return
                end
                if button == 'LeftButton' then
                    SetSpecialization(self:GetID())
                end
                TalentModule.specPopup:Hide()
            end)

            self.specButtons[i] = button

            if textWidth > popupWidth then
                popupWidth = textWidth
                changedWidth = true
            end
        end
    end

    for _, button in pairs(self.specButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end
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

    local popupPadding = xb.constants.popupPadding
    if db.general.barPosition == 'TOP' then
        popupPadding = -(popupPadding)
    end

    self.specPopup:ClearAllPoints()
    self.specPopup:SetPoint(db.general.barPosition, self.specFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.specPopup, "SpecToolTip")
    self.specPopup:Hide()
end

function TalentModule:CreateSpecPopupVanilla()
    if not self.specPopup then
        return
    end

    for _, button in pairs(self.specButtons) do
        if button then
            button:Hide()
            button:SetParent(nil)
        end
    end
    wipe(self.specButtons)

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.specOptionString = self.specOptionString or self.specPopup:CreateFontString(nil, 'OVERLAY')
    self.specOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.specOptionString:SetTextColor(r, g, b, 1)
    self.specOptionString:SetText(L['Set Specialization'])
    self.specOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.specOptionString:SetPoint('CENTER')

    local popupWidth = self.specPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false

    local numSpecs = GetNumTalentGroups()
    for i = 1, numSpecs do
        local name = "Not set"
        local activeTab = 1
        local highestPoints = 0
        for tabIndex = 1, GetNumTalentTabs() do
            local tabID, _, _, _, pointsSpent = GetTalentTabInfo(tabIndex, false, false, i)
            pointsSpent = tonumber(pointsSpent) or 0
            if pointsSpent > highestPoints then
                highestPoints = pointsSpent
                local _, specName = GetSpecializationInfoForSpecID(tabID)
                name = specName or "Not set"
                activeTab = tabIndex
            end
        end

        local button = CreateFrame('BUTTON', nil, self.specPopup)
        local buttonText = button:CreateFontString(nil, 'OVERLAY')
        local buttonIcon = button:CreateTexture(nil, 'OVERLAY')

        buttonIcon:SetTexture(self.classIcon)
        if name == "Not set" then
            buttonIcon:SetTexCoord(unpack(self.specCoords[1]))
        else
            buttonIcon:SetTexCoord(unpack(self.specCoords[activeTab]))
        end
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

        button:SetScript('OnClick', function(_, clickButton)
            if InCombatLockdown() then
                return
            end
            if clickButton == 'LeftButton' then
                if SetActiveTalentGroup then
                    SetActiveTalentGroup(i)
                elseif SetActiveSpecGroup then
                    SetActiveSpecGroup(i)
                end
            end
            TalentModule.specPopup:Hide()
        end)

        self.specButtons[i] = button

        if textWidth > popupWidth then
            popupWidth = textWidth
            changedWidth = true
        end
    end

    for _, button in pairs(self.specButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end

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

    local popupPadding = xb.constants.popupPadding
    if db.general.barPosition == 'TOP' then
        popupPadding = -(popupPadding)
    end

    self.specPopup:ClearAllPoints()
    self.specPopup:SetPoint(db.general.barPosition, self.specFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.specPopup, "SpecToolTip")
    self.specPopup:Hide()
end

function TalentModule:CreateLootSpecPopup()
    if not self.lootSpecPopup then
        return
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    self.lootSpecOptionString = self.lootSpecOptionString or self.lootSpecPopup:CreateFontString(nil, 'OVERLAY')
    self.lootSpecOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.lootSpecOptionString:SetTextColor(r, g, b, 1)
    self.lootSpecOptionString:SetText(L['Set Loot Specialization'])
    self.lootSpecOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.lootSpecOptionString:SetPoint('CENTER')

    local popupWidth = self.lootSpecPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
    local changedWidth = false
    for i = 0, GetNumSpecializations() do
        if self.lootSpecButtons[i] == nil then
            local specId = i
            local name = ''
            if i == 0 then
                name = L['Current Specialization']
                specId = self.currentSpecID
            else
                local _, specName = GetSpecializationInfo(i)
                name = specName
            end
            local button = CreateFrame('BUTTON', nil, self.lootSpecPopup)
            local buttonText = button:CreateFontString(nil, 'OVERLAY')
            local buttonIcon = button:CreateTexture(nil, 'OVERLAY')

            buttonIcon:SetTexture(self.classIcon)
            buttonIcon:SetTexCoord(unpack(self.specCoords[specId]))
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

            button:SetScript('OnClick', function(self, clickButton)
                if InCombatLockdown() then
                    return
                end
                if clickButton == 'LeftButton' then
                    local id = 0
                    if self:GetID() ~= 0 then
                        id = GetSpecializationInfo(self:GetID())
                    else
                        id = GetSpecializationInfo(GetSpecialization())
                    end
                    SetLootSpecialization(id)
                end
                TalentModule.lootSpecPopup:Hide()
            end)

            self.lootSpecButtons[i] = button

            if textWidth > popupWidth then
                popupWidth = textWidth
                changedWidth = true
            end
        end
    end

    for _, button in pairs(self.lootSpecButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
        else
            button:Hide()
        end
    end
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

    local popupPadding = xb.constants.popupPadding
    if db.general.barPosition == 'TOP' then
        popupPadding = -(popupPadding)
    end

    self.lootSpecPopup:ClearAllPoints()
    self.lootSpecPopup:SetPoint(db.general.barPosition, self.specFrame, xb.miniTextPosition, 0, 0)
    self:SkinFrame(self.lootSpecPopup, "LootSpecToolTip")
    self.lootSpecPopup:Hide()
end

function TalentModule:ShowTooltip()
    if self.LTip:IsAcquired("TalentTooltip") then
        self.LTip:Release(self.LTip:Acquire("TalentTooltip"))
    end
    local tooltip = self.LTip:Acquire("TalentTooltip", 2, "LEFT", "RIGHT")
    tooltip:SmartAnchorTo(self.talentFrame)
    local r, g, b, _ = unpack(xb:HoverColors())
    tooltip:AddHeader("|cFFFFFFFF[|r" .. SPECIALIZATION .. "|cFFFFFFFF]|r")
    tooltip:SetCellTextColor(1, 1, r, g, b, 1)
    tooltip:AddLine(" ")

    if not isVanilla then
        local name = ''
        if self.currentLootSpecID == 0 then
            local _, specName = GetSpecializationInfo(self.currentSpecID)
            name = specName
        else
            local _, specName = GetSpecializationInfoByID(self.currentLootSpecID)
            name = specName
        end
        tooltip:AddLine(L['Current Loot Specialization'], "|cFFFFFFFF" .. name .. "|r")
        tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
        tooltip:AddLine(" ")
    end

    tooltip:AddLine('<' .. L['Left-Click'] .. '>', "|cFFFFFFFF" .. L['Set Specialization'] .. "|r")
    tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
    if not isVanilla then
        tooltip:AddLine('<' .. L['Right-Click'] .. '>', "|cFFFFFFFF" .. L['Set Loot Specialization'] .. "|r")
        tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
    end
    self:SkinFrame(tooltip, "TalentTooltip")
    tooltip:Show()
end

function TalentModule:GetDefaultOptions()
    return 'talent', {
        enabled = true,
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
                    return xb.db.profile.modules.talent.enabled
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
            showTooltip = {
                name = L['Show Tooltips'],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.talent.showTooltip
                end,
                set = function(_, val)
                    xb.db.profile.modules.talent.showTooltip = val
                    self:Refresh()
                end
            },
            minWidth = {
                name = L['Talent Minimum Width'],
                type = 'range',
                order = 3,
                min = 10,
                max = 200,
                step = 10,
                get = function()
                    return xb.db.profile.modules.talent.minWidth
                end,
                set = function(_, val)
                    xb.db.profile.modules.talent.minWidth = val
                    self:Refresh()
                end
            }
        }
    }
end
