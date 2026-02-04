local AddOnName, XIVBar = ...;
local L = XIVBar.L;

XIVBar.Changelog[4200] = {
    version_string = "4.2",
    release_date = "2026/02/04",
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
            "[Retail] The [" .. L['Micromenu'] .. "] module went into an overhaul to fix multiple Taint (Action blocked) issues. It's now possible to use most of the buttons in combat (Spellbook and Talents are still locked in combat).",
        },
        ["frFR"] = {
            "[Retail] Le module [" .. L['Micromenu'] .. "] a été revu pour corriger plusieurs problèmes de Taint (Action bloquée). Il est maintenant possible d'utiliser la plupart des boutons en combat (le Livre des Sorts et les Talents restent verrouillés en combat).",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] Fixed the [" .. L['M+ Teleports'] .. "] not working when the [ActionButtonUseKeyDown] CVar was not in the correct state.",
            "[Global] Brought back the [" .. L['Bar Color'] .. "] and [Bar alpha] options in the general settings.",
            "[Global] Fixed a LUA error happening with the [Clock] module.",
        },
        ["frFR"] = {
            "[Retail] Correction d'un bug avec les [" .. L['M+ Teleports'] .. "] qui ne fonctionnaient pas lorsque la variable (CVar) [ActionButtonUseKeyDown] n'était pas dans le bon état.",
            "[Global] Les options [" .. L['Bar Color'] .. "] et [Alpha de la barre] ont été ramenées dans les paramètres généraux.",
            "[Global] Correction d'une erreur LUA causée par le module [Horloge].",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}