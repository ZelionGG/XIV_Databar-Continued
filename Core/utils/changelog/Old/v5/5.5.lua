---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5500] = {
    version_string = "5.5",
    release_date = "2026/04/14",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.5 - Travel Improvements & Anchor Fixes",
            text = "This update focuses on [Travel] module improvements across multiple game versions, with a new Retail hearthstone addition and cleaner Classic options.\n"
                .. "It also fixes several anchor-related issues that could cause the [Travel] and [Gold] modules to disappear."
        },
        ["frFR"] = {
            title = "Version 5.5 - Ameliorations du module Voyage et corrections d'ancrage",
            text = "Cette mise a jour se concentre sur des ameliorations du module [Voyage] pour plusieurs versions du jeu, avec un ajout de pierre de foyer sur Retail et des options plus propres sur Classic.\n"
                .. "Elle corrige egalement plusieurs problemes d'ancrage pouvant faire disparaitre les modules [Voyage] et [Or]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
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
        ["enUS"] = {
            "[Retail] Added [Lightcalled Hearthstone] to the [Travel] module hearthstone list."
        },
        ["frFR"] = {
            "[Retail] Ajout de la [Pierre de foyer de lumappel] à la liste des pierres de foyer du module [Voyage]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Classic] The secondary teleports should no longer appear in the [Travel] module options."
        },
        ["frFR"] = {
            "[Classic] Les téléportations secondaires ne devraient plus apparaître dans les options du module [Voyage]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Fixed an issue that sometimes caused the [Travel] module to disappear when changing zones.",
            "[Global] Fixed an issue that sometimes caused the [Gold] module to disappear.",
            "[Global] Fixed an issue where checking [Hide Hearthstone Button] in the settings could leave the [Travel] module empty and cause other anchored modules to disappear.",
        },
        ["frFR"] = {
            "[Global] Correction du module [Voyage] qui disparaissait parfois lors d'un changement de zone.",
            "[Global] Correction du module [Or] qui disparaissait parfois.",
            "[Global] Correction d'un problème où cocher la case [Masquer le bouton de pierre de foyer] dans les paramètres pouvait laisser le module [Voyage] vide et faire disparaître les autres modules attachés."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}