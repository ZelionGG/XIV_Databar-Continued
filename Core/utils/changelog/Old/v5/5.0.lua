---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5000] = {
    version_string = "5.0",
    release_date = "2026/03/14",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.0 - Thank You, Community",
            text = "This milestone release brings one of the biggest updates in the AddOn's history, and it would not mean as much without the community that helps me shape, improve, and enrich XIV every day, so thank you once again."
        },
        ["frFR"] = {
            title = "Version 5.0 - Merci à la communauté",
            text = "Cette mise à jour majeure apporte l'une des évolutions les plus importantes de l'histoire de l'AddOn, et elle n'aurait pas la même portée sans la communauté qui aide chaque jour à façonner, améliorer et enrichir XIV, donc merci encore une fois."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
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
            "[Global] Added an option to allow setting sound volume from the [Master Volume] module using mouse wheel (Thank you [Skyfox] on the Discord for the suggestion).",
            "[Global] It is now possible to hide the [Clock] module when [Module Free Placement] is enabled, if [Module Free Placement] is disabled, the [Clock] module will show again automatically."
        },
        ["frFR"] = {
            "[Global] Ajout d'une nouvelle icône de repos hautement personnalisable dans le module [Horloge] (Merci à [Skyfox] sur le Discord pour la suggestion).",
            "[Global] Ajout d'une option pour permettre de régler le volume sonore depuis le module [Master Volume] en utilisant la molette de la souris (Merci à [Skyfox] sur le Discord pour la suggestion).",
            "[Global] Le module [Horloge] peut maintenant être masqué quand le [Placement libre des modules] est activé, s'il est désactivé, le module [Horloge] sera affiché à nouveau automatiquement."
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
            "[Global] Popups now stay visible when using [Show on mouseover].",
            "[Global] [Talent] and [Travel] popups are now closed automatically when you click anywhere outside of them.",
            "[Global] Updated German translation (thank you [DlargeX]).",
            "[Code] Refactored the locales system to make it easier to maintain, read, and update.",
        },
        ["frFR"] = {
            "[Retail] Le clic sur [La Grande Chambre Forte] est maintenant désactivé jusqu'au début de la prochaine saison et un avertissement a été ajouté dans l'infobulle.",
            "[Retail] [La Grande Chambre Forte] ne s'affiche plus si votre personnage n'est pas au niveau maximum.",
            "[Retail] Un avertissement a été ajouté dans les options du module [La Grande Chambre Forte] pour prévenir que le niveau maximum est nécessaire pour que le module s'affiche.",
            "[Global] Les options pour masquer l'interface Blizzard dans les modules [Micro menu] et [" .. BONUS_ROLL_REWARD_MONEY .. "] sont maintenant désactivées quand un AddOn de barre d'action externe est détecté.",
            "[Global] Les popups restent maintenant affichées correctement lorsque l’option [Afficher au survol] est active.",
            "[Global] Les popups [Talents] et [Voyage] se ferment désormais automatiquement lorsque vous cliquez ailleurs sur l'écran.",
            "[Global] Mise à jour de la traduction allemande (merci [DlargeX]).",
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