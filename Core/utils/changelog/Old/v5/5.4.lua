---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5400] = {
    version_string = "5.4",
    release_date = "2026/04/10",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.4 - Tooltip Improvements & Classic Fixes",
            text = "This update focuses on tooltip improvements across several modules, with updates for [Tradeskill], [Clock], [Gold], and [Travel].\n"
                .. "It also adds a global option to hide XIV Databar tooltips during combat and fixes Classic Lua errors caused by missing locale strings."
        },
        ["frFR"] = {
            title = "Version 5.4 - Ameliorations des infobulles et corrections Classic",
            text = "Cette mise a jour se concentre sur l'amelioration des infobulles de plusieurs modules, avec des mises a jour pour [Metiers], [Horloge], [Or] et [Voyage].\n"
                .. "Elle ajoute aussi une option globale pour masquer les infobulles de XIV Databar en combat et corrige les erreurs Lua sur Classic causees par des chaines de traduction manquantes."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added the [Hide Tooltips in Combat] option to suppress XIV Databar tooltips during combat across supported modules."
        },
        ["frFR"] = {
            "[Global] Ajout de l'option [Masquer les infobulles en combat] pour désactiver les infobulles de XIV Databar pendant les combats sur les modules pris en charge."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added calendar event lines with formatted start and end times to the [Clock] module tooltip.",
            "[Retail] Added an optional [WoW Token] price line to the [Gold] module tooltip.",
            "[Retail] Added [Path of the Naaru] to the [Travel] module hearthstone list (thank you [flaicher])."
        },
        ["frFR"] = {
            "[Global] Ajout des événements du calendrier avec heures de début et de fin formatées dans l'infobulle du module [Horloge].",
            "[Retail] Ajout d'une ligne optionnelle pour le prix du [Jeton WoW] dans l'infobulle du module [Or].",
            "[Retail] Ajout de [Path of the Naaru] à la liste des pierres de foyer du module [Voyage] (merci à [flaicher])."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Reworked the [Tradeskill] tooltip with clickable hover handling and added the optional [Use Interactive Tooltip] mode with fallback to the default tooltip.",
        },
        ["frFR"] = {
            "[Global] Refonte de l'infobulle du module [Métiers] avec la gestion du survol cliquable et ajout de l'option [Utiliser l'infobulle interactive] avec repli vers l'infobulle par défaut.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Fixed [Gold] tooltip totals so negative [Session Total] and [Daily Total] values now keep their minus sign correctly.",
            "[Classic] Fixed Lua errors caused by missing locale strings."
        },
        ["frFR"] = {
            "[Global] Correction des totaux de l'infobulle du module [Or] pour que les valeurs négatives de [Total de la session] et [Total journalier] conservent correctement leur signe moins.",
            "[Classic] Correction des erreurs Lua causées par des chaînes de traduction manquantes."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}