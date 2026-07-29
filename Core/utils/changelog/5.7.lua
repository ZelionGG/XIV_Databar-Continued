---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5700] = {
    version_string = "5.7",
    release_date = "2026/07/29",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.7 - DataBrokers, Profiles & Travel",
            text = "This update finally ships the long-awaited [DataBrokers] module to display third-party LibDataBroker plugins on the bar.\n"
                .. "It also migrates profiles to per-character defaults, improves [Travel] Mythic+ season navigation, and adds login/update chat messages."
        },
        ["frFR"] = {
            title = "Version 5.7 - DataBrokers, profils et Voyage",
            text = "Cette mise à jour livre enfin le module [DataBrokers] tant attendu pour afficher les plugins LibDataBroker tiers sur la barre.\n"
                .. "Elle migre aussi les profils vers des réglages par personnage, améliore la navigation des saisons Mythique+ du module [Voyage], et ajoute des messages de connexion/mise à jour dans le chat."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Profiles now default to a per-character \"Name - Realm\" profile. Existing characters on the shared Default profile get a one-time migration prompt; new characters can join Default or keep a blank personal profile."
        },
        ["frFR"] = {
            "[Global] Les profils utilisent désormais par défaut un profil personnel \"Nom - Royaume\". Les personnages encore sur le profil partagé Default ont une invite de migration unique ; les nouveaux personnages peuvent rejoindre Default ou garder un profil personnel vide."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Added the long-awaited [DataBrokers] module: enable third-party LibDataBroker data sources and launchers as independent bar pieces with icon/text display, click and tooltip forwarding, free placement, per-object toggles, type filters, icon size options, and options nested by source addon.",
            "[Retail] Added the Alliance Boralus portal to the [Travel] module",
            "[Retail] Added Midnight Season 2 Mythic+ teleports to the [Travel] module.",
            "[Retail] Added Mythic+ season date ranges, a Next season group, and temporary dungeon name fallbacks in the [Travel] Mythic+ Teleports menu.",
            "[Global] Added a login chat tip with the /xivc settings command, a [Disable login message] option under [Behavior], and a chat update announcement with a clickable [Open Changelog] link when the addon version changes."
        },
        ["frFR"] = {
            "[Global] Ajout du module [DataBrokers] tant attendu : activez les data sources et launchers LibDataBroker tiers comme pièces indépendantes sur la barre, avec icône/texte, clic et infobulles, placement libre, options par objet, filtres de type, taille d'icône, et options regroupées par addon source.",
            "[Retail] Ajout du portail pour Boralus de l'Alliance au module [Voyage]",
            "[Retail] Ajout des téléportations Mythique+ de la saison 2 de Midnight (dont un donjon Dragonflight) au module [Voyage].",
            "[Retail] Ajout des plages de dates de saisons Mythique+, d'un groupe Prochaine saison, et de noms de donjons temporaires de secours dans le menu [Téléportations Mythique+] du module [Voyage].",
            "[Global] Ajout d'un message de connexion dans le chat avec la commande /xivc, d'une option [Désactiver le message de connexion] dans [Comportement], et d'une annonce de mise à jour avec un lien cliquable [Ouvrir les notes de mise à jour] lorsque la version de l'addon change."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Localized dates now use Blizzard's default function for consistent calendar formatting.",
            "[Global] Class color toggles no longer overwrite saved custom colors; disabling a class-color flag restores the previous RGB.",
            "[TBC Anniversary] TOC update for patch 2.5.6.",
            "[Classic SoD] TOC update for patch 1.15.9."
        },
        ["frFR"] = {
            "[Global] Les dates localisées utilisent désormais la fonction par défaut de Blizzard pour un formatage calendaire cohérent.",
            "[Global] Les options de couleur de classe n'écrasent plus les couleurs personnalisées sauvegardées ; désactiver une option de couleur de classe restaure le RVB précédent.",
            "[TBC Anniversary] Mise à jour TOC pour la mise à jour 2.5.6.",
            "[Classic SoD] Mise à jour TOC pour la mise à jour 1.15.9."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Classic] Fixed [Armor] durability API usage and hid equipment-set UI on flavors without equipment sets.",
        },
        ["frFR"] = {
            "[Classic] Correction de l'API de durabilité du module [Armure] et masquage de l'UI des ensembles d'équipement sur les versions sans ensembles.",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}
