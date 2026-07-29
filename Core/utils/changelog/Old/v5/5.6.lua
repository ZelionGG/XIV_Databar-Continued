---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5600] = {
    version_string = "5.6",
    release_date = "2026/07/09",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.6 - Equipment Sets, Lockouts & QoL",
            text = "This update adds quick equipment set switching to the [Armor] module, saved instance lockouts to the [Clock] tooltip, and audio output selection to [Master Volume].\n"
                .. "It also improves [Travel] tooltips, consolidates profile sharing in the [Profiles] options tab, and fixes [Vault] and lockout display issues."
        },
        ["frFR"] = {
            title = "Version 5.6 - Ensembles d'équipement, verrouillages et QoL",
            text = "Cette mise à jour ajoute le changement rapide d'ensembles d'équipement au module [Armure], les verrouillages d'instances à l'infobulle de l'[Horloge], et la sélection de sortie audio au [Volume principal].\n"
                .. "Elle améliore aussi les infobulles du module [Voyage], regroupe le partage de profils dans l'onglet [Profiles] des options, et corrige l'affichage des verrouillages et la fermeture de [La grande chambre forte]."
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
            "[Retail] Added quick equipment set switching to the [Armor] module with left-click popup, active set highlighting in tooltip and selection menu and hidden durability display when no slot reports data.",
            "[Global] Added saved raid and dungeon lockouts to the [Clock] module tooltip with configurable date/time formats and optional boss progress.",
            "[Global] Added audio output device selection to the [Master Volume] module with current device shown in tooltip and Shift+Left-Click popup.",
            "[Retail] Added shared [Mythic+ Teleports] cooldown display to the [Travel] module tooltip."
        },
        ["frFR"] = {
            "[Retail] Ajout du changement rapide d'ensembles d'équipement au module [Armure] via popup au clic gauche, avec mise en évidence de l'ensemble actif dans l'infobulle et le menu de sélection et masquage de la durabilité lorsqu'aucun emplacement ne fournit de données.",
            "[Global] Ajout des verrouillages de raids et de donjons dans l'infobulle du module [Horloge], avec formats de date/heure configurables et progression des boss en option.",
            "[Global] Ajout de la sélection du périphérique de sortie audio au module [Volume principal], avec affichage du périphérique actuel dans l'infobulle et popup au Maj+Clic gauche.",
            "[Retail] Ajout de l'affichage du temps de recharge partagé des [Téléportations Mythique+] dans l'infobulle du module [Voyage]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Consolidated profile import/export into the [Profiles] options tab.",
            "[Global] Added a blank line after section headers in [Travel] module tooltips for consistent layout."
        },
        ["frFR"] = {
            "[Global] Regroupement de l'import/export de profils dans l'onglet [Profiles] des options.",
            "[Global] Ajout d'une ligne vide après les titres de section dans les infobulles du module [Voyage] pour un formatage cohérent."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Fixed [Clock] lockout reset times showing off-by-one-minute values and stale data on first tooltip hover after reload.",
            "[Retail] Fixed [Vault] frame not closing with the Escape key."
        },
        ["frFR"] = {
            "[Global] Correction des heures de réinitialisation des verrouillages dans le module [Horloge] qui affichaient une minute de décalage et des données obsolètes au premier survol après rechargement.",
            "[Retail] Correction de la fermeture de [La grande chambre forte] avec la touche Échap."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}
