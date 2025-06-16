local AddOnName, xb = ...
local L = xb.L

-- Classic mythic teleports data
xb.MythicTeleports = xb.MythicTeleports or {}
xb.MythicTeleports.CLASSIC = {
    name = L["Classic"],
    order = 1, -- Top of the list
    teleports = {} -- No teleports currently defined for Classic
}
