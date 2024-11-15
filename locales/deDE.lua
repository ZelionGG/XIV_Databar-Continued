local AddOnName, Engine = ...;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddOnName, "deDE", false, false);
if not L then return end

L['Modules'] = "Module";
L['Left-Click'] = "Links-Klick";
L['Right-Click'] = "Rechts-Klick";
L['k'] = true; -- short for 1000
L['M'] = true; -- short for 1000000
L['B'] = true; -- short for 1000000000
L['L'] = true; -- For the local ping
L['W'] = true; -- For the world ping

-- General
L["Positioning"] = "Positionierung";
L['Bar Position'] = "Leistenposition";
L['Top'] = "Oben";
L['Bottom'] = "Unten";
L['Bar Color'] = "Leistenfarbe";
L['Use Class Color for Bar'] = "Benutze Klassenfarbe für Leiste";
L["Miscellaneous"] = "Verschiedenes";
L['Hide Bar in combat'] = "Verstecke die Leiste im Kampf";
L['Bar Padding'] = "Leistenabstand";
L['Module Spacing'] = "Abstand zwischen Modulen";
L['Bar Margin'] = "Balkenrand";
L["Leftmost and rightmost margin of the bar modules"] = "Linker und rechter Rand der Balkenmodule";
L['Hide order hall bar'] = "Verstecke Klassenhallenleiste";
L['Use ElvUI for tooltips'] = "Verwende ElvUI für QuickInfos";

-- Positioning Options
L['Positioning Options'] = "Positions Einstellungen";
L['Horizontal Position'] = "Horizontale Position";
L['Bar Width'] = "Leistenbreite";
L['Left'] = "Links";
L['Center'] = "Mitte";
L['Right'] = "Rechts";

-- Media
L['Font'] = "Schriftart";
L['Small Font Size'] = "Kleine Schriftgröße";
L['Text Style'] = "Schriftstil";

-- Text Colors
L["Colors"] = "Farben";
L['Text Colors'] = "Textfarben";
L['Normal'] = "Normal";
L['Inactive'] = "Inaktiv";
L["Use Class Color for Text"] = "Benutze Klassenfarben für Texte";
L["Only the alpha can be set with the color picker"] = "Nur die Transparenz kann mit dem Farbwerkzeug gesetzt werden";
L['Use Class Colors for Hover'] = "Benutze Klassenfarbe für Mouseover";
L['Hover'] = "Mouseover";

-------------------- MODULES ---------------------------

L['Micromenu'] = "Mikromenü";
L['Show Social Tooltips'] = "Social Tooltips anzeigen";
L['Main Menu Icon Right Spacing'] = "Hauptmenü Symbolabstand Rechts";
L['Icon Spacing'] = "Symbolabstand";
L["Hide BNet App Friends"] = "BNet App-Freunde verbergen";
L['Open Guild Page'] = "Öffne Gildenfenster";
L['No Tag'] = "Keine Markierung";
L['Whisper BNet'] = "über BNet anflüstern";
L['Whisper Character'] = "Charakter anflüstern";
L['Hide Social Text'] = "Social Text verstecken";
L['Social Text Offset'] = "Social Text Versatz";
L["GMOTD in Tooltip"] = "Nachricht des Tages im Tooltip";
L["Modifier for friend invite"] = "Modifikator für Freundschaftseinladungen";
L['Show/Hide Buttons'] = "Zeige/Verstecke Tasten";
L['Show Menu Button'] = "Zeige Menü Taste";
L['Show Chat Button'] = "Zeige Chat Taste";
L['Show Guild Button'] = "Zeige Gilden Taste";
L['Show Social Button'] = "Zeige Freunde Taste";
L['Show Character Button'] = "Zeige Charakter Taste";
L['Show Spellbook Button'] = "Zeige Zauberbuch Taste";
L['Show Talents Button'] = "Zeige Talent Taste";
L['Show Achievements Button'] = "Zeige Erfolg Taste";
L['Show Quests Button'] = "Zeige Quest Taste";
L['Show LFG Button'] = "Zeige LFG Taste";
L['Show Journal Button'] = "Zeige Journal Taste";
L['Show PVP Button'] = "Zeige PVP Taste";
L['Show Pets Button'] = "Zeige Haustier Taste";
L['Show Shop Button'] = "Zeige Shop Taste";
L['Show Help Button'] = "Zeige Hilfe Taste";
L['No Info'] = "Keine Informationen";
L['Classic'] = true;
L['Alliance'] = "Allianz";
L['Horde'] = true;

