---@class XIVBar
local XIVBar = select(2, ...)
local compat = XIVBar.compat or {}
local addons = {}
local managedActionBarAddOns = {
    Bartender4 = true,
    Dominos = true,
    ElvUI = true,
    Tukui = true,
}

XIVBar.addons = addons

function addons.GetExternalActionBarManagerName()
    local isAddOnLoaded = compat.IsAddOnLoaded
    if not isAddOnLoaded then
        return nil
    end

    for addOnName in pairs(managedActionBarAddOns) do
        if isAddOnLoaded(addOnName) then
            return addOnName
        end
    end

    return nil
end

function addons.HasExternalActionBarManager()
    return addons.GetExternalActionBarManagerName() ~= nil
end
