local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local TradeskillModule = xb:NewModule("TradeskillModule", 'AceEvent-3.0')

function TradeskillModule:GetName() return TRADESKILLS; end
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function TradeskillModule:OnInitialize()
    self.tipHover = (name == 'tradeskill')
    self.LTip = LibStub('LibQTip-1.0')
    self.profIcons = {
        [164] = 'blacksmithing',
        [165] = 'leatherworking',
        [171] = 'alchemy',
        [182] = 'herbalism',
        [186] = 'mining',
        [202] = 'engineering',
        [333] = 'enchanting',
        [755] = 'jewelcrafting',
        [773] = 'inscription',
        [197] = 'tailoring',
        [393] = 'skinning'
    }
end

function TradeskillModule:OnEnable()
    if self.tradeskillFrame == nil then
        self.tradeskillFrame = CreateFrame("FRAME", nil, xb:GetFrame('bar'))
        xb:RegisterFrame('tradeskillFrame', self.tradeskillFrame)
    end

    self.tipHover = (name == 'tradeskill')
    self.lineHover = false

    self.tradeskillFrame:Show()

    self.firstProf = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil
    }
    self.secondProf = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil
    }
    self.arch = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil
    }
    self.fish = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil
    }
    self.cook = {
        idx = nil,
        id = nil,
        name = nil,
        defIcon = nil,
        lvl = nil,
        maxLvl = nil
    }

    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function TradeskillModule:OnDisable()
    self.tradeskillFrame:Hide()
    self:UnregisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('UNIT_SPELLCAST_STOP')
end

function TradeskillModule:UpdateProfValues()
    -- update profession indexes before anything else or receive a million bugs when (un)learning professions
    self.firstProf.idx, self.secondProf.idx, self.arch.idx, self.fish.idx, self.cook
        .idx = GetProfessions() -- this is the most important line in the entire fucking module

    -- if firstProf.idx doesn't exist, the player hasn't learned any profession and thus the tradeskillFrame is hidden
    if not self.firstProf.idx then
        self.tradeskillFrame:Hide()
    else
        -- player has at least one profession, setting first one. show tradeskillFrame because it might've been hidden before
        self.tradeskillFrame:Show()
        local name, defIcon, lvl, maxLvl, _, _, id, _ = GetProfessionInfo(
                                                            self.firstProf.idx)
        self.firstProf.name, self.firstProf.defIcon, self.firstProf.lvl, self.firstProf
            .maxLvl, self.firstProf.id = name, defIcon, lvl, maxLvl, id
        self.firstProfBar:SetMinMaxValues(1, self.firstProf.maxLvl)
        self.firstProfBar:SetValue(self.firstProf.lvl)
    end

    -- if secondProf.idx doesn't exist, hide the secondProfFrame 
    if not self.secondProf.idx then
        self.secondProfFrame:Hide()
    else
        -- player has two profession, setting second one. show secondProfFrame because it might've been hidden before
        self.secondProfFrame:Show()
        local name, defIcon, lvl, maxLvl, _, _, id, _ = GetProfessionInfo(
                                                            self.secondProf.idx)
        self.secondProf.name, self.secondProf.defIcon, self.secondProf.lvl, self.secondProf
            .maxLvl, self.secondProf.id = name, defIcon, lvl, maxLvl, id
        self.secondProfBar:SetMinMaxValues(1, self.secondProf.maxLvl)
        self.secondProfBar:SetValue(self.secondProf.lvl)
    end

    -- update values for secondary professions if they exist (archaeology / fishing / cooking)
    -- update archaeology
    if self.arch.idx then
        local name, defIcon, lvl, maxLvl, _, _, id, _ = GetProfessionInfo(
                                                            self.arch.idx)
        self.arch.name, self.arch.defIcon, self.arch.lvl, self.arch.maxLvl, self.arch
            .id = name, defIcon, lvl, maxLvl, id
    end
    -- update fishing
    if self.fish.idx then
        local name, defIcon, lvl, maxLvl, _, _, id, _ = GetProfessionInfo(
                                                            self.fish.idx)
        self.fish.name, self.fish.defIcon, self.fish.lvl, self.fish.maxLvl, self.fish
            .id = name, defIcon, lvl, maxLvl, id
    end
    -- update cooking
    if self.cook.idx then
        local name, defIcon, lvl, maxLvl, _, _, id, _ = GetProfessionInfo(
                                                            self.cook.idx)
        self.cook.name, self.cook.defIcon, self.cook.lvl, self.cook.maxLvl, self.cook
            .id = name, defIcon, lvl, maxLvl, id
    end
