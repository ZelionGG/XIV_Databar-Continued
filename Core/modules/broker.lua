--------------------------------------------------------------------------------
-- BROKER MODULE
-- Displays third-party LibDataBroker-1.1 data objects as independent bar pieces
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

local function SanitizeFrameToken(name)
    return (tostring(name):gsub("[^%w]", "_"))
end

local function PlacementKey(name)
    return "Broker:" .. name
end

local function FrameNameFor(name)
    return "brokerPiece_" .. SanitizeFrameToken(name)
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

local function DefaultShowText(dataobj)
    return dataobj.type ~= "launcher"
end

function BrokerModule:GetName()
    return L["BROKER"] or "Broker"
end

function BrokerModule:GetDb()
    return xb.db and xb.db.profile and xb.db.profile.modules and xb.db.profile.modules.Broker
end

function BrokerModule:GetObjectSettings(name, create)
    local db = self:GetDb()
    if not db then
        return nil
    end
    db.objects = db.objects or {}
    if create and type(db.objects[name]) ~= "table" then
        local dataobj = LDB:GetDataObjectByName(name)
        db.objects[name] = {
            enabled = false,
            showIcon = true,
            showText = dataobj and DefaultShowText(dataobj) or true,
        }
    end
    return db.objects[name]
end

function BrokerModule:MigrateDb()
    local db = self:GetDb()
    if not db then
        return
    end

    db.objects = db.objects or {}

    if type(db.enabledObjects) == "table" then
        for name, enabled in pairs(db.enabledObjects) do
            if enabled then
                local dataobj = LDB:GetDataObjectByName(name)
                local settings = db.objects[name]
                if type(settings) ~= "table" then
                    settings = {
                        enabled = true,
                        showIcon = true,
                        showText = dataobj and DefaultShowText(dataobj) or true,
                    }
                    db.objects[name] = settings
                else
                    settings.enabled = true
                    if settings.showIcon == nil then
                        settings.showIcon = true
                    end
                    if settings.showText == nil then
                        settings.showText = dataobj and DefaultShowText(dataobj) or true
                    end
                end
            end
        end
        db.enabledObjects = nil
    end
end

function BrokerModule:NotifyOptionsChange()
    local registry = LibStub("AceConfigRegistry-3.0", true)
    if registry then
        registry:NotifyChange(AddOnName .. "_Modules")
    end
end

function BrokerModule:OnInitialize()
    self.pieces = {}
    self.registeredCallbacks = {}
    self.activeObjects = {}
    self.optionsTable = nil
    self:MigrateDb()

    LDB.RegisterCallback(self, "LibDataBroker_DataObjectCreated", "OnDataObjectCreated")
end

function BrokerModule:OnEnable()
    self:MigrateDb()
    self:SyncPieces()
    self:Refresh()
end

function BrokerModule:OnDisable()
    local names = {}
    for name in pairs(self.pieces) do
        table.insert(names, name)
    end
    for _, name in ipairs(names) do
        self:DisableObject(name)
    end
end

function BrokerModule:OnDataObjectCreated(_, name, dataobj)
    if not IsDisplayable(name, dataobj) then
        return
    end

    self:RebuildPluginOptions()
    self:NotifyOptionsChange()

    local settings = self:GetObjectSettings(name, false)
    local db = self:GetDb()
    if db and db.enabled and settings and settings.enabled then
        self:EnableObject(name)
        self:Refresh()
    end
end

function BrokerModule:OnAttributeChanged(_, name, key, _value, dataobj)
    local piece = self.pieces[name]
    if not piece or not piece:IsShown() then
        return
    end

    if not IsDisplayable(name, dataobj) then
        return
    end

    piece.dataobj = dataobj

    if key == "text" or key == "value" or key == "suffix" or key == "label" or key == "icon"
        or key == "iconCoords" or key == "iconR" or key == "iconG" or key == "iconB"
        or key == "type" then
        local oldWidth = piece:GetWidth()
        self:UpdatePieceContent(piece)
        if not InCombatLockdown() and abs(piece:GetWidth() - oldWidth) > 0.5 then
            self:RefreshLayoutOnly()
        end
    end
end

