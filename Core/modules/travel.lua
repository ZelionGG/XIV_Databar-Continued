--------------------------------------------------------------------------------
-- TRAVEL MODULE
-- Provides quick access to hearthstones, portals, and mythic+ teleports
--------------------------------------------------------------------------------

local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;
local compat = xb.compat

local TravelModule = xb:NewModule("TravelModule", 'AceEvent-3.0')

-- Cache frequently used API functions for performance
local GetItemInfo = C_Item.GetItemInfo
local ContinueOnItemLoad = (C_Item and C_Item.ContinueOnItemLoad) or function(_, callback)
    if callback then callback() end
end
local GetItemCooldown = C_Container.GetItemCooldown
local GetSpellCooldown = C_Spell.GetSpellCooldown
local GetSpellInfo = C_Spell.GetSpellInfo
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Safe IsUsableItem wrapper with compatibility check
local function SafeIsUsableItem(id)
    if compat.isMists and not IsUsableItem then return false end
    return IsUsableItem(id)
end

--------------------------------------------------------------------------------
-- UTILITY FUNCTIONS - Centralized logic to reduce code duplication
--------------------------------------------------------------------------------

function TravelModule:GetName() return L['Travel']; end

local function GetRetrievingText(id)
    return L['Retrieving data'] .. " (" .. id .. ")"
end

local function GetItemName(id)
    if not id then return "" end
    if compat.isMists and not GetItemInfo then return tostring(id) end
    local name = select(1, GetItemInfo(id))

    if name then
        if TravelModule and TravelModule.portOptions and TravelModule.portOptions[id] then
            TravelModule.portOptions[id].text = name
        end
        return name
    end

    local retrievingText = GetRetrievingText(id)

    if compat.isMists then
        return retrievingText
    end

    -- Classic/TBC: avoid ContinueOnItemLoad which can error on missing items
    if compat.isClassicOrTBC then
        return retrievingText
    end

    local function onItemReady()
        local loadedName = GetItemName(id)
        if loadedName and TravelModule and TravelModule.portOptions then
            if TravelModule.portOptions[id] then
                TravelModule.portOptions[id].text = loadedName
            end
        end
        if loadedName and xb and xb.db and xb.db.char and xb.db.char.portItem and xb.db.char.portItem.portId == id then
            xb.db.char.portItem.text = loadedName
        end
        if TravelModule and TravelModule.Refresh then
            TravelModule:Refresh()
        end
    end

    -- Prefer Item API when available (safer in modern clients)
    if Item and Item.CreateFromItemID and not compat.isMists then
        local item = Item:CreateFromItemID(id)
        item:ContinueOnItemLoad(onItemReady)
    else
        ContinueOnItemLoad(id, onItemReady)
    end

    return retrievingText
end

local function GetPortLabel(portId)
    if IsPlayerSpell(portId) then
        local spellInfo = GetSpellInfo(portId)
        if spellInfo and spellInfo.name then return spellInfo.name end
    end
    return GetItemName(portId)
end

function TravelModule:OnInitialize()
    self.iconPath = xb.constants.mediaPath .. 'datatexts\\repair'
    self.garrisonHearth = 110560
    self.hearthstones = {
        556,       -- Astral Recall
        6948,      -- Hearthstone
        260221, -- Naaru's Embrace (Classic)
        184871 -- Dark Portal (Classic)
    }
    if compat.isMainline then
        self.hearthstones = {
            246565, -- Cosmic Hearthstone
            245970, -- P.O.S.T. Master's Express Hearthstone
            236687, -- Explosive Hearthstone
            235016, -- Redeployment Module
            228940, -- Notorious Thread's Hearthstone
            200630, -- Ohn'ir Windsage's Hearthstone
            190196, -- Enlightened Hearthstone
            212337, -- Stone of the Hearth
            209035, -- Hearthstone of the Flame
            208704, -- Deepdweller's Earthen Hearthstone
            54452, -- Ethereal Portal
            193588, -- Timewalker's Hearthstone
            190237, -- Broker Translocation Matrix
            188952, -- Dominated Hearthstone
            184353, -- Kyrian Hearthstone
            182773, -- Necrolord Hearthstone
            180290, -- Night Fae Hearthstone
            183716, -- Venthyr Sinstone
            172179, -- Eternal Travaler's Hearthstone
            6948, -- Hearthstone
            64488, -- Innkeeper's Daughter
            28585, -- Ruby Slippers
            93672, -- Dark Portal
            142542, -- Tome of Town Portal
            163045, -- Headless Horseman's Hearthstone
            162973, -- Greatfather Winter's Hearthstone
            165669, -- Lunar Elder's Hearthstone
            165670, -- Peddlefeet's Lovely Hearthstone
            165802, -- Noble Gardener's Hearthstone
            166746, -- Fire Eater's Hearthstone
            166747, -- Brewfest Reveler's Hearthstone
            40582, -- Scourgestone (Death Knight Starting Campaign)
            172179, -- Eternal Traveler's Hearthstone
            142543, -- Scroll of Town Portal
            37118, -- Scroll of Recall 1
            44314, -- Scroll of Recall 2
            44315, -- Scroll of Recall 3
            556, -- Astral Recall
            168907, -- Holographic Digitalization Hearthstone
            142298, -- Astonishingly Scarlet Slippers
            210455, -- Draenic Hologem
            263489, -- Naaru's Embrace (Retail)
            260221, -- Naaru's Embrace (Classic)
            184871 -- Dark Portal (Classic)
        }
    end

    self.portButtons = {}
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
    self.availableHearthstones = {}
    self.selectedHearthstones = {}
    self.noMythicTeleport = true
    self.playerHouseList = nil
end

local portal = C_CVar.GetCVar("portal")
if portal == "US" then
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-04"] = "TWW_2",  -- TWW Season 2 start date
        ["2025-08-12"] = "TWW_3" -- TWW Season 3 start date
    }
elseif portal == "EU" then
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2",  -- TWW Season 2 start date
        ["2025-08-13"] = "TWW_3" -- TWW Season 3 start date
    }
else
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2",  -- TWW Season 2 start date
        ["2025-08-13"] = "TWW_3" -- TWW Season 3 start date
    }
end

-- Skin Support for ElvUI/TukUI
-- Make sure to disable "Tooltip" in the Skins section of ElvUI together with
-- unchecking "Use ElvUI for tooltips" in XIV options to not have ElvUI interfere with tooltips
function TravelModule:SkinFrame(frame, name)
    if self.useElvUI then
        if frame.StripTextures then frame:StripTextures() end
        if frame.SetTemplate then frame:SetTemplate("Transparent") end

        local close = _G[name .. "CloseButton"] or frame.CloseButton
        if close and close.SetAlpha then
            if ElvUI then
                ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
            end

            -- Tukui support - may not be loaded, so check safely
            -- Tukui is an external dependency that may not be loaded
            if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
                Tukui[1].SkinCloseButton(close)
            end
            close:SetAlpha(1)
        end
    end
end

