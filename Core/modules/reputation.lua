local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;
local compat = xb.compat or {}
local huge = math.huge

local FACTION_BAR_COLORS  = FACTION_BAR_COLORS
local RANK_LABEL = rawget(_G, "RANK") or "Rank"

local LegacyGetWatchedFactionInfo = rawget(_G, "GetWatchedFactionInfo")
local C_Reputation_GetWatchedFactionData = C_Reputation.GetWatchedFactionData

local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_IsFactionParagonForCurrentPlayer = C_Reputation.IsFactionParagonForCurrentPlayer
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction
local C_GossipInfo_GetFriendshipReputation = C_GossipInfo and C_GossipInfo.GetFriendshipReputation

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData

local function GetReactionLabel(reaction)
    if type(reaction) ~= "number" then
        return tostring(reaction or "?")
    end

    return _G["FACTION_STANDING_LABEL" .. reaction] or
               _G["FACTION_STANDING_LABEL" .. reaction .. "_FEMALE"] or
               tostring(reaction)
end

local function OpenReputationPanel()
    if _G.ReputationFrame and _G.ToggleCharacter then
        _G.ToggleCharacter('ReputationFrame')
    elseif _G.ToggleCharacter then
        _G.ToggleCharacter('TokenFrame')
    end
end

local function IsFactionParagonCompat(factionID)
    if not factionID then
        return false
    end

    if C_Reputation_IsFactionParagonForCurrentPlayer then
        return C_Reputation_IsFactionParagonForCurrentPlayer(factionID)
    end

    if C_Reputation_IsFactionParagon then
        return C_Reputation_IsFactionParagon(factionID)
    end

    return false
end

local function GetProgressValues(currentStanding, minValue, maxValue)
    local minThreshold = type(minValue) == "number" and minValue or 0
    local maxThreshold = type(maxValue) == "number" and maxValue or minThreshold + 1
    local current = type(currentStanding) == "number" and currentStanding or minThreshold

    local progressCurrent = current - minThreshold
    local progressMax = maxThreshold - minThreshold

    if progressMax < 0 then
        progressMax = progressCurrent
    end

    if progressMax <= 0 then
        local normalized = progressCurrent > 0 and progressCurrent or 1
        return normalized, normalized, 100, true
    end

    local percent = floor((progressCurrent / progressMax) * 100)
    if percent < 0 then
        percent = 0
    elseif percent > 100 then
        percent = 100
    end

    return progressCurrent, progressMax, percent, progressCurrent >= progressMax
end

local function GetWatchedFactionInfoCompat()
    if LegacyGetWatchedFactionInfo then
        return LegacyGetWatchedFactionInfo()
    end

    if C_Reputation_GetWatchedFactionData then
        local data = C_Reputation_GetWatchedFactionData()
        if data then
            return data.name, data.reaction, data.currentReactionThreshold,
                   data.nextReactionThreshold, data.currentStanding,
                   data.factionID
        end
    end

    return nil
end

