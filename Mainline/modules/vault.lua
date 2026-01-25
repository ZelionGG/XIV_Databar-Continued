local AddOnName, XIVBar = ...
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
        local diffName = activity.level and DifficultyUtil and DifficultyUtil.GetDifficultyName and DifficultyUtil.GetDifficultyName(activity.level)
        return diffName or (L['Unlocked'] or 'Unlocked')
    end

    if typeId == Enum.WeeklyRewardChestThresholdType.Activities then
        if activity.level and activity.level > 0 then
            return string.format('M+%d', activity.level)
        end
        return L['Heroic'] or 'Heroic'
    end

    if typeId == Enum.WeeklyRewardChestThresholdType.World then
        if activity.level and activity.level > 0 then
            return string.format('%s %d %s', L['Tier'] or 'Tier', activity.level, L['Delve'] or 'Delve')
        end
        return L['World activity'] or 'World activity'
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
    return VAULT or "Vault"
end

-- Render the Great Vault tooltip with compact rewards + M+ keystone line.
function VaultModule:ShowTooltip()
    if not xb.db.profile.modules.vault.showTooltip then return end

    local r, g, b, _ = unpack(xb:HoverColors())

    if C_AddOns and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
        C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
    end

    GameTooltip:SetOwner(self.vaultFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. (L['Vault'] or 'Vault') .. "|cFFFFFFFF]|r", r, g, b)
    GameTooltip:AddLine(" ")

    -- Refresh data if needed
    if C_WeeklyRewards and C_WeeklyRewards.RequestRewards then
        C_WeeklyRewards.RequestRewards()
    end

    local activitiesByType = CollectActivitiesByType()
    for _, typeId in ipairs(TYPE_ORDER) do
        local label = TYPE_LABELS[typeId]
        local activities = activitiesByType[typeId] or {}
        local summary = BuildSlotSummary(typeId, activities)
        GameTooltip:AddDoubleLine(label or ' ', summary or (L['None'] or 'None'), r, g, b, 1, 1, 1)
    end

    local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    if mapId and mapId > 0 and keystoneLevel and keystoneLevel > 0 then
        local mapName, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapId)
        local iconTexture = texture
        local icon = iconTexture and string.format(' |T%s:16|t', iconTexture) or ''
        local label = MYTHIC_PLUS_KEYSTONE or (L['Mythic+ Keystone'] or 'Mythic+ Keystone')
        local value = string.format('+%d %s%s', keystoneLevel, mapName or '', icon)
        GameTooltip:AddLine(' ')
        GameTooltip:AddDoubleLine(label, value, r, g, b, 1, 1, 1)
    end
    GameTooltip:Show()
end

-- Default configuration options for the module.
function VaultModule:GetDefaultOptions()
    return 'vault', {
        enabled = true,
        showLabel = true,
        showTooltip = true,
    }
end

-- Initialize module paths and resources.
function VaultModule:OnInitialize()
    self.mediaFolder = xb.constants.mediaPath .. 'vault\\'
    self.iconPath = self.mediaFolder .. 'vault.tga'
end

-- Enable module, build frames, and refresh layout.
function VaultModule:OnEnable()
    local db = xb.db.profile
    if not db.modules.vault.enabled then
        self:Disable()
        return
    end

    if not self.vaultFrame then
        self:CreateFrames()
    end

    self.vaultFrame:Show()
    self:RegisterFrameEvents()
    self:Refresh()
end

-- Disable module and hide its frame.
function VaultModule:OnDisable()
    if self.vaultFrame then
        self.vaultFrame:Hide()
    end
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
    self.vaultFrame:RegisterForClicks('AnyUp')

    self.vaultFrame:SetScript('OnEnter', function()
        self.icon:SetVertexColor(unpack(xb:HoverColors()))
        self.text:SetTextColor(unpack(xb:HoverColors()))
        self:ShowTooltip()
    end)

    self.vaultFrame:SetScript('OnLeave', function()
        self.icon:SetVertexColor(xb:GetColor('normal'))
        self.text:SetTextColor(xb:GetColor('normal'))
        GameTooltip:Hide()
    end)

    self.vaultFrame:SetScript('OnClick', function(_, button)
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

-- Apply settings to layout, size, and position.
function VaultModule:Refresh()
    if not self.vaultFrame then return end
    local db = xb.db.profile
    if not db.modules.vault.enabled then
        self:Disable()
        return
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    self.icon:SetTexture(self.iconPath)
    self.icon:SetSize(iconSize, iconSize)
    self.icon:SetPoint('LEFT')
    self.icon:SetVertexColor(xb:GetColor('normal'))

    self.text:SetFont(xb:GetFont(db.text.fontSize))
    self.text:SetTextColor(xb:GetColor('normal'))
    if db.modules.vault.showLabel then
        self.text:SetText(L['Vault'] or 'Vault')
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

    local anchor = getAnchorFrame()
    local spacing = db.general.moduleSpacing
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
            enable = {
                name = ENABLE,
                order = 0,
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
                name = L['Show label'] or 'Show label',
                order = 1,
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
                name = L['Show tooltip'] or 'Show tooltip',
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.vault.showTooltip
                end,
                set = function(_, val)
                    xb.db.profile.modules.vault.showTooltip = val
                    self:Refresh()
                end
            },
        }
    }
end
