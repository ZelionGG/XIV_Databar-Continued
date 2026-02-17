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
    return not compat.isClassicOrTBC
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

    -- Currency data may not have been available when GetConfig() ran during OnInitialize.
    -- Always rebuild config args here to catch data that loaded between OnInitialize and OnEnable.
    if ShouldUseSelectedCurrencies() and
        compat.GetCurrencyListSize() then
        if compat.GetCurrencyListSize() > 0 then
            -- Data is already loaded, rebuild config args now
            self:BuildCurrencySelectionArgs()
        else
            -- Data still not loaded, retry periodically
            self.currencyRetryTicker = C_Timer.NewTicker(0.5, function()
                if compat.GetCurrencyListSize() > 0 then
                    if self.currencyRetryTicker then
                        self.currencyRetryTicker:Cancel()
                        self.currencyRetryTicker = nil
                    end
                    self:BuildCurrencySelectionArgs()
                    self:Refresh()
                    -- Notify AceConfig to refresh the config panel if it's open
                    local AceConfigRegistry =
                        LibStub("AceConfigRegistry-3.0", true)
                    if AceConfigRegistry then
                        AceConfigRegistry:NotifyChange(AddOnName .. "_Modules")
                    end
                end
            end, 20) -- Max 20 attempts (10 seconds)
        end
    end
end

function CurrencyModule:OnDisable()
    self.currencyFrame:Hide()
    if self.currencyRetryTicker then
        self.currencyRetryTicker:Cancel()
        self.currencyRetryTicker = nil
    end
    self:UnregisterEvent('CURRENCY_DISPLAY_UPDATE')
    self:UnregisterEvent('PLAYER_XP_UPDATE')
    self:UnregisterEvent('PLAYER_LEVEL_UP')
end

