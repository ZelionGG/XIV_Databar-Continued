local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "deDE", false, false)
if not L then return end

-- NOTE : Strings that requires translation are marked with -- TODO: To Translate

L["MODULES"] = "Module"
L["LEFT_CLICK"] = "Links-Klick"
L["RIGHT_CLICK"] = "Rechts-Klick"
L["k"] = true -- short for 1000
L["M"] = true -- short for 1000000
L["B"] = true -- short for 1000000000
L["L"] = true -- For the local ping
L["W"] = true -- For the world ping

-- General
L["POSITIONING"] = "Positionierung"
L["BAR_POSITION"] = "Leistenposition"
L["TOP"] = "Oben"
L["BOTTOM"] = "Unten"
L["BAR_COLOR"] = "Leistenfarbe"
L["USE_CLASS_COLOR"] = "Benutze Klassenfarbe für Leiste"
L["MISCELLANEOUS"] = "Verschiedenes"
L["HIDE_IN_COMBAT"] = "Verstecke die Leiste im Kampf"
L["HIDE_IN_FLIGHT"] = "Im Flug verstecken"
L["SHOW_ON_MOUSEOVER"] = "Zeige mit Mouseover"
L["SHOW_ON_MOUSEOVER_DESC"] = "Die Leiste wird nur angezeigt, wenn Du mit der Maus darüberfährst."
L["BAR_PADDING"] = "Leistenabstand"
L["MODULE_SPACING"] = "Abstand zwischen Modulen"
L["BAR_MARGIN"] = "Balkenrand"
L["BAR_MARGIN_DESC"] = "Linker und rechter Rand der Balkenmodule"
L["HIDE_ORDER_HALL_BAR"] = "Verstecke Klassenhallenleiste"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Verwende ElvUI für QuickInfos"
L["LOCK_BAR"] = "Leiste sperren"
L["LOCK_BAR_DESC"] = "Sperrt die Leiste, um ein Ziehen zu verhindern."
L["BAR_FULLSCREEN_DESC"] = "Sorgt dafür, dass sich die Balken über die gesamte Bildschirmbreite erstreckt."
L["BAR_POSITION_DESC"] = "Positioniere die Leiste am oberen oder unteren Bildschirmrand."
L["X_OFFSET"] = "X-Versatz"
L["Y_OFFSET"] = "Y-Versatz"
L["HORIZONTAL_POSITION"] = "Horizontale Position der Leiste"
L["VERTICAL_POSITION"] = "Vertikale Position der Leiste"
L["BEHAVIOR"] = "Verhalten"
L["SPACING"] = "Abstand"

-- Modules Positioning
L["MODULES_POSITIONING"] = "Modules Positioning" -- TODO: To Translate
L["ENABLE_FREE_PLACEMENT"] = "Enable free placement" -- TODO: To Translate
L["ENABLE_FREE_PLACEMENT_DESC"] = "Enable independent X positioning for each module and disable inter-module anchors" -- TODO: To Translate
L["RESET_ALL_POSITIONS"] = "Reset All Positions" -- TODO: To Translate
L["RESET_ALL_POSITIONS_DESC"] = "Reset all modules to their initial free placement positions" -- TODO: To Translate
L["ANCHOR_POINT"] = "Anchor Point" -- TODO: To Translate
L["X_POSITION"] = "X Position" -- TODO: To Translate
L["RESET_POSITION"] = "Reset Position" -- TODO: To Translate
L["RESET_POSITION_DESC"] = "Reset to the anchored position" -- TODO: To Translate
L["RECAPTURE_INITIAL_POSITIONS"] = "Re-capture initial positions" -- TODO: To Translate
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Capture the current anchored positions as the new initial free placement positions" -- TODO: To Translate

-- Positioning Options
L["BAR_WIDTH"] = "Leistenbreite"
L["LEFT"] = "Links"
L["CENTER"] = "Mitte"
L["RIGHT"] = "Rechts"

-- Media
L["FONT"] = "Schriftart"
L["SMALL_FONT_SIZE"] = "Kleine Schriftgröße"
L["TEXT_STYLE"] = "Schriftstil"

