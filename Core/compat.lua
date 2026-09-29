---@class XIVBar
local XIVBar = select(2, ...)
local compat = {}
local C_AddOns = _G.C_AddOns
local WOW_PROJECT_CATACLYSM_CLASSIC = _G.WOW_PROJECT_CATACLYSM_CLASSIC
local WOW_PROJECT_MISTS_CLASSIC = _G.WOW_PROJECT_MISTS_CLASSIC
XIVBar.compat = compat

-- Version flags
-- Forever (Camelot) reports WOW_PROJECT_CLASSIC but uses interface 16001.
-- Detect it first so it is not treated as Vanilla Anniversary.
local interfaceVersion = select(4, GetBuildInfo()) or 0
compat.projectId = WOW_PROJECT_ID
compat.isForever = interfaceVersion >= 16000 and interfaceVersion < 20000
compat.isClassicEra = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and not compat.isForever
compat.isTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
compat.isWrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
compat.isMainline = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
compat.isCata = WOW_PROJECT_CATACLYSM_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
compat.isMists = WOW_PROJECT_MISTS_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC
compat.isClassicOrTBC = compat.isClassicEra or compat.isTBC
compat.isClassicProgression = compat.isWrath or compat.isCata or compat.isMists

-- Addon API helpers
-- compat.IsAddOnLoaded: wrapper to avoid errors if C_AddOns is missing
-- (e.g. older Classic builds).
local fallbackIsAddOnLoaded = _G.IsAddOnLoaded or function()
    return false
end
compat.IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or fallbackIsAddOnLoaded

-- Currency API helpers
local function GetCurrencyListSize()
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListSize then
        return C_CurrencyInfo.GetCurrencyListSize()
    elseif _G.GetCurrencyListSize then
        return _G.GetCurrencyListSize()
    end
    return 0
end

compat.GetCurrencyListSize = GetCurrencyListSize

local function GetCurrencyListInfo(index)
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListInfo then
        return C_CurrencyInfo.GetCurrencyListInfo(index)
    elseif _G.GetCurrencyListInfo then
        -- Legacy API returns multiple values:
        -- name, isHeader, isExpanded, isUnused, isWatched, count, icon,
        -- maximum, hasWeeklyLimit, currentWeeklyAmount, unknown, itemID
        local name, isHeader, isExpanded, isUnused, isWatched, count, icon,
              maximum, hasWeeklyLimit, currentWeeklyAmount, _, itemID =
              _G.GetCurrencyListInfo(index)
        if name then
            return {
                name = name,
                isHeader = isHeader,
                isExpanded = isExpanded,
                isTypeUnused = isUnused,
                isWatched = isWatched,
                quantity = count,
                iconFileID = icon,
                maxQuantity = maximum or 0,
                hasWeeklyLimit = hasWeeklyLimit,
                currentWeeklyAmount = currentWeeklyAmount,
                itemID = itemID,
            }
        end
    end
    return nil
end

compat.GetCurrencyListInfo = GetCurrencyListInfo

local function GetCurrencyListLink(index)
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListLink then
        return C_CurrencyInfo.GetCurrencyListLink(index)
    elseif _G.GetCurrencyListLink then
        return _G.GetCurrencyListLink(index)
    end
    return nil
end

compat.GetCurrencyListLink = GetCurrencyListLink

local function ExpandCurrencyList(index, expand)
    if C_CurrencyInfo and C_CurrencyInfo.ExpandCurrencyList then
        return C_CurrencyInfo.ExpandCurrencyList(index, expand)
    elseif _G.ExpandCurrencyList then
        -- Legacy API expects a number (1/0), not a boolean
        local flag = expand and 1 or 0
        return _G.ExpandCurrencyList(index, flag)
    end
    return nil
end

compat.ExpandCurrencyList = ExpandCurrencyList

local function GetCurrencyIDFromLink(link)
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyIDFromLink then
        return C_CurrencyInfo.GetCurrencyIDFromLink(link)
    elseif _G.GetCurrencyIDFromLink then
        return _G.GetCurrencyIDFromLink(link)
    end
    return nil
end

compat.GetCurrencyIDFromLink = GetCurrencyIDFromLink

local function GetBasicCurrencyInfo(currencyID)
    if C_CurrencyInfo and C_CurrencyInfo.GetBasicCurrencyInfo then
        return C_CurrencyInfo.GetBasicCurrencyInfo(currencyID)
    elseif _G.GetCurrencyInfo then
        -- No GetBasicCurrencyInfo on legacy; build from GetCurrencyInfo
        local name, currentAmount, texture = _G.GetCurrencyInfo(currencyID)
        if name then
            return {
                name = name,
                quantity = currentAmount,
                icon = texture,
                iconFileID = texture,
            }
        end
    end
    return nil
end

compat.GetBasicCurrencyInfo = GetBasicCurrencyInfo

local function GetCurrencyInfo(currencyID)
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        return C_CurrencyInfo.GetCurrencyInfo(currencyID)
    end
    return nil
end

compat.GetCurrencyInfo = GetCurrencyInfo

