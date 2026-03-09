local _, xb = ...

-- The War Within Season 1 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TWW_1 = {
    start_date = {
        US = "2024-09-10",
        EU = "2024-09-10",
        default = "2024-09-10"
    },
    end_date = {
        US = "2025-03-03",
        EU = "2025-03-04",
        default = "2025-03-04"
    },
    teleports = {
        -- TWW dungeons
        "TWW.AKCE",
        "TWW.CoT",
        "TWW.TDB",
        "TWW.TSV",

        -- SL dungeons
        "SL.MoTS",
        "SL.NW",

        -- BFA dungeons
        "BFA.SoB",

        -- Cataclysm dungeons
        "CATA.GB"
    }
}
