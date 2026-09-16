--------------------------------------------------------------------------------
-- Mage teleport / portal spell IDs by game flavor.
-- Add a `forever` table later; GetFlavorKey() only needs a new compat branch.
-- Spell IDs are from Wowhead (classic/retail spell pages). Labels come from the
-- client via GetSpellName, so destination names stay localized.
--------------------------------------------------------------------------------

---@class XIVBar
local XIVBar = select(2, ...)
local xb = XIVBar
local compat = xb.compat

xb.MagePortals = xb.MagePortals or {}
local MagePortals = xb.MagePortals

-- Classic Era capitals
-- Teleport: Stormwind 3561 / Portal: Stormwind 10059
-- Teleport: Ironforge 3562 / Portal: Ironforge 11416
-- Teleport: Darnassus 3565 / Portal: Darnassus 11419
-- Teleport: Orgrimmar 3567 / Portal: Orgrimmar 11417
-- Teleport: Undercity 3563 / Portal: Undercity 11418
-- Teleport: Thunder Bluff 3566 / Portal: Thunder Bluff 11420
local classicDestinations = {
    { key = "stormwind", faction = "Alliance", teleportId = 3561, portalId = 10059 },
    { key = "ironforge", faction = "Alliance", teleportId = 3562, portalId = 11416 },
    { key = "darnassus", faction = "Alliance", teleportId = 3565, portalId = 11419 },
    { key = "orgrimmar", faction = "Horde", teleportId = 3567, portalId = 11417 },
    { key = "undercity", faction = "Horde", teleportId = 3563, portalId = 11418 },
    { key = "thunderBluff", faction = "Horde", teleportId = 3566, portalId = 11420 },
}

-- TBC additions (Exodar, Silvermoon, Shattrath, Theramore, Stonard)
local tbcDestinations = {
    { key = "exodar", faction = "Alliance", teleportId = 32271, portalId = 32266 },
    { key = "theramore", faction = "Alliance", teleportId = 49359, portalId = 49360 },
    { key = "silvermoon", faction = "Horde", teleportId = 32272, portalId = 32267 },
    { key = "stonard", faction = "Horde", teleportId = 49358, portalId = 49361 },
    { key = "shattrathAlliance", faction = "Alliance", teleportId = 33690, portalId = 33691 },
    { key = "shattrathHorde", faction = "Horde", teleportId = 35715, portalId = 35717 },
}

-- MoP Classic also includes WotLK Dalaran, Cata Tol Barad, Ancient Dalaran, Vale
local mopDestinations = {
    { key = "dalaranNorthrend", teleportId = 53140, portalId = 53142 },
    { key = "tolBaradAlliance", faction = "Alliance", teleportId = 88342, portalId = 88345 },
    { key = "tolBaradHorde", faction = "Horde", teleportId = 88344, portalId = 88346 },
    { key = "ancientDalaran", teleportId = 120145, portalId = 120146 },
    { key = "valeAlliance", faction = "Alliance", teleportId = 132621, portalId = 132620 },
    { key = "valeHorde", faction = "Horde", teleportId = 132627, portalId = 132626 },
}

-- Retail extras (WoD through Midnight). Hall of the Guardian is teleport-only
-- (no portal). It stays on the Port button and is also listed as a teleport.
local mainlineDestinations = {
    { key = "hallOfTheGuardian", teleportId = 193759 },
    { key = "stormshield", faction = "Alliance", teleportId = 176248, portalId = 176246 },
    { key = "warspear", faction = "Horde", teleportId = 176242, portalId = 176244 },
    { key = "dalaranBrokenIsles", teleportId = 224869, portalId = 224871 },
    { key = "boralus", faction = "Alliance", teleportId = 281403, portalId = 281400 },
    { key = "dazaralor", faction = "Horde", teleportId = 281404, portalId = 281402 },
    { key = "oribos", teleportId = 344587, portalId = 344597 },
    { key = "valdrakken", teleportId = 395277, portalId = 395289 },
    { key = "dornogal", teleportId = 446540, portalId = 446534 },
    { key = "silvermoonCity", teleportId = 1259190, portalId = 1259194 },
}

