local AddOnName, xb = ...
local L = xb.L

-- The War Within mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TWW = {
    name = L["The War Within"],
    order = 11, -- Second to last in the list
    teleports = {
        AKCE = {
            teleportId = 445417, -- Ara-Kara, City of Echoes Teleport
            dungeonId = 2604, -- Ara-Kara, City of Echoes
        },
        CBM = {
            teleportId = 445440, -- Cinderbrew Meadery Teleport
            dungeonId = 2689, -- Cinderbrew Meadery
        },
        CoT = {
            teleportId = 445416, -- City of Threads Teleport
            dungeonId = 2642, -- City of Threads
        },
        DFC = {
            teleportId = 445441, -- Darkflame Cleft Teleport
            dungeonId = 2518, -- Darkflame Cleft
        },
        TDB = {
            teleportId = 445414, -- The Dawnbreaker Teleport
            dungeonId = 2523, -- The Dawnbreaker
        },
        TSV = {
            teleportId = 445269, -- The Stonevault Teleport
            dungeonId = 2693, -- The Stonevault
        },
        PotSF = {
            teleportId = 445444, -- Priory of the Sacred Flame Teleport
            dungeonId = 2695, -- Priory of the Sacred Flame
        },
        OFG = {
            teleportId = 1216786, -- Operation: Floodgate Teleport
            dungeonId = 2791, -- Operation: Floodgate
        },
        TR = {
            teleportId = 445443, -- The Rookery Teleport
            dungeonId = 2637, -- The Rookery
        }
    }
}
