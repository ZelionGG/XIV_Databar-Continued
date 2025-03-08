local AddOnName, xb = ...
local L = xb.L

-- Legion mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.LEGION = {
    name = L["Legion"],
    order = 7, -- Sixth to last in the list
    teleports = {
        BRH = {
            teleportId = 424153, -- Black Rook Hold Teleport
            dungeonId = 1204 -- Black Rook Hold
        },
        COS = {
            teleportId = 393766, -- Court of Stars Teleport
            dungeonId = 1318 -- Court of Stars
        },
        DHT = {
            teleportId = 424163, -- Darkheart Thicket Teleport
            dungeonId = 1201 -- Darkheart Thicket
        },
        HoV = {
            teleportId = 393764, -- Halls of Valor Teleport
            dungeonId = 1473 -- Halls of Valor
        },
        NL = {
            teleportId = 410078, -- Neltharion's Lair Teleport
            dungeonId = 1206 -- Neltharion's Lair
        }
    }
}
