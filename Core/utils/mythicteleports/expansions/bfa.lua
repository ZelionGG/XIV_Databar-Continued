local _, xb = ...
local L = xb.L

-- Battle for Azeroth mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.BFA = {
    name = L["Battle for Azeroth"],
    order = 8, -- Fifth to last in the list
    teleports = {
        AD = {
            teleportId = 424187, -- Atal'Dazar Teleport
            dungeonId = 1668, -- Atal'Dazar
        },
        FH = {
            teleportId = 410071, -- Freehold Teleport
            dungeonId = 1672, -- Freehold
        },
        SoB = {
            teleportId = {464256,445418}, -- Siege of Boralus Teleport
            dungeonId = 1700, -- Siege of Boralus
        },
        UR = {
            teleportId = 410074, -- The Underrot Teleport
            dungeonId = 1711, -- The Underrot
        },
        WM = {
            teleportId = 424167, -- Waycrest Manor Teleport
            dungeonId = 1705, -- Waycrest Manor
        },
        OMG = {
            teleportId = 373274, -- Operation: Mechagon Teleport
            dungeonId = 2006, -- Operation: Mechagon
        },
        TML = {
            teleportId = {467555, 467553}, -- The MOTHERLODE!! Teleport
            dungeonId = 1707, -- The MOTHERLODE!!
        },
        ToSet = {
            teleportId = 1286828, -- Temple of Sethraliss Teleport
            dungeonId = 1694, -- Temple of Sethraliss
        },
        KR = {
            teleportId = 1286831, -- King's Rest Teleport
            dungeonId = 1785, -- King's Rest
        }
    }
}