function CurrencyModule:Refresh()
    local db = xb.db.profile
    xb.constants.playerLevel = UnitLevel("player")
    local maxLevel = GetMaxLevel()
    local effectiveMaxLevel = (_G.GetMaxLevelForPlayerExpansion and GetMaxLevelForPlayerExpansion()) or maxLevel
    local xpLocked = IsXPUserDisabled() or (UnitXPMax('player') or 0) <= 0
    if InCombatLockdown() then
        if xb.constants.playerLevel < effectiveMaxLevel and db.modules.currency.showXPbar and not xpLocked then
            self.xpBar:SetMinMaxValues(0, UnitXPMax('player'))
            self.xpBar:SetValue(UnitXP('player'))
            self.xpText:SetFont(xb:GetFont(db.text.fontSize))
            self.xpText:SetTextColor(xb:GetColor('normal'))
            self.xpText:SetText(string.upper(LEVEL .. ' ' .. UnitLevel("player") .. ' ' .. UnitClass('player')))
        else
            self.xpFrame:Hide()
            self.moduleIconFrame:Hide()
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
    self.moduleIconFrame:Hide()

    if xb.constants.playerLevel < effectiveMaxLevel and db.modules.currency.showXPbar and not xpLocked then
        local textHeight = floor((xb:GetHeight() - 4) / 2)
        local barHeight = (iconSize - textHeight - 2)
        if barHeight < 2 then
            barHeight = 2
        end
        local barYOffset = floor((xb:GetHeight() - iconSize) / 2)
        if barYOffset < 0 then
            barYOffset = 0
        end
        self.xpIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\exp')
        self.xpIcon:SetSize(iconSize, iconSize)
        self.xpIcon:ClearAllPoints()
        self.xpIcon:SetPoint('LEFT')
        self.xpIcon:SetVertexColor(xb:GetColor('normal'))

        self.xpText:SetFont(xb:GetFont(db.text.fontSize))
        self.xpText:SetTextColor(xb:GetColor('normal'))
        self.xpText:SetText(string.upper(LEVEL .. ' ' .. UnitLevel("player") .. ' ' .. UnitClass('player')))
        self.xpText:ClearAllPoints()
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
        self.xpBar:ClearAllPoints()
        self.xpBar:SetPoint('BOTTOMLEFT', self.xpFrame, 'BOTTOMLEFT', iconSize + 5, barYOffset)

        self.xpBarBg:SetAllPoints()
        self.xpBarBg:SetColorTexture(db.color.inactive.r, db.color.inactive.g, db.color.inactive.b, db.color.inactive.a)
        self.currencyFrame:SetSize(iconSize + self.xpText:GetStringWidth() + 5, xb:GetHeight())
        self.xpFrame:SetAllPoints()
        self.xpFrame:Show()
    elseif not compat.isClassicOrTBC then
        -- Check if 'icon only' mode is enabled
        if db.modules.currency.showOnlyModuleIcon then
            -- Show only the module icon
            local icon = xb.constants.mediaPath .. 'datatexts\\garres'
            self.moduleIcon:SetTexture(icon)
            self.moduleIcon:SetSize(iconSize, iconSize)
            self.moduleIcon:SetPoint('RIGHT')
            self.moduleIcon:SetVertexColor(xb:GetColor('normal'))
            self.moduleIconFrame:SetSize(iconSize, xb:GetHeight())
            self.moduleIconFrame:SetPoint('RIGHT', self.currencyFrame, 'RIGHT', 0, 0)
            self.moduleIconFrame:Show()
            self.currencyFrame:SetSize(iconSize, xb:GetHeight())
        else
            local iconsWidth = 0
            local buttonIndex = 1
            local maxCurrencies = db.modules.currency.numCurrenciesOnBar or 3
            if ShouldUseSelectedCurrencies() then
                local selectedCurrencies = db.modules.currency.selectedCurrencies
                for i, currencyId in ipairs(selectedCurrencies) do
                    if buttonIndex <= maxCurrencies then
                        local width = self:StyleCurrencyFrame(currencyId, nil, buttonIndex)
                        if width > 0 then
                            iconsWidth = iconsWidth + width
                            if buttonIndex == 1 then
                                self.curButtons[1]:SetPoint('RIGHT')
                            elseif buttonIndex == 2 then
                                self.curButtons[2]:SetPoint('RIGHT', self.curButtons[1], 'LEFT', -5, 0)
                            elseif buttonIndex == 3 then
                                self.curButtons[3]:SetPoint('RIGHT', self.curButtons[2], 'LEFT', -5, 0)
                            end
                            buttonIndex = buttonIndex + 1
                        end
                    end
                end
            elseif GetNumWatchedTokens and type(GetNumWatchedTokens) == "function" then
                for i = 1, GetNumWatchedTokens() do
                    local name, count, _, currencyID = GetBackpackCurrencyInfo(i)
                    if name then
                        iconsWidth = iconsWidth + self:StyleCurrencyFrame(currencyID, count, i)
                        if i == 1 then
                            self.curButtons[1]:SetPoint('RIGHT')
                        elseif i == 2 then
                            self.curButtons[2]:SetPoint('RIGHT', self.curButtons[1], 'LEFT', -5, 0)
                        elseif i == 3 then
                            self.curButtons[3]:SetPoint('RIGHT', self.curButtons[2], 'LEFT', -5, 0)
                        end
                    end
                end
            end
            self.currencyFrame:SetSize(iconsWidth, xb:GetHeight())
        end
        -- Hide XP frame explicitly when XP is locked or not shown
        self.xpFrame:Hide()
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
    self.currencyFrame:ClearAllPoints()
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
    if quantity == nil then
        local curInfo = C_CurrencyInfo.GetCurrencyInfoFromLink(curId)
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

    -- Module icon frame for 'icon only' mode
    self.moduleIconFrame = self.moduleIconFrame or CreateFrame("BUTTON", nil, self.currencyFrame)
    self.moduleIcon = self.moduleIcon or self.moduleIconFrame:CreateTexture(nil, 'OVERLAY')
    self.moduleIconFrame:Hide()
end