function BrokerModule:CreatePiece(name, dataobj)
    local bar = xb:GetFrame("bar")
    if not bar then
        return nil
    end

    local frameName = FrameNameFor(name)
    local piece = CreateFrame("BUTTON", nil, bar)
    piece.icon = piece:CreateTexture(nil, "OVERLAY")
    piece.text = piece:CreateFontString(nil, "OVERLAY")
    piece.brokerName = name
    piece.dataobj = dataobj
    piece.placementKey = PlacementKey(name)
    piece.frameName = frameName
    piece:EnableMouse(true)
    piece:RegisterForClicks("AnyUp")
    piece:EnableMouseWheel(true)
    piece:Hide()

    piece:SetScript("OnEnter", function(button)
        if button.text and button.text:IsShown() then
            button.text:SetTextColor(unpack(xb:HoverColors()))
        end
        self:ShowBrokerTooltip(button)
    end)

    piece:SetScript("OnLeave", function(button)
        if button.text and button.text:IsShown() then
            button.text:SetTextColor(xb:GetColor("normal"))
        end
        self:HideBrokerTooltip(button)
    end)

    piece:SetScript("OnClick", function(button, mouseButton)
        local obj = button.dataobj
        if obj and obj.OnClick then
            obj.OnClick(button, mouseButton)
        end
    end)

    piece:SetScript("OnMouseWheel", function(button, delta)
        local obj = button.dataobj
        if obj and obj.OnMouseWheel then
            obj.OnMouseWheel(button, delta)
        end
    end)

    xb:RegisterFrame(frameName, piece)
    return piece
end

function BrokerModule:GetDisplayName(name, dataobj)
    local label = dataobj and dataobj.label
    if label and label ~= "" then
        return string.format("%s: %s", L["BROKER"] or "Broker", label)
    end
    return string.format("%s: %s", L["BROKER"] or "Broker", name)
end

function BrokerModule:EnableObject(name)
    local dataobj = LDB:GetDataObjectByName(name)
    if not IsDisplayable(name, dataobj) then
        return false
    end

    local settings = self:GetObjectSettings(name, true)
    if not settings then
        return false
    end
    settings.enabled = true
    if settings.showIcon == nil then
        settings.showIcon = true
    end
    if settings.showText == nil then
        settings.showText = DefaultShowText(dataobj)
    end

    local piece = self.pieces[name]
    if not piece then
        piece = self:CreatePiece(name, dataobj)
        if not piece then
            return false
        end
        self.pieces[name] = piece
    else
        piece.dataobj = dataobj
    end

    if not self.activeObjects[name] then
        if xb.RegisterDynamicFreePlacement then
            xb:RegisterDynamicFreePlacement(
                piece.placementKey,
                piece.frameName,
                self:GetDisplayName(name, dataobj),
                self
            )
        end

        if not self.registeredCallbacks[name] then
            LDB.RegisterCallback(self, "LibDataBroker_AttributeChanged_" .. name, "OnAttributeChanged")
            self.registeredCallbacks[name] = true
        end

        self.activeObjects[name] = true
    end

    self:UpdatePieceContent(piece)
    piece:Show()
    return true
end

function BrokerModule:DisableObject(name)
    local piece = self.pieces[name]
    if not piece then
        return
    end

    if self.registeredCallbacks[name] then
        LDB.UnregisterCallback(self, "LibDataBroker_AttributeChanged_" .. name)
        self.registeredCallbacks[name] = nil
    end

    if self.activeObjects[name] and xb.UnregisterDynamicFreePlacement then
        xb:UnregisterDynamicFreePlacement(piece.placementKey)
    end
    self.activeObjects[name] = nil

    piece:Hide()
    piece:ClearAllPoints()
end

function BrokerModule:UpdatePieceContent(piece)
    local name = piece.brokerName
    local dataobj = piece.dataobj or LDB:GetDataObjectByName(name)
    if not dataobj then
        return
    end
    piece.dataobj = dataobj

    local settings = self:GetObjectSettings(name, false) or {}
    local showIcon = settings.showIcon ~= false and dataobj.icon ~= nil
    local showText = settings.showText == true
    local db = xb.db.profile
    local iconSize = db.text.fontSize
    local text = GetBrokerText(name, dataobj)

    if not showText and not showIcon then
        -- Avoid empty invisible hitbox: fall back to label/name text
        showText = true
        text = (dataobj.label and dataobj.label ~= "") and dataobj.label or name
    end

    piece.text:SetFont(xb:GetFont(db.text.fontSize))
    if showText then
        piece.text:SetText(text)
        if not piece:IsMouseOver() then
            piece.text:SetTextColor(xb:GetColor("normal"))
        end
        piece.text:Show()
    else
        piece.text:SetText("")
        piece.text:Hide()
    end

    if showIcon and dataobj.icon then
        piece.icon:SetTexture(dataobj.icon)
        if dataobj.iconCoords then
            piece.icon:SetTexCoord(unpack(dataobj.iconCoords))
        else
            piece.icon:SetTexCoord(0, 1, 0, 1)
        end
        piece.icon:SetVertexColor(dataobj.iconR or 1, dataobj.iconG or 1, dataobj.iconB or 1, 1)
        piece.icon:SetSize(iconSize, iconSize)
        piece.icon:ClearAllPoints()
        piece.icon:SetPoint("LEFT")
        piece.icon:Show()

        piece.text:ClearAllPoints()
        if showText then
            piece.text:SetPoint("LEFT", piece.icon, "RIGHT", 3, 0)
        end
    else
        piece.icon:Hide()
        piece.text:ClearAllPoints()
        piece.text:SetPoint("LEFT")
    end

    local width = 0
    if piece.icon:IsShown() then
        width = width + iconSize
        if showText then
            width = width + 3 + piece.text:GetStringWidth()
        end
    elseif showText then
        width = piece.text:GetStringWidth()
    end

    piece:SetSize(math.max(width, 1), xb:GetHeight())
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

