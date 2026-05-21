---@class XIVBar
local XIVBar = select(2, ...)
local xb = XIVBar
local L = xb.L

local VaultModule = xb:NewModule("VaultModule", "AceEvent-3.0")

local TYPE_LABELS = {
    [Enum.WeeklyRewardChestThresholdType.Raid] = WEEKLY_REWARDS_CATEGORY_RAID or RAIDS,
    [Enum.WeeklyRewardChestThresholdType.Activities] = WEEKLY_REWARDS_CATEGORY_DUNGEON or WEEKLY_REWARDS_CATEGORY_DUNGEONS or DUNGEONS,
    [Enum.WeeklyRewardChestThresholdType.World] = WEEKLY_REWARDS_CATEGORY_WORLD or WORLD,
}

local TYPE_ORDER = {
    Enum.WeeklyRewardChestThresholdType.Raid,
    Enum.WeeklyRewardChestThresholdType.Activities,
    Enum.WeeklyRewardChestThresholdType.World,
}

local DEFAULT_WARNING_COLOR = {
    r = 1,
    g = 0.82,
    b = 0,
    a = 1,
}

local DEFAULT_FLASH_INTERVAL = 0.75
local FLASH_UPDATE_INTERVAL = 0.05
local FLASH_CYCLE_RADIANS = math.pi * 2

local function GetVaultModuleDb()
    return xb.db.profile.modules.vault
end

local function IsRewardAlertEnabled()
    return GetVaultModuleDb().rewardAlertEnabled ~= false
end

local function GetWarningColor()
    local warningColor = GetVaultModuleDb().warningColor or DEFAULT_WARNING_COLOR
    return warningColor.r or DEFAULT_WARNING_COLOR.r,
        warningColor.g or DEFAULT_WARNING_COLOR.g,
        warningColor.b or DEFAULT_WARNING_COLOR.b,
        warningColor.a or DEFAULT_WARNING_COLOR.a
end

local function GetWarningColorRgb()
    local red, green, blue = GetWarningColor()
    return red, green, blue
end

local function GetBaseColor(isHover)
    if isHover then
        return unpack(xb:HoverColors())
    end

    return xb:GetColor('normal')
end

local function HasPendingVaultRewardWarning()
    if not IsRewardAlertEnabled() then
        return false
    end

    if not C_WeeklyRewards or not C_WeeklyRewards.HasAvailableRewards or not C_WeeklyRewards.IsWeeklyChestRetired then
        return false
    end

    if C_WeeklyRewards.IsWeeklyChestRetired() then
        return false
    end

    return C_WeeklyRewards.HasAvailableRewards() == true
end

local function GetPendingVaultRewardMessage()
    if not HasPendingVaultRewardWarning() then
        return nil
    end

    if C_WeeklyRewards and C_WeeklyRewards.CanClaimRewards and C_WeeklyRewards.CanClaimRewards() then
        return WEEKLY_REWARDS_CHOOSE_REWARD or DELVES_GREAT_VAULT_LABEL
    end

    return WEEKLY_REWARDS_RETURN_TO_CLAIM or WEEKLY_REWARDS_CHOOSE_REWARD or DELVES_GREAT_VAULT_LABEL
end

local function GetFlashInterval()
    local interval = GetVaultModuleDb().warningFlashInterval
    if type(interval) ~= 'number' or interval <= 0 then
        return DEFAULT_FLASH_INTERVAL
    end
    return interval
end

local function GetSnoozeDurationSeconds()
    local minutes = GetVaultModuleDb().warningFlashSnoozeMinutes or 0
    return math.max(0, minutes) * 60
end

local function FormatRemainingSnooze(seconds)
    seconds = math.max(0, math.ceil(seconds or 0))
    local minutes = math.floor(seconds / 60)
    local remainder = seconds % 60

    if minutes > 0 and remainder > 0 then
        return string.format('%dm %02ds', minutes, remainder)
    end

    if minutes > 0 then
        return string.format('%dm', minutes)
    end

    return string.format('%ds', remainder)
