local AddOnName = ...;
---@class XIVBar
local XIVBar = select(2, ...);

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = XIVBar.L
local floor = math.floor

XIVBar.defaults = {
    profile = {
        general = {
            barPosition = "BOTTOM",
            barPadding = 3,
            moduleSpacing = 30,
            barMargin = 0,
            barFullscreen = true,
            barCombatHide = false,
            barFlightHide = false,
            useElvUI = true,
            barWidth = floor(GetScreenWidth()),
            locked = true,
            point = "CENTER",
            relativePoint = "CENTER",
            xOffset = 0,
            yOffset = 0,
            showOnMouseover = false,
            enableFreePlacement = false,
            freePlacementInitialized = false,
            modulePlacements = {},
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

XIVBar.freePlacementFrameMap = {
    armor = "armorFrame",
    clock = "clockFrame",
    currency = "currencyFrame",
    gold = "goldFrame",
    MasterVolume = "volumeFrame",
    microMenu = "microMenuFrame",
    reputation = "reputationFrame",
    system = "systemFrame",
    talent = "talentFrame",
    tradeskill = "tradeskillFrame",
    travel = "travelFrame",
    vault = "vaultFrame",
}

XIVBar.freePlacementDefaultAnchor = {
    armor = "LEFT",
    clock = "CENTER",
    currency = "LEFT",
    gold = "RIGHT",
    MasterVolume = "LEFT",
    microMenu = "LEFT",
    reputation = "LEFT",
    system = "RIGHT",
    talent = "RIGHT",
    tradeskill = "LEFT",
    travel = "RIGHT",
    vault = "RIGHT",
}

local function RoundNearest(value)
    if type(value) ~= "number" then
        return 0
    end

    if value >= 0 then
        return floor(value + 0.5)
    end

    return floor(value - 0.5)
end

local function NormalizeAnchor(anchor)
    if anchor == "LEFT" or anchor == "CENTER" or anchor == "RIGHT" then
        return anchor
    end

    return "CENTER"
end

function XIVBar:SetupOptions()
    local options = {
        name = "XIV Bar Continued",
        handler = XIVBar,
        type = 'group',
        args = {
            general = self:GetGeneralOptions()
        }
    }

    local moduleOptions = {
        name = L["MODULES"],
        type = "group",
        args = {}
    }

    local changelogOptions = {
        type = "group",
        childGroups = "select",
        name = L["CHANGELOG"],
        args = {}
    }

    local profileSharingOptions = {
        name = L["PROFILE_SHARING"],
        type = "group",
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["PROFILE_IMPORT_EXPORT"],
            },
            desc = {
                order = 2,
                type = "description",
                name = L["IMPORT_EXPORT_PROFILES_DESC"],
                fontSize = "medium",
            },
            export = {
                order = 3,
                type = "execute",
                name = L["EXPORT_PROFILE"],
                desc = L["EXPORT_PROFILE_DESC"],
                func = function()
                    local exportString = XIVBar:ExportProfile()
                    if exportString then
                        local dialog = StaticPopup_Show("XIVBAR_EXPORT_PROFILE")
                        if dialog then
                            local eb = dialog.editBox or dialog.EditBox
                            if eb then
                                eb:SetText(exportString)
                                eb:HighlightText()
                            end
                        end
                    end
                end,
            },
            import = {
                order = 4,
                type = "execute",
                name = L["IMPORT_PROFILE"],
                desc = L["IMPORT_PROFILE_DESC"],
                func = function()
                    StaticPopup_Show("XIVBAR_IMPORT_PROFILE")
                end,
            },
        }
    }

    self.freePlacementModuleOrder = {}
    self.freePlacementModuleMeta = {}

    for name, module in self:IterateModules() do
        if module['GetConfig'] ~= nil then
            moduleOptions.args[name] = module:GetConfig()
        end
        if module['GetDefaultOptions'] ~= nil then
            local oName, oTable = module:GetDefaultOptions()
            self.defaults.profile.modules[oName] = oTable

            local frameName = self.freePlacementFrameMap[oName]
            if frameName and self.freePlacementModuleMeta[oName] == nil then
                local displayName = oName
                if module['GetName'] ~= nil then
                    local success, moduleName = pcall(function()
                        return module:GetName()
                    end)
                    if success and moduleName then
                        displayName = moduleName
                    end
                end

                self.freePlacementModuleMeta[oName] = {
                    displayName = displayName,
                    frameName = frameName,
                    module = module,
                }
                table.insert(self.freePlacementModuleOrder, oName)
            end
        end
    end

    local modulesPositioningOptions = self:GetModulesPositionningOptions()

    local function orange(string)
        if type(string) ~= "string" then string = tostring(string) end
        string = XIVBar:CreateColorString(string, {r = 0.859, g = 0.388, b = 0.203})
        return string
    end

    local function lightblue(string)
        if type(string) ~= "string" then string = tostring(string) end
        string = XIVBar:CreateColorString(string, {r = 0.4, g = 0.6, b = 1.0})
        return string
    end

    local function renderChangelogLine(line, color)
        line = gsub(line, "%[[^%[]+%]", color)
        return line
    end

    for version, data in pairs(XIVBar.Changelog) do
        local versionString = data.version_string
        local dateTable = {strsplit("/", data.release_date)}
        local dateString = data.release_date
        if #dateTable == 3 then
            dateString = L["DATE_FORMAT"]
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
                    name = GAME_VERSION_LABEL .. " " .. orange(versionString) ..
                        " - |cffbbbbbb" .. dateString .. "|r",
                    fontSize = "large"
                }
            }
        }

        local page = changelogOptions.args[tostring(version)].args

        local header
        if data.header then
            local headerLocalized = data.header[GetLocale()]
            if headerLocalized ~= nil and (headerLocalized.title ~= nil or headerLocalized.text ~= nil) then
                header = headerLocalized
            else
                header = data.header["enUS"]
            end
        end

        if header and (header.title ~= nil or header.text ~= nil) then
            if header.title ~= nil and header.title ~= "" then
                page.headerHeader = {
                    order = 2.5,
                    type = "header",
                    name = lightblue(header.title)
                }
            end

            if header.text ~= nil and header.text ~= "" then
                page.headerText = {
                    order = 2.6,
                    type = "description",
                    name = function()
                        return renderChangelogLine(header.text, lightblue) .. "\n"
                    end,
                    fontSize = "medium"
                }
            end
        end

        -- Checking localized "Important" category
        local important_localized
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
                name = orange(L["IMPORTANT"])
            }
            page.important = {
                order = 4,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(important) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line, orange) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end

        -- Checking localized "Bugfix" category
        local bugfix_localized = {}
        if data.bugfix and data.bugfix[GetLocale()] ~= nil and next(data.bugfix[GetLocale()]) ~= nil then
            bugfix_localized = data.bugfix[GetLocale()]
        elseif data.bugfix then
            bugfix_localized = data.bugfix["enUS"]
        end

        local bugfix = data.bugfix and bugfix_localized
        if bugfix and #bugfix > 0 then
            page.bugfixHeader = {
                order = 9,
                type = "header",
                name = orange(L["BUGFIX"]) or orange("Bugfix")
            }
            page.bugfix = {
                order = 10,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(bugfix) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line, orange) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end

        -- Checking localized "New" category
        local new_localized
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
                name = orange(L["NEW"])
            }
            page.new = {
                order = 6,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(new) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line, orange) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end

        -- Checking localized "Improvment" category
        local improvment_localized
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
                name = orange(L["IMPROVEMENT"])
            }
            page.improvment = {
                order = 8,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(improvment) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line, orange) .. "\n"
                    end
                    return text .. "\n"
                end,
                fontSize = "medium"
            }
        end
    end

    -- Get profile options
    local profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Register all options tables
    AceConfig:RegisterOptionsTable(AddOnName, options)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Modules", moduleOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_ModulesPositioning", modulesPositioningOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Changelog", changelogOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Profiles", profileOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_ProfileSharing", profileSharingOptions)

    -- Add to Blizzard options
    local _, mainCategory = AceConfigDialog:AddToBlizOptions(AddOnName, "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Modules", L["MODULES"], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_ModulesPositioning", L["MODULES_POSITIONING"], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L["CHANGELOG"], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Profiles", 'Profiles', "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_ProfileSharing", 'Profile Sharing', "XIV Bar Continued")
    self.optionsCategory = mainCategory