-- Text Colors
L["COLORS"] = "Farben"
L["TEXT_COLORS"] = "Textfarben"
L["NORMAL"] = "Normal"
L["INACTIVE"] = "Inaktiv"
L["USE_CLASS_COLOR_TEXT"] = "Benutzt Klassenfarben für Texte"
L["USE_CLASS_COLOR_TEXT_DESC"] = "Nur die Transparenz kann mit dem Farbwerkzeug gesetzt werden"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Benutzt Klassenfarbe für Mouseover"
L["HOVER"] = "Mouseover"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Mikromenü"
L["SHOW_SOCIAL_TOOLTIPS"] = "Social Tooltips anzeigen"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Barrierefreiheits Tooltips anzeigen"
L["BLIZZARD_MICROMENU"] = "Blizzard Mikromenü"
L["DISABLE_BLIZZARD_MICROMENU"] = "Deaktiviert Blizzard Mikromenü"
L["KEEP_QUEUE_STATUS_ICON"] = "Zeigt Wartenschlangen Statussymbol"
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- TODO: To Translate
L["BLIZZARD_BAGS_BAR"] = "Blizzard Taschenleiste"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Deaktiviert Blizzard Taschenleiste"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- TODO: To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Hauptmenü Symbolabstand Rechts"
L["ICON_SPACING"] = "Symbolabstand"
L["HIDE_BNET_APP_FRIENDS"] = "BNet App-Freunde verbergen"
L["OPEN_GUILD_PAGE"] = "Öffnet Gildenfenster"
L["NO_TAG"] = "Keine Markierung"
L["WHISPER_BNET"] = "über BNet anflüstern"
L["WHISPER_CHARACTER"] = "Charakter anflüstern"
L["HIDE_SOCIAL_TEXT"] = "Social Text verstecken"
L["SOCIAL_TEXT_OFFSET"] = "Social Text Versatz"
L["GMOTD_IN_TOOLTIP"] = "Nachricht des Tages im Tooltip"
L["FRIEND_INVITE_MODIFIER"] = "Modifikator für Freundschaftseinladungen"
L["SHOW_HIDE_BUTTONS"] = "Zeigt/Versteckt Tasten"
L["SHOW_MENU_BUTTON"] = "Zeigt Menü Taste"
L["SHOW_CHAT_BUTTON"] = "Zeigt Chat Taste"
L["SHOW_GUILD_BUTTON"] = "Zeigt Gilden Taste"
L["SHOW_SOCIAL_BUTTON"] = "Zeigt Freunde Taste"
L["SHOW_CHARACTER_BUTTON"] = "Zeigt Charakter Taste"
L["SHOW_SPELLBOOK_BUTTON"] = "Zeigt Zauberbuch Taste"
L["SHOW_TALENTS_BUTTON"] = "Zeigt Talente Taste"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Zeigt Erfolge Taste"
L["SHOW_QUESTS_BUTTON"] = "Zeigt Quests Taste"
L["SHOW_LFG_BUTTON"] = "Zeigt LFG Taste"
L["SHOW_JOURNAL_BUTTON"] = "Zeigt Journal Taste"
L["SHOW_PVP_BUTTON"] = "Zeigt PVP Taste"
L["SHOW_PETS_BUTTON"] = "Zeigt Haustier Taste"
L["SHOW_SHOP_BUTTON"] = "Zeigt Shop Taste"
L["SHOW_HELP_BUTTON"] = "Zeigt Hilfe Taste"
L["SHOW_HOUSING_BUTTON"] = "Zeigt Housing Taste"
L["NO_INFO"] = "Keine Informationen"
L["ALLIANCE"] = "Allianz"
L["HORDE"] = "Horde" -- No Translate needed

L["DURABILITY_WARNING_THRESHOLD"] = "Haltbarkeitswarnschwelle"
L["SHOW_ITEM_LEVEL"] = "Gegenstandsstufe anzeigen"
L["SHOW_COORDINATES"] = "Koordinaten anzeigen"

L["MASTER_VOLUME"] = "Hauptlautstärke"
L["VOLUME_STEP"] = "Lautstärken Schritte"

L["TIME_FORMAT"] = "Uhrzeit Format"
L["USE_SERVER_TIME"] = "Serverzeit benutzen"
L["NEW_EVENT"] = "Neue Veranstaltung!"
L["LOCAL_TIME"] = "Lokale Zeit"
L["REALM_TIME"] = "Realm Zeit"
L["OPEN_CALENDAR"] = "Kalendar öffnen"
L["OPEN_CLOCK"] = "Stoppuhr öffnen"
L["HIDE_EVENT_TEXT"] = "Eventtext verstecken"

L["TRAVEL"] = "Reise"
L["PORT_OPTIONS"] = "Teleport Einstellungen"
L["READY"] = "Bereit"
L["TRAVEL_COOLDOWNS"] = "Reise Abklingzeiten"
L["CHANGE_PORT_OPTION"] = "Teleport Einstellungen ändern"

