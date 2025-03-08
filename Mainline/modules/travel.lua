local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local TravelModule = xb:NewModule("TravelModule", 'AceEvent-3.0')

local GetItemInfo = C_Item.GetItemInfo
local IsUsableItem = C_Item.IsUsableItem
local GetItemCooldown = C_Container.GetItemCooldown

local GetSpellCooldown = C_Spell.GetSpellCooldown
local GetSpellInfo = C_Spell.GetSpellInfo

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function TravelModule:GetName() return L['Travel']; end

function TravelModule:OnInitialize()
    self.iconPath = xb.constants.mediaPath .. 'datatexts\\repair'
    self.garrisonHearth = 110560
    self.hearthstones = {
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
        210455 -- Draenic Hologem
    }

    self.portButtons = {}
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
    self.availableHearthstones = {}
    self.selectedHearthstones = {}
    self.noMythicTeleport = true
end

local portal = C_CVar.GetCVar("portal")
if portal == "US" then
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-04"] = "TWW_2",  -- TWW Season 2 start date
    }
elseif portal == "EU" then
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2",  -- TWW Season 2 start date
    }
else
    XIVBar.SEASON_START_DATES = {
        ["2024-09-10"] = "TWW_1",  -- TWW Season 1 start date
        ["2025-03-05"] = "TWW_2",  -- TWW Season 2 start date
    }
end

-- Skin Support for ElvUI/TukUI
-- Make sure to disable "Tooltip" in the Skins section of ElvUI together with
-- unchecking "Use ElvUI for tooltips" in XIV options to not have ElvUI fuck with tooltips
function TravelModule:SkinFrame(frame, name)
    if self.useElvUI then
        if frame.StripTextures then frame:StripTextures() end
        if frame.SetTemplate then frame:SetTemplate("Transparent") end

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
end

function TravelModule:CreateFrames()
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

    -- Mythic+ Part
    self.mythicButton = self.mythicButton or
                            CreateFrame('BUTTON', 'mythicButton',
                                        self.hearthFrame,
                                        'SecureActionButtonTemplate')
    self.mythicIcon = self.mythicIcon or
                          self.mythicButton:CreateTexture(nil, 'OVERLAY')
    self.mythicText = self.mythicText or
                          self.mythicButton:CreateFontString(nil, 'OVERLAY')

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
            self.portPopup.NineSlice:SetCenterColor(
                GameTooltip.NineSlice:GetCenterColor())
            self.portPopup.NineSlice:SetBorderColor(
                GameTooltip.NineSlice:GetBorderColor())
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

    -- Mythic+ popup
    self.mythicPopup = self.mythicPopup or
                           CreateFrame('FRAME', 'mythicPopup',
                                       self.mythicButton,
                                       'UIDropDownMenuTemplate')
end