end

local function ShouldShowSnoozeChatMessage()
    return GetVaultModuleDb().showSnoozeChatMessage ~= false
end


local function IsWarningFlashEnabled()
    local db = GetVaultModuleDb()
    return IsRewardAlertEnabled() and db.warningFlashEnabled
end

local function LerpColor(fromRed, fromGreen, fromBlue, fromAlpha, toRed, toGreen, toBlue, toAlpha, progress)
    return fromRed + (toRed - fromRed) * progress,
        fromGreen + (toGreen - fromGreen) * progress,
        fromBlue + (toBlue - fromBlue) * progress,
        fromAlpha + (toAlpha - fromAlpha) * progress
end

-- Enable module, build frames, and refresh layout.
function VaultModule:OnEnable()
    local db = xb.db.profile
    if not db.modules.vault.enabled or UnitLevel("player") ~= GetMaxLevelForPlayerExpansion() then
        self:Disable()
        return
    end

    if not self.vaultFrame then
        self:CreateFrames()
    end

    self.vaultFrame:Show()
    self:RegisterFrameEvents()
    self:RegisterEvent('WEEKLY_REWARDS_UPDATE', 'Refresh')
    self:Refresh()
end

-- Disable module and hide its frame.
function VaultModule:OnDisable()
    self:UnregisterEvent('WEEKLY_REWARDS_UPDATE')
    self:StopFlashTicker()
    self.isMouseOverVault = false
    if self.vaultFrame then
        self.vaultFrame:Hide()
    end
end

-- Collect weekly reward activities grouped by type, sorted by slot index.
local function CollectActivitiesByType()
    local byType = {}
    if not C_WeeklyRewards or not C_WeeklyRewards.GetActivities then
        return byType
    end
    local activities = C_WeeklyRewards.GetActivities()
    if not activities then return byType end

    for _, activity in ipairs(activities) do
        byType[activity.type] = byType[activity.type] or {}
        table.insert(byType[activity.type], activity)
    end

    for _, list in pairs(byType) do
        table.sort(list, function(a, b)
            return (a.index or 0) < (b.index or 0)
        end)
    end

    return byType
end

-- Check if a vault activity slot is unlocked (progress >= threshold).
local function IsActivityUnlocked(activity)
    local progress = activity and activity.progress or 0
    local threshold = activity and activity.threshold or 0
    return threshold > 0 and progress >= threshold
end

-- Find the activity entry for a given slot index.
local function GetActivityByIndex(activities, index)
    for _, activity in ipairs(activities) do
        if activity.index == index then
            return activity
        end
    end
end

-- Format a slot display value for the compact tooltip summary.
local function FormatSlotValue(typeId, activity)
    if not IsActivityUnlocked(activity) then
        local progress = activity and activity.progress or 0
        local threshold = activity and activity.threshold or 0
        if threshold > 0 then
            return string.format('%d/%d', progress, threshold)
        end
        return '-'
    end

    if typeId == Enum.WeeklyRewardChestThresholdType.Raid then
        local diffName = activity.level and DifficultyUtil.GetDifficultyName(activity.level)
        return diffName
    end

    if typeId == Enum.WeeklyRewardChestThresholdType.Activities then
        if activity and activity.level ~= nil then
            if activity.level >= 0 then
                return string.format(WEEKLY_REWARDS_MYTHIC, activity.level)
            end
        end
        return WEEKLY_REWARDS_HEROIC
    end

    if typeId == Enum.WeeklyRewardChestThresholdType.World then
        if activity.level and activity.level > 0 then
            return string.format(GREAT_VAULT_WORLD_TIER, activity.level)
        end
    end

    return '-'
end