local function GetWatchedReputationDisplayData()
    local name, reaction, minValue, maxValue, curValue, factionID =
        GetWatchedFactionInfoCompat()
    if not name then
        return nil
    end

    local data = {
        name = name,
        reaction = reaction,
        minValue = minValue,
        maxValue = maxValue,
        curValue = curValue,
        factionID = factionID,
        rankText = GetReactionLabel(reaction),
        kind = "normal",
        paragonRewardAvailable = false,
        hasBonusRepGain = false
    }

    if factionID and C_Reputation_IsMajorFaction and C_Reputation_IsMajorFaction(factionID) then
        local majorFactionData = C_MajorFactions_GetMajorFactionData and
                                     C_MajorFactions_GetMajorFactionData(factionID)
        if majorFactionData and type(majorFactionData.renownLevelThreshold) == "number" and
            majorFactionData.renownLevelThreshold > 0 then
            data.kind = "major"
            data.rankText = string.format("Renown %d", majorFactionData.renownLevel or 0)
            data.reaction = 10
            data.minValue = 0
            data.maxValue = majorFactionData.renownLevelThreshold
            data.curValue = majorFactionData.renownReputationEarned or 0
            data.hasBonusRepGain = majorFactionData.hasBonusRepGain and true or false
        end
    end

    if data.kind == "normal" and factionID and C_GossipInfo_GetFriendshipReputation then
        local friendID, friendMinRep, friendRep, friendMaxRep, friendTextLevel
        local friendshipInfo, legacyFriendRep, legacyFriendMaxRep, _, _, _,
            legacyFriendTextLevel = C_GossipInfo_GetFriendshipReputation(factionID)

        if type(friendshipInfo) == "table" then
            friendID = friendshipInfo.friendshipFactionID
            friendMinRep = friendshipInfo.reactionThreshold or 0
            friendRep = friendshipInfo.standing
            friendMaxRep = friendshipInfo.nextThreshold or huge
            friendTextLevel = friendshipInfo.reaction
        else
            friendID = friendshipInfo
            friendMinRep = 0
            friendRep = legacyFriendRep
            friendMaxRep = legacyFriendMaxRep
            friendTextLevel = legacyFriendTextLevel
        end

        local isValidFriendID = type(friendID) == "number" and friendID > 0
        local hasFriendRankText = type(friendTextLevel) == "string" and
                                    friendTextLevel ~= ""
        if isValidFriendID and type(friendRep) == "number" and
            type(friendMaxRep) == "number" and friendMaxRep > 0 then
            data.kind = "friendship"
            data.friendRankText = hasFriendRankText and friendTextLevel or nil
            if hasFriendRankText then
                data.rankText = friendTextLevel
            end
            data.minValue = friendMinRep
            data.maxValue = friendMaxRep
            data.curValue = friendRep
        end
    end

    if data.kind == "friendship" and data.maxValue == huge then
        data.minValue = 0
        data.maxValue = type(data.curValue) == "number" and
                            math.max(data.curValue, 1) or 1
    end

    if (data.kind == "normal" or data.kind == "friendship" or data.kind == "major") and factionID and
        IsFactionParagonCompat(factionID) then
        local paragonCurrent, paragonThreshold, _, rewardPending =
            C_Reputation_GetFactionParagonInfo(factionID)
        local isRewardPending = rewardPending == true or rewardPending == 1
        local wasMajorFaction = data.kind == "major"
        local isNormalBarCapped = type(data.curValue) == "number" and
                                      type(data.maxValue) == "number" and
                                      data.curValue >= data.maxValue
        local hasParagonProgress = type(paragonCurrent) == "number" and
                                       paragonCurrent > 0
        if type(paragonCurrent) == "number" and type(paragonThreshold) == "number" and
            paragonThreshold > 0 and (isNormalBarCapped or hasParagonProgress or isRewardPending) then
            data.kind = "paragon"
            data.paragonRewardAvailable = isRewardPending
            local paragonLabel = L["Paragon"] or "Paragon"
            if type(data.friendRankText) == "string" and data.friendRankText ~= "" then
                data.rankText = string.format("%s (%s)", data.friendRankText,
                                              paragonLabel)
            elseif type(data.rankText) == "string" and data.rankText ~= "" and
                wasMajorFaction then
                data.rankText = string.format("%s (%s)", data.rankText,
                                              paragonLabel)
            else
                data.rankText = paragonLabel
            end
            data.reaction = 9
            data.minValue = 0
            data.maxValue = paragonThreshold
            data.curValue = paragonCurrent % paragonThreshold
        end
    end

    if data.kind == "normal" and type(data.minValue) == "number" and
        type(data.maxValue) == "number" and type(data.curValue) == "number" then
        local normalizedMax = data.maxValue - data.minValue
        local normalizedCur = data.curValue - data.minValue
        if normalizedMax > 0 then
            data.minValue = 0
            data.maxValue = normalizedMax
            data.curValue = normalizedCur
        end
    end

    if type(data.minValue) ~= "number" then
        data.minValue = 0
    end
    if type(data.maxValue) ~= "number" or data.maxValue <= data.minValue then
        data.maxValue = data.minValue + 1
    end
    if type(data.curValue) ~= "number" then
        data.curValue = data.minValue
    end
    if data.curValue < data.minValue then
        data.curValue = data.minValue
    elseif data.curValue > data.maxValue then
        data.curValue = data.maxValue
    end

    data.progressCurrent, data.progressMax, data.progressPercent, data.progressCapped =
        GetProgressValues(data.curValue, data.minValue, data.maxValue)

    return data
