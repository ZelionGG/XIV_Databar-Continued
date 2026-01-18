local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;
local compat = xb.compat or {}

local CurrencyModule = xb:NewModule("CurrencyModule", 'AceEvent-3.0', 'AceHook-3.0')

local function GetMaxLevel()
    if _G.GetMaxPlayerLevel then
        return _G.GetMaxPlayerLevel()
    end
    if _G.GetMaxLevelForExpansionLevel and _G.GetExpansionLevel then
        return GetMaxLevelForExpansionLevel(GetExpansionLevel())
    end
    return MAX_PLAYER_LEVEL or 60
end

local function ShouldUseSelectedCurrencies()
    return compat.isMainline == true
end

function CurrencyModule:GetName()
    return CURRENCY;
end

function CurrencyModule:OnInitialize()
    self.rerollItems = {697, 752, 776, 994, 1129, 1273}
    self.intToOpt = {
        [1] = 'currencyOne',
        [2] = 'currencyTwo',
        [3] = 'currencyThree'
    }

    self.curButtons = {}
    self.curIcons = {}
    self.curText = {}
    self.rerollItems = self.rerollItems or {}
end

function CurrencyModule:OnEnable()
    if self.currencyFrame == nil then
        self.currencyFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('currencyFrame', self.currencyFrame)
    end

    self.currencyFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function CurrencyModule:OnDisable()
    self.currencyFrame:Hide()
    self:UnregisterEvent('CURRENCY_DISPLAY_UPDATE')
    self:UnregisterEvent('PLAYER_XP_UPDATE')
    self:UnregisterEvent('PLAYER_LEVEL_UP')
end

