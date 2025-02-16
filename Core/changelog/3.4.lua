local AddOnName, XIVBar = ...;

XIVBar.Changelog[3400] = {
    version_string = "3.4",
    release_date = "2025/01/27",
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Brought back the barColor and barCC options for the color and opacity of the databar.",
            "[Global] Fixed the class color handling errors for the text and bar colors that caused the color to not properly use the class color when changing character.",
            "[Classic SoD] Removed the Calendar button from the [Clock] module.",
            "[Classic SoD] Fixed the [Currency] module to remove the Currency part for classic SoD and showing the XP bar correctly for Cataclysm Classic."
        },
        ["frFR"] = {
            "[Global] Ré-implémentation des options barColor et barCC pour la couleur et la transparence de la barre de données.",
            "[Global] Correction des erreurs de traitement des couleurs de classe pour le texte et la barre qui causaient une couleur incorrecte lorsque vous changiez de personnage.",
            "[Classic SoD] Suppression du bouton Calendrier du module [Horloge].",
            "[Classic SoD] Correction du module [Monnaies] pour supprimer la partie Monnaie pour SoD classique et afficher correctement la barre d'experience pour Cataclysm Classic."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Classic] Implemented a new Experience/Kill tracker that will allow you to see approximately how many mobs you need to kill to level up in the [Currency] module."
        },
        ["frFR"] = {
            "[Classic] Implémentation d'un nouveau suivi de XP/Kill qui vous permettra de voir environ combien de monstres vous devez tuer pour monter de niveau dans le module [Monnaies]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Small refactoring of the [Armor] module to order the durability using the character profile logic from top-left to bottom-right.",
            "[Global] Fixing a bug making the bar disappear when entering certain areas.",
            "[Classic] Fixed the [Talents] module so that the popup and the bar shows the right information.",
            "[Classic] Fixed the [Armor] module showing the head item for each slot."
        },
        ["frFR"] = {
            "[Global] Petite adaptation du module [Armure] pour trier la durabilité selon la logique du profil de personnages de haut-gauche vers bas-droit.",
            "[Global] Correction d'un bug causant la disparition de la barre lorsque vous entrez dans certaines zones.",
            "[Classic] Correction d'un bug provoquant des affichages incorrects sur le module [Talents].",
            "[Classic] Correction d'un bug provoquant l'affichage de l'objet de tête sur tout les emplacements d'équipements sur le module [Armure]."
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}