L['Durability Warning Threshold'] = "Haltbarkeitswarnschwelle";
L['Show Item Level'] = "Gegenstandsstufe anzeigen";
L['Show Coordinates'] = "Koordinaten anzeigen";

L['Master Volume'] = "Haupt-Lautstärke";
L["Volume step"] = "Lautstärken Schritte";

L['Time Format'] = "Uhrzeit Format";
L['Use Server Time'] = "Server Zeit benutzen";
L['New Event!'] = "Neue Veranstaltung!";
L['Local Time'] = "Lokale Zeit";
L['Realm Time'] = "Realm Zeit";
L['Open Calendar'] = "Kalendar öffnen";
L['Open Clock'] = "Stoppuhr öffnen";
L['Hide Event Text'] = "Event Text verstecken";

L['Travel'] = "Reise";
L['Port Options'] = "Teleport Einstellungen";
L['Ready'] = "Bereit";
L['Travel Cooldowns'] = "Reise Abklingzeiten";
L['Change Port Option'] = "Teleport Einstellungen ändern";

L["Registered characters"] = true;
L['Show Free Bag Space'] = true;
L['Show Other Realms'] = true;
L['Always Show Silver and Copper'] = "Silber und Kupfer immer anzeigen";
L['Shorten Gold'] = "Gold abkürzen";
L['Toggle Bags'] = "Taschen anzeigen";
L['Session Total'] = "Sitzung total";
L['Daily Total'] = "Heute total";
L['Gold rounded values'] = "Gold runden";

L['Show XP Bar Below Max Level'] = "Erfahrungsleiste unter Levelcap anzeigen";
L['Use Class Colors for XP Bar'] = "Klassenfarbe für Erfahrungsleiste benutzen";
L['Show Tooltips'] = "Tooltips anzeigen";
L['Text on Right'] = "Text auf der rechten Seite";
L['Currency Select'] = "Währung auswählen";
L['First Currency'] = "Währung #1";
L['Second Currency'] = "Währung #2";
L['Third Currency'] = "Währung #3";
L['Rested'] = "Ausgeruht";

L['Show World Ping'] = "Welt-Ping anzeigen";
L['Number of Addons To Show'] = "Maximale Anzahl für Addon Anzeige";
L['Addons to Show in Tooltip'] = "Addons die im Tooltip angezeigt werden";
L['Show All Addons in Tooltip with Shift'] = "Alle Addons im Tooltip anzeigen via Shift";
L['Memory Usage'] = "Speichernutzung";
L['Garbage Collect'] = "Speicher säubern";
L['Cleaned'] = "Gesäubert";

L['Use Class Colors'] = "Klassenfarben benutzen";
L['Cooldowns'] = "Abklingzeiten";
L['Toggle Profession Frame'] = 'Berufsfenster anzeigen';
L['Toggle Profession Spellbook'] = 'Zauberbuch für Berufe anzeigen';

L['Set Specialization'] = "Spezialisierung auswählen";
L['Set Loadout'] = "Konfiguration auswählen";
L['Set Loot Specialization'] = "Beute Spezialisierung auswählen";
L['Current Specialization'] = "Aktuelle Spezialisierung";
L['Current Loot Specialization'] = "Aktuelle Beute Spezialisierung";
L['Talent Minimum Width'] = "Minimale Breite für Talente";
L['Open Artifact'] = "Artefakt öffen";
L['Remaining'] = "Verbleibend";
L['Available Ranks'] = "Verfügbare Ränge";
L['Artifact Knowledge'] = "Artefaktwissen";

-- Travel (Translation needed)
L['M+ Teleports'] = true;
L['Only show current season'] = true;
L["Mythic+ Teleports"] = true;

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
L["Current season"] = "Aktuelle Season";

-- Profile Import/Export
L["Profile Sharing"] = true;

L["Invalid import string"] = true;
L["Failed to decode import string"] = true;
L["Failed to decompress import string"] = true;
L["Failed to deserialize import string"] = true;
L["Invalid profile format"] = true;
L["Profile imported successfully as"] = true;

L["Copy the export string below:"] = true;
L["Paste the import string below:"] = true;
L["Import or export your profiles to share them with other players."] = true;
L["Profile Import/Export"] = true;
L["Export Profile"] = true;
L["Export your current profile settings"] = true;
L["Import Profile"] = true;
L["Import a profile from another player"] = true;

-- Changelog
L["%month%-%day%-%year%"] = true;
L["Version"] = true;
L["Important"] = "Wichtig";
L["New"] = "Neu";
L["Improvment"] = "Verbesserung";
L["Changelog"] = "Änderungen";