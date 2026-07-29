--------------------------------------------------------------------------------
-- DATABROKERS MODULE
-- Displays third-party LibDataBroker-1.1 data objects as independent bar pieces
--------------------------------------------------------------------------------

local AddOnName = ...
---@class XIVBar
local XIVBar = select(2, ...)
local xb = XIVBar
local L = XIVBar.L
local LDB = LibStub("LibDataBroker-1.1")

local DataBrokersModule = xb:NewModule("DataBrokersModule", "AceEvent-3.0")

local DISPLAY_TYPES = {
    ["data source"] = true,
    ["launcher"] = true,
}

local function IsUsableAnchor(frame)
    return frame and frame:IsShown() and frame:GetWidth() > 0
end

local function NormalizeBrokerType(brokerType)
    if type(brokerType) ~= "string" then
        return nil
    end
    return string.lower((brokerType:gsub("^%s+", ""):gsub("%s+$", "")))
end

local function IsBrokerCandidate(name, dataobj)
    if not name or not dataobj then
        return false
    end
    if name == AddOnName then
        return false
    end
    local brokerType = NormalizeBrokerType(dataobj.type)
    return brokerType and DISPLAY_TYPES[brokerType] == true
end

local function IsTypeFilterEnabled(module, key)
    -- Prefer in-memory mirrors so option toggles apply even if AceDB readback lags
    if module[key] ~= nil then
        return module[key] and true or false
    end
    local db = module.GetDb and module:GetDb()
    if not db or db[key] == nil then
        return true
    end
    return db[key] and true or false
end

local function IsTypeAllowed(dataobj)
    local brokerType = dataobj and NormalizeBrokerType(dataobj.type)
    if not brokerType or not DISPLAY_TYPES[brokerType] then
        return false
    end

    if brokerType == "data source" then
        return IsTypeFilterEnabled(DataBrokersModule, "showDataSources")
    end
    if brokerType == "launcher" then
        return IsTypeFilterEnabled(DataBrokersModule, "showLaunchers")
    end
    return false
end

local function IsDisplayable(name, dataobj)
    return IsBrokerCandidate(name, dataobj) and IsTypeAllowed(dataobj)
end

local function HasVisibleBrokerPlugins()
    for name, dataobj in LDB:DataObjectIterator() do
        if IsDisplayable(name, dataobj) then
            return true
        end
    end
    return false
end

local function SanitizeFrameToken(name)
    return (tostring(name):gsub("[^%w]", "_"))
end

local function PlacementKey(name)
    return "DataBrokers:" .. name
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

local function GetBrokerLabel(name, dataobj)
    if dataobj and dataobj.label and dataobj.label ~= "" then
        return dataobj.label
    end
    return name
end

local function GetBrokerSource(dataobj)
    if not dataobj then
        return nil
    end
    local source = dataobj.parent or dataobj.tocname
    if type(source) == "string" and source ~= "" then
        return source
    end
    return nil
end

local function DefaultShowText(dataobj)
    return NormalizeBrokerType(dataobj and dataobj.type) ~= "launcher"
end

local function IsObjectEnabled(name)
    local settings = DataBrokersModule:GetObjectSettings(name, false)
    return settings and settings.enabled == true
end

function DataBrokersModule:GetName()
    return L["DATABROKERS"] or "DataBrokers"
end

function DataBrokersModule:GetDb()
    return xb.db and xb.db.profile and xb.db.profile.modules and xb.db.profile.modules.dataBrokers
end

function DataBrokersModule:GetObjectSettings(name, create)
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

function DataBrokersModule:MigrateDb()
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

function DataBrokersModule:SyncTypeFilterMirrors()
    local db = self:GetDb()
    if not db then
        self.showDataSources = true
        self.showLaunchers = true
        return
    end
    self.showDataSources = db.showDataSources ~= false
    self.showLaunchers = db.showLaunchers ~= false
end

function DataBrokersModule:NotifyOptionsChange()
    local appName = AddOnName .. "_Modules"
    local registry = LibStub("AceConfigRegistry-3.0", true)
    if registry then
        registry:NotifyChange(appName)
    end
