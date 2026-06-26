local _, xb = ...
local _G = _G
local L = xb.L
local compat = xb.compat or {}
local IsAddOnLoaded = (compat and compat.IsAddOnLoaded) or (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded

local VolumeModule = xb:NewModule("VolumeModule", 'AceEvent-3.0')

local function hasOutputDriverSupport()
  return type(Sound_GameSystem_GetNumOutputDrivers) == "function"
end

function VolumeModule:GetName()
  return "MasterVolume";
end

function VolumeModule:SkinFrame(frame, name)
  if self.useElvUI then
    if frame.StripTextures then
      frame:StripTextures()
    end
    if frame.SetTemplate then
      frame:SetTemplate("Transparent")
    end

    local close = _G[name .. "CloseButton"] or frame.CloseButton
    if close and close.SetAlpha then
      if _G.ElvUI then
        _G.ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
      end

      if _G.Tukui and _G.Tukui[1] and _G.Tukui[1].SkinCloseButton then
        _G.Tukui[1].SkinCloseButton(close)
      end
      close:SetAlpha(1)
    end
  end
end

function VolumeModule:OnInitialize()
  self.frame = nil
  self.icon = nil
  self.text = nil
  self.outputPopup = nil
  self.outputButtons = {}
  self.extraPadding = (xb.constants.popupPadding * 3)
  self.optionTextExtra = 4
  self.useElvUI = xb.db.profile.general.useElvUI and (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui'))
end

function VolumeModule:OnEnable()
	if self.frame == nil then
		self:CreateModuleFrame()
		self:RegisterEvents()
		self:MasterVolume_Update_Value()
		self:Hooks()
	else
		self.frame:Show()
    self.frame:EnableMouseWheel(xb.db.profile.modules.MasterVolume.enableMouseWheel)
    self:RegisterEvents()
	end
end

function VolumeModule:OnDisable()
	if self.outputPopup and self.outputPopup:IsVisible() then
		xb:HidePopup(self.outputPopup)
	end
	if self.frame then
		self.frame:Hide()
		self.frame:UnregisterAllEvents()
	end
end

function VolumeModule:GetCurrentOutputIndex()
  return tonumber(GetCVar("Sound_OutputDriverIndex")) or 0
end

function VolumeModule:GetOutputDriverName(index)
  if not hasOutputDriverSupport() then
    return ""
  end
  return Sound_GameSystem_GetOutputDriverNameByIndex(index) or ""
end

function VolumeModule:CreateModuleFrame()
	self.frame=CreateFrame("BUTTON","masterVolume", xb:GetFrame('bar'))
	xb:RegisterFrame('volumeFrame',self.frame)
	self.frame:EnableMouse(true)
	self.frame:EnableMouseWheel(xb.db.profile.modules.MasterVolume.enableMouseWheel)
	self.frame:RegisterForClicks("AnyDown")

  local template = (TooltipBackdropTemplateMixin and "TooltipBackdropTemplate") or
                       (BackdropTemplateMixin and "BackdropTemplate")
  self.outputPopup = self.outputPopup or CreateFrame('BUTTON', 'VolumeOutputPopup', self.frame, template)
  self.outputPopup:SetFrameStrata('TOOLTIP')
  xb:RegisterMouseoverHoldFrame(self.outputPopup, true)

  if TooltipBackdropTemplateMixin then
    self.outputPopup.layoutType = GameTooltip.layoutType
    NineSlicePanelMixin.OnLoad(self.outputPopup.NineSlice)

    if GameTooltip.layoutType then
      self.outputPopup.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
      self.outputPopup.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
    end
  else
    local backdrop = GameTooltip:GetBackdrop()
    if backdrop then
      self.outputPopup:SetBackdrop(backdrop)
      self.outputPopup:SetBackdropColor(GameTooltip:GetBackdropColor())
      self.outputPopup:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
    end
  end

  self.outputPopup:Hide()

if not xb:ApplyModuleFreePlacement('MasterVolume', self.frame) then
		local relativeAnchorPoint = 'RIGHT'
		local xOffset = xb.db.profile.general.moduleSpacing
		local parentFrame = xb:GetFrame('armorFrame')
		if not xb.db.profile.modules.armor.enabled then
			parentFrame=xb:GetFrame('microMenuFrame')
			if not xb.db.profile.modules.microMenu.enabled then
				parentFrame=xb:GetFrame('bar')
				relativeAnchorPoint = 'LEFT'
				xOffset = 0
			end
		end

		self.frame:SetPoint('LEFT', parentFrame, relativeAnchorPoint, xOffset, 0)
	end

  self.icon = self.frame:CreateTexture(nil, "OVERLAY", nil, 7)
  self.icon:SetPoint("LEFT")
  self.icon:SetTexture(xb.constants.mediaPath .. "datatexts\\sound")
  self.icon:SetVertexColor(xb:GetColor('normal'))

  self.text = self.frame:CreateFontString(nil, "OVERLAY")
  self.text:SetFont(xb:GetFont(xb.db.profile.text.fontSize))
  self.text:SetPoint("RIGHT", self.frame, 2, 0)
  self.text:SetTextColor(xb:GetColor('inactive'))
end

function VolumeModule:CreateOutputPopup()
  if not self.outputPopup or not hasOutputDriverSupport() then
    return
  end

  local db = xb.db.profile
  local iconSize = db.text.fontSize + db.general.barPadding
  local popupWidth = self.frame:GetWidth()
  local popupHeight = xb.constants.popupPadding + db.text.fontSize + self.optionTextExtra
  local changedWidth = false
  local r, g, b, _ = unpack(xb:HoverColors())
  local normalR, normalG, normalB = xb:GetColor('normal')

  self.outputOptionString = self.outputOptionString or self.outputPopup:CreateFontString(nil, 'OVERLAY')
  self.outputOptionString:SetFont(xb:GetFont(db.text.fontSize + self.optionTextExtra))
  self.outputOptionString:SetTextColor(r, g, b, 1)
  self.outputOptionString:SetText(L["SET_AUDIO_OUTPUT"])
  self.outputOptionString:SetPoint('TOP', 0, -(xb.constants.popupPadding))
  self.outputOptionString:SetPoint('CENTER')

  for _, button in pairs(self.outputButtons) do
    button.isSettable = false
    button:Hide()
  end

  local numDrivers = Sound_GameSystem_GetNumOutputDrivers() or 0

  if numDrivers == 0 then
    local button = self.outputButtons[1]
    if button == nil then
      button = CreateFrame('BUTTON', nil, self.outputPopup)
      button.text = button:CreateFontString(nil, 'OVERLAY')
      self.outputButtons[1] = button
    end

    button.text:SetFont(xb:GetFont(db.text.fontSize))
    button.text:SetTextColor(normalR, normalG, normalB)
    button.text:SetText(L["NO_AUDIO_OUTPUT_DEVICES"])
    button.text:ClearAllPoints()
    button.text:SetPoint('LEFT')
    button:SetSize(button.text:GetStringWidth(), iconSize)
    button:EnableMouse(false)
    button:SetScript('OnEnter', nil)
    button:SetScript('OnLeave', nil)
    button:SetScript('OnClick', nil)
    button.isSettable = true
    button:Show()

    popupWidth = button.text:GetStringWidth()
    changedWidth = true
  else
    for index = 0, numDrivers - 1 do
      local driverName = Sound_GameSystem_GetOutputDriverNameByIndex(index)
      if driverName then
        local buttonIndex = index + 1
        local button = self.outputButtons[buttonIndex]
        if button == nil then
          button = CreateFrame('BUTTON', nil, self.outputPopup)
          button.text = button:CreateFontString(nil, 'OVERLAY')
          self.outputButtons[buttonIndex] = button
        end

        button.text:SetFont(xb:GetFont(db.text.fontSize))
        button.text:SetTextColor(normalR, normalG, normalB)
        button.text:SetText(driverName)
        button.text:ClearAllPoints()
        button.text:SetPoint('LEFT')
        local textWidth = button.text:GetStringWidth()

        button:SetID(index)
        button:SetSize(textWidth, iconSize)
        button.isSettable = true
        button:EnableMouse(true)
        button:RegisterForClicks('AnyUp')
        button:Show()

        button:SetScript('OnEnter', function()
          button.text:SetTextColor(r, g, b, 1)
        end)

        button:SetScript('OnLeave', function()
          button.text:SetTextColor(normalR, normalG, normalB)
        end)

        button:SetScript('OnClick', function(clickedButton, mouseButton)
          if InCombatLockdown() then
            return
          end

          if mouseButton == 'LeftButton' then
            SetCVar("Sound_OutputDriverIndex", tostring(clickedButton:GetID()))
            Sound_GameSystem_RestartSoundSystem()
          end

          xb:HidePopup(VolumeModule.outputPopup)
        end)

        if textWidth > popupWidth then
          popupWidth = textWidth
          changedWidth = true
        end
      end
    end
  end

  for _, button in pairs(self.outputButtons) do
    if button.isSettable then
      button:SetPoint('LEFT', xb.constants.popupPadding, 0)
      button:SetPoint('TOP', 0, -(popupHeight + xb.constants.popupPadding))
      button:SetPoint('RIGHT')
      popupHeight = popupHeight + xb.constants.popupPadding + db.text.fontSize
    end
  end

  if changedWidth then
    popupWidth = popupWidth + self.extraPadding
  end

  if popupWidth < self.frame:GetWidth() then
    popupWidth = self.frame:GetWidth()
  end

  if popupWidth < (self.outputOptionString:GetStringWidth() + self.extraPadding) then
    popupWidth = (self.outputOptionString:GetStringWidth() + self.extraPadding)
  end

  self.outputPopup:SetSize(popupWidth, popupHeight + xb.constants.popupPadding)
  self.outputPopup:ClearAllPoints()
  self.outputPopup:SetPoint(db.general.barPosition, self.frame, xb.miniTextPosition, 0, 0)
  self:SkinFrame(self.outputPopup, "SpecToolTip")
  self.outputPopup:Hide()
end

function VolumeModule:ShowTooltip()
  if InCombatLockdown() then
    return
  end
  if self.outputPopup and self.outputPopup:IsVisible() then
    return
  end

  self.icon:SetVertexColor(xb:GetColor('hover'))
  self.text:SetTextColor(xb:GetColor('hover'))

  local r, g, b, _ = unpack(xb:HoverColors())
  GameTooltip:SetOwner(self.frame, 'ANCHOR_' .. xb.miniTextPosition)
  GameTooltip:ClearLines()
  GameTooltip:AddLine("|cFFFFFFFF[|r" .. MASTER_VOLUME .. "|cFFFFFFFF]|r", r, g, b)

  if hasOutputDriverSupport() then
    local outputName = self:GetOutputDriverName(self:GetCurrentOutputIndex())
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["CURRENT_AUDIO_OUTPUT"], outputName, r, g, b, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. SHIFT_KEY_TEXT .. '+' .. L["LEFT_CLICK"] .. '>', L["SET_AUDIO_OUTPUT"], r, g, b, 1, 1, 1)
  end

  GameTooltip:AddLine(" ")
  GameTooltip:AddDoubleLine("<" .. L["LEFT_CLICK"] .. ">", BINDING_NAME_MASTERVOLUMEUP, r, g, b, 1, 1, 1)
  GameTooltip:AddDoubleLine("<" .. L["RIGHT_CLICK"] .. ">", BINDING_NAME_MASTERVOLUMEDOWN, r, g, b, 1, 1, 1)
  if xb.db.profile.modules.MasterVolume.enableMouseWheel then
    GameTooltip:AddDoubleLine("<" .. KEY_MOUSEWHEELUP .. ">", BINDING_NAME_MASTERVOLUMEUP, r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine("<" .. KEY_MOUSEWHEELDOWN .. ">", BINDING_NAME_MASTERVOLUMEDOWN, r, g, b, 1, 1, 1)
  end
  GameTooltip:Show()
end

function VolumeModule:RegisterEvents()
  self.frame:SetScript("OnEnter", function()
    self:ShowTooltip()
  end)

  self.frame:SetScript("OnClick", function(_, button)
    if InCombatLockdown() then
      return
    end

    local volume = tonumber(GetCVar("Sound_MasterVolume"));

    if button == "LeftButton" then
      if IsShiftKeyDown() and hasOutputDriverSupport() then
        GameTooltip:Hide()

        if not self.outputPopup:IsVisible() then
          self:CreateOutputPopup()
          xb:ShowPopup(self.outputPopup)
        else
          xb:HidePopup(self.outputPopup)
          self:ShowTooltip()
        end
      else
        SetCVar("Sound_MasterVolume", volume + xb.db.profile.modules.MasterVolume.step);
      end

    elseif button == "RightButton" then
      SetCVar("Sound_MasterVolume", volume - xb.db.profile.modules.MasterVolume.step);
    end
    volume = tonumber(GetCVar("Sound_MasterVolume"));
    if volume <= 0 then SetCVar("Sound_MasterVolume", 0); end
    if volume >= 1 then SetCVar("Sound_MasterVolume", 1); end
  end)

  if xb.db.profile.modules.MasterVolume.enableMouseWheel then
    self.frame:SetScript("OnMouseWheel", function(_, delta)
      local volume = tonumber(GetCVar("Sound_MasterVolume"));

      if delta > 0 then
        SetCVar("Sound_MasterVolume", volume + xb.db.profile.modules.MasterVolume.step);
      elseif delta < 0 then
        SetCVar("Sound_MasterVolume", volume - xb.db.profile.modules.MasterVolume.step);
      end

      volume = tonumber(GetCVar("Sound_MasterVolume"));
      if volume <= 0 then SetCVar("Sound_MasterVolume", 0); end
      if volume >= 1 then SetCVar("Sound_MasterVolume", 1); end
    end)
  else
    self.frame:SetScript("OnMouseWheel", nil)
  end

  self.frame:SetScript("OnLeave", function()
    self.icon:SetVertexColor(xb:GetColor('normal'))
    self.text:SetTextColor(xb:GetColor('inactive'))
    GameTooltip:Hide();
  end)

  self.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
  self.frame:RegisterEvent("CVAR_UPDATE");
  self.frame:SetScript("OnEvent", function()
    VolumeModule:MasterVolume_Update_Value();
  end)
end

function VolumeModule:Refresh()
  if not xb.db.profile.modules.MasterVolume.enabled then self:Disable(); return; end
  if not self.frame and xb.db.profile.modules.MasterVolume.enabled then
    self:Enable()
    return;
  end
  if self.frame then
    self.frame:Hide()
    if xb:ApplyModuleFreePlacement('MasterVolume', self.frame) then
      self.frame:EnableMouseWheel(xb.db.profile.modules.MasterVolume.enableMouseWheel)
      self:RegisterEvents()
      self.frame:Show()
      return
    end
    local relativeAnchorPoint = 'RIGHT'
    local xOffset = xb.db.profile.general.moduleSpacing
    local parentFrame = xb:GetFrame('armorFrame')
    if not xb.db.profile.modules.armor.enabled then
      parentFrame = xb:GetFrame('microMenuFrame')
      if not xb.db.profile.modules.microMenu.enabled then
        parentFrame = xb:GetFrame('bar')
        relativeAnchorPoint = 'LEFT'
        xOffset = 0
      end
    end
    self.frame:ClearAllPoints()
    self.frame:SetPoint('LEFT', parentFrame, relativeAnchorPoint, xOffset, 0)
    self.frame:EnableMouseWheel(xb.db.profile.modules.MasterVolume.enableMouseWheel)
    self:RegisterEvents()
    self.frame:Show()
  end
end

function VolumeModule:MasterVolume_Update_Value()
	local volume = tonumber(GetCVar("Sound_MasterVolume")) or 0;
	local volumePercent = (volume * 100);
	local volumePercentTrimed = tonumber(string.format("%.1f", volumePercent));
	if self.text and self.frame then
		self.text:SetText(volumePercentTrimed.." %")
		self.frame:SetSize(self.text:GetStringWidth()+18, 16)
	end
end

function VolumeModule:Hooks()
	hooksecurefunc("Sound_MasterVolumeUp", VolumeModule.MasterVolume_Update_Value)
	hooksecurefunc("Sound_MasterVolumeDown", VolumeModule.MasterVolume_Update_Value)

	hooksecurefunc("SetCVar", function(cvar)
		if cvar == "Sound_MasterVolume" then
			VolumeModule:MasterVolume_Update_Value()
		end
	end)
end

function VolumeModule:GetDefaultOptions()
  return self:GetName(), {
      enabled = false,
      enableMouseWheel = true,
      step = 0.1
    }
end

function VolumeModule:GetConfig()
  return {
    name = L["MASTER_VOLUME"],
    type = "group",
    args = {
      enable = {
        name = ENABLE,
        order = 0,
        type = "toggle",
        get = function() return xb.db.profile.modules.MasterVolume.enabled; end,
        set = function(_, val)
          xb.db.profile.modules.MasterVolume.enabled = val
          if val then
            self:Enable();
          else
            self:Disable();
          end
        end,
      },
      enableMouseWheel = {
        name = L["ENABLE_MOUSE_WHEEL"],
        order = 1,
        type = "toggle",
        get = function() return xb.db.profile.modules.MasterVolume.enableMouseWheel; end,
        set = function(_, val)
          xb.db.profile.modules.MasterVolume.enableMouseWheel = val
          self:Refresh()
        end
      },
      step = {
        name = L["VOLUME_STEP"],
        order = 2,
        type = "range",
        min = 1,
        max = 50,
        step = 1,
        get = function() return xb.db.profile.modules.MasterVolume.step*100; end,
        set = function(_,val) xb.db.profile.modules.MasterVolume.step = val/100.0; end
      },
    }
  }
 end
