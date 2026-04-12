---@class XIVBar
local XIVBar = select(2, ...);
local xb = XIVBar;
local L = XIVBar.L;

local TravelModule = xb:NewModule("TravelModule", 'AceEvent-3.0')

function TravelModule:GetName()
    return L["TRAVEL"];
end

function TravelModule:OnInitialize()
    self.hearthstones = {
        184871, -- Dark Portal
        6948 -- Hearthstone
    }
end

function TravelModule:OnEnable()
    if self.hearthFrame == nil then
        self.hearthFrame = CreateFrame('FRAME', nil, xb:GetFrame('bar'))
        xb:RegisterFrame('travelFrame', self.hearthFrame)
    end
    self.hearthFrame:Show()
    self:CreateFrames()
    self:RegisterFrameEvents()
    self:Refresh()
end

function TravelModule:OnDisable()
    self.hearthFrame:Hide()
    self:UnregisterEvent('SPELLS_CHANGED')
    self:UnregisterEvent('BAG_UPDATE_DELAYED')
    self:UnregisterEvent('HEARTHSTONE_BOUND')
end

function TravelModule:CreateFrames()
    self.hearthButton = self.hearthButton or
                            CreateFrame('BUTTON', 'hearthButton', self.hearthFrame, 'SecureActionButtonTemplate')
    self.hearthIcon = self.hearthIcon or self.hearthButton:CreateTexture(nil, 'OVERLAY')
    self.hearthText = self.hearthText or self.hearthButton:CreateFontString(nil, 'OVERLAY')
end

function TravelModule:RegisterFrameEvents()
    self:RegisterEvent('SPELLS_CHANGED', 'Refresh')
    self:RegisterEvent('BAG_UPDATE_DELAYED', 'Refresh')
    self:RegisterEvent('HEARTHSTONE_BOUND', 'Refresh')
    self.hearthButton:EnableMouse(true)
    self.hearthButton:RegisterForClicks('AnyUp')
    self.hearthButton:SetAttribute('type', 'macro')

    self.hearthButton:SetScript('OnEnter', function()
        TravelModule:SetHearthColor()
    end)

    self.hearthButton:SetScript('OnLeave', function()
        TravelModule:SetHearthColor()
    end)
end

function TravelModule:SetHearthColor()
    if InCombatLockdown() then
        return;
    end

    if self.hearthButton:IsMouseOver() then
        self.hearthText:SetTextColor(unpack(xb:HoverColors()))
    else
        self.hearthIcon:SetVertexColor(xb:GetColor('normal'))
        for _, v in ipairs(self.hearthstones) do
            if IsUsableItem(v) then
                if C_Container.GetItemCooldown(v) == 0 then
                    local hearthName = GetItemInfo(v)
                    if hearthName ~= nil then
                        self.hearthButton:SetAttribute("macrotext", "/cast " .. hearthName)
                        break
                    end
                end
            end -- if toy/item
            if IsPlayerSpell(v) then
                if GetSpellCooldown(v) == 0 then
                    local spellInfo = GetSpellInfo(v)
                    local hearthName = spellInfo and spellInfo.name
                    self.hearthButton:SetAttribute("macrotext", "/cast " .. hearthName)
                end
            end -- if is spell
        end -- for hearthstones
        self.hearthText:SetTextColor(xb:GetColor('normal'))
    end -- else
end

function TravelModule:Refresh()
    if self.hearthFrame == nil then
        return;
    end

    if not xb.db.profile.modules.travel.enabled then
        self:Disable();
        return;
    end
    if InCombatLockdown() then
        self.hearthText:SetText(GetBindLocation())
        self:SetHearthColor()
        return
    end

    local db = xb.db.profile
    local iconSize = db.text.fontSize + db.general.barPadding

    self.hearthText:SetFont(xb:GetFont(db.text.fontSize))
    self.hearthText:SetText(GetBindLocation())

    self.hearthButton:SetSize(self.hearthText:GetWidth() + iconSize + db.general.barPadding, xb:GetHeight())
    self.hearthButton:SetPoint("RIGHT")

    self.hearthText:SetPoint("RIGHT")

    self.hearthIcon:SetTexture(xb.constants.mediaPath .. 'datatexts\\hearth')
    self.hearthIcon:SetSize(iconSize, iconSize)

    self.hearthIcon:SetPoint("RIGHT", self.hearthText, "LEFT", -(db.general.barPadding), 0)

    self:SetHearthColor()

    local totalWidth = self.hearthButton:GetWidth() + db.general.barPadding
    self.hearthFrame:SetSize(totalWidth, xb:GetHeight())

    if xb:ApplyModuleFreePlacement('travel', self.hearthFrame) then
        self.hearthFrame:Show()
        return
    end

    self.hearthFrame:ClearAllPoints()
    self.hearthFrame:SetPoint("RIGHT", -(db.general.barPadding), 0)
    self.hearthFrame:Show()
end

function TravelModule:GetDefaultOptions()
    return 'travel', {
        enabled = true
    }
end

function TravelModule:GetConfig()
    return {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                get = function()
                    return xb.db.profile.modules.travel.enabled;
                end,
                set = function(_, val)
                    xb.db.profile.modules.travel.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
                width = "full"
            }
        }
    }
end
