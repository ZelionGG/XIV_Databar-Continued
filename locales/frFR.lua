local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "frFR", false, false)
if not L then return end

-- NOTE: Some strings are sourced from BlizzardInterfaceResources:
-- https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/frFR.lua

L["MODULES"] = "Modules"
L["LEFT_CLICK"] = "Clic gauche"
L["RIGHT_CLICK"] = "Clic droit"
L["k"] = true -- short for 1000
L["M"] = "m" -- short for 1000000
L["B"] = "M" -- short for 1000000000
L["L"] = true -- For the local ping
L["W"] = "M" -- For the world ping

-- General
L["POSITIONING"] = "Positionnement"
L["BAR_POSITION"] = "Position de la barre"
L["TOP"] = "Haut"
L["BOTTOM"] = "Bas"
L["BAR_COLOR"] = "Couleur de la barre"
L["USE_CLASS_COLOR"] = "Utiliser la couleur de classe pour la barre"
L["MISCELLANEOUS"] = "Divers"
L["HIDE_IN_COMBAT"] = "Cacher la barre en combat"
L["HIDE_IN_FLIGHT"] = "Cacher la barre en vol"
L["SHOW_ON_MOUSEOVER"] = "Afficher au survol"
L["SHOW_ON_MOUSEOVER_DESC"] = "Afficher la barre uniquement au survol"
L["BAR_PADDING"] = "Décalage de la barre"
L["MODULE_SPACING"] = "Espacement des modules"
L["BAR_MARGIN"] = "Marge des modules en bord d'écran"
L["BAR_MARGIN_DESC"] = "Décalage des modules en bord d'écran"
L["HIDE_ORDER_HALL_BAR"] = "Cacher la barre du hall de classe"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Utiliser ElvUI pour les info-bulles"
L["LOCK_BAR"] = "Verrouiller la position de la barre"
L["LOCK_BAR_DESC"] = "Verrouiller la barre pour empêcher le déplacement"
L["BAR_FULLSCREEN_DESC"] = "La barre prend toute la largeur de l'écran"
L["BAR_POSITION_DESC"] = "Positionne la barre en haut ou en bas de l'écran"
L["X_OFFSET"] = "Décalage X"
L["Y_OFFSET"] = "Décalage Y"
L["HORIZONTAL_POSITION"] = "Position horizontale de la barre"
L["VERTICAL_POSITION"] = "Position verticale de la barre"
L["BEHAVIOR"] = "Comportement"
L["SPACING"] = "Espacement"

-- Modules Positioning
L["MODULES_POSITIONING"] = "Positionnement des modules"
L["ENABLE_FREE_PLACEMENT"] = "Activer le placement libre"
L["ENABLE_FREE_PLACEMENT_DESC"] = "Activer un positionnement X indépendant pour chaque module et désactiver les ancres inter-modules"
L["RESET_ALL_POSITIONS"] = "Réinitialiser toutes les positions"
L["RESET_ALL_POSITIONS_DESC"] = "Remet tous les modules à leurs positions initiales en placement libre"
L["ANCHOR_POINT"] = "Point d'ancrage"
L["X_POSITION"] = "Position X"
L["RESET_POSITION"] = "Réinitialiser la position"
L["RESET_POSITION_DESC"] = "Remet le module à sa position en mode ancré"
L["RECAPTURE_INITIAL_POSITIONS"] = "Recapturer les positions initiales"
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Capture les positions ancrées actuelles comme nouvelles positions initiales du placement libre"

-- Positioning Options
L["BAR_WIDTH"] = "Longueur de la barre"
L["LEFT"] = "Aligné à gauche"
L["CENTER"] = "Centrer"
L["RIGHT"] = "Aligné à droite"

-- Media
L["FONT"] = "Police"
L["SMALL_FONT_SIZE"] = "Taille de la petite police"
L["TEXT_STYLE"] = "Style du texte"