end

function DataBrokersModule:ApplyTypeFilter()
    self:SyncTypeFilterMirrors()

    local moduleDb = self:GetDb()
    if moduleDb and moduleDb.enabled then
        if not self:IsEnabled() then
            self:Enable()
        else
            self:SyncPieces()
            self:RefreshLayoutOnly()
        end
    else
        self:SyncPieces()
    end

    -- Keep all candidates registered; visibility is via hidden() so Blizzard Settings
    -- and AceConfigDialog both drop filtered groups on the next feed/refresh.
    self:RebuildPluginOptions()
    self:NotifyOptionsChange()
end

function DataBrokersModule:OnInitialize()
    self.pieces = {}
    self.registeredCallbacks = {}
    self.activeObjects = {}
    self.optionsTable = nil
    self:MigrateDb()
    self:SyncTypeFilterMirrors()

    LDB.RegisterCallback(self, "LibDataBroker_DataObjectCreated", "OnDataObjectCreated")
end

function DataBrokersModule:OnEnable()
    self:MigrateDb()
    self:SyncTypeFilterMirrors()
    self:SyncPieces()
    self:Refresh()
end

function DataBrokersModule:OnDisable()
    local names = {}
    for name in pairs(self.pieces) do
        table.insert(names, name)
    end
    for _, name in ipairs(names) do
        self:DisableObject(name)
    end
end

function DataBrokersModule:OnDataObjectCreated(_, name, dataobj)
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

function DataBrokersModule:OnAttributeChanged(_, name, key, _value, dataobj)
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

function DataBrokersModule:CreatePiece(name, dataobj)
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

function DataBrokersModule:GetDisplayName(name, dataobj)
    local label = GetBrokerLabel(name, dataobj)
    local source = GetBrokerSource(dataobj)
    local moduleName = L["DATABROKERS"] or "DataBrokers"
    if source and source ~= label then
        return string.format("%s: %s | %s", moduleName, source, label)
    end
    return string.format("%s: %s", moduleName, label)
end

function DataBrokersModule:EnableObject(name)
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

function DataBrokersModule:DisableObject(name)
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

function DataBrokersModule:UpdatePieceContent(piece)
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
    local moduleDb = self:GetDb()
    local iconSize = settings.iconSize
        or (moduleDb and moduleDb.iconSize)
        or db.text.fontSize
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

function DataBrokersModule:ShowBrokerTooltip(button)
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

function DataBrokersModule:HideBrokerTooltip(button)
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

function DataBrokersModule:GetActiveNames()
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

function DataBrokersModule:SyncPieces()
    local db = self:GetDb()
    if not db or not db.enabled then
        local toDisable = {}
        for name in pairs(self.pieces) do
            table.insert(toDisable, name)
        end
        for _, name in ipairs(toDisable) do
            self:DisableObject(name)
        end
        return
    end

    db.objects = db.objects or {}

    -- Hide anything that should not be visible (type filter, object off, missing LDB)
    local toDisable = {}
    for name in pairs(self.pieces) do
        local dataobj = LDB:GetDataObjectByName(name)
        local settings = db.objects[name]
        local shouldShow = settings and settings.enabled and IsDisplayable(name, dataobj)
        if not shouldShow then
            table.insert(toDisable, name)
        end
    end
    for _, name in ipairs(toDisable) do
        self:DisableObject(name)
    end

    for name, settings in pairs(db.objects) do
        local dataobj = LDB:GetDataObjectByName(name)
        if settings and settings.enabled and IsDisplayable(name, dataobj) then
            self:EnableObject(name)
        end
    end
end

function DataBrokersModule:HideInactivePieces(activeSet)
    for name, piece in pairs(self.pieces) do
        if not activeSet[name] then
            piece:Hide()
            piece:ClearAllPoints()
        end
    end
end

