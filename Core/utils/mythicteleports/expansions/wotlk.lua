local AddOnName, xb = ...
local L = xb.L

-- Wrath of the Lich King mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.WOTLK = {
    name = L["Wrath of the Lich King"],
    order = 3, -- Tenth to last in the list
    teleports = {} -- No teleports currently defined for WOTLK
}