function TravelModule:OnEnable()
    if self.hearthFrame == nil then
        self.hearthFrame = CreateFrame('FRAME', "TravelModule",
                                       xb:GetFrame('bar'))
        xb:RegisterFrame('travelFrame', self.hearthFrame)
    end
    self.useElvUI = xb.db.profile.general.useElvUI and
                        (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui'))
    self.hearthFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()

    xb.db.profile.selectedHearthstones =
        xb.db.profile.selectedHearthstones or {}
end

function TravelModule:OnDisable()
    self.hearthFrame:Hide()
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('BAG_UPDATE_DELAYED')
    self:UnregisterEvent('HEARTHSTONE_BOUND')
    self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')
    if compat.isMainline then
        self:UnregisterEvent('PLAYER_HOUSE_LIST_UPDATED')
    end
end

function TravelModule:CreateFrames()
    local db = xb.db and xb.db.profile
    -- Hearthstones Part
    self.hearthButton = self.hearthButton or
                            CreateFrame('BUTTON', 'hearthButton',
                                        self.hearthFrame,
                                        'SecureActionButtonTemplate')
    self.hearthIcon = self.hearthIcon or
                        self.hearthButton:CreateTexture(nil, 'OVERLAY')
    self.hearthText = self.hearthText or
                        self.hearthButton:CreateFontString(nil, 'OVERLAY')

    -- Portals Part
    self.portButton = self.portButton or
                        CreateFrame('BUTTON', 'portButton', self.hearthFrame,
                                    'SecureActionButtonTemplate')
    self.portIcon = self.portIcon or
                        self.portButton:CreateTexture(nil, 'OVERLAY')
    self.portText = self.portText or
                        self.portButton:CreateFontString(nil, 'OVERLAY')


    local template =
        (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
            (BackdropTemplateMixin and "BackdropTemplate")
    -- Portals popup
    self.portPopup = self.portPopup or
                         CreateFrame('BUTTON', 'portPopup', self.portButton,
                                     template)
    self.portPopup:SetFrameStrata("TOOLTIP")

    if TooltipBackdropTemplateMixin then
        self.portPopup.layoutType = GameTooltip.layoutType
        NineSlicePanelMixin.OnLoad(self.portPopup.NineSlice)

        if GameTooltip.layoutType then
            -- NineSlice color methods may not exist in all WoW client versions
            -- Check safely before calling to prevent errors
            local nineSlice = self.portPopup.NineSlice
            local tooltipNineSlice = GameTooltip.NineSlice
            
            if nineSlice.SetCenterColor and tooltipNineSlice.GetCenterColor then
                nineSlice:SetCenterColor(tooltipNineSlice:GetCenterColor())
            end
            if nineSlice.SetBorderColor and tooltipNineSlice.GetBorderColor then
                nineSlice:SetBorderColor(tooltipNineSlice:GetBorderColor())
            end
        end
    else
        local backdrop = GameTooltip:GetBackdrop()
        if backdrop and (not self.useElvUI) then
            self.portPopup:SetBackdrop(backdrop)
            self.portPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
            self.portPopup:SetBackdropBorderColor(
                GameTooltip:GetBackdropBorderColor())
        end
    end

    -- Home (Housing) Part - Retail only
    if compat.isMainline then
        self.homeButton = self.homeButton or
                              CreateFrame('BUTTON', 'homeButton',
                                          self.hearthFrame,
                                          'SecureActionButtonTemplate')
        self.homeIcon = self.homeIcon or
                            self.homeButton:CreateTexture(nil, 'OVERLAY')
    end
end

function TravelModule:CreateMythicFrames()
    if self.mythicButton or InCombatLockdown() then
        return
    end

    self.mythicButton = CreateFrame('BUTTON', 'mythicButton', self.hearthFrame,
                                    'InsecureActionButtonTemplate')
    self.mythicIcon = self.mythicButton:CreateTexture(nil, 'OVERLAY')
    self.mythicText = self.mythicButton:CreateFontString(nil, 'OVERLAY')
    self.mythicPopup = CreateFrame('FRAME', 'mythicPopup', self.mythicButton,
                                   'UIDropDownMenuTemplate')

    self.mythicButton:EnableMouse(true)
    self.mythicButton:RegisterForClicks('LeftButtonUp', 'LeftButtonDown')
    self.mythicButton:SetAttribute('type', 'mythicFunction')
    self.mythicButton.HandlesGlobalMouseEvent = function() return true end

    self.mythicButton.mythicFunction = function()
        if not InCombatLockdown() then
            ToggleDropDownMenu(1, nil, self.mythicPopup, self.mythicButton, 0, 0)
        end
    end

    self.mythicButton:SetScript('OnEnter', function()
        TravelModule:SetMythicColor()
        if InCombatLockdown() then return end
    end)

    self.mythicButton:SetScript('OnLeave', function()
        TravelModule:SetMythicColor()
        GameTooltip:Hide()
    end)
end

function TravelModule:RegisterFrameEvents()
    self:RegisterEvent('SPELLS_CHANGED', 'Refresh')
    self:RegisterEvent('BAG_UPDATE_DELAYED', 'Refresh')
    self:RegisterEvent('HEARTHSTONE_BOUND', 'Refresh')
    self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'RefreshHearthstonesList')

    -- Housing events - Retail only
    if compat.isMainline then
        self:RegisterEvent('PLAYER_HOUSE_LIST_UPDATED', 'OnHouseListUpdated')
        C_Housing.GetPlayerOwnedHouses()
    end

    self.hearthButton:EnableMouse(true)
    self.hearthButton:RegisterForClicks('AnyUp', 'AnyDown')
    self.hearthButton:SetAttribute('type', 'macro')

    self.portButton:EnableMouse(true)
    self.portButton:RegisterForClicks("AnyUp", "AnyDown")
    self.portButton:SetAttribute('*type1', 'macro')
    self.portButton:SetAttribute('*type2', 'portFunction')

    self.portPopup:EnableMouse(true)
    self.portPopup:RegisterForClicks('RightButtonUp')

    self.portButton.portFunction = self.portButton.portFunction or function()
        if TravelModule.portPopup:IsVisible() then
            TravelModule.portPopup:Hide()
            self:ShowTooltip()
        else
            TravelModule:CreatePortPopup()
            TravelModule.portPopup:Show()
            GameTooltip:Hide()
        end
    end

    self.portPopup:SetScript('OnClick', function(self, button)
        if button == 'RightButton' then self:Hide() end
    end)


    -- Heartstone Randomizer
    if xb.db.profile.randomizeHs then
        self.hearthButton:SetScript('PreClick', function()
            TravelModule:SetHearthColor()
        end)
    end

    -- Create unified hover/leave handlers to avoid duplication
    local function createHoverHandler(colorFunc, showTooltip)
        return function()
            colorFunc()
            if not InCombatLockdown() and showTooltip then
                self:ShowTooltip()
            end
        end
    end
    
    local function createLeaveHandler(colorFunc)
        return function()
            colorFunc()
            if self.tooltipTimer then
                self.tooltipTimer:Cancel()
                self.tooltipTimer = nil
            end
            GameTooltip:Hide()
        end
    end

    -- Hearthstone button events
    self.hearthButton:SetScript('OnEnter', createHoverHandler(function() self:SetHearthColor() end, true))
    self.hearthButton:SetScript('OnLeave', createLeaveHandler(function() self:SetHearthColor() end))

    -- Port button events  
    self.portButton:SetScript('OnEnter', createHoverHandler(function() self:SetPortColor() end, true))
    self.portButton:SetScript('OnLeave', createLeaveHandler(function() self:SetPortColor() end))

    -- Home button events - Retail only
    if compat.isMainline and self.homeButton then
        self.homeButton:EnableMouse(true)
        self.homeButton:RegisterForClicks('AnyUp', 'AnyDown')

        -- Left click: teleport home (SecureAction type)
        self.homeButton:SetAttribute('type1', 'teleporthome')
        self.homeButton:SetAttribute('clickbutton', self.homeButton)

        self.homeButton:SetScript('OnEnter', function()
            self:SetHomeColor()
            if not InCombatLockdown() then
                self:UpdateHouseAttributes()
            end
        end)

        self.homeButton:SetScript('OnLeave', function()
            self:SetHomeColor()
        end)
    end
end

function TravelModule:UpdatePortOptions()
    if not self.portOptions then self.portOptions = {} end
    if SafeIsUsableItem(128353) and not self.portOptions[128353] then
        self.portOptions[128353] = {
            portId = 128353,
            text = GetItemName(128353)
        } -- admiral's compass
    end
    if PlayerHasToy(140192) and not self.portOptions[140192] then
        self.portOptions[140192] = {
            portId = 140192,
            text = GetItemName(140192)
        } -- dalaran hearthstone
    end

    if PlayerHasToy(self.garrisonHearth) and
        not self.portOptions[self.garrisonHearth] then
        self.portOptions[self.garrisonHearth] = {
            portId = self.garrisonHearth,
            text = GARRISON_LOCATION_TOOLTIP
        } -- needs to be var for default options
    end

    if xb.constants.playerClass == 'DRUID' then
        if IsPlayerSpell(193753) then
            if not self.portOptions[193753] then
                self.portOptions[193753] = {
                    portId = 193753,
                    text = ORDER_HALL_DRUID
                }
            end
        else
            if not self.portOptions[18960] then
                self.portOptions[18960] = {
                    portId = 18960,
                    text = C_Map.GetMapInfo(1471).name
                }
            end
        end
    end

    if xb.constants.playerClass == 'DEATHKNIGHT' and not self.portOptions[50977] then
        self.portOptions[50977] = {
            portId = 50977,
            text = ORDER_HALL_DEATHKNIGHT
        }
    end

    if xb.constants.playerClass == 'SHAMAN' and not self.portOptions[556] then
        local spellInfo = GetSpellInfo(556)
        self.portOptions[556] = {
            portId = 556,
            text = spellInfo.name
        }
    end

    if xb.constants.playerClass == 'MAGE' and not self.portOptions[193759] then
        self.portOptions[193759] = {portId = 193759, text = ORDER_HALL_MAGE}
    end

    if xb.constants.playerClass == 'MONK' and not self.portOptions[193759] then
        local portText = C_Map.GetMapInfo(809)
        if IsPlayerSpell(200617) then portText = ORDER_HALL_MONK end
        self.portOptions[193759] = {portId = 193759, text = portText}
    end
end

function TravelModule:GetRemainingCooldown(id, isSpell)
    local startTime, duration
    if isSpell then
        local spellCooldownInfo = GetSpellCooldown(id)
        startTime = spellCooldownInfo.startTime
        duration = spellCooldownInfo.duration
    else
        startTime, duration = GetItemCooldown(id)
    end
    
    if type(startTime) == "number" and type(duration) == "number" and duration > 0 then
        return math.max(0, startTime + duration - GetTime())
    end
    return 0
end

function TravelModule:GetTransportName(id)
    -- Try spell first
    if IsPlayerSpell(id) then
        local spellInfo = GetSpellInfo(id)
        if spellInfo and spellInfo.name then
            return spellInfo.name
        end
    end
    
    -- Try toy
    if PlayerHasToy(id) then
        local _, name = C_ToyBox.GetToyInfo(id)
        if name then return name end
    end
    
    -- Try item
    if SafeIsUsableItem(id) then
        local name = GetItemInfo(id)
        if name then return name end
    end
    
    return nil
end

function TravelModule:FindUsableTransport(ids, preferRandom)
    local available = {}
    
    for _, id in ipairs(ids) do
        if self:IsUsable(id) then
            local name = self:GetTransportName(id)
            if name then
                -- Use global IsUsableItem with compatibility check
                local isUsableItemFunc = SafeIsUsableItem(id)
                local macro = isUsableItemFunc and "/use item:" .. id or "/cast " .. name
                table.insert(available, {id = id, name = name, macro = macro})
            end
        end
    end
    
    if #available == 0 then return nil end
    if preferRandom then
        return available[math.random(#available)]
    end
    return available[1]
end

function TravelModule:SetButtonState(button, icon, text, isActive, isHover)
    local db = xb.db.profile
    
    if isHover then
        text:SetTextColor(unpack(xb:HoverColors()))
    elseif isActive then
        icon:SetVertexColor(xb:GetColor('normal'))
        text:SetTextColor(xb:GetColor('normal'))
    else
        icon:SetVertexColor(db.color.inactive.r, db.color.inactive.g, 
                          db.color.inactive.b, db.color.inactive.a)
        text:SetTextColor(db.color.inactive.r, db.color.inactive.g, 
                         db.color.inactive.b, db.color.inactive.a)
    end
end

function TravelModule:FormatCooldown(cdTime)
    if cdTime <= 0 then return L['Ready'] end
    local hours = string.format("%02.f", math.floor(cdTime / 3600))
    local minutes = string.format("%02.f",
                                  math.floor(cdTime / 60 - (hours * 60)))
    local seconds = string.format("%02.f", math.floor(
                                      cdTime - (hours * 3600) - (minutes * 60)))
    local retString = ''
    if tonumber(hours) ~= 0 then retString = hours .. ':' end
    if tonumber(minutes) ~= 0 or tonumber(hours) ~= 0 then
        retString = retString .. minutes .. ':'
    end
    return retString .. seconds
end

function TravelModule:SetHearthColor()
    if InCombatLockdown() then return end

    -- Determine which hearthstones to use
    local selectedHearthstones = {}
    if xb.db.profile.selectedHearthstones then
        for hearthstoneId, isSelected in pairs(xb.db.profile.selectedHearthstones) do
            if isSelected then table.insert(selectedHearthstones, hearthstoneId) end
        end
    end
    
    local usableHearthstones = #selectedHearthstones > 0 and selectedHearthstones or self.hearthstones
    
    -- Find usable transport
    local transport = self:FindUsableTransport(usableHearthstones, xb.db.profile.randomizeHs)
    local isActive = transport ~= nil
    
    if transport then
        self.hearthButton:SetAttribute("macrotext", transport.macro)
    end
    
    -- Set button appearance
    self:SetButtonState(self.hearthButton, self.hearthIcon, self.hearthText, 
                       isActive, self.hearthButton:IsMouseOver())
end

function TravelModule:SetPortColor()
    if InCombatLockdown() then return end

    local portItem = xb.db.char.portItem
    if not portItem or not self:IsUsable(portItem.portId) then
        portItem = self:FindFirstOption()
        if not portItem or not self:IsUsable(portItem.portId) then
            return
        end
    end
    
    -- Get transport name and set macro
    local transportName = self:GetTransportName(portItem.portId)
    local isActive = transportName ~= nil
    
    if transportName then
        -- Use global IsUsableItem with compatibility check
        local isUsableItemFunc = SafeIsUsableItem(portItem.portId)
        local macro = isUsableItemFunc and "/use item:" .. portItem.portId or "/cast " .. transportName
        self.portButton:SetAttribute("macrotext", macro)
    end
    
    -- Set button appearance
    self:SetButtonState(self.portButton, self.portIcon, self.portText, 
                       isActive, self.portButton:IsMouseOver())
end

function TravelModule:SetHomeColor()
    if InCombatLockdown() then return end
    if not self.homeButton then return end

    local hasHouse = self.playerHouseList and #self.playerHouseList > 0

    if self.homeButton:IsMouseOver() then
        self.homeIcon:SetVertexColor(unpack(xb:HoverColors()))
    elseif hasHouse then
        self.homeIcon:SetVertexColor(xb:GetColor('normal'))
    else
        local db = xb.db.profile
        self.homeIcon:SetVertexColor(db.color.inactive.r, db.color.inactive.g,
                                     db.color.inactive.b, db.color.inactive.a)
    end
end

function TravelModule:UpdateHouseAttributes()
    if not compat.isMainline or not self.homeButton then return end

    if not self.playerHouseList or #self.playerHouseList == 0 then
        C_Housing.GetPlayerOwnedHouses()
        return
    end

    if InCombatLockdown() then return end

    local house = self.playerHouseList[1]
    if house and house.neighborhoodGUID and house.houseGUID and house.plotID then
        self.homeButton:SetAttribute('house-neighborhood-guid',
                                     house.neighborhoodGUID)
        self.homeButton:SetAttribute('house-guid', house.houseGUID)
        self.homeButton:SetAttribute('house-plot-id', house.plotID)
    end
end

function TravelModule:OnHouseListUpdated(_, houseInfoList)
    self.playerHouseList = houseInfoList
    if not InCombatLockdown() then
        self:UpdateHouseAttributes()
        self:Refresh()
    end
end

function TravelModule:SetMythicColor()
    if InCombatLockdown() then return; end

    local hideMythicText = xb.db and xb.db.profile and xb.db.profile.hideMythicText

    if self.mythicButton:IsMouseOver() then
        if(hideMythicText) then
            self.mythicIcon:SetVertexColor(unpack(xb:HoverColors()))
        end
        self.mythicText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.mythicIcon:SetVertexColor(xb:GetColor('normal'))
        self.mythicText:SetTextColor(xb:GetColor('normal'))
    end -- else
end

function TravelModule:GetCurrentSeason()
    local currentDate = date("%Y-%m-%d")
    local currentSeason = nil
    local latestDate = nil

    -- Find the most recent season start date that is before or equal to today
    for startDate, seasonKey in pairs(XIVBar.SEASON_START_DATES) do
        if startDate <= currentDate and (latestDate == nil or startDate > latestDate) then
            latestDate = startDate
            currentSeason = seasonKey
        end
    end

    return currentSeason
end

-- Utility function to resolve teleport references
function TravelModule:ResolveTeleportReference(teleportRef)
    if type(teleportRef) == "string" then
        -- Parse the reference (format: "ExpansionKey.TeleportKey")
        local expansionKey, teleportKey = strsplit(".", teleportRef)
        if expansionKey and teleportKey and xb.MythicTeleports[expansionKey] and xb.MythicTeleports[expansionKey].teleports[teleportKey] then
            return xb.MythicTeleports[expansionKey].teleports[teleportKey]
        end
    end
    return teleportRef -- Return as-is if not a reference or reference not found
end

-- Utility function to check if a teleport spell is known
function TravelModule:IsKnownTeleportSpell(teleportId)
    if type(teleportId) == "table" then
        for _, id in ipairs(teleportId) do
            if IsSpellKnown(id) then
                return id
            end
        end
        return nil
    else
        return IsSpellKnown(teleportId) and teleportId or nil
    end
end

-- Utility function to check if any mythic teleport is available
function TravelModule:HasAvailableMythicTeleports()
    if not compat.isMainline then
        return false
    end
    local currentSeason = self:GetCurrentSeason()

    if xb.db.profile.curSeasonOnly then
        -- Check current season teleports
        if currentSeason and xb.MythicTeleports[currentSeason] then
            for _, teleportRef in ipairs(xb.MythicTeleports[currentSeason].teleports) do
                local value = self:ResolveTeleportReference(teleportRef)
                if value and value.teleportId then
                    local knownId = self:IsKnownTeleportSpell(value.teleportId)
                    if knownId then
                        return true
                    end
                end
            end
        end

        -- If no teleports in current season, check CURRENT
        if xb.MythicTeleports.CURRENT then
            for _, teleportRef in ipairs(xb.MythicTeleports.CURRENT.teleports) do
                local value = self:ResolveTeleportReference(teleportRef)
                if value and value.teleportId then
                    local knownId = self:IsKnownTeleportSpell(value.teleportId)
                    if knownId then
                        return true
                    end
                end
            end
        end
    else
        -- Check all expansions
        for _, expansion in pairs(xb.MythicTeleports) do
            if expansion.teleports then
                for _, teleportRef in ipairs(expansion.teleports) do
                    local value = self:ResolveTeleportReference(teleportRef)
                    if value and value.teleportId then
                        local knownId = self:IsKnownTeleportSpell(value.teleportId)
                        if knownId then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

-- Utility function to get teleport information
function TravelModule:GetTeleportInfo(teleportData)
    local teleportId = teleportData.teleportId
    local knownId = self:IsKnownTeleportSpell(teleportId)

    if knownId then
        local spellName = C_Spell.GetSpellName(knownId)
        local dungeonName = GetLFGDungeonInfo(teleportData.dungeonId)

        if spellName and dungeonName then
            return {
                teleportData = teleportData,
                spellName = spellName,
                dungeonName = dungeonName,
                knownId = knownId
            }
        end
    end

    return nil
end

-- Utility function to collect teleports from a season or expansion
function TravelModule:CollectTeleports(teleportsList)
    local result = {}

    for _, teleportRef in ipairs(teleportsList) do
        local teleportData = self:ResolveTeleportReference(teleportRef)
        if teleportData then
            local teleportInfo = self:GetTeleportInfo(teleportData)
            if teleportInfo then
                table.insert(result, teleportInfo)
            end
        end
    end

    -- Sort alphabetically by dungeon name
    table.sort(result, function(a, b)
        return a.dungeonName < b.dungeonName
    end)

    return result
end

-- Utility function to create a teleport button
function TravelModule:CreateTeleportButton(teleportInfo)
    local button = CreateFrame("Button",
                           "TravelMenuTeleportButton" .. teleportInfo.spellName,
                           UIParent,
                           "UIDropDownMenuButtonTemplate, UIDropDownCustomMenuEntryTemplate, InsecureActionButtonTemplate")

    button:SetText(teleportInfo.dungeonName)
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", teleportInfo.spellName)
    button:SetAttribute("useOnKeyDown", true)
    button:RegisterForClicks("LeftButtonDown", "LeftButtonUp")

    -- Hide the checkboxes
    for i, region in pairs {button:GetRegions()} do
        if region:GetObjectType() == "Texture" then region:Hide() end
    end

    -- Move the text to the right by 5 units
    local text = button:GetFontString()
    text:SetPoint('LEFT', 5, 0)
    local font, _, flags = text:GetFont()
    text:SetFont(font, 12, flags)

    local textWidth = text:GetStringWidth()
    button:SetSize(textWidth + xb.db.profile.general.barPadding + 5, 16)

    button:HookScript("PostClick",
                  function(self, button, down)
        CloseDropDownMenus()
    end)

    return button
end

function TravelModule:CreatePortPopup()
    if not self.portPopup then return; end

    local db = xb.db.profile
    self.portOptionString = self.portOptionString or
                                self.portPopup:CreateFontString(nil, 'OVERLAY')
    self.portOptionString:SetFont(xb:GetFont(db.text.fontSize +
                                                 self.optionTextExtra))
    local r, g, b, _ = unpack(xb:HoverColors())
    self.portOptionString:SetTextColor(r, g, b, 1)
    self.portOptionString:SetText(L['Port Options'])
    self.portOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
    self.portOptionString:SetPoint('CENTER')

    local popupWidth = self.portPopup:GetWidth()
    local popupHeight = xb.constants.popupPadding + db.text.fontSize +
                            self.optionTextExtra
    local changedWidth = false
    for i, v in pairs(self.portOptions) do
        if self.portButtons[v.portId] == nil then
            if PlayerHasToy(v.portId) or IsPlayerSpell(v.portId) or
                SafeIsUsableItem(v.portId) then
                local button = CreateFrame('BUTTON', nil, self.portPopup)
                local buttonText = button:CreateFontString(nil, 'OVERLAY')

                buttonText:SetFont(xb:GetFont(db.text.fontSize))
                buttonText:SetTextColor(xb:GetColor('normal'))
                local label = GetPortLabel(v.portId) or v.text
                v.text = label
                buttonText:SetText(label)
                buttonText:SetPoint('LEFT')
                local textWidth = buttonText:GetStringWidth()

                button:SetID(v.portId)
                button:SetSize(textWidth, db.text.fontSize)
                button.isSettable = true
                button.portItem = v
                button.textField = buttonText

                button:EnableMouse(true)
                button:RegisterForClicks('LeftButtonUp')

                button:SetScript('OnEnter', function()
                    buttonText:SetTextColor(xb:GetColor('normal'))
                end)

                button:SetScript('OnLeave', function()
                    buttonText:SetTextColor(xb:GetColor('normal'))
                end)

                button:SetScript('OnClick', function(self)
                    xb.db.char.portItem = { portId = self.portItem.portId }
                    TravelModule:Refresh()
                end)

                self.portButtons[v.portId] = button

                if textWidth > popupWidth then
                    popupWidth = textWidth
                    changedWidth = true
                end
            end -- if usable item or spell
        else
            if not (PlayerHasToy(v.portId) or IsPlayerSpell(v.portId) or
                SafeIsUsableItem(v.portId)) then
                self.portButtons[v.portId].isSettable = false
            else
                local label = GetPortLabel(v.portId) or v.text
                v.text = label
                local button = self.portButtons[v.portId]
                if button and button.textField then
                    button.textField:SetText(label)
                    local textWidth = button.textField:GetStringWidth()
                    button:SetSize(textWidth, db.text.fontSize)
                end
            end
        end -- if nil
    end -- for ipairs portOptions

    for portId, button in pairs(self.portButtons) do
        if button.isSettable then
            button:SetPoint('LEFT', xb.constants.popupPadding, 0)
            button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
            button:SetPoint('RIGHT')
            popupHeight = popupHeight + xb.constants.popupPadding +
                              db.text.fontSize
        else
            button:Hide()
        end
    end -- for id/button in portButtons

    if changedWidth then popupWidth = popupWidth + self.extraPadding end

    if popupWidth < self.portButton:GetWidth() then
        popupWidth = self.portButton:GetWidth()
    end

    if popupWidth < (self.portOptionString:GetStringWidth() + self.extraPadding) then
        popupWidth =
            (self.portOptionString:GetStringWidth() + self.extraPadding)
    end
    self.portPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)
end

function TravelModule:CreateMythicPopup()
    if not compat.isMainline then
        return
    end
    -- Get the current season
    local currentSeason = self:GetCurrentSeason()

    -- Create popup menu
    local filteredTeleports = {}

    if xb.db.profile.curSeasonOnly then
        -- Use current season if available
        if currentSeason and xb.MythicTeleports[currentSeason] then
            local teleports = self:CollectTeleports(xb.MythicTeleports[currentSeason].teleports)

            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current season"],
                    teleports = teleports
                })
            end
        end

        -- If no teleports for current season, use CURRENT
        if #filteredTeleports == 0 and xb.MythicTeleports.CURRENT then
            local teleports = self:CollectTeleports(xb.MythicTeleports.CURRENT.teleports)

            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current season"],
                    teleports = teleports
                })
            end
        end
    else
        -- If not curSeasonOnly, show all expansions
        local expansions = {}
        for key, expansion in pairs(xb.MythicTeleports) do
            if key ~= "CURRENT" and not string.match(key, "TWW_%d") then
                table.insert(expansions, {
                    key = key,
                    data = expansion
                })
            end
        end

        -- Sort expansions by order (reverse chronological)
        table.sort(expansions, function(a, b)
            local orderA = a.data.order or 0
            local orderB = b.data.order or 0
            return orderA > orderB
        end)

        -- Process each expansion
        for _, expansion in ipairs(expansions) do
            if expansion.data.teleports then
                local teleports = {}

                for _, value in pairs(expansion.data.teleports) do
                    local teleportInfo = self:GetTeleportInfo(value)
                    if teleportInfo then
                        table.insert(teleports, teleportInfo)
                    end
                end

                -- Sort alphabetically by dungeon name
                table.sort(teleports, function(a, b)
                    return a.dungeonName < b.dungeonName
                end)

                if #teleports > 0 then
                    table.insert(filteredTeleports, {
                        name = expansion.data.name,
                        teleports = teleports
                    })
                end
            end
        end

        -- Add current season at the bottom if available
        if currentSeason and xb.MythicTeleports[currentSeason] then
            local teleports = self:CollectTeleports(xb.MythicTeleports[currentSeason].teleports)

            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current season"],
                    teleports = teleports
                })
            end
        end
    end

    -- Function to add title and separator to the menu
    local function AddMenuHeader(level)
        -- Title
        local info = UIDropDownMenu_CreateInfo()
        local r, g, b, _ = unpack(xb:HoverColors())
        info.text = '[|cFF' .. string.format('%02x', r * 255) ..
                        string.format('%02x', g * 255) ..
                        string.format('%02x', b * 255) ..
                        L['Mythic+ Teleports'] .. '|r]'
        info.notClickable, info.notCheckable = true, true
        UIDropDownMenu_AddButton(info, level)

        -- Separator
        local separator = UIDropDownMenu_CreateInfo()
        separator.text = ""
        separator.disabled = true
        separator.notClickable = true
        separator.isTitle = true
        separator.leftPadding = 10
        separator.textHeight = 1 -- Makes the separator line thinner
        separator.notCheckable = true
        UIDropDownMenu_AddButton(separator, level)
    end

    if not xb.db.profile.curSeasonOnly then -- Two-level menu
        UIDropDownMenu_Initialize(self.mythicPopup, function(self, level, menuList)
            if (level or 1) == 1 then
                AddMenuHeader(level)

                -- Add expansions with teleports as menu items
                for _, expData in ipairs(filteredTeleports) do
                    if expData.teleports and next(expData.teleports) then
                        local info = UIDropDownMenu_CreateInfo()
                        info.text, info.checked = expData.name, false
                        info.menuList, info.hasArrow = expData.teleports, true
                        info.notCheckable = true
                        info.value = expData.teleports
                        UIDropDownMenu_AddButton(info, level)
                    end
                end
            else
                -- Add sorted teleports to the menu
                for _, teleport in ipairs(menuList) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.customFrame = TravelModule:CreateTeleportButton(teleport)
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end, 'MENU')
    else -- Single-level menu
        UIDropDownMenu_Initialize(self.mythicPopup, function(self, level, menuList)
            AddMenuHeader(level)

            -- Add all teleports to the menu
            local allTeleports = {}
            for _, expData in ipairs(filteredTeleports) do
                for _, teleport in ipairs(expData.teleports) do
                    table.insert(allTeleports, teleport)
                end
            end

            -- Sort by dungeon name
            table.sort(allTeleports, function(a, b)
                return a.dungeonName < b.dungeonName
            end)

            -- Add sorted teleports to the menu
            for _, teleport in ipairs(allTeleports) do
                local info = UIDropDownMenu_CreateInfo()
                info.customFrame = TravelModule:CreateTeleportButton(teleport)
                UIDropDownMenu_AddButton(info, level)
            end
        end, 'MENU')
    end

    for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
        local button = _G["DropDownList1Button" .. i]
        if button then
            local text = button:GetFontString()
            if text then
                local font, _, flags = text:GetFont()
                text:SetFont(font, 12, flags) -- Change `14` to your desired font size
            end
        end
    end
