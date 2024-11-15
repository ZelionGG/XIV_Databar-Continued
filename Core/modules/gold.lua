local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local GoldModule = xb:NewModule("GoldModule", 'AceEvent-3.0')

local isSessionNegative, isDailyNegative = false, false
local positiveSign = "|cff00ff00+ "
local negativeSign = "|cffff0000- "

local function shortenNumber(num)
    if num < 1000 then
        return tostring(num)
    elseif num < 1000000 then
        return format("%.1f" .. L['k'], num / 1000)
    elseif num < 1000000000 then
        return format("%.2f" .. L['M'], num / 1000000)
    else
        return format("%.3f" .. L['B'], num / 1000000000)
    end
end

local function moneyWithTexture(amount, session)
    local copper, silver = 0, 0;
    local showSC = xb.db.profile.modules.gold.showSmallCoins
    local shortThousands = xb.db.profile.modules.gold.shortThousands
    local shortGold = ""

    amount, copper = math.modf(amount / 100.0)
    amount, silver = math.modf(amount / 100.0)

    silver = silver * 100
    copper = copper * 100

    silver = string.format("%02d", silver)
    copper = string.format("%02d", copper)

    amount = string.format("%.0f", amount)

    if not showSC then
        silver, copper = "00", "00"
    end

    amountStringTexture = C_CurrencyInfo.GetCoinTextureString(amount .. "" .. silver .. "" .. copper)

    if shortThousands then
        shortGold = shortenNumber(tonumber(amount))
        amountStringTexture = amountStringTexture:gsub(amount .. "|T", shortGold .. "|T")
    end

    if not session then
        return amountStringTexture
    else
        return isSessionNegative and negativeSign .. amountStringTexture or amountStringTexture
    end
end

local function ConvertDateToNumber(month, day, year)
    month = gsub(month, "(%d)(%d?)", function(d1, d2)
        return d2 == "" and "0" .. d1 or d1 .. d2
    end) -- converts M to MM
    day = gsub(day, "(%d)(%d?)", function(d1, d2)
        return d2 == "" and "0" .. d1 or d1 .. d2
    end) -- converts D to DD

    return tonumber(year .. month .. day)
end

function GoldModule:GetName()
    return BONUS_ROLL_REWARD_MONEY;
end

function GoldModule:OnInitialize()
    local fullCharName = xb.constants.playerName .. "-" .. xb.constants.playerRealm
    if not xb.db.global.characters[fullCharName] then
        xb.db.global.characters[fullCharName] = {
            currentMoney = 0,
            sessionMoney = 0,
            dailyMoney = 0,
            faction = select(1, UnitFactionGroup("player")),
            class = select(2, UnitClass("player")),
            realm = xb.constants.playerRealm
        }
    else
        if not xb.db.global.characters[fullCharName].dailyMoney then
            xb.db.global.characters[fullCharName].dailyMoney = 0
        end
        if not xb.db.global.characters[fullCharName].faction then
            xb.db.global.characters[fullCharName].faction = select(1, UnitFactionGroup("player"))
        end
        if not xb.db.global.characters[fullCharName].class then
            xb.db.global.characters[fullCharName].class = select(2, UnitClass("player"))
        end
        if not xb.db.global.characters[fullCharName].realm then
            xb.db.global.characters[fullCharName].realm = xb.constants.playerRealm
        end
    end

    local playerData = xb.db.global.characters[fullCharName]

    local curDate = C_DateAndTime.GetCurrentCalendarTime()
    local today = ConvertDateToNumber(curDate.month, curDate.monthDay, curDate.year)

    if playerData.lastLoginDate then
        if playerData.lastLoginDate < today then -- is true, if last time player logged in was the day before or even earlier
            playerData.lastLoginDate = today
            playerData.daily = 0
        end
    else
        playerData.lastLoginDate = today
    end
end

function GoldModule:OnEnable()
    if self.goldFrame == nil then
        self.goldFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('goldFrame', self.goldFrame)
    end
    self.goldFrame:Show()

    local fullCharName = xb.constants.playerName .. "-" .. xb.constants.playerRealm
    xb.db.global.characters[fullCharName].sessionMoney = 0
    xb.db.global.characters[fullCharName].currentMoney = GetMoney()

    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
    listAllCharactersByFactionRealm()
end

function GoldModule:OnDisable()
    self.goldFrame:Hide()
    self:UnregisterEvent('PLAYER_MONEY')
    self:UnregisterEvent('BAG_UPDATE')
end

