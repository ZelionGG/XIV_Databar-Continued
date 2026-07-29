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
            disableTooltipsInCombat = false,
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
            disableLoginMessage = false,
            lastChangelogAnnounce = "",
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
                a = 1
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

XIVBar.ColumnRow = function(order, left, right, spacerWidth)
    left.order = 1
    left.width = left.width or 1.25
    right.order = 2
    right.width = right.width or 1.25
    return {
        type = "group", inline = true, name = "", order = order,
        args = {
            col1 = left,
            spacer = { name = " ", type = "description", order = 1.5, width = spacerWidth or 0.12 },
            col2 = right,
        }
    }
end

function XIVBar:SetupOptions()
    local options = {
        name = "XIV Databar Continued",
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
        local dateString = XIVBar:FormatLocalizedDateString(data.release_date)

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
    profileOptions.plugins = profileOptions.plugins or {}
    profileOptions.plugins.XIVBarProfileSharing = {
        sharingHeader = {
            order = 90,
            type = "header",
            name = L["PROFILE_IMPORT_EXPORT"],
        },
        sharingDesc = {
            order = 91,
            type = "description",
            name = L["IMPORT_EXPORT_PROFILES_DESC"],
            fontSize = "medium",
        },
        importExportRow = XIVBar.ColumnRow(93, {
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
        {
            type = "execute",
            name = L["IMPORT_PROFILE"],
            desc = L["IMPORT_PROFILE_DESC"],
            func = function()
                StaticPopup_Show("XIVBAR_IMPORT_PROFILE")
            end,
        }),
    }

    -- Register all options tables
    AceConfig:RegisterOptionsTable(AddOnName, options)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Modules", moduleOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_ModulesPositioning", function()
        return self:GetModulesPositionningOptions()
    end)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Changelog", changelogOptions)
    AceConfig:RegisterOptionsTable(AddOnName .. "_Profiles", profileOptions)

    -- Add to Blizzard options
    local _, mainCategory = AceConfigDialog:AddToBlizOptions(AddOnName, "XIV Databar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Modules", L["MODULES"], "XIV Databar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_ModulesPositioning", L["MODULES_POSITIONING"], "XIV Databar Continued")
    local _, changelogCategory = AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L["CHANGELOG"], "XIV Databar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Profiles", 'Profiles', "XIV Databar Continued")
    self.optionsCategory = mainCategory
    self.changelogCategory = changelogCategory
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

local PROFILE_SETUP_DIALOG_WIDTH = 560
local PROFILE_SETUP_TEXT_WIDTH = 540
local PROFILE_SETUP_BUTTON_GAP = 10
local PROFILE_SETUP_TOP_PAD = 20
local PROFILE_SETUP_TITLE_BODY_GAP = 16
local PROFILE_SETUP_BODY_SEP_GAP = 14
local PROFILE_SETUP_SEP_FOOTER_GAP = 10
local PROFILE_SETUP_FOOTER_BUTTON_GAP = 24
local PROFILE_SETUP_BODY_BUTTON_GAP = 24
local PROFILE_SETUP_BOTTOM_PAD = 20
local PROFILE_SETUP_BUTTON_HEIGHT = 24
local PROFILE_SETUP_SEP_HEIGHT = 1
local PROFILE_SETUP_SEP_WIDTH = 400
local PROFILE_SETUP_ACCENT = "|cff40E0D0%s|r"

local function ApplyProfileSetupBackdrop(frame)
    if not frame.SetBackdrop then
        return
    end
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    frame:SetBackdropColor(0, 0, 0, 1)
end

