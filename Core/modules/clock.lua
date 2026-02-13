local AddOnName, XIVBar = ...;
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
    self.clockFrame:Hide()
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
    self:EnsureFrames()
    if self.clockFrame == nil then
        return;
    end
    if not db.modules.clock.enabled then
        self:Disable();
        return;
    end

    --[[ if InCombatLockdown() then
        self:SetClockColor()
        return
    end ]]

    self.clockText:SetFont(xb:GetFont(db.modules.clock.fontSize))
    local dateString = nil
    if xb.db.profile.modules.clock.serverTime then
        dateString = GetServerTimeString(xb.db.profile.modules.clock.timeFormat)
    else
        local clockTime = time()
        dateString = date(ClockModule.timeFormats[xb.db.profile.modules.clock.timeFormat], clockTime)
    end
    self.clockText:SetText(dateString)
    self:SetClockColor()

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

    self.eventText:SetFont(xb:GetFont(db.text.smallFontSize))
    self.eventText:ClearAllPoints()
    self.eventText:SetPoint('CENTER', self.clockText, xb.miniTextPosition)
    if xb.db.profile.modules.clock.hideEventText then
        self.eventText:Hide()
    else
        self.eventText:Show()
    end
end

function ClockModule:CreateFrames()
    self.clockTextFrame = self.clockTextFrame or CreateFrame("BUTTON", nil, self.clockFrame)
    self.clockText = self.clockText or self.clockTextFrame:CreateFontString(nil, "OVERLAY")
    self.eventText = self.eventText or self.clockTextFrame:CreateFontString(nil, "OVERLAY")
end

function ClockModule:RegisterFrameEvents()

    self.clockTextFrame:EnableMouse(true)
    self.clockTextFrame:RegisterForClicks("AnyUp")

    self.clockFrame:SetScript("OnUpdate", function(self, elapsed)
        ClockModule.elapsed = ClockModule.elapsed + elapsed
        if ClockModule.elapsed >= 1 then
            local dateString = nil
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
                    ClockModule.eventText:SetText(string.format("%s  (|cffffff00%i|r)", L['New Event!'], eventInvites))
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
        local clockTime = nil
        if xb.db.profile.modules.clock.serverTime then
            clockTime = time()
        else
            clockTime = GetServerTime()
        end

        local realmTime = GetServerTimeString(xb.db.profile.modules.clock.timeFormat)

        GameTooltip:AddDoubleLine(L['Local Time'],
            date(ClockModule.timeFormats[xb.db.profile.modules.clock.timeFormat], clockTime), r, g, b, 1, 1, 1)
        GameTooltip:AddDoubleLine(L['Realm Time'], realmTime, r, g, b, 1, 1, 1)
        GameTooltip:AddLine(" ")
        if ToggleCalendar and type(ToggleCalendar) == "function" then
            GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>', L['Open Calendar'], r, g, b, 1, 1, 1)
        end
        GameTooltip:AddDoubleLine('<' .. L['Right-Click'] .. '>', L['Open Clock'], r, g, b, 1, 1, 1)
        GameTooltip:Show()
    end)

    self.clockTextFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then
            return;
        end
        ClockModule:SetClockColor()
        GameTooltip:Hide()
    end)

    self.clockTextFrame:SetScript('OnClick', function(_, button)
        if InCombatLockdown() then
            return;
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
end

function ClockModule:SetClockColor()
    local db = xb.db.profile
    if self.clockTextFrame:IsMouseOver() then
        self.clockText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.clockText:SetTextColor(xb:GetColor('normal'))
    end
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
        hideEventText = false
    }
end

function ClockModule:GetConfig()
    local timeFormatOptions = self.exampleTimeFormats
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.clock.enabled;
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
                hidden = true
            },
            useServerTime = {
                name = L['Use Server Time'],
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
                name = L['Hide Event Text'],
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
                name = L['Time Format'],
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
            }
        }
    }
end
