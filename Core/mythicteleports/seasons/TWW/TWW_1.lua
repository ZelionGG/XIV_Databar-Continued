local AddOnName, xb = ...
local L = xb.L

-- The War Within Season 1 mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TWW_1 = {
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
