local AddOnName, XIVBar = ...;
local L = XIVBar.L;

XIVBar.Changelog[4400] = {
    version_string = "4.4",
    release_date = "2026/02/19",
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
            "[Global] Added a new [Reputation] module that allows you to track your standing with your currently watched faction.",
        },
        ["frFR"] = {
            "[Retail] Ajout d'un nouveau module [Réputation] permettant de suivre votre réputation avec la faction marquée comme suivie.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added a check to see if XP is locked (by the player or because the next expansion is not yet released) before showing XP bar in the [Currency] module.",
            "[Global] German translation updated, thank you [DlargeX]."
        },
        ["frFR"] = {
            "[Global] Ajout d'une vérification pour savoir si l'XP est verrouillée (par le joueur ou parce que la prochaine extension n'est pas encore sortie) avant d'afficher la barre d'XP dans le module [Monnaie].",
            "[Global] Traduction allemande mise à jour, merci [DlargeX]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Fixed a Lua error occurring when entering combat with the [Show on mouseover] option enabled.",
            "[Global] Fixed a visual issue causing the [Tradeskills] and XP bars to sometimes not align properly with their backgrounds."
        },
        ["frFR"] = {
            "[Global] Correction d'une erreur Lua survenant lors de l'entrée en combat lorsque l'option [Afficher au survol de la souris] est activée.",
            "[Global] Correction d'un problème visuel où les barres de [Métiers] et d'XP n'étaient pas correctement alignées avec leur arrière-plan."

        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}