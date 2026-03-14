---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5000] = {
    version_string = "5.0",
    release_date = "2026/03/09",
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:16:16:0:0|t |cffffd700 Modules Free Positioning feature|r\n\n" ..
            "After years of waiting, the dream is real: you can now position modules however you want! Enable [Module Positioning] in the settings, slide each module along the X-axis with the new controls, let the addon auto-capture your current layout, and enjoy free, precise placement without breaking your legacy setup."
        },
        ["frFR"] = {
            "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:16:16:0:0|t |cffffd700 Fonctionnalité de placement libre des modules|r\n\n" ..
            "Après des années d'attente, le rêve est devenu réalité : vous pouvez désormais positionner les modules comme vous le souhaitez ! Activez [Module Positioning] dans les paramètres, faites glisser chaque module sur l'axe X avec les nouveaux contrôles, laissez l'addon capturer automatiquement votre disposition actuelle, et profitez d'un placement libre et précis sans casser votre ancienne configuration."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added a new highly customizable [Rest Icon] in the [Clock] module (Thank you [Skyfox] on the Discord for the suggestion).",
            "[Global] Added an option to allow setting sound volume from the [Master Volume] module using mouse wheel (Thank you [Skyfox] on the Discord for the suggestion)."
        },
        ["frFR"] = {
            "[Global] Ajout d'une nouvelle icône de repos hautement personnalisable dans le module [Horloge] (Merci à [Skyfox] sur le Discord pour la suggestion).",
            "[Global] Ajout d'une option pour permettre de régler le volume sonore depuis le module [Master Volume] en utilisant la molette de la souris (Merci à [Skyfox] sur le Discord pour la suggestion)."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] The [Great Vault] click is now disabled until the next season starts and a disclaimer was added in the tooltip.",
            "[Retail] The [Great Vault] won't show anymore if your character is not at max level.",
            "[Retail] Added a disclaimer in the [Great Vault] module options to warn that max level is needed for the module to show.",
            "[Global] Options to hide Blizzard UI in the [Micromenu] and [" .. BONUS_ROLL_REWARD_MONEY .. "] modules are now disabled when an external action bar AddOn is detected.",
            "[Code] Refactored the locales system to make it easier to maintain, read, and update."
        },
        ["frFR"] = {
            "[Retail] Le clic sur [La Grande Chambre Forte] est maintenant désactivé jusqu'au début de la prochaine saison et un avertissement a été ajouté dans l'infobulle.",
            "[Retail] [La Grande Chambre Forte] ne s'affiche plus si votre personnage n'est pas au niveau maximum.",
            "[Retail] Un avertissement a été ajouté dans les options du module [La Grande Chambre Forte] pour prévenir que le niveau maximum est nécessaire pour que le module s'affiche.",
            "[Global] Les options pour masquer l'interface Blizzard dans les modules [Micro menu] et [" .. BONUS_ROLL_REWARD_MONEY .. "] sont maintenant désactivées quand un AddOn de barre d'action externe est détecté.",
            "[Code] Le système de localisation a été repensé pour être plus facile à maintenir, à lire et à mettre à jour."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}