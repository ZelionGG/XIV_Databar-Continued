local AddOnName, Engine = ...;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddOnName, "frFR", false, false);
if not L then return end

L['Modules'] = "Modules";
L['Left-Click'] = "Clic gauche";
L['Right-Click'] = "Clic droit";
L['k'] = true; -- short for 1000
L['M'] = "m"; -- short for 1000000
L['B'] = "M"; -- short for 1000000000
L['L'] = true; -- For the local ping
L['W'] = "M"; -- For the world ping

-- General
L["Positioning"] = "Positionnement";
L['Bar Position'] = "Position de la barre";
L['Top'] = "Haut";
L['Bottom'] = "Bas";
L['Bar Color'] = "Couleur de la barre";
L['Use Class Color for Bar'] = "Utiliser la couleur de classe pour la barre";
L["Miscellaneous"] = "Divers";
L['Hide Bar in combat'] = "Cacher la barre en combat";
L["Hide when in flight"] = "Cacher la barre en vol";
L['Bar Padding'] = "Décalage de la barre";
L['Module Spacing'] = "Espacement des modules";
L['Bar Margin'] = "Marge des modules en bord d'écran";
L["Leftmost and rightmost margin of the bar modules"] = "Décalage des modules en bord d'écran";
L['Hide order hall bar'] = "Cacher la barre du hall de classe";
L['Use ElvUI for tooltips'] = "Utiliser ElvUI pour les info-bulles";
L["Lock Bar"] = "Verrouiller la position de la barre";
L["Lock the bar in place"] = "Verrouiller la position de la barre";
L["Lock the bar to prevent dragging"] = "Verrouiller la barre pour empêcher le déplacement";
L["Makes the bar span the entire screen width"] = "La barre prend toute la largeur de l'écran";
L["Position the bar at the top or bottom of the screen"] = "Positionne la barre en haut ou en bas de l'écran";
L["X Offset"] = "Décalage X";
L["Y Offset"] = "Décalage Y";
L["Horizontal position of the bar"] = "Position horizontale de la barre";
L["Vertical position of the bar"] = "Position verticale de la barre";
L["Behavior"] = "Comportement";
L["Spacing"] = "Espacement";

-- Positioning Options
L['Positioning Options'] = "Options de positionnement";
L['Horizontal Position'] = "Horizontal";
L['Bar Width'] = "Longueur de la barre";
L['Left'] = "Aligné à gauche";
L['Center'] = "Centrer";
L['Right'] = "Aligné à droite";

-- Media
L['Font'] = "Police";
L['Small Font Size'] = "Taille de la petite police";
L['Text Style'] = "Style du texte";

-- Text Colors
L["Colors"] = "Couleurs";
L['Text Colors'] = "Couleurs du texte";
L['Normal'] = "Normale";
L['Use Class Color for Text'] = "Utiliser la couleur de classe pour le texte";
L['Only the alpha can be set with the color picker'] = "Seul l'alpha peut être réglé avec la sélection de couleur";
L['Inactive'] = "Inactif";
L['Use Class Colors for Hover'] = "Utiliser la couleur de classe lors du survol";
L['Hover'] = "Survol";

-------------------- MODULES ---------------------------

