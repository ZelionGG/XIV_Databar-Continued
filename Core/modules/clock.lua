---@class XIVBar
local XIVBar = select(2, ...);
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local ClockModule = xb:NewModule("ClockModule", 'AceEvent-3.0')

local function SnapToEvenPixel(value)
    local snapped = floor((value or 0) + 0.5)
    if snapped < 1 then
        snapped = 1
    end
    if snapped % 2 ~= 0 then
        snapped = snapped + 1
    end
    return snapped
end

function ClockModule:ApplyRestIconTexture()
    if not self.restIcon or not self.restIconFrame then return end
    local mode = xb.db.profile.modules.clock.restIconTextureMode or "default"
    local custom = xb.db.profile.modules.clock.restIconCustomTexture
    local size = xb.db.profile.modules.clock.restIconSize or 24
    local useCustomColor = xb.db.profile.modules.clock.restIconUseCustomColor
    local useClassColor = xb.db.profile.modules.clock.restIconUseClassColor
    local color = xb.db.profile.modules.clock.restIconColor or { r = 1, g = 1, b = 1, a = 1 }
    local elvuiRestIcons = nil
    ---@diagnostic disable-next-line: undefined-field
    if _G.ElvUI and _G.ElvUI[1] and _G.ElvUI[1].Media and _G.ElvUI[1].Media.RestIcons then
        ---@diagnostic disable-next-line: undefined-field
        elvuiRestIcons = _G.ElvUI[1].Media.RestIcons
    end

    if mode == "custom" and custom and custom:match("%S") then
        self.restIcon:SetTexture(custom)
        self.restIcon:SetTexCoord(0, 1, 0, 1)
        self.restIcon:SetSize(size, size)
    elseif elvuiRestIcons and elvuiRestIcons[mode] then
        self.restIcon:SetTexture(elvuiRestIcons[mode])
        self.restIcon:SetTexCoord(0, 1, 0, 1)
        self.restIcon:SetSize(size, size)
    else
        -- default: atlas modern then fallback classic texture
        if self.restIcon.SetAtlas and self.restIcon:SetAtlas("UI-HUD-UnitFrame-PlayerPortrait-Rest") then
            self.restIcon:SetSize(size, size)
            self.restIcon:SetTexCoord(0, 1, 0, 1)
        else
            self.restIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
            self.restIcon:SetTexCoord(0, 0.5, 0, 0.421875)
            self.restIcon:SetSize(size, size)
        end
    end

    if useCustomColor then
        local r, g, b = color.r or 1, color.g or 1, color.b or 1
        if useClassColor then
            r, g, b = xb:GetClassColors()
        end
        self.restIcon:SetVertexColor(r, g, b, color.a or 1)
        if self.restIcon.SetDesaturated then
            self.restIcon:SetDesaturated(true)
        end
    else
        self.restIcon:SetVertexColor(1, 1, 1, 1)
        if self.restIcon.SetDesaturated then
            self.restIcon:SetDesaturated(false)
        end
    end

    self.restIconFrame:SetSize(self.restIcon:GetWidth(), self.restIcon:GetHeight())
end

local function GetServerTimeString(optFormat)
    local hour, minute = GetGameTime()
    local constructedServerTime = time({
        year = 1970,
        month = 1,
        day = 2,
        hour = hour,
        min = minute,
        sec = 0
    })
    return date(ClockModule.timeFormats[optFormat], constructedServerTime)
end

function ClockModule:OnLeaveCombat()
    if self.needsResize then
        self.needsResize = false
        self:Refresh()
    end
end

function ClockModule:GetName()
    return TIMEMANAGER_TITLE;
end

function ClockModule:OnInitialize()
    if IsWindowsClient() then
        self.timeFormats = {
            twelveAmPm = '%I:%M %p',
            twelveNoAm = '%I:%M',
            twelveAmNoZero = '%#I:%M %p',
            twelveNoAmNoZero = '%#I:%M',
            twoFour = '%H:%M',
            twoFourNoZero = '%#H:%M'
        }
    else
        self.timeFormats = {
            twelveAmPm = '%I:%M %p',
            twelveNoAm = '%I:%M',
            twelveAmNoZero = '%l:%M %p',
            twelveNoAmNoZero = '%l:%M',
            twoFour = '%R',
            twoFourNoZero = '%k:%M'
        }
    end

    self.exampleTimeFormats = {
        twelveAmPm = '08:00 AM (12 Hour)',
        twelveNoAm = '08:00 (12 Hour)',
        twelveAmNoZero = '8:00 AM (12 Hour)',
        twelveNoAmNoZero = '8:00 (12 Hour)',
        twoFour = '08:00 (24 Hour)',
        twoFourNoZero = '8:00 (24 Hour)'
    }

    self.elapsed = 0

    self.functions = {}
