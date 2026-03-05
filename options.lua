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
                name = orange(L["Bugfix"]) or orange("Bugfix")
            }
            page.bugfix = {
                order = 10,
                type = "description",
                name = function()
                    local text = ""
                    for index, line in ipairs(bugfix) do
                        text = text .. index .. ". " ..
                                   renderChangelogLine(line) .. "\n"
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

    -- Get profile options
    local profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Register all options tables
    AceConfig:RegisterOptionsTable(AddOnName, options)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Modules", moduleOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Changelog", changelogOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Profiles", profileOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_ProfileSharing", profileSharingOptions)

    -- Add to Blizzard options
    local _, mainCategory = AceConfigDialog:AddToBlizOptions(AddOnName, "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Modules", L['Modules'], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L['Changelog'], "XIV Bar Continued")
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
    text = L["Copy the export string below:"],
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
    text = L["Paste the import string below:"],
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

function XIVBar:GetColorOptions()
    return {
        name = L["Colors"],
        type = "group",
        inline = true,
        order = 3,
        args = {
            barColor = {
                name = L['Bar Color'],
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
                name = L['Use Class Color for Bar'],
                desc = L["Only the alpha can be set with the color picker"],
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
        name = L['Text Colors'],
        type = "group",
        order = 4,
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

function XIVBar:GetPositioningOptions()
    return {
        name = L["Positioning"],
        type = "group",
        order = 1,
        inline = true,
        args = {
            positionHeader = {
                name = L["Bar Position"],
                type = "header",
                order = 1
            },
            barFullscreen = {
                name = VIDEO_OPTIONS_FULLSCREEN,
                desc = L["Makes the bar span the entire screen width"],
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
                name = L['Bar Position'],
                desc = L["Position the bar at the top or bottom of the screen"],
                type = "select",
                order = 3,
                width = "full",
                values = {TOP = L["Top"], BOTTOM = L["Bottom"]},
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
                name = L["X Offset"],
                desc = L["Horizontal position of the bar"],
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
                name = L["Y Offset"],
                desc = L["Vertical position of the bar"],
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
                name = L["Lock Bar"],
                desc = L["Lock the bar to prevent dragging"],
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
                name = L["Bar Width"],
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
                name = L["Behavior"],
                type = "header",
                order = 8
            },
            barCombatHide = {
                name = L['Hide Bar in combat'],
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
                name = L["Hide when in flight"],
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
                name = L["Show on mouseover"],
                desc = L["Show the bar only when you mouseover it"],
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
                name = L["Spacing"],
                type = "header",
                order = 11
            },
            barPadding = {
                name = L["Bar Padding"],
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
                name = L["Module Spacing"],
                type = "range",
                order = 13,
                min = 10,
                max = 80,
                step = 1,
                get = function()
                    return self.db.profile.general.moduleSpacing
                end,
                set = function(_, val)
                    self.db.profile.general.moduleSpacing = val
                    self:Refresh()
                end
            },
            barMargin = {
                name = L["Bar Margin"],
                desc = L["Leftmost and rightmost margin of the bar modules"],
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
