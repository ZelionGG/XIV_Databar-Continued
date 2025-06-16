local AddOnName, xb = ...
local L = xb.L

-- Shadowlands mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.SL = {
    name = L["Shadowlands"],
    order = 9, -- Fourth to last in the list
    teleports = {
        DOS = {
            teleportId = 354468, -- De Other Side Teleport
            dungeonId = 2080 -- De Other Side
        },
        MoTS = {
            teleportId = 354464, -- Mists of Tirna Scithe Teleport
            dungeonId = 2072 -- Mists of Tirna Scithe
        },
        PF = {
            teleportId = 354463, -- Plaguefall Teleport
            dungeonId = 2069 -- Plaguefall
        },
        SD = {
            teleportId = 354469, -- Sanguine Depths Teleport
            dungeonId = 2082 -- Sanguine Depths
        },
        SoA = {
            teleportId = 354466, -- Spires of Ascension Teleport
            dungeonId = 2076 -- Spires of Ascension
        },
        TVM = {
            teleportId = 367416, -- Tazavesh, the Veiled Market Teleport
            dungeonId = 2225 -- Tazavesh, the Veiled Market
        },
        ToP = {
            teleportId = 354467, -- Theater of Pain Teleport
            dungeonId = 2078 -- Theater of Pain
        },
        NW = {
            teleportId = 354462, -- The Necrotic Wake Teleport
            dungeonId = 2070 -- The Necrotic Wake
        }
    }
}