end

function TradeskillModule:Refresh()
    -- don't refresh anything while in combat because why the fuck would you?
    if InCombatLockdown() then return end
    -- do this before updating prof values or get rekt by bugs because refresh triggers a thousand times before anything is even loaded
    if self.tradeskillFrame == nil then return end
    -- similar reasons for the line above apply here
    local db = xb.db.profile
    if not db.modules.tradeskill.enabled then
        self:Disable()
        return
    end

    -- update before doing anything here mister addon creator. if we have no professions, why the fuck would we refresh anything?
    self:UpdateProfValues()
    -- get the hell out of this function if we have no professions
    if not self.firstProf.idx then return end

    -- prepare tradeskillFrame bar width and profession icon size
    local iconSize = db.text.fontSize + db.general.barPadding
    local totalWidth = 0

    -- setting width and position for profession 1 frame
    self:StyleTradeskillFrame('firstProf')
    totalWidth = totalWidth + self.firstProfFrame:GetWidth()
    self.firstProfFrame:SetPoint('LEFT')

    -- setting width and position for profession 2 frame if it exists, otherwise its frame is hidden anyway
    if self.secondProf.idx then
        self:StyleTradeskillFrame('secondProf')
        totalWidth = totalWidth + self.secondProfFrame:GetWidth()
        self.secondProfFrame:SetPoint('LEFT', self.firstProfFrame, 'RIGHT', 5, 0)
    end

    -- final touches on our precious tradeskillFrame
    self.tradeskillFrame:SetSize(totalWidth, xb:GetHeight())
    local relativeAnchorPoint = 'RIGHT'
    local xOffset = db.general.moduleSpacing
    if not xb:GetFrame('clockFrame'):IsVisible() then
        relativeAnchorPoint = 'LEFT'
        xOffset = 0
    end
    self.tradeskillFrame:SetPoint('LEFT', xb:GetFrame('clockFrame'),
                                  relativeAnchorPoint, xOffset, 0)
end

function TradeskillModule:StyleTradeskillFrame(prefix)
    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding
    local icon = xb.constants.mediaPath .. 'profession\\' ..
                     self.profIcons[self[prefix].id]

    local textHeight = floor((xb:GetHeight() - 4) / 2)
    if self[prefix].lvl == self[prefix].maxLvl then
        textHeight = db.text.fontSize
    end

    local barHeight = (iconSize - textHeight - 2)
    if barHeight < 2 then barHeight = 2 end

    self[prefix .. 'Icon']:SetTexture(icon)
    self[prefix .. 'Icon']:SetSize(iconSize, iconSize)
    self[prefix .. 'Icon']:SetPoint('LEFT')
    self[prefix .. 'Icon']:SetVertexColor(xb:GetColor('normal'))

    self[prefix .. 'Text']:SetFont(xb:GetFont(textHeight))
    self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
    self[prefix .. 'Text']:SetText(string.upper(self[prefix].name))

    if self[prefix].lvl == self[prefix].maxLvl then
        self[prefix .. 'Text']:SetPoint('LEFT', self[prefix .. 'Icon'], 'RIGHT',
                                        5, 0)
    else
        self[prefix .. 'Text']:SetPoint('TOPLEFT', self[prefix .. 'Icon'],
                                        'TOPRIGHT', 5, 0)
        self[prefix .. 'Bar']:SetStatusBarTexture("Interface/BUTTONS/WHITE8X8")
        if db.modules.tradeskill.barCC then
            rPerc, gPerc, bPerc, argbHex = xb:GetClassColors()
            self[prefix .. 'Bar']:SetStatusBarColor(rPerc, gPerc, bPerc, 1)
        else
            self[prefix .. 'Bar']:SetStatusBarColor(xb:GetColor('normal'))
        end
        self[prefix .. 'Bar']:SetSize(self[prefix .. 'Text']:GetStringWidth(),
                                      barHeight)
        self[prefix .. 'Bar']:SetPoint('BOTTOMLEFT', self[prefix .. 'Icon'],
                                       'BOTTOMRIGHT', 5, 0)

        self[prefix .. 'BarBg']:SetAllPoints()
        self[prefix .. 'BarBg']:SetColorTexture(db.color.inactive.r,
                                                db.color.inactive.g,
                                                db.color.inactive.b,
                                                db.color.inactive.a)
    end

    self[prefix .. 'Frame']:SetSize(iconSize +
                                        self[prefix .. 'Text']:GetStringWidth() +
                                        5, xb:GetHeight())