function DataBrokersModule:LayoutLegacyCluster()
    local names = self:GetActiveNames()
    local activeSet = {}
    for _, name in ipairs(names) do
        activeSet[name] = true
    end
    self:HideInactivePieces(activeSet)

    local gap = 5
    local previous
    local firstPiece

    for _, name in ipairs(names) do
        local piece = self.pieces[name]
        if piece then
            self:UpdatePieceContent(piece)
            piece:ClearAllPoints()
            if previous then
                -- Grow leftward away from system/gold/travel anchors
                piece:SetPoint("RIGHT", previous, "LEFT", -gap, 0)
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

function DataBrokersModule:RefreshLayoutOnly()
    local names = self:GetActiveNames()
    local activeSet = {}
    for _, name in ipairs(names) do
        activeSet[name] = true
    end
    self:HideInactivePieces(activeSet)

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

function DataBrokersModule:Refresh()
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

function DataBrokersModule:RebuildPluginOptions()
    if not self.optionsTable or not self.optionsTable.args then
        return
    end

    local rootArgs = self.optionsTable.args

    -- Drop previous dynamically generated source groups / empty notice
    local staleKeys = {}
    for key in pairs(rootArgs) do
        if type(key) == "string" and (key == "none" or string.sub(key, 1, 4) == "src_") then
            table.insert(staleKeys, key)
        end
    end
    for _, key in ipairs(staleKeys) do
        rootArgs[key] = nil
    end

    local names = {}
    for name, dataobj in LDB:DataObjectIterator() do
        if IsBrokerCandidate(name, dataobj) then
            table.insert(names, name)
        end
    end
    table.sort(names, function(a, b)
        local dataobjA = LDB:GetDataObjectByName(a)
        local dataobjB = LDB:GetDataObjectByName(b)
        local sourceA = GetBrokerSource(dataobjA)
        local sourceB = GetBrokerSource(dataobjB)
        if sourceA ~= sourceB then
            if not sourceA then
                return false
            end
            if not sourceB then
                return true
            end
            return sourceA < sourceB
        end
        local labelA = GetBrokerLabel(a, dataobjA)
        local labelB = GetBrokerLabel(b, dataobjB)
        if labelA ~= labelB then
            return labelA < labelB
        end
        return a < b
    end)

    local sourceOrder = 10
    local sourceMeta = {}
    local brokerOrder = {}

    local function IsModuleDisabled()
        local moduleDb = DataBrokersModule:GetDb()
        return not (moduleDb and moduleDb.enabled)
    end

    for _, name in ipairs(names) do
        local dataobj = LDB:GetDataObjectByName(name)
        local label = GetBrokerLabel(name, dataobj)
        local source = GetBrokerSource(dataobj)
        local typeLabel = NormalizeBrokerType(dataobj.type) or dataobj.type or ""
        local groupKey = "obj_" .. SanitizeFrameToken(name)
        local groupName = string.format("%s (%s)", label, typeLabel)

        local sourceKey, sourceName
        if source then
            sourceName = source
            sourceKey = "src_" .. SanitizeFrameToken(source)
        else
            sourceName = L["DATABROKERS_OTHER"] or "Other"
            sourceKey = "src_other"
        end

        local meta = sourceMeta[sourceKey]
        if not meta then
            meta = {
                name = sourceName,
                order = sourceOrder,
                brokers = {},
            }
            sourceOrder = sourceOrder + 1
            sourceMeta[sourceKey] = meta
            brokerOrder[sourceKey] = 1
        end
        table.insert(meta.brokers, name)

        local order = brokerOrder[sourceKey]
        brokerOrder[sourceKey] = order + 1

        if not rootArgs[sourceKey] then
            local brokersForHidden = meta.brokers
            rootArgs[sourceKey] = {
                name = meta.name,
                order = meta.order,
                type = "group",
                hidden = function()
                    for _, brokerName in ipairs(brokersForHidden) do
                        if IsDisplayable(brokerName, LDB:GetDataObjectByName(brokerName)) then
                            return false
                        end
                    end
                    return true
                end,
                args = {},
            }
        end

        rootArgs[sourceKey].args[groupKey] = {
            name = groupName,
            order = order,
            type = "group",
            inline = true,
            disabled = IsModuleDisabled,
            hidden = function()
                return not IsDisplayable(name, LDB:GetDataObjectByName(name))
            end,
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
                        self:NotifyOptionsChange()
                    end,
                },
                showIcon = {
                    name = L["DATABROKERS_SHOW_ICON"],
                    order = 2,
                    type = "toggle",
                    hidden = function()
                        return not IsObjectEnabled(name)
                    end,
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
                    name = L["DATABROKERS_SHOW_TEXT"],
                    order = 3,
                    type = "toggle",
                    hidden = function()
                        return not IsObjectEnabled(name)
                    end,
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
                iconSize = {
                    name = L["DATABROKERS_ICON_SIZE"],
                    order = 4,
                    type = "range",
                    min = 8,
                    max = 40,
                    step = 1,
                    hidden = function()
                        return not IsObjectEnabled(name)
                    end,
                    get = function()
                        local settings = self:GetObjectSettings(name, true)
                        local moduleDb = self:GetDb()
                        return settings.iconSize
                            or (moduleDb and moduleDb.iconSize)
                            or 12
                    end,
                    set = function(_, val)
                        local settings = self:GetObjectSettings(name, true)
                        settings.iconSize = val
                        if self.pieces[name] then
                            self:UpdatePieceContent(self.pieces[name])
                            self:Refresh()
                        end
                    end,
                },
            },
        }
    end

    rootArgs.none = {
        name = L["DATABROKERS_NONE_AVAILABLE"],
        order = 1000,
        type = "description",
        fontSize = "medium",
        hidden = function()
            return HasVisibleBrokerPlugins()
        end,
    }
