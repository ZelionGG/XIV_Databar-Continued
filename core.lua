local AddOnName, XIVBar = ...;
local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceAddon:NewAddon(XIVBar, AddOnName, "AceConsole-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName, true);
local ldb = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(AddOnName, {
    type = "launcher",
    icon = "Interface\\Icons\\Spell_Nature_StormReach",
    OnClick = function(clickedframe, button) XIVBar:ToggleConfig() end
})
local options

XIVBar.Changelog = {}

XIVBar.L = L

_G.XIV_Databar_Continued_OnAddonCompartmentClick = function()
    XIVBar:ToggleConfig()
end

XIVBar.constants = {
    mediaPath = "Interface\\AddOns\\" .. AddOnName .. "\\media\\",
    playerName = UnitName("player"),
    playerClass = select(2, UnitClass("player")),
    playerLevel = UnitLevel("player"),
    playerFactionLocal = select(2, UnitFactionGroup("player")),
    playerRealm = GetRealmName(),
    popupPadding = 10
}

XIVBar.defaults = {
    profile = {
        general = {
            barPosition = "BOTTOM",
            barPadding = 3,
            moduleSpacing = 30,
            barMargin = 0,
            barFullscreen = true,
            barWidth = GetScreenWidth(),
            barHoriz = 'CENTER',
            barCombatHide = false,
            barFlightHide = false,
            useElvUI = true
        },
        color = {
            barColor = {r = 0.094, g = 0.094, b = 0.094, a = 0.75},
            normal = {r = 0.8, g = 0.8, b = 0.8, a = 0.75},
            inactive = {r = 1, g = 1, b = 1, a = 0.25},
            useCC = false,
            useTextCC = false,
            useHoverCC = true,
            hover = {
                r = RAID_CLASS_COLORS[XIVBar.constants.playerClass].r,
                g = RAID_CLASS_COLORS[XIVBar.constants.playerClass].g,
                b = RAID_CLASS_COLORS[XIVBar.constants.playerClass].b,
                a = RAID_CLASS_COLORS[XIVBar.constants.playerClass].a
            }
        },
        text = {fontSize = 12, smallFontSize = 11, font = 'Homizio Bold'},
        modules = {}
    },
    global = {
        characters = {}
    }
};

XIVBar.LSM = LibStub('LibSharedMedia-3.0');

-- Changelog Module
function XIVBar:CreateColorString(text, db)
    local hex = db.r and db.g and db.b and self:RGBToHex(db.r, db.g, db.b) or
                    "|cffffffff"

    local string = hex .. text .. "|r"
    return string
end

function XIVBar:RGBToHex(r, g, b, header, ending)
    r = r <= 1 and r >= 0 and r or 1
    g = g <= 1 and g >= 0 and g or 1
    b = b <= 1 and b >= 0 and b or 1

    local hex = format('%s%02x%02x%02x%s', header or '|cff', r * 255, g * 255,
                       b * 255, ending or '')
    return hex
end

function XIVBar:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("XIVBarDB", self.defaults, "Default")
    self.LSM:Register(self.LSM.MediaType.FONT, 'Homizio Bold',
                      self.constants.mediaPath .. "homizio_bold.ttf")
    self.frames = {}

    self.fontFlags = {'', 'OUTLINE', 'THICKOUTLINE', 'MONOCHROME'}

    options = {
        name = "XIV Bar Continued",
        handler = XIVBar,
        type = 'group',
        args = {
            general = self:GetGeneralOptions()
        }
    }

    local moduleOptions = {
        name = L['Modules'],
        type = "group",
        args = {}
    }

    local changelogOptions = {
        type = "group",
        childGroups = "select",
        name = L["Changelog"],
        args = {}
    }

    local profileSharingOptions = {
        name = L["Profile Sharing"],
        type = "group",
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["Profile Import/Export"],
            },
            desc = {
                order = 2,
                type = "description",
                name = L["Import or export your profiles to share them with other players."],
                fontSize = "medium",
            },
            export = {
                order = 3,
                type = "execute",
                name = L["Export Profile"],
                desc = L["Export your current profile settings"],
                func = function()
                    local exportString = XIVBar:ExportProfile()
                    if exportString then
                        local dialog = StaticPopup_Show("XIVBAR_EXPORT_PROFILE")
                        if dialog then
                            dialog.editBox:SetText(exportString)
                            dialog.editBox:HighlightText()
                        end
                    end
                end,
            },
            import = {
                order = 4,
                type = "execute",
                name = L["Import Profile"],
                desc = L["Import a profile from another player"],
                func = function()
                    StaticPopup_Show("XIVBAR_IMPORT_PROFILE")
                end,
            },
        }
    }

    for name, module in self:IterateModules() do
        if module['GetConfig'] ~= nil then
            moduleOptions.args[name] = module:GetConfig()
        end
        if module['GetDefaultOptions'] ~= nil then
            local oName, oTable = module:GetDefaultOptions()
            self.defaults.profile.modules[oName] = oTable
        end
    end

    local function orange(string)
        if type(string) ~= "string" then string = tostring(string) end
        string = XIVBar:CreateColorString(string, {r = 0.859, g = 0.388, b = 0.203})
        return string
    end

    local function renderChangelogLine(line)
        line = gsub(line, "%[[^%[]+%]", orange)
        return line
    end

    for version, data in pairs(XIVBar.Changelog) do
        local versionString = data.version_string
        local dateTable = {strsplit("/", data.release_date)}
        local dateString = data.release_date
        if #dateTable == 3 then
            dateString = L["%month%-%day%-%year%"]
            dateString = gsub(dateString, "%%year%%", dateTable[1])
            dateString = gsub(dateString, "%%month%%", dateTable[2])
            dateString = gsub(dateString, "%%day%%", dateTable[3])
        end

        changelogOptions.args[tostring(version)] = {
            order = 10000 - version,
            name = versionString,
            type = "group",
            args = {
                version = {
                    order = 2,
                    type = "description",
                    name = L["Version"] .. " " .. orange(versionString) ..
                        " - |cffbbbbbb" .. dateString .. "|r",
                    fontSize = "large"
                }
            }
        }

        local page = changelogOptions.args[tostring(version)].args

        -- Checking localized "Important" category
        local important_localized = {}
        if data.important[GetLocale()] ~= nil and next(data.important[GetLocale()]) ~= nil then
            important_localized = data.important[GetLocale()]
        else 
            important_localized = data.important["enUS"]
        end

        local important = data.important and important_localized
        if important and #important > 0 then
            page.importantHeader = {
                order = 3,
                type = "header",
                name = orange(L["Important"])
            }
            page.important = {
                order = 4,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(important) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end

        -- Checking localized "New" category
        local new_localized = {}
        if data.new[GetLocale()] ~= nil and next(data.new[GetLocale()]) ~= nil then
            new_localized = data.new[GetLocale()]
        else 
            new_localized = data.new["enUS"]
        end

        local new = data.new and new_localized
        if new and #new > 0 then
            page.newHeader = {
                order = 5,
                type = "header",
                name = orange(L["New"])
            }
            page.new = {
                order = 6,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(new) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end

        -- Checking localized "Improvment" category
        local improvment_localized = {}
        if data.improvment[GetLocale()] ~= nil and next(data.improvment[GetLocale()]) ~= nil then
            improvment_localized = data.improvment[GetLocale()]
        else 
            improvment_localized = data.improvment["enUS"]
        end

        local improvment = data.improvment and improvment_localized
        if improvment and #improvment > 0 then
            page.improvmentHeader = {
                order = 7,
                type = "header",
                name = orange(L["Improvment"])
            }
            page.improvment = {
                order = 8,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(improvment) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end
    end

    self.db:RegisterDefaults(self.defaults)

    -- Get profile options
    local profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Register all options tables
    AceConfig:RegisterOptionsTable(AddOnName, options)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Modules", moduleOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Changelog", changelogOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Profiles", profileOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_ProfileSharing", profileSharingOptions)

    -- Add to Blizzard options
    AceConfigDialog:AddToBlizOptions(AddOnName, "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Modules", L['Modules'], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L['Changelog'], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Profiles", 'Profiles', "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_ProfileSharing", 'Profile Sharing', "XIV Bar Continued")

    self.timerRefresh = false

    self:RegisterChatCommand('xivc', 'ToggleConfig')
    self:RegisterChatCommand('xivbar', 'ToggleConfig')
    self:RegisterChatCommand('xbc', 'ToggleConfig')

    -- Export and Import Profile Functions
    function XIVBar:ExportProfile()
        local currentProfile = self.db.profile
        local exportData = {
            profile = currentProfile,
            meta = {
                character = self.constants.playerName,
                realm = self.constants.playerRealm,
                exportTime = time()
            }
        }
        local serialized = LibStub:GetLibrary("AceSerializer-3.0"):Serialize(exportData)
        local encoded = LibStub:GetLibrary("LibDeflate"):EncodeForPrint(LibStub:GetLibrary("LibDeflate"):CompressDeflate(serialized))
        return encoded
    end

    function XIVBar:ImportProfile(encoded)
        if not encoded or encoded == "" then
            print("|cffff0000XIV Databar Continued:|r " .. L["Invalid import string"])
            return false
        end

        local decoded = LibStub:GetLibrary("LibDeflate"):DecodeForPrint(encoded)
        if not decoded then
            print("|cffff0000XIV Databar Continued:|r " .. L["Failed to decode import string"])
            return false
        end

        local decompressed = LibStub:GetLibrary("LibDeflate"):DecompressDeflate(decoded)
        if not decompressed then
            print("|cffff0000XIV Databar Continued:|r " .. L["Failed to decompress import string"])
            return false
        end

        local success, imported = LibStub:GetLibrary("AceSerializer-3.0"):Deserialize(decompressed)
        if not success then
            print("|cffff0000XIV Databar Continued:|r " .. L["Failed to deserialize import string"])
            return false
        end

        -- Validate the imported data
        if type(imported) ~= "table" or type(imported.profile) ~= "table" or type(imported.meta) ~= "table" then
            print("|cffff0000XIV Databar Continued:|r " .. L["Invalid profile format"])
            return false
        end

        -- Create a profile name based on the source character
        local profileName = imported.meta.character
        if imported.meta.realm and imported.meta.realm ~= self.constants.playerRealm then
            profileName = profileName .. " - " .. imported.meta.realm
        end

        -- Add a number if profile already exists
        local baseProfileName = profileName
        local count = 1
        while self.db.profiles[profileName] do
            profileName = baseProfileName .. " " .. count
            count = count + 1
        end

        -- Create new profile and import settings
        self.db:SetProfile(profileName)
        for k, v in pairs(imported.profile) do
            if k ~= "profileKeys" then -- Skip profileKeys to avoid conflicts
                self.db.profile[k] = v
            end
        end

        self:Refresh()
        print("|cff00ff00XIV Databar Continued:|r " .. L["Profile imported successfully as"] .. " '" .. profileName .. "'")
        return true
    end

    -- Add export/import options to the general options
    function XIVBar:GetGeneralOptions()
        return {
            name = GENERAL_LABEL,
            type = "group",
            inline = true,
            args = {
                positioning = self:GetPositioningOptions(),
                text = self:GetTextOptions(),
                textColors = self:GetTextColorOptions()
            }
        }
    end
end

StaticPopupDialogs["XIVBAR_EXPORT_PROFILE"] = {
    text = L["Copy the export string below:"],
    button1 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 350,
    maxLetters = 0,
    OnShow = function(self)
        self.editBox:SetAutoFocus(true)
        self.editBox:SetJustifyH("LEFT")
        self.editBox:SetWidth(350)
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

StaticPopupDialogs["XIVBAR_IMPORT_PROFILE"] = {
    text = L["Paste the import string below:"],
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = true,
    editBoxWidth = 350,
    maxLetters = 0,
    OnShow = function(self)
        self.editBox:SetAutoFocus(true)
        self.editBox:SetJustifyH("LEFT")
        self.editBox:SetWidth(350)
    end,
    OnAccept = function(self)
        local importString = self.editBox:GetText()
        XIVBar:ImportProfile(importString)
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function XIVBar:GetPositioningOptions()
    return {
        name = L["Positioning"],
        type = "group",
        order = 1,
        inline = true,
        args = {
            barLocation = {
                name = L['Bar Position'],
                type = "select",
                order = 2,
                width = "full",
                values = {TOP = L['Top'], BOTTOM = L['Bottom']},
                style = "dropdown",
                get = function()
                    return self.db.profile.general.barPosition;
                end,
                set = function(info, value)
                    self.db.profile.general.barPosition = value;
                    self:Refresh();
                end
            },
            flightHide = {
                name = "Hide when in flight",
                type = "toggle",
                order = 1,
                get = function()
                    return self.db.profile.general.barFlightHide
                end,
                set = function(_, val)
                    self.db.profile.general.barFlightHide = val;
                    self:Refresh();
                end
            },
            fullScreen = {
                name = VIDEO_OPTIONS_FULLSCREEN,
                type = "toggle",
                order = 4,
                get = function()
                    return self.db.profile.general.barFullscreen;
                end,
                set = function(info, value)
                    self.db.profile.general.barFullscreen = value;
                    self:Refresh();
                end
            },
            barPosition = {
                name = L['Horizontal Position'],
                type = "select",
                hidden = function()
                    return self.db.profile.general.barFullscreen;
                end,
                order = 5,
                values = {
                    LEFT = L['Left'],
                    CENTER = L['Center'],
                    RIGHT = L['Right']
                },
                style = "dropdown",
                get = function()
                    return self.db.profile.general.barHoriz;
                end,
                set = function(info, value)
                    self.db.profile.general.barHoriz = value;
                    self:Refresh();
                end,
                disabled = function()
                    return self.db.profile.general.barFullscreen;
                end
            },
            barWidth = {
                name = L['Bar Width'],
                type = 'range',
                order = 6,
                hidden = function()
                    return self.db.profile.general.barFullscreen;
                end,
                min = 200,
                max = GetScreenWidth(),
                step = 1,
                get = function()
                    return self.db.profile.general.barWidth;
                end,
                set = function(info, val)
                    self.db.profile.general.barWidth = val;
                    self:Refresh();
                end,
                disabled = function()
                    return self.db.profile.general.barFullscreen;
                end
            },
            barPadding = {
                name = L['Bar Padding'],
                type = 'range',
                order = 10,
                min = 0,
                max = 10,
                step = 1,
                get = function()
                    return self.db.profile.general.barPadding;
                end,
                set = function(info, val)
                    self.db.profile.general.barPadding = val;
                    self:Refresh();
                end
            },
            moduleSpacing = {
                name = L['Module Spacing'],
                type = 'range',
                order = 11,
                min = 10,
                max = 80,
                step = 1,
                get = function()
                    return self.db.profile.general.moduleSpacing;
                end,
                set = function(info, val)
                    self.db.profile.general.moduleSpacing = val;
                    self:Refresh();
                end
            },
            barMargin = {
                name = L['Bar Margin'],
                desc = L["Leftmost and rightmost margin of the bar modules"],
                type = 'range',
                order = 12,
                min = 0,
                max = 80,
                step = 1,
                get = function()
                    return self.db.profile.general.barMargin;
                end,
                set = function(info, val)
                    self.db.profile.general.barMargin = val;
                    self:Refresh();
                end
            }
        }
    }
end

function XIVBar:OnEnable()
    self:CreateMainBar()
    self:Refresh()

    self.db.RegisterCallback(self, 'OnProfileCopied', 'Refresh')
    self.db.RegisterCallback(self, 'OnProfileChanged', 'Refresh')
    self.db.RegisterCallback(self, 'OnProfileReset', 'Refresh')

    if not self.timerRefresh then
        C_Timer.After(5, function()
            self:Refresh()
            self.timerRefresh = true
        end)
    end
end

function XIVBar:ToggleConfig()
    Settings.OpenToCategory("XIV Bar Continued")
end

function XIVBar:SetColor(name, r, g, b, a)
    self.db.profile.color[name].r = r
    self.db.profile.color[name].g = g
    self.db.profile.color[name].b = b
    self.db.profile.color[name].a = a

    self:Refresh()
end

function XIVBar:GetColor(name)
    local profile = self.db.profile.color
    local a = profile[name].a
    -- what a stupid hacky solution, the whole config part is kind of fucked and i dread having to come fix this eventually.
    -- feel like just burning it all down and writing something from scratch when seeing shit like this. terrible library.
    if name == 'normal' then
        -- use class color for normal color
        if profile.useTextCC then
            local cr, cg, cb, _ = self:GetClassColors()
            r, g, b = cr, cg, cb
        end
    end
    -- use self-picked color for normal color
    return profile[name].r, profile[name].g, profile[name].b, a
end

function XIVBar:HoverColors()
    local colors
    local profile = self.db.profile.color
    -- use self-picked color for hover color
    if not profile.useHoverCC then
        colors = {
            profile.hover.r, profile.hover.g, profile.hover.b, profile.hover.a
        }
        -- use class color for hover color
    else
        local r, g, b = self:GetClassColors()
        colors = {r, g, b, profile.hover.a}
    end
    return colors
end

function XIVBar:RegisterFrame(name, frame)
    frame:SetScript('OnHide',
                    function() self:SendMessage('XIVBar_FrameHide', name) end)
    frame:SetScript('OnShow',
                    function() self:SendMessage('XIVBar_FrameShow', name) end)
    self.frames[name] = frame
end

--- Get the frame with the specified name
---@param name string name of the frame as supplied to RegisterFrame
---@return Frame
function XIVBar:GetFrame(name) return self.frames[name] end

function XIVBar:CreateMainBar()
    if self.frames.bar == nil then
        self:RegisterFrame('bar', CreateFrame("FRAME", "XIV_Databar", UIParent))
        self.frames.bgTexture = self.frames.bgTexture or
                                    self.frames.bar:CreateTexture(nil,
                                                                  "BACKGROUND")
    end
end

function XIVBar:HideBarEvent()
    local bar = self:GetFrame("bar")
    local vehiculeIsFlight = false;

    bar:UnregisterAllEvents()
    bar.OnEvent = nil
    bar:RegisterEvent("PET_BATTLE_OPENING_START")
    bar:RegisterEvent("PET_BATTLE_CLOSE")
    bar:RegisterEvent("TAXIMAP_CLOSED")
    bar:RegisterEvent("VEHICLE_POWER_SHOW")

    bar:SetScript("OnEvent", function(_, event, ...)
        local barFrame = XIVBar:GetFrame("bar")
        if self.db.profile.general.barFlightHide then
            if event == "VEHICLE_POWER_SHOW" then
                if not barFrame:IsVisible() then barFrame:Show() end
                if vehiculeIsFlight and barFrame:IsVisible() then
                    barFrame:Hide()
                end
            end

            if event == "TAXIMAP_CLOSED" then
                vehiculeIsFlight = true
                C_Timer.After(1, function()
                    vehiculeIsFlight = false
                end)
            end
        end

        if event == "PET_BATTLE_OPENING_START" and barFrame:IsVisible() then
            barFrame:Hide()
        end
        if event == "PET_BATTLE_CLOSE" and not barFrame:IsVisible() then
            barFrame:Show()
        end
    end)

    if self.db.profile.general.barCombatHide then
        bar:RegisterEvent("PLAYER_REGEN_ENABLED")
        bar:RegisterEvent("PLAYER_REGEN_DISABLED")

        bar:HookScript("OnEvent", function(_, event, ...)
            local barFrame = XIVBar:GetFrame("bar")
            if event == "PLAYER_REGEN_DISABLED" and barFrame:IsVisible() then
                barFrame:Hide()
            end
            if event == "PLAYER_REGEN_ENABLED" and not barFrame:IsVisible() then
                barFrame:Show()
            end
        end)
    else
        if bar:IsEventRegistered("PLAYER_REGEN_ENABLED") then
            bar:UnregisterEvent("PLAYER_REGEN_ENABLED")
        elseif bar:IsEventRegistered("PLAYER_REGEN_DISABLED") then
            bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
        end
    end
end

function XIVBar:GetHeight()
    return (self.db.profile.text.fontSize * 2) +
               self.db.profile.general.barPadding
end

function XIVBar:Refresh()
    if self.frames.bar == nil then return; end

    self:HideBarEvent()
    self.miniTextPosition = "TOP"
    if self.db.profile.general.barPosition == 'TOP' then
        hooksecurefunc("UIParent_UpdateTopFramePositions", function(self)
            if (XIVBar.db.profile.general.barPosition == 'TOP') then
                OffsetUI()
            end
        end)
        OffsetUI()
        self.miniTextPosition = 'BOTTOM'
    else
        self:ResetUI();
    end

    local barColor = self.db.profile.color.barColor
    self.frames.bar:ClearAllPoints()
    self.frames.bar:SetPoint(self.db.profile.general.barPosition)
    if self.db.profile.general.barFullscreen then
        self.frames.bar:SetPoint("LEFT", self.db.profile.general.barMargin, 0)
        self.frames.bar:SetPoint("RIGHT", -self.db.profile.general.barMargin, 0)
    else
        local relativePoint = self.db.profile.general.barHoriz
        if relativePoint == 'CENTER' then relativePoint = 'BOTTOM' end
        self.frames.bar:SetPoint(self.db.profile.general.barHoriz,
                                 self.frames.bar:GetParent(), relativePoint)
        self.frames.bar:SetWidth(self.db.profile.general.barWidth)
    end
    self.frames.bar:SetHeight(self:GetHeight())

    self.frames.bgTexture:SetColorTexture(self:GetColor('barColor'))
    self.frames.bgTexture:SetAllPoints()

    for name, module in self:IterateModules() do
        if module['Refresh'] == nil then return; end
        module:Refresh()
    end
end

function XIVBar:GetFont(size)
    return self.LSM:Fetch(self.LSM.MediaType.FONT, self.db.profile.text.font),
           size, self.fontFlags[self.db.profile.text.flags]
end

function XIVBar:GetClassColors()
    return RAID_CLASS_COLORS[self.constants.playerClass].r,
           RAID_CLASS_COLORS[self.constants.playerClass].g,
           RAID_CLASS_COLORS[self.constants.playerClass].b,
           self.db.profile.color.barColor.a
end

function XIVBar:RGBAToHex(r, g, b, a)
    a = a or 1
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    a = a <= 1 and a >= 0 and a or 1
    return string.format("%02x%02x%02x%02x", r * 255, g * 255, b * 255, a * 255)
end

function XIVBar:HexToRGBA(hex)
    local rhex, ghex, bhex, ahex = string.sub(hex, 1, 2), string.sub(hex, 3, 4),
                                   string.sub(hex, 5, 6), string.sub(hex, 7, 8)
    if not (rhex and ghex and bhex and ahex) then return 0, 0, 0, 0 end
    return (tonumber(rhex, 16) / 255), (tonumber(ghex, 16) / 255),
           (tonumber(bhex, 16) / 255), (tonumber(ahex, 16) / 255)
end

function XIVBar:PrintTable(table, prefix)
    for k, v in pairs(table) do
        if type(v) == 'table' then
            self:PrintTable(v, prefix .. '.' .. k)
        else
            print(prefix .. '.' .. k .. ': ' .. tostring(v))
        end
    end
end

function OffsetUI()
    local offset = XIVBar.frames.bar:GetHeight();
    local buffsAreaTopOffset = offset;

    if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
        if (PlayerFrame and not PlayerFrame:IsUserPlaced() and
            not PlayerFrame_IsAnimatedOut(PlayerFrame)) then
            PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -19,
                                 -4 - offset)
        end

        if (TargetFrame and not TargetFrame:IsUserPlaced()) then
            TargetFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250,
                                 -4 - offset);
        end

        local ticketStatusFrameShown = TicketStatusFrame and
                                           TicketStatusFrame:IsShown();
        local gmChatStatusFrameShown = GMChatStatusFrame and
                                           GMChatStatusFrame:IsShown();
        if (ticketStatusFrameShown) then
            TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -180,
                                       0 - offset);
            buffsAreaTopOffset = buffsAreaTopOffset +
                                     TicketStatusFrame:GetHeight();
        end
        if (gmChatStatusFrameShown) then
            GMChatStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -170,
                                       -5 - offset);
            buffsAreaTopOffset = buffsAreaTopOffset +
                                     GMChatStatusFrame:GetHeight() + 5;
        end
        if (not ticketStatusFrameShown and not gmChatStatusFrameShown) then
            buffsAreaTopOffset = buffsAreaTopOffset + 13;
        end

        BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -205,
                           0 - buffsAreaTopOffset);
    end
