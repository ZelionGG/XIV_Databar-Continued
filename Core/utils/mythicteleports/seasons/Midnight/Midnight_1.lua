local _, xb = ...

-- The War Within Season 1 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.MIDNIGHT_1 = {
    start_date = {
        US = "2026-03-08",
        EU = "2026-03-09",
        default = "2026-03-09"
    },
    --[[ end_date = {
        US = "2025-03-03",
        EU = "2025-03-04",
        default = "2025-03-04"
    }, ]]
    teleports = {
        -- TWW dungeons
        "MIDNIGHT.MAGI",
        "MIDNIGHT.MAIS",
        "MIDNIGHT.NPX",
        "MIDNIGHT.WIS",

        -- DF dungeons
        "DF.AA",

        -- Legion dungeons
        "LEGION.SotT",

        -- WoD dungeons
        "WOD.SR",

        -- Wotlk dungeons
        "WOTLK.PoS"
    }
}