end

function TravelModule:Refresh()
    if self.hearthFrame == nil then return; end

    if not xb.db.profile.modules.travel.enabled then
        self:Disable();
        return;
    end

    if not xb.db.profile.randomizeHs then
        -- Heartstone Randomizer
        self.hearthButton:SetScript('PreClick', function()
            -- end
        end)
    else
        self.hearthButton:SetScript('PreClick', function()
            TravelModule:SetHearthColor()
        end)
    end

    local db = xb.db.profile
    local allowMythic = compat.isMainline and db.enableMythicPortals

    self:UpdatePortOptions()
    local hasPortOptions = false
    if self.portOptions then
        for _, option in pairs(self.portOptions) do
            if option and option.portId and self:IsUsable(option.portId) then
                hasPortOptions = true
                break
            end
        end
    end

    if allowMythic and not self.mythicButton then
        if InCombatLockdown() then
            self.pendingMythicCreate = true
        else
            self:CreateMythicFrames()
        end
    end

    if not allowMythic and self.mythicButton and not InCombatLockdown() then
        self.mythicButton:Hide()
    end

    if not hasPortOptions and self.portButton and not InCombatLockdown() then
        self.portButton:Hide()
    end

    if InCombatLockdown() then
        if not select(1, self.hearthText:GetFont()) then
            self.hearthText:SetFont(xb:GetFont(xb.db.profile.text.fontSize))
        end
        if not select(1, self.portText:GetFont()) then
            self.portText:SetFont(xb:GetFont(xb.db.profile.text.fontSize))
        end

        self.hearthText:SetText(GetBindLocation())
        local combatPortItem = xb.db.char.portItem or self:FindFirstOption()
        local combatPortText = combatPortItem and (combatPortItem.text or GetPortLabel(combatPortItem.portId)) or ''
        self.portText:SetText(combatPortText)
        self:SetHearthColor()
        self:SetPortColor()
        if allowMythic then
            self:SetMythicColor()
        end

        local totalWidth = self.hearthButton:GetWidth() + db.general.barPadding
        if hasPortOptions and self.portButton and not self.portButton:IsVisible() then
            self.portButton:Show()
        end
        if self.portButton:IsVisible() then
            totalWidth = totalWidth + self.portButton:GetWidth()
        end

        if allowMythic and self.mythicButton and self.mythicButton:IsVisible() then
            totalWidth = totalWidth + self.mythicButton:GetWidth()
        end

        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding

    -- Hearthstone Part
    if not db.hideHearthstoneButton then
        self.hearthText:SetFont(xb:GetFont(db.text.fontSize))
        self.hearthText:SetText(GetBindLocation())

        self.hearthButton:SetSize(self.hearthText:GetWidth() + iconSize +
                                    db.general.barPadding, xb:GetHeight())
        self.hearthButton:SetPoint("RIGHT")

        self.hearthText:SetPoint("RIGHT")

        self.hearthIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\hearth')
        self.hearthIcon:SetSize(iconSize, iconSize)

        self.hearthIcon:SetPoint("RIGHT", self.hearthText, "LEFT",
                                -(db.general.barPadding), 0)

        self:SetHearthColor()
        if not self.hearthButton:IsVisible() then
            self.hearthButton:Show()
            self.hearthText:Show()
        end
    else
        self.hearthButton:Hide()
        self.hearthText:Hide()
    end

    -- Portals Part
    if hasPortOptions and not db.hidePortButton then
        self.portButton:Show()
        self.portText:SetFont(xb:GetFont(db.text.fontSize))
        local portItem = xb.db.char.portItem or self:FindFirstOption()
        local portText = portItem and (portItem.text or GetPortLabel(portItem.portId)) or ''
        self.portText:SetText(portText)

        self.portButton:SetSize(self.portText:GetWidth() + iconSize +
                                    db.general.barPadding, xb:GetHeight())

        -- Set parent to main button if hearth is hidden
        local parent = self.hearthButton
        local parentPoint, relPoint, xOff = "RIGHT", "LEFT", -(db.general.barPadding)

        if db.hideHearthstoneButton or not (self.hearthButton and self.hearthButton:IsShown()) then
            parent = self.hearthFrame
            parentPoint, relPoint, xOff = "RIGHT", "RIGHT", 0  -- Stick to the right
        end

        self.portButton:SetPoint(parentPoint, parent, relPoint, xOff, 0)

        self.portText:SetPoint("RIGHT")
        self.portIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\garr')
        self.portIcon:SetSize(iconSize, iconSize)
        self.portIcon:SetPoint("RIGHT", self.portText, "LEFT", -(db.general.barPadding), 0)

        self:SetPortColor()
        self:CreatePortPopup()
    else
        self.portButton:Hide()
        self.portPopup:Hide()
    end

    -- M+ Part
    if self.mythicButton and not InCombatLockdown() then
        self.mythicButton:Hide()
    end

    if allowMythic and self.mythicButton then
        -- Choose the parent based on visible buttons
        local parentFrame = self.portButton
        local parentPoint, relPoint, xOff = "RIGHT", "LEFT", -(db.general.barPadding)

        local portShown = self.portButton and self.portButton:IsShown()
        local hearthShown = self.hearthButton and self.hearthButton:IsShown()

        if not portShown then
            parentFrame = self.hearthButton
        end
        if (not portShown and not hearthShown) or (db.hidePortButton and db.hideHearthstoneButton) then
            parentFrame = self.hearthFrame
            parentPoint, relPoint, xOff = "RIGHT", "RIGHT", 0
        end

        -- Only show the button if teleports are available
        if self:HasAvailableMythicTeleports() then
            local hideMythicText = db.hideMythicText

            self.mythicText:SetFont(xb:GetFont(db.text.fontSize))
            self.mythicText:SetText(hideMythicText and '' or L['M+ Teleports'])
            self.mythicText:SetShown(not hideMythicText)

            self.mythicIcon:SetTexture(xb.constants.mediaPath .. 'microbar\\lfg')
            self.mythicIcon:SetSize(iconSize + 8, iconSize + 8)
            self.mythicIcon:ClearAllPoints()

            if hideMythicText then
                self.mythicButton:SetSize(iconSize + db.general.barPadding, xb:GetHeight())
                self.mythicButton:SetPoint(parentPoint, parentFrame, relPoint, xOff, 0)
                self.mythicIcon:SetPoint("RIGHT", self.mythicButton, "RIGHT", 0, 0)
            else
                self.mythicButton:SetSize(self.mythicText:GetWidth() + iconSize + db.general.barPadding, xb:GetHeight())
                self.mythicButton:SetPoint(parentPoint, parentFrame, relPoint, xOff, 0)
                self.mythicText:SetPoint("RIGHT")
                self.mythicIcon:SetPoint("RIGHT", self.mythicText, "LEFT", -(db.general.barPadding) + 5, 0)
            end

            self:SetMythicColor()
            self:CreateMythicPopup()
            self.mythicButton:Show()
        end
    end

    -- Home (Housing) Part - Retail only
    if compat.isMainline and self.homeButton and not db.hideHomeButton then
        -- Choose the parent based on visible buttons
        local homeParentFrame = self.mythicButton and
                                    self.mythicButton:IsShown() and
                                    self.mythicButton or
                                    (self.portButton and
                                        self.portButton:IsShown() and
                                        self.portButton) or
                                    (self.hearthButton and
                                        self.hearthButton:IsShown() and
                                        self.hearthButton) or self.hearthFrame
        local homeParentPoint, homeRelPoint, homeXOff = "RIGHT", "LEFT",
                                                        -(db.general.barPadding)

        if homeParentFrame == self.hearthFrame then
            homeParentPoint, homeRelPoint, homeXOff = "RIGHT", "RIGHT", 0
        end

        self.homeButton:SetSize(iconSize + db.general.barPadding, xb:GetHeight())
        self.homeButton:SetPoint(homeParentPoint, homeParentFrame, homeRelPoint,
                                 homeXOff, 0)

        self.homeIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\house')
        self.homeIcon:SetSize(iconSize, iconSize)
        self.homeIcon:SetPoint("RIGHT", self.homeButton, "RIGHT", 0, 0)

        self:SetHomeColor()
        self:UpdateHouseAttributes()
        self.homeButton:Show()
    elseif self.homeButton then
        self.homeButton:Hide()
    end

    local popupPadding = xb.constants.popupPadding
    local popupPoint = 'BOTTOM'
    local relPoint = 'TOP'
    if db.general.barPosition == 'TOP' then
        popupPadding = -(popupPadding)
        popupPoint = 'TOP'
        relPoint = 'BOTTOM'
    end

    self.portPopup:ClearAllPoints()
    self.portPopup:SetPoint(popupPoint, self.portButton, relPoint, 0, 0)
    self:SkinFrame(self.portPopup, "SpecToolTip")
    self.portPopup:Hide()

    if self.mythicPopup then
        self.mythicPopup:ClearAllPoints()

        if db.general.barPosition == 'TOP' then
            self.mythicPopup.point = "TOP"
            self.mythicPopup.relativePoint = "BOTTOM"
        else
            self.mythicPopup.point = "BOTTOM"
            self.mythicPopup.relativePoint = "TOP"
        end

        self:SkinFrame(self.mythicPopup, "SpecToolTip")
        self.mythicPopup:Hide()
    end

    local totalWidth = 0
    if self.hearthButton:IsVisible() then
        totalWidth = totalWidth + self.hearthButton:GetWidth() + db.general.barPadding
    end
    if self.portButton:IsVisible() then
        totalWidth = totalWidth + self.portButton:GetWidth()
    end

    if allowMythic and self.mythicButton and self.mythicButton:IsVisible() then
        totalWidth = totalWidth + self.mythicButton:GetWidth()
    end
    if compat.isMainline and self.homeButton and self.homeButton:IsVisible() then
        totalWidth = totalWidth + self.homeButton:GetWidth() +
                         db.general.barPadding
    end
    self.hearthFrame:SetSize(totalWidth, xb:GetHeight())
    self.hearthFrame:SetPoint("RIGHT", -(db.general.barPadding), 0)
    self.hearthFrame:Show()