L['Micromenu'] = "Micro menu";
L['Show Social Tooltips'] = "Montrer les bulles de contacts";
L['Blizzard Micromenu'] = "Micro menu Blizzard";
L['Disable Blizzard Micromenu'] = "Désactiver le micro menu Blizzard";
L['Blizzard Micromenu Disclaimer'] = "Si vous utilisez un autre addon d'interface (ex : ElvUI), masquez sa microbar dans les options de cet addon.";
L['Blizzard Bags Bar'] = "Barre des sacs Blizzard";
L['Disable Blizzard Bags Bar'] = "Désactiver la barre des sacs Blizzard";
L['Blizzard Bags Bar Disclaimer'] = "Si vous utilisez un autre addon d'interface (ex : ElvUI), masquez sa barre des sacs dans les options de cet addon.";
L['Main Menu Icon Right Spacing'] = "Décalage à droite du micro menu";
L['Icon Spacing'] = "Espacement des icônes";
L["Hide BNet App Friends"] = "Masquer amis BNet applications";
L['Open Guild Page'] = "Ouvrir la page de guilde";
L['No Tag'] = "Aucun Tag";
L['Whisper BNet'] = "Chuchoter BNet";
L['Whisper Character'] = "Chuchoter le personnage";
L['Hide Social Text'] = "Cacher le texte des contacts";
L['Social Text Offset'] = "Décalage du texte social";
L["GMOTD in Tooltip"] = "Afficher le message de guilde dans la bulle";
L["Modifier for friend invite"] = "Touche modifieuse pour inviter un contact";
L['Show/Hide Buttons'] = "Afficher/Cacher les boutons";
L['Show Menu Button'] = "Afficher le bouton Menu";
L['Show Chat Button'] = "Afficher le bouton Tchat";
L['Show Guild Button'] = "Afficher le bouton Guilde";
L['Show Social Button'] = "Afficher le bouton Contacts";
L['Show Character Button'] = "Afficher le bouton Personnage";
L['Show Spellbook Button'] = "Afficher le bouton Grimoire";
L['Show Talents Button'] = "Afficher le bouton Talents";
L['Show Achievements Button'] = "Afficher le bouton Haut-faits";
L['Show Quests Button'] = "Afficher le bouton Quêtes";
L['Show LFG Button'] = "Afficher le bouton RDG";
L['Show Journal Button'] = "Afficher le bouton Journal";
L['Show PVP Button'] = "Afficher le bouton JcJ";
L['Show Pets Button'] = "Afficher le bouton Mascottes";
L['Show Shop Button'] = "Afficher le bouton Boutique";
L['Show Help Button'] = "Afficher le bouton Aide";
L['Show Housing Button'] = "Afficher le bouton Logis";
L['No Info'] = "Pas d'information";
L['Classic'] = true;
L['Alliance'] = true;
L['Horde'] = true;

L['Durability Warning Threshold'] = "Seuil d'avertissement de durabilité";
L['Show Item Level'] = "Afficher le niveau d'équipement";
L['Show Coordinates'] = "Afficher les coordonnées";

L['Master Volume'] = "Volume principal";
L["Volume step"] = "Incrément de volume";

L['Time Format'] = "Format de l'heure";
L['Use Server Time'] = "Utiliser l'heure du serveur";
L['New Event!'] = "Nouvel événement";
L['Local Time'] = "Heure locale";
L['Realm Time'] = "Heure du royaume";
L['Open Calendar'] = "Ouvrir le calendrier";
L['Open Clock'] = "Ouvrir l'horloge";
L['Hide Event Text'] = "Cacher le texte d'événement";

L['Travel'] = "Voyage";
L['Port Options'] = "Options de téléportation";
L['Ready'] = "Prêt";
L['Travel Cooldowns'] = "Temps de recharge des voyages";
L['Change Port Option'] = "Option de changement de la téléportation";

L["Registered characters"] = "Personnages enregistrés";
L['Show Free Bag Space'] = "Montrer l'espace libre dans les sacs";
L['Show Other Realms'] = "Montrer les autres royaumes";
L['Always Show Silver and Copper'] = "Toujours montrer l'argent et le cuivre";
L['Shorten Gold'] = "Raccourcir le montant d'or";
L['Toggle Bags'] = "Ouvrir/Fermer les sacs";
L['Session Total'] = "Total sur la session";
L['Daily Total'] = "Total quotidien";
L['Gold rounded values'] = "Valeurs arrondies au po";

L['Show XP Bar Below Max Level'] = "Montrer la barre d'XP quand le niveau max n'est pas atteint";
L['Use Class Colors for XP Bar'] = "Utiliser la couleur de classe pour la barre d'XP";
L['Show Tooltips'] = "Montrer les bulles";
L['Text on Right'] = "Texte à droite";
L['Currency Select'] = "Sélection de la monnaie";
L['First Currency'] = "Première monnaie";
L['Second Currency'] = "Seconde monnaie";
L['Third Currency'] = "Troisième monnaie";
L['Rested'] = "Reposé";