local function AppendDestinations(target, source)
    for i = 1, #source do
        target[#target + 1] = source[i]
    end
end

local function BuildFlavorList(...)
    local list = {}
    for i = 1, select("#", ...) do
        AppendDestinations(list, select(i, ...))
    end
    return list
end

MagePortals.classic = classicDestinations
MagePortals.tbc = BuildFlavorList(classicDestinations, tbcDestinations)
MagePortals.mop = BuildFlavorList(classicDestinations, tbcDestinations, mopDestinations)
MagePortals.mainline = BuildFlavorList(classicDestinations, tbcDestinations, mopDestinations, mainlineDestinations)
-- MagePortals.forever = { ... }

function MagePortals:GetFlavorKey()
    if not compat then
        return "classic"
    end
    if compat.isMainline then
        return "mainline"
    end
    if compat.isMists or compat.isClassicProgression then
        return "mop"
    end
    if compat.isTBC then
        return "tbc"
    end
    return "classic"
end

function MagePortals:GetDestinations()
    local list = self[self:GetFlavorKey()] or self.classic
    local faction = xb.constants and xb.constants.playerFactionLocal
    local filtered = {}
    for i = 1, #list do
        local dest = list[i]
        if not dest.faction or dest.faction == faction then
            filtered[#filtered + 1] = dest
        end
    end
    return filtered
end

function MagePortals:GetSpellName(spellId)
    if not spellId then
        return nil
    end

    if C_Spell and C_Spell.GetSpellName then
        local name = C_Spell.GetSpellName(spellId)
        if name then
            return name
        end
    end

    if C_Spell and C_Spell.GetSpellInfo then
        local spellInfo = C_Spell.GetSpellInfo(spellId)
        if spellInfo and spellInfo.name then
            return spellInfo.name
        end
    end

    if GetSpellInfo then
        local spellInfo = GetSpellInfo(spellId)
        if type(spellInfo) == "table" then
            return spellInfo.name
        end
        return spellInfo
    end

    return nil
end

function MagePortals:GetSpellIcon(spellId)
    if not spellId then
        return nil
    end

    if C_Spell and C_Spell.GetSpellTexture then
        local texture = C_Spell.GetSpellTexture(spellId)
        if texture then
            return texture
        end
    end

    if C_Spell and C_Spell.GetSpellInfo then
        local spellInfo = C_Spell.GetSpellInfo(spellId)
        if type(spellInfo) == "table" then
            return spellInfo.iconID or spellInfo.originalIconID or spellInfo.icon
        end
    end

    if GetSpellTexture then
        local texture = GetSpellTexture(spellId)
        if texture then
            return texture
        end
    end

    if GetSpellInfo then
        local name, _, icon = GetSpellInfo(spellId)
        if type(name) == "table" then
            return name.iconID or name.originalIconID or name.icon
        end
        return icon
    end

    return nil
end

function MagePortals:FormatIconLabel(icon, text, size)
    if not text then
        return text
    end
    if not icon then
        return text
    end
    size = size or 14
    return "|T" .. icon .. ":" .. size .. ":" .. size .. ":0:0|t " .. text
end

function MagePortals:IsKnown(spellId)
    return spellId and IsPlayerSpell(spellId) and true or false
end

local function CollectKnown(destinations, idKey, kind)
    local result = {}
    for i = 1, #destinations do
        local dest = destinations[i]
        local spellId = dest[idKey]
        if MagePortals:IsKnown(spellId) then
            local name = MagePortals:GetSpellName(spellId)
            if name then
                result[#result + 1] = {
                    spellId = spellId,
                    name = name,
                    icon = MagePortals:GetSpellIcon(spellId),
                    key = dest.key,
                    kind = kind,
                }
            end
        end
    end
    table.sort(result, function(a, b)
        return a.name < b.name
    end)
    return result
end

function MagePortals:GetKnownSpells()
    local destinations = self:GetDestinations()
    return CollectKnown(destinations, "teleportId", "teleport"),
           CollectKnown(destinations, "portalId", "portal")
end

-- Order Teleports / Portals by the localized header, not a hardcoded English order.
function MagePortals:GetSortedKnownCategories()
    local teleports, portals = self:GetKnownSpells()
    local L = xb.L
    local categories = {}
    if #teleports > 0 then
        categories[#categories + 1] = {
            kind = "teleport",
            label = L["MAGE_TELEPORTS"],
            list = teleports,
        }
    end
    if #portals > 0 then
        categories[#categories + 1] = {
            kind = "portal",
            label = L["MAGE_PORTAL_SPELLS"],
            list = portals,
        }
    end
    table.sort(categories, function(a, b)
        return a.label < b.label
    end)
    return categories
end

function MagePortals:HasKnownSpells()
    local teleports, portals = self:GetKnownSpells()
    return (#teleports + #portals) > 0
end

function MagePortals:FindKnownSpell(spellId)
    if not spellId then
        return nil
    end
    local teleports, portals = self:GetKnownSpells()
    for i = 1, #teleports do
        if teleports[i].spellId == spellId then
            return teleports[i]
        end
    end
    for i = 1, #portals do
        if portals[i].spellId == spellId then
            return portals[i]
        end
    end
    return nil
end

function MagePortals:GetFirstKnown()
    local teleports, portals = self:GetKnownSpells()
    return teleports[1] or portals[1]
end

function MagePortals:GetCooldownRemaining(spellId)
    if not spellId then
        return 0
    end

    local startTime, duration
    if C_Spell and C_Spell.GetSpellCooldown then
        local info, extra = C_Spell.GetSpellCooldown(spellId)
        if type(info) == "table" then
            startTime = info.startTime
            duration = info.duration
        else
            startTime, duration = info, extra
        end
    elseif GetSpellCooldown then
        startTime, duration = GetSpellCooldown(spellId)
    end

    -- Ignore the GCD (about 1.5s). Teleports/portals do not share a category CD.
    if type(startTime) == "number" and type(duration) == "number" and duration > 2 then
        return math.max(0, startTime + duration - GetTime())
    end
    return 0
end

function MagePortals:GetOnCooldownSpells(excludeSpellId)
    local teleports, portals = self:GetKnownSpells()
    local result = {}
    local function addFrom(list)
        for i = 1, #list do
            local spell = list[i]
            if spell.spellId ~= excludeSpellId then
                local remaining = self:GetCooldownRemaining(spell.spellId)
                if remaining > 0 then
                    result[#result + 1] = {
                        spellId = spell.spellId,
                        name = spell.name,
                        icon = spell.icon,
                        remaining = remaining,
                    }
                end
            end
        end
    end
    addFrom(teleports)
    addFrom(portals)
    table.sort(result, function(a, b)
        return a.name < b.name
    end)
    return result
end
