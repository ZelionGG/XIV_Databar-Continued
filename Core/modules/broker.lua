--------------------------------------------------------------------------------
-- BROKER MODULE
-- Displays third-party LibDataBroker-1.1 data objects on the XIV bar
--------------------------------------------------------------------------------

local AddOnName = ...
---@class XIVBar
local XIVBar = select(2, ...)
local xb = XIVBar
local L = XIVBar.L
local LDB = LibStub("LibDataBroker-1.1")

local BrokerModule = xb:NewModule("BrokerModule", "AceEvent-3.0")

local DISPLAY_TYPES = {
    ["data source"] = true,
    ["launcher"] = true,
}

local function IsUsableAnchor(frame)
    return frame and frame:IsShown() and frame:GetWidth() > 0
end

local function IsDisplayable(name, dataobj)
    if not name or not dataobj then
        return false
    end
    if name == AddOnName then
        return false
    end
    return DISPLAY_TYPES[dataobj.type] == true
end

local function GetBrokerText(name, dataobj)
    if dataobj.text and dataobj.text ~= "" then
        return dataobj.text
    end
    if dataobj.value ~= nil then
        local suffix = dataobj.suffix or ""
        return tostring(dataobj.value) .. suffix
    end
    if dataobj.label and dataobj.label ~= "" then
        return dataobj.label
    end
    return name
end

function BrokerModule:GetName()
    return L["BROKER"] or "Broker"
end

function BrokerModule:OnInitialize()
    self.slots = {}
    self.slotsByName = {}
    self.optionsTable = nil

    LDB.RegisterCallback(self, "LibDataBroker_DataObjectCreated", "OnDataObjectCreated")
    LDB.RegisterCallback(self, "LibDataBroker_AttributeChanged", "OnAttributeChanged")
end

function BrokerModule:OnEnable()
    if self.brokerFrame == nil then
        self.brokerFrame = CreateFrame("FRAME", nil, xb:GetFrame("bar"))
        xb:RegisterFrame("brokerFrame", self.brokerFrame)
    end

    self.brokerFrame:Show()
    self:Refresh()
end

function BrokerModule:OnDisable()
    if self.brokerFrame then
        self.brokerFrame:Hide()
    end
    for _, slot in pairs(self.slots) do
        slot:Hide()
    end
end

function BrokerModule:GetDb()
    return xb.db and xb.db.profile and xb.db.profile.modules and xb.db.profile.modules.Broker
end

function BrokerModule:NotifyOptionsChange()
    local registry = LibStub("AceConfigRegistry-3.0", true)
    if registry then
        registry:NotifyChange(AddOnName .. "_Modules")
    end
end

function BrokerModule:OnDataObjectCreated(_, name, dataobj)
    if not IsDisplayable(name, dataobj) then
        return
    end

    self:RebuildPluginOptions()
    self:NotifyOptionsChange()

    local db = self:GetDb()
    if db and db.enabled and db.enabledObjects and db.enabledObjects[name] then
        self:Refresh()
    end
end

function BrokerModule:OnAttributeChanged(_, name, key, _value, dataobj)
    if not IsDisplayable(name, dataobj) then
        return
    end

    local db = self:GetDb()
    if not db or not db.enabled or not db.enabledObjects or not db.enabledObjects[name] then
        return
    end

    local slot = self.slotsByName[name]
    if not slot or not slot:IsShown() then
        if key == "type" or key == "text" or key == "icon" or key == "label" or key == "value" or key == "suffix" then
            self:Refresh()
        end
        return
    end

    if key == "text" or key == "value" or key == "suffix" or key == "label" then
        self:UpdateSlotContent(slot, name, dataobj)
        if not InCombatLockdown() then
            self:LayoutSlots()
        end
    elseif key == "icon" or key == "iconCoords" or key == "iconR" or key == "iconG" or key == "iconB" then
        self:UpdateSlotIcon(slot, dataobj)
    elseif key == "type" then
        self:Refresh()
    end
end

function BrokerModule:AcquireSlot(name)
    local slot = self.slotsByName[name]
    if slot then
        return slot
    end

    slot = CreateFrame("BUTTON", nil, self.brokerFrame)
    slot.icon = slot:CreateTexture(nil, "OVERLAY")
    slot.text = slot:CreateFontString(nil, "OVERLAY")
    slot:EnableMouse(true)
    slot:RegisterForClicks("AnyUp")
    slot:Hide()

    slot:SetScript("OnEnter", function(button)
        if button.text then
            button.text:SetTextColor(unpack(xb:HoverColors()))
        end
        self:ShowBrokerTooltip(button)
    end)

    slot:SetScript("OnLeave", function(button)
        if button.text then
            button.text:SetTextColor(xb:GetColor("normal"))
        end
        self:HideBrokerTooltip(button)
    end)

    slot:SetScript("OnClick", function(button, mouseButton)
        local dataobj = button.dataobj
        if dataobj and dataobj.OnClick then
            dataobj.OnClick(button, mouseButton)
        end
    end)

    self.slotsByName[name] = slot
    table.insert(self.slots, slot)
    return slot