end

function XIVBar:ResetUI()
    if topOffsetBlizz then UIParent_UpdateTopFramePositions = topOffsetBlizz end
    UIParent_UpdateTopFramePositions();
end

function XIVBar:GetGeneralOptions()
    return {
        name = GENERAL_LABEL,
        type = "group",
        inline = true,
        args = {
            positioning = self:GetPositioningOptions(),
            text = self:GetTextOptions(),
            textColors = self:GetTextColorOptions()
        }
    }
end

function XIVBar:GetTextOptions()
    return {
        name = LOCALE_TEXT_LABEL,
        type = "group",
        order = 2,
        inline = true,
        args = {
            font = {
                name = L['Font'],
                type = "select",
                dialogControl = 'LSM30_Font',
                order = 1,
                values = AceGUIWidgetLSMlists.font,
                style = "dropdown",
                get = function()
                    return self.db.profile.text.font;
                end,
                set = function(info, val)
                    self.db.profile.text.font = val;
                    self:Refresh();
                end
            },
            fontSize = {
                name = FONT_SIZE,
                type = 'range',
                order = 2,
                min = 10,
                max = 40,
                step = 1,
                get = function()
                    return self.db.profile.text.fontSize;
                end,
                set = function(info, val)
                    self.db.profile.text.fontSize = val;
                    self:Refresh();
                end
            },
            smallFontSize = {
                name = L['Small Font Size'],
                type = 'range',
                order = 2,
                min = 10,
                max = 20,
                step = 1,
                get = function()
                    return self.db.profile.text.smallFontSize;
                end,
                set = function(info, val)
                    self.db.profile.text.smallFontSize = val;
                    self:Refresh();
                end
            },
            textFlags = {
                name = L['Text Style'],
                type = 'select',
                style = 'dropdown',
                order = 3,
                values = self.fontFlags,
                get = function()
                    return self.db.profile.text.flags;
                end,
                set = function(info, val)
                    self.db.profile.text.flags = val;
                    self:Refresh();
                end
            }
        }
    }
