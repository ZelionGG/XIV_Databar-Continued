---@class XIVBar
local XIVBar = select(2, ...);
local L = XIVBar.L;

XIVBar.Changelog[4110] = {
    version_string = "4.1.1",
    release_date = "2026/01/28",
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] The [" .. L["MICROMENU"] .. "] module went into an overhaul to fix multiple Taint (Action blocked) issues. It's now possible to use most of the buttons in combat (Spellbook and Talents are still locked in combat).",
        },
        ["frFR"] = {
            "[Retail] Le module [" .. L["MICROMENU"] .. "] a été revu pour corriger plusieurs problèmes de Taint (Action bloquée). Il est maintenant possible d'utiliser la plupart des boutons en combat (le Livre des Sorts et les Talents restent verrouillés en combat).",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] Fixed the [" .. L["M_PLUS_TELEPORTS"] .. "] not working when the [ActionButtonUseKeyDown] CVar was not in the correct state.",
            "[Global] Brought back the [" .. L["BAR_COLOR"] .. "] and [Bar alpha] options in the general settings.",
            "[Global] Fixed a LUA error happening with the [Clock] module.",
        },
        ["frFR"] = {
            "[Retail] Correction d'un bug avec les [" .. L["M_PLUS_TELEPORTS"] .. "] qui ne fonctionnaient pas lorsque la variable (CVar) [ActionButtonUseKeyDown] n'était pas dans le bon état.",
            "[Global] Les options [" .. L["BAR_COLOR"] .. "] et [Alpha de la barre] ont été ramenées dans les paramètres généraux.",
            "[Global] Correction d'une erreur LUA causée par le module [Horloge].",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}