function GoldModule:Refresh()
    local db = xb.db.profile
    if self.goldFrame == nil then
        return;
    end
    if not db.modules.gold.enabled then
        self:Disable();
        return;
    end

    if InCombatLockdown() then
        self.goldText:SetFont(xb:GetFont(db.text.fontSize))
        self.goldText:SetText(self:FormatCoinText(GetMoney()))
        if db.modules.gold.showFreeBagSpace then
            local freeSpace = 0
            for i = 0, 4 do
                freeSpace = freeSpace + C_Container.GetContainerNumFreeSlots(i)
            end
            self.bagText:SetFont(xb:GetFont(db.text.fontSize))
            self.bagText:SetText('(' .. tostring(freeSpace) .. ')')
        end
        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    self.goldIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\gold')
    self.goldIcon:SetSize(iconSize, iconSize)
    self.goldIcon:SetPoint('LEFT')
    self.goldIcon:SetVertexColor(xb:GetColor('normal'))

    self.goldText:SetFont(xb:GetFont(db.text.fontSize))
    self.goldText:SetTextColor(xb:GetColor('normal'))
    self.goldText:SetText(self:FormatCoinText(GetMoney()))
    self.goldText:SetPoint('LEFT', self.goldIcon, 'RIGHT', 5, 0)

    local bagWidth = 0
    if db.modules.gold.showFreeBagSpace then
        local freeSpace = 0
        for i = 0, 4 do
            freeSpace = freeSpace + C_Container.GetContainerNumFreeSlots(i)
        end
        self.bagText:SetFont(xb:GetFont(db.text.fontSize))
        self.bagText:SetTextColor(xb:GetColor('normal'))
        self.bagText:SetText('(' .. tostring(freeSpace) .. ')')
        self.bagText:SetPoint('LEFT', self.goldText, 'RIGHT', 5, 0)
        bagWidth = self.bagText:GetStringWidth()
    else
        self.bagText:SetFont(xb:GetFont(db.text.fontSize))
        self.bagText:SetText('')
        self.bagText:SetSize(0, 0)
    end

    self.goldButton:SetSize(self.goldText:GetStringWidth() + iconSize + 10 + bagWidth, iconSize)
    self.goldButton:SetPoint('LEFT')

    self.goldFrame:SetSize(self.goldButton:GetSize())

    local relativeAnchorPoint = 'LEFT'
    local xOffset = db.general.moduleSpacing
    local parentFrame = xb:GetFrame('travelFrame')
    if not xb.db.profile.modules.travel.enabled then -- xb.db.profile.modules.travel.enabled
        parentFrame = self.goldFrame:GetParent()
        relativeAnchorPoint = 'RIGHT'
        xOffset = 5
    end
    self.goldFrame:SetPoint('RIGHT', parentFrame, relativeAnchorPoint, -(xOffset), 0)
end

function GoldModule:CreateFrames()
    self.goldButton = self.goldButton or CreateFrame("BUTTON", nil, self.goldFrame)
    self.goldIcon = self.goldIcon or self.goldButton:CreateTexture(nil, 'OVERLAY')
    self.goldText = self.goldText or self.goldButton:CreateFontString(nil, "OVERLAY")
    self.bagText = self.bagText or self.goldButton:CreateFontString(nil, "OVERLAY")
end