end

function BrokerModule:UpdateSlotIcon(slot, dataobj)
    local db = xb.db.profile
    local iconSize = db.text.fontSize

    if dataobj.icon then
        slot.icon:SetTexture(dataobj.icon)
        slot.icon:Show()
        if dataobj.iconCoords then
            slot.icon:SetTexCoord(unpack(dataobj.iconCoords))
        else
            slot.icon:SetTexCoord(0, 1, 0, 1)
        end
        local r = dataobj.iconR or 1
        local g = dataobj.iconG or 1
        local b = dataobj.iconB or 1
        slot.icon:SetVertexColor(r, g, b, 1)
        slot.icon:SetSize(iconSize, iconSize)
        slot.icon:ClearAllPoints()
        slot.icon:SetPoint("LEFT")
    else
        slot.icon:Hide()
    end
end

function BrokerModule:UpdateSlotContent(slot, name, dataobj)
    local db = xb.db.profile
    local iconSize = db.text.fontSize
    local text = GetBrokerText(name, dataobj)

    slot.text:SetFont(xb:GetFont(db.text.fontSize))
    slot.text:SetText(text)
    if not slot:IsMouseOver() then
        slot.text:SetTextColor(xb:GetColor("normal"))
    end

    self:UpdateSlotIcon(slot, dataobj)

    local width = 0
    if slot.icon:IsShown() then
        width = width + iconSize
        slot.text:ClearAllPoints()
        if text and text ~= "" then
            slot.text:SetPoint("LEFT", slot.icon, "RIGHT", 3, 0)
            width = width + 3 + slot.text:GetStringWidth()
            slot.text:Show()
        else
            slot.text:Hide()
        end
    else
        slot.text:ClearAllPoints()
        slot.text:SetPoint("LEFT")
        if text and text ~= "" then
            width = slot.text:GetStringWidth()
            slot.text:Show()
        else
            slot.text:Hide()
        end
    end

    slot:SetSize(math.max(width, 1), xb:GetHeight())
end

function BrokerModule:ShowBrokerTooltip(button)
    if not xb:ShouldShowTooltip() then
        return
    end

    local dataobj = button.dataobj
    if not dataobj then
        return
    end

    if dataobj.OnEnter then
        dataobj.OnEnter(button)
        return
    end

    if dataobj.tooltip then
        local tip = dataobj.tooltip
        tip:ClearAllPoints()
        if tip.SetOwner then
            tip:SetOwner(button, "ANCHOR_" .. xb.miniTextPosition)
        else
            local anchor = xb.miniTextPosition == "LEFT" and "RIGHT" or "LEFT"
            tip:SetPoint(anchor, button, xb.miniTextPosition, 0, 0)
        end
        tip:Show()
        return
    end

    if dataobj.OnTooltipShow then
        GameTooltip:SetOwner(button, "ANCHOR_" .. xb.miniTextPosition)
        GameTooltip:ClearLines()
        dataobj.OnTooltipShow(GameTooltip)
        GameTooltip:Show()
    end
end

function BrokerModule:HideBrokerTooltip(button)
    local dataobj = button.dataobj
    if dataobj and dataobj.OnLeave then
        dataobj.OnLeave(button)
        return
    end

    if dataobj and dataobj.tooltip then
        dataobj.tooltip:Hide()
        return
    end

    GameTooltip:Hide()
end

function BrokerModule:GetEnabledBrokerNames()
    local db = self:GetDb()
    local names = {}
    if not db or not db.enabledObjects then
        return names
    end

    for name, enabled in pairs(db.enabledObjects) do
        if enabled then
            local dataobj = LDB:GetDataObjectByName(name)
            if IsDisplayable(name, dataobj) then
                table.insert(names, name)
            end
        end
    end

    table.sort(names)
    return names
end

function BrokerModule:LayoutSlots()
    local names = self:GetEnabledBrokerNames()
    local gap = 5
    local totalWidth = 0
    local previous

    for _, slot in pairs(self.slots) do
        slot:Hide()
    end

    for _, name in ipairs(names) do
        local dataobj = LDB:GetDataObjectByName(name)
        local slot = self:AcquireSlot(name)
        slot.brokerName = name
        slot.dataobj = dataobj
        self:UpdateSlotContent(slot, name, dataobj)

        slot:ClearAllPoints()
        if previous then
            slot:SetPoint("LEFT", previous, "RIGHT", gap, 0)
            totalWidth = totalWidth + gap
        else
            slot:SetPoint("LEFT", self.brokerFrame, "LEFT", 0, 0)
        end

        totalWidth = totalWidth + slot:GetWidth()
        slot:Show()
        previous = slot
    end

    if totalWidth <= 0 then
        self.brokerFrame:SetSize(1, xb:GetHeight())
        self.brokerFrame:Hide()
        return false
    end

    self.brokerFrame:SetSize(totalWidth, xb:GetHeight())
    self.brokerFrame:Show()
    return true
