---@class XIVBar
local XIVBar = select(2, ...)
local _G = _G
local xb = XIVBar
local L = XIVBar.L
local compat = XIVBar.compat or {}
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local managedActionBarAddOns = {
    Bartender4 = true,
    Dominos = true,
    ElvUI = true,
    Tukui = true,
}

local GoldModule = xb:NewModule("GoldModule", 'AceEvent-3.0')

local isSessionNegative = false
local negativeSign = "|cffff0000- "

local function shortenNumber(num)
    if num < 1000 then
        return tostring(num)
    elseif num < 1000000 then
        return format("%.1f" .. L["k"], num / 1000)
    elseif num < 1000000000 then
        return format("%.2f" .. L["M"], num / 1000000)
    else
        return format("%.3f" .. L["B"], num / 1000000000)
    end
end

local function moneyWithTexture(amount, session)
    local copper, silver
    local showSC = xb.db.profile.modules.gold.showSmallCoins
    local shortThousands = xb.db.profile.modules.gold.shortThousands

    amount, copper = math.modf(amount / 100.0)
    amount, silver = math.modf(amount / 100.0)

    silver = silver * 100
    copper = copper * 100

    local silverStr = string.format("%02d", silver)
    local copperStr = string.format("%02d", copper)

    amount = string.format("%.0f", amount)

    if not showSC then
        silverStr, copperStr = "00", "00"
    end

    local totalCopper = (tonumber(amount) or 0) * 10000 + (tonumber(silverStr) or 0) * 100 +
        (tonumber(copperStr) or 0)
    local amountStringTexture = C_CurrencyInfo.GetCoinTextureString(totalCopper)

    if shortThousands then
        local shortGold = shortenNumber(tonumber(amount))
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
    end)
    day = gsub(day, "(%d)(%d?)", function(d1, d2)
        return d2 == "" and "0" .. d1 or d1 .. d2
    end)

    return tonumber(year .. month .. day)
end

local function getGoldStore()
    if compat.isMainline then
        xb.db.global.characters = xb.db.global.characters or {}
        return xb.db.global.characters
    end

    xb.db.factionrealm = xb.db.factionrealm or {}
    return xb.db.factionrealm
end

local function getCharacterKey()
    if compat.isMainline then
        return xb.constants.playerName .. "-" .. xb.constants.playerRealm
    end

    return xb.constants.playerName
end

local function getPlayerData()
    local store = getGoldStore()
    local key = getCharacterKey()
    return store[key], store
end

function GoldModule:GetExternalActionBarManagerName()
    for addOnName in pairs(managedActionBarAddOns) do
        if IsAddOnLoaded(addOnName) then
            return addOnName
        end
    end

    return nil
end

function GoldModule:HasExternalActionBarManager()
    return self:GetExternalActionBarManagerName() ~= nil
end

function GoldModule:ToggleBlizzardBagsBar(force)
    if not compat.isMainline then
        return
    end

    local hide = xb.db.profile.modules.gold.disableBlizzardBagsBar
    if force ~= nil then
        hide = force
    end

    if InCombatLockdown() then
        self:RegisterEvent('PLAYER_REGEN_ENABLED', function()
            self:ToggleBlizzardBagsBar(force)
            self:UnregisterEvent('PLAYER_REGEN_ENABLED')
        end)
        return
    end

    if self:HasExternalActionBarManager() then
        hide = false
    end

    self.hiddenBagsByXIV = self.hiddenBagsByXIV or {}

    local frames = {
        _G.BagsBar,
        _G.MainMenuBarBackpackButton,
        _G.CharacterBag0Slot,
        _G.CharacterBag1Slot,
        _G.CharacterBag2Slot,
        _G.CharacterBag3Slot
    }

    for _, frame in ipairs(frames) do
        if frame then
            if hide then
                if frame:IsShown() then
                    frame:Hide()
                    self.hiddenBagsByXIV[frame] = true
                end
            else
                if self.hiddenBagsByXIV[frame] then
                    frame:Show()
                    self.hiddenBagsByXIV[frame] = nil
                end
            end
        end
    end
end

function GoldModule:GetName()
    return BONUS_ROLL_REWARD_MONEY
end