end

function DataBrokersModule:GetDefaultOptions()
    return "dataBrokers", {
        enabled = false,
        showDataSources = true,
        showLaunchers = true,
        iconSize = 12,
        objects = {},
    }
end

function DataBrokersModule:GetConfig()
    self.optionsTable = {
        name = self:GetName(),
        type = "group",
        childGroups = "tree",
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
                    self:NotifyOptionsChange()
                end,
            },
            showDataSources = {
                name = L["DATABROKERS_SHOW_DATA_SOURCES"],
                order = 0.1,
                type = "toggle",
                width = "full",
                disabled = function()
                    local moduleDb = self:GetDb()
                    return not (moduleDb and moduleDb.enabled)
                end,
                get = function()
                    return IsTypeFilterEnabled(self, "showDataSources")
                end,
                set = function(_, val)
                    local moduleDb = self:GetDb()
                    if not moduleDb then
                        return
                    end
                    moduleDb.showDataSources = val and true or false
                    self.showDataSources = moduleDb.showDataSources
                    self:ApplyTypeFilter()
                end,
            },
            showLaunchers = {
                name = L["DATABROKERS_SHOW_LAUNCHERS"],
                order = 0.2,
                type = "toggle",
                width = "full",
                disabled = function()
                    local moduleDb = self:GetDb()
                    return not (moduleDb and moduleDb.enabled)
                end,
                get = function()
                    return IsTypeFilterEnabled(self, "showLaunchers")
                end,
                set = function(_, val)
                    local moduleDb = self:GetDb()
                    if not moduleDb then
                        return
                    end
                    moduleDb.showLaunchers = val and true or false
                    self.showLaunchers = moduleDb.showLaunchers
                    self:ApplyTypeFilter()
                end,
            },
            iconSize = {
                name = L["DATABROKERS_ICON_SIZE"],
                order = 0.3,
                type = "range",
                min = 8,
                max = 40,
                step = 1,
                disabled = function()
                    local moduleDb = self:GetDb()
                    return not (moduleDb and moduleDb.enabled)
                end,
                get = function()
                    local moduleDb = self:GetDb()
                    return (moduleDb and moduleDb.iconSize) or 12
                end,
                set = function(_, val)
                    local moduleDb = self:GetDb()
                    if not moduleDb then
                        return
                    end
                    moduleDb.iconSize = val
                    self:Refresh()
                end,
            },
        },
    }

    self:SyncTypeFilterMirrors()
    self:RebuildPluginOptions()
    return self.optionsTable
end