function CurrencyModule:RegisterFrameEvents()
    for i = 1, 3 do
        local buttonIndex = i  -- Capture index for closures
        self.curButtons[buttonIndex]:EnableMouse(true)
        self.curButtons[buttonIndex]:RegisterForClicks("AnyUp")
        self.curButtons[buttonIndex]:SetScript('OnEnter', function()
            if InCombatLockdown() then
                return;
            end
            self.curText[buttonIndex]:SetTextColor(unpack(xb:HoverColors()))
            if xb.db.profile.modules.currency.showTooltip then
                self:ShowTooltip()
            end
        end)
        self.curButtons[buttonIndex]:SetScript('OnLeave', function()
            if InCombatLockdown() then
                return;
            end
            local db = xb.db.profile
            self.curText[buttonIndex]:SetTextColor(xb:GetColor('normal'))
            if db.modules.currency.showTooltip then
                GameTooltip:Hide()
            end
        end)
        self.curButtons[buttonIndex]:SetScript('OnClick', function()
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

    -- Module icon frame events for 'icon only' mode
    self.moduleIconFrame:EnableMouse(true)
    self.moduleIconFrame:RegisterForClicks("AnyUp")
    self.moduleIconFrame:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return;
        end
        self.moduleIcon:SetVertexColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.currency.showTooltip then
            self:ShowTooltip()
        end
    end)
    self.moduleIconFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return;
        end
        self.moduleIcon:SetVertexColor(xb:GetColor('normal'))
        if xb.db.profile.modules.currency.showTooltip then
            GameTooltip:Hide()
        end
    end)
    self.moduleIconFrame:SetScript('OnClick', function()
        if InCombatLockdown() then
            return;
        end
        ToggleCharacter('TokenFrame')
    end)

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
    local effectiveMaxLevel = (_G.GetMaxLevelForPlayerExpansion and GetMaxLevelForPlayerExpansion()) or maxLevel
    local xpLocked = IsXPUserDisabled() or (UnitXPMax('player') or 0) <= 0

    if xb.constants.playerLevel < effectiveMaxLevel and xb.db.profile.modules.currency.showXPbar and not xpLocked then
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

        -- Display selected currencies grouped by categories
        local selectedCurrencies = xb.db.profile.modules.currency.selectedCurrencies
        local showAllOnShift = xb.db.profile.modules.currency.showMoreCurrenciesOnShift
        local shiftIsDown = IsShiftKeyDown()
        local showAllCurrencies = showAllOnShift and shiftIsDown
        local maxCurrencies = xb.db.profile.modules.currency.maxCurrenciesTooltipShift or 30
        local currencyCount = 0

        if #selectedCurrencies > 0 then
            -- Create a set to quickly check if a currency is selected
            local selectedSet = {}
            for _, currencyId in ipairs(selectedCurrencies) do
                selectedSet[currencyId] = true
            end

            -- Get currencies by expansion for ordering
            local expansionCurrencies = self:GetCurrenciesByExpansion()

            for _, expansionData in ipairs(expansionCurrencies) do
                -- Stop if we reached the limit (only when showing all currencies)
                if showAllCurrencies and currencyCount >= maxCurrencies then
                    break
                end

                local hasCurrencyInCategory = false
                local currenciesToShow = {}

                -- Check if this category has selected currencies (or show more if Shift is held)
                for _, currencyInfo in ipairs(expansionData.currencies) do
                    if showAllCurrencies then
                        -- When showing all, respect the limit
                        if currencyCount + #currenciesToShow < maxCurrencies then
                            hasCurrencyInCategory = true
                            table.insert(currenciesToShow, currencyInfo)
                        end
                    elseif selectedSet[currencyInfo.id] then
                        hasCurrencyInCategory = true
                        table.insert(currenciesToShow, currencyInfo)
                    end
                end

                -- Display header (except Legacy) and currencies
                if hasCurrencyInCategory then
                    -- Add golden header except if it's Legacy
                    if expansionData.header ~= "Legacy" then
                        GameTooltip:AddLine('-- ' .. expansionData.header .. ' --', 1, 0.82, 0)  -- Golden color
                    end

                    -- Display currencies from this category
                    for _, currencyInfo in ipairs(currenciesToShow) do
                        local curInfo = C_CurrencyInfo.GetCurrencyInfoFromLink(currencyInfo.id)
                        if curInfo then
                            local iconString = string.format("|T%s:16:16:0:0|t ", curInfo.iconFileID or "")
                            local quantityText = tostring(curInfo.quantity)
                            local isAtMax = false

                            -- Check if currency has a max quantity (like Valorstones with 2000 cap)
                            if curInfo.maxQuantity and curInfo.maxQuantity > 0 then
                                -- Check if at max capacity (seasonal or possession cap)
                                if curInfo.useTotalEarnedForMaxQty and curInfo.totalEarned then
                                    -- For seasonal currencies: check totalEarned against max
                                    if curInfo.totalEarned >= curInfo.maxQuantity then
                                        isAtMax = true
                                    end
                                else
                                    -- For possession cap currencies
                                    if curInfo.quantity >= curInfo.maxQuantity then
                                        isAtMax = true
                                    end
                                end

                                -- For currencies with weekly or total caps
                                if curInfo.useTotalEarnedForMaxQty and curInfo.totalEarned then
                                    -- Show: quantity (earned/max)
                                    quantityText = string.format('%d (%d/%d)', curInfo.quantity, curInfo.totalEarned, curInfo.maxQuantity)
                                else
                                    -- Show: quantity/max
                                    quantityText = string.format('%d/%d', curInfo.quantity, curInfo.maxQuantity)
                                end
                            end

                            -- Use red color if at max, otherwise white
                            local qtyR, qtyG, qtyB = 1, 1, 1
                            if isAtMax then
                                qtyR, qtyG, qtyB = 1, 0, 0  -- Red
                            end

                            GameTooltip:AddDoubleLine(iconString .. curInfo.name, quantityText, r, g, b, qtyR, qtyG, qtyB)
                            currencyCount = currencyCount + 1
                        end
                    end

                    -- Add space between categories (except after Legacy if no header)
                    if expansionData.header ~= "Legacy" then
                        GameTooltip:AddLine(" ")
                    end
                end
            end
        elseif GetNumWatchedTokens and type(GetNumWatchedTokens) == "function" then
            for i = 1, GetNumWatchedTokens() do
                local name, count = GetBackpackCurrencyInfo(i)
                GameTooltip:AddDoubleLine(name, string.format('%d', count), r, g, b, 1, 1, 1)
            end
        end

        GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>', BINDING_NAME_TOGGLECURRENCY, r, g, b, 1, 1, 1)
    end

    GameTooltip:Show()
