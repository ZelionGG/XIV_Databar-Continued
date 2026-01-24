local AddOnName, XIVBar = ...
local xb = XIVBar
local L = xb.L

local VaultModule = xb:NewModule("VaultModule", "AceEvent-3.0")

function VaultModule:GetName()
    return VAULT or "Vault"
end

function VaultModule:ShowTooltip()
    if not xb.db.profile.modules.vault.showTooltip then return end
    GameTooltip:SetOwner(self.vaultFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:ClearLines()
    GameTooltip:AddLine(L['Vault'] or 'Vault')
    GameTooltip:AddLine(L['Great Vault info coming soon'] or 'Great Vault info coming soon', 1, 1, 1, true)
    GameTooltip:AddLine(L['Placeholder action: no click yet'] or 'Placeholder action: no click yet', 0.9, 0.9, 0.9, true)
    GameTooltip:Show()
end

function VaultModule:GetDefaultOptions()
    return 'vault', {
        enabled = true,
        showLabel = true,
        showTooltip = true,
    }
end

function VaultModule:OnInitialize()
    self.mediaFolder = xb.constants.mediaPath .. 'vault\\'
    self.iconPath = self.mediaFolder .. 'vault.tga'
end

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

function VaultModule:OnDisable()
    if self.vaultFrame then
        self.vaultFrame:Hide()
    end
end

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

function VaultModule:CreateFrames()
    self.vaultFrame = CreateFrame('BUTTON', nil, xb:GetFrame('bar'))
    xb:RegisterFrame('vaultFrame', self.vaultFrame)

    self.icon = self.vaultFrame:CreateTexture(nil, 'OVERLAY')
    self.text = self.vaultFrame:CreateFontString(nil, 'OVERLAY')
    self.text:SetJustifyH('LEFT')
end

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
        --if InCombatLockdown() then return end
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
