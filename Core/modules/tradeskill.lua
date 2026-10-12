---@class XIVBar
local XIVBar = select(2, ...)
local _G = _G
local xb = XIVBar
local L = XIVBar.L
local compat = XIVBar.compat or {}

local TradeskillModule = xb:NewModule("TradeskillModule", 'AceEvent-3.0')

local PROF_PREFIXES = { 'firstProf', 'secondProf', 'cook', 'fish', 'arch', 'first_aid' }

local LibStub = _G.LibStub
local LibAddonCompat = nil
local C_Timer = _G.C_Timer
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function TradeskillModule:GetName()
    return TRADESKILLS
end

-- Skin Support for ElvUI/TukUI (align with micromenu/travel/talent)
function TradeskillModule:SkinFrame(frame, name)
    local ElvUI = rawget(_G, 'ElvUI')
    local Tukui = rawget(_G, 'Tukui')

    if xb.db.profile.general.useElvUI and IsAddOnLoaded and (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui')) then
        if frame.StripTextures then
            frame:StripTextures()
        end
        if frame.SetTemplate then
            frame:SetTemplate("Transparent")
        end

        local close = _G[name .. "CloseButton"] or frame.CloseButton
        if close and close.SetAlpha then
            if ElvUI and ElvUI[1] and ElvUI[1].GetModule then
                ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
            end

            if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
                Tukui[1].SkinCloseButton(close)
            end
            close:SetAlpha(1)
        end
    end
end

function TradeskillModule:OnInitialize()
    if not compat.isMainline and LibStub then
        LibAddonCompat = LibStub("LibAddonCompat-1.0")
    end
    if LibStub then
        self.LTip = LibStub('LibQTip-2.0', true)
    end

    self.profIcons = {
        [164] = 'blacksmithing',
        [165] = 'leatherworking',
        [171] = 'alchemy',
        [182] = 'herbalism',
        [186] = 'mining',
        [202] = 'engineering',
        [333] = 'enchanting',
        [755] = 'jewelcrafting',
        [773] = 'inscription',
        [197] = 'tailoring',
        [393] = 'skinning',
        [185] = 'cooking'
    }
end

function TradeskillModule:OnEnable()
    if self.tradeskillFrame == nil then
        self.tradeskillFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('tradeskillFrame', self.tradeskillFrame)
    end

    self.tradeskillFrame:Show()

    self.firstProf = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }
    self.secondProf = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }
    self.arch = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }
    self.fish = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }
    self.cook = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }
    self.first_aid = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil,
        offset = nil
    }

    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function TradeskillModule:OnDisable()
    self:HideTooltip(true)
    self.tradeskillFrame:Hide()
    self:UnregisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('SKILL_LINES_CHANGED')
    self:UnregisterEvent('UNIT_SPELLCAST_STOP')
end

local function IsCataClassic()
    return LE_EXPANSION_LEVEL_CURRENT == (LE_EXPANSION_CATACLYSM or 3)
end

-- Classic Era still has the legacy skill line globals. Forever 1.60.1 does not.
-- Mists and Cataclysm also still expose those globals, but LibAddonCompat drops
-- Archaeology, so those flavours use the native profession API.
local function UseNativeProfessions()
    return compat.isMainline or compat.isMists or IsCataClassic()
end

local function GetProfessionInfoCompat(index)
    if UseNativeProfessions() then
        return GetProfessionInfo(index)
    end

    if LibAddonCompat and GetNumSkillLines then
        return LibAddonCompat:GetProfessionInfo(index)
    end

    return GetProfessionInfo(index)
end

local function GetProfessionsCompat()
    if UseNativeProfessions() then
        return GetProfessions()
    end

    if LibAddonCompat and GetNumSkillLines then
        return LibAddonCompat:GetProfessions()
    end

    return GetProfessions()
end

function TradeskillModule:ReadProfession(prefix, index)
    local prof = self[prefix]
    prof.idx = index
    if not index then
        return
    end

    local name, defIcon, lvl, maxLvl, _, offset, id = GetProfessionInfoCompat(index)
    prof.name, prof.defIcon, prof.lvl, prof.maxLvl, prof.offset, prof.id = name, defIcon, lvl, maxLvl, offset, id

    local bar = self[prefix .. 'Bar']
    if bar and prof.maxLvl then
        bar:SetMinMaxValues(1, prof.maxLvl)
        bar:SetValue(prof.lvl)
    end
