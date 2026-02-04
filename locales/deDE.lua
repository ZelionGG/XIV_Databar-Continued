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
L["Hide when in flight"] = "Im Flug verstecken";
L["Show on mouseover"] = "Zeige mit Mouseover";
L["Show the bar only when you mouseover it"] = "Die Leiste wird nur angezeigt, wenn Du mit der Maus darüberfährst.";
L['Bar Padding'] = "Leistenabstand";
L['Module Spacing'] = "Abstand zwischen Modulen";
L['Bar Margin'] = "Balkenrand";
L["Leftmost and rightmost margin of the bar modules"] = "Linker und rechter Rand der Balkenmodule";
L['Hide order hall bar'] = "Verstecke Klassenhallenleiste";
L['Use ElvUI for tooltips'] = "Verwende ElvUI für QuickInfos";
L["Lock Bar"] = "Leiste sperren";
L["Lock the bar in place"] = "Die Leiste festsetzen";
L["Lock the bar to prevent dragging"] = "Sperre die Leiste, um ein Ziehen zu verhindern.";
L["Makes the bar span the entire screen width"] = "Sorgt dafür, dass sich die Balken über die gesamte Bildschirmbreite erstreckt.";
L["Position the bar at the top or bottom of the screen"] = "Positioniere die Leiste am oberen oder unteren Bildschirmrand.";
L["X Offset"] = "X-Versatz";
L["Y Offset"] = "Y-Versatz";
L["Horizontal position of the bar"] = "Horizontale Position der Leiste";
L["Vertical position of the bar"] = "Vertikale Position der Leiste";
L["Behavior"] = "Verhalten";
L["Spacing"] = "Abstand";

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
L['Show Accessibility Tooltips'] = "Barrierefreiheits-Tooltips anzeigen";
L['Blizzard Micromenu'] = true; -- No Translate needed
L['Disable Blizzard Micromenu'] = "Deaktiviere Blizzard Micromenu";
L["Keep Queue Status Icon"] = "Zeige Wartenschlangen Statussymbol";
L['Blizzard Micromenu Disclaimer'] = 'If you use another UI addon (e.g. ElvUI), hide its microbar in that addon\'s settings.';
L['Blizzard Bags Bar'] = "Blizzard Taschenleiste";
L['Disable Blizzard Bags Bar'] = "Deaktiviere Blizzard Taschenleiste";
L['Blizzard Bags Bar Disclaimer'] = 'If you use another UI addon (e.g. ElvUI), hide its bags bar in that addon\'s settings.';
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
L['Show Talents Button'] = "Zeige Talente Taste";
L['Show Achievements Button'] = "Zeige Erfolg Taste";
L['Show Quests Button'] = "Zeige Quests Taste";
L['Show LFG Button'] = "Zeige LFG Taste";
L['Show Journal Button'] = "Zeige Journal Taste";
L['Show PVP Button'] = "Zeige PVP Taste";
L['Show Pets Button'] = "Zeige Haustier Taste";
L['Show Shop Button'] = "Zeige Shop Taste";
L['Show Help Button'] = "Zeige Hilfe Taste";
L['Show Housing Button'] = "Zeige Housing Taste";
L['No Info'] = "Keine Informationen";
L['Classic'] = true; -- No Translate needed
L['Alliance'] = "Allianz";
L['Horde'] = true; -- No Translate needed

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

L["Registered characters"] = "Registrierte Charaktere";
L['Show Free Bag Space'] = "Zeige Freie Taschenplätze";
L['Show Other Realms'] = "Zeige andere Realms";
L['Always Show Silver and Copper'] = "Silber und Kupfer immer anzeigen";
L['Shorten Gold'] = "Gold abkürzen";
L['Toggle Bags'] = "Taschen anzeigen";
L['Session Total'] = "Sitzung total";
L['Daily Total'] = "Heute total";
L['Gold rounded values'] = "Gold runden";