end

function CurrencyModule:GetCurrencyOptions()
    local curOpts = {
        ['0'] = ''
    }
    if not compat.GetCurrencyListSize then
        return curOpts
    end

    for i = 1, compat.GetCurrencyListSize() do
        local listInfo = compat.GetCurrencyListInfo(i)
        if listInfo and not listInfo.isHeader and not listInfo.isTypeUnused then
            local cL = compat.GetCurrencyListLink(i)
            curOpts[tostring(compat.GetCurrencyIDFromLink(cL))] =
                compat.GetBasicCurrencyInfo(compat.GetCurrencyIDFromLink(cL)).name
        end
    end
    return curOpts
end

function CurrencyModule:GetCurrenciesByExpansion()
    local expansionCurrencies = {}
    if not compat.GetCurrencyListSize then
        return expansionCurrencies
    end

    local currentHeader = nil
    local currentHeaderIndex = nil

    for i = 1, compat.GetCurrencyListSize() do
        local listInfo = compat.GetCurrencyListInfo(i)
        if not listInfo then
            -- Skip nil entries (can happen when switching characters)
        elseif listInfo.isHeader then
            compat.ExpandCurrencyList(i, true)
            currentHeader = listInfo.name
            currentHeaderIndex = #expansionCurrencies + 1
            table.insert(expansionCurrencies, {
                header = currentHeader,
                currencies = {}
            })
        elseif not listInfo.isTypeUnused and currentHeader and currentHeaderIndex then
            local cL = compat.GetCurrencyListLink(i)
            local curInfo = C_CurrencyInfo.GetCurrencyInfoFromLink(cL)
            if curInfo then
                table.insert(expansionCurrencies[currentHeaderIndex].currencies, {
                    id = cL,
                    name = curInfo.name,
                    iconFileID = curInfo.iconFileID,
                    index = i
                })
            end
        end
    end
    return expansionCurrencies