end

function XIVBar:GetTextColorOptions()
    return {
        name = L['Text Colors'],
        type = "group",
        order = 3,
        inline = true,
        args = {
            normal = {
                name = L['Normal'],
                type = "color",
                order = 1,
                width = "double",
                hasAlpha = true,
                set = function(info, r, g, b, a)
                    if self.db.profile.color.useTextCC then
                        local cr, cg, cb, _ = self:GetClassColors()
                        r, g, b = cr, cg, cb
                    end
                    XIVBar:SetColor('normal', r, g, b, a)
                end,
                get = function() return XIVBar:GetColor('normal') end
            },
            textCC = {
                name = L["Use Class Color for Text"],
                desc = L["Only the alpha can be set with the color picker"],
                type = "toggle",
                order = 2,
                set = function(_, val)
                    if val then
                        XIVBar:SetColor("normal", self:GetClassColors())
                    end
                    self.db.profile.color.useTextCC = val
                end,
                get = function()
                    return self.db.profile.color.useTextCC
                end
            },
            hover = {
                name = L['Hover'],
                type = "color",
                order = 3,
                width = "double",
                hasAlpha = true,
                set = function(info, r, g, b, a)
                    if self.db.profile.color.useHoverCC then
                        local cr, cg, cb, _ = self:GetClassColors()
                        r, g, b = cr, cg, cb
                    end
                    XIVBar:SetColor('hover', r, g, b, a)
                end,
                get = function() return XIVBar:GetColor('hover') end
            },
            hoverCC = {
                name = L['Use Class Colors for Hover'],
                type = "toggle",
                order = 4,
                set = function(_, val)
                    if val then
                        XIVBar:SetColor("hover", self:GetClassColors())
                    end
                    self.db.profile.color.useHoverCC = val;
                    self:Refresh();
                end,
                get = function()
                    return self.db.profile.color.useHoverCC
                end
            },
            inactive = {
                name = L['Inactive'],
                type = "color",
                order = 5,
                hasAlpha = true,
                width = "double",
                set = function(info, r, g, b, a)
                    XIVBar:SetColor('inactive', r, g, b, a)
                end,
                get = function()
                    return XIVBar:GetColor('inactive')
                end
            }
        }
    }
end
