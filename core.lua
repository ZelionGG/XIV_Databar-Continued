local AddOnName, XIVBar = ...;
local _G = _G;
local pairs, unpack, select = pairs, unpack, select
local floor = math.floor
local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local SetBarMouseoverScripts

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
    local _, mainCategory = AceConfigDialog:AddToBlizOptions(AddOnName, "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Modules", L['Modules'], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Changelog", L['Changelog'], "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_Profiles", 'Profiles', "XIV Bar Continued")
    AceConfigDialog:AddToBlizOptions(AddOnName .. "_ProfileSharing", 'Profile Sharing', "XIV Bar Continued")
    self.optionsCategory = mainCategory

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
                textColors = self:GetTextColorOptions(),
                showOnMouseover = {
                    name = L["Show on mouseover"],
                    desc = L["Show the bar only when the mouse is over it"],
                    type = "toggle",
                    order = 10,
                    get = function()
                        return self.db.profile.general.showOnMouseover
                    end,
                    set = function(_, val)
                        self.db.profile.general.showOnMouseover = val
                        SetBarMouseoverScripts()
                    end
                }
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

function XIVBar:CreateMainBar()
    if self.frames.bar == nil then
        local bar = CreateFrame("FRAME", "XIV_Databar", UIParent)
        self:RegisterFrame('bar', bar)
        self.frames.bgTexture = self.frames.bgTexture or bar:CreateTexture(nil, "BACKGROUND")
        
        -- Create guide lines
        local guides = CreateFrame("FRAME", nil, UIParent)
        guides:SetAllPoints()
        guides:Hide()
        
        -- Vertical center line
        local centerLine = guides:CreateTexture(nil, "OVERLAY")
        centerLine:SetColorTexture(1, 1, 1, 0.3)
        centerLine:SetWidth(2)
        centerLine:SetPoint("TOP", UIParent, "TOP", 0, 0)
        centerLine:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
        
        -- Horizontal center line
        local hCenterLine = guides:CreateTexture(nil, "OVERLAY")
        hCenterLine:SetColorTexture(1, 1, 1, 0.3)
        hCenterLine:SetHeight(2)
        hCenterLine:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
        hCenterLine:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)
        
        -- Edge markers
        local edgeMarkerSize = 40
        local edgeMarkerThickness = 2
        
        -- Top edge markers
        local topLeft = guides:CreateTexture(nil, "OVERLAY")
        topLeft:SetColorTexture(1, 1, 1, 0.3)
        topLeft:SetSize(edgeMarkerSize, edgeMarkerThickness)
        topLeft:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
        
        local topRight = guides:CreateTexture(nil, "OVERLAY")
        topRight:SetColorTexture(1, 1, 1, 0.3)
        topRight:SetSize(edgeMarkerSize, edgeMarkerThickness)
        topRight:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
        
        -- Bottom edge markers
        local bottomLeft = guides:CreateTexture(nil, "OVERLAY")
        bottomLeft:SetColorTexture(1, 1, 1, 0.3)
        bottomLeft:SetSize(edgeMarkerSize, edgeMarkerThickness)
        bottomLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
        
        local bottomRight = guides:CreateTexture(nil, "OVERLAY")
        bottomRight:SetColorTexture(1, 1, 1, 0.3)
        bottomRight:SetSize(edgeMarkerSize, edgeMarkerThickness)
        bottomRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        
        -- Vertical edge markers
        local leftTop = guides:CreateTexture(nil, "OVERLAY")
        leftTop:SetColorTexture(1, 1, 1, 0.3)
        leftTop:SetSize(edgeMarkerThickness, edgeMarkerSize)
        leftTop:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
        
        local leftBottom = guides:CreateTexture(nil, "OVERLAY")
        leftBottom:SetColorTexture(1, 1, 1, 0.3)
        leftBottom:SetSize(edgeMarkerThickness, edgeMarkerSize)
        leftBottom:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
        
        local rightTop = guides:CreateTexture(nil, "OVERLAY")
        rightTop:SetColorTexture(1, 1, 1, 0.3)
        rightTop:SetSize(edgeMarkerThickness, edgeMarkerSize)
        rightTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
        
        local rightBottom = guides:CreateTexture(nil, "OVERLAY")
        rightBottom:SetColorTexture(1, 1, 1, 0.3)
        rightBottom:SetSize(edgeMarkerThickness, edgeMarkerSize)
        rightBottom:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        
        self.frames.guides = guides
        
        -- Set initial frame level instead of strata
        bar:SetFrameLevel(1)
        
        -- Make the bar movable
        bar:SetMovable(true)
        bar:EnableMouse(true)
        bar:RegisterForDrag("LeftButton")
        
        -- Snap threshold in pixels
        local SNAP_THRESHOLD = 20

        -- Helper function to check if a value is within the snap threshold
        local function IsWithinThreshold(value, target, threshold)
            return math.abs(value - target) <= threshold
        end

        -- Helper function to get the center coordinates of the bar
        local function GetBarCenter(bar)
            local width, height = bar:GetSize()
            local x, y = bar:GetCenter()
            return x, y, width, height
        end

        -- Helper function to snap to nearest point if within threshold
        local function GetSnappedPosition(bar)
            local screenWidth, screenHeight = UIParent:GetWidth(), UIParent:GetHeight()
            local centerX, centerY, barWidth, barHeight = GetBarCenter(bar)
            local point = "CENTER"
            local xOffset, yOffset = 0, 0
            local snapped = false
            
            -- Check horizontal position
            if IsWithinThreshold(centerX, screenWidth/2, SNAP_THRESHOLD) then
                point = "CENTER"
                xOffset = 0
                snapped = true
            elseif IsWithinThreshold(centerX - barWidth/2, 0, SNAP_THRESHOLD) then
                point = "LEFT"
                xOffset = 0
                snapped = true
            elseif IsWithinThreshold(centerX + barWidth/2, screenWidth, SNAP_THRESHOLD) then
                point = "RIGHT"
                xOffset = 0
                snapped = true
            else
                point = "CENTER"
                xOffset = centerX - screenWidth/2
            end
            
            -- Check vertical position
            if IsWithinThreshold(centerY, 0, SNAP_THRESHOLD) then
                yOffset = 0
                point = "BOTTOM" .. (point ~= "CENTER" and point or "")
                snapped = true
            elseif IsWithinThreshold(centerY, screenHeight, SNAP_THRESHOLD) then
                yOffset = 0
                point = "TOP" .. (point ~= "CENTER" and point or "")
                snapped = true
            else
                yOffset = centerY - screenHeight/2
            end
            
            return point, point, xOffset, yOffset, snapped
        end
        
        bar:SetScript("OnDragStart", function(self)
            if not XIVBar.db.profile.general.locked and not XIVBar.db.profile.general.barFullscreen then
                self:StartMoving()
                XIVBar.frames.guides:Show()
            end
        end)

        bar:SetScript("OnDragStop", function(self)
            if not XIVBar.db.profile.general.barFullscreen then
                self:StopMovingOrSizing()
                XIVBar.frames.guides:Hide()
                
                -- Get final position with snapping
                local point, relativePoint, xOffset, yOffset = GetSnappedPosition(self)
                
                -- Save position
                XIVBar.db.profile.general.point = point
                XIVBar.db.profile.general.relativePoint = relativePoint
                XIVBar.db.profile.general.xOffset = xOffset
                XIVBar.db.profile.general.yOffset = yOffset
                
                -- Apply position
                self:ClearAllPoints()
                self:SetPoint(point, UIParent, relativePoint, xOffset, yOffset)
                
                XIVBar:Refresh()
            end
        end)
    end