function TravelModule:RegisterFrameEvents()
    self:RegisterEvent('SPELLS_CHANGED', 'Refresh')
    self:RegisterEvent('BAG_UPDATE_DELAYED', 'Refresh')
    self:RegisterEvent('HEARTHSTONE_BOUND', 'Refresh')
    self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'RefreshHearthstonesList')

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

    self.mythicButton:EnableMouse(true)
    self.mythicButton:RegisterForClicks('LeftButtonUp', 'LeftButtonDown')
    self.mythicButton:SetAttribute('type', 'mythicFunction')
    self.mythicButton.HandlesGlobalMouseEvent = function() return true end

    self.mythicButton.mythicFunction = self.mythicButton.mythicFunction or
                                           function()
            if not InCombatLockdown() then
                ToggleDropDownMenu(1, nil, self.mythicPopup, self.mythicButton,
                                   0, 0)
            end
        end

    -- Heartstone Randomizer
    if xb.db.profile.randomizeHs then
        self.hearthButton:SetScript('PreClick', function()
            TravelModule:SetHearthColor()
        end)
    end

    self.hearthButton:SetScript('OnEnter', function()
        self:SetHearthColor()
        if InCombatLockdown() then return end
        self:ShowTooltip()
    end)

    self.hearthButton:SetScript('OnLeave', function()
        self:SetHearthColor()
        if self.tooltipTimer then
            self.tooltipTimer:Cancel()
            self.tooltipTimer = nil
        end
        GameTooltip:Hide()
    end)

    self.portButton:SetScript('OnEnter', function()
        TravelModule:SetPortColor()
        if InCombatLockdown() then return end
        self:ShowTooltip()
    end)

    self.portButton:SetScript('OnLeave', function()
        TravelModule:SetPortColor()
        if self.tooltipTimer then
            self.tooltipTimer:Cancel()
            self.tooltipTimer = nil
        end
        GameTooltip:Hide()
    end)

    self.mythicButton:SetScript('OnEnter', function()
        TravelModule:SetMythicColor()
        if InCombatLockdown() then return end
    end)

    self.mythicButton:SetScript('OnLeave', function()
        TravelModule:SetMythicColor()
        GameTooltip:Hide()
    end)

    self.portButton:SetScript('OnEnter', function()
        TravelModule:SetPortColor()
        if InCombatLockdown() then return end
        self:ShowTooltip()
    end)

    self.portButton:SetScript('OnLeave', function()
        TravelModule:SetPortColor()
        if self.tooltipTimer then
            self.tooltipTimer:Cancel()
            self.tooltipTimer = nil
        end
        GameTooltip:Hide()
    end)

    self.hearthButton:SetScript('OnEnter', function()
        self:SetHearthColor()
        if InCombatLockdown() then return end
        self:ShowTooltip()
    end)

    self.hearthButton:SetScript('OnLeave', function()
        self:SetHearthColor()
        if self.tooltipTimer then
            self.tooltipTimer:Cancel()
            self.tooltipTimer = nil
        end
        GameTooltip:Hide()
    end)
end