end

function TradeskillModule:CreateFrames()
    self.firstProfFrame = self.firstProfFrame or
                              CreateFrame("BUTTON", nil, self.tradeskillFrame)
    self.firstProfIcon = self.firstProfIcon or
                             self.firstProfFrame:CreateTexture(nil, 'OVERLAY')
    self.firstProfText = self.firstProfText or
                             self.firstProfFrame:CreateFontString(nil, 'OVERLAY')
    self.firstProfBar = self.firstProfBar or
                            CreateFrame('STATUSBAR', nil, self.firstProfFrame)
    self.firstProfBarBg = self.firstProfBarBg or
                              self.firstProfBar:CreateTexture(nil, 'BACKGROUND')

    self.secondProfFrame = self.secondProfFrame or
                               CreateFrame("BUTTON", nil, self.tradeskillFrame)
    self.secondProfIcon = self.secondProfIcon or
                              self.secondProfFrame:CreateTexture(nil, 'OVERLAY')
    self.secondProfText = self.secondProfText or
                              self.secondProfFrame:CreateFontString(nil,
                                                                    'OVERLAY')
    self.secondProfBar = self.secondProfBar or
                             CreateFrame('STATUSBAR', nil, self.secondProfFrame)
    self.secondProfBarBg = self.secondProfBarBg or
                               self.secondProfBar:CreateTexture(nil,
                                                                'BACKGROUND')
end

-- function TradeskillModule:SetProfScripts(prefix)
--     self[prefix .. 'Frame']:SetScript('OnMouseDown', function(_, button)
--         if button == 'LeftButton' then
--             -- workaround, toggling spellbooks for tailoring / engineering / inscription is bugged on blizzard's side
--             -- i prefer this over the alternative of casting a spell via SecureActionButtonTemplate frames anyway
--             local currentProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
--             if currentProfessionInfo.professionID == self[prefix].id then
--                 C_TradeSkillUI.CloseTradeSkill()
--                 return
--             end
--             C_TradeSkillUI.OpenTradeSkill(self[prefix].id)
--         elseif button == 'RightButton' then
--             ToggleProfessionsBook()
--         end
--     end)

--     self[prefix .. 'Frame']:SetScript('OnEnter', function()
--         if InCombatLockdown() then return end
--         self[prefix .. 'Text']:SetTextColor(unpack(xb:HoverColors()))
--         if xb.db.profile.modules.tradeskill.showTooltip then
--             if not self.LTip:IsAcquired("TradeskillTooltip") then
--                 self:ShowTooltip()
--             end
--         end
--     end)

--     self[prefix .. 'Frame']:SetScript('OnLeave', function()
--         if InCombatLockdown() then return; end
--         local db = xb.db.profile
--         self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
--         if xb.db.profile.modules.tradeskill.showTooltip then
--             -- self.LTip:Release(self.LTip:Acquire("TradeskillTooltip"))
--             -- GameTooltip:Hide()
--         end
--     end)
-- end

function TradeskillModule:SetProfScripts(prefix)
    self[prefix .. 'Frame']:SetScript('OnMouseDown', function(_, button)
        if button == 'LeftButton' then
            -- workaround, toggling spellbooks for tailoring / engineering / inscription is bugged on blizzard's side
            -- i prefer this over the alternative of casting a spell via SecureActionButtonTemplate frames anyway
            local currentProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
            if currentProfessionInfo.professionID == self[prefix].id then
                C_TradeSkillUI.CloseTradeSkill()
                return
            end
            C_TradeSkillUI.OpenTradeSkill(self[prefix].id)
        elseif button == 'RightButton' then
            ToggleProfessionsBook()
        end
    end)

    self[prefix .. 'Frame']:SetScript('OnEnter', function()
        if InCombatLockdown() then return end
        self[prefix .. 'Text']:SetTextColor(unpack(xb:HoverColors()))
        if xb.db.profile.modules.tradeskill.showTooltip then
            self:ShowTooltip()
        end
    end)

    self[prefix .. 'Frame']:SetScript('OnLeave', function()
        if InCombatLockdown() then return; end
        local db = xb.db.profile
        self[prefix .. 'Text']:SetTextColor(xb:GetColor('normal'))
        if xb.db.profile.modules.tradeskill.showTooltip then
            GameTooltip:Hide()
        end
    end)
end

-- function TradeskillModule:RegisterFrameEvents()
--     self.tradeskillFrame:SetScript('OnEvent', function() self:Refresh() end)
--     self.tradeskillFrame:RegisterEvent('TRADE_SKILL_DETAILS_UPDATE')
--     self.tradeskillFrame:RegisterEvent('SPELLS_CHANGED')
--     self.tradeskillFrame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')

--     self:SetProfScripts('firstProf')
--     self:SetProfScripts('secondProf')

--     self.tradeskillFrame:SetScript('OnEnter', function()
--         if xb.db.profile.modules.tradeskill.showTooltip then
--             if not self.LTip:IsAcquired("TradeskillTooltip") then
--                 self:ShowTooltip()
--             end
--         end
--     end)

--     self.tradeskillFrame:SetScript('OnLeave', function()
--         if xb.db.profile.modules.tradeskill.showTooltip then
--             self.LTip:Release(self.LTip:Acquire("TradeskillTooltip"))
--             -- GameTooltip:Hide()
--         end
--     end)

--     self:RegisterMessage('XIVBar_FrameHide', function(_, name)
--         if name == 'clockFrame' then self:Refresh() end
--     end)

--     self:RegisterMessage('XIVBar_FrameShow', function(_, name)
--         if name == 'clockFrame' then self:Refresh() end
--     end)
-- end

function TradeskillModule:RegisterFrameEvents()
    self.tradeskillFrame:SetScript('OnEvent', function() self:Refresh() end)
    self.tradeskillFrame:RegisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self.tradeskillFrame:RegisterEvent('SPELLS_CHANGED')
    self.tradeskillFrame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')

    self:SetProfScripts('firstProf')
    self:SetProfScripts('secondProf')

    self.tradeskillFrame:SetScript('OnEnter', function()
        if xb.db.profile.modules.tradeskill.showTooltip then
            self:ShowTooltip()
        end
    end)

    self.tradeskillFrame:SetScript('OnLeave', function()
        if xb.db.profile.modules.tradeskill.showTooltip then
            GameTooltip:Hide()
        end
    end)

    self:RegisterMessage('XIVBar_FrameHide', function(_, name)
        if name == 'clockFrame' then self:Refresh() end
    end)

    self:RegisterMessage('XIVBar_FrameShow', function(_, name)
        if name == 'clockFrame' then self:Refresh() end
    end)
end

-- Skin Support for ElvUI/TukUI
-- Make sure to disable "Tooltip" in the Skins section of ElvUI together with 
-- unchecking "Use ElvUI for tooltips" in XIV options to not have ElvUI fuck with tooltips
function TradeskillModule:SkinFrame(frame, name)
    if xb.db.profile.general.useElvUI and
        (IsAddOnLoaded('ElvUI') or IsAddOnLoaded('Tukui')) then
        if frame.StripTextures then frame:StripTextures() end
        if frame.SetTemplate then frame:SetTemplate("Transparent") end

        local close = _G[name .. "CloseButton"] or frame.CloseButton
        if close and close.SetAlpha then
            if ElvUI then
                ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
            end

            if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
                Tukui[1].SkinCloseButton(close)
            end
            close:SetAlpha(1)
        end
    end
end

-- function TradeskillModule:ShowTooltip()
--     local r, g, b = unpack(xb:HoverColors())

--     local tooltip = self.LTip:Acquire("TradeskillTooltip", 2, "LEFT", "RIGHT")

--     tooltip:EnableMouse(true)
--     tooltip:SetScript("OnEnter", function() self.tipHover = true end)
--     tooltip:SetScript("OnLeave", function() self.tipHover = false end)
--     --[[ tooltip:SetScript("OnUpdate", function()
--         if not self.tipHover and not self.lineHover then
--             tooltip:Release()
--         end
--     end) ]]

--     TradeskillModule:SkinFrame(tooltip, "TradeskillTooltip")

--     tooltip:AddHeader("|cFFFFFFFF[|r" .. TRADE_SKILLS .. "|cFFFFFFFF]|r")
--     tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
--     tooltip:AddLine(' ', ' ')

--     if self.firstProf.idx then
--         self:ListTooltipProfession('firstProf', r, g, b, tooltip)
--     end
--     if self.secondProf.idx then
--         self:ListTooltipProfession('secondProf', r, g, b, tooltip)
--     end
--     if self.cook.idx then
--         self:ListTooltipProfession('cook', r, g, b, tooltip)
--     end
--     if self.fish.idx then
--         self:ListTooltipProfession('fish', r, g, b, tooltip)
--     end
--     if self.arch.idx then
--         self:ListTooltipProfession('arch', r, g, b, tooltip)
--     end

--     tooltip:AddLine(' ', ' ')
--     tooltip:AddLine('<' .. L['Left-Click'] .. '>', L['Toggle Profession Frame'])
--     tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
--     tooltip:AddLine('<' .. L['Right-Click'] .. '>',
--                     L['Toggle Profession Spellbook'])
--     tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)

--     tooltip:SmartAnchorTo(self.tradeskillFrame) -- frame is where you want the tooltip to be anchored
--     tooltip:Show()
-- end

function TradeskillModule:ShowTooltip()
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:SetOwner(self.tradeskillFrame, 'ANCHOR_' .. xb.miniTextPosition)
    GameTooltip:AddLine("|cFFFFFFFF[|r" .. TRADE_SKILLS .. "|cFFFFFFFF]|r", r,
                        g, b)
    GameTooltip:AddLine(" ")

    if self.firstProf.idx then
        self:ListTooltipProfession('firstProf', r, g, b)
    end
    if self.secondProf.idx then
        self:ListTooltipProfession('secondProf', r, g, b)
    end
    if self.cook.idx then self:ListTooltipProfession('cook', r, g, b) end
    if self.fish.idx then self:ListTooltipProfession('fish', r, g, b) end
    if self.arch.idx then self:ListTooltipProfession('arch', r, g, b) end

    -- in case there's daily crafts in shadowlands, add a section under the professions for cooldowns
    -- probably works with: C_TradeSkillUI.GetRecipeInfo() and GetSpellCooldown()

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine('<' .. L['Left-Click'] .. '>',
                              L['Toggle Profession Frame'], r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine('<' .. L['Right-Click'] .. '>',
                              L['Toggle Profession Spellbook'], r, g, b, 1, 1, 1)
    GameTooltip:Show()
end

-- Function to handle tooltip clicks
-- local function OnTooltipClick()
--     local spellButton = CreateFrame("Button", "MySecureSpellButton", UIParent,
--                                     "SecureActionButtonTemplate")
--     spellButton:SetAttribute("type", "spell") -- Set the button to cast a spell
--     spellButton:SetAttribute("spell", "2656") -- Set the spell name (or use a spell ID)
--     spellButton:SetSize(1, 1) -- Make it effectively invisible
--     spellButton:SetPoint("CENTER") -- Position it off-screen
--     spellButton:Hide() -- Hide the button
--     -- Secure buttons can only be clicked in response to secure actions, so we simulate the button click
--     spellButton:Click()
-- end

-- function TradeskillModule:ListTooltipProfession(prefix, r, g, b, tooltip)
--     local left = "|T" .. self[prefix].defIcon .. ":0|t " .. self[prefix].name
--     local right = "|cFFFFFFFF" .. self[prefix].lvl .. "|r / " ..
--                       self[prefix].maxLvl
--     tooltip:AddLine(left, right)
--     tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, r, g, b, 1)
--     tooltip:SetLineScript(tooltip:GetLineCount(), "OnMouseUp",
--                           function(self, _, button)
--         -- player left clicks on the friend, checks whether a modifier was used or not after
--         if button == "LeftButton" then
--             OnTooltipClick()
--         elseif button == "RightButton" then
--             CastSpellByName("Mining")
--         end
--     end)
--     -- GameTooltip:AddDoubleLine(left, right, 1, 1, 1, r, g, b)
-- end

function TradeskillModule:ListTooltipProfession(prefix, r, g, b)
    local left = "|T"..self[prefix].defIcon..":0|t "..self[prefix].name
    local right = "|cFFFFFFFF"..self[prefix].lvl.."|r / "..self[prefix].maxLvl
    GameTooltip:AddDoubleLine(left, right, 1, 1, 1, r, g, b)
  end

function TradeskillModule:GetDefaultOptions()
    return 'tradeskill', {enabled = true, barCC = false, showTooltip = true}
end

function TradeskillModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            },
            barCC = {
                name = L['Use Class Colors'],
                order = 2,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.barCC;
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.barCC = val;
                    self:Refresh();
                end
            },
            showTooltip = {
                name = L['Show Tooltips'],
                order = 3,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.tradeskill.showTooltip;
                end,
                set = function(_, val)
                    xb.db.profile.modules.tradeskill.showTooltip = val;
                    self:Refresh();
                end
            }
        }
    }
end