end

function XIVBar:ResetUI()
    if UIParent_UpdateTopFramePositions then
        UIParent_UpdateTopFramePositions()
    end
end

function OffsetUI()
    local offset = XIVBar.frames.bar:GetHeight();
    local buffsAreaTopOffset = offset;

    BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -205,
                       0 - buffsAreaTopOffset);
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
    if self.optionsCategory then
        Settings.OpenToCategory(self.optionsCategory)
    else
        Settings.OpenToCategory("XIV Bar Continued")
    end
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
    local r, g, b, a = profile[name].r, profile[name].g, profile[name].b, profile[name].a
    
    if name == 'normal' and profile.useTextCC then
        r, g, b, _ = self:GetClassColors()
    elseif name == 'barColor' and profile.useCC then
        r, g, b, _ = self:GetClassColors()
    end

    return r, g, b, a
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

function XIVBar:HideBarEvent()
    local bar = self:GetFrame("bar")
    local vehiculeIsFlight = false;

    bar:UnregisterAllEvents()
    bar.OnEvent = nil
    bar:RegisterEvent("PET_BATTLE_OPENING_START")
    bar:RegisterEvent("PET_BATTLE_CLOSE")
    bar:RegisterEvent("TAXIMAP_CLOSED")
    bar:RegisterEvent("VEHICLE_POWER_SHOW")
    bar:RegisterEvent("PLAYER_ENTERING_WORLD")
    bar:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    bar:SetScript("OnEvent", function(_, event, ...)
        local barFrame = XIVBar:GetFrame("bar")
        
        -- Handle zone changes and instance transitions
        if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
            C_Timer.After(0.5, function()
                if not barFrame:IsVisible() then
                    barFrame:Show()
                end
                -- Full refresh of the bar and modules
                XIVBar:Refresh()
                -- Force update module positions
                if XIVBar.db.profile.general.barPosition == 'TOP' then
                    OffsetUI()
                else
                    XIVBar:ResetUI()
                end
            end)
            return
        end
        
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
                -- Refresh modules when showing after combat
                XIVBar:Refresh()
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
    if not InCombatLockdown() then
        self.frames.bar:ClearAllPoints()
    end
    
    -- Use saved position if not in fullscreen mode
    if not self.db.profile.general.barFullscreen then
        -- If we have a saved custom position, use it
        if self.db.profile.general.point then
            self.frames.bar:SetPoint(
                self.db.profile.general.point,
                UIParent,
                self.db.profile.general.relativePoint,
                self.db.profile.general.xOffset,
                self.db.profile.general.yOffset
            )
        else
            -- Initial position based on barHoriz and barPosition
            self.frames.bar:SetPoint(self.db.profile.general.barPosition, UIParent, self.db.profile.general.barPosition)
            if self.db.profile.general.barHoriz == 'LEFT' then
                self.frames.bar:SetPoint("LEFT", UIParent, "LEFT", self.db.profile.general.barMargin, 0)
            elseif self.db.profile.general.barHoriz == 'RIGHT' then
                self.frames.bar:SetPoint("RIGHT", UIParent, "RIGHT", -self.db.profile.general.barMargin, 0)
            else -- CENTER
                self.frames.bar:SetPoint(self.db.profile.general.barHoriz, UIParent, self.db.profile.general.barHoriz, 0, 0)
            end
        end
        self.frames.bar:SetWidth(self.db.profile.general.barWidth)
    else
        if not InCombatLockdown() then
            self.frames.bar:SetPoint(self.db.profile.general.barPosition)
            self.frames.bar:SetPoint("LEFT", self.db.profile.general.barMargin, 0)
            self.frames.bar:SetPoint("RIGHT", -self.db.profile.general.barMargin, 0)
        end
    end
    
    if not InCombatLockdown() then
        self.frames.bar:SetHeight(self:GetHeight())
        self.frames.bgTexture:SetColorTexture(self:GetColor('barColor'))
        self.frames.bgTexture:SetAllPoints()
    end

    for name, module in self:IterateModules() do
        if module['Refresh'] == nil then return; end
        module:Refresh()
    end

    SetBarMouseoverScripts()
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

SetBarMouseoverScripts = function()
    local bar = XIVBar.frames and XIVBar.frames.bar
    if not bar then return end

    local function IsMouseOverBar()
        return MouseIsOver(bar)
    end

    local function IsBarChild(frame)
        local parent = frame and frame:GetParent()
        while parent do
            if parent == bar then
                return true
            end
            parent = parent:GetParent()
        end
        return false
    end

    local function showBar()
        bar._xivHidePending = false
        if not bar._xivMouseoverEnabled then
            return
        end
        if bar._xivMouseoverVisible then
            return
        end
        bar._xivMouseoverVisible = true
        if UIFrameFadeIn then
            UIFrameFadeIn(bar, 0.15, bar:GetAlpha(), 1)
        else
            bar:SetAlpha(1)
        end
    end

    local function hideBarIfOut()
        -- Petit délai pour laisser le curseur passer d'un enfant à l'autre sans clignoter
        if bar._xivHidePending then return end
        bar._xivHidePending = true
        bar._xivHideToken = (bar._xivHideToken or 0) + 1
        local token = bar._xivHideToken
        C_Timer.After(0.12, function()
            bar._xivHidePending = false
            if token ~= bar._xivHideToken then
                return
            end
            if not bar._xivMouseoverEnabled then
                return
            end
            if not IsMouseOverBar() then
                bar._xivMouseoverVisible = false
                if UIFrameFadeOut then
                    UIFrameFadeOut(bar, 0.15, bar:GetAlpha(), 0)
                else
                    bar:SetAlpha(0)
                end
            end
        end)
    end

    if XIVBar.db and XIVBar.db.profile and XIVBar.db.profile.general.showOnMouseover then
        bar._xivMouseoverEnabled = true
        bar._xivMouseoverVisible = false
        bar._xivHidePending = false
        bar:SetAlpha(0)
        bar:SetScript('OnEnter', showBar)
        bar:SetScript('OnLeave', hideBarIfOut)
        bar:SetScript('OnUpdate', function(self, elapsed)
            self._xivMouseoverElapsed = (self._xivMouseoverElapsed or 0) + elapsed
            if self._xivMouseoverElapsed < 0.05 then return end
            self._xivMouseoverElapsed = 0
            if not bar._xivMouseoverEnabled then
                return
            end
            if IsMouseOverBar() then
                showBar()
            else
                hideBarIfOut()
            end
        end)
        -- Apply the same handlers to all registered module frames so the bar stays visible when hovering them
        if XIVBar.frames then
            for name, frame in pairs(XIVBar.frames) do
                if frame and frame ~= bar and frame.EnableMouse and frame.HookScript and IsBarChild(frame) then
                    frame:EnableMouse(true)
                    frame:HookScript('OnEnter', showBar)
                    frame:HookScript('OnLeave', hideBarIfOut)
                end
            end
        end
    else
        bar._xivMouseoverEnabled = false
        bar._xivHideToken = (bar._xivHideToken or 0) + 1
        if UIFrameFadeRemoveFrame then
            UIFrameFadeRemoveFrame(bar)
        end
        bar._xivHidePending = false
        bar:SetAlpha(1)
        bar:SetScript('OnEnter', nil)
        bar:SetScript('OnLeave', nil)
        bar:SetScript('OnUpdate', nil)
        bar._xivMouseoverElapsed = nil
        bar._xivMouseoverVisible = nil
        bar._xivHidePending = nil
    end
end

function XIVBar:GetGeneralOptions()
    return {
        name = GENERAL_LABEL,
        type = "group",
        inline = true,
        args = {
            positioning = self:GetPositioningOptions(),
            text = self:GetTextOptions(),
            textColors = self:GetTextColorOptions(),
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
                    SetBarMouseoverScripts()
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