function GoldModule:OnInitialize()
    local store = getGoldStore()
    local key = getCharacterKey()

    if not store[key] then
        store[key] = {
            currentMoney = 0,
            sessionMoney = 0,
            dailyMoney = 0
        }

        if compat.isMainline then
            store[key].faction = select(1, UnitFactionGroup("player"))
            store[key].class = select(2, UnitClass("player"))
            store[key].realm = xb.constants.playerRealm
        end
    else
        if not store[key].dailyMoney then
            store[key].dailyMoney = 0
        end
        if not store[key].class then
            store[key].class = select(2, UnitClass("player"))
        end

        if compat.isMainline then
            if not store[key].faction then
                store[key].faction = select(1, UnitFactionGroup("player"))
            end
            if not store[key].realm then
                store[key].realm = xb.constants.playerRealm
            end
        end
    end

    local playerData = store[key]

    local curDate = C_DateAndTime.GetCurrentCalendarTime()
    local today = ConvertDateToNumber(curDate.month, curDate.monthDay, curDate.year)

    if playerData.lastLoginDate then
        if playerData.lastLoginDate < today then
            playerData.lastLoginDate = today
            playerData.dailyMoney = 0
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

    self:ToggleBlizzardBagsBar()

    local playerData, _ = getPlayerData()
    if playerData then
        playerData.sessionMoney = 0
        playerData.currentMoney = GetMoney()
    end

    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function GoldModule:OnDisable()
    self.goldFrame:Hide()
    self:ToggleBlizzardBagsBar(false)
    self:UnregisterEvent('PLAYER_MONEY')
    self:UnregisterEvent('BAG_UPDATE')
end