-- Battle.net whisper helper: APIs differ by version/patch.
-- Try multiple functions in a safe order.
local ChatFrameUtil = _G.ChatFrameUtil
local function TrySendBNetWhisper(accountId, accountName)
    if _G.ChatFrame_SendBNWhisper then
        _G.ChatFrame_SendBNWhisper(accountId, accountName)
    elseif _G.FriendsFrame_SendBNetMessage then
        _G.FriendsFrame_SendBNetMessage(accountId)
    elseif _G.BNOpenWhisper then
        _G.BNOpenWhisper(accountId, accountName)
    elseif _G.ChatFrame_SendBNetTell then
        _G.ChatFrame_SendBNetTell(accountName)
    elseif ChatFrameUtil and ChatFrameUtil.SendBNetTell then
        ChatFrameUtil.SendBNetTell(accountName)
    elseif _G.BNSendWhisper then
        _G.BNSendWhisper(accountId, accountName)
    elseif _G.ChatFrame_OpenChat then
        _G.ChatFrame_OpenChat("/w " .. accountName)
    end
end

compat.SendBNetWhisper = TrySendBNetWhisper

local function ResolveLFGMicroButton()
    return _G.LFDMicroButton or _G.LFGMicroButton
end

local function ResolvePVPMicroButton()
    return _G.PVPMicroButton
end

compat.ResolveLFGMicroButton = ResolveLFGMicroButton
compat.ResolvePVPMicroButton = ResolvePVPMicroButton

compat.ResolveMicroButton = function(key)
    if key == 'lfg' then
        return ResolveLFGMicroButton()
    elseif key == 'pvp' then
        return ResolvePVPMicroButton()
    end
    return nil
end

compat.GetMicroButtonMacro = function(key)
    -- Forever has no LFGMicroButton or PVPMicroButton. A /click macro on a
    -- missing button does nothing. LFG clicks LFDMicroButton directly.
    if compat.isForever then
        return nil
    end
    if key == 'lfg' then
        return "/click LFDMicroButton\n/click LFGMicroButton"
    elseif key == 'pvp' then
        return "/click PVPMicroButton"
    end

    return nil
end

-- Blizzard_GroupFinder is not loaded on Forever. The vanilla-style finder is.
-- Category 118 is LFGLISTING_BATTLEGROUND_CATEGORY_ID in that addon's constants.
local FOREVER_BATTLEGROUND_CATEGORY_ID = 118

local function LoadVanillaGroupFinder()
    if _G.GroupFinderVanillaStyle_LoadUI then
        _G.GroupFinderVanillaStyle_LoadUI()
    end
    return _G.LFGVanilla_ShowFrame ~= nil
end

local function ShowVanillaGroupFinder(categoryID)
    if not LoadVanillaGroupFinder() then
        return false
    end
    _G.LFGVanilla_ShowFrame(1)
    local listing = _G.LFGListingFrame
    if categoryID and listing and listing.SetCategorySelection
        and _G.C_LFGList and _G.C_LFGList.GetLfgCategoryInfo
        and _G.C_LFGList.GetLfgCategoryInfo(categoryID) then
        listing:SetCategorySelection(categoryID)
    end
    return true
end

-- LFG toggle helper: Retail via PVEFrame, Classic via LFGMinimapFrame.
-- Falls back to legacy toggles when needed.
local function TryToggleLFG()
    if compat.isForever then
        local lfdButton = _G.LFDMicroButton
        if lfdButton and lfdButton.Click then
            lfdButton:Click()
        end
        return
    end

    if compat.isMists and _G.PVEFrame_ToggleFrame then
        _G.PVEFrame_ToggleFrame("GroupFinderFrame")
        return
    end

    local microButton = ResolveLFGMicroButton()
    if microButton and microButton.Click then
        microButton:Click()
        return
    end

    local lfgFrame = _G.LFGMinimapFrame
    if lfgFrame and lfgFrame.Click then
        lfgFrame:Click()
        return
    end

    if _G.ToggleLFGParentFrame then
        _G.ToggleLFGParentFrame()
    elseif _G.PVEFrame_ToggleFrame then
        _G.PVEFrame_ToggleFrame()
    elseif _G.ToggleLFGFrame then
        _G.ToggleLFGFrame()
    end
end

compat.ToggleLFG = TryToggleLFG

-- PVP toggle helper: legacy LFGMinimapFrame button, otherwise modern PVP UI.
local function TryTogglePVP()
    if compat.isForever and ShowVanillaGroupFinder(FOREVER_BATTLEGROUND_CATEGORY_ID) then
        return
    end

    if compat.isMists and _G.TogglePVPFrame then
        _G.TogglePVPFrame()
        return
    end

    local microButton = ResolvePVPMicroButton()
    if microButton and microButton.Click then
        microButton:Click()
        return
    end

    local lfgFrame = _G.LFGMinimapFrame
    if lfgFrame and lfgFrame.Click then
        lfgFrame:Click()
        return
    end

    if _G.TogglePVPFrame then
        _G.TogglePVPFrame()
    elseif _G.PVPUIFrame_ToggleFrame then
        _G.PVPUIFrame_ToggleFrame()
    elseif _G.PVEFrame_ToggleFrame then
        _G.PVEFrame_ToggleFrame()
    end
