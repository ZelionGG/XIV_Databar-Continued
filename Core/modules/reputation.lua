local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local FACTION_BAR_COLORS  = FACTION_BAR_COLORS

local GetWatchedFactionInfo = GetWatchedFactionInfo

local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData

local ReputationModule = xb:NewModule("ReputationModule", 'AceEvent-3.0',
                                      'AceHook-3.0')

function ReputationModule:GetName() return REPUTATION; end

function ReputationModule:OnInitialize()
    self.curButtons = {}
    self.curIcons = {}
    self.curText = {}
end

function ReputationModule:OnEnable()
    if self.reputationFrame == nil then
        self.reputationFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('reputationFrame', self.reputationFrame)
    end

    self.reputationFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function ReputationModule:OnDisable()
    self.reputationFrame:Hide()
    self:UnregisterEvent('UPDATE_FACTION', 'Refresh')
    self:UnregisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED', 'Refresh')
    self:UnregisterEvent('MAJOR_FACTION_UNLOCKED', 'Refresh')
end

function ReputationModule:Refresh()
    local db = xb.db.profile
    local name, reaction, minValue, maxValue, curValue, factionID =
        GetWatchedFactionInfo()

    if string.len(name) > 20 then
        name = string.sub(name, 1, 20) .. "..."
    end

    if factionID and C_Reputation_IsFactionParagon(factionID) then
        local current, threshold, _, rewardPending = C_Reputation_GetFactionParagonInfo(factionID)

        if current and threshold then
            local _, minVal, maxVal, curVal, reactVal = L["Paragon"], 0, threshold, current % threshold, 9
            reaction, minValue, maxValue, curValue = reactVal, minVal, maxVal, curVal
        end
    end

    if factionID and C_Reputation_IsMajorFaction(factionID) then
		local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)

		reaction, minValue, maxValue = 10, 0, majorFactionData.renownLevelThreshold
	end

    if InCombatLockdown() then
        self.reputationBar:SetMinMaxValues(minValue, maxValue)
        self.reputationBar:SetValue(curValue)
        self.reputationText:SetText(string.upper(name))
        return
    end
    if self.reputationFrame == nil then return; end
    if not db.modules.reputation.enabled or not GetWatchedFactionInfo() then
        self:Disable();
        return;
    end

    local iconSize = db.text.fontSize + db.general.barPadding
    for i = 1, 3 do self.curButtons[i]:Hide() end
    self.reputationBarFrame:Hide()

    local textHeight = floor((xb:GetHeight() - 4) / 2)
    local barHeight = (iconSize - textHeight - 2)
    if barHeight < 2 then barHeight = 2 end
    self.reputationIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\seal')
    self.reputationIcon:SetSize(iconSize, iconSize)
    self.reputationIcon:SetPoint('LEFT')
    self.reputationIcon:SetVertexColor(xb:GetColor('normal'))

    self.reputationText:SetFont(xb:GetFont(textHeight))
    self.reputationText:SetTextColor(xb:GetColor('normal'))
    self.reputationText:SetText(string.upper(name))
    self.reputationText:SetPoint('TOPLEFT', self.reputationIcon, 'TOPRIGHT', 5,
                                 0)

    local color = FACTION_BAR_COLORS[reaction] or {r=1,g=0,b=1}
    print(color)
    self.reputationBar:SetStatusBarTexture("Interface/BUTTONS/WHITE8X8")
    if db.modules.reputation.reputationBarClassCC then
        local rPerc, gPerc, bPerc, argbHex = xb:GetClassColors()
        self.reputationBar:SetStatusBarColor(rPerc, gPerc, bPerc, 1)
    elseif db.modules.reputation.reputationBarReputationCC then
        self.reputationBar:SetStatusBarColor(color.r or 1, color.g or 1, color.b or 1, 1)
    else
        self.reputationBar:SetStatusBarColor(xb:GetColor('normal'))
    end

    print(name .. " " .. minValue .. " " .. curValue .. " " .. maxValue)
    self.reputationBar:SetMinMaxValues(minValue, maxValue)
    self.reputationBar:SetValue(curValue)
    self.reputationBar:SetSize(self.reputationText:GetStringWidth(), barHeight)
    self.reputationBar:SetPoint('BOTTOMLEFT', self.reputationIcon,
                                'BOTTOMRIGHT', 5, 0)

    self.reputationBarBg:SetAllPoints()
    self.reputationBarBg:SetColorTexture(db.color.inactive.r,
                                         db.color.inactive.g,
                                         db.color.inactive.b,
                                         db.color.inactive.a)
    self.reputationFrame:SetSize(
        iconSize + self.reputationText:GetStringWidth() + 5, xb:GetHeight())
    self.reputationBarFrame:SetAllPoints()
    self.reputationBarFrame:Show()

    -- self.reputationFrame:SetSize(self.goldButton:GetSize())
    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    local anchorFrame = xb:GetFrame('tradeskillFrame')
    -- For some reason anchorFrame can happen to be nil, in this case, skip this until value gets different from nil
    if anchorFrame ~= nil and not anchorFrame:IsVisible() then
        if xb:GetFrame('clockFrame') and xb:GetFrame('clockFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('clockFrame')
        elseif xb:GetFrame('talentFrame') and
            xb:GetFrame('talentFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('talentFrame')
        else
            relativeAnchorPoint = 'LEFT'
            xOffset = 0
        end
    end
    self.reputationFrame:SetPoint('LEFT', anchorFrame, relativeAnchorPoint,
                                  xOffset, 0)
end

function ReputationModule:CreateFrames()
    for i = 1, 3 do
        self.curButtons[i] = self.curButtons[i] or
                                 CreateFrame("BUTTON", nil, self.reputationFrame)
        self.curIcons[i] = self.curIcons[i] or
                               self.curButtons[i]:CreateTexture(nil, 'OVERLAY')
        self.curText[i] = self.curText[i] or
                              self.curButtons[i]:CreateFontString(nil, "OVERLAY")
        self.curButtons[i]:Hide()
    end

    self.reputationBarFrame = self.reputationBarFrame or CreateFrame("BUTTON", nil, self.reputationFrame)
    self.reputationIcon = self.reputationIcon or
                              self.reputationBarFrame:CreateTexture(nil, 'OVERLAY')
    self.reputationText = self.reputationText or
                              self.reputationBarFrame:CreateFontString(nil, 'OVERLAY')
    self.reputationBar = self.reputationBar or
                             CreateFrame('STATUSBAR', nil, self.reputationBarFrame)
    self.reputationBarBg = self.reputationBarBg or
                               self.reputationBar:CreateTexture(nil,
                                                                'BACKGROUND')
    self.reputationBarFrame:Hide()
end

function ReputationModule:RegisterFrameEvents()

    for i = 1, 3 do
        self.curButtons[i]:EnableMouse(true)
        self.curButtons[i]:RegisterForClicks("AnyUp")
        self.curButtons[i]:SetScript('OnEnter', function()
            if InCombatLockdown() then return; end
            self.curText[i]:SetTextColor(unpack(xb:HoverColors()))
            if xb.db.profile.modules.reputation.showTooltip then
                self:ShowTooltip()
            end
        end)
        self.curButtons[i]:SetScript('OnLeave', function()
            if InCombatLockdown() then return; end
            local db = xb.db.profile
            self.curText[i]:SetTextColor(xb:GetColor('normal'))
            if db.modules.reputation.showTooltip then
                GameTooltip:Hide()
            end
        end)
        self.curButtons[i]:SetScript('OnClick', function()
            if InCombatLockdown() then return; end
            ToggleCharacter('TokenFrame')
        end)
    end
    self:RegisterEvent('UPDATE_FACTION', 'Refresh')
    self:RegisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED', 'Refresh')
    self:RegisterEvent('MAJOR_FACTION_UNLOCKED', 'Refresh')
    -- self:SecureHook('BackpackTokenFrame_Update', 'Refresh') -- Ugh, why is there no event for this?

    self.reputationFrame:EnableMouse(true)
    self.reputationFrame:SetScript('OnEnter', function()
        if xb.db.profile.modules.reputation.showTooltip then
            self:ShowTooltip()
        end
    end)
    self.reputationFrame:SetScript('OnLeave', function()
        if xb.db.profile.modules.reputation.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self.reputationBarFrame:SetScript('OnEnter', function()
        if InCombatLockdown() then return; end
        self.reputationText:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.reputation.showTooltip then
            self:ShowTooltip()
        end
    end)

    self.reputationBarFrame:SetScript('OnLeave', function()
        if InCombatLockdown() then return; end
        local db = xb.db.profile
        self.reputationText:SetTextColor(xb:GetColor('normal'))
        if xb.db.profile.modules.reputation.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'tradeskillFrame' then self:Refresh() end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'tradeskillFrame' then self:Refresh() end
    end)
end

function ReputationModule:ShowTooltip()
    if not xb.db.profile.modules.reputation.showTooltip then return end

    local r, g, b, _ = unpack(xb:HoverColors())

    GameTooltip:SetOwner(self.reputationFrame, 'ANCHOR_' .. xb.miniTextPosition)

    if xb.constants.playerLevel < MAX_PLAYER_LEVEL and
        xb.db.profile.modules.reputation.showXPbar then
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. POWER_TYPE_EXPERIENCE ..
                                "|cFFFFFFFF]|r", r, g, b)
        GameTooltip:AddLine(" ")

        local curXp = UnitXP('player')
        local maxXp = UnitXPMax('player')
        local rested = GetXPExhaustion()
        -- XP
        GameTooltip:AddDoubleLine(XP .. ':', string.format('%d / %d (%d%%)',
                                                           curXp, maxXp, floor(
                                                               (curXp / maxXp) *
                                                                   100)), r, g,
                                  b, 1, 1, 1)
        -- Remaining
        GameTooltip:AddDoubleLine(L['Remaining'] .. ':',
                                  string.format('%d (%d%%)', (maxXp - curXp),
                                                floor(
                                                    ((maxXp - curXp) / maxXp) *
                                                        100)), r, g, b, 1, 1, 1)
        -- Rested
        if rested then
            GameTooltip:AddDoubleLine(L['Rested'] .. ':', string.format(
                                          '+%d (%d%%)', rested,
                                          floor((rested / maxXp) * 100)), r, g,
                                      b, 1, 1, 1)
        end
    else
        GameTooltip:AddLine("|cFFFFFFFF[|r" .. CURRENCY .. "|cFFFFFFFF]|r", r,
                            g, b)
        GameTooltip:AddLine(" ")

        for i = 1, 3 do
            if xb.db.profile.modules.reputation[self.intToOpt[i]] ~= '0' then
                local curId = tonumber(
                                  xb.db.profile.modules.reputation[self.intToOpt[i]])
                local curInfo = C_CurrencyInfo.GetCurrencyInfo(curId)
                GameTooltip:AddDoubleLine(curInfo.name, string.format('%d/%d',
                                                                      curInfo.quantity,
                                                                      curInfo.maxQuantity),
                                          r, g, b, 1, 1, 1)
            end
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>',
                                  BINDING_NAME_TOGGLECURRENCY, r, g, b, 1, 1, 1)
    end

    GameTooltip:Show()
end

function ReputationModule:GetDefaultOptions()
    return 'reputation',
           {enabled = false, reputationBarClassCC = false, showTooltip = true}
end

function ReputationModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.reputation.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.reputation.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            reputationBarClassCC = {
                name = L['Use Class Colors for Reputation Bar'],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.reputation.reputationBarClassCC;
                end,
                set = function(_, val)
                    xb.db.profile.modules.reputation.reputationBarClassCC = val;
                    self:Refresh();
                end,
            },
            reputationBarReputationCC = {
                name = L['Use Reputation Colors for Reputation Bar'],
                order = 3,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.reputation.reputationBarReputationCC;
                end,
                set = function(_, val)
                    xb.db.profile.modules.reputation.reputationBarReputationCC = val;
                    self:Refresh();
                end,
            },
            showTooltip = {
                name = L['Show Tooltips'],
                order = 4,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.reputation.showTooltip;
                end,
                set = function(_, val)
                    xb.db.profile.modules.reputation.showTooltip = val;
                    self:Refresh();
                end
            }
        }
    }
end
