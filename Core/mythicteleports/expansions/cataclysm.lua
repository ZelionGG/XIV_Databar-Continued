local AddOnName, xb = ...
local L = xb.L

-- Cataclysm mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.CATA = {
    name = L["Cataclysm"],
    order = 4, -- Ninth to last in the list
    teleports = {
        GB = {
            teleportId = 445424, -- Grim Batol Teleport
            dungeonId = 304 -- Grim Batol
        },
        VP = {
            teleportId = 410080, -- The Vortex Pinnacle Teleport
            dungeonId = 311 -- The Vortex Pinnacle
        },
        TotT = {
            teleportId = 424142, -- Throne of the Tides Teleport
            dungeonId = 302 -- Throne of the Tides
        }
    }
}