-- Build the 3-slot summary string (slot1/slot2/slot3) for a category.
local function BuildSlotSummary(typeId, activities)
    local values = {}
    for index = 1, 3 do
        local activity = GetActivityByIndex(activities, index)
        local value = FormatSlotValue(typeId, activity)
        if IsActivityUnlocked(activity) then
            value = GREEN_FONT_COLOR_CODE .. value .. FONT_COLOR_CODE_CLOSE
        end
        values[index] = value
    end
    return table.concat(values, ' | ')
end

-- Module display name.
function VaultModule:GetName()
    return DELVES_GREAT_VAULT_LABEL
end

function VaultModule:IsWarningFlashSnoozed()
    return self.warningFlashSnoozeUntil ~= nil and self.warningFlashSnoozeUntil > GetTime()
end


function VaultModule:ShouldFlashWarning()
    return HasPendingVaultRewardWarning()
    and IsWarningFlashEnabled()
        and not self:IsWarningFlashSnoozed()
        and self.vaultFrame
        and self.vaultFrame:IsShown()
end

function VaultModule:StopFlashTicker()
    if self.warningFlashTicker then
        self.warningFlashTicker:Cancel()
        self.warningFlashTicker = nil
    end
    self.warningFlashTickerInterval = nil
    self.warningFlashStartTime = nil
    self.warningFlashBlend = 1
end

function VaultModule:UpdateFlashTicker()
    if not self:ShouldFlashWarning() then
        self:StopFlashTicker()
        return
    end

    local interval = GetFlashInterval()
    if self.warningFlashTicker and self.warningFlashTickerInterval == interval then
        return
    end

    self:StopFlashTicker()
    self.warningFlashTickerInterval = interval
    self.warningFlashStartTime = GetTime()
    self.warningFlashBlend = 1
    self.warningFlashTicker = C_Timer.NewTicker(FLASH_UPDATE_INTERVAL, function()
        if not self:ShouldFlashWarning() then
            self:StopFlashTicker()
            self:ApplyVisualState(self.isMouseOverVault)
            return
        end

        local elapsed = GetTime() - self.warningFlashStartTime
        local cycleDuration = interval * 2
        local cycleProgress = (elapsed % cycleDuration) / cycleDuration
        self.warningFlashBlend = 0.5 + 0.5 * math.cos(cycleProgress * FLASH_CYCLE_RADIANS)
        self:ApplyVisualState(self.isMouseOverVault)
    end)
end

function VaultModule:SnoozeWarningFlash()
    if not IsWarningFlashEnabled() then
        return
    end

    local snoozeSeconds = GetSnoozeDurationSeconds()
    if snoozeSeconds <= 0 then
        return
    end

    local snoozeUntil = GetTime() + snoozeSeconds
    self.warningFlashSnoozeUntil = snoozeUntil
    self:UpdateFlashTicker()
    if ShouldShowSnoozeChatMessage() then
        local message = L["VAULT_SNOOZE_CHAT_MESSAGE"]
        local prefix = xb:CreateColorString('XIV Databar Continued:', { r = 0, g = 1, b = 0 })
        local duration = xb:CreateColorString(FormatRemainingSnooze(snoozeSeconds), { r = 0.4, g = 0.6, b = 1.0 })
        print(prefix .. ' ' .. string.format(message, duration))
    end
    if not self.isMouseOverVault then
        self:ApplyVisualState(false)
    end

    C_Timer.After(snoozeSeconds, function()
        if self.warningFlashSnoozeUntil == snoozeUntil then
            self.warningFlashSnoozeUntil = nil
            self:UpdateFlashTicker()
            if not self.isMouseOverVault then
                self:ApplyVisualState(false)
            end
        end
    end)
end