end

function TradeskillModule:UpdateProfValues()
    local firstIdx, secondIdx, archIdx, fishIdx, cookIdx, firstAidIdx = GetProfessionsCompat()
    self:ReadProfession('firstProf', firstIdx)
    self:ReadProfession('secondProf', secondIdx)
    self:ReadProfession('arch', archIdx)
    self:ReadProfession('fish', fishIdx)
    self:ReadProfession('cook', cookIdx)
    self:ReadProfession('first_aid', firstAidIdx)
end

function TradeskillModule:GetBarPrefixes()
    local prefixes = { 'firstProf', 'secondProf' }
    local moduleDb = xb.db.profile.modules and xb.db.profile.modules.tradeskill
    if moduleDb and moduleDb.showSecondary then
        prefixes[#prefixes + 1] = 'cook'
        prefixes[#prefixes + 1] = 'fish'
        prefixes[#prefixes + 1] = 'arch'
        if not compat.isMainline then
            prefixes[#prefixes + 1] = 'first_aid'
        end
    end
    return prefixes
end

function TradeskillModule:Refresh()
    if InCombatLockdown() then
        return
    end
    if self.tradeskillFrame == nil then
        return
    end

    local db = xb.db.profile
    if not db then
        return
    end

    local modulesDb = db.modules
    local moduleDb = modulesDb and modulesDb.tradeskill
    if not moduleDb then
        return
    end
    if not moduleDb.showTooltip then
        self:HideTooltip(true)
    end
    if not moduleDb.enabled then
        self:Disable()
        return
    end

    self:UpdateProfValues()

    local shown = {}
    local shownSet = {}
    for _, prefix in ipairs(self:GetBarPrefixes()) do
        if self[prefix].idx then
            shown[#shown + 1] = prefix
            shownSet[prefix] = true
        end
    end

    for _, prefix in ipairs(PROF_PREFIXES) do
        local frame = self[prefix .. 'Frame']
        if frame and not shownSet[prefix] then
            frame:Hide()
        end
    end

    if #shown == 0 then
        self:HideTooltip(true)
        self.tradeskillFrame:Hide()
        return
    end

    self.tradeskillFrame:Show()

    local totalWidth = 0
    local previous = nil
    for _, prefix in ipairs(shown) do
        self:ConfigureSecureRightClick(prefix)
        self:StyleTradeskillFrame(prefix)
        local frame = self[prefix .. 'Frame']
        frame:Show()
        frame:ClearAllPoints()
        if previous then
            frame:SetPoint('LEFT', previous, 'RIGHT', 5, 0)
            totalWidth = totalWidth + 5
        else
            frame:SetPoint('LEFT')
        end
        totalWidth = totalWidth + frame:GetWidth()
        previous = frame
    end

    self.tradeskillFrame:SetSize(totalWidth, xb:GetHeight())

    if xb:ApplyModuleFreePlacement('tradeskill', self.tradeskillFrame) then
        return
    end

    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    if not xb:GetFrame('clockFrame') or not xb:GetFrame('clockFrame'):IsVisible() then
        relativeAnchorPoint = 'LEFT'
        xOffset = 0
    end
    self.tradeskillFrame:ClearAllPoints()
    self.tradeskillFrame:SetPoint('LEFT', xb:GetFrame('clockFrame'), relativeAnchorPoint, xOffset, 0)
end

function TradeskillModule:StyleTradeskillFrame(prefix)
    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    -- A Classic skill line does not always resolve to a profession id, and profIcons then
    -- yields nil: fall back to the icon the API reported for the profession itself.
    local iconName = self.profIcons[self[prefix].id]
    local icon = self[prefix].defIcon or (xb.constants.mediaPath .. 'profession\\major')
    if iconName then
        icon = xb.constants.mediaPath .. 'profession\\' .. iconName
    end

    local textHeight = floor((xb:GetHeight() - 4) / 2)
    if self[prefix].lvl == self[prefix].maxLvl then
        textHeight = db.text.fontSize
    end

    local barHeight = (iconSize - textHeight - 2)
    if barHeight < 3 then
        barHeight = 3
    end
    local barYOffset = floor((xb:GetHeight() - iconSize) / 2)
    if barYOffset < 0 then
        barYOffset = 0
    end

    -- Icon
    self[prefix .. 'Icon']:ClearAllPoints()
    self[prefix .. 'Icon']:SetTexture(icon)
    self[prefix .. 'Icon']:SetSize(iconSize, iconSize)
    self[prefix .. 'Icon']:SetPoint('LEFT')
    self[prefix .. 'Icon']:SetVertexColor(xb:GetColor('normal'))

    if db.modules.tradeskill.showLabel == false then
        self[prefix .. 'Text']:Hide()
        self[prefix .. 'Bar']:Hide()
        self[prefix .. 'Frame']:SetSize(iconSize, xb:GetHeight())
        return
    end

    -- Text
    self[prefix .. 'Text']:Show()
    self[prefix .. 'Text']:ClearAllPoints()
    self[prefix .. 'Text']:SetFont(xb:GetFont(textHeight))
    self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
    self[prefix .. 'Text']:SetText(string.upper(self[prefix].name))

    if self[prefix].lvl == self[prefix].maxLvl then
        self[prefix .. 'Bar']:Hide()
        self[prefix .. 'Text']:SetPoint('LEFT', self[prefix .. 'Icon'], 'RIGHT', 5, 0)
    else
        self[prefix .. 'Bar']:Show()
        self[prefix .. 'Text']:SetPoint('TOPLEFT', self[prefix .. 'Icon'], 'TOPRIGHT', 5, 0)

        self[prefix .. 'Bar']:ClearAllPoints()
        self[prefix .. 'Bar']:SetStatusBarTexture("Interface/BUTTONS/WHITE8X8")
        if db.modules.tradeskill.barCC then
            local rPerc, gPerc, bPerc = xb:GetClassColors()
            self[prefix .. 'Bar']:SetStatusBarColor(rPerc, gPerc, bPerc, 1)
        else
            self[prefix .. 'Bar']:SetStatusBarColor(xb:GetColor('normal'))
        end
        self[prefix .. 'Bar']:SetSize(self[prefix .. 'Text']:GetStringWidth(), barHeight)
        self[prefix .. 'Bar']:SetPoint('BOTTOMLEFT', self[prefix .. 'Frame'], 'BOTTOMLEFT', iconSize + 5, barYOffset)

        self[prefix .. 'BarBg']:SetAllPoints()
        self[prefix .. 'BarBg']:SetColorTexture(db.color.inactive.r, db.color.inactive.g, db.color.inactive.b,
            db.color.inactive.a)
    end

    self[prefix .. 'Frame']:SetSize(iconSize + self[prefix .. 'Text']:GetStringWidth() + 5, xb:GetHeight())
end

function TradeskillModule:CreateFrames()
    local buttonTemplate = nil
    if compat.isMainline then
        buttonTemplate = 'SecureActionButtonTemplate,SecureHandlerStateTemplate'
    end

    for _, prefix in ipairs(PROF_PREFIXES) do
        local frame = self[prefix .. 'Frame']
        if not frame then
            frame = CreateFrame("BUTTON", nil, self.tradeskillFrame, buttonTemplate)
            self[prefix .. 'Frame'] = frame
        end
        if not self[prefix .. 'Icon'] then
            self[prefix .. 'Icon'] = frame:CreateTexture(nil, 'OVERLAY')
        end
        if not self[prefix .. 'Text'] then
            self[prefix .. 'Text'] = frame:CreateFontString(nil, 'OVERLAY')
        end
        if not self[prefix .. 'Bar'] then
            self[prefix .. 'Bar'] = CreateFrame('STATUSBAR', nil, frame)
        end
        if not self[prefix .. 'BarBg'] then
            self[prefix .. 'BarBg'] = self[prefix .. 'Bar']:CreateTexture(nil, 'BACKGROUND')
        end
    end
end

function TradeskillModule:ConfigureSecureRightClick(prefix)
    if not compat.isMainline or InCombatLockdown() then
        return
    end

    local frame = self[prefix .. 'Frame']
    if not frame then
        return
    end

    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute('useOnKeyDown', false)

    local professionMicroButton = _G.ProfessionMicroButton
    if professionMicroButton then
        frame:SetAttribute('*type2', 'click')
        frame:SetAttribute('*clickbutton2', professionMicroButton)
    else
        frame:SetAttribute('*type2', nil)
        frame:SetAttribute('*clickbutton2', nil)
    end
end

function TradeskillModule:OpenProfession(prefix)
    if not prefix or not self[prefix] then
        return
    end

    if compat.isMainline then
        local currentProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
        if currentProfessionInfo and currentProfessionInfo.professionID == self[prefix].id then
            C_TradeSkillUI.CloseTradeSkill()
            return
        end
        C_TradeSkillUI.OpenTradeSkill(self[prefix].id)
        return
    end

    if self[prefix].offset ~= nil then
        CastSpell(self[prefix].offset + 1, "Spell")
    end
end

function TradeskillModule:IsInteractiveTooltipEnabled()
    local moduleDb = xb.db.profile.modules and xb.db.profile.modules.tradeskill
    return moduleDb and moduleDb.useInteractiveTooltip ~= false and self.LTip
end

function TradeskillModule:ShowGameTooltip()
    if not xb:ShouldShowTooltip() then
        self:HideTooltip(true)
        return
    end

    local r, g, b, _ = unpack(xb:HoverColors())

    self.tooltipHover = false
    self.lineHover = false

    GameTooltip:SetOwner(self.tradeskillFrame, "ANCHOR_TOP")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. TRADE_SKILLS .. "|cFFFFFFFF]|r", r, g, b, true)
    GameTooltip:AddLine(' ')

    local function AddGameTooltipProfessionRow(prefix)
        local defIcon = self[prefix].defIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
        local left = "|T" .. defIcon .. ":0|t " .. (self[prefix].name or '')
        local right = "|cFFFFFFFF" .. self[prefix].lvl .. "|r / " .. self[prefix].maxLvl
        GameTooltip:AddDoubleLine(left, right, 1, 1, 1, 1, 1, 1)
    end

    if self.firstProf.idx then
        AddGameTooltipProfessionRow('firstProf')
    end
    if self.secondProf.idx then
        AddGameTooltipProfessionRow('secondProf')
    end
    if self.cook.idx then
        AddGameTooltipProfessionRow('cook')
    end
    if self.fish.idx then
        AddGameTooltipProfessionRow('fish')
    end
    if self.arch.idx then
        AddGameTooltipProfessionRow('arch')
    end
    if self.first_aid.idx and not compat.isMainline then
        AddGameTooltipProfessionRow('first_aid')
    end

    local function HexColor(hr, hg, hb)
        return string.format("%02x%02x%02x", hr * 255, hg * 255, hb * 255)
    end

    GameTooltip:AddLine(' ')
    local color = HexColor(r, g, b)
    local row1Left = string.format("|cff%s<%s>|r", color, L["LEFT_CLICK"])
    GameTooltip:AddDoubleLine(row1Left, L["TOGGLE_PROFESSION_FRAME"], 1, 1, 1, 1, 1, 1)

    if compat.isMainline or IsCataClassic() then
        local row2Left = string.format("|cff%s<%s>|r", color, L["RIGHT_CLICK"])
        GameTooltip:AddDoubleLine(row2Left, L["TOGGLE_PROFESSION_SPELLBOOK"], 1, 1, 1, 1, 1, 1)
    end

    GameTooltip:Show()
end

function TradeskillModule:ShowConfiguredTooltip()
    local moduleDb = xb.db.profile.modules and xb.db.profile.modules.tradeskill
    if not moduleDb or not moduleDb.showTooltip then
        self:HideTooltip(true)
        return
    end

    if self:IsInteractiveTooltipEnabled() then
        self:ShowTooltip()
        return
    end

    self:HideTooltip(true)
    self:ShowGameTooltip()
end

function TradeskillModule:HideTooltip(force)
    GameTooltip:Hide()

    if not self:IsInteractiveTooltipEnabled() then
        self.tooltip = nil
        self.tooltipHover = false
        self.lineHover = false
        return
    end

    if not force and (self.frameHover or self.tooltipHover or self.lineHover) then
        return
    end

    if self.tooltip and self.LTip:IsAcquiredTooltip("TradeskillToolTip") then
        self.LTip:ReleaseTooltip(self.tooltip)
    end

    self.tooltip = nil
    self.tooltipHover = false
    self.lineHover = false
end

function TradeskillModule:QueueTooltipHide()
    if not self:IsInteractiveTooltipEnabled() then
        self:HideTooltip(true)
        return
    end

    if not C_Timer then
        self:HideTooltip()
        return
    end

    C_Timer.After(0.05, function()
        self:HideTooltip()
    end)
end

function TradeskillModule:AcquireTooltip()
    if not self.LTip then
        return nil
    end

    if self.LTip:IsAcquiredTooltip("TradeskillToolTip") then
        local existingTooltip = self.LTip:AcquireTooltip("TradeskillToolTip", 2, "LEFT", "RIGHT")
        self.LTip:ReleaseTooltip(existingTooltip)
    end

    local tooltip = self.LTip:AcquireTooltip("TradeskillToolTip", 2, "LEFT", "RIGHT")
    tooltip:EnableMouse(true)
    tooltip:SetFrameStrata('TOOLTIP')
    xb:RegisterMouseoverHoldFrame(tooltip, true)
    tooltip:SetScript("OnEnter", function()
        self.tooltipHover = true
    end)
    tooltip:SetScript("OnLeave", function()
        self.tooltipHover = false
        self:QueueTooltipHide()
    end)
    tooltip:SetScript("OnUpdate", function()
        if not self.frameHover and not self.tooltipHover and not self.lineHover then
            self:HideTooltip()
        end
    end)

    self:SkinFrame(tooltip, "TradeskillToolTip")

    self.tooltip = tooltip
    return tooltip
end

function TradeskillModule:AddTooltipProfessionRow(tooltip, prefix)
    local defIcon = self[prefix].defIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
    local left = "|T" .. defIcon .. ":0|t " .. (self[prefix].name or '')
    local right = "|cFFFFFFFF" .. self[prefix].lvl .. "|r / " .. self[prefix].maxLvl
    local lineRow = tooltip:AddRow(left, right)
    lineRow:SetScript("OnEnter", function()
        self.lineHover = true
    end)
    lineRow:SetScript("OnLeave", function()
        self.lineHover = false
        self:QueueTooltipHide()
    end)
    lineRow:SetScript("OnMouseUp", function(_, _, button)
        if button ~= 'LeftButton' then
            return
        end
        self:OpenProfession(prefix)
    end)
end

function TradeskillModule:SetProfScripts(prefix)
    self[prefix .. 'Frame']:SetScript('OnMouseDown', function(_, button)
        if button == 'LeftButton' then
            self:OpenProfession(prefix)
        end
    end)

    self:ConfigureSecureRightClick(prefix)

    self[prefix .. 'Frame']:SetScript('OnEnter', function()
        self.frameHover = true
        if xb.db.profile.modules.tradeskill.showLabel == false then
            self[prefix .. 'Icon']:SetVertexColor(unpack(xb:HoverColors()))
        else
            self[prefix .. 'Text']:SetTextColor(unpack(xb:HoverColors()))
        end
        if xb:ShouldShowTooltip() then
            self:ShowConfiguredTooltip()
        else
            self:HideTooltip(true)
        end
    end)

    self[prefix .. 'Frame']:SetScript('OnLeave', function()
        self.frameHover = false
        if xb.db.profile.modules.tradeskill.showLabel == false then
            self[prefix .. 'Icon']:SetVertexColor(xb:GetColor('normal'))
        else
            self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
        end
        local moduleDb = xb.db.profile.modules.tradeskill
        if moduleDb.showTooltip then
            self:QueueTooltipHide()
        end
    end)
end

function TradeskillModule:RegisterFrameEvents()
    self.tradeskillFrame:SetScript('OnEvent', function()
        self:Refresh()
    end)
    self.tradeskillFrame:RegisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self.tradeskillFrame:RegisterEvent('SPELLS_CHANGED')
    self.tradeskillFrame:RegisterEvent('SKILL_LINES_CHANGED')
    self.tradeskillFrame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')

    for _, prefix in ipairs(PROF_PREFIXES) do
        self:SetProfScripts(prefix)
    end

    self.tradeskillFrame:SetScript('OnEnter', function()
        self.frameHover = true
        if xb:ShouldShowTooltip() then
            self:ShowConfiguredTooltip()
        else
            self:HideTooltip(true)
        end
    end)

    self.tradeskillFrame:SetScript('OnLeave', function()
        local moduleDb = xb.db.profile.modules.tradeskill
        self.frameHover = false
        if moduleDb.showTooltip then
            self:QueueTooltipHide()
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

function TradeskillModule:ShowTooltip()
    if not self.LTip then
        return
    end
    if not xb:ShouldShowTooltip() then
        self:HideTooltip(true)
        return
    end

    GameTooltip:Hide()

    local r, g, b, _ = unpack(xb:HoverColors())
    local tooltip = self:AcquireTooltip()
    if not tooltip then
        return
    end

    tooltip:SmartAnchorTo(self.tradeskillFrame)
    local headerRow = tooltip:AddHeadingRow("|cFFFFFFFF[|r" .. TRADE_SKILLS .. "|cFFFFFFFF]|r")
    headerRow:SetTextColor(r, g, b, 1)
    tooltip:AddRow(' ', ' ')

    if self.firstProf.idx then
        self:AddTooltipProfessionRow(tooltip, 'firstProf', r, g, b)
    end
    if self.secondProf.idx then
        self:AddTooltipProfessionRow(tooltip, 'secondProf', r, g, b)
    end
    if self.cook.idx then
        self:AddTooltipProfessionRow(tooltip, 'cook', r, g, b)
    end
    if self.fish.idx then
        self:AddTooltipProfessionRow(tooltip, 'fish', r, g, b)
    end
    if self.arch.idx then
        self:AddTooltipProfessionRow(tooltip, 'arch', r, g, b)
    end
    if self.first_aid.idx and not compat.isMainline then
        self:AddTooltipProfessionRow(tooltip, 'first_aid', r, g, b)
    end

    -- construit une couleur hex à partir de r/g/b (0-1)
    local function HexColor(hr, hg, hb)
        return string.format("%02x%02x%02x", hr * 255, hg * 255, hb * 255)
    end

    tooltip:AddRow(' ', ' ')
    local color = HexColor(r, g, b)

    local row1Left = string.format("|cff%s<%s>|r", color, L["LEFT_CLICK"])
    tooltip:AddRow(row1Left, L["TOGGLE_PROFESSION_FRAME"])

    if compat.isMainline or IsCataClassic() then
        local row2Left = string.format("|cff%s<%s>|r", color, L["RIGHT_CLICK"])
        tooltip:AddRow(row2Left, L["TOGGLE_PROFESSION_SPELLBOOK"])
    end
    tooltip:Show()
end

function TradeskillModule:GetDefaultOptions()
    return 'tradeskill', {
        enabled = true,
        showSecondary = false,
        showLabel = true,
        barCC = false,
        showTooltip = true,
        useInteractiveTooltip = true
    }
end

function TradeskillModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.enabled
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            showSecondary = {
                name = L["SHOW_SECONDARY_PROFESSIONS"],
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.showSecondary
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.showSecondary = val
                    self:Refresh()
                end,
                width = "full"
            },
            showLabel = {
                name = L["SHOW_PROFESSION_NAMES"],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.showLabel ~= false
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.showLabel = val
                    self:Refresh()
                end,
                width = "full"
            },
            barCC = {
                name = L["USE_CLASS_COLORS"],
                order = 3,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.barCC
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.barCC = val
                    self:Refresh()
                end,
                disabled = function()
                    return xb.db.profile.modules.tradeskill.showLabel == false
                end
            },
            showTooltip = {
                name = L["SHOW_TOOLTIPS"],
                order = 4,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.showTooltip
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.showTooltip = val
                    self:Refresh()
                end
            },
            useInteractiveTooltip = {
                name = L["USE_INTERACTIVE_TOOLTIP"],
                order = 5,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.useInteractiveTooltip ~= false
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.useInteractiveTooltip = val
                    self:Refresh()
                end,
                disabled = function()
                    return not xb.db.profile.modules.tradeskill.showTooltip
                end
            }
        }
    }
end