L["REGISTERED_CHARACTERS"] = "Registrierte Charaktere"
L["SHOW_FREE_BAG_SPACE"] = "Zeige Freie Taschenplätze"
L["SHOW_OTHER_REALMS"] = "Zeige andere Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Silber und Kupfer immer anzeigen"
L["SHORTEN_GOLD"] = "Gold abkürzen"
L["TOGGLE_BAGS"] = "Taschen anzeigen"
L["SESSION_TOTAL"] = "Sitzung total"
L["DAILY_TOTAL"] = "Heute total"
L["GOLD_ROUNDED_VALUES"] = "Gold runden"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Erfahrungsleiste unter Levelcap anzeigen"
L["CLASS_COLORS_XP_BAR"] = "Klassenfarbe für Erfahrungsleiste benutzen"
L["SHOW_TOOLTIPS"] = "Tooltips anzeigen"
L["TEXT_ON_RIGHT"] = "Text auf der rechten Seite"
L["CURRENCY_SELECT"] = "Währung auswählen"
L["FIRST_CURRENCY"] = "Währung #1"
L["SECOND_CURRENCY"] = "Währung #2"
L["THIRD_CURRENCY"] = "Währung #3"
L["RESTED"] = "Ausgeruht"
L["SHOW_MORE_CURRENCIES"] = "Weitere Währungen bei Shift+Mouseover anzeigen"
L["MAX_CURRENCIES_SHOWN"] = "Maximal angezeigte Währungen bei gedrückter Umschalttaste"
L["ONLY_SHOW_MODULE_ICON"] = "Nur Modulsymbol anzeigen"
L["CURRENCY_NUMBER"] = "Anzahl der Währungen auf der Leiste"
L["CURRENCY_SELECTION"] = "Währungsauswahl"
L["SELECT_ALL"] = "Alle auswählen"
L["UNSELECT_ALL"] = "Alles abwählen"
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Äffne XIV Währungseinstellungen"

-- System
L["WORLD_PING"] = "Welt-Ping anzeigen"
L["ADDONS_NUMBER_TO_SHOW"] = "Maximale Anzahl für Addon Anzeige"
L["ADDONS_IN_TOOLTIP"] = "Addons die im Tooltip angezeigt werden"
L["SHOW_ALL_ADDONS"] = "Alle Addons im Tooltip anzeigen via Shift"
L["MEMORY_USAGE"] = "Speichernutzung"
L["GARBAGE_COLLECT"] = "Speicher säubern"
L["CLEANED"] = "Gesäubert"

-- Reputation
L["OPEN_REPUTATION"] = "Öffne " .. REPUTATION
L["PARAGON_REWARD_AVAILABLE"] = "Paragonbelohnung verfügbar"
L["CLASS_COLORS_REPUTATION"] = "Klassenfarben für die Rufleiste verwenden"
L["REPUTATION_COLORS_REPUTATION"] = "Verwendet Ruffarben für die Rufleiste."
L["FLASH_PARAGON_REWARD"] = "Aufblitzen bei Paragonbelohnung"
L["PROGRESS"] = "Fortschritt"
L["RANK"] = "Rang"
L["PARAGON"] = "Paragon" -- No Translate needed

L["USE_CLASS_COLORS"] = "Klassenfarben benutzen"
L["COOLDOWNS"] = "Abklingzeiten"
L["TOGGLE_PROFESSION_FRAME"] = "Berufsfenster anzeigen"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Zauberbuch für Berufe anzeigen"

L["SET_SPECIALIZATION"] = "Spezialisierung auswählen"
L["SET_LOADOUT"] = "Konfiguration auswählen"
L["SET_LOOT_SPECIALIZATION"] = "Beute Spezialisierung auswählen"
L["CURRENT_SPECIALIZATION"] = "Aktuelle Spezialisierung"
L["CURRENT_LOOT_SPECIALIZATION"] = "Aktuelle Beute Spezialisierung"
L["TALENT_MINIMUM_WIDTH"] = "Minimale Breite für Talente"
L["OPEN_ARTIFACT"] = "Artefakt öffen"
L["REMAINING"] = "Verbleibend"
L["AVAILABLE_RANKS"] = "Verfügbare Ränge"
L["ARTIFACT_KNOWLEDGE"] = "Artefaktwissen"

L["SHOW_BUTTON_TEXT"] = "Zeige Tastentext"