-- Text Colors
L["COLORS"] = "Couleurs"
L["TEXT_COLORS"] = "Couleurs du texte"
L["NORMAL"] = "Normale"
L["INACTIVE"] = "Inactif"
L["USE_CLASS_COLOR_TEXT"] = "Utiliser la couleur de classe pour le texte"
L["USE_CLASS_COLOR_TEXT_DESC"] = "Seul l'alpha peut être réglé avec la sélection de couleur"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Utiliser la couleur de classe lors du survol"
L["HOVER"] = "Survol"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Micro menu"
L["SHOW_SOCIAL_TOOLTIPS"] = "Montrer les bulles de contacts"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Montrer les bulles d'accessibilité"
L["BLIZZARD_MICROMENU"] = "Micro menu Blizzard"
L["DISABLE_BLIZZARD_MICROMENU"] = "Désactiver le micro menu Blizzard"
L["KEEP_QUEUE_STATUS_ICON"] = "Garder l'icône de la file d'attente"
L["BLIZZARD_MICROMENU_DISCLAIMER"] = "Cette option est désactivée car un gestionnaire de barres externe est détecté : %s."
L["BLIZZARD_BAGS_BAR"] = "Barre des sacs Blizzard"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Désactiver la barre des sacs Blizzard"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = "Cette option est désactivée car un gestionnaire de barres externe est détecté : %s."
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Décalage à droite du micro menu"
L["ICON_SPACING"] = "Espacement des icônes"
L["HIDE_BNET_APP_FRIENDS"] = "Masquer amis BNet applications"
L["OPEN_GUILD_PAGE"] = "Ouvrir la page de guilde"
L["NO_TAG"] = "Aucun Tag"
L["WHISPER_BNET"] = "Chuchoter BNet"
L["WHISPER_CHARACTER"] = "Chuchoter le personnage"
L["HIDE_SOCIAL_TEXT"] = "Cacher le texte des contacts"
L["SOCIAL_TEXT_OFFSET"] = "Décalage du texte social"
L["GMOTD_IN_TOOLTIP"] = "Afficher le message de guilde dans la bulle"
L["FRIEND_INVITE_MODIFIER"] = "Touche modifieuse pour inviter un contact"
L["SHOW_HIDE_BUTTONS"] = "Afficher/Cacher les boutons"
L["SHOW_MENU_BUTTON"] = "Afficher le bouton Menu"
L["SHOW_CHAT_BUTTON"] = "Afficher le bouton Tchat"
L["SHOW_GUILD_BUTTON"] = "Afficher le bouton Guilde"
L["SHOW_SOCIAL_BUTTON"] = "Afficher le bouton Contacts"
L["SHOW_CHARACTER_BUTTON"] = "Afficher le bouton Personnage"
L["SHOW_SPELLBOOK_BUTTON"] = "Afficher le bouton Grimoire"
L["SHOW_TALENTS_BUTTON"] = "Afficher le bouton Talents"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Afficher le bouton Haut-faits"
L["SHOW_QUESTS_BUTTON"] = "Afficher le bouton Quêtes"
L["SHOW_LFG_BUTTON"] = "Afficher le bouton RDG"
L["SHOW_JOURNAL_BUTTON"] = "Afficher le bouton Journal"
L["SHOW_PVP_BUTTON"] = "Afficher le bouton JcJ"
L["SHOW_PETS_BUTTON"] = "Afficher le bouton Mascottes"
L["SHOW_SHOP_BUTTON"] = "Afficher le bouton Boutique"
L["SHOW_HELP_BUTTON"] = "Afficher le bouton Aide"
L["SHOW_HOUSING_BUTTON"] = "Afficher le bouton Logis"
L["NO_INFO"] = "Pas d'information"
L["Alliance"] = FACTION_ALLIANCE
L["Horde"] = FACTION_HORDE

L["DURABILITY_WARNING_THRESHOLD"] = "Seuil d'avertissement de durabilité"
L["SHOW_ITEM_LEVEL"] = "Afficher le niveau d'équipement"
L["SHOW_COORDINATES"] = "Afficher les coordonnées"

-- Master Volume
L["MASTER_VOLUME"] = "Volume principal"
L["VOLUME_STEP"] = "Incrément de volume"
L["ENABLE_MOUSE_WHEEL"] = "Activer le réglage par molette"

-- Clock
L["TIME_FORMAT"] = "Format de l'heure"
L["USE_SERVER_TIME"] = "Utiliser l'heure du serveur"
L["NEW_EVENT"] = "Nouvel événement"
L["LOCAL_TIME"] = "Heure locale"
L["REALM_TIME"] = "Heure du royaume"
L["OPEN_CALENDAR"] = "Ouvrir le calendrier"
L["OPEN_CLOCK"] = "Ouvrir l'horloge"
L["HIDE_EVENT_TEXT"] = "Cacher le texte d'événement"
L["REST_ICON"] = "Icône de repos"
L["SHOW_REST_ICON"] = "Afficher l'icône de repos"
L["TEXTURE"] = "Texture"
L["DEFAULT"] = "Par défaut"
L["CUSTOM"] = "Personnalisée"
L["CUSTOM_TEXTURE"] = "Texture personnalisée"
L["HIDE_REST_ICON_MAX_LEVEL"] = "Masquer au niveau maximum"
L["TEXTURE_SIZE"] = "Taille de la texture"
L["POSITION"] = "Position"
L["CUSTOM_TEXTURE_COLOR"] = "Couleur personnalisée"
L["COLOR"] = "Couleur"