-- Currency
L['Show XP Bar Below Max Level'] = "Erfahrungsleiste unter Levelcap anzeigen";
L['Use Class Colors for XP Bar'] = "Klassenfarbe für Erfahrungsleiste benutzen";
L['Show Tooltips'] = "Tooltips anzeigen";
L['Text on Right'] = "Text auf der rechten Seite";
L['Currency Select'] = "Währung auswählen";
L['First Currency'] = "Währung #1";
L['Second Currency'] = "Währung #2";
L['Third Currency'] = "Währung #3";
L['Rested'] = "Ausgeruht";
L['Show More Currencies on Shift+Hover'] = true; -- To Translate
L['Max currencies shown when holding Shift'] = true; -- To Translate
L['Only Show Module Icon'] = true; -- To Translate
L['Number of Currencies on Bar'] = true; -- To Translate
L['Currency Selection'] = true; -- To Translate
L['Select All'] = true; -- To Translate
L['Unselect All'] = true; -- To Translate

-- System
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

L['Show Button Text'] = "Zeige Tastentext";

-- Travel (Translation needed)
L['Hearthstone'] = "Ruhestein";
L['M+ Teleports'] = "M+ Teleporter";
L['Only show current season'] = "Zeige nur aktuelle Season";
L["Mythic+ Teleports"] = "Mythic+ Teleporter";
L['Hide M+ Teleports text'] = true; -- Needs Translate
L['Show Mythic+ Teleports'] = "Zeige Mythisch+ Teleporter";
L['Use Random Hearthstone'] = "Nutze zufälligen Ruhestein";
local retrievingData = "Daten werden abgerufen..."
L['Retrieving data'] = retrievingData;
L['Empty Hearthstones List'] = "Wenn du '" .. retrievingData .. "' in der Liste unten siehst, wechsle einfach den Tab oder öffne dieses Menü erneut, um die Daten zu aktualisieren.";
L['Hearthstones Select'] = "Ruhesteine auswählen";
L['Hearthstones Select Desc'] = "Ruhesteinauswahl Beschreibung";
L['Hide Hearthstone Button'] = true; -- To Translate
L['Hide Port Button'] = true; -- To Translate

L["Classic"] = true; -- No Translate needed
L["Burning Crusade"] = true; -- No Translate needed
L["Wrath of the Lich King"] = true; -- No Translate needed
L["Cataclysm"] = true; -- No Translate needed
L["Mists of Pandaria"] = true; -- No Translate needed
L["Warlords of Draenor"] = true; -- No Translate needed
L["Legion"] = true; -- No Translate needed
L["Battle for Azeroth"] = true;
L["Shadowlands"] = true; -- No Translate needed
L["Dragonflight"] = true; -- No Translate needed
L["The War Within"] = true; -- No Translate needed
L["Current season"] = "Aktuelle Season";

-- Profile Import/Export
L["Profile Sharing"] = "Profile Teilen";

L["Invalid import string"] = "Ungültige Importzeichenfolge";
L["Failed to decode import string"] = "Fehler beim Dekodieren der Importzeichenfolge";
L["Failed to decompress import string"] = "Fehler beim Dekomprimieren der Importzeichenfolge";
L["Failed to deserialize import string"] = "Fehler beim Deserialisieren der Importzeichenfolge";
L["Invalid profile format"] = "Ungültiges Profilformat";
L["Profile imported successfully as"] = "Profil erfolgreich importiert als";

L["Copy the export string below:"] = "Kopiere die unten stehende Exportzeichenfolge:";
L["Paste the import string below:"] = "Füge die Importzeichenfolge unten ein:";
L["Import or export your profiles to share them with other players."] = "Importiere oder exportiere Deine Profile, um sie mit anderen Spielern zu teilen.";
L["Profile Import/Export"] = true; -- No Translate needed
L["Export Profile"] = "Profil Exportieren";
L["Export your current profile settings"] = "Exportiere Ihre aktuellen Profileinstellungen";
L["Import Profile"] = "Profil Importieren";
L["Import a profile from another player"] = "Importiere ein Profil von einem anderen Spieler";

-- Changelog
L["%month%-%day%-%year%"] = true; -- No Translate needed
L["Version"] = true; -- No Translate needed
L["Important"] = "Wichtig";
L["New"] = "Neu";
L["Improvment"] = "Verbesserung";
L["Bugfix"] = true; -- No Translate needed
L["Changelog"] = "Änderungen";