-- Travel (Translation needed)
L["HEARTHSTONE"] = "Ruhestein"
L["M_PLUS_TELEPORTS"] = "M+ Teleporter"
L["ONLY_SHOW_CURRENT_SEASON"] = "Zeige nur aktuelle Season"
L["MYTHIC_PLUS_TELEPORTS"] = "Mythisch+ Teleporter"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "M+ Teleportertext ausblenden"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Zeige Mythisch+ Teleporter"
L["USE_RANDOM_HEARTHSTONE"] = "Nutze zufälligen Ruhestein"
local retrievingData = "Daten werden abgerufen..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Wenn du '" .. retrievingData .. "' in der Liste unten siehst, wechsle einfach den Tab oder öffne dieses Menü erneut, um die Daten zu aktualisieren."
L["HEARTHSTONES_SELECT"] = "Ruhesteine auswählen"
L["HEARTHSTONES_SELECT_DESC"] = "Ruhesteinauswahl Beschreibung"
L["HIDE_HEARTHSTONE_BUTTON"] = "Ruhestein Taste ausblenden"
L["HIDE_PORT_BUTTON"] = "Port Taste ausblenden"
L["HIDE_HOME_BUTTON"] = "Home Taste ausblenden"
L["HIDE_HEARTHSTONE_TEXT"] = "Versteckt Ruhesteintext"
L["HIDE_PORT_TEXT"] = "Versteckt Porttext"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Zusätzlichen Tooltiptext ausblenden"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Blende den Hearthstone-Bindungsort und die Taste zur Portauswahl im Tooltip aus."
L["NOT_LEARNED"] = "Nicht erlernt"
L["SHOW_UNLEARNED_TELEPORTS"] = "Zeigt ungelernte Teleports"
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Versteckt Taste ausserhalb der Saeson"

-- House/Home Selection
L["HOME"] = "Zuhause"
L["UNKNOWN_HOUSE"] = "Unbekanntes Haus"
L["HOUSE"] = "Haus"
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Ausgewählt"
L["CHANGE_HOME"] = "Ändere Zuhause"
L["NO_HOUSES_OWNED"] = "Kein eigenenes Haus"
L["VISIT_SELECTED_HOME"] = "Besuche ausgewähltes Haus"

L["CLASSIC"] = "Classic" -- No Translate needed
L["Burning Crusade"] = true -- No Translate needed
L["Wrath of the Lich King"] = true -- No Translate needed
L["Cataclysm"] = true -- No Translate needed
L["Mists of Pandaria"] = true -- No Translate needed
L["Warlords of Draenor"] = true -- No Translate needed
L["Legion"] = true -- No Translate needed
L["Battle for Azeroth"] = true
L["Shadowlands"] = true -- No Translate needed
L["Dragonflight"] = true -- No Translate needed
L["The War Within"] = true -- No Translate needed
L["Midnight"] = true -- No Translate needed
L["CURRENT_SEASON"] = "Aktuelle Season"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Profile Teilen"

L["INVALID_IMPORT_STRING"] = "Ungültige Importzeichenfolge"
L["FAILED_DECODE_IMPORT_STRING"] = "Fehler beim Dekodieren der Importzeichenfolge"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Fehler beim Dekomprimieren der Importzeichenfolge"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Fehler beim Deserialisieren der Importzeichenfolge"
L["INVALID_PROFILE_FORMAT"] = "Ungültiges Profilformat"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Profil erfolgreich importiert als"

L["COPY_EXPORT_STRING"] = "Kopiere die unten stehende Exportzeichenfolge:"
L["PASTE_IMPORT_STRING"] = "Füge die Importzeichenfolge unten ein:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Importiere oder Exportiere Deine Profile, um sie mit anderen Spielern zu teilen."
L["PROFILE_IMPORT_EXPORT"] = "Profile Import/Export" -- No Translate needed
L["EXPORT_PROFILE"] = "Profil Exportieren"
L["EXPORT_PROFILE_DESC"] = "Exportiere Ihre aktuellen Profileinstellungen"
L["IMPORT_PROFILE"] = "Profil Importieren"
L["IMPORT_PROFILE_DESC"] = "Importiere ein Profil von einem anderen Spieler"

-- Changelog
L["DATE_FORMAT"] = "%month%-%day%-%year%" -- No Translate needed
L["VERSION"] = "Version" -- No Translate needed
L["IMPORTANT"] = "Wichtig"
L["NEW"] = "Neu"
L["IMPROVEMENT"] = "Verbesserung"
L["BUGFIX"] = "Fehlerbehebung"
L["CHANGELOG"] = "Änderungen"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts." -- TODO: To Translate
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level." -- TODO: To Translate