end

compat.TogglePVP = TryTogglePVP

local function TryToggleFriends()
    if _G.ToggleFriendsFrame then
        _G.ToggleFriendsFrame()
        return
    end
    local friendsButton = _G.FriendsMicroButton
    if friendsButton and friendsButton.Click then
        friendsButton:Click()
    end
end

compat.ToggleFriends = TryToggleFriends

local function TryToggleTalents()
    if _G.PlayerSpellsFrame_LoadUI then
        _G.PlayerSpellsFrame_LoadUI()
    end
    local util = _G.PlayerSpellsUtil
    if util and util.ToggleClassTalentFrame then
        util.ToggleClassTalentFrame()
        return
    end
    if util and util.TogglePlayerSpellsFrame and util.FrameTabs then
        util.TogglePlayerSpellsFrame(util.FrameTabs.ClassTalents)
        return
    end
    local talentButton = _G.TalentMicroButton or _G.PlayerSpellsMicroButton
    if talentButton and talentButton.Click then
        talentButton:Click()
    end
end

compat.ToggleTalents = TryToggleTalents

local function TryToggleJournal()
    if _G.ToggleEncounterJournal then
        _G.ToggleEncounterJournal()
        return
    end
    local journalButton = _G.EJMicroButton
    if journalButton and journalButton.Click then
        journalButton:Click()
    end
end

compat.ToggleJournal = TryToggleJournal

-- Chat menu toggle helper: modern menu (ChatFrameMenuButton) or
-- classic menu (ChatMenu/ChatFrame_ToggleMenu).
local function TryToggleChatMenu()
    local chatMenuButton = _G.ChatFrameMenuButton
    if chatMenuButton and chatMenuButton.OpenMenu then
        chatMenuButton:OpenMenu()
        return
    end

    local chatMenu = _G.ChatMenu
    if chatMenu and chatMenu.IsVisible then
        if chatMenu:IsVisible() then
            chatMenu:Hide()
        else
            if _G.ChatFrame_ToggleMenu then
                _G.ChatFrame_ToggleMenu()
            end
        end
    elseif _G.ChatFrame_ToggleMenu then
        _G.ChatFrame_ToggleMenu()
    end
end

compat.ToggleChatMenu = TryToggleChatMenu

-- Shop toggle helper: micro-menu button (if present), otherwise ToggleStoreUI.
local function TryToggleStore()
    local storeButton = _G.StoreMicroButton
    if storeButton and storeButton.Click then
        storeButton:Click()
        return
    end

    if _G.ToggleStoreUI then
        _G.ToggleStoreUI()
    end
end

compat.ToggleStore = TryToggleStore

-- Feature flags to show/hide buttons based on version.
-- UI modules read these flags before creating buttons.
compat.features = {
    microMenu = {
        achievements = not compat.isClassicOrTBC and not compat.isForever,
        lfg = true,
        pvp = true,
        pet = not compat.isClassicOrTBC or compat.isForever,
        legacy = compat.isForever,
        -- Blizzard_EncounterJournal does not load on Forever: AllowLoadGameType
        -- is standard/classic, and the journal UI itself is cata, mists, mainline.
        journal = (compat.isMainline or compat.isClassicProgression) and not compat.isForever,
        shop = not compat.isClassicOrTBC,
    },
    currency = {
        -- No currencies in Classic Era/TBC/Forever V1, we only keep the XP bar
        available = not compat.isClassicOrTBC and not compat.isForever,
    },
    travel = {
        secondaryPorts = compat.isMainline or compat.isMists,
        magePortals = true,
    },
    armor = {
        -- Equipment sets were added in Mists of Pandaria.
        equipmentSets = compat.isMainline or compat.isMists,
    },
}

-- AceGUI CheckBox calls the FrameXML helper SetDesaturation(texture, desat).
-- Forever only exposes Texture:SetDesaturated / :SetDesaturation.
if not _G.SetDesaturation then
    function SetDesaturation(texture, desaturation)
        if not texture then
            return
        end
        if texture.SetDesaturated then
            texture:SetDesaturated(desaturation and true or false)
        elseif texture.SetDesaturation then
            texture:SetDesaturation(desaturation and 1 or 0)
        end
    end
end

-- AceConfigDialog still calls GameTooltip:SetText(text, r, g, b, wrapBoolean).
-- Forever types arg 5 as alpha (number), so `true` errors.
if compat.isForever then
    local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
    local tip = AceConfigDialog and AceConfigDialog.tooltip
    if tip and not tip._xivSetTextPatched then
        tip._xivSetTextPatched = true
        local origSetText = tip.SetText
        function tip:SetText(text, r, g, b, a, wrap)
            if type(a) == "boolean" then
                wrap = a
                a = 1
            end
            return origSetText(self, text, r, g, b, a, wrap)
        end
    end
end