end

function ClockModule:OnEnable()
    if self.clockFrame == nil then
        self.clockFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('clockFrame', self.clockFrame)
    end
    self.clockFrame:Show()
    self.elapsed = 0
    self.needsResize = false
    self:CreateFrames()
    self:CreateClickFunctions()
    self:RegisterFrameEvents()
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnLeaveCombat")
    self:Refresh()
end

function ClockModule:OnDisable()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:UnregisterEvent("PLAYER_UPDATE_RESTING")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    if self.clockFrame then
        self.clockFrame:SetScript("OnUpdate", nil)
        self.clockFrame:Hide()
    end
end

function ClockModule:EnsureFrames()
    if self.framesInitialized then return end
    if self.clockFrame == nil then
        self.clockFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('clockFrame', self.clockFrame)
    end
    self.clockFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self.framesInitialized = true
end

function ClockModule:Refresh()
    local db = xb.db.profile

    if not xb:IsFreePlacementEnabled() and db.modules.clock.enabled ~= true then
        db.modules.clock.enabled = true
    end

    if not db.modules.clock.enabled then
        self:Disable()
        return
    end

    self:EnsureFrames()
    if self.clockFrame == nil then
        return;
    end

    self.clockText:SetFont(xb:GetFont(xb.db.profile.modules.clock.fontSize))
    local dateString
    if xb.db.profile.modules.clock.serverTime then
        dateString = GetServerTimeString(xb.db.profile.modules.clock.timeFormat)
    else
        local clockTime = time()
        dateString = date(ClockModule.timeFormats[xb.db.profile.modules.clock.timeFormat], clockTime)
    end
    self.clockText:SetText(dateString)
    self:SetClockColor()
    self:ApplyRestIconTexture()
    self:UpdateResting()

    if InCombatLockdown() then
        self.needsResize = true
        return
    end

    local clockTextWidth = SnapToEvenPixel(self.clockText:GetStringWidth())
    local clockTextHeight = floor((self.clockText:GetStringHeight() or 0) + 0.5)
    if clockTextHeight < 1 then
        clockTextHeight = 1
    end

    self.clockFrame:SetSize(clockTextWidth, clockTextHeight)
    self.clockFrame:ClearAllPoints()
    self.clockFrame:SetPoint('CENTER')

    self.clockTextFrame:SetSize(clockTextWidth, clockTextHeight)
    self.clockTextFrame:ClearAllPoints()
    self.clockTextFrame:SetPoint('CENTER')

    self.clockText:ClearAllPoints()
    self.clockText:SetPoint('CENTER')

    if self.restIconFrame then
        self.restIconFrame:SetFrameStrata(self.clockFrame:GetFrameStrata())
        self.restIconFrame:SetFrameLevel((self.clockTextFrame:GetFrameLevel() or self.clockFrame:GetFrameLevel()) + 20)
        self.restIconFrame:ClearAllPoints()
        local pos = xb.db.profile.modules.clock.restIconPosition or 'TOPRIGHT'
        local xOff = xb.db.profile.modules.clock.restIconXOffset or 0
        local yOff = xb.db.profile.modules.clock.restIconYOffset or 0
        self.restIconFrame:SetPoint(pos, self.clockFrame, pos, xOff, yOff)
    end

    self.eventText:SetFont(xb:GetFont(xb.db.profile.text.smallFontSize))
    self.eventText:ClearAllPoints()
    self.eventText:SetPoint('CENTER', self.clockText, xb.miniTextPosition)
    if xb.db.profile.modules.clock.hideEventText then
        self.eventText:Hide()
    else
        self.eventText:Show()
    end

    xb:ApplyModuleFreePlacement('clock', self.clockFrame)
end