end

-- Optimized tooltip display using utility functions
function TravelModule:ShowTooltip()
    if not self.portPopup:IsVisible() then
        GameTooltip:SetOwner(self.portButton, 'ANCHOR_' .. xb.miniTextPosition)
        GameTooltip:ClearLines()
        local r, g, b, _ = unpack(xb:HoverColors())
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. L['Travel Cooldowns'] .. "|cFFFFFFFF]|r", r, g, b)

        -- Show hearthstone cooldown using utility function
        local hearthstoneId = 6948 -- Regular Hearthstone ID
        local hearthCooldown = self:GetRemainingCooldown(hearthstoneId, false)
        local hearthCdString = self:FormatCooldown(hearthCooldown)
        GameTooltip:AddDoubleLine(L['Hearthstone'], hearthCdString, r, g, b, 1, 1, 1)

        -- Show teleport cooldowns using utility functions
        if self.portOptions then
            for _, portOption in pairs(self.portOptions) do
                if portOption and portOption.portId then
                    local label = portOption.text or GetPortLabel(portOption.portId)
                    local isSpell = IsSpellKnown(portOption.portId)
                    
                    if isSpell then
                        -- Handle spells
                        local spellCooldown = self:GetRemainingCooldown(portOption.portId, true)
                        local cdString = self:FormatCooldown(spellCooldown)
                        GameTooltip:AddDoubleLine(label, cdString, r, g, b, 1, 1, 1)
                    elseif PlayerHasToy(portOption.portId) or SafeIsUsableItem(portOption.portId) then
                        -- Handle items and toys
                        local itemCooldown = self:GetRemainingCooldown(portOption.portId, false)
                        local cdString = self:FormatCooldown(itemCooldown)
                        GameTooltip:AddDoubleLine(label, cdString, r, g, b, 1, 1, 1)
                    end
                end
            end
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine('<' .. L['Right-Click'] .. '>', L['Change Port Option'], r, g, b, 1, 1, 1)
        GameTooltip:Show()

        -- Update the tooltip every second
        if not self.tooltipTimer then
            self.tooltipTimer = C_Timer.NewTicker(1, function()
                if GameTooltip:IsOwned(self.portButton) then
                    self:ShowTooltip()
                else
                    self.tooltipTimer:Cancel()
                    self.tooltipTimer = nil
                end
            end)
        end
    end