function VaultModule:ApplyVisualState(isHover)
    if HasPendingVaultRewardWarning() then
        if self.warningFlashTicker then
            local normalRed, normalGreen, normalBlue, normalAlpha = GetBaseColor(isHover)
            local warningRed, warningGreen, warningBlue, warningAlpha = GetWarningColor()
            local blend = self.warningFlashBlend or 1
            local red, green, blue, alpha = LerpColor(normalRed, normalGreen, normalBlue, normalAlpha,
                warningRed, warningGreen, warningBlue, warningAlpha, blend)
            self.icon:SetVertexColor(red, green, blue, alpha)
            self.text:SetTextColor(red, green, blue, alpha)
            return
        end

        self.icon:SetVertexColor(GetWarningColor())
        self.text:SetTextColor(GetWarningColor())
        return
    end

    if isHover then
        self.icon:SetVertexColor(unpack(xb:HoverColors()))
        self.text:SetTextColor(unpack(xb:HoverColors()))
        return
    end

    self.icon:SetVertexColor(xb:GetColor('normal'))
    self.text:SetTextColor(xb:GetColor('normal'))
end

-- Render the Great Vault tooltip with compact rewards + M+ keystone line.
function VaultModule:ShowTooltip()
    if not xb.db.profile.modules.vault.showTooltip then return end
    if not xb:ShouldShowTooltip() then
        GameTooltip:Hide()
        return
    end

    local r, g, b, _ = unpack(xb:HoverColors())

    GameTooltip:SetOwner(self.vaultFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. DELVES_GREAT_VAULT_LABEL .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")

    -- If the Great Vault is not disabled, show the tooltip with progress
    if(not C_WeeklyRewards.IsWeeklyChestRetired()) then
        local pendingMessage = GetPendingVaultRewardMessage()
        if pendingMessage then
            GameTooltip:AddLine('|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16:16:0:0|t ' .. pendingMessage,
                GetWarningColorRgb())
            if IsWarningFlashEnabled() then
                local snoozeLabel = L["VAULT_SNOOZE_FLASH"]
                GameTooltip:AddDoubleLine('<' .. L["RIGHT_CLICK"] .. '>', snoozeLabel, r, g, b, 1, 1, 1)
            end
            GameTooltip:AddLine(' ')
        end

        local activitiesByType = CollectActivitiesByType()
        for _, typeId in ipairs(TYPE_ORDER) do
            local label = TYPE_LABELS[typeId]
            local activities = activitiesByType[typeId] or {}
            local summary = BuildSlotSummary(typeId, activities)
            GameTooltip:AddDoubleLine(label or ' ', summary or L["None"], r, g, b, 1, 1, 1)
        end

        local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
        if mapId and mapId > 0 and keystoneLevel and keystoneLevel > 0 then
            local mapName, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapId)
            local iconTexture = texture
            local icon = iconTexture and string.format(' |T%s:16|t', iconTexture) or ''
            local label = WEEKLY_REWARDS_MYTHIC_KEYSTONE
            local value = string.format('+%d %s%s', keystoneLevel, mapName or '', icon)
            GameTooltip:AddLine(' ')
            GameTooltip:AddDoubleLine(label, value, r, g, b, 1, 1, 1)
        end
    else
        GameTooltip:AddLine(L["GREAT_VAULT_DISABLED"], 1, 1, 1)
    end
    GameTooltip:Show()
end

-- Default configuration options for the module.
function VaultModule:GetDefaultOptions()
    return 'vault', {
        enabled = true,
        showLabel = true,
        showTooltip = true,
        rewardAlertEnabled = true,
        showSnoozeChatMessage = true,
        warningColor = {
            r = DEFAULT_WARNING_COLOR.r,
            g = DEFAULT_WARNING_COLOR.g,
            b = DEFAULT_WARNING_COLOR.b,
            a = DEFAULT_WARNING_COLOR.a,
        },
        warningFlashEnabled = true,
        warningFlashInterval = DEFAULT_FLASH_INTERVAL,
        warningFlashSnoozeMinutes = 30,
    }
end