end

function BrokerModule:Refresh()
    local db = self:GetDb()
    if self.brokerFrame == nil then
        return
    end

    if not db or not db.enabled then
        self:Disable()
        return
    end

    if InCombatLockdown() then
        for name, slot in pairs(self.slotsByName) do
            if slot:IsShown() then
                local dataobj = LDB:GetDataObjectByName(name)
                if dataobj then
                    slot.dataobj = dataobj
                    self:UpdateSlotContent(slot, name, dataobj)
                end
            end
        end
        return
    end

    local hasSlots = self:LayoutSlots()
    if not hasSlots then
        return
    end

    if xb:ApplyModuleFreePlacement("Broker", self.brokerFrame) then
        return
    end

    local relativeAnchorPoint = "LEFT"
    local xOffset = xb.db.profile.general.moduleSpacing
    local parentFrame = xb:GetFrame("systemFrame")
    local systemDb = xb.db.profile.modules.system

    if not (systemDb and systemDb.enabled) or not IsUsableAnchor(parentFrame) then
        parentFrame = xb:GetFrame("goldFrame")
        local goldDb = xb.db.profile.modules.gold
        if not (goldDb and goldDb.enabled) or not IsUsableAnchor(parentFrame) then
            parentFrame = xb:GetFrame("travelFrame")
            local travelDb = xb.db.profile.modules.travel
            if not (travelDb and travelDb.enabled) or not IsUsableAnchor(parentFrame) then
                relativeAnchorPoint = "RIGHT"
                xOffset = 15
                parentFrame = self.brokerFrame:GetParent()
            end
        end
    end

    self.brokerFrame:ClearAllPoints()
    self.brokerFrame:SetPoint("RIGHT", parentFrame, relativeAnchorPoint, -xOffset, 0)
end

function BrokerModule:RebuildPluginOptions()
    if not self.optionsTable or not self.optionsTable.args or not self.optionsTable.args.plugins then
        return
    end

    local args = {}
    local order = 1
    local names = {}

    for name, dataobj in LDB:DataObjectIterator() do
        if IsDisplayable(name, dataobj) then
            table.insert(names, name)
        end
    end
    table.sort(names)

    for _, name in ipairs(names) do
        local dataobj = LDB:GetDataObjectByName(name)
        local label = name
        if dataobj.label and dataobj.label ~= "" then
            label = dataobj.label
        end
        local typeLabel = dataobj.type or ""
        args[name] = {
            name = label,
            desc = string.format("%s (%s)", name, typeLabel),
            order = order,
            type = "toggle",
            width = "full",
            get = function()
                local moduleDb = self:GetDb()
                return moduleDb and moduleDb.enabledObjects and moduleDb.enabledObjects[name] == true
            end,
            set = function(_, val)
                local moduleDb = self:GetDb()
                if not moduleDb then
                    return
                end
                moduleDb.enabledObjects = moduleDb.enabledObjects or {}
                if val then
                    moduleDb.enabledObjects[name] = true
                else
                    moduleDb.enabledObjects[name] = nil
                end
                if moduleDb.enabled then
                    self:Refresh()
                end
            end,
        }
        order = order + 1
    end

    if order == 1 then
        args.none = {
            name = L["BROKER_NONE_AVAILABLE"],
            order = 1,
            type = "description",
            fontSize = "medium",
        }
    end

    self.optionsTable.args.plugins.args = args
end

function BrokerModule:GetDefaultOptions()
    return "Broker", {
        enabled = false,
        enabledObjects = {},
    }
end

function BrokerModule:GetConfig()
    self.optionsTable = {
        name = self:GetName(),
        type = "group",
        args = {
            enable = {
                name = ENABLE,
                order = 0,
                type = "toggle",
                width = "full",
                get = function()
                    local moduleDb = self:GetDb()
                    return moduleDb and moduleDb.enabled
                end,
                set = function(_, val)
                    local moduleDb = self:GetDb()
                    if not moduleDb then
                        return
                    end
                    moduleDb.enabled = val
                    if val then
                        self:Enable()
                    else
                        self:Disable()
                    end
                end,
            },
            plugins = {
                name = L["BROKER_PLUGINS"],
                order = 1,
                type = "group",
                inline = true,
                args = {},
            },
        },
    }

    self:RebuildPluginOptions()
    return self.optionsTable
end