end

function TravelModule:FindFirstOption()
    local firstItem = {portId = 140192, text = GetItemName(140192)}
    if self.portOptions then
        for k, v in pairs(self.portOptions) do
            if self:IsUsable(v.portId) then
                firstItem = v
                break
            end
        end
    end
    return firstItem
end

function TravelModule:IsUsable(id)
    return PlayerHasToy(id) or SafeIsUsableItem(id) or IsPlayerSpell(id)
end

function TravelModule:RefreshHearthstonesList()
    local function has_index(tab, ind)
        for index, value in pairs(tab) do
            if index == ind then return true end
        end

        return false
    end

    if xb.db.profile.hearthstonesList == nil then
        xb.db.profile.hearthstonesList = {}
        for i, v in ipairs(self.hearthstones) do
            if self:IsUsable(v) then
                table.insert(xb.db.profile.hearthstonesList, v, "")
            end
        end
    else
        for i, v in ipairs(self.hearthstones) do
            if not has_index(xb.db.profile.hearthstonesList, v) then
                if self:IsUsable(v) then
                    table.insert(xb.db.profile.hearthstonesList, v, "")
                end
            end
        end
    end

    for i, v in pairs(xb.db.profile.hearthstonesList) do
        if v == '' or v == nil then
            local hearthName = ''
            local _, name, _, _, _, _ = C_ToyBox.GetToyInfo(i)
            hearthName = name
            xb.db.profile.hearthstonesList[i] = hearthName
        end
    end