function CurrencyModule:Refresh()
    local db = xb.db.profile
    xb.constants.playerLevel = UnitLevel("player")
    local maxLevel = GetMaxLevel()
    if InCombatLockdown() then
        if xb.constants.playerLevel < maxLevel and db.modules.currency.showXPbar then
            self.xpBar:SetMinMaxValues(0, UnitXPMax('player'))
            self.xpBar:SetValue(UnitXP('player'))
            self.xpText:SetText(string.upper(LEVEL .. ' ' .. UnitLevel("player") .. ' ' .. UnitClass('player')))
        end
        return
    end
    if self.currencyFrame == nil then
        return;
    end
    if not db.modules.currency.enabled then
        self:Disable();
        return;
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    for i = 1, 3 do
        self.curButtons[i]:Hide()
    end
    self.xpFrame:Hide()

    if xb.constants.playerLevel < maxLevel and db.modules.currency.showXPbar then
        local textHeight = floor((xb:GetHeight() - 4) / 2)
        local barHeight = (iconSize - textHeight - 2)
        if barHeight < 2 then
            barHeight = 2
        end
        self.xpIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\exp')
        self.xpIcon:SetSize(iconSize, iconSize)
        self.xpIcon:SetPoint('LEFT')
        self.xpIcon:SetVertexColor(xb:GetColor('normal'))

        self.xpText:SetFont(xb:GetFont(textHeight))
        self.xpText:SetTextColor(xb:GetColor('normal'))
        self.xpText:SetText(string.upper(LEVEL .. ' ' .. UnitLevel("player") .. ' ' .. UnitClass('player')))
        self.xpText:SetPoint('TOPLEFT', self.xpIcon, 'TOPRIGHT', 5, 0)

        self.xpBar:SetStatusBarTexture("Interface/BUTTONS/WHITE8X8")
        if db.modules.currency.xpBarCC then
            local rPerc, gPerc, bPerc = xb:GetClassColors()
            self.xpBar:SetStatusBarColor(rPerc, gPerc, bPerc, 1)
        else
            self.xpBar:SetStatusBarColor(xb:GetColor('normal'))
        end
        self.xpBar:SetMinMaxValues(0, UnitXPMax('player'))
        self.xpBar:SetValue(UnitXP('player'))
        self.xpBar:SetSize(self.xpText:GetStringWidth(), barHeight)
        self.xpBar:SetPoint('BOTTOMLEFT', self.xpIcon, 'BOTTOMRIGHT', 5, 0)

        self.xpBarBg:SetAllPoints()
        self.xpBarBg:SetColorTexture(db.color.inactive.r, db.color.inactive.g, db.color.inactive.b, db.color.inactive.a)
        self.currencyFrame:SetSize(iconSize + self.xpText:GetStringWidth() + 5, xb:GetHeight())
        self.xpFrame:SetAllPoints()
        self.xpFrame:Show()
    elseif not compat.isClassicOrTBC then
        local iconsWidth = 0
        if ShouldUseSelectedCurrencies() and C_CurrencyInfo then
            for i = 1, 3 do
                if db.modules.currency[self.intToOpt[i]] ~= '0' then
                    iconsWidth = iconsWidth +
                        self:StyleCurrencyFrame(tonumber(db.modules.currency[self.intToOpt[i]]), nil, i)
                end
            end
            if self.curButtons[1]:IsShown() then
                self.curButtons[1]:SetPoint('LEFT')
                self.curButtons[2]:SetPoint('LEFT', self.curButtons[1], 'RIGHT', 5, 0)
                self.curButtons[3]:SetPoint('LEFT', self.curButtons[2], 'RIGHT', 5, 0)
            end
        elseif GetNumWatchedTokens and type(GetNumWatchedTokens) == "function" then
            for i = 1, GetNumWatchedTokens() do
                local name, count, _, currencyID = GetBackpackCurrencyInfo(i)
                if name then
                    iconsWidth = iconsWidth + self:StyleCurrencyFrame(currencyID, count, i)
                    if i == 1 then
                        self.curButtons[1]:SetPoint('LEFT')
                    elseif i == 2 then
                        self.curButtons[2]:SetPoint('LEFT', self.curButtons[1], 'RIGHT', 5, 0)
                    elseif i == 3 then
                        self.curButtons[3]:SetPoint('LEFT', self.curButtons[2], 'RIGHT', 5, 0)
                    end
                end
            end
        end
        self.currencyFrame:SetSize(iconsWidth, xb:GetHeight())
    end

    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    local anchorFrame = xb:GetFrame('tradeskillFrame')
    if anchorFrame ~= nil and not anchorFrame:IsVisible() then
        if xb:GetFrame('clockFrame') and xb:GetFrame('clockFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('clockFrame')
        elseif xb:GetFrame('talentFrame') and xb:GetFrame('talentFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('talentFrame')
        else
            relativeAnchorPoint = 'LEFT'
            xOffset = 0
        end
    end
    self.currencyFrame:SetPoint('LEFT', anchorFrame, relativeAnchorPoint, xOffset, 0)
end

function CurrencyModule:StyleCurrencyFrame(curId, curQuantity, i)
    if curId == nil then
        return 0
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    local icon = xb.constants.mediaPath .. 'datatexts\\garres'
    if tContains(self.rerollItems, curId) then
        icon = xb.constants.mediaPath .. 'datatexts\\reroll'
    end

    local quantity = curQuantity
    if quantity == nil and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        local curInfo = C_CurrencyInfo.GetCurrencyInfo(curId)
        if curInfo then
            quantity = curInfo.quantity
        end
    end

    if quantity == nil then
        return 0
    end

    local iconPoint = 'RIGHT'
    local textPoint = 'LEFT'
    local padding = -3

    if xb.db.profile.modules.currency.textOnRight then
        iconPoint = 'LEFT'
        textPoint = 'RIGHT'
        padding = -(padding)
    end

    self.curIcons[i]:ClearAllPoints()
    self.curText[i]:ClearAllPoints()

    self.curIcons[i]:SetTexture(icon)
    self.curIcons[i]:SetSize(iconSize, iconSize)
    self.curIcons[i]:SetPoint(iconPoint)
    self.curIcons[i]:SetVertexColor(xb:GetColor('normal'))

    self.curText[i]:SetFont(xb:GetFont(db.text.fontSize))
    self.curText[i]:SetTextColor(xb:GetColor('normal'))
    self.curText[i]:SetText(quantity)
    self.curText[i]:SetPoint(iconPoint, self.curIcons[i], textPoint, padding, 0)

    local buttonWidth = iconSize + self.curText[i]:GetStringWidth() + 5
    self.curButtons[i]:SetSize(buttonWidth, xb:GetHeight())
    self.curButtons[i]:Show()
    return buttonWidth
end

function CurrencyModule:CreateFrames()
    for i = 1, 3 do
        self.curButtons[i] = self.curButtons[i] or CreateFrame("BUTTON", nil, self.currencyFrame)
        self.curIcons[i] = self.curIcons[i] or self.curButtons[i]:CreateTexture(nil, 'OVERLAY')
        self.curText[i] = self.curText[i] or self.curButtons[i]:CreateFontString(nil, "OVERLAY")
        self.curButtons[i]:Hide()
    end

    self.xpFrame = self.xpFrame or CreateFrame("BUTTON", nil, self.currencyFrame)
    self.xpIcon = self.xpIcon or self.xpFrame:CreateTexture(nil, 'OVERLAY')
    self.xpText = self.xpText or self.xpFrame:CreateFontString(nil, 'OVERLAY')
    self.xpBar = self.xpBar or CreateFrame('STATUSBAR', nil, self.xpFrame)
    self.xpBarBg = self.xpBarBg or self.xpBar:CreateTexture(nil, 'BACKGROUND')
    self.xpFrame:Hide()
end

function CurrencyModule:RegisterFrameEvents()
    for i = 1, 3 do
        self.curButtons[i]:EnableMouse(true)
        self.curButtons[i]:RegisterForClicks("AnyUp")
        self.curButtons[i]:SetScript('OnEnter', function()
            if InCombatLockdown() then
                return;
            end
            self.curText[i]:SetTextColor(unpack(xb:HoverColors()))
            if xb.db.profile.modules.currency.showTooltip then
                self:ShowTooltip()
            end
        end)
        self.curButtons[i]:SetScript('OnLeave', function()
            if InCombatLockdown() then
                return;
            end
            local db = xb.db.profile
            self.curText[i]:SetTextColor(xb:GetColor('normal'))
            if db.modules.currency.showTooltip then
                GameTooltip:Hide()
            end
        end)
        self.curButtons[i]:SetScript('OnClick', function()
            if InCombatLockdown() then
                return;
            end
            ToggleCharacter('TokenFrame')
        end)
    end
    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Refresh')
    self:RegisterEvent('PLAYER_XP_UPDATE', 'XpUpdate')
    self:RegisterEvent('PLAYER_LEVEL_UP', 'XpUpdate')
    if _G.BackpackTokenFrame_Update then
        self:SecureHook('BackpackTokenFrame_Update', 'Refresh')
    end

    self.currencyFrame:EnableMouse(true)
    self.currencyFrame:SetScript('OnEnter', function()
        if xb.db.profile.modules.currency.showTooltip then
            self:ShowTooltip()
        end
    end)
    self.currencyFrame:SetScript('OnLeave', function()
        if xb.db.profile.modules.currency.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self.xpFrame:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return;
        end
        self.xpText:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.currency.showTooltip then
            self:ShowTooltip()
        end
    end)

    self.xpFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return;
        end
        self.xpText:SetTextColor(xb:GetColor('normal'))
        if xb.db.profile.modules.currency.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'tradeskillFrame' then
            self:Refresh()
        end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'tradeskillFrame' then
            self:Refresh()
        end
    end)
end

function CurrencyModule:ExperienceGains()
    CurXp = UnitXP('player')
    MaxXp = UnitXPMax('player')

    OldXp = OldXp or CurXp
    LastXp = LastXp or 0
    KillsRemaining = KillsRemaining or 0

    if CurXp < OldXp then
        if LastXp > 0 then
            KillsRemaining = MaxXp / LastXp
        else
            KillsRemaining = 0
        end
        OldXp = CurXp
        XpGained = 0
        return XpGained, CurXp, MaxXp, KillsRemaining
    end

    XpGained = CurXp - OldXp
    if XpGained > 0 then
        KillsRemaining = (MaxXp - CurXp) / XpGained
        LastXp = XpGained
    end

    OldXp = CurXp

    return XpGained, CurXp, MaxXp, KillsRemaining
end

function CurrencyModule:XpUpdate()
    CurrencyModule:ExperienceGains()
    CurrencyModule:Refresh()
end

function CurrencyModule:ShowTooltip()
    if not xb.db.profile.modules.currency.showTooltip then
        return
    end

    local r, g, b, _ = unpack(xb:HoverColors())

    GameTooltip:SetOwner(self.currencyFrame, 'ANCHOR_' .. xb.miniTextPosition)

    local maxLevel = GetMaxLevel()
    if xb.constants.playerLevel < maxLevel and xb.db.profile.modules.currency.showXPbar then
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. POWER_TYPE_EXPERIENCE .. "|cFFFFFFFF]|r", r, g, b)
        GameTooltip:AddLine(" ")

        local curXp = UnitXP('player')
        local maxXp = UnitXPMax('player')
        local rested = GetXPExhaustion()
        GameTooltip:AddDoubleLine(XP .. ':',
            string.format('%d / %d (%d%%)', curXp, maxXp, floor((curXp / maxXp) * 100)), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L['Remaining'] .. ':',
            string.format('%d (%d%%)', (maxXp - curXp), floor(((maxXp - curXp) / maxXp) * 100)), r, g, b, 1, 1, 1)
        if KillsRemaining then
            GameTooltip:AddDoubleLine(L['Kills to level'] .. ':',
                '~' .. string.format('%d', math.ceil(KillsRemaining)), r, g, b, 1, 1, 1)
        end
        if LastXp then
            GameTooltip:AddDoubleLine(L['Last xp gain'] .. ':',
                string.format('%d', LastXp), r, g, b, 1, 1, 1)
        end
        if rested then
            GameTooltip:AddDoubleLine(L['Rested'] .. ':',
                string.format('+%d (%d%%)', rested, floor((rested / maxXp) * 100)), r, g, b, 1, 1, 1)
        end
    else
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. CURRENCY .. "|cFFFFFFFF]|r", r, g, b)
        GameTooltip:AddLine(" ")

        if ShouldUseSelectedCurrencies() and C_CurrencyInfo then
            for i = 1, 3 do
                if xb.db.profile.modules.currency[self.intToOpt[i]] ~= '0' then
                    local curId = tonumber(xb.db.profile.modules.currency[self.intToOpt[i]])
                    local curInfo = C_CurrencyInfo.GetCurrencyInfo(curId)
                    if curInfo then
                        if curInfo.useTotalEarnedForMaxQty then
                            GameTooltip:AddDoubleLine(curInfo.name,
                                string.format('%d (%d/%d)', curInfo.quantity, curInfo.totalEarned,
                                    curInfo.maxQuantity), r, g, b, 1, 1, 1)
                        else
                            GameTooltip:AddDoubleLine(curInfo.name, string.format('%d', curInfo.quantity), r, g, b, 1,
                                1, 1)
                        end
                    end
                end
            end
        elseif GetNumWatchedTokens and type(GetNumWatchedTokens) == "function" then
            for i = 1, GetNumWatchedTokens() do
                local name, count = GetBackpackCurrencyInfo(i)
                GameTooltip:AddDoubleLine(name, string.format('%d', count), r, g, b, 1, 1, 1)
            end
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>', BINDING_NAME_TOGGLECURRENCY, r, g, b, 1, 1, 1)
    end

    GameTooltip:Show()