L["TRAVEL"] = "Voyage"
L["PORT_OPTIONS"] = "Options de téléportation"
L["READY"] = "Prêt"
L["TRAVEL_COOLDOWNS"] = "Temps de recharge des voyages"
L["CHANGE_PORT_OPTION"] = "Option de changement de la téléportation"

-- Gold
L["REGISTERED_CHARACTERS"] = "Personnages enregistrés"
L["SHOW_FREE_BAG_SPACE"] = "Montrer l'espace libre dans les sacs"
L["SHOW_OTHER_REALMS"] = "Montrer les autres royaumes"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Toujours montrer l'argent et le cuivre"
L["SHORTEN_GOLD"] = "Raccourcir le montant d'or"
L["TOGGLE_BAGS"] = "Ouvrir/Fermer les sacs"
L["SESSION_TOTAL"] = "Total sur la session"
L["DAILY_TOTAL"] = "Total quotidien"
L["SHOW_WARBAND_BANK_GOLD"] = "Afficher l'or de la " .. ACCOUNT_BANK_PANEL_TITLE
L["GOLD_ROUNDED_VALUES"] = "Valeurs arrondies à l'or"
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Masquer les personnages sous le seuil"
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Seuil"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Montrer la barre d'XP quand le niveau max n'est pas atteint"
L["CLASS_COLORS_XP_BAR"] = "Utiliser la couleur de classe pour la barre d'XP"
L["SHOW_TOOLTIPS"] = "Montrer les bulles"
L["TEXT_ON_RIGHT"] = "Texte à droite"
L["CURRENCY_SELECT"] = "Sélection de la monnaie"
L["FIRST_CURRENCY"] = "Première monnaie"
L["SECOND_CURRENCY"] = "Seconde monnaie"
L["THIRD_CURRENCY"] = "Troisième monnaie"
L["RESTED"] = "Reposé"
L["SHOW_MORE_CURRENCIES"] = "Montrer plus de monnaies avec Maj+Survol"
L["MAX_CURRENCIES_SHOWN"] = "Nombre maximum de monnaies affichées avec Maj"
L["ONLY_SHOW_MODULE_ICON"] = "Montrer uniquement l'icône du module"
L["CURRENCY_NUMBER"] = "Nombre de monnaies dans la barre"
L["CURRENCY_SELECTION"] = "Sélection des monnaies"
L["SELECT_ALL"] = "Tout sélectionner"
L["UNSELECT_ALL"] = "Tout désélectionner"
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Ouvrir les options de monnaie de XIV"

-- System
L["WORLD_PING"] = "Montrer la latence monde"
L["ADDONS_NUMBER_TO_SHOW"] = "Nombre d'addon à lister"
L["ADDONS_IN_TOOLTIP"] = "Addon à lister dans la bulle"
L["SHOW_ALL_ADDONS"] = "Lister tous les addons avec Maj"
L["MEMORY_USAGE"] = "Utilisation mémoire"
L["GARBAGE_COLLECT"] = "Nettoyer la mémoire"
L["CLEANED"] = "Nettoyé"

-- Reputation
L["OPEN_REPUTATION"] = "Ouvrir l'interface de " .. REPUTATION
L["PARAGON_REWARD_AVAILABLE"] = "Récompense de parangon disponible"
L["CLASS_COLORS_REPUTATION"] = "Utiliser la couleur de classe pour la barre de réputation"
L["REPUTATION_COLORS_REPUTATION"] = "Utiliser la couleur de réputation pour la barre de réputation"
L["FLASH_PARAGON_REWARD"] = "Flash lorsque la récompense de parangon est disponible"
L["PROGRESS"] = "Progression"
L["RANK"] = "Rang"
L["PARAGON"] = "Parangon"

L["USE_CLASS_COLORS"] = "Utiliser les couleurs de classe"
L["COOLDOWNS"] = "Temps de recharge"
L["TOGGLE_PROFESSION_FRAME"] = 'Afficher le cadre de la profession'
L["TOGGLE_PROFESSION_SPELLBOOK"] = 'Afficher le livre de sorts de la profession'

L["SET_SPECIALIZATION"] = "Choix de la spécialisation"
L["SET_LOADOUT"] = "Choix de la configuration"
L["SET_LOOT_SPECIALIZATION"] = "Spécialisation du butin"
L["CURRENT_SPECIALIZATION"] = "Spécialisation actuelle"
L["CURRENT_LOOT_SPECIALIZATION"] = "Spécialisation du butin actuelle"
L["TALENT_MINIMUM_WIDTH"] = "Longueur minimum"
L["OPEN_ARTIFACT"] = "Ouvrir l'Arme Prodigieuse"
L["REMAINING"] = "Restant"
L["AVAILABLE_RANKS"] = "Rangs disponibles"
L["ARTIFACT_KNOWLEDGE"] = "Connaissance de l'arme prodigieuse"