function GoldModule:Refresh()
    local db = xb.db.profile
    if self.goldFrame == nil then
        return
    end
    if not db.modules.gold.enabled then
        self:Disable()
        return
    end

    self:ToggleBlizzardBagsBar()

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

    if xb:ApplyModuleFreePlacement('gold', self.goldFrame) then
        return
    end

    local relativeAnchorPoint = 'LEFT'
    local xOffset = db.general.moduleSpacing
    local parentFrame = xb:GetFrame('travelFrame')
    if not xb.db.profile.modules.travel.enabled then
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
        self.goldText:SetTextColor(unpack(xb:HoverColors()))
        self.bagText:SetTextColor(unpack(xb:HoverColors()))

        if compat.isMainline then
            self:ShowTooltipMainline()
        else
            self:ShowTooltipClassic()
        end
    end)

    self.goldButton:SetScript('OnLeave', function()
        self.goldText:SetTextColor(xb:GetColor('normal'))
        self.bagText:SetTextColor(xb:GetColor('normal'))
        GameTooltip:Hide()
    end)

    self.goldButton:SetScript('OnClick', function(_, button)
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

function GoldModule:ShowTooltipClassic()
    if GameTooltip:IsOwned(self.goldButton) then
        return
    end

    GameTooltip:SetOwner(self.goldFrame, 'ANCHOR_' .. xb.miniTextPosition, 0, 6)
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. BONUS_ROLL_REWARD_MONEY .. "|cFFFFFFFF - |r" ..
                            xb.constants.playerFactionLocal .. " " .. xb.constants.playerRealm .. "|cFFFFFFFF]|r",
        r, g, b)
    if not xb.db.profile.modules.gold.showSmallCoins then
        GameTooltip:AddLine(L["GOLD_ROUNDED_VALUES"], 1, 1, 1)
    end
    GameTooltip:AddLine(" ")

    local playerData, store = getPlayerData()
    if playerData then
        GameTooltip:AddDoubleLine(L["SESSION_TOTAL"], moneyWithTexture(math.abs(playerData.sessionMoney), true), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L["DAILY_TOTAL"], moneyWithTexture(math.abs(playerData.dailyMoney), true), r, g, b, 1, 1, 1)
    end

    GameTooltip:AddLine(" ")

    local hideThreshold = tonumber(xb.db.profile.modules.gold.hideCharUnderThresholdAmount) or 0

    local totalGold = 0
    for charName, goldData in pairs(store) do
        local gold = floor(abs(goldData.currentMoney / 10000))
        local charClass = goldData.class
        local cc_r, cc_g, cc_b = 1, 1, 1
        if charClass then
            cc_r = RAID_CLASS_COLORS[charClass].r
            cc_g = RAID_CLASS_COLORS[charClass].g
            cc_b = RAID_CLASS_COLORS[charClass].b
        end
        if gold > 0 and ((xb.db.profile.modules.gold.hideCharUnderThreshold and gold >= hideThreshold) or not xb.db.profile.modules.gold.hideCharUnderThreshold) then
            GameTooltip:AddDoubleLine(charName, moneyWithTexture(goldData.currentMoney), cc_r, cc_g, cc_b, 1, 1, 1)
        end
        totalGold = totalGold + goldData.currentMoney
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(TOTAL, self:FormatCoinText(totalGold), r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', L["TOGGLE_BAGS"], r, g, b, 1, 1, 1)
    GameTooltip:Show()
end

function GoldModule:ShowTooltipMainline()
    if GameTooltip:IsOwned(self.goldButton) then
        return
    end

    GameTooltip:SetOwner(self.goldButton, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. BONUS_ROLL_REWARD_MONEY .. "|cFFFFFFFF]|r", r, g, b)

    if not xb.db.profile.modules.gold.showSmallCoins then
        GameTooltip:AddLine(L["GOLD_ROUNDED_VALUES"], 1, 1, 1)
    end
    GameTooltip:AddLine(" ")

    local playerData = getGoldStore()[getCharacterKey()]
    if playerData then
        GameTooltip:AddDoubleLine(L["SESSION_TOTAL"], self:FormatGold(math.abs(playerData.sessionMoney)), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L["DAILY_TOTAL"], self:FormatGold(math.abs(playerData.dailyMoney)), r, g, b, 1, 1, 1)
    end
    local warbandBankGold = 0
    if xb.db.profile.modules.gold.showWarbandBankGold then
        warbandBankGold = C_Bank.FetchDepositedMoney(Enum.BankType.Account)
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(ACCOUNT_BANK_PANEL_TITLE, self:FormatGold(warbandBankGold), r, g, b, 1, 1, 1)
    end

    local realmCharacters = {}
    local currentRealm = GetRealmName()
    local currentName = UnitName('player')
    local totalGold = 0
    if xb.db.profile.modules.gold.showWarbandBankGold then
        totalGold = warbandBankGold
    end

    local hideThreshold = tonumber(xb.db.profile.modules.gold.hideCharUnderThresholdAmount) or 0

    for characterName, goldData in pairs(getGoldStore()) do
        local realm = goldData.realm or currentRealm
        if not realmCharacters[realm] then
            realmCharacters[realm] = {}
        end
        local gold = floor(abs(goldData.currentMoney / 10000))
        if gold > 0 and ((xb.db.profile.modules.gold.hideCharUnderThreshold and gold >= hideThreshold) or not xb.db.profile.modules.gold.hideCharUnderThreshold) then
            table.insert(realmCharacters[realm], {
                name = characterName:match("^([^-]+)"),
                gold = goldData.currentMoney,
                class = goldData.class,
                faction = goldData.faction,
                isCurrent = (characterName == (currentName .. "-" .. currentRealm))
            })
        end
        totalGold = totalGold + goldData.currentMoney
    end

    local sortedRealms = {}
    for realm in pairs(realmCharacters) do
        table.insert(sortedRealms, realm)
    end
    table.sort(sortedRealms, function(a, realmB)
        if a == currentRealm then
            return true
        end
        if realmB == currentRealm then
            return false
        end
        return string.lower(a) < string.lower(realmB)
    end)

    for _, realm in ipairs(sortedRealms) do
        if xb.db.profile.modules.gold.showOtherRealms or realm == currentRealm then
            table.sort(realmCharacters[realm], function(a, realmCharacterB)
                if a.isCurrent ~= realmCharacterB.isCurrent then
                    return a.isCurrent
                end
                return string.lower(a.name) < string.lower(realmCharacterB.name)
            end)

            local realmTotal = 0
            for _, character in ipairs(realmCharacters[realm]) do
                realmTotal = realmTotal + character.gold
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine("|cff82c5ff" .. realm .. "|r", self:FormatGold(realmTotal), nil, nil, nil, 1, 1, 1)

            for _, character in ipairs(realmCharacters[realm]) do
                local displayName = character.name
                local factionIcon = ""
                if character.faction then
                    factionIcon = character.faction == "Alliance" and
                        "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t " or
                        "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t "
                end

                local cc_r, cc_g, cc_b = 1, 1, 1
                if character.class then
                    cc_r = RAID_CLASS_COLORS[character.class].r
                    cc_g = RAID_CLASS_COLORS[character.class].g
                    cc_b = RAID_CLASS_COLORS[character.class].b
                end

                GameTooltip:AddDoubleLine(factionIcon .. displayName, self:FormatGold(character.gold), cc_r, cc_g, cc_b, 1, 1, 1)
            end
        end
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(TOTAL, self:FormatGold(totalGold), r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', L["TOGGLE_BAGS"], r, g, b, 1, 1, 1)
    GameTooltip:Show()
end

function GoldModule:FormatGold(money)
    if xb.db.profile.modules.gold.showSmallCoins then
        return GetCoinTextureString(money)
    else
        local gold = floor(abs(money / 10000))
        if xb.db.profile.modules.gold.shortThousands then
            if gold >= 1000000 then
                return format("%.1fM", gold / 1000000) .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
            elseif gold >= 1000 then
                return format("%.1fK", gold / 1000) .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
            end
        end
        return gold .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
    end
end

function GoldModule:PLAYER_MONEY()
    local playerData = getGoldStore()[getCharacterKey()]
    if not playerData then
        return
    end

    local curMoney = playerData.currentMoney
    local tmpMoney = GetMoney()
    local moneyDiff = tmpMoney - curMoney

    playerData.sessionMoney = playerData.sessionMoney + moneyDiff
    playerData.dailyMoney = playerData.dailyMoney + moneyDiff

    isSessionNegative = playerData.sessionMoney < 0
    playerData.currentMoney = tmpMoney
    self:Refresh()
end

function GoldModule:FormatCoinText(money)
    local showSC = xb.db.profile.modules.gold.showSmallCoins
    if money == 0 then
        return showSC and
                   string.format("%s" .. GOLD_AMOUNT_SYMBOL .. " %s" .. SILVER_AMOUNT_SYMBOL .. " %s" ..
                COPPER_AMOUNT_SYMBOL, 0, 0, 0) or
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

function GoldModule:BuildClassicCharacterOptions()
    local optTable = {
        header = {
            name = "|cff82c5ff" .. xb.constants.playerFactionLocal .. " " .. xb.constants.playerRealm .. "|r",
            type = "header",
            order = 0
        },
        footer = {
            name = "All the characters listed above are currently registered in the gold database. To delete one or several character, plase uncheck the box correponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), untill you reload or logout/login",
            type = "description",
            order = -1
        }
    }

    local store = getGoldStore()
    for k in pairs(store) do
        optTable[k] = {
            name = k,
            width = "full",
            type = "toggle",
            get = function()
                return store[k] ~= nil
            end,
            set = function(_, val)
                if not val and store[k] ~= nil then
                    store[k] = nil
                end
            end
        }
    end
    return optTable
end

function GoldModule:BuildMainlineCharacterOptions()
    local optTable = {
        header = {
            name = "|cff82c5ff" .. L["REGISTERED_CHARACTERS"] .. "|r",
            type = "header",
            order = 0
        },
        footer = {
            name = "All the characters listed above are currently registered in the gold database. To delete one or several character, please uncheck the box corresponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), until you reload or logout/login",
            type = "description",
            order = -1
        }
    }

    local realmCharacters = {}
    local sortedRealms = {}
    local currentRealm = xb.constants.playerRealm

    for charName, charData in pairs(getGoldStore()) do
        local realm = charData.realm or currentRealm
        realmCharacters[realm] = realmCharacters[realm] or {}
        realmCharacters[realm][charName] = charData
        if not tContains(sortedRealms, realm) then
            table.insert(sortedRealms, realm)
        end
    end

    table.sort(sortedRealms)

    for i, realm in ipairs(sortedRealms) do
        if realm == currentRealm then
            table.remove(sortedRealms, i)
            table.insert(sortedRealms, 1, realm)
            break
        end
    end

    local order = 1
    for _, realm in ipairs(sortedRealms) do
        optTable["header_" .. realm] = {
            name = "|cff82c5ff" .. realm .. "|r",
            type = "header",
            order = order
        }
        order = order + 1

        for charName, charData in pairs(realmCharacters[realm]) do
            local factionText = charData.faction or "Unknown"
            local classColor = charData.class and RAID_CLASS_COLORS[charData.class].colorStr or "ffffffff"
            local displayName = charName:match("^([^-]+)")
            optTable[charName] = {
                name = displayName .. " (|c" .. classColor .. factionText .. "|r)",
                width = "full",
                type = "toggle",
                order = order,
                get = function()
                    return getGoldStore()[charName] ~= nil
                end,
                set = function(_, val)
                    if not val and getGoldStore()[charName] ~= nil then
                        getGoldStore()[charName] = nil
                    end
                end
            }
            order = order + 1
        end
    end

    return optTable
end

function GoldModule:GetDefaultOptions()
    local defaults = {
        enabled = true,
        showSmallCoins = false,
        showFreeBagSpace = true,
        shortThousands = false,
        hideCharUnderThreshold = false,
        hideCharUnderThresholdAmount = 0
    }

    if compat.isMainline then
        defaults.disableBlizzardBagsBar = false
        defaults.showOtherRealms = true
    end

    return 'gold', defaults
end

function GoldModule:GetConfig()
    local args = {
        enable = {
            name = ENABLE,
            order = 0,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.enabled
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
            name = L["ALWAYS_SHOW_SILVER_COPPER"],
            order = 1,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.showSmallCoins
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.showSmallCoins = val
                self:Refresh()
            end
        },
        shortThousands = {
            name = L["SHORTEN_GOLD"],
            order = 2,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.shortThousands
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.shortThousands = val
                self:Refresh()
            end
        },
        showFreeBagSpace = {
            name = L["SHOW_FREE_BAG_SPACE"],
            order = 3,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.showFreeBagSpace
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.showFreeBagSpace = val
                self:Refresh()
            end,
            width = "full"
        },
        hideCharUnderThreshold = {
            name = L["HIDE_CHAR_UNDER_THRESHOLD"],
            order = 3.4,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.hideCharUnderThreshold
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.hideCharUnderThreshold = val
                self:Refresh()
            end,
        },
        hideCharUnderThresholdAmount = {
            name = L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"],
            order = 3.5,
            type = "input",
            get = function()
                local value = xb.db.profile.modules.gold.hideCharUnderThresholdAmount
                return value ~= nil and tostring(value) or ""
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.hideCharUnderThresholdAmount = tonumber(val) or 0
                self:Refresh()
            end,
            hidden = function()
                return not xb.db.profile.modules.gold.hideCharUnderThreshold
            end,
            width = "full"
        }
    }

    if compat.isMainline then
        args.showOtherRealms = {
            name = L["SHOW_OTHER_REALMS"],
            order = 4,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.showOtherRealms
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.showOtherRealms = val
                self:Refresh()
            end,
        }
        args.showWarbandBankGold = {
            name = L["SHOW_WARBAND_BANK_GOLD"],
            order = 4.2,
            type = "toggle",
            get = function()
                return xb.db.profile.modules.gold.showWarbandBankGold
            end,
            set = function(_, val)
                xb.db.profile.modules.gold.showWarbandBankGold = val
                self:Refresh()
            end,
        }

        args.blizzardBagsBar = {
            type = "group",
            name = L["BLIZZARD_BAGS_BAR"],
            order = 4.5,
            inline = true,
            args = {
                disableBlizzardBagsBar = {
                    name = L["DISABLE_BLIZZARD_BAGS_BAR"],
                    order = 1,
                    type = "toggle",
                    width = "full",
                    disabled = function()
                        return self:HasExternalActionBarManager()
                    end,
                    get = function()
                        return xb.db.profile.modules.gold.disableBlizzardBagsBar
                    end,
                    set = function(_, val)
                        xb.db.profile.modules.gold.disableBlizzardBagsBar = val
                        self:ToggleBlizzardBagsBar()
                        self:Refresh()
                    end
                },
                blizzardBagsBarDisclaimer = {
                    name = function()
                        local addOnName = self:GetExternalActionBarManagerName()
                        local text = L["BLIZZARD_BAGS_BAR_DISCLAIMER"]
                        if addOnName then
                            text = string.format(text, addOnName)
                        end

                        return "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16:16:0:0|t " .. text
                    end,
                    order = 2,
                    type = "description",
                    width = "full"
                }
            }
        }

        args.characters = {
            name = L["REGISTERED_CHARACTERS"],
            type = 'group',
            order = 5,
            args = self:BuildMainlineCharacterOptions()
        }
    else
        args.listPlayers = {
            name = "Registered characters",
            type = "group",
            order = 4,
            args = self:BuildClassicCharacterOptions()
        }
    end

    return {
        name = self:GetName(),
        type = "group",
        args = args
    }
end