end

function TravelModule:GetDefaultOptions()
    local firstItem = self:FindFirstOption()
    xb.db.char.portItem = xb.db.char.portItem or firstItem
    return 'travel', {
        enabled = true,
        hideHearthstoneButton = false,
        hideHomeButton = false,
        enableMythicPortals = compat.isMainline,
        hideMythicText = false,
        curSeasonOnly = false,
        randomizeHs = false
    }
end

function TravelModule:GetHearthstoneValues()
    if xb.db.profile.hearthstoneCache == nil then
        xb.db.profile.hearthstoneCache = {}
    end

    local values = {}
    for i, v in ipairs(self.hearthstones) do
        if self:IsUsable(v) then
            local name = GetItemInfo(v)

            if not name then
                local _, toyName = C_ToyBox.GetToyInfo(v)
                name = toyName
            end

            if not name and IsPlayerSpell(v) then
                local spellInfo = GetSpellInfo(v)
                if spellInfo then name = spellInfo.name end
            end

            if name then
                values[v] = name
                xb.db.profile.hearthstoneCache[v] = name
            else
                if xb.db.profile.hearthstoneCache[v] then
                    values[v] = xb.db.profile.hearthstoneCache[v]
                else
                    values[v] = L['Retrieving data'] .. " (" .. v .. ")"
                end
            end
        end
    end
    return values
