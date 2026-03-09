local _, xb = ...

-- The War Within Season 2 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TWW_2 = {
    start_date = {
        US = "2025-03-04",
        EU = "2025-03-05",
        default = "2025-03-05"
    },
    end_date = {
        US = "2025-08-11",
        EU = "2025-08-12",
        default = "2025-08-12"
    },
    teleports = {
        -- TWW dungeons
        "TWW.PotSF",
        "TWW.CBM",
        "TWW.DFC",
        "TWW.OFG",
        "TWW.TR",

        -- SL dungeons
        "SL.ToP",

        -- BFA dungeons
        "BFA.TML",
        "BFA.OMG"
    }
}