end

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
    self:SetParagonRewardFlash(false)
    self.reputationFrame:Hide()
    self:UnregisterEvent('UPDATE_FACTION', 'Refresh')
    self:UnregisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED', 'Refresh')
    self:UnregisterEvent('MAJOR_FACTION_UNLOCKED', 'Refresh')
    self:UnregisterEvent('CURRENCY_DISPLAY_UPDATE', 'Refresh')
    self:UnregisterEvent('QUEST_TURNED_IN', 'Refresh')
end

function ReputationModule:SetParagonRewardFlash(enabled)
    if not self.reputationBarFrame then
        return
    end

    if not self.reputationFlashAnim then
        local anim = self.reputationBarFrame:CreateAnimationGroup()
        local fadeOut = anim:CreateAnimation('Alpha')
        fadeOut:SetFromAlpha(1)
        fadeOut:SetToAlpha(0.10)
        fadeOut:SetDuration(0.5)
        fadeOut:SetOrder(1)

        local fadeIn = anim:CreateAnimation('Alpha')
        fadeIn:SetFromAlpha(0.10)
        fadeIn:SetToAlpha(1)
        fadeIn:SetDuration(0.5)
        fadeIn:SetOrder(2)

        anim:SetLooping('REPEAT')
        self.reputationFlashAnim = anim
    end

    if enabled then
        if not self.reputationFlashAnim:IsPlaying() then
            self.reputationFlashAnim:Play()
        end
    else
        if self.reputationFlashAnim:IsPlaying() then
            self.reputationFlashAnim:Stop()
        end
        self.reputationBarFrame:SetAlpha(1)
    end
end