function GoldModule:RegisterFrameEvents()
    self.goldButton:EnableMouse(true)
    self.goldButton:RegisterForClicks("AnyUp")

    self:RegisterEvent('PLAYER_MONEY')
    self:RegisterEvent('BAG_UPDATE', 'Refresh')

    self.goldButton:SetScript('OnEnter', function()
        if InCombatLockdown() then
            return;
        end
        self.goldText:SetTextColor(unpack(xb:HoverColors()))
        self.bagText:SetTextColor(unpack(xb:HoverColors()))

        GameTooltip:SetOwner(GoldModule.goldFrame, 'ANCHOR_' .. xb.miniTextPosition, 0, 6)
        local r, g, b, _ = unpack(xb:HoverColors())
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. BONUS_ROLL_REWARD_MONEY .. "|cFFFFFFFF]|r",
            r, g, b)
        if not xb.db.profile.modules.gold.showSmallCoins then
            GameTooltip:AddLine(L["Gold rounded values"], 1, 1, 1)
        end
        GameTooltip:AddLine(" ")

        local fullCharName = xb.constants.playerName .. "-" .. xb.constants.playerRealm
        GameTooltip:AddDoubleLine(L['Session Total'], moneyWithTexture(
            math.abs(xb.db.global.characters[fullCharName].sessionMoney), true), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L['Daily Total'], moneyWithTexture(
            math.abs(xb.db.global.characters[fullCharName].dailyMoney), true), r, g, b, 1, 1, 1)
        GameTooltip:AddLine(" ")

        -- Sort characters by realm
        local realmCharacters = {}
        local sortedRealms = {}
        for charName, goldData in pairs(xb.db.global.characters) do
            local realm = goldData.realm or "Unknown Realm"
            realmCharacters[realm] = realmCharacters[realm] or {}
            realmCharacters[realm][charName] = goldData
            -- Add realm to sorted list if not already present
            local found = false
            for _, existingRealm in ipairs(sortedRealms) do
                if existingRealm == realm then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(sortedRealms, realm)
            end
        end

        -- Sort realms alphabetically
        table.sort(sortedRealms)

        -- Move current realm to the top if it exists
        local currentRealm = xb.constants.playerRealm
        for i, realm in ipairs(sortedRealms) do
            if realm == currentRealm then
                table.remove(sortedRealms, i)
                table.insert(sortedRealms, 1, realm)
                break
            end
        end

        local totalGold = 0
        -- Display characters grouped by realm
        for _, realm in ipairs(sortedRealms) do
            -- Skip other realms if showOtherRealms is disabled
            if xb.db.profile.modules.gold.showOtherRealms or realm == currentRealm then
                -- Calculate realm total
                local realmTotal = 0
                for _, goldData in pairs(realmCharacters[realm]) do
                    realmTotal = realmTotal + goldData.currentMoney
                end
                
                GameTooltip:AddDoubleLine("|cff82c5ff" .. realm .. "|r", moneyWithTexture(realmTotal), nil, nil, nil, 1, 1, 1)
                
                for charName, goldData in pairs(realmCharacters[realm]) do
                    local charClass = goldData.class
                    local cc_r, cc_g, cc_b = 1, 1, 1
                    if charClass then
                        cc_r = RAID_CLASS_COLORS[charClass].r
                        cc_g = RAID_CLASS_COLORS[charClass].g
                        cc_b = RAID_CLASS_COLORS[charClass].b
                    end
                    local factionIcon = ""
                    if goldData.faction then
                        factionIcon = goldData.faction == "Alliance" and "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t " or "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t "
                    end
                    -- Extract just the character name part before any hyphens
                    local displayName = charName:match("^([^-]+)")
                    GameTooltip:AddDoubleLine(factionIcon .. displayName, moneyWithTexture(goldData.currentMoney), cc_r, cc_g, cc_b, 1, 1, 1)
                    totalGold = totalGold + goldData.currentMoney
                end
                GameTooltip:AddLine(" ")  -- Add space between realms
            end
        end

        GameTooltip:AddDoubleLine(TOTAL, GoldModule:FormatCoinText(totalGold), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>', L['Toggle Bags'], r, g, b, 1, 1, 1)
        GameTooltip:Show()
    end)

    self.goldButton:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return;
        end
        local db = xb.db.profile
        self.goldText:SetTextColor(xb:GetColor('normal'))
        self.bagText:SetTextColor(xb:GetColor('normal'))
        GameTooltip:Hide()
    end)

    self.goldButton:SetScript('OnClick', function(_, button)
        if InCombatLockdown() then
            return;
        end
        ToggleAllBags()
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'travelFrame' then
            self:Refresh()
        end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'travelFrame' then
            self:Refresh()
        end
    end)
end

function GoldModule:PLAYER_MONEY()
    local fullCharName = xb.constants.playerName .. "-" .. xb.constants.playerRealm
    local gdb = xb.db.global.characters[fullCharName]
    local curMoney = gdb.currentMoney
    local tmpMoney = GetMoney()
    local moneyDiff = tmpMoney - curMoney

    gdb.sessionMoney = gdb.sessionMoney + moneyDiff
    gdb.dailyMoney = gdb.dailyMoney + moneyDiff

    isSessionNegative = gdb.sessionMoney < 0
    isDailyNegative = gdb.dailyMoney < 0
    gdb.currentMoney = tmpMoney
    self:Refresh()
end

function GoldModule:FormatCoinText(money)
    local showSC = xb.db.profile.modules.gold.showSmallCoins
    if money == 0 then
        return showSC and
                   string.format(
                "%s" .. GOLD_AMOUNT_SYMBOL .. " %s" .. SILVER_AMOUNT_SYMBOL .. " %s" .. COPPER_AMOUNT_SYMBOL, 0, 0, 0) or
                   money .. GOLD_AMOUNT_SYMBOL
    end

    local shortThousands = xb.db.profile.modules.gold.shortThousands
    local g, s, c = self:SeparateCoins(money)

    if showSC then
        return (shortThousands and shortenNumber(g) or BreakUpLargeNumbers(g)) .. GOLD_AMOUNT_SYMBOL .. ' ' .. s ..
                   SILVER_AMOUNT_SYMBOL .. ' ' .. c .. COPPER_AMOUNT_SYMBOL
    else
        return g > 0 and (shortThousands and shortenNumber(g) .. GOLD_AMOUNT_SYMBOL) or BreakUpLargeNumbers(g) ..
                   GOLD_AMOUNT_SYMBOL
    end
