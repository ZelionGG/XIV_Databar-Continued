local _, xb = ...
local L = xb.L

-- Legion mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.MIDNIGHT = {
    name = L["Midnight"],
    order = 12, -- Sixth to last in the list
    teleports = {
        MAGI = { -- Magisters' Terrace
            teleportId = 1254572,
            dungeonId = 3085
        },
        MAIS = { -- Maisara Caverns
            teleportId = 1254559,
            dungeonId = 3097
        },
        NPX = { -- Nexus-Point Xenas
            teleportId = 1254563,
            dungeonId = 3056
        },
        WIS = { -- Windrunner Spire
            teleportId = 1254400,
            dungeonId = 2739
        },
        MR = { -- Murder Row
            teleportId = 1286809,
            dungeonId = 3090
        },
        DoN = { -- Den of Nalorakk
            teleportId = 1286807,
            dungeonId = 3051
        },
        TBV = { -- The Blinding Vale
            teleportId = 1286801,
            dungeonId = 3102
        },
        VSA = { -- Voidscar Arena
            teleportId = 1286804,
            dungeonId = 3106
        },
        AoFa = { -- Altar of Fangs
            teleportId = 1286812,
            dungeonId = 3191,
            name = "Altar of Fangs", -- Temporary fallback
        },
    }
}
