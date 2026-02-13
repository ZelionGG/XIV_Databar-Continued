local AddOnName, XIVBar = ...;
local L = XIVBar.L;

XIVBar.Changelog[4200] = {
    version_string = "4.2",
    release_date = "2026/02/04",
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] The [Currency] module went into a big overhaul to allow you to only show an icon that will show a tooltip with all selected currencies in the module settings. Please note that checking the [Show more Currencies on Shift+Hover] will allow you to see X (X being the number of currencies in the module settings) currencies in the tooltip, the hard limit being 50 for visual reasons. As always, don't hesitate to send your feedbacks.",
        },
        ["frFR"] = {
            "[Global] Le module [Monnaie] a été revu pour permettre de montrer une icône simple qui affichera une infobulle avec toutes les monnaies sélectionnées dans les paramètres du module. Veuillez noter que la vérification de l'option [Afficher plus de monnaies en Shift+Survol] permettra de voir X (X étant le nombre de monnaies dans les paramètres du module) monnaies dans l'infobulle, la limite d'affichage étant de 50 pour des raisons visuelles. Comme toujours, n'hésitez pas à me faire des retours.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added options to hide each of the [Travel] module's button individually.",
            "[Retail] Added an option to hide the [M+ Teleports] text in the [Travel] module.",
        },
        ["frFR"] = {
            "[Global] Ajout d'options pour cacher chaque bouton du module [Voyage] individuellement.",
            "[Retail] Ajout d'une option pour cacher le texte [Téléportations Mythique+] dans le module [Voyage].",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] The [Travel] module went into a small overhaul again to optimize items/spells/toys names retrieval.",
            "[Global] Updated German translation (thank you [DlargeX]).",
            "[Global] Updated for patch [12.0.1].",
            "[Retail] The [Micromenu] module went into a big overhaul to make most buttons compliant with SecureActionButtonTemplate (making LUA errors [ADDON_ACTION_BLOCKED] not likely to happen again).",
            "[Classic] The [Micromenu] module is now mostly synced with the Retail version.",
        },
        ["frFR"] = {
            "[Global] Le module [Voyage] a été revu pour optimiser le chargement des noms des objets/sorts/jouets de téléportations.",
            "[Global] Mise à jour de la traduction allemande (merci [DlargeX]).",
            "[Global] Mise à jour pour le patch [12.0.1].",
            "[Retail] Le module [Micromenu] a été revu pour transformer la plupart des boutons en boutons sécurisés (rendant les erreurs LUA [ADDON_ACTION_BLOCKED] moins susceptibles de se produire).",
            "[Classic] Le module [Micromenu] est maintenant globalement synchronisé avec la version Retail.",
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