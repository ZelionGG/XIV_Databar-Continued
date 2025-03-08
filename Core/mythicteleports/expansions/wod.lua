local AddOnName, xb = ...
local L = xb.L

-- Warlords of Draenor mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.WOD = {
    name = L["Warlords of Draenor"],
    order = 6, -- Seventh to last in the list
    teleports = {
        AD = {
            teleportId = 159897, -- Auchindoun Teleport
            dungeonId = 820 -- Auchindoun
        },
        BSM = {
            teleportId = 159895, -- Bloodmaul Slag Mines Teleport
            dungeonId = 787 -- Bloodmaul Slag Mines
        },
        GD = {
            teleportId = 159900, -- Grimrail Depot Teleport
            dungeonId = 822 -- Grimrail Depot
        },
        ID = {
            teleportId = 159896, -- Iron Docks Teleport
            dungeonId = 821 -- Iron Docks
        },
        SR = {
            teleportId = 159898, -- Skyreach Teleport
            dungeonId = 779 -- Skyreach
        },
        SBM = {
            teleportId = 159899, -- Shadowmoon Burial Grounds Teleport
            dungeonId = 783 -- Shadowmoon Burial Grounds
        },
        EB = {
            teleportId = 159901, -- The Everbloom Teleport
            dungeonId = 824 -- The Everbloom
        },
        UBRS = {
            teleportId = 159902, -- Upper Blackrock Spire Teleport
            dungeonId = 828 -- Upper Blackrock Spire
        }
    }
}