function BrokerModule:GetActiveNames()
    local names = {}
    local db = self:GetDb()
    if not db or not db.objects then
        return names
    end

    for name, settings in pairs(db.objects) do
        if settings and settings.enabled and self.pieces[name] and IsDisplayable(name, LDB:GetDataObjectByName(name)) then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

function BrokerModule:SyncPieces()
    local db = self:GetDb()
    if not db or not db.enabled then
        return
    end

    db.objects = db.objects or {}
    for name, settings in pairs(db.objects) do
        if settings and settings.enabled then
            self:EnableObject(name)
        elseif self.pieces[name] then
            self:DisableObject(name)
        end
    end
end

function BrokerModule:LayoutLegacyCluster()
    local names = self:GetActiveNames()
    local gap = 5
    local previous
    local firstPiece

    for _, name in ipairs(names) do
        local piece = self.pieces[name]
        if piece then
            self:UpdatePieceContent(piece)
            piece:ClearAllPoints()
            if previous then
                piece:SetPoint("LEFT", previous, "RIGHT", gap, 0)
            else
                firstPiece = piece
            end
            piece:Show()
            previous = piece
        end
    end

    if not firstPiece then
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
                parentFrame = firstPiece:GetParent()
            end
        end
    end

    firstPiece:SetPoint("RIGHT", parentFrame, relativeAnchorPoint, -xOffset, 0)
end

function BrokerModule:RefreshLayoutOnly()
    local names = self:GetActiveNames()
    if #names == 0 then
        return
    end

    if xb:IsFreePlacementEnabled() then
        for _, name in ipairs(names) do
            local piece = self.pieces[name]
            if piece then
                piece:Show()
                xb:ApplyModuleFreePlacement(piece.placementKey, piece)
            end
        end
        return
    end

    self:LayoutLegacyCluster()
end

function BrokerModule:Refresh()
    local db = self:GetDb()
    if not db or not db.enabled then
        self:Disable()
        return
    end

    if InCombatLockdown() then
        for _, piece in pairs(self.pieces) do
            if piece:IsShown() then
                local dataobj = LDB:GetDataObjectByName(piece.brokerName)
                if dataobj then
                    piece.dataobj = dataobj
                    self:UpdatePieceContent(piece)
                end
            end
        end
        return
    end

    self:SyncPieces()
    self:RefreshLayoutOnly()
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
        local groupKey = "obj_" .. SanitizeFrameToken(name)

        args[groupKey] = {
            name = string.format("%s (%s)", label, typeLabel),
            order = order,
            type = "group",
            inline = true,
            args = {
                enabled = {
                    name = ENABLE,
                    order = 1,
                    type = "toggle",
                    width = "full",
                    get = function()
                        local settings = self:GetObjectSettings(name, false)
                        return settings and settings.enabled == true
                    end,
                    set = function(_, val)
                        local moduleDb = self:GetDb()
                        if not moduleDb then
                            return
                        end
                        local settings = self:GetObjectSettings(name, true)
                        settings.enabled = val and true or false
                        if moduleDb.enabled then
                            if val then
                                self:EnableObject(name)
                            else
                                self:DisableObject(name)
                            end
                            self:Refresh()
                        end
                    end,
                },
                showIcon = {
                    name = L["BROKER_SHOW_ICON"],
                    order = 2,
                    type = "toggle",
                    get = function()
                        local settings = self:GetObjectSettings(name, true)
                        return settings.showIcon ~= false
                    end,
                    set = function(_, val)
                        local settings = self:GetObjectSettings(name, true)
                        settings.showIcon = val and true or false
                        if self.pieces[name] then
                            self:UpdatePieceContent(self.pieces[name])
                            self:Refresh()
                        end
                    end,
                },
                showText = {
                    name = L["BROKER_SHOW_TEXT"],
                    order = 3,
                    type = "toggle",
                    get = function()
                        local settings = self:GetObjectSettings(name, true)
                        return settings.showText == true
                    end,
                    set = function(_, val)
                        local settings = self:GetObjectSettings(name, true)
                        settings.showText = val and true or false
                        if self.pieces[name] then
                            self:UpdatePieceContent(self.pieces[name])
                            self:Refresh()
                        end
                    end,
                },
            },
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
        objects = {},
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