end

function TravelModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 10,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.travel.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.travel.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            hideHearthstoneButton = {
                name = L['Hide Hearthstone Button'],
                order = 12,
                type = "toggle",
                get = function()
                    return xb.db.profile.hideHearthstoneButton;
                end,
                set = function(_, val)
                    xb.db.profile.hideHearthstoneButton = val;
                    self:Refresh();
                end,
                width = "full"
            },
            hidePortButton = {
                name = L['Hide Port Button'],
                order = 14,
                type = "toggle",
                get = function()
                    return xb.db.profile.hidePortButton;
                end,
                set = function(_, val)
                    xb.db.profile.hidePortButton = val;
                    self:Refresh();
                end,
                width = "full"
            },
            hideHomeButton = {
                name = L['Hide Home Button'],
                order = 15,
                type = "toggle",
                hidden = function() return not compat.isMainline end,
                get = function()
                    return xb.db.profile.hideHomeButton;
                end,
                set = function(_, val)
                    xb.db.profile.hideHomeButton = val;
                    self:Refresh();
                end,
                width = "full"
            },
            mythicHeader = {
                order = 18,
                name = L['Mythic+ Teleports'],
                type = 'header',
                hidden = function() return not compat.isMainline end
            },
            enableMythicPortals = {
                name = L['Show Mythic+ Teleports'],
                order = 20,
                type = "toggle",
                hidden = function() return not compat.isMainline end,
                get = function()
                    return xb.db.profile.enableMythicPortals;
                end,
                set = function(_, val)
                    xb.db.profile.enableMythicPortals = val;
                    self:Refresh();
                end,
                width = 1.2
            },
            hideMythicText = {
                name = L['Hide M+ Teleports text'],
                order = 22,
                type = "toggle",
                hidden = function() return not compat.isMainline end,
                get = function()
                    return xb.db.profile.hideMythicText;
                end,
                set = function(_, val)
                    xb.db.profile.hideMythicText = val;
                    self:Refresh();
                end,
                width = 1.2
            },
            curSeasonOnly = {
                name = L['Only show current season'],
                order = 25,
                type = "toggle",
                hidden = function() return not compat.isMainline end,
                get = function()
                    return xb.db.profile.curSeasonOnly;
                end,
                set = function(_, val)
                    xb.db.profile.curSeasonOnly = val;
                    self:Refresh();
                end,
                width = "full"
            },
            hearthstoneHeader = {
                order = 28,
                name = "Hearthstones",
                type = 'header',
            },
            randomizeHs = {
                name = L['Use Random Hearthstone'],
                order = 30,
                type = "toggle",
                get = function()
                    return xb.db.profile.randomizeHs;
                end,
                set = function(_, val)
                    xb.db.profile.randomizeHs = val;
                    self:Refresh();
                end,
                width = "full"
            },
            information = {
                name = L['Empty Hearthstones List'],
                order = 40,
                type = "description"
            },
            selectedHearthstones = {
                order = 50,
                name = L['Hearthstones Select'],
                desc = L['Hearthstones Select Desc'],
                type = "multiselect",
                values = function() return self:GetHearthstoneValues() end,
                get = function(_, key)
                    return xb.db.profile.selectedHearthstones[key]
                end,
                set = function(_, key, state)
                    xb.db.profile.selectedHearthstones[key] = state
                    self:Refresh()
                end
            }
        }
    }
end