L['Show World Ping'] = "Montrer la latence monde";
L['Number of Addons To Show'] = "Nombre d'addon à lister";
L['Addons to Show in Tooltip'] = "Addon à lister dans la bulle";
L['Show All Addons in Tooltip with Shift'] = "Lister tous les addons avec Maj";
L['Memory Usage'] = "Utilisation mémoire";
L['Garbage Collect'] = "Nettoyer la mémoire";
L['Cleaned'] = "Nettoyé";

L['Use Class Colors'] = "Utiliser les couleurs de classe";
L['Cooldowns'] = "Temps de recharge";
L['Toggle Profession Frame'] = 'Afficher le cadre de la profession';
L['Toggle Profession Spellbook'] = 'afficher le livre de sorts de la profession';

L['Set Specialization'] = "Choix de la spécialisation";
L['Set Loadout'] = "Choix de la configuration";
L['Set Loot Specialization'] = "Spécialisation du butin";
L['Current Specialization'] = "Spécialisation actuelle";
L['Current Loot Specialization'] = "Spécialisation du butin actuelle";
L['Talent Minimum Width'] = "Longueur minimum";
L['Open Artifact'] = "Ouvrir l'Arme Prodigieuse";
L['Remaining'] = "Restant";
L['Available Ranks'] = "Rangs disponibles";
L['Artifact Knowledge'] = "Connaissance de l'arme prodigieuse";

-- Travel
L['Hearthstone'] = "Pierre de foyer";
L['M+ Teleports'] = "Téléportations M+";
L['Only show current season'] = "N'afficher que les téléportations de la saison courante.";
L["Mythic+ Teleports"] = "Téléportations Mythique+";
L['Show Mythic+ Teleports'] = "Montrer les téléportations Mythique+";
L['Use Random Hearthstone'] = "Utiliser une pierre de foyer aléatoire";
local retrievingData = "Récupération des données..."
L['Retrieving data'] = retrievingData;
L['Empty Hearthstones List'] = "Si vous voyez '" .. retrievingData .. "' dans la liste ci-dessous, changez simplement d'onglet ou rouvrez ce menu pour rafraîchir les données."
L['Hearthstones Select'] = "Sélection des pierres de foyers";
L['Hearthstones Select Desc'] = "Sélectionner les pierres de foyers à utiliser (Attention, si vous sélectionnez plusieurs pierres de foyers, il faudrait cocher l'option 'Sélection des pierres de foyers')";

L["Classic"] = true;
L["Burning Crusade"] = true;
L["Wrath of the Lich King"] = true;
L["Cataclysm"] = true;
L["Mists of Pandaria"] = true;
L["Warlords of Draenor"] = true;
L["Legion"] = true;
L["Battle for Azeroth"] = true;
L["Shadowlands"] = true;
L["Dragonflight"] = true;
L["The War Within"] = true;
L["Current season"] = "Saison courante";

-- Profile Import/Export
L["Profile Sharing"] = "Partage de profil";

L["Invalid import string"] = "Chaine d'import non valide";
L["Failed to decode import string"] = "Erreur de décodage de la chaine d'import";
L["Failed to decompress import string"] = "Erreur de décompression de la chaine d'import";
L["Failed to deserialize import string"] = "Erreur de deserialization de la chaine d'import";
L["Invalid profile format"] = "Format de profil non valide";
L["Profile imported successfully as"] = "Profil importé avec succès sous le nom";

L["Copy the export string below:"] = "Copier la chaîne d'export ci-dessous:";
L["Paste the import string below:"] = "Coller la chaîne d'import ci-dessous:";
L["Import or export your profiles to share them with other players."] = "Importez ou exportez vos profils pour les partager avec d'autres joueurs.";
L["Profile Import/Export"] = "Import/Export de profil";
L["Export Profile"] = "Exporter le profil";
L["Export your current profile settings"] = "Exporter les paramètres du profil actuel";
L["Import Profile"] = "Importer un profil";
L["Import a profile from another player"] = "Importer un profil d'un autre joueur";

-- Changelog
L["%month%-%day%-%year%"] = "%month%-%day%-%year%";
L["Version"] = true;
L["Important"] = true;
L["New"] = "Nouveau";
L["Improvment"] = "Améliorations";
L["Changelog"] = "Historique de modifications";