end

function CurrencyModule:GetCurrencyOptions()
    local curOpts = {
        ['0'] = ''
    }
    if not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyListSize then
        return curOpts
    end

    for i = 1, C_CurrencyInfo.GetCurrencyListSize() do
        local listInfo = C_CurrencyInfo.GetCurrencyListInfo(i)
        if not listInfo.isHeader and not listInfo.isTypeUnused then
            local cL = C_CurrencyInfo.GetCurrencyListLink(i)
            curOpts[tostring(C_CurrencyInfo.GetCurrencyIDFromLink(cL))] =
                C_CurrencyInfo.GetBasicCurrencyInfo(C_CurrencyInfo.GetCurrencyIDFromLink(cL)).name
        end
    end
    return curOpts
end

function CurrencyModule:GetDefaultOptions()
    return 'currency', {
        enabled = true,
        showXPbar = true,
        xpBarCC = false,
        showTooltip = true,
        textOnRight = true,
        currencyOne = '0',
        currencyTwo = '0',
        currencyThree = '0'
    }
end

function CurrencyModule:GetConfig()
    local args = {
        enable = {
            name = ENABLE,
            order = 0,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.enabled;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.enabled = val
                if val then
                    self:Enable()
                else
                    self:Disable()
                end
            end,
            width = "full"
        },
        showXPbar = {
            name = L['Show XP Bar Below Max Level'],
            order = 1,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.showXPbar;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.showXPbar = val;
                self:Refresh();
            end
        },
        xpBarCC = {
            name = L['Use Class Colors for XP Bar'],
            order = 2,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.xpBarCC;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.xpBarCC = val;
                self:Refresh();
            end,
            disabled = function()
                return not xb.db.profile.modules.currency.showXPbar
            end
        },
        showTooltip = {
            name = L['Show Tooltips'],
            order = 3,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.showTooltip;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.showTooltip = val;
                self:Refresh();
            end
        },
        textOnRight = {
            name = L['Text on Right'],
            order = 4,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.textOnRight;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.textOnRight = val;
                self:Refresh();
            end
        }
    }

    if ShouldUseSelectedCurrencies() then
        args.currency = {
            type = 'group',
            name = L['Currency Select'],
            order = 5,
            inline = true,
            args = {
                currencyOne = {
                    name = L['First Currency'],
                    type = "select",
                    order = 1,
                    values = function()
                        return self:GetCurrencyOptions();
                    end,
                    style = "dropdown",
                    get = function()
                        return xb.db.profile.modules.currency.currencyOne;
                    end,
                    set = function(info, value)
                        xb.db.profile.modules.currency.currencyOne = value;
                        self:Refresh();
                    end
                },
                currencyTwo = {
                    name = L['Second Currency'],
                    type = "select",
                    order = 2,
                    values = function()
                        return self:GetCurrencyOptions();
                    end,
                    style = "dropdown",
                    get = function()
                        return xb.db.profile.modules.currency.currencyTwo;
                    end,
                    set = function(info, value)
                        xb.db.profile.modules.currency.currencyTwo = value;
                        self:Refresh();
                    end
                },
                currencyThree = {
                    name = L['Third Currency'],
                    type = "select",
                    order = 3,
                    values = function()
                        return self:GetCurrencyOptions();
                    end,
                    style = "dropdown",
                    get = function()
                        return xb.db.profile.modules.currency.currencyThree;
                    end,
                    set = function(info, value)
                        xb.db.profile.modules.currency.currencyThree = value;
                        self:Refresh();
                    end
                }
            }
        }
    end

    return {
        name = self:GetName(),
        type = "group",
        args = args
    }
end
