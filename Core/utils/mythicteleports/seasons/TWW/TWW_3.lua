local _, xb = ...

-- The War Within Season 3 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TWW_3 = {
    start_date = {
        US = "2025-08-12",
        EU = "2025-08-13",
        default = "2025-08-13"
    },
    end_date = {
        US = "2026-01-20",
        EU = "2026-01-21",
        default = "2026-01-21"
    },
    teleports = {
        -- TWW dungeons
        "TWW.AKCE",
        "TWW.PotSF",
        "TWW.TDB",
        "TWW.OFG",
        "TWW.EDAD",

        -- SL dungeons
        "SL.TVM",
        "SL.HoA"
    }
}