function TravelModule:UpdatePortOptions()
    if not self.portOptions then self.portOptions = {} end
    if IsUsableItem(128353) and not self.portOptions[128353] then
        self.portOptions[128353] = {
            portId = 128353, 
            text = GetItemInfo(128353)
        } -- admiral's compass
    end
    if PlayerHasToy(140192) and not self.portOptions[140192] then
        self.portOptions[140192] = {
            portId = 140192,
            text = xb.db.profile.dalaran_hs_string or GetItemInfo(140192)
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

    if xb.constants.playerClass == 'MAGE' and not self.portOptions[193759] then
        self.portOptions[193759] = {portId = 193759, text = ORDER_HALL_MAGE}
    end

    if xb.constants.playerClass == 'MONK' and not self.portOptions[193759] then
        local portText = C_Map.GetMapInfo(809)
        if IsPlayerSpell(200617) then portText = ORDER_HALL_MONK end
        self.portOptions[193759] = {portId = 193759, text = portText}
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
    if InCombatLockdown() then return; end

    local db = xb.db.profile

    self.hearthIcon:SetVertexColor(xb:GetColor('normal'))

    local hearthName = ''
    local hearthActive = true
    local keyset = {}
    local random_elem
    local selectedHearthstones = {}
    local usedHearthstones = {}

    if xb.db.profile.selectedHearthstones then
        for i, v in pairs(xb.db.profile.selectedHearthstones) do
            if v == true then table.insert(selectedHearthstones, i) end
        end
    end

    if #selectedHearthstones >= 1 then
        usedHearthstones = selectedHearthstones
    else
        usedHearthstones = self.hearthstones
    end

    for i, v in ipairs(usedHearthstones) do
        if IsUsableItem(v) then
            --if GetItemCooldown(v) == 0 then
                local name, _ = GetItemInfo(v)
                hearthName = name
                if hearthName ~= nil then
                    if xb.db.profile.randomizeHs then
                        table.insert(keyset, i)
                        self.availableHearthstones[v] = {name = hearthName}
                    else
                        hearthActive = true
                        self.hearthButton:SetAttribute("macrotext",
                                                       "/cast " .. hearthName)
                        break
                    end
                end
            --end
        end -- if toy/item
        if PlayerHasToy(v) then
            --if GetItemCooldown(v) == 0 then
                local _, name, _, _, _, _ = C_ToyBox.GetToyInfo(v)
                hearthName = name
                if hearthName ~= nil then
                    if xb.db.profile.randomizeHs then
                        table.insert(keyset, i)
                        self.availableHearthstones[v] = {name = hearthName}
                    else
                        hearthActive = true
                        self.hearthButton:SetAttribute("macrotext",
                                                       "/cast " .. hearthName)
                        break
                    end
                end
            --end
        end -- if toy/item
        if IsPlayerSpell(v) then
            local start, duration = GetSpellCooldown(v)
            --if start == 0 then
                local spellInfo = GetSpellInfo(v)
                if spellInfo then
                    hearthName = spellInfo.name
                    if xb.db.profile.randomizeHs then
                        table.insert(keyset, i)
                        self.availableHearthstones[v] = {name = hearthName}
                    else
                        hearthActive = true
                        self.hearthButton:SetAttribute("macrotext",
                                                       "/cast " .. hearthName)
                    end
                end
            --end
        end -- if is spell
    end -- for hearthstones

    if xb.db.profile.randomizeHs then
        random_elem = usedHearthstones[math.random(#usedHearthstones)]
        for k, v in pairs(self.availableHearthstones) do
            if k == random_elem then
                self.hearthButton:SetAttribute("macrotext", "/cast " .. v.name)
                break
            end
        end
    end

    if not hearthActive then
        self.hearthIcon:SetVertexColor(db.color.inactive.r, db.color.inactive.g,
                                       db.color.inactive.b, db.color.inactive.a)
        self.hearthText:SetTextColor(db.color.inactive.r, db.color.inactive.g,
                                     db.color.inactive.b, db.color.inactive.a)
    else
        if self.hearthButton:IsMouseOver() then
            self.hearthText:SetTextColor(unpack(xb:HoverColors()))
        else
            self.hearthText:SetTextColor(xb:GetColor('normal'))
        end
    end
end

function TravelModule:SetPortColor()
    if InCombatLockdown() then return; end

    local db = xb.db.profile
    local v = xb.db.char.portItem.portId

    if not (self:IsUsable(v)) then
        v = self:FindFirstOption()
        v = v.portId
        if not (self:IsUsable(v)) then
            -- self.portButton:Hide()
            return
        end
    end

    if self.portButton:IsMouseOver() then
        self.portText:SetTextColor(unpack(xb:HoverColors()))
    else
        local hearthname = ''
        local hearthActive = false

        if IsPlayerSpell(v) then
            local start, duration = GetSpellCooldown(v)
            --if start == 0 then
                local spellInfo = GetSpellInfo(v)
                if spellInfo then
                    hearthName = spellInfo.name
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            --end
        end -- if is spell
        if IsUsableItem(v) then
            --if GetItemCooldown(v) == 0 then
                local name, _ = GetItemInfo(v)
                hearthName = name
                if hearthName ~= nil then
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            --end
        end -- if item
        if PlayerHasToy(v) then
            --if GetItemCooldown(v) == 0 then
                local _, name, _, _, _, _ = C_ToyBox.GetToyInfo(v)
                hearthName = name
                if hearthName ~= nil then
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            --end
        end -- if toy

        if not hearthActive then
            self.portIcon:SetVertexColor(db.color.inactive.r,
                                         db.color.inactive.g,
                                         db.color.inactive.b,
                                         db.color.inactive.a)
            self.portText:SetTextColor(db.color.inactive.r, db.color.inactive.g,
                                       db.color.inactive.b, db.color.inactive.a)
        else
            self.portIcon:SetVertexColor(xb:GetColor('normal'))
            self.portText:SetTextColor(xb:GetColor('normal'))
        end
    end -- else
end

function TravelModule:SetMythicColor()
    if InCombatLockdown() then return; end

    if self.mythicButton:IsMouseOver() then
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

-- Helper function to resolve teleport references
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

-- Helper function to create a teleport button for the dropdown menu
local function CreateTeleportButton(teleportData, spellName)
    local frame = CreateFrame("Button", nil, nil, "UIDropDownCustomMenuEntryTemplate")
    frame:SetSize(100, 16)
    
    local dungeonName = GetLFGDungeonInfo(teleportData.dungeonId) or spellName
    
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text:SetPoint("LEFT", 10, 0)
    text:SetText(dungeonName)
    
    frame:SetScript("OnClick", function()
        CastSpellByID(teleportData.teleportId)
        CloseDropDownMenus()
    end)
    
    return frame
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
                IsUsableItem(v.portId) then
                local button = CreateFrame('BUTTON', nil, self.portPopup)
                local buttonText = button:CreateFontString(nil, 'OVERLAY')

                buttonText:SetFont(xb:GetFont(db.text.fontSize))
                buttonText:SetTextColor(xb:GetColor('normal'))
                buttonText:SetText(v.text)
                buttonText:SetPoint('LEFT')
                local textWidth = buttonText:GetStringWidth()

                button:SetID(v.portId)
                button:SetSize(textWidth, db.text.fontSize)
                button.isSettable = true
                button.portItem = v

                button:EnableMouse(true)
                button:RegisterForClicks('LeftButtonUp')

                button:SetScript('OnEnter', function()
                    buttonText:SetTextColor(xb:GetColor('normal'))
                end)

                button:SetScript('OnLeave', function()
                    buttonText:SetTextColor(xb:GetColor('normal'))
                end)

                button:SetScript('OnClick', function(self)
                    xb.db.char.portItem = self.portItem
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
                IsUsableItem(v.portId)) then
                self.portButtons[v.portId].isSettable = false
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
    end
end

function TravelModule:CreateMythicPopup()
    -- Get the current season
    local currentSeason = self:GetCurrentSeason()
    
    -- Create popup menu
    local expansions = {}
    
    -- Sort expansions by their order
    for expKey, expData in pairs(xb.MythicTeleports) do
        -- Skip season-specific entries when building the expansion list
        if not (expKey:match("^TWW_%d+$") or expKey == "CURRENT") then
            table.insert(expansions, {key = expKey, data = expData})
        end
    end
    
    table.sort(expansions, function(a, b) return a.data.order < b.data.order end)
    
    local filteredTeleports = {}
    if xb.db.profile.curSeasonOnly then
        -- Use the current season teleports if available
        if currentSeason and xb.MythicTeleports[currentSeason] then
            local teleports = {}
            for _, teleportRef in ipairs(xb.MythicTeleports[currentSeason].teleports) do
                -- Resolve the teleport reference
                local value = self:ResolveTeleportReference(teleportRef)
                
                -- Check if the teleport is valid and the spell is known
                if value and value.teleportId then
                    local spellName = C_Spell.GetSpellName(value.teleportId)
                    if spellName and IsSpellKnown(value.teleportId) then
                        table.insert(teleports, value)
                    end
                end
            end
            
            -- Sort teleports alphabetically by name
            table.sort(teleports, function(a, b)
                return (a.name or "") < (b.name or "")
            end)
            
            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current Season"],
                    teleports = teleports
                })
            end
        end
        
        -- If no current season teleports, use the default CURRENT
        if #filteredTeleports == 0 and xb.MythicTeleports.CURRENT then
            local teleports = {}
            for _, teleportRef in ipairs(xb.MythicTeleports.CURRENT.teleports) do
                local value = self:ResolveTeleportReference(teleportRef)
                if value and value.teleportId then
                    local spellName = C_Spell.GetSpellName(value.teleportId)
                    if spellName and IsSpellKnown(value.teleportId) then
                        table.insert(teleports, value)
                    end
                end
            end
            
            -- Sort teleports alphabetically by name
            table.sort(teleports, function(a, b)
                return (a.name or "") < (b.name or "")
            end)
            
            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current Season"],
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
            local teleports = {}
            
            -- Check if this is a regular expansion with teleports array
            if expansion.data.teleports then
                for teleportKey, value in pairs(expansion.data.teleports) do
                    if value.teleportId then
                        local spellName = C_Spell.GetSpellName(value.teleportId)
                        if spellName and IsSpellKnown(value.teleportId) then
                            table.insert(teleports, value)
                        end
                    end
                end
                
                -- Sort teleports alphabetically by name
                table.sort(teleports, function(a, b)
                    local nameA = GetLFGDungeonInfo(a.dungeonId) or ""
                    local nameB = GetLFGDungeonInfo(b.dungeonId) or ""
                    return nameA < nameB
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
            local teleports = {}
            for _, teleportRef in ipairs(xb.MythicTeleports[currentSeason].teleports) do
                local value = self:ResolveTeleportReference(teleportRef)
                if value and value.teleportId then
                    local spellName = C_Spell.GetSpellName(value.teleportId)
                    if spellName and IsSpellKnown(value.teleportId) then
                        table.insert(teleports, value)
                    end
                end
            end
            
            -- Sort teleports alphabetically by name
            table.sort(teleports, function(a, b)
                local nameA = GetLFGDungeonInfo(a.dungeonId) or ""
                local nameB = GetLFGDungeonInfo(b.dungeonId) or ""
                return nameA < nameB
            end)
            
            if #teleports > 0 then
                table.insert(filteredTeleports, {
                    name = L["Current Season"],
                    teleports = teleports
                })
            end
        end
    end

    local function CreateTeleportButton(value, spellName)
        local button = CreateFrame("Button",
                               "TravelMenuTeleportButton" .. spellName,
                               UIParent,
                               "UIDropDownMenuButtonTemplate, UIDropDownCustomMenuEntryTemplate, InsecureActionButtonTemplate")

        name = GetLFGDungeonInfo(value.dungeonId)
        button:SetText(name)
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", spellName)
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

    if not xb.db.profile.curSeasonOnly then -- If not curSeasonOnly, show a 2 levels dropdown menu
        UIDropDownMenu_Initialize(self.mythicPopup, function(self, level, menuList)
            if (level or 1) == 1 then
                -- Title
                local info = UIDropDownMenu_CreateInfo()
                local r, g, b, _ = unpack(xb:HoverColors())
                info.text = '[|cFF' .. string.format('%02x', r * 255) ..
                                string.format('%02x', g * 255) ..
                                string.format('%02x', b * 255) ..
                                L['Mythic+ Teleports'] .. '|r]'
                info.notClickable, info.notCheckable = true, true
                UIDropDownMenu_AddButton(info)

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

                -- Add expansions with teleports as menu items
                for _, expData in ipairs(filteredTeleports) do
                    if expData.teleports and next(expData.teleports) then
                        local info = UIDropDownMenu_CreateInfo()
                        info.text, info.checked = expData.name, false
                        info.menuList, info.hasArrow = expData.teleports, true
                        info.notCheckable = true
                        info.value = expData.teleports
                        UIDropDownMenu_AddButton(info)
                    end
                end
            else
                -- Create a table to hold teleport data with dungeon names
                local sortedTeleports = {}
                for key, value in ipairs(menuList) do
                    -- Resolve the teleport reference if needed
                    local teleportData = TravelModule:ResolveTeleportReference(value)
                    if teleportData and teleportData.teleportId then
                        local spellName = C_Spell.GetSpellName(teleportData.teleportId)
                        local dungeonName = GetLFGDungeonInfo(teleportData.dungeonId)
                        
                        table.insert(sortedTeleports, {
                            teleportData = teleportData,
                            spellName = spellName,
                            dungeonName = dungeonName
                        })
                    end
                end
                
                -- Sort by dungeon name alphabetically
                table.sort(sortedTeleports, function(a, b)
                    return a.dungeonName < b.dungeonName
                end)
                
                -- Add sorted teleports to the menu
                for _, teleport in ipairs(sortedTeleports) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.customFrame = CreateTeleportButton(teleport.teleportData, teleport.spellName)
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end, 'MENU')
    else -- If curSeasonOnly, only show a single-level dropdown menu
        UIDropDownMenu_Initialize(self.mythicPopup, function(self, level, menuList)
            local info = UIDropDownMenu_CreateInfo()
            local r, g, b, _ = unpack(xb:HoverColors())
            info.text = '[|cFF' .. string.format('%02x', r * 255) ..
                            string.format('%02x', g * 255) ..
                            string.format('%02x', b * 255) ..
                            L['Mythic+ Teleports'] .. '|r]'
            info.notClickable, info.notCheckable = true, true
            UIDropDownMenu_AddButton(info)

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
                
            -- Create a table to hold all teleport data with dungeon names
            local allTeleports = {}
            for _, expData in ipairs(filteredTeleports) do
                for _, value in ipairs(expData.teleports) do
                    -- Resolve the teleport reference if needed
                    local teleportData = TravelModule:ResolveTeleportReference(value)
                    if teleportData and teleportData.teleportId then
                        local spellName = C_Spell.GetSpellName(teleportData.teleportId)
                        local dungeonName = GetLFGDungeonInfo(teleportData.dungeonId)
                        
                        table.insert(allTeleports, {
                            teleportData = teleportData,
                            spellName = spellName,
                            dungeonName = dungeonName
                        })
                    end
                end
            end
            
            -- Sort by dungeon name alphabetically
            table.sort(allTeleports, function(a, b)
                return a.dungeonName < b.dungeonName
            end)
            
            -- Add sorted teleports to the menu
            for _, teleport in ipairs(allTeleports) do
                local info = UIDropDownMenu_CreateInfo()
                info.customFrame = CreateTeleportButton(teleport.teleportData, teleport.spellName)
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

    if InCombatLockdown() then
        self.hearthText:SetText(GetBindLocation())
        self.portText:SetText(xb.db.char.portItem.text)
        self:SetHearthColor()
        self:SetPortColor()
        self:SetMythicColor()
        return
    end

    self:UpdatePortOptions()

    local db = xb.db.profile
    -- local iconSize = (xb:GetHeight() / 2)
    local iconSize = db.text.fontSize + db.general.barPadding

    -- Hearthstone Part
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

    -- Portals Part
    self.portText:SetFont(xb:GetFont(db.text.fontSize))
    self.portText:SetText(xb.db.char.portItem.text)

    self.portButton:SetSize(self.portText:GetWidth() + iconSize +
                                db.general.barPadding, xb:GetHeight())
    self.portButton:SetPoint("RIGHT", self.hearthButton, "LEFT",
                             -(db.general.barPadding), 0)

    self.portText:SetPoint("RIGHT")

    self.portIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\garr')
    self.portIcon:SetSize(iconSize, iconSize)

    self.portIcon:SetPoint("RIGHT", self.portText, "LEFT",
                           -(db.general.barPadding), 0)

    self:SetPortColor()

    self:CreatePortPopup()

    -- M+ Part
    if self.mythicButton then self.mythicButton:Hide() end

    if (xb.db.profile.enableMythicPortals) then
        self.mythicText:SetFont(xb:GetFont(db.text.fontSize))
        self.mythicText:SetText(L['M+ Teleports'])

        self.mythicButton:SetSize(self.mythicText:GetWidth() + iconSize +
                                      db.general.barPadding, xb:GetHeight())
        self.mythicButton:SetPoint("RIGHT", self.portButton, "LEFT", -(db.general.barPadding), 0)

        self.mythicText:SetPoint("RIGHT")

        self.mythicIcon:SetTexture(xb.constants.mediaPath .. 'microbar\\lfg')
        self.mythicIcon:SetSize(iconSize + 8, iconSize + 8)

        self.mythicIcon:SetPoint("RIGHT", self.mythicText, "LEFT",
                                 -(db.general.barPadding) + 5, 0)

        self:SetMythicColor()

        self:CreateMythicPopup()

        self.mythicButton:Show()
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

    self.mythicPopup:ClearAllPoints()

    self.mythicPopup.point = "BOTTOM"
    self.mythicPopup.relativePoint = "TOP"

    self:SkinFrame(self.mythicPopup, "SpecToolTip")
    self.mythicPopup:Hide()

    local totalWidth = self.hearthButton:GetWidth() + db.general.barPadding
    self.portButton:Show()
    if self.portButton:IsVisible() then
        totalWidth = totalWidth + self.portButton:GetWidth()
    end

    if (xb.db.profile.enableMythicPortals) then
        if self.mythicButton:IsVisible() then
            totalWidth = totalWidth + self.mythicButton:GetWidth()
        end
    end
    self.hearthFrame:SetSize(totalWidth, xb:GetHeight())
    self.hearthFrame:SetPoint("RIGHT", -(db.general.barPadding), 0)
    self.hearthFrame:Show()
end

function TravelModule:ShowTooltip()
    if not self.portPopup:IsVisible() then
        GameTooltip:SetOwner(self.portButton, 'ANCHOR_' .. xb.miniTextPosition)
        GameTooltip:ClearLines()
        local r, g, b, _ = unpack(xb:HoverColors())
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. L['Travel Cooldowns'] .. "|cFFFFFFFF]|r", r, g, b)
        
        -- Show hearthstone cooldown
        local hearthstoneId = 6948 -- Regular Hearthstone ID
        if C_Item.DoesItemExistByID(hearthstoneId) then
            local startTime, duration = GetItemCooldown(hearthstoneId)
            local remainingCooldown = (startTime + duration - GetTime())
            local cdString = self:FormatCooldown(remainingCooldown)
            GameTooltip:AddDoubleLine(L['Hearthstone'], cdString, r, g, b, 1, 1, 1)
        end

        -- Show teleport cooldowns
        if self.portOptions then
            for i, v in pairs(self.portOptions) do
                if v and v.portId and v.text then
                    if PlayerHasToy(v.portId) or (IsUsableItem(v.portId) and not IsSpellKnown(v.portId)) then
                        -- Handle items and toys
                        local startTime, duration = GetItemCooldown(v.portId)
                        local remainingCooldown = (startTime + duration - GetTime())
                        local cdString = self:FormatCooldown(remainingCooldown)
                        GameTooltip:AddDoubleLine(v.text, cdString, r, g, b, 1, 1, 1)
                    else
                        -- Handle spells (including class-specific teleports)
                        if IsSpellKnown(v.portId) then
                            local start, duration = GetSpellCooldown(v.portId)
                            
                            -- Always show cooldown info
                            local remainingCooldown = 0
                            if start and duration then
                                if duration > 0 then
                                    remainingCooldown = start + duration - GetTime()
                                end
                            end
                            local cdString = self:FormatCooldown(remainingCooldown)
                            GameTooltip:AddDoubleLine(v.text, cdString, r, g, b, 1, 1, 1)
                        end
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
    local firstItem = {portId = 140192, text = GetItemInfo(140192)}
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
    return PlayerHasToy(id) or IsUsableItem(id) or IsPlayerSpell(id)
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
            -- if IsUsableItem(i) then
            --     hearthName, _ = GetItemInfo(i)
            -- elseif PlayerHasToy(i) then
            local _, name, _, _, _, _ = C_ToyBox.GetToyInfo(i)
            hearthName = name
            -- elseif IsPlayerSpell(i) then
            --     hearthName, _ = GetSpellInfo(i)
            -- end
            xb.db.profile.hearthstonesList[i] = hearthName
        end
    end

    -- Dalaran Hearthstone
    if xb.db.profile.dalaran_hs_string == nil then
        local _, hearthName, _, _, _, _ = C_ToyBox.GetToyInfo(140192)
        xb.db.profile.dalaran_hs_string = hearthName
    end
end

function TravelModule:GetDefaultOptions()
    local firstItem = self:FindFirstOption()
    xb.db.char.portItem = xb.db.char.portItem or firstItem
    return 'travel', {
        enabled = true,
        enableMythicPortals = true,
        curSeasonOnly = false,
        randomizeHs = false
    }
end

function TravelModule:GetConfig()
    local hearthstonesTable = {}

    if xb.db.profile.hearthstonesList then
        for i, v in pairs(xb.db.profile.hearthstonesList) do
            table.insert(hearthstonesTable, i, v)
        end
    end

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
            mythicHeader = {
                order = 18,
                name = L['Mythic+ Teleports'],
                type = 'header',
            },
            enableMythicPortals = {
                name = L['Show Mythic+ Teleports'],
                order = 20,
                type = "toggle",
                get = function()
                    return xb.db.profile.enableMythicPortals;
                end,
                set = function(_, val)
                    xb.db.profile.enableMythicPortals = val;
                    self:Refresh();
                end,
                width = "full"
            },
            curSeasonOnly = {
                name = L['Only show current season'],
                order = 25,
                type = "toggle",
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
                values = hearthstonesTable,
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
