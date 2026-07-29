local _, xb = ...

-- The War Within Season 1 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.MIDNIGHT_2 = {
    start_date = {
        US = "2026-08-18",
        EU = "2026-08-19",
        default = "2026-08-19"
    },
    teleports = {
        -- TWW dungeons
        "MIDNIGHT.MR",
        "MIDNIGHT.DoN",
        "MIDNIGHT.TBV",
        "MIDNIGHT.VSA",
        "MIDNIGHT.AoFa",
        -- DF dungeons
        "DF.RLP",
        -- BFA dungeons
        "BFA.ToSet",
        "BFA.KR",
    }
}
