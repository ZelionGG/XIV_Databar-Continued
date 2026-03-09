local _, xb = ...

-- The War Within Season 1 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.MIDNIGHT_1 = {
    start_date = {
        US = "2026-03-24",
        EU = "2026-03-25",
        default = "2026-03-25"
    },
    --[[ end_date = {
        US = "2026-03-24",
        EU = "2026-03-25",
        default = "2026-03-25"
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
