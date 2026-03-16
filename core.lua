local AddOnName = ...;
---@class XIVBar : AceAddon-3.0, AceConsole-3.0, AceEvent-3.0
local XIVBar = select(2, ...);
local _G = _G;
local pairs, select = pairs, select
local AceAddon = _G.LibStub('AceAddon-3.0')

AceAddon:NewAddon(XIVBar, AddOnName, "AceConsole-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName, true);
LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(AddOnName, {
    type = "launcher",
    icon = "Interface\\Icons\\Spell_Nature_StormReach",
    OnClick = function(_, button) XIVBar:ToggleConfig() end
})

XIVBar.Changelog = {}

XIVBar.L = L ---@type XIV_DatabarLocale

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

XIVBar.LSM = LibStub('LibSharedMedia-3.0');

function XIVBar:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("XIVBarDB", self.defaults, "Default")
    self.LSM:Register(self.LSM.MediaType.FONT, 'Homizio Bold',
                      self.constants.mediaPath .. "homizio_bold.ttf")
    self.frames = {}

    self.fontFlags = {'', 'OUTLINE', 'THICKOUTLINE', 'MONOCHROME'}

    self:SetupOptions()

    self.timerRefresh = false

    self:RegisterChatCommand('xivc', 'ToggleConfig')
    self:RegisterChatCommand('xivbar', 'ToggleConfig')
    self:RegisterChatCommand('xbc', 'ToggleConfig')
end

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
        local function GetBarCenter(frame)
            local width, height = frame:GetSize()
            local x, y = frame:GetCenter()
            return x, y, width, height
        end

        -- Helper function to snap to nearest point if within threshold
        local function GetSnappedPosition(frame)
            local screenWidth, screenHeight = UIParent:GetWidth(), UIParent:GetHeight()
            local centerX, centerY, barWidth = GetBarCenter(frame)
            local point
            local xOffset
            local yOffset
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

        bar:SetScript("OnDragStart", function(frame)
            if not XIVBar.db.profile.general.locked and not XIVBar.db.profile.general.barFullscreen then
                frame:StartMoving()
                XIVBar.frames.guides:Show()
            end
        end)

        bar:SetScript("OnDragStop", function(frame)
            if not XIVBar.db.profile.general.barFullscreen then
                frame:StopMovingOrSizing()
                XIVBar.frames.guides:Hide()

                -- Get final position with snapping
                local point, relativePoint, xOffset, yOffset = GetSnappedPosition(frame)

                -- Save position
                XIVBar.db.profile.general.point = point
                XIVBar.db.profile.general.relativePoint = relativePoint
                XIVBar.db.profile.general.xOffset = xOffset
                XIVBar.db.profile.general.yOffset = yOffset

                -- Apply position
                frame:ClearAllPoints()
                frame:SetPoint(point, UIParent, relativePoint, xOffset, yOffset)

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
    local settings = _G["Settings"]
    local openLegacyCategory = _G["InterfaceOptionsFrame_OpenToCategory"]

    if settings and settings.OpenToCategory then
        if self.optionsCategory then
            settings.OpenToCategory(self.optionsCategory)
        else
            settings.OpenToCategory("XIV Bar Continued")
        end
    elseif openLegacyCategory then
        local category = self.optionsCategory or "XIV Bar Continued"
        openLegacyCategory(category)
    else
        self:Print("Impossible d'ouvrir les options sur cette version du client.")
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
        r, g, b = self:GetClassColors()
    elseif name == 'barColor' and profile.useCC then
        r, g, b = self:GetClassColors()
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

function XIVBar:RegisterMouseoverHoldFrame(frame, keepVisibleWhileShown)
    if not frame then
        return
    end
    self.mouseoverHoldFrames = self.mouseoverHoldFrames or {}
    self.mouseoverHoldFrames[frame] = true
    frame._xivKeepVisibleWhileShown = (keepVisibleWhileShown ~= false)
end

function XIVBar:GetPopupDismissLayer()
    if self.popupDismissLayer then
        return self.popupDismissLayer
    end

    local layer = CreateFrame("BUTTON", nil, UIParent)
    layer:SetAllPoints(UIParent)
    layer:Hide()
    layer:EnableMouse(true)
    layer:RegisterForClicks("AnyUp", "AnyDown")
    layer:SetFrameStrata("TOOLTIP")
    layer:SetFrameLevel(1)
    layer:SetScript("OnClick", function()
        XIVBar:HideActivePopup()
    end)

    self.popupDismissLayer = layer
    return layer
end

function XIVBar:ShowPopup(popup)
    if not popup then
        return
    end

    local layer = self:GetPopupDismissLayer()
    if self.activePopup and self.activePopup ~= popup and self.activePopup.Hide then
        self.activePopup:Hide()
    end

    self.activePopup = popup

    if not popup._xivPopupAutoCloseHooked then
        popup._xivPopupAutoCloseHooked = true
        popup:HookScript("OnHide", function(frame)
            if XIVBar.activePopup == frame then
                XIVBar.activePopup = nil
                if XIVBar.popupDismissLayer then
                    XIVBar.popupDismissLayer:Hide()
                end
            end
        end)
    end

    layer:ClearAllPoints()
    layer:SetAllPoints(UIParent)
    layer:SetFrameStrata(popup:GetFrameStrata() or "TOOLTIP")
    local popupLevel = popup:GetFrameLevel() or 1
    layer:SetFrameLevel(math.max(1, popupLevel - 1))
    layer:Show()
    popup:Show()
end

function XIVBar:HidePopup(popup)
    if not popup then
        return
    end
    popup:Hide()
    if self.activePopup == popup then
        self.activePopup = nil
        if self.popupDismissLayer then
            self.popupDismissLayer:Hide()
        end
    end
end

function XIVBar:HideActivePopup()
    if self.activePopup and self.activePopup.Hide then
        self.activePopup:Hide()
        return
    end
    if self.popupDismissLayer then
        self.popupDismissLayer:Hide()
    end
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
                XIVBar:ResetUI()
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
        self.miniTextPosition = 'BOTTOM'
    else
        self:ResetUI();
    end

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

    for _, module in self:IterateModules() do
        if module['Refresh'] == nil then return; end
        module:Refresh()
    end

    self:UpdateMouseoverScripts()
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

function XIVBar:UpdateMouseoverScripts()
    local bar = XIVBar.frames and XIVBar.frames.bar
    if not bar then return end

    local function IsMouseOverBar()
        if MouseIsOver(bar) then
            return true
        end

        if XIVBar.mouseoverHoldFrames then
            for frame in pairs(XIVBar.mouseoverHoldFrames) do
                if frame then
                    local isShown = frame.IsShown and frame:IsShown()
                    local isVisible = frame.IsVisible and frame:IsVisible()
                    if isShown and isVisible then
                        if MouseIsOver(frame) or frame._xivKeepVisibleWhileShown then
                            return true
                        end
                    end
                end
            end
        end

        return false
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

    local function EnsureMouseoverAnimations()
        if bar._xivFadeInGroup and bar._xivFadeOutGroup then
            return
        end

        bar._xivFadeInGroup = bar:CreateAnimationGroup()
        bar._xivFadeIn = bar._xivFadeInGroup:CreateAnimation("Alpha")
        bar._xivFadeIn:SetOrder(1)
        bar._xivFadeIn:SetDuration(0.15)
        bar._xivFadeInGroup:SetScript("OnFinished", function()
            bar:SetAlpha(1)
        end)

        bar._xivFadeOutGroup = bar:CreateAnimationGroup()
        bar._xivFadeOut = bar._xivFadeOutGroup:CreateAnimation("Alpha")
        bar._xivFadeOut:SetOrder(1)
        bar._xivFadeOut:SetDuration(0.15)
        bar._xivFadeOutGroup:SetScript("OnFinished", function()
            bar:SetAlpha(0)
        end)
    end

    local function PlayAlpha(group, anim, fromAlpha, toAlpha)
        if group:IsPlaying() then
            group:Stop()
        end
        anim:SetFromAlpha(fromAlpha)
        anim:SetToAlpha(toAlpha)
        group:Play()
    end

    local showBar
    local hideBarIfOut

    local function HookMouseoverFrame(frame)
        if not (frame and frame.EnableMouse) then
            return
        end
        if frame._xivMouseoverHooksInstalled then
            return
        end

        frame:EnableMouse(true)

        if frame._xivKeepVisibleWhileShown then
            frame._xivMouseoverHooksInstalled = true
            return
        end

        if not frame.HookScript then
            return
        end

        frame._xivMouseoverHooksInstalled = true
        frame:HookScript('OnEnter', showBar)
        frame:HookScript('OnLeave', hideBarIfOut)
    end

    showBar = function()
        bar._xivHidePending = false
        if not bar._xivMouseoverEnabled then
            return
        end
        if bar._xivMouseoverVisible then
            return
        end

        EnsureMouseoverAnimations()
        if bar._xivFadeOutGroup and bar._xivFadeOutGroup:IsPlaying() then
            bar._xivFadeOutGroup:Stop()
        end

        bar._xivMouseoverVisible = true
        PlayAlpha(bar._xivFadeInGroup, bar._xivFadeIn, bar:GetAlpha(), 1)
    end

    hideBarIfOut = function()
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
                EnsureMouseoverAnimations()
                if bar._xivFadeInGroup and bar._xivFadeInGroup:IsPlaying() then
                    bar._xivFadeInGroup:Stop()
                end

                bar._xivMouseoverVisible = false
                PlayAlpha(bar._xivFadeOutGroup, bar._xivFadeOut, bar:GetAlpha(), 0)
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
        bar:SetScript('OnUpdate', function(frame, elapsed)
            frame._xivMouseoverElapsed = (frame._xivMouseoverElapsed or 0) + elapsed
            if frame._xivMouseoverElapsed < 0.05 then return end
            frame._xivMouseoverElapsed = 0
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
            for _, frame in pairs(XIVBar.frames) do
                if frame and frame ~= bar and frame.EnableMouse and frame.HookScript and IsBarChild(frame) then
                    HookMouseoverFrame(frame)
                end
            end
        end
        if XIVBar.mouseoverHoldFrames then
            for frame in pairs(XIVBar.mouseoverHoldFrames) do
                if frame and frame ~= bar then
                    HookMouseoverFrame(frame)
                end
            end
        end
    else
        bar._xivMouseoverEnabled = false
        bar._xivHideToken = (bar._xivHideToken or 0) + 1
        if bar._xivFadeInGroup and bar._xivFadeInGroup:IsPlaying() then
            bar._xivFadeInGroup:Stop()
        end
        if bar._xivFadeOutGroup and bar._xivFadeOutGroup:IsPlaying() then
            bar._xivFadeOutGroup:Stop()
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