function ClockModule:CreateFrames()
    self.clockTextFrame = self.clockTextFrame or CreateFrame("BUTTON", nil, self.clockFrame)
    self.clockText = self.clockText or self.clockTextFrame:CreateFontString(nil, "OVERLAY")
    self.eventText = self.eventText or self.clockTextFrame:CreateFontString(nil, "OVERLAY")
    self.restIconFrame = self.restIconFrame or CreateFrame("Frame", nil, self.clockFrame)
    if not self.restIcon then
        self.restIcon = self.restIconFrame:CreateTexture(nil, "OVERLAY")
        self.restIcon:SetDrawLayer("OVERLAY", 7)
        self.restIcon:ClearAllPoints()
        self.restIcon:SetPoint("CENTER")
    end
    self:ApplyRestIconTexture()
end

function ClockModule:RegisterFrameEvents()

    self.clockTextFrame:EnableMouse(true)
    self.clockTextFrame:RegisterForClicks("AnyUp")

    self.clockFrame:SetScript("OnUpdate", function(_, elapsed)
        ClockModule.elapsed = ClockModule.elapsed + elapsed
        if ClockModule.elapsed >= 1 then
            local dateString
            if xb.db.profile.modules.clock.serverTime then
                dateString = GetServerTimeString(xb.db.profile.modules.clock.timeFormat)
            else
                local clockTime = time()
                dateString = date(ClockModule.timeFormats[xb.db.profile.modules.clock.timeFormat], clockTime)
            end
            ClockModule.clockText:SetText(dateString)

            if not xb.db.profile.modules.clock.hideEventText and C_Calendar and C_Calendar.GetNumPendingInvites then
                local eventInvites = C_Calendar.GetNumPendingInvites()
                if eventInvites > 0 then
                    ClockModule.eventText:SetText(string.format("%s  (|cffffff00%i|r)", L["NEW_EVENT"], eventInvites))
                end
            end

            ClockModule:Refresh()
            ClockModule.elapsed = 0
        end
    end)

    self.clockTextFrame:SetScript('OnEnter', function()
        --[[ if InCombatLockdown() then
            return;
        end ]]
        ClockModule:SetClockColor()
        GameTooltip:SetOwner(ClockModule.clockTextFrame, 'ANCHOR_' .. xb.miniTextPosition, 0, 3)
        -- GameTooltip:SetPoint(xb.db.profile.general.barPosition, self.clockTextFrame, xb.miniTextPosition, 0, 1)
        local r, g, b, _ = unpack(xb:HoverColors())
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. TIMEMANAGER_TITLE .. "|cFFFFFFFF]|r", r, g, b)
        GameTooltip:AddLine(" ")
        local clockTime
        if xb.db.profile.modules.clock.serverTime then
            clockTime = time()
        else
            clockTime = GetServerTime()
        end

        local realmTime = GetServerTimeString(xb.db.profile.modules.clock.timeFormat)

        GameTooltip:AddDoubleLine(L["LOCAL_TIME"],
            date(ClockModule.timeFormats[xb.db.profile.modules.clock.timeFormat], clockTime), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L["REALM_TIME"], realmTime, r, g, b, 1, 1, 1)
        GameTooltip:AddLine(" ")
        if ToggleCalendar and type(ToggleCalendar) == "function" then
            GameTooltip:AddDoubleLine('<' .. L["LEFT_CLICK"] .. '>', L["OPEN_CALENDAR"], r, g, b, 1, 1, 1)
        end
        GameTooltip:AddDoubleLine('<' .. L["RIGHT_CLICK"] .. '>', L["OPEN_CLOCK"], r, g, b, 1, 1, 1)
        GameTooltip:Show()
    end)

    self.clockTextFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return
        end
        ClockModule:SetClockColor()
        GameTooltip:Hide()
    end)

    self.clockTextFrame:SetScript('OnClick', function(_, button)
        if InCombatLockdown() then
            return
        end
        if button == 'LeftButton' then
            if ToggleCalendar and type(ToggleCalendar) == "function" then
                ToggleCalendar()
            end
        elseif button == 'RightButton' then
            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                ToggleTimeManager()
            else
                ToggleFrame(_G.TimeManagerFrame)
            end
        end
    end)

    self:RegisterEvent("PLAYER_UPDATE_RESTING", "OnRestingUpdate")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnRestingUpdate")
end

function ClockModule:SetClockColor()
    if self.clockTextFrame:IsMouseOver() then
        self.clockText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.clockText:SetTextColor(xb:GetColor('normal'))
    end
