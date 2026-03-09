local _, xb = ...
local L = xb.L

-- Wrath of the Lich King mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.WOTLK = {
    name = L["Wrath of the Lich King"],
    order = 3, -- Tenth to last in the list
    teleports = {
        PoS = { -- Pit of Saron
            teleportId = 1254555,
            dungeonId = 3113
        },
    }
}
