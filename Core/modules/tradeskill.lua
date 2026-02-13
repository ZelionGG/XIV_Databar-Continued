local AddOnName, XIVBar = ...
local _G = _G
local xb = XIVBar
local L = XIVBar.L
local compat = XIVBar.compat or {}

local TradeskillModule = xb:NewModule("TradeskillModule", 'AceEvent-3.0')

local LibStub = _G.LibStub
local LibAddonCompat = nil
local IsAddOnLoaded = compat.IsAddOnLoaded or (C_AddOns and C_AddOns.IsAddOnLoaded)

function TradeskillModule:GetName()
    return TRADESKILLS
end

function TradeskillModule:OnInitialize()
    if not compat.isMainline and LibStub then
        LibAddonCompat = LibStub("LibAddonCompat-1.0")
    end

    if compat.isMainline and LibStub then
        self.LTip = LibStub('LibQTip-1.0')
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
        [393] = 'skinning'
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
    self.tradeskillFrame:Hide()
    self:UnregisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('SKILL_LINES_CHANGED')
    self:UnregisterEvent('UNIT_SPELLCAST_STOP')
end

local function IsCataClassic()
    return LE_EXPANSION_LEVEL_CURRENT == (LE_EXPANSION_CATACLYSM or 3)
end

local function GetProfessionInfoCompat(index)
    if compat.isMainline then
        return GetProfessionInfo(index)
    end

    if IsCataClassic() then
        return GetProfessionInfo(index)
    end

    if LibAddonCompat then
        return LibAddonCompat:GetProfessionInfo(index)
    end

    return GetProfessionInfo(index)
end

local function GetProfessionsCompat()
    if compat.isMainline then
        return GetProfessions()
    end

    if IsCataClassic() then
        return GetProfessions()
    end

    if LibAddonCompat then
        return LibAddonCompat:GetProfessions()
    end

    return GetProfessions()
end

function TradeskillModule:UpdateProfValues()
    self.firstProf.idx, self.secondProf.idx, self.arch.idx, self.fish.idx, self.cook.idx, self.first_aid.idx =
        GetProfessionsCompat()

    if not self.firstProf.idx then
        self.tradeskillFrame:Hide()
    else
        self.tradeskillFrame:Show()
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.firstProf.idx)
        self.firstProf.name, self.firstProf.defIcon, self.firstProf.lvl, self.firstProf.maxLvl, self.firstProf.offset,
            self.firstProf.id = name, defIcon, lvl, maxLvl, offset, id
        self.firstProfBar:SetMinMaxValues(1, self.firstProf.maxLvl)
        self.firstProfBar:SetValue(self.firstProf.lvl)
    end

    if not self.secondProf.idx then
        self.secondProfFrame:Hide()
    else
        self.secondProfFrame:Show()
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.secondProf.idx)
        self.secondProf.name, self.secondProf.defIcon, self.secondProf.lvl, self.secondProf.maxLvl,
            self.secondProf.offset, self.secondProf.id = name, defIcon, lvl, maxLvl, offset, id
        self.secondProfBar:SetMinMaxValues(1, self.secondProf.maxLvl)
        self.secondProfBar:SetValue(self.secondProf.lvl)
    end

    if self.first_aid.idx and not compat.isMainline then
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.first_aid.idx)
        self.first_aid.name, self.first_aid.defIcon, self.first_aid.lvl, self.first_aid.maxLvl, self.first_aid.offset,
            self.first_aid.id = name, defIcon, lvl, maxLvl, offset, id
    end

    if self.arch.idx then
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.arch.idx)
        self.arch.name, self.arch.defIcon, self.arch.lvl, self.arch.maxLvl, self.arch.offset, self.arch.id = name,
            defIcon, lvl, maxLvl, offset, id
    end

    if self.fish.idx then
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.fish.idx)
        self.fish.name, self.fish.defIcon, self.fish.lvl, self.fish.maxLvl, self.fish.offset, self.fish.id = name,
            defIcon, lvl, maxLvl, offset, id
    end

    if self.cook.idx then
        local name, defIcon, lvl, maxLvl, _, offset, id, _ = GetProfessionInfoCompat(self.cook.idx)
        self.cook.name, self.cook.defIcon, self.cook.lvl, self.cook.maxLvl, self.cook.offset, self.cook.id = name,
            defIcon, lvl, maxLvl, offset, id
    end
end

function TradeskillModule:Refresh()
    if InCombatLockdown() then
        return
    end
    if self.tradeskillFrame == nil then
        return
    end

    local db = xb.db.profile
    if not db.modules.tradeskill.enabled then
        self:Disable()
        return
    end

    self:UpdateProfValues()
    if not self.firstProf.idx then
        return
    end

    local totalWidth = 0

    self:StyleTradeskillFrame('firstProf')
    totalWidth = totalWidth + self.firstProfFrame:GetWidth()
    self.firstProfFrame:SetPoint('LEFT')

    if self.secondProf.idx then
        self:StyleTradeskillFrame('secondProf')
        totalWidth = totalWidth + self.secondProfFrame:GetWidth()
        self.secondProfFrame:SetPoint('LEFT', self.firstProfFrame, 'RIGHT', 5, 0)
    end

    self.tradeskillFrame:SetSize(totalWidth, xb:GetHeight())
    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    if not xb:GetFrame('clockFrame') or not xb:GetFrame('clockFrame'):IsVisible() then
        relativeAnchorPoint = 'LEFT'
        xOffset = 0
    end
    self.tradeskillFrame:SetPoint('LEFT', xb:GetFrame('clockFrame'), relativeAnchorPoint, xOffset, 0)
