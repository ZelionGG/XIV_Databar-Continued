local AddOnName, xb = ...
local L = xb.L

-- Mists of Pandaria mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.MOP = {
    name = L["Mists of Pandaria"],
    order = 5, -- Eighth to last in the list
    teleports = {
        TJS = {
            teleportId = 131204, -- Temple of the Jade Serpent Teleport
            dungeonId = 464 -- Temple of the Jade Serpent
        }
    }
}