end

function CurrencyModule:GetDefaultOptions()
    return 'currency', {
        enabled = true,
        showXPbar = true,
        xpBarCC = false,
        showTooltip = true,
        textOnRight = true,
        showOnlyModuleIcon = false,
        numCurrenciesOnBar = 3,
        selectedCurrencies = {},  -- Array of selected currency IDs
        showMoreCurrenciesOnShift = false,  -- Setting to display more currencies while using Shift+Hover
        maxCurrenciesTooltipShift = 30  -- Maximum number of currencies displayed during Shift+Hover
    }
end

function CurrencyModule:GetConfig()
    local hasCurrencyUI = compat.features and compat.features.currency and compat.features.currency.available
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
            end,
            hidden = function()
                return not hasCurrencyUI
            end
        },
        showOnlyModuleIcon = {
            name = L['Only Show Module Icon'],
            order = 5,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.showOnlyModuleIcon;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.showOnlyModuleIcon = val;
                self:Refresh();
            end,
            hidden = function()
                return not hasCurrencyUI
            end
        },
        numCurrenciesOnBar = {
            name = L['Number of Currencies on Bar'],
            order = 6,
            type = "range",
            min = 1,
            max = 3,
            step = 1,
            get = function()
                return xb.db.profile.modules.currency.numCurrenciesOnBar;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.numCurrenciesOnBar = val;
                self:Refresh();
            end,
            disabled = function()
                return xb.db.profile.modules.currency.showOnlyModuleIcon
            end,
            hidden = function()
                return not hasCurrencyUI
            end
        },
        showMoreCurrenciesOnShift = {
            name = L['Show More Currencies on Shift+Hover'],
            order = 7,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.currency.showMoreCurrenciesOnShift;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.showMoreCurrenciesOnShift = val;
                self:Refresh();
            end,
            hidden = function()
                return not hasCurrencyUI
            end
        },
        maxCurrenciesTooltipShift = {
            name = L['Max currencies shown when holding Shift'],
            order = 8,
            type = "range",
            min = 10,
            max = 50,
            step = 1,
            get = function()
                return xb.db.profile.modules.currency.maxCurrenciesTooltipShift;
            end,
            set = function(_, val)
                xb.db.profile.modules.currency.maxCurrenciesTooltipShift = val;
                self:Refresh();
            end,
            disabled = function()
                return not xb.db.profile.modules.currency
                           .showMoreCurrenciesOnShift
            end,
            hidden = function() return not hasCurrencyUI end
        }
    }

    if ShouldUseSelectedCurrencies() and hasCurrencyUI then
        -- Currency selection uses a mutable args table that is rebuilt when currency data becomes available.
        -- This fixes the "0 currency" bug: at OnInitialize time, GetCurrencyListSize() returns 0,
        -- so we populate the args later when the data is loaded.
        self.currencySelectionArgs = self.currencySelectionArgs or {}
        args['currency_selection'] = {
            type = 'group',
            name = L['Currency Selection'],
            order = 9,
            inline = true,
            args = self.currencySelectionArgs
        }
        -- Populate immediately (will be empty if data isn't loaded yet)
        self:BuildCurrencySelectionArgs()
    end

    return {name = self:GetName(), type = "group", args = args}
end

-- Rebuilds the currency selection toggles in the config panel.
-- Called from GetConfig() and also from the retry ticker when data becomes available.
function CurrencyModule:BuildCurrencySelectionArgs()
    if not self.currencySelectionArgs then return end

    -- Wipe existing entries
    for k in pairs(self.currencySelectionArgs) do
        self.currencySelectionArgs[k] = nil
    end

    local expansionCurrencies = self:GetCurrenciesByExpansion()
    local order = 1

    -- Select All / Unselect All buttons
    self.currencySelectionArgs['selectAll'] = {
        name = L['Select All'],
        type = "execute",
        order = order,
        func = function()
            local freshExpansions = self:GetCurrenciesByExpansion()
            local allCurrencies = {}
            for _, expansionData in ipairs(freshExpansions) do
                for _, currencyInfo in ipairs(expansionData.currencies) do
                    table.insert(allCurrencies, currencyInfo.id)
                end
            end
            xb.db.profile.modules.currency.selectedCurrencies = allCurrencies
            self:Refresh()
        end
    }
    order = order + 1

    self.currencySelectionArgs['unselectAll'] = {
        name = L['Unselect All'],
        type = "execute",
        order = order,
        func = function()
            xb.db.profile.modules.currency.selectedCurrencies = {}
            self:Refresh()
        end
    }
    order = order + 1

    for _, expansionData in ipairs(expansionCurrencies) do
        if expansionData.header == "Legacy" then
            self.currencySelectionArgs['header_legacy'] = {
                type = 'header',
                name = expansionData.header,
                order = order
            }
            order = order + 1

            for _, currencyInfo in ipairs(expansionData.currencies) do
                local iconString = string.format("|T%s:16:16:0:0|t ",
                                                 currencyInfo.iconFileID or "")
                self.currencySelectionArgs['currency_' .. currencyInfo.id] = {
                    name = iconString .. currencyInfo.name,
                    type = "toggle",
                    order = order,
                    get = function()
                        local selected =
                            xb.db.profile.modules.currency.selectedCurrencies
                        for _, id in ipairs(selected) do
                            if id == currencyInfo.id then
                                return true
                            end
                        end
                        return false
                    end,
                    set = function(_, val)
                        local selected =
                            xb.db.profile.modules.currency.selectedCurrencies
                        if val then
                            table.insert(selected, currencyInfo.id)
                        else
                            for i, id in ipairs(selected) do
                                if id == currencyInfo.id then
                                    table.remove(selected, i)
                                    break
                                end
                            end
                        end
                        self:Refresh()
                    end
                }
                order = order + 1
            end
        else
            local expansionArgs = {}
            local expansionOrder = 1

            for _, currencyInfo in ipairs(expansionData.currencies) do
                local iconString = string.format("|T%s:16:16:0:0|t ",
                                                 currencyInfo.iconFileID or "")
                expansionArgs['currency_' .. currencyInfo.id] = {
                    name = iconString .. currencyInfo.name,
                    type = "toggle",
                    order = expansionOrder,
                    get = function()
                        local selected =
                            xb.db.profile.modules.currency.selectedCurrencies
                        for _, id in ipairs(selected) do
                            if id == currencyInfo.id then
                                return true
                            end
                        end
                        return false
                    end,
                    set = function(_, val)
                        local selected =
                            xb.db.profile.modules.currency.selectedCurrencies
                        if val then
                            table.insert(selected, currencyInfo.id)
                        else
                            for i, id in ipairs(selected) do
                                if id == currencyInfo.id then
                                    table.remove(selected, i)
                                    break
                                end
                            end
                        end
                        self:Refresh()
                    end
                }
                expansionOrder = expansionOrder + 1
            end

            self.currencySelectionArgs['expansion_' .. expansionData.header] = {
                type = 'group',
                name = expansionData.header,
                order = order,
                inline = true,
                args = expansionArgs
            }
            order = order + 1
        end
    end
end