end

function TradeskillModule:StyleTradeskillFrame(prefix)
    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    local icon = xb.constants.mediaPath .. 'profession\\' .. self.profIcons[self[prefix].id]

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

    -- Text
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
    self.firstProfFrame = self.firstProfFrame or CreateFrame("BUTTON", nil, self.tradeskillFrame)
    self.firstProfIcon = self.firstProfIcon or self.firstProfFrame:CreateTexture(nil, 'OVERLAY')
    self.firstProfText = self.firstProfText or self.firstProfFrame:CreateFontString(nil, 'OVERLAY')
    self.firstProfBar = self.firstProfBar or CreateFrame('STATUSBAR', nil, self.firstProfFrame)
    self.firstProfBarBg = self.firstProfBarBg or self.firstProfBar:CreateTexture(nil, 'BACKGROUND')

    self.secondProfFrame = self.secondProfFrame or CreateFrame("BUTTON", nil, self.tradeskillFrame)
    self.secondProfIcon = self.secondProfIcon or self.secondProfFrame:CreateTexture(nil, 'OVERLAY')
    self.secondProfText = self.secondProfText or self.secondProfFrame:CreateFontString(nil, 'OVERLAY')
    self.secondProfBar = self.secondProfBar or CreateFrame('STATUSBAR', nil, self.secondProfFrame)
    self.secondProfBarBg = self.secondProfBarBg or self.secondProfBar:CreateTexture(nil, 'BACKGROUND')
end

function TradeskillModule:SetProfScripts(prefix)
    self[prefix .. 'Frame']:SetScript('OnMouseDown', function(_, button)
        if button == 'LeftButton' then
            if compat.isMainline then
                local currentProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
                if currentProfessionInfo and currentProfessionInfo.professionID == self[prefix].id then
                    C_TradeSkillUI.CloseTradeSkill()
                    return
                end
                C_TradeSkillUI.OpenTradeSkill(self[prefix].id)
            else
                if self[prefix].offset ~= nil then
                    CastSpell(self[prefix].offset + 1, "Spell")
                end
            end
        elseif button == 'RightButton' then
            if compat.isMainline then
                ToggleProfessionsBook()
            else
                if IsCataClassic() then
                    ToggleSpellBook(BOOKTYPE_PROFESSION)
                end
            end
        end
    end)

    self[prefix .. 'Frame']:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return
        end
        self[prefix .. 'Text']:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.tradeskill.showTooltip then
            self:ShowTooltip()
        end
    end)

    self[prefix .. 'Frame']:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return
        end
        self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
        if xb.db.profile.modules.tradeskill.showTooltip then
            GameTooltip:Hide()
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

    self:SetProfScripts('firstProf')
    self:SetProfScripts('secondProf')

    self.tradeskillFrame:SetScript('OnEnter', function()
        if xb.db.profile.modules.tradeskill.showTooltip then
            self:ShowTooltip()
        end
    end)

    self.tradeskillFrame:SetScript('OnLeave', function()
        if xb.db.profile.modules.tradeskill.showTooltip then
            GameTooltip:Hide()
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

function TradeskillModule:SkinFrame(frame, name)
    if not compat.isMainline then
        return
    end

    if xb.db.profile.general.useElvUI and IsAddOnLoaded and (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui')) then
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

function TradeskillModule:ShowTooltip()
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:SetOwner(self.tradeskillFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. TRADE_SKILLS .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")

    if self.firstProf.idx then
        self:ListTooltipProfession('firstProf', r, g, b)
    end
    if self.secondProf.idx then
        self:ListTooltipProfession('secondProf', r, g, b)
    end
    if self.cook.idx then
        self:ListTooltipProfession('cook', r, g, b)
    end
    if self.fish.idx then
        self:ListTooltipProfession('fish', r, g, b)
    end
    if self.arch.idx then
        self:ListTooltipProfession('arch', r, g, b)
    end
    if self.first_aid.idx and not compat.isMainline then
        self:ListTooltipProfession('first_aid', r, g, b)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>', L['Toggle Profession Frame'], r, g, b, 1, 1, 1)
    if compat.isMainline or IsCataClassic() then
        GameTooltip:AddDoubleLine('<' .. L['Right-Click'] .. '>', L['Toggle Profession Spellbook'], r, g, b, 1, 1, 1)
    end
    GameTooltip:Show()
end

function TradeskillModule:ListTooltipProfession(prefix, r, g, b)
    local left = "|T" .. self[prefix].defIcon .. ":0|t " .. self[prefix].name
    local right = "|cFFFFFFFF" .. self[prefix].lvl .. "|r / " .. self[prefix].maxLvl
    GameTooltip:AddDoubleLine(left, right, 1, 1, 1, r, g, b)
end

function TradeskillModule:GetDefaultOptions()
    return 'tradeskill', {
        enabled = true,
        barCC = false,
        showTooltip = true
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
            barCC = {
                name = L['Use Class Colors'],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.barCC
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.barCC = val
                    self:Refresh()
                end
            },
            showTooltip = {
                name = L['Show Tooltips'],
                order = 3,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.showTooltip
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.showTooltip = val
                    self:Refresh()
                end
            }
        }
    }
end
