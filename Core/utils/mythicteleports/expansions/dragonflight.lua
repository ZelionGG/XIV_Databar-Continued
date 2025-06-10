local AddOnName, xb = ...
local L = xb.L

-- Dragonflight mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.DF = {
    name = L["Dragonflight"],
    order = 10, -- Third to last in the list
    teleports = {
        AA = {
            teleportId = 393273, -- Algeth'ar Academy Teleport
            dungeonId = 2366 -- Algeth'ar Academy
        },
        BH = {
            teleportId = 393267, -- Brackenhide Hollow Teleport
            dungeonId = 2362 -- Brackenhide Hollow
        },
        DOTI = {
            teleportId = 424197, -- Dawn of the Infinite Teleport
            dungeonId = 2430 -- Dawn of the Infinite
        },
        HoA = {
            teleportId = 393283, -- Halls of Infusion Teleport
            dungeonId = 2364 -- Halls of Infusion
        },
        NL = {
            teleportId = 393276, -- Neltharus Teleport
            dungeonId = 2356 -- Neltharus
        },
        RLP = {
            teleportId = 393256, -- Ruby Life Pools Teleport
            dungeonId = 2361 -- Ruby Life Pools
        },
        AV = {
            teleportId = 393279, -- The Azure Vault Teleport
            dungeonId = 2332 -- The Azure Vault
        },
        NO = {
            teleportId = 393262, -- The Nokhud Offensive Teleport
            dungeonId = 2368 -- The Nokhud Offensive
        }
    }
}