local function LayoutProfileSetupButtons(frame, specs)
    local visible = {}
    for i, button in ipairs(frame.buttons) do
        local spec = specs[i]
        if spec and spec.show ~= false then
            button:SetText(spec.text)
            button:SetScript("OnClick", function()
                if spec.onClick then
                    spec.onClick()
                end
                frame:Hide()
            end)
            local width = math.max(120, button:GetTextWidth() + 24)
            button:SetWidth(width)
            button:Show()
            visible[#visible + 1] = button
        else
            button:Hide()
            button:SetScript("OnClick", nil)
        end
    end

    local totalWidth = 0
    for i, button in ipairs(visible) do
        totalWidth = totalWidth + button:GetWidth()
        if i > 1 then
            totalWidth = totalWidth + PROFILE_SETUP_BUTTON_GAP
        end
    end

    local x = -totalWidth / 2
    for _, button in ipairs(visible) do
        button:ClearAllPoints()
        button:SetPoint("LEFT", frame.buttonContainer, "CENTER", x, 0)
        x = x + button:GetWidth() + PROFILE_SETUP_BUTTON_GAP
    end
end

local function ResizeProfileSetupFrame(frame)
    local height = PROFILE_SETUP_TOP_PAD
        + frame.title:GetStringHeight()
        + PROFILE_SETUP_TITLE_BODY_GAP
        + frame.body:GetStringHeight()

    if frame.footer:IsShown() then
        height = height
            + PROFILE_SETUP_BODY_SEP_GAP
            + PROFILE_SETUP_SEP_HEIGHT
            + PROFILE_SETUP_SEP_FOOTER_GAP
            + frame.footer:GetStringHeight()
            + PROFILE_SETUP_FOOTER_BUTTON_GAP
    else
        height = height + PROFILE_SETUP_BODY_BUTTON_GAP
    end

    height = height + PROFILE_SETUP_BUTTON_HEIGHT + PROFILE_SETUP_BOTTOM_PAD
    frame:SetHeight(height)
end

local function CreateProfileSetupFrame()
    local compat = XIVBar.compat
    local useElvUI = XIVBar.db.profile.general.useElvUI
        and (compat.IsAddOnLoaded('ElvUI') or compat.IsAddOnLoaded('Tukui'))

    local template = BackdropTemplateMixin and "BackdropTemplate" or nil
    local frame = CreateFrame("Frame", "XIVBarProfileSetupFrame", UIParent, template)
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(100)
    frame:SetWidth(PROFILE_SETUP_DIALOG_WIDTH)
    frame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    if useElvUI then
        if frame.StripTextures then
            frame:StripTextures()
        end
        if frame.SetTemplate then
            frame:SetTemplate("Transparent")
        end
    else
        ApplyProfileSetupBackdrop(frame)
    end

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    title:SetPoint("TOP", 0, -PROFILE_SETUP_TOP_PAD)
    title:SetWidth(PROFILE_SETUP_TEXT_WIDTH)
    title:SetJustifyH("CENTER")
    title:SetTextColor(1, 0.82, 0)
    frame.title = title

    local body = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    body:SetPoint("TOP", title, "BOTTOM", 0, -PROFILE_SETUP_TITLE_BODY_GAP)
    body:SetWidth(PROFILE_SETUP_TEXT_WIDTH)
    body:SetJustifyH("CENTER")
    body:SetTextColor(1, 1, 1)
    frame.body = body

    local separator = frame:CreateTexture(nil, "ARTWORK")
    separator:SetColorTexture(1, 1, 1, 0.25)
    separator:SetSize(PROFILE_SETUP_SEP_WIDTH, PROFILE_SETUP_SEP_HEIGHT)
    separator:SetPoint("TOP", body, "BOTTOM", 0, -PROFILE_SETUP_BODY_SEP_GAP)
    frame.separator = separator

    local footer = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    footer:SetPoint("TOP", separator, "BOTTOM", 0, -PROFILE_SETUP_SEP_FOOTER_GAP)
    footer:SetWidth(PROFILE_SETUP_TEXT_WIDTH)
    footer:SetJustifyH("CENTER")
    footer:SetTextColor(1, 1, 1)
    frame.footer = footer

    local buttonContainer = CreateFrame("Frame", nil, frame)
    buttonContainer:SetPoint("BOTTOM", 0, PROFILE_SETUP_BOTTOM_PAD)
    buttonContainer:SetSize(PROFILE_SETUP_TEXT_WIDTH, PROFILE_SETUP_BUTTON_HEIGHT)
    frame.buttonContainer = buttonContainer

    local elvSkins = _G.ElvUI and _G.ElvUI[1] and _G.ElvUI[1]:GetModule('Skins', true)

    frame.buttons = {}
    for i = 1, 3 do
        local button = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
        button:SetSize(120, PROFILE_SETUP_BUTTON_HEIGHT)
        if useElvUI and elvSkins and elvSkins.HandleButton then
            elvSkins:HandleButton(button)
        end
        frame.buttons[i] = button
    end

    frame:SetScript("OnHide", function()
        -- Escape / dismiss: treat as keep current (same as former noCancelOnEscape).
        if XIVBar.db and not XIVBar:HasCompletedProfileSetup() then
            XIVBar:MarkProfileSetupDone()
        end
    end)

    table.insert(UISpecialFrames, frame:GetName())
    return frame
end

function XIVBar:ShowProfileSetupDialog(mode)
    local frame = self.profileSetupFrame
    if not frame then
        frame = CreateProfileSetupFrame()
        self.profileSetupFrame = frame
    end

    frame.title:SetText(L["PROFILE_SETUP_HEADER"])

    if mode == "migrate" then
        local pending = self.profileSetupPending
        local preferred = (pending and pending.preferred) or "Default"
        frame.body:SetText(L["PROFILE_SETUP_TEXT"])
        frame.footer:SetText(L["PROFILE_SETUP_CURRENT"]:format(PROFILE_SETUP_ACCENT:format(preferred)))
        frame.separator:Show()
        frame.footer:Show()

        local hasShared = self:GetSharedProfileForCopy() ~= nil
        LayoutProfileSetupButtons(frame, {
            {
                text = PROFILE_SETUP_ACCENT:format(L["PROFILE_SETUP_KEEP_CURRENT"]),
                onClick = function()
                    XIVBar:MarkProfileSetupDone()
                end,
            },
            {
                text = L["PROFILE_SETUP_NEW_FROM_SHARED"],
                show = hasShared,
                onClick = function()
                    XIVBar:CreatePersonalProfileFromSetup(true)
                end,
            },
            {
                text = L["PROFILE_SETUP_NEW_BLANK"],
                onClick = function()
                    XIVBar:CreatePersonalProfileFromSetup(false)
                end,
            },
        })
    else
        frame.body:SetText(L["PROFILE_NEWCHAR_TEXT"])
        frame.separator:Hide()
        frame.footer:Hide()
        LayoutProfileSetupButtons(frame, {
            {
                text = PROFILE_SETUP_ACCENT:format(L["PROFILE_SETUP_KEEP_CURRENT"]),
                onClick = function()
                    XIVBar:MarkProfileSetupDone()
                end,
            },
            {
                text = L["PROFILE_NEWCHAR_USE_SHARED"],
                onClick = function()
                    XIVBar:UseSharedDefaultFromSetup()
                end,
            },
        })
    end

    ResizeProfileSetupFrame(frame)
    frame:Show()
    frame:Raise()
end

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
                set = function(_, val)
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
                set = function(_, val)
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
                set = function(_, val)
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
                set = function(_, val)
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
                set = function(_, r, g, b, a)
                    if self.db.profile.color.useCC then
                        local c = self.db.profile.color.barColor
                        self:SetColor('barColor', c.r, c.g, c.b, a)
                    else
                        self:SetColor('barColor', r, g, b, a)
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
                set = function(_, val)
                    self.db.profile.color.useCC = val
                    self:Refresh()
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
                set = function(_, r, g, b, a)
                    if self.db.profile.color.useTextCC then
                        local c = self.db.profile.color.normal
                        XIVBar:SetColor('normal', c.r, c.g, c.b, a)
                    else
                        XIVBar:SetColor('normal', r, g, b, a)
                    end
                end,
                get = function() return XIVBar:GetColor('normal') end
            },
            textCC = {
                name = L["USE_CLASS_COLOR_TEXT"],
                desc = L["USE_CLASS_COLOR_TEXT_DESC"],
                type = "toggle",
                order = 2,
                set = function(_, val)
                    self.db.profile.color.useTextCC = val
                    self:Refresh()
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
                set = function(_, r, g, b, a)
                    if self.db.profile.color.useHoverCC then
                        local c = self.db.profile.color.hover
                        XIVBar:SetColor('hover', c.r, c.g, c.b, a)
                    else
                        XIVBar:SetColor('hover', r, g, b, a)
                    end
                end,
                get = function() return XIVBar:GetColor('hover') end
            },
            hoverCC = {
                name = L["USE_CLASS_COLORS_FOR_HOVER"],
                type = "toggle",
                order = 4,
                set = function(_, val)
                    self.db.profile.color.useHoverCC = val
                    self:Refresh()
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
                set = function(_, r, g, b, a)
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
            disableTooltipsInCombat = {
                name = L["DISABLE_TOOLTIPS_IN_COMBAT"] or "Disable Tooltips in Combat",
                type = "toggle",
                order = 10.6,
                get = function()
                    return self.db.profile.general.disableTooltipsInCombat
                end,
                set = function(_, val)
                    self.db.profile.general.disableTooltipsInCombat = val
                    self:Refresh()
                end
            },
            disableLoginMessage = {
                name = L["DISABLE_LOGIN_MESSAGE"] or "Disable login message",
                type = "toggle",
                order = 10.7,
                get = function()
                    return self.db.profile.general.disableLoginMessage
                end,
                set = function(_, val)
                    self.db.profile.general.disableLoginMessage = not not val
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

function XIVBar:NotifyModulesPositioningChange()
    local registry = LibStub("AceConfigRegistry-3.0", true)
    if registry then
        registry:NotifyChange(AddOnName .. "_ModulesPositioning")
    end
end

function XIVBar:RegisterDynamicFreePlacement(moduleKey, frameName, displayName, ownerModule)
    if type(moduleKey) ~= "string" or type(frameName) ~= "string" then
        return false
    end

    self.freePlacementFrameMap = self.freePlacementFrameMap or {}
    self.freePlacementDefaultAnchor = self.freePlacementDefaultAnchor or {}
    self.freePlacementModuleMeta = self.freePlacementModuleMeta or {}
    self.freePlacementModuleOrder = self.freePlacementModuleOrder or {}

    self.freePlacementFrameMap[moduleKey] = frameName
    self.freePlacementDefaultAnchor[moduleKey] = self.freePlacementDefaultAnchor[moduleKey] or "RIGHT"
    self.freePlacementModuleMeta[moduleKey] = {
        displayName = displayName or moduleKey,
        frameName = frameName,
        module = ownerModule,
        dynamic = true,
    }

    local alreadyListed = false
    for _, key in ipairs(self.freePlacementModuleOrder) do
        if key == moduleKey then
            alreadyListed = true
            break
        end
    end
    if not alreadyListed then
        table.insert(self.freePlacementModuleOrder, moduleKey)
    end

    self:NotifyModulesPositioningChange()
    return true
end

function XIVBar:UnregisterDynamicFreePlacement(moduleKey)
    if type(moduleKey) ~= "string" then
        return false
    end

    if self.freePlacementFrameMap then
        self.freePlacementFrameMap[moduleKey] = nil
    end
    if self.freePlacementDefaultAnchor then
        self.freePlacementDefaultAnchor[moduleKey] = nil
    end
    if self.freePlacementModuleMeta then
        self.freePlacementModuleMeta[moduleKey] = nil
    end

    if self.freePlacementModuleOrder then
        for i = #self.freePlacementModuleOrder, 1, -1 do
            if self.freePlacementModuleOrder[i] == moduleKey then
                table.remove(self.freePlacementModuleOrder, i)
            end
        end
    end

    self:NotifyModulesPositioningChange()
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