end

function GoldModule:SeparateCoins(money)
    local gold, silver, copper = floor(abs(money / 10000)), floor(abs(mod(money / 100, 100))),
        floor(abs(mod(money, 100)))
    return gold, silver, copper
end

function listAllCharactersByFactionRealm()
    local optTable = {
        header = {
            name = "|cff82c5ff" .. L["Characters"] .. "|r",
            type = "header",
            order = 0
        },
        footer = {
            name = "All the characters listed above are currently registered in the gold database. To delete one or several character, plase uncheck the box correponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), untill you reload or logout/login",
            type = "description",
            order = -1
        }
    }

    -- Sort characters by realm
    local realmCharacters = {}
    local sortedRealms = {}
    for charName, charData in pairs(xb.db.global.characters) do
        local realm = charData.realm or "Unknown Realm"
        realmCharacters[realm] = realmCharacters[realm] or {}
        realmCharacters[realm][charName] = charData
        -- Add realm to sorted list if not already present
        local found = false
        for _, existingRealm in ipairs(sortedRealms) do
            if existingRealm == realm then
                found = true
                break
            end
        end
        if not found then
            table.insert(sortedRealms, realm)
        end
    end

    -- Sort realms alphabetically
    table.sort(sortedRealms)

    -- Move current realm to the top if it exists
    local currentRealm = xb.constants.playerRealm
    for i, realm in ipairs(sortedRealms) do
        if realm == currentRealm then
            table.remove(sortedRealms, i)
            table.insert(sortedRealms, 1, realm)
            break
        end
    end

    local order = 1
    -- Create realm headers and character entries
    for _, realm in ipairs(sortedRealms) do
        -- Add realm header
        optTable["header_"..realm] = {
            name = "|cff82c5ff" .. realm .. "|r",
            type = "header",
            order = order
        }
        order = order + 1

        -- Add characters for this realm
        for charName, charData in pairs(realmCharacters[realm]) do
            local factionText = charData.faction or "Unknown"
            local classColor = charData.class and RAID_CLASS_COLORS[charData.class].colorStr or "ffffffff"
            -- Extract just the character name part before any hyphens
            local displayName = charName:match("^([^-]+)")
            optTable[charName] = {
                name = displayName .. " (|c" .. classColor .. factionText .. "|r)",
                width = "full",
                type = "toggle",
                order = order,
                get = function()
                    return xb.db.global.characters[charName] ~= nil;
                end,
                set = function(_, val)
                    if not val and xb.db.global.characters[charName] ~= nil then
                        xb.db.global.characters[charName] = nil;
                    end
                end
            }
            order = order + 1
        end
    end
    return optTable;
end

function GoldModule:GetDefaultOptions()
    return 'gold', {
        enabled = true,
        showSmallCoins = false,
        showFreeBagSpace = true,
        shortThousands = false,
        showOtherRealms = true
    }
end

function GoldModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.gold.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.gold.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            showSmallCoins = {
                name = L['Always Show Silver and Copper'],
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.gold.showSmallCoins;
                end,
                set = function(_, val)
                    xb.db.profile.modules.gold.showSmallCoins = val;
                    self:Refresh();
                end
            },
            showFreeBagSpace = {
                name = DISPLAY_FREE_BAG_SLOTS,
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.gold.showFreeBagSpace;
                end,
                set = function(_, val)
                    xb.db.profile.modules.gold.showFreeBagSpace = val;
                    self:Refresh();
                end
            },
            shortThousands = {
                name = L['Shorten Gold'],
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.gold.shortThousands;
                end,
                set = function(_, val)
                    xb.db.profile.modules.gold.shortThousands = val;
                    self:Refresh();
                end
            },
            showOtherRealms = {
                name = L['Show Other Realms'],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.gold.showOtherRealms;
                end,
                set = function(_, val)
                    xb.db.profile.modules.gold.showOtherRealms = val;
                    self:Refresh();
                end
            },
            listPlayers = {
                name = "Registered characters",
                type = "group",
                order = 1,
                args = listAllCharactersByFactionRealm()
            }
        }
    }
end
