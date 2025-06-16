local AddOnName, xb = ...
local L = xb.L

-- The Burning Crusade mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.TBC = {
    name = L["Burning Crusade"],
    order = 2, -- Second from the top
    teleports = {} -- No teleports currently defined for TBC
}