end

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
        print("|cffff0000XIV Databar Continued:|r " .. L["INVALID_IMPORT_STRING"])
        return false
    end

    local decoded = LibStub:GetLibrary("LibDeflate"):DecodeForPrint(encoded)
    if not decoded then
        print("|cffff0000XIV Databar Continued:|r " .. L["FAILED_DECODE_IMPORT_STRING"])
        return false
    end

    local decompressed = LibStub:GetLibrary("LibDeflate"):DecompressDeflate(decoded)
    if not decompressed then
        print("|cffff0000XIV Databar Continued:|r " .. L["FAILED_DECOMPRESS_IMPORT_STRING"])
        return false
    end

    local success, imported = LibStub:GetLibrary("AceSerializer-3.0"):Deserialize(decompressed)
    if not success then
        print("|cffff0000XIV Databar Continued:|r " .. L["FAILED_DESERIALIZE_IMPORT_STRING"])
        return false
    end

    -- Validate the imported data
    if type(imported) ~= "table" or type(imported.profile) ~= "table" or type(imported.meta) ~= "table" then
        print("|cffff0000XIV Databar Continued:|r " .. L["INVALID_PROFILE_FORMAT"])
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
    print("|cff00ff00XIV Databar Continued:|r " .. L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] .. " '" .. profileName .. "'")
    return true