function ReputationModule:Refresh()
    local db = xb.db.profile
    if not db.modules.reputation.enabled then
        self:Disable();
        return;
    end

    local watchedData = GetWatchedReputationDisplayData()

    if not watchedData then
        if self.reputationBarFrame then
            self.reputationBarFrame:Hide()
        end
        if self.reputationFrame then
            self.reputationFrame:Hide()
        end
        if self.reputationRewardCheck then
            self.reputationRewardCheck:Hide()
        end
        self:SetParagonRewardFlash(false)
        return;
    end

    local reputationKind = watchedData.kind
    local name = watchedData.name
    local reaction = watchedData.reaction
    local minValue = watchedData.minValue
    local maxValue = watchedData.maxValue
    local curValue = watchedData.curValue
    local paragonRewardAvailable = watchedData.paragonRewardAvailable
    local shouldFlashParagonReward = db.modules.reputation.flashParagonReward and
                                         paragonRewardAvailable

    if self.reputationFrame and not self.reputationFrame:IsShown() then
        self.reputationFrame:Show()
    end

    if string.len(name) > 20 then
        name = string.sub(name, 1, 20) .. "..."
    end

    if InCombatLockdown() then
        self.reputationBar:SetMinMaxValues(minValue, maxValue)
        self.reputationBar:SetValue(curValue)
        self.reputationText:SetText(string.upper(name))
        if self.reputationRewardCheck then
            self.reputationRewardCheck:Hide()
        end
        self:SetParagonRewardFlash(shouldFlashParagonReward)
        return
    end
    if self.reputationFrame == nil then return; end

    local iconSize = db.text.fontSize + db.general.barPadding
    for i = 1, 3 do self.curButtons[i]:Hide() end
    self.reputationBarFrame:Hide()

    local textHeight = floor((xb:GetHeight() - 4) / 2)
    local barHeight = (iconSize - textHeight - 2)
    if barHeight < 2 then barHeight = 2 end
    local barYOffset = floor((xb:GetHeight() - iconSize) / 2)
    if barYOffset < 0 then barYOffset = 0 end
    self.reputationIcon:ClearAllPoints()
    self.reputationIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\seal')
    self.reputationIcon:SetSize(iconSize, iconSize)
    self.reputationIcon:SetPoint('LEFT')
    self.reputationIcon:SetVertexColor(xb:GetColor('normal'))

    self.reputationText:SetFont(xb:GetFont(textHeight))
    self.reputationText:SetTextColor(xb:GetColor('normal'))
    self.reputationText:SetText(string.upper(name))
    self.reputationText:ClearAllPoints()

    local rewardCheckWidth = 0
    if self.reputationRewardCheck then
        self.reputationRewardCheck:Hide()
        self.reputationText:SetPoint('TOPLEFT', self.reputationIcon, 'TOPRIGHT',
                                     5, 0)
    else
        self.reputationText:SetPoint('TOPLEFT', self.reputationIcon, 'TOPRIGHT',
                                     5, 0)
    end

    local color = FACTION_BAR_COLORS[reaction] or { r = 1, g = 0, b = 1 }
    local renownColor = { r = 0.00, g = 0.76, b = 1.00 } -- blue/cyan style Renown UI
    
    self.reputationBar:SetStatusBarTexture("Interface/BUTTONS/WHITE8X8")
    if db.modules.reputation.reputationBarClassCC then
        local rPerc, gPerc, bPerc = xb:GetClassColors()
        self.reputationBar:SetStatusBarColor(rPerc, gPerc, bPerc, 1)
    elseif db.modules.reputation.reputationBarReputationCC then
        if reputationKind == "major" then
            self.reputationBar:SetStatusBarColor(renownColor.r, renownColor.g, renownColor.b, 1)
        else
            self.reputationBar:SetStatusBarColor(color.r or 1, color.g or 1, color.b or 1, 1)
        end
    else
        self.reputationBar:SetStatusBarColor(xb:GetColor('normal'))
    end

    self.reputationBar:ClearAllPoints()
    self.reputationBar:SetMinMaxValues(minValue, maxValue)
    self.reputationBar:SetValue(curValue)
    self.reputationBar:SetSize(self.reputationText:GetStringWidth() + rewardCheckWidth,
                               barHeight)
    self.reputationBar:SetPoint('BOTTOMLEFT', self.reputationBarFrame,
                                'BOTTOMLEFT', iconSize + 5, barYOffset)

    self.reputationBarBg:SetAllPoints()
    self.reputationBarBg:SetColorTexture(db.color.inactive.r,
                                         db.color.inactive.g,
                                         db.color.inactive.b,
                                         db.color.inactive.a)
    self.reputationFrame:SetSize(
        iconSize + self.reputationText:GetStringWidth() + rewardCheckWidth + 5,
        xb:GetHeight())
    self.reputationBarFrame:SetAllPoints()
    self.reputationBarFrame:Show()
    self:SetParagonRewardFlash(shouldFlashParagonReward)

    -- self.reputationFrame:SetSize(self.goldButton:GetSize())
    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    local anchorFrame = xb:GetFrame('currencyFrame')
    -- For some reason anchorFrame can happen to be nil, in this case, skip this until value gets different from nil
    if anchorFrame ~= nil and not anchorFrame:IsVisible() then
        if xb:GetFrame('tradeskillFrame') and xb:GetFrame('tradeskillFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('tradeskillFrame')
        elseif xb:GetFrame('clockFrame') and xb:GetFrame('clockFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('clockFrame')
        elseif xb:GetFrame('talentFrame') and xb:GetFrame('talentFrame'):IsVisible() then
            anchorFrame = xb:GetFrame('talentFrame')
        else
            relativeAnchorPoint = 'LEFT'
            xOffset = 0
        end
    end
    self.reputationFrame:ClearAllPoints()
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
    self.reputationRewardCheck = self.reputationRewardCheck or
                                     self.reputationBarFrame:CreateTexture(nil,
                                                                          'OVERLAY')
    self.reputationRewardCheck:Hide()
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
            OpenReputationPanel()
        end)
    end
    self:RegisterEvent('UPDATE_FACTION', 'Refresh')
    self:RegisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED', 'Refresh')
    self:RegisterEvent('MAJOR_FACTION_UNLOCKED', 'Refresh')
    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Refresh')
    self:RegisterEvent('QUEST_TURNED_IN', 'Refresh')
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
    self.reputationFrame:SetScript('OnMouseUp', function()
        if InCombatLockdown() then return; end
        OpenReputationPanel()
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
    self.reputationBarFrame:SetScript('OnClick', function()
        if InCombatLockdown() then return; end
        OpenReputationPanel()
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'currencyFrame' or name == 'tradeskillFrame' then
            self:Refresh()
        end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'currencyFrame' or name == 'tradeskillFrame' then
            self:Refresh()
        end
    end)
end

function ReputationModule:ShowTooltip()
    if not xb.db.profile.modules.reputation.showTooltip then return end

    local r, g, b, _ = unpack(xb:HoverColors())

    GameTooltip:SetOwner(self.reputationFrame, 'ANCHOR_' .. xb.miniTextPosition)

    GameTooltip:AddLine("|cFFFFFFFF[|r" .. REPUTATION .. "|cFFFFFFFF]|r", r,
                        g, b)
    GameTooltip:AddLine(" ")

    local watchedData = GetWatchedReputationDisplayData()

    if not watchedData then
        GameTooltip:AddLine("No Watched Faction", 1, 1, 1)
    else
        local name = watchedData.name
        local rankText = watchedData.rankText
        local current = watchedData.progressCurrent
        local maxValueForDisplay = watchedData.progressMax
        local percent = watchedData.progressPercent

        GameTooltip:AddDoubleLine(REPUTATION .. ':', name, r, g, b, 1, 1, 1)

        GameTooltip:AddDoubleLine(RANK_LABEL .. ':', rankText, r, g, b, 1, 1, 1)

        if type(current) == "number" and type(maxValueForDisplay) == "number" and
            maxValueForDisplay > 0 then
            if type(percent) ~= "number" then
                percent = floor((current / maxValueForDisplay) * 100)
            end
            GameTooltip:AddDoubleLine("Progress:",
                                      string.format('%d / %d (%d%%)', current,
                                                    maxValueForDisplay, percent),
                                      r, g, b, 1, 1, 1)
        end

        if watchedData.paragonRewardAvailable then
            GameTooltip:AddLine("|A:ParagonReputation_Bag:14:14|a Paragon Reward available",
                                1, 0.82, 0)
        end
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>',
                              'Open ' .. REPUTATION, r, g, b, 1, 1, 1)

    GameTooltip:Show()
end

function ReputationModule:GetDefaultOptions()
    return 'reputation',
           {
        enabled = false,
        reputationBarClassCC = false,
        showTooltip = true,
        flashParagonReward = true
    }
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
            },
            flashParagonReward = {
                name = 'Flash on Paragon Reward',
                order = 5,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.reputation.flashParagonReward;
                end,
                set = function(_, val)
                    xb.db.profile.modules.reputation.flashParagonReward = val;
                    self:Refresh();
                end
            }
        }
    }
end