L["SHOW_BUTTON_TEXT"] = "Afficher le texte du bouton"

-- Travel
L["HEARTHSTONE"] = "Pierre de foyer"
L["M_PLUS_TELEPORTS"] = "Téléportations M+"
L["ONLY_SHOW_CURRENT_SEASON"] = "N'afficher que les téléportations de la saison courante."
L["MYTHIC_PLUS_TELEPORTS"] = "Téléportations Mythique+"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Masquer le texte des téléportations M+"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Montrer les téléportations Mythique+"
L["USE_RANDOM_HEARTHSTONE"] = "Utiliser une pierre de foyer aléatoire"
local retrievingData = "Récupération des données..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Si vous voyez '" .. retrievingData .. "' dans la liste ci-dessous, changez simplement d'onglet ou rouvrez ce menu pour rafraîchir les données."
L["HEARTHSTONES_SELECT"] = "Sélection des pierres de foyers"
L["HEARTHSTONES_SELECT_DESC"] = "Sélectionner les pierres de foyers à utiliser (Attention, si vous sélectionnez plusieurs pierres de foyers, il faudrait cocher l'option 'Sélection des pierres de foyers')"
L["HIDE_HEARTHSTONE_BUTTON"] = "Masquer le bouton de la pierre de foyer"
L["HIDE_PORT_BUTTON"] = "Masquer le bouton des téléportations secondaires"
L["HIDE_HOME_BUTTON"] = "Masquer le bouton Logis"
L["HIDE_HEARTHSTONE_TEXT"] = "Masquer le texte de la pierre de foyer"
L["HIDE_PORT_TEXT"] = "Masquer le texte des téléportations secondaires"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Masquer les textes additionnels de l'infobulle"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Masquer les textes additionnels de l'infobulle comme le point de liaison de la pierre de foyer et le bouton de téléportation secondaire sélectionné." -- To Translate
L["NOT_LEARNED"] = "Non appris"
L["SHOW_UNLEARNED_TELEPORTS"] = "Afficher les sorts de téléportation non appris"
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Masquer le bouton pendant l’entre-saison"

-- House/Home Selection
L["HOME"] = "Logis"
L["UNKNOWN_HOUSE"] = "Maison Inconnue"
L["HOUSE"] = "Logis"
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Sélectionné"
L["CHANGE_HOME"] = "Changer de Logis"
L["NO_HOUSES_OWNED"] = "Aucun logis possédé"
L["VISIT_SELECTED_HOME"] = "Visiter le logis sélectionné"

L["CLASSIC"] = "Classic"
L["Burning Crusade"] = true
L["Wrath of the Lich King"] = true
L["Cataclysm"] = true
L["Mists of Pandaria"] = true
L["Warlords of Draenor"] = true
L["Legion"] = true
L["Battle for Azeroth"] = true
L["Shadowlands"] = true
L["Dragonflight"] = true
L["The War Within"] = true
L["Midnight"] = true
L["CURRENT_SEASON"] = "Saison courante"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Partage de profil"

L["INVALID_IMPORT_STRING"] = "Chaine d'import non valide"
L["FAILED_DECODE_IMPORT_STRING"] = "Erreur de décodage de la chaine d'import"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Erreur de décompression de la chaine d'import"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Erreur de deserialization de la chaine d'import"
L["INVALID_PROFILE_FORMAT"] = "Format de profil non valide"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Profil importé avec succès sous le nom"

L["COPY_EXPORT_STRING"] = "Copier la chaîne d'export ci-dessous:"
L["PASTE_IMPORT_STRING"] = "Coller la chaîne d'import ci-dessous:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Importez ou exportez vos profils pour les partager avec d'autres joueurs."
L["PROFILE_IMPORT_EXPORT"] = "Import/Export de profil"
L["EXPORT_PROFILE"] = "Exporter le profil"
L["EXPORT_PROFILE_DESC"] = "Exporter les paramètres du profil actuel"
L["IMPORT_PROFILE"] = "Importer un profil"
L["IMPORT_PROFILE_DESC"] = "Importer un profil d'un autre joueur"

-- Changelog
L["DATE_FORMAT"] = "%day%/%month%/%year%"
L["IMPORTANT"] = "Important"
L["NEW"] = "Nouveau"
L["IMPROVEMENT"] = "Améliorations"
L["BUGFIX"] = "Corrections de bugs"
L["CHANGELOG"] = "Historique de modifications"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = DELVES_GREAT_VAULT_LABEL .. " est actuellement désactivée jusqu'au début de la prochaine saison."
L["MAX_LEVEL_DISCLAIMER"] = "Ce module ne s'affichera que lorsque vous atteindrez le niveau maximum."