end

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

StaticPopupDialogs["XIVBAR_EXPORT_PROFILE"] = {
    text = L["COPY_EXPORT_STRING"],
    button1 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 350,
    maxLetters = 0,
    OnShow = function(self)
        local eb = self.editBox or self.EditBox
        if eb then
            eb:SetAutoFocus(true)
            eb:SetJustifyH("LEFT")
            eb:SetWidth(350)
        end
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
    text = L["PASTE_IMPORT_STRING"],
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = true,
    editBoxWidth = 350,
    maxLetters = 0,
    OnShow = function(self)
        local eb = self.editBox or self.EditBox
        if eb then
            eb:SetAutoFocus(true)
            eb:SetJustifyH("LEFT")
            eb:SetWidth(350)
        end
    end,
    OnAccept = function(self)
        local eb = self.editBox or self.EditBox
        local importString = eb and eb:GetText() or ""
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

function XIVBar:GetGeneralOptions()
    return {
        name = GENERAL_LABEL,
        type = "group",
        inline = true,
        args = {
            positioning = self:GetPositioningOptions(),
            text = self:GetTextOptions(),
            textColors = self:GetColorOptions(),
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
                name = L["FONT"],
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
                name = L["SMALL_FONT_SIZE"],
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
                name = L["TEXT_STYLE"],
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

function XIVBar:GetColorOptions()
    return {
        name = L["COLORS"],
        type = "group",
        inline = true,
        order = 3,
        args = {
            barColor = {
                name = L["BAR_COLOR"],
                type = "color",
                order = 1,
                hasAlpha = true,
                set = function(info, r, g, b, a)
                    if not self.db.profile.color.useCC then
                        self:SetColor('barColor', r, g, b, a)
                    else
                        local cr, cg, cb, _ = self:GetClassColors()
                        self:SetColor('barColor', cr, cg, cb, a)
                    end
                end,
                get = function()
                    return XIVBar:GetColor('barColor')
                end
            },
            barCC = {
                name = L["USE_CLASS_COLOR"],
                desc = L["USE_CLASS_COLOR_TEXT_DESC"],
                type = "toggle",
                order = 2,
                set = function(info, val)
                    XIVBar:SetColor('barColor', self:GetClassColors());
                    self.db.profile.color.useCC = val;
                    self:Refresh();
                end,
                get = function()
                    return self.db.profile.color.useCC
                end
            },
            textColors = self:GetTextColorOptions()
        }
    }
end

function XIVBar:GetTextColorOptions()
    return {
        name = L["TEXT_COLORS"],
        type = "group",
        order = 4,
        inline = true,
        args = {
            normal = {
                name = L["NORMAL"],
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
                name = L["USE_CLASS_COLOR_TEXT"],
                desc = L["USE_CLASS_COLOR_TEXT_DESC"],
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
                name = L["HOVER"],
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
                name = L["USE_CLASS_COLORS_FOR_HOVER"],
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
                name = L["INACTIVE"],
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

function XIVBar:GetPositioningOptions()
    return {
        name = L["POSITIONING"],
        type = "group",
        order = 1,
        inline = true,
        args = {
            positionHeader = {
                name = L["BAR_POSITION"],
                type = "header",
                order = 1
            },
            barFullscreen = {
                name = VIDEO_OPTIONS_FULLSCREEN,
                desc = L["BAR_FULLSCREEN_DESC"],
                type = "toggle",
                order = 2,
                width = "full",
                get = function()
                    return self.db.profile.general.barFullscreen
                end,
                set = function(_, val)
                    self.db.profile.general.barFullscreen = val
                    self:Refresh()
                end
            },
            barPosition = {
                name = L["BAR_POSITION"],
                desc = L["BAR_POSITION_DESC"],
                type = "select",
                order = 3,
                width = "full",
                values = {TOP = L["TOP"], BOTTOM = L["BOTTOM"]},
                style = "dropdown",
                hidden = function()
                    return not self.db.profile.general.barFullscreen
                end,
                get = function()
                    return self.db.profile.general.barPosition
                end,
                set = function(_, val)
                    self.db.profile.general.barPosition = val
                    self:Refresh()
                end
            },
            xOffset = {
                name = L["X_OFFSET"],
                desc = L["HORIZONTAL_POSITION"],
                type = "range",
                order = 4,
                hidden = function()
                    return self.db.profile.general.barFullscreen
                end,
                min = -floor(GetScreenWidth()),
                max = floor(GetScreenWidth()),
                step = 1,
                get = function()
                    return self.db.profile.general.xOffset
                end,
                set = function(_, val)
                    self.db.profile.general.xOffset = val
                    self:Refresh()
                end
            },
            yOffset = {
                name = L["Y_OFFSET"],
                desc = L["VERTICAL_POSITION"],
                type = "range",
                order = 5,
                hidden = function()
                    return self.db.profile.general.barFullscreen
                end,
                min = -floor(GetScreenHeight()),
                max = floor(GetScreenHeight()),
                step = 1,
                get = function()
                    return self.db.profile.general.yOffset
                end,
                set = function(_, val)
                    self.db.profile.general.yOffset = val
                    self:Refresh()
                end
            },
            locked = {
                name = L["LOCK_BAR"],
                desc = L["LOCK_BAR_DESC"],
                type = "toggle",
                order = 6,
                hidden = function()
                    return self.db.profile.general.barFullscreen
                end,
                get = function()
                    return self.db.profile.general.locked
                end,
                set = function(_, val)
                    self.db.profile.general.locked = val
                end
            },
            barWidth = {
                name = L["BAR_WIDTH"],
                type = "range",
                order = 7,
                hidden = function()
                    return self.db.profile.general.barFullscreen
                end,
                min = 200,
                max = math.floor(GetScreenWidth()),
                step = 1,
                get = function()
                    return self.db.profile.general.barWidth
                end,
                set = function(_, val)
                    self.db.profile.general.barWidth = val
                    self:Refresh()
                end,
                disabled = function()
                    return self.db.profile.general.barFullscreen
                end
            },
            behaviorHeader = {
                name = L["BEHAVIOR"],
                type = "header",
                order = 8
            },
            barCombatHide = {
                name = L["HIDE_IN_COMBAT"],
                type = "toggle",
                order = 9,
                get = function()
                    return self.db.profile.general.barCombatHide
                end,
                set = function(_, val)
                    self.db.profile.general.barCombatHide = val
                    self:Refresh()
                end
            },
            barFlightHide = {
                name = L["HIDE_IN_FLIGHT"],
                type = "toggle",
                order = 10,
                get = function()
                    return self.db.profile.general.barFlightHide
                end,
                set = function(_, val)
                    self.db.profile.general.barFlightHide = val
                end
            },
            showOnMouseover = {
                name = L["SHOW_ON_MOUSEOVER"],
                desc = L["SHOW_ON_MOUSEOVER_DESC"],
                type = "toggle",
                order = 10.5,
                get = function()
                    return self.db.profile.general.showOnMouseover
                end,
                set = function(_, val)
                    self.db.profile.general.showOnMouseover = val
                    XIVBar:UpdateMouseoverScripts()
                end
            },
            spacingHeader = {
                name = L["SPACING"],
                type = "header",
                order = 11
            },
            barPadding = {
                name = L["BAR_PADDING"],
                type = "range",
                order = 12,
                min = 0,
                max = 10,
                step = 1,
                get = function()
                    return self.db.profile.general.barPadding
                end,
                set = function(_, val)
                    self.db.profile.general.barPadding = val
                    self:Refresh()
                end
            },
            moduleSpacing = {
                name = L["MODULE_SPACING"],
                type = "range",
                order = 13,
                min = 10,
                max = 80,
                step = 1,
                disabled = function()
                    return self.db.profile.general.enableFreePlacement
                end,
                get = function()
                    return self.db.profile.general.moduleSpacing
                end,
                set = function(_, val)
                    self.db.profile.general.moduleSpacing = val
                    self:Refresh()
                end
            },
            barMargin = {
                name = L["BAR_MARGIN"],
                desc = L["BAR_MARGIN_DESC"],
                type = "range",
                order = 14,
                min = 0,
                max = 80,
                step = 1,
                get = function()
                    return self.db.profile.general.barMargin
                end,
                set = function(_, val)
                    self.db.profile.general.barMargin = val
                    self:Refresh()
                end
            }
        }
    }
end

function XIVBar:IsFreePlacementEnabled()
    return self.db and self.db.profile and self.db.profile.general.enableFreePlacement
end

function XIVBar:GetModulePlacements(create)
    local general = self.db and self.db.profile and self.db.profile.general
    if not general then
        return nil
    end

    if create and type(general.modulePlacements) ~= "table" then
        general.modulePlacements = {}
    end

    return general.modulePlacements
end

function XIVBar:GetDefaultModulePlacement(moduleKey)
    local anchor = self.freePlacementDefaultAnchor[moduleKey] or "CENTER"
    local padding = self.db and self.db.profile and self.db.profile.general.barPadding or 0
    local x = 0

    if anchor == "LEFT" then
        x = padding
    elseif anchor == "RIGHT" then
        x = -(padding)
    end

    return anchor, x
end

function XIVBar:GetModulePlacement(moduleKey, create)
    if type(moduleKey) ~= "string" then
        return nil
    end

    local placements = self:GetModulePlacements(create)
    if not placements then
        return nil
    end

    if create and type(placements[moduleKey]) ~= "table" then
        local defaultAnchor, defaultX = self:GetDefaultModulePlacement(moduleKey)
        placements[moduleKey] = {
            anchorPoint = defaultAnchor,
            x = defaultX,
            captured = false,
        }
    end

    return placements[moduleKey]
end

function XIVBar:CaptureModulePlacement(moduleKey, frame, isInitial)
    if type(moduleKey) ~= "string" then
        return false
    end

    local placement = self:GetModulePlacement(moduleKey, true)
    if not placement then
        return false
    end

    local bar = self:GetFrame("bar")
    local captured = false

    if frame and bar then
        local barLeft, barRight, barCenter = bar:GetLeft(), bar:GetRight(), bar:GetCenter()
        local frameLeft, frameRight, frameCenter = frame:GetLeft(), frame:GetRight(), frame:GetCenter()

        if barLeft and barRight and barCenter and frameLeft and frameRight and frameCenter then
            local distanceLeft = abs(frameLeft - barLeft)
            local distanceCenter = abs(frameCenter - barCenter)
            local distanceRight = abs(frameRight - barRight)

            local anchor = "CENTER"
            if distanceLeft <= distanceCenter and distanceLeft <= distanceRight then
                anchor = "LEFT"
            elseif distanceRight < distanceCenter and distanceRight < distanceLeft then
                anchor = "RIGHT"
            end

            local x
            if anchor == "LEFT" then
                x = frameLeft - barLeft
            elseif anchor == "RIGHT" then
                x = frameRight - barRight
            else
                x = frameCenter - barCenter
            end

            placement.anchorPoint = anchor
            placement.x = x
            captured = true
        end
    end

    if not captured and frame then
        local point, _, _, xOffset = frame:GetPoint(1)
        if point and type(xOffset) == "number" then
            local anchor = "CENTER"
            if point:find("LEFT") then
                anchor = "LEFT"
            elseif point:find("RIGHT") then
                anchor = "RIGHT"
            end

            placement.anchorPoint = anchor
            placement.x = xOffset
            captured = true
        end
    end

    if not captured then
        local defaultAnchor, defaultX = self:GetDefaultModulePlacement(moduleKey)
        placement.anchorPoint = defaultAnchor
        placement.x = defaultX
    end

    if isInitial then
        placement.initialX = placement.x
        placement.initialAnchorPoint = placement.anchorPoint
    end
    placement.captured = true
    return captured
end

function XIVBar:CaptureAllModulePlacements(forceInitial)
    if not self.freePlacementModuleOrder then
        return
    end

    for _, moduleKey in ipairs(self.freePlacementModuleOrder) do
        local meta = self.freePlacementModuleMeta and self.freePlacementModuleMeta[moduleKey]
        local frameName = meta and meta.frameName or self.freePlacementFrameMap[moduleKey]
        local frame = frameName and self:GetFrame(frameName) or nil
        local placement = self:GetModulePlacement(moduleKey, true)
        if forceInitial == true
            or not placement
            or placement.initialX == nil
            or placement.initialAnchorPoint == nil then
            self:CaptureModulePlacement(moduleKey, frame, true)
        end
    end

    if self.db and self.db.profile and self.db.profile.general then
        self.db.profile.general.freePlacementInitialized = true
    end
end

function XIVBar:RecaptureAllInitialModulePlacements()
    if self:IsFreePlacementEnabled() then
        return false
    end

    if not self.freePlacementModuleOrder then
        return false
    end

    for _, moduleKey in ipairs(self.freePlacementModuleOrder) do
        local meta = self.freePlacementModuleMeta and self.freePlacementModuleMeta[moduleKey]
        local frameName = meta and meta.frameName or self.freePlacementFrameMap[moduleKey]
        local frame = frameName and self:GetFrame(frameName) or nil
        local placement = self:GetModulePlacement(moduleKey, true)

        if frame and placement then
            local previousX = placement.x
            local previousAnchorPoint = placement.anchorPoint
            local previousCaptured = placement.captured

            self:CaptureModulePlacement(moduleKey, frame, true)

            placement.x = previousX
            placement.anchorPoint = previousAnchorPoint
            placement.captured = previousCaptured
        end
    end

    return true
end

function XIVBar:ApplyModuleFreePlacement(moduleKey, frame)
    if not self:IsFreePlacementEnabled() then
        return false
    end

    if type(moduleKey) ~= "string" or frame == nil then
        return true
    end

    local bar = self:GetFrame('bar')
    if not bar then
        return true
    end

    local placement = self:GetModulePlacement(moduleKey, true)
    if not placement then
        return true
    end

    if type(placement.x) ~= "number" then
        placement.captured = false
    end

    if placement.captured ~= true then
        self:CaptureModulePlacement(moduleKey, frame)
    end

    local anchor = NormalizeAnchor(placement.anchorPoint)
    local xOffset = placement.x

    frame:ClearAllPoints()
    frame:SetPoint(anchor, bar, anchor, xOffset, 0)

    placement.captured = true
    return true
end

function XIVBar:ApplySingleModuleFreePlacement(moduleKey)
    local meta = self.freePlacementModuleMeta and self.freePlacementModuleMeta[moduleKey]
    local frameName = meta and meta.frameName or (self.freePlacementFrameMap and self.freePlacementFrameMap[moduleKey])
    local frame = frameName and self:GetFrame(frameName)
    if frame then
        self:ApplyModuleFreePlacement(moduleKey, frame)
    end
end

function XIVBar:ResetModulePlacement(moduleKey)
    local placement = self:GetModulePlacement(moduleKey, false)
    if not placement or placement.initialX == nil then return end
    placement.x = placement.initialX
    placement.anchorPoint = placement.initialAnchorPoint
    placement.captured = true
    self:ApplySingleModuleFreePlacement(moduleKey)
end

function XIVBar:ResetAllModulePlacements()
    if not self.freePlacementModuleOrder then
        return
    end

    for _, moduleKey in ipairs(self.freePlacementModuleOrder) do
        local mod = self.db and self.db.profile and self.db.profile.modules and self.db.profile.modules[moduleKey]
        if mod == nil or mod.enabled ~= false then
            self:ResetModulePlacement(moduleKey)
        end
    end
end

function XIVBar:GetModulesPositionningOptions()
    local args = {
        enableFreePlacement = {
            name = L["ENABLE_FREE_PLACEMENT"],
            desc = L["ENABLE_FREE_PLACEMENT_DESC"],
            type = "toggle",
            order = 1,
            width = "full",
            get = function()
                return self.db.profile.general.enableFreePlacement
            end,
            set = function(_, val)
                if self.freePlacementToggleInProgress then
                    return
                end

                local wasEnabled = self.db.profile.general.enableFreePlacement
                if val == wasEnabled then
                    return
                end

                self.freePlacementToggleInProgress = true
                self.db.profile.general.enableFreePlacement = val

                if val and not wasEnabled and not self.db.profile.general.freePlacementInitialized then
                    self:CaptureAllModulePlacements()
                end

                if not val then
                    self.db.profile.modules.clock.enabled = true

                    local clockModule = self:GetModule("ClockModule", true)
                    if clockModule then
                        clockModule:Enable()
                        clockModule:Refresh()
                    end
                end

                self:Refresh()

                local registry = LibStub("AceConfigRegistry-3.0", true)
                if registry then
                    registry:NotifyChange(AddOnName)
                    registry:NotifyChange(AddOnName .. "_ModulesPositioning")
                end

                self.freePlacementToggleInProgress = false
            end,
        },
        resetAllPositions = {
            name = L["RESET_ALL_POSITIONS"],
            desc = L["RESET_ALL_POSITIONS_DESC"],
            type = "execute",
            order = 1.5,
            width = "full",
            disabled = function()
                return not self.db.profile.general.enableFreePlacement
            end,
            func = function()
                self:ResetAllModulePlacements()
                local registry = LibStub("AceConfigRegistry-3.0", true)
                if registry then
                    registry:NotifyChange(AddOnName .. "_ModulesPositioning")
                end
            end,
        },
        recaptureAllInitialPositions = {
            name = L["RECAPTURE_INITIAL_POSITIONS"],
            desc = L["RECAPTURE_INITIAL_POSITIONS_DESC"],
            type = "execute",
            order = 1.6,
            width = "full",
            disabled = function()
                return self.db.profile.general.enableFreePlacement
            end,
            func = function()
                self:RecaptureAllInitialModulePlacements()
                local registry = LibStub("AceConfigRegistry-3.0", true)
                if registry then
                    registry:NotifyChange(AddOnName .. "_ModulesPositioning")
                end
            end,
        },
    }

    local sortedModuleOrder = {}
    for _, moduleKey in ipairs(self.freePlacementModuleOrder or {}) do
        table.insert(sortedModuleOrder, moduleKey)
    end
    table.sort(sortedModuleOrder, function(a, b)
        local metaA = self.freePlacementModuleMeta and self.freePlacementModuleMeta[a]
        local metaB = self.freePlacementModuleMeta and self.freePlacementModuleMeta[b]
        local nameA = metaA and metaA.displayName or a
        local nameB = metaB and metaB.displayName or b
        return nameA:lower() < nameB:lower()
    end)

    for order, moduleKey in ipairs(sortedModuleOrder) do
        local moduleMeta = self.freePlacementModuleMeta and self.freePlacementModuleMeta[moduleKey]
        if moduleMeta then
            local currentModuleKey = moduleKey
            local currentModuleMeta = moduleMeta

            args[currentModuleKey] = {
                name = currentModuleMeta.displayName,
                type = "group",
                order = order + 1,
                inline = true,
                disabled = function()
                    if not self.db.profile.general.enableFreePlacement then return true end
                    local mod = self.db.profile.modules[currentModuleKey]
                    return mod ~= nil and mod.enabled == false
                end,
                args = {
                    anchorPoint = {
                        name = L["ANCHOR_POINT"],
                        type = "select",
                        order = 1,
                        values = {
                            LEFT = L["LEFT"],
                            CENTER = L["CENTER"],
                            RIGHT = L["RIGHT"],
                        },
                        get = function(info)
                            local moduleKeyFromInfo = info and info[#info - 1] or currentModuleKey
                            local placement = self:GetModulePlacement(moduleKeyFromInfo, true)
                            return placement and NormalizeAnchor(placement.anchorPoint) or "CENTER"
                        end,
                        set = function(info, value)
                            local moduleKeyFromInfo = info and info[#info - 1] or currentModuleKey
                            local placement = self:GetModulePlacement(moduleKeyFromInfo, true)
                            if placement then
                                placement.anchorPoint = NormalizeAnchor(value)
                                placement.captured = true
                            end
                            self:ApplySingleModuleFreePlacement(moduleKeyFromInfo)
                        end,
                    },
                    xPosition = {
                        name = L["X_POSITION"],
                        type = "range",
                        order = 2,
                        min = -floor(GetScreenWidth()),
                        max = floor(GetScreenWidth()),
                        step = 1,
                        get = function(info)
                            local moduleKeyFromInfo = info and info[#info - 1] or currentModuleKey
                            local placement = self:GetModulePlacement(moduleKeyFromInfo, true)
                            return placement and RoundNearest(placement.x) or 0
                        end,
                        set = function(info, value)
                            local moduleKeyFromInfo = info and info[#info - 1] or currentModuleKey
                            local placement = self:GetModulePlacement(moduleKeyFromInfo, true)
                            if placement then
                                placement.x = RoundNearest(value)
                                placement.captured = true
                            end
                            self:ApplySingleModuleFreePlacement(moduleKeyFromInfo)
                        end,
                    },
                    resetPosition = {
                        name = L["RESET_POSITION"],
                        desc = L["RESET_POSITION_DESC"],
                        type = "execute",
                        order = 3,
                        func = function()
                            self:ResetModulePlacement(currentModuleKey)
                            local registry = LibStub("AceConfigRegistry-3.0", true)
                            if registry then
                                registry:NotifyChange(AddOnName .. "_ModulesPositioning")
                            end
                        end,
                    },
                }
            }
        end
    end

    return {
        name = L["MODULES_POSITIONING"],
        type = "group",
        args = args
    }
end