-- Initialize module paths and resources.
function VaultModule:OnInitialize()
    self.mediaFolder = xb.constants.mediaPath .. 'vault\\'
    self.iconPath = self.mediaFolder .. 'vault.tga'
    local moduleDb = GetVaultModuleDb()
    if moduleDb.rewardAlertEnabled == nil then
        moduleDb.rewardAlertEnabled = true
    end
    if moduleDb.showSnoozeChatMessage == nil then
        moduleDb.showSnoozeChatMessage = true
    end
    self.warningFlashBlend = 1
    self.warningFlashSnoozeUntil = nil
    self.warningFlashTicker = nil
    self.warningFlashTickerInterval = nil
    self.warningFlashStartTime = nil
    self.isMouseOverVault = false
end

-- Pick the anchor frame used to position the vault module.
local function getAnchorFrame()
    local order = {
        'talentFrame',
        'clockFrame',
        'tradeskillFrame',
        'currencyFrame',
    }
    for _, name in ipairs(order) do
        local frame = xb:GetFrame(name)
        if frame and frame:IsShown() then
            return frame
        end
    end
    return xb:GetFrame('bar')
end

-- Create frame widgets for the module.
function VaultModule:CreateFrames()
    self.vaultFrame = CreateFrame('BUTTON', nil, xb:GetFrame('bar'))
    xb:RegisterFrame('vaultFrame', self.vaultFrame)

    self.icon = self.vaultFrame:CreateTexture(nil, 'OVERLAY')
    self.text = self.vaultFrame:CreateFontString(nil, 'OVERLAY')
    self.text:SetJustifyH('LEFT')
end

-- Register mouse handlers and click behavior.
function VaultModule:RegisterFrameEvents()
    self.vaultFrame:EnableMouse(true)
    self.vaultFrame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

    self.vaultFrame:SetScript('OnEnter', function()
        self.isMouseOverVault = true
        self:ApplyVisualState(true)
        self:ShowTooltip()
    end)

    self.vaultFrame:SetScript('OnLeave', function()
        self.isMouseOverVault = false
        self:ApplyVisualState(false)
        GameTooltip:Hide()
    end)

    if(not C_WeeklyRewards.IsWeeklyChestRetired()) then
        self.vaultFrame:SetScript('OnClick', function(_, button)
            if button == 'RightButton' then
                self:SnoozeWarningFlash()
                if self.isMouseOverVault then
                    self:ShowTooltip()
                end
                return
            end

            if not WeeklyRewardsFrame or not WeeklyRewardsFrame:IsShown() then
                if not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
                    C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
                end
            end
            if WeeklyRewardsFrame then
                if WeeklyRewardsFrame:IsShown() then
                    WeeklyRewardsFrame:Hide()
                else
                    WeeklyRewardsFrame:Show()
                end
            end
        end)
    end
end

-- Apply settings to layout, size, and position.
function VaultModule:Refresh()
    if not self.vaultFrame then return end
    local db = xb.db.profile
    if not db.modules.vault.enabled then
        self:StopFlashTicker()
        self:Disable()
        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    self.icon:SetTexture(self.iconPath)
    self.icon:SetSize(iconSize, iconSize)
    self.icon:SetPoint('LEFT')

    self.text:SetFont(xb:GetFont(db.text.fontSize))
    if db.modules.vault.showLabel then
        self.text:SetText(DELVES_GREAT_VAULT_LABEL)
        self.text:Show()
    else
        self.text:SetText('')
        self.text:Hide()
    end

    local width = iconSize
    if db.modules.vault.showLabel then
        width = width + 5 + self.text:GetStringWidth()
    end

    self.vaultFrame:SetSize(width, xb:GetHeight())
    self.text:SetPoint('LEFT', self.icon, 'RIGHT', 5, 0)
    self:UpdateFlashTicker()
    self:ApplyVisualState(false)

    if xb:ApplyModuleFreePlacement('vault', self.vaultFrame) then
        return
    end

    local anchor = getAnchorFrame()
    local spacing = db.general.moduleSpacing - 5
    if anchor and anchor ~= xb:GetFrame('bar') then
        self.vaultFrame:ClearAllPoints()
        self.vaultFrame:SetPoint('RIGHT', anchor, 'LEFT', -spacing, 0)
    else
        self.vaultFrame:ClearAllPoints()
        self.vaultFrame:SetPoint('LEFT', xb:GetFrame('bar'), 'LEFT', spacing, 0)
    end
end

-- Return AceConfig options for the module.
function VaultModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            maxLevelDisclaimer = {
                name = "|TInterface\\EncounterJournal\\UI-EJ-WarningTextIcon:16:16:0:0|t |cffffd200" .. L["MAX_LEVEL_DISCLAIMER"] .. "|r",
                order = 0,
                type = "description",
                fontSize = "large",
                width = "full",
                hidden = function()
                    return UnitLevel("player") == GetMaxLevelForPlayerExpansion()
                end
            },
            enable = {
                name = ENABLE,
                order = 1,
                type = "toggle",
                width = "full",
                get = function()
                    return xb.db.profile.modules.vault.enabled
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end
            },
            showLabel = {
                name = L["SHOW_BUTTON_TEXT"],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.vault.showLabel
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.showLabel = val
                    self:Refresh()
                end
            },
            showTooltip = {
                name = L["SHOW_TOOLTIPS"],
                order = 3,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.vault.showTooltip
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.showTooltip = val
                    self:Refresh()
                end
            },
            rewardAlertHeader = {
                order = 4,
                name = L["VAULT_REWARD_ALERTS"],
                type = 'header'
            },
            rewardAlertEnabled = {
                name = L["VAULT_ENABLE_REWARD_ALERT"],
                order = 5,
                type = 'toggle',
                width = '1.2',
                get = function()
                    return IsRewardAlertEnabled()
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.rewardAlertEnabled = val
                    self:Refresh()
                end,
            },
            warningColor = {
                name = L["VAULT_ALERT_COLOR"],
                order = 6,
                type = 'color',
                hasAlpha = true,
                width = '1.2',
                disabled = function()
                    return not IsRewardAlertEnabled()
                end,
                get = function()
                    return GetWarningColor()
                end,
                set = function(_, red, green, blue, alpha)
                    xb.db.profile.modules.vault.warningColor = {
                        r = red,
                        g = green,
                        b = blue,
                        a = alpha,
                    }
                    self:Refresh()
                end,
            },
            warningFlashEnabled = {
                name = L["VAULT_FLASH_ALERT"],
                order = 7,
                type = 'toggle',
                width = 'full',
                disabled = function()
                    return not IsRewardAlertEnabled()
                end,
                get = function()
                    return xb.db.profile.modules.vault.warningFlashEnabled
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.warningFlashEnabled = val
                    self:Refresh()
                end,
            },
            warningFlashInterval = {
                name = L["VAULT_FLASH_INTERVAL"],
                order = 8,
                type = 'range',
                min = 0.25,
                max = 2,
                step = 0.05,
                width = 'full',
                disabled = function()
                    return not IsWarningFlashEnabled()
                end,
                get = function()
                    return GetFlashInterval()
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.warningFlashInterval = val
                    self:Refresh()
                end,
            },
            warningFlashSnoozeMinutes = {
                name = L["VAULT_SNOOZE_MINUTES"],
                order = 9,
                type = 'range',
                min = 1,
                max = 180,
                step = 1,
                width = 'full',
                disabled = function()
                    return not IsWarningFlashEnabled()
                end,
                get = function()
                    return xb.db.profile.modules.vault.warningFlashSnoozeMinutes
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.warningFlashSnoozeMinutes = val
                end,
            },
            showSnoozeChatMessage = {
                name = L["VAULT_SNOOZE_CHAT"],
                order = 10,
                type = 'toggle',
                width = 'full',
                disabled = function()
                    return not IsWarningFlashEnabled()
                end,
                get = function()
                    return ShouldShowSnoozeChatMessage()
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.showSnoozeChatMessage = val
                end,
            },
        }
    }
end
