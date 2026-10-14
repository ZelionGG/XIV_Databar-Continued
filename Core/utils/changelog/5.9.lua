---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5900] = {
    version_string = "5.9",
    release_date = "2026/10/15",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.9 - Professions, Talents & 12.1.5",
            text = "This update adds secondary professions to the [Tradeskill] module.\n"
                .. "It also fixes the [Loadout switcher] in the [Talents] module (hopefully), LUA errors in [Travel], the [Tradeskill] module on Forever, and updates the TOC for patch 12.1.5."
        },
        ["frFR"] = {
            title = "Version 5.9 - Métiers, Talents et 12.1.5",
            text = "Cette mise à jour ajoute les métiers secondaires au module [Métiers].\n"
                .. "Elle corrige aussi le [Sélecteur d'ensembles de talents] du module [Talents] (j'espère), des erreurs LUA du module [Voyage], le module [Métiers] sur Forever, et met à jour le TOC pour le patch 12.1.5."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added secondary professions (cooking, fishing, archaeology and first aid) to the [Tradeskill] module, with the [Show Secondary Professions] option and the [Show Profession Names] option.",
        },
        ["frFR"] = {
            "[Global] Ajout des métiers secondaires (cuisine, pêche, archéologie et secourisme) au module [Métiers], avec les options [Afficher les métiers secondaires] et [Afficher les noms des métiers].",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] TOC update for patch 12.1.5.",
        },
        ["frFR"] = {
            "[Retail] Mise à jour TOC pour le patch 12.1.5.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] Fixed the [Loadout switcher] in the [Talents] module not showing the active loadout, not returning to it when a talent change is cancelled, and not responding the first time it is enabled.",
            "[Retail] Fixed a LUA error in the [Travel] module caused by a removed API.",
            "[Retail] Fixed a LUA error in [Travel] tooltips during combat.",
            "[Forever] Fixed a LUA error in the [Tradeskill] module which hid the [Currency] module and its XP bar.",
        },
        ["frFR"] = {
            "[Retail] Correction du [Sélecteur d'ensembles de talents] dans le module [Talents] qui n'affichait pas la configuration active, n'y revenait pas lorsqu'un changement de talents est annulé, et ne répondait pas la première fois qu'il est activé.",
            "[Retail] Correction d'une erreur LUA dans le module [Voyage] causée par une API supprimée.",
            "[Retail] Correction d'une erreur LUA dans les infobulles du module [Voyage] en combat.",
            "[Forever] Correction d'une erreur LUA dans le module [Métiers] qui masquait le module [Devises] et sa barre d'XP.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}