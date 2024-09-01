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
        184353, -- Kyrian Hearthstone
        182773, -- Necrolord Hearthstone
        180290, -- Night Fae Hearthstone
        183716, -- Venthyr Sinstone
        142543, -- Scroll of Town Portal
        37118, -- Scroll of Recall 1
        44314, -- Scroll of Recall 2
        44315, -- Scroll of Recall 3
        556, -- Astral Recall
        168907, -- Holographic Digitalization Hearthstone
        142298 -- Astonishingly Scarlet Slippers
    }

    self.portButtons = {}
    self.extraPadding = (xb.constants.popupPadding * 3)
    self.optionTextExtra = 4
    self.availableHearthstones = {}
    self.selectedHearthstones = {}
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

    self.hearthButton:SetScript('OnEnter',
                                function() TravelModule:SetHearthColor() end)

    self.hearthButton:SetScript('OnLeave',
                                function() TravelModule:SetHearthColor() end)

    self.portButton:SetScript('OnEnter', function()
        TravelModule:SetPortColor()
        if InCombatLockdown() then return end
        self:ShowTooltip()
    end)

    self.portButton:SetScript('OnLeave', function()
        TravelModule:SetPortColor()
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
end

function TravelModule:UpdatePortOptions()
    if not self.portOptions then self.portOptions = {} end
    if IsUsableItem(128353) and not self.portOptions[128353] then
        self.portOptions[128353] = {portId = 128353, text = GetItemInfo(128353)} -- admiral's compass
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
            if GetItemCooldown(v) == 0 then
                hearthName, _ = GetItemInfo(v)
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
            end
        end -- if toy/item
        if PlayerHasToy(v) then
            if GetItemCooldown(v) == 0 then
                _, hearthName, _, _, _, _ = C_ToyBox.GetToyInfo(v)
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
            end
        end -- if toy/item
        if IsPlayerSpell(v) then
            if GetSpellCooldown(v) == 0 then
                spellInfo = GetSpellInfo(v)
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

        if IsUsableItem(v) then
            if GetItemCooldown(v) == 0 then
                hearthName, _ = GetItemInfo(v)
                if hearthName ~= nil then
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            end
        end -- if item
        if PlayerHasToy(v) then
            if GetItemCooldown(v) == 0 then
                _, hearthName, _, _, _, _ = C_ToyBox.GetToyInfo(v)
                if hearthName ~= nil then
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            end
        end -- if toy
        if IsPlayerSpell(v) then
            if GetSpellCooldown(v).duration == 0 then
                spellInfo = GetSpellInfo(v)
                hearthName = spellInfo.name
                if hearthName ~= nil then
                    hearthActive = true
                    self.portButton:SetAttribute("macrotext",
                                                 "/cast " .. hearthName)
                end
            end
        end -- if is spell

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
    local mythicTeleports = {
        [1] = {name = L["Classic"]},
        [2] = {name = L["Burning Crusade"]},
        [3] = {name = L["Wrath of the Lich King"]},
        [4] = {
            name = L["Cataclysm"],
            teleports = {
                [1] = {
                    teleportId = 445424, -- Grim Batol Teleport
                    dungeonId = 304 -- Grim Batol
                },
                [2] = {
                    teleportId = 410080, -- The Vortex Pinnacle Teleport
                    dungeonId = 311 -- The Vortex Pinnacle
                },
                [3] = {
                    teleportId = 424142, -- Throne of the Tides Teleport
                    dungeonId = 302 -- Throne of the Tides
                }
            }
        },
        [5] = {
            name = L["Mists of Pandaria"],
            teleports = {
                [1] = {
                    teleportId = 131204, -- Temple of the Jade Serpent Teleport
                    dungeonId = 464 -- Temple of the Jade Serpent
                }
            }
        },
        [6] = {
            name = L["Warlords of Draenor"],
            teleports = {
                [1] = {
                    teleportId = 159897, -- Auchindoun Teleport
                    dungeonId = 820 -- Auchindoun
                },
                [2] = {
                    teleportId = 159895, -- Bloodmaul Slag Mines Teleport
                    dungeonId = 787 -- Bloodmaul Slag Mines
                },
                [3] = {
                    teleportId = 159900, -- Grimrail Depot Teleport
                    dungeonId = 822 -- Grimrail Depot
                },
                [4] = {
                    teleportId = 159896, -- Iron Docks Teleport
                    dungeonId = 821 -- Iron Docks
                },
                [5] = {
                    teleportId = 159898, -- Skyreach Teleport
                    dungeonId = 779 -- Skyreach
                },
                [6] = {
                    teleportId = 159899, -- Shadowmoon Burial Grounds Teleport
                    dungeonId = 783 -- Shadowmoon Burial Grounds
                },
                [7] = {
                    teleportId = 159901, -- The Everbloom Teleport
                    dungeonId = 824 -- The Everbloom
                },
                [8] = {
                    teleportId = 159902, -- Upper Blackrock Spire Teleport
                    dungeonId = 828 -- Upper Blackrock Spire
                }
            }
        },
        [7] = {
            name = L["Legion"],
            teleports = {
                [1] = {
                    teleportId = 424153, -- -- Black Rook Hold Teleport
                    dungeonId = 1204 -- -- Black Rook Hold
                },
                [2] = {
                    teleportId = 393766, -- Court of Stars Teleport
                    dungeonId = 1318 -- Court of Stars
                },
                [3] = {
                    teleportId = 424163, -- Darkheart Thicket Teleport
                    dungeonId = 1201 -- Darkheart Thicket
                },
                [4] = {
                    teleportId = 393764, -- Halls of Valor Teleport
                    dungeonId = 1473 -- Halls of Valor
                },
                [5] = {
                    teleportId = 410078, -- Neltharion's Lair Teleport
                    dungeonId = 1206 -- Neltharion's Lair
                }
            }
        },
        [8] = {
            name = L["Battle for Azeroth"],
            teleports = {
                [1] = {
                    teleportId = 424187, -- Atal'Dazar Teleport
                    dungeonId = 1668 -- Atal'Dazar
                },
                [2] = {
                    teleportId = 410071, -- Freehold Teleport
                    dungeonId = 1672 -- Freehold
                },
                [3] = {
                    teleportId = 445418, -- Siege of Boralus Teleport
                    dungeonId = 1700 -- Siege of Boralus
                },
                [4] = {
                    teleportId = 410074, -- The Underrot Teleport
                    dungeonId = 1711 -- The Underrot
                },
                [5] = {
                    teleportId = 424167, -- Waycrest Manor Teleport
                    dungeonId = 1705 -- Waycrest Manor
                }
            }
        },
        [9] = {
            name = L["Shadowlands"],
            teleports = {
                [1] = {
                    teleportId = 354468, -- De Other Side Teleport
                    dungeonId = 2080 -- De Other Side
                },
                [2] = {
                    teleportId = 354464, -- Mists of Tirna Scithe Teleport
                    dungeonId = 2072 -- Mists of Tirna Scithe
                },
                [3] = {
                    teleportId = 354463, -- Plaguefall Teleport
                    dungeonId = 2069 -- Plaguefall
                },
                [4] = {
                    teleportId = 354469, -- Sanguine Depths Teleport
                    dungeonId = 2082 -- Sanguine Depths
                },
                [5] = {
                    teleportId = 354466, -- Spires of Ascension Teleport
                    dungeonId = 2076 -- Spires of Ascension
                },
                [6] = {
                    teleportId = 367416, -- Tazavesh, the Veiled Market Teleport
                    dungeonId = 2225 -- Tazavesh, the Veiled Market
                },
                [7] = {
                    teleportId = 354467, -- Theater of Pain Teleport
                    dungeonId = 2078 -- Theater of Pain
                },
                [8] = {
                    teleportId = 354462, -- The Necrotic Wake Teleport
                    dungeonId = 2070 -- The Necrotic Wake
                }
            }
        },
        [10] = {
            name = L["Dragonflight"],
            teleports = {
                [1] = {
                    teleportId = 393273, -- Algeth'ar Academy Teleport
                    dungeonId = 2366 -- Algeth'ar Academy
                },
                [2] = {
                    teleportId = 393267, -- Brackenhide Hollow Teleport
                    dungeonId = 2362 -- Brackenhide Hollow
                },
                [3] = {
                    teleportId = 424197, -- Dawn of the Infinite Teleport
                    dungeonId = 2430 -- Dawn of the Infinite
                },
                [4] = {
                    teleportId = 393283, -- Halls of Infusion Teleport
                    dungeonId = 2364 -- Halls of Infusion
                },
                [5] = {
                    teleportId = 393276, -- Neltharus Teleport
                    dungeonId = 2356 -- Neltharus
                },
                [6] = {
                    teleportId = 393256, -- Ruby Life Pools Teleport
                    dungeonId = 2361 -- Ruby Life Pools
                },
                [7] = {
                    teleportId = 393279, -- The Azure Vault Teleport
                    dungeonId = 2332 -- The Azure Vault
                },
                [8] = {
                    teleportId = 393262, -- The Nokhud Offensive Teleport
                    dungeonId = 2368 -- The Nokhud Offensive
                },
                [9] = {
                    teleportId = 393222, -- Uldaman: Legacy of Tyr Teleport
                    dungeonId = 2352 -- Uldaman: Legacy of Tyr
                }
            }
        },
        [11] = {name = L["The War Within"]},
        [12] = {
            name = L["Current season"],
            teleports = {
                [1] = {
                    teleportId = 445417, -- Ara-Kara, City of Echoes Teleport
                    dungeonId = 2604 -- Ara-Kara, City of Echoes
                },
                [2] = {
                    teleportId = 445416, -- City of Threads Teleport
                    dungeonId = 2642 -- City of Threads
                },
                [3] = {
                    teleportId = 445424, -- Grim Batol Teleport
                    dungeonId = 304 -- Grim Batol
                },
                [4] = {
                    teleportId = 354464, -- Mists of Tirna Scithe Teleport
                    dungeonId = 2072 -- Mists of Tirna Scithe
                },
                [5] = {
                    teleportId = 445418, -- Siege of Boralus Teleport
                    dungeonId = 1700 -- Siege of Boralus
                },
                [6] = {
                    teleportId = 445414, -- The Dawnbreaker Teleport
                    dungeonId = 2523 -- The Dawnbreaker
                },
                [7] = {
                    teleportId = 354462, -- The Necrotic Wake Teleport
                    dungeonId = 2070 -- The Necrotic Wake
                },
                [8] = {
                    teleportId = 445269, -- The Stonevault Teleport
                    dungeonId = 2693 -- The Stonevault
                }
            }
        }
    }

    -- Loop on each mythicTeleports item and check foreach if spell known, if known, add to new table
    local filteredTeleports = {}
    for mythicKey, mythicData in ipairs(mythicTeleports) do
        if mythicData.teleports then
            local newTeleports = {}
            local i = 1
            for index, spell in ipairs(mythicData.teleports) do
                if IsSpellKnown(spell.teleportId) then
                    newTeleports[i] = {
                        teleportId = spell.teleportId,
                        dungeonId = spell.dungeonId
                    }
                    i = i + 1
                end
            end
            if next(newTeleports) then
                mythicData.teleports = newTeleports
                table.insert(filteredTeleports, mythicData)
            end
        else
            table.insert(filteredTeleports, mythicData)
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

    UIDropDownMenu_Initialize(self.mythicPopup, function(self, level, menuList)
        if (level or 1) == 1 then
            -- Title
            local info = UIDropDownMenu_CreateInfo()
            local r, g, b, _ = unpack(xb:HoverColors())
            info.text = '[|cFF' .. string.format('%02x', r * 255) ..
                            string.format('%02x', g * 255) ..
                            string.format('%02x', b * 255) ..
                            L["Mythic+ Portals"] .. '|r]'
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

            -- Loop on each mythicTeleports item and check foreach if spell known, if not, don't show anything
            for mythicKey, mythicData in ipairs(filteredTeleports) do
                if mythicData.teleports then
                    if mythicData.name == L["Current season"] then
                        UIDropDownMenu_AddButton(separator, level)
                    end

                    local info = UIDropDownMenu_CreateInfo()
                    info.text, info.checked = mythicData.name, false
                    info.menuList, info.hasArrow = mythicData.teleports, true
                    info.notCheckable = true
                    info.value = mythicData.teleports
                    UIDropDownMenu_AddButton(info)
                end
            end
        else
            for key, value in ipairs(menuList) do
                local spellName = C_Spell.GetSpellName(value.teleportId)

                local info = UIDropDownMenu_CreateInfo()

                info.customFrame = CreateTeleportButton(value, spellName)
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end, 'MENU')

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
        self.mythicText:SetText('M+ Portals')

        self.mythicButton:SetSize(self.mythicText:GetWidth() + iconSize +
                                      db.general.barPadding, xb:GetHeight())
        self.mythicButton:SetPoint("LEFT", -(db.general.barPadding), 0)

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
        self.mythicButton:Show()
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
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. L['Travel Cooldowns'] ..
                                "|cFFFFFFFF]|r", r, g, b)
        for i, v in pairs(self.portOptions) do
            if IsUsableItem(v.portId) or IsPlayerSpell(v.portId) then
                if IsUsableItem(v.portId) then
                    local startTime, cd, _ = GetItemCooldown(v.portId)
                    local remainingCooldown = (startTime + cd - GetTime())
                    local cdString = self:FormatCooldown(remainingCooldown)
                    GameTooltip:AddDoubleLine(v.text, cdString, r, g, b, 1, 1, 1)
                end
                if IsPlayerSpell(v.portId) then
                    local cd = GetSpellCooldown(v.portId)
                    local remainingCooldown =
                        (cd.startTime + cd.duration - GetTime())
                    local cdString = self:FormatCooldown(remainingCooldown)
                    GameTooltip:AddDoubleLine(v.text, cdString, r, g, b, 1, 1, 1)
                end
            end
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine('<' .. L['Right-Click'] .. '>',
                                  L['Change Port Option'], r, g, b, 1, 1, 1)
        GameTooltip:Show()
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
            _, hearthName, _, _, _, _ = C_ToyBox.GetToyInfo(i)
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
    return 'travel', {enabled = true}
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
                order = 0,
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
            enableMythicPortals = {
                name = L['Show Mythic+ Portals'],
                order = 1,
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
            randomizeHs = {
                name = L['Use Random Hearthstone'],
                order = 2,
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
                order = 3,
                type = "description"
            },
            selectedHearthstones = {
                order = 4,
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