end

function ClockModule:UpdateResting()
    if not self.restIcon or not self.restIconFrame then return end
    if not xb.db.profile.modules.clock.showRestIcon then
        self.restIconFrame:Hide()
        return
    end

    if xb.db.profile.modules.clock.hideRestIconMaxLevel then
        local playerLevel = UnitLevel and UnitLevel("player") or 0
        local maxLevel = nil
        if GetMaxLevelForPlayerExpansion then
            maxLevel = GetMaxLevelForPlayerExpansion()
        elseif GetMaxPlayerLevel then
            maxLevel = GetMaxPlayerLevel()
        end
        if maxLevel and playerLevel >= maxLevel then
            self.restIconFrame:Hide()
            return
        end
    end

    if IsResting and IsResting() then
        self.restIconFrame:Show()
    else
        self.restIconFrame:Hide()
    end
end

function ClockModule:OnRestingUpdate()
    self:UpdateResting()
end

function ClockModule:UnregisterFrameEvents()
end

function ClockModule:CreateClickFunctions()
end

function ClockModule:GetDefaultOptions()
    return 'clock', {
        enabled = true,
        timeFormat = 'twelveAmPm',
        fontSize = 20,
        serverTime = false,
        hideEventText = false,
        showRestIcon = true,
        restIconTextureMode = "default",
        restIconCustomTexture = nil,
        hideRestIconMaxLevel = false,
        restIconSize = 20,
        restIconXOffset = 17,
        restIconYOffset = 10,
        restIconPosition = "TOPRIGHT",
        restIconUseCustomColor = false,
        restIconUseClassColor = false,
        restIconColor = { r = 1, g = 1, b = 1, a = 1 }
    }
end

function ClockModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.enabled
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full",
                disabled = function()
                    return not xb:IsFreePlacementEnabled()
                end,
            },
            useServerTime = {
                name = L["USE_SERVER_TIME"],
                order = 1,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.serverTime;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.serverTime = val;
                end
            },
            hideEventText = {
                name = L["HIDE_EVENT_TEXT"],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.hideEventText;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.hideEventText = val;
                end
            },
            timeFormat = {
                name = L["TIME_FORMAT"],
                order = 3,
                type = "select",
                values = { -- TODO: WTF is with this not accepting a variable?
                    twelveAmPm = '08:00 AM (12 Hour)',
                    twelveNoAm = '08:00 (12 Hour)',
                    twelveAmNoZero = '8:00 AM (12 Hour)',
                    twelveNoAmNoZero = '8:00 (12 Hour)',
                    twoFour = '08:00 (24 Hour)',
                    twoFourNoZero = '8:00 (24 Hour)'
                },
                style = "dropdown",
                get = function()
                    return xb.db.profile.modules.clock.timeFormat;
                end,
                set = function(info, val)
                    xb.db.profile.modules.clock.timeFormat = val;
                    self:Refresh();
                end
            },
            fontSize = {
                name = FONT_SIZE,
                type = 'range',
                order = 4,
                min = 10,
                max = 40,
                step = 1,
                get = function()
                    return xb.db.profile.modules.clock.fontSize;
                end,
                set = function(info, val)
                    xb.db.profile.modules.clock.fontSize = val;
                    self:Refresh();
                end
            },
            restIconHeader = {
                name = L["REST_ICON"],
                order = 5,
                type = "header"
            },
            showRestIcon = {
                name = L["SHOW_REST_ICON"],
                order = 6,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.showRestIcon;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.showRestIcon = val;
                    self:UpdateResting();
                    self:Refresh();
                end,
            },
            hideRestIconMaxLevel = {
                name = L["HIDE_REST_ICON_MAX_LEVEL"],
                order = 7,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.hideRestIconMaxLevel;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.hideRestIconMaxLevel = val;
                    self:UpdateResting();
                    self:Refresh();
                end,
            },
            restIconSize = {
                name = L["TEXTURE_SIZE"],
                order = 8,
                type = 'range',
                min = 10,
                max = 64,
                step = 1,
                get = function()
                    return xb.db.profile.modules.clock.restIconSize;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconSize = val;
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end,
            },
            restIconPosition = {
                name = L["POSITION"],
                order = 9,
                type = "select",
                values = {
                    TOPLEFT = "TOPLEFT", TOP = "TOP", TOPRIGHT = "TOPRIGHT",
                    LEFT = "LEFT", CENTER = "CENTER", RIGHT = "RIGHT",
                    BOTTOMLEFT = "BOTTOMLEFT", BOTTOM = "BOTTOM", BOTTOMRIGHT = "BOTTOMRIGHT"
                },
                get = function()
                    return xb.db.profile.modules.clock.restIconPosition;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconPosition = val;
                    self:Refresh();
                end,
            },
            restIconXOffset = {
                name = L["X_OFFSET"],
                order = 10,
                type = 'range',
                min = -100,
                max = 100,
                step = 1,
                get = function()
                    return xb.db.profile.modules.clock.restIconXOffset;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconXOffset = val;
                    self:Refresh();
                end,
                width = "double"
            },
            restIconYOffset = {
                name = L["Y_OFFSET"],
                order = 11,
                type = 'range',
                min = -100,
                max = 100,
                step = 1,
                get = function()
                    return xb.db.profile.modules.clock.restIconYOffset;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconYOffset = val;
                    self:Refresh();
                end,
                width = "double"
            },
            restIconUseCustomColor = {
                name = L["CUSTOM_TEXTURE_COLOR"],
                order = 12,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.restIconUseCustomColor;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconUseCustomColor = val;
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end,
                width = "full"
            },
            restIconUseClassColor = {
                name = L["USE_CLASS_COLORS"],
                order = 13,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.restIconUseClassColor;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconUseClassColor = val;
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end,
                hidden = function()
                    return not xb.db.profile.modules.clock.restIconUseCustomColor
                end,
            },
            restIconColor = {
                name = L["COLOR"],
                order = 14,
                type = "color",
                hasAlpha = true,
                get = function()
                    local c = xb.db.profile.modules.clock.restIconColor
                    if xb.db.profile.modules.clock.restIconUseClassColor then
                        local r, g, b = xb:GetClassColors()
                        return r, g, b, c.a
                    end
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    local current = xb.db.profile.modules.clock.restIconColor or { r = 1, g = 1, b = 1, a = 1 }
                    if xb.db.profile.modules.clock.restIconUseClassColor then
                        xb.db.profile.modules.clock.restIconColor = { r = current.r, g = current.g, b = current.b, a = a }
                    else
                        xb.db.profile.modules.clock.restIconColor = { r = r, g = g, b = b, a = a }
                    end
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end,
                hidden = function()
                    return not xb.db.profile.modules.clock.restIconUseCustomColor
                end,
            },
            restIconTextureMode = {
                name = L["TEXTURE"],
                order = 15,
                type = "select",
                values = function()
                    local values = {
                        default = L["DEFAULT"],
                        custom = L["CUSTOM"]
                    }
                    local elvui = _G.ElvUI and _G.ElvUI[1]
                    local icons = elvui and elvui.Media and elvui.Media.RestIcons
                    if icons then
                        for key, tex in pairs(icons) do
                            if tex and elvui and elvui.TextureString then
                                values[key] = elvui:TextureString(tex, ':14:14')
                            else
                                values[key] = tex or key
                            end
                        end
                    end
                    return values
                end,
                sorting = function()
                    local sorting = { "default", "custom" }
                    local elvui = _G.ElvUI and _G.ElvUI[1]
                    local icons = elvui and elvui.Media and elvui.Media.RestIcons
                    if icons then
                        for key in pairs(icons) do
                            if key ~= "default" and key ~= "custom" then
                                sorting[#sorting + 1] = key
                            end
                        end
                    end
                    return sorting
                end,
                get = function()
                    return xb.db.profile.modules.clock.restIconTextureMode;
                end,
                set = function(_, val)
                    xb.db.profile.modules.clock.restIconTextureMode = val;
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end
            },
            restIconCustomTexture = {
                name = L["CUSTOM_TEXTURE"],
                order = 16,
                type = "input",
                get = function()
                    return xb.db.profile.modules.clock.restIconCustomTexture;
                end,
                set = function(_, val)
                    local trimmed = (val and val:match("%S")) and val or nil
                    xb.db.profile.modules.clock.restIconCustomTexture = trimmed;
                    self:ApplyRestIconTexture();
                    self:Refresh();
                end,
                hidden = function()
                    return xb.db.profile.modules.clock.restIconTextureMode ~= "custom";
                end
            },
        }
    }
end
