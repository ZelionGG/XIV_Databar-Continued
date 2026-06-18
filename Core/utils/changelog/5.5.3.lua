---@class XIVBar
local XIVBar = select(2, ...);

XIVBar.Changelog[5530] = {
    version_string = "5.5.3",
    release_date = "2026/06/19",
    header = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            title = "Version 5.5.3 - Great Vault Reward Alerts",
            text = "This update adds visual alerts to the [Vault] module when a weekly reward is available to claim.\n"
                .. "It also fixes alert refresh after claiming rewards and updates TOC versions for Retail and Mists of Pandaria Classic."
        },
        ["frFR"] = {
            title = "Version 5.5.3 - Alertes de récompense de la grande chambre forte",
            text = "Cette mise à jour ajoute des alertes visuelles au module [La grande chambre forte] lorsqu'une récompense hebdomadaire est disponible.\n"
                .. "Elle corrige aussi la réinitialisation de l'alerte après réclamation d'une récompense et met à jour les versions TOC pour Retail et Mists of Pandaria Classic."
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
            "[Retail] Added pending reward alerts to the [Vault] module with configurable alert color, flash, snooze, optional chat confirmation, right-click snooze, and tooltip highlighting."
        },
        ["frFR"] = {
            "[Retail] Ajout d'alertes de récompense en attente dans le module [La grande chambre forte], avec couleur d'alerte, clignotement, mise en pause, confirmation dans le chat, pause au clic droit et mise en évidence dans l'infobulle configurables."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] TOC update for patch 12.0.7.",
            "[Mists of Pandaria Classic] TOC update for patch 5.5.4."
        },
        ["frFR"] = {
            "[Retail] Mise à jour TOC pour le patch 12.0.7.",
            "[Mists of Pandaria Classic] Mise à jour TOC pour le patch 5.5.4."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Retail] Fixed [Vault] alert state not clearing immediately after claiming a Weekly Reward.",
            "[Retail] Fixed [Vault] pending reward tooltip to use Blizzard unclaimed reward strings."
        },
        ["frFR"] = {
            "[Retail] Correction de l'état d'alerte du module [La grande chambre forte] qui ne se réinitialisait pas immédiatement après avoir réclamé une récompense hebdomadaire.",
            "[Retail] Correction de l'infobulle de récompense en attente du module [La grande chambre forte] pour utiliser les textes Blizzard des récompenses non réclamées."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}
