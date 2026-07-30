local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "deDE", false, false)
if not L then return end

-- Reference:
-- Some strings below are sourced from BlizzardInterfaceResources.
-- Source: https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/deDE.lua
-- @Translation Team: If you find a false positive (a string that should stay identical),
-- add `-- @no-translate` at the end of the line so the locale sync script ignores it.

L["MODULES"] = "Module"
L["LEFT_CLICK"] = "Links-Klick"
L["RIGHT_CLICK"] = "Rechts-Klick"
-- TODO: L["k"] = true -- short for 1000
-- TODO: L["M"] = true -- short for 1000000
-- TODO: L["B"] = true -- short for 1000000000
-- TODO: L["L"] = true -- For the local ping
-- TODO: L["W"] = true -- For the world ping

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
L["MODULES_POSITIONING"] = "Modulpositionierung"
L["ENABLE_FREE_PLACEMENT"] = "Freie Platzierung aktivieren"
L["ENABLE_FREE_PLACEMENT_DESC"] = "Aktiviert die unabhängige X-Positionierung für jedes Modul und deaktiviert Verankerungen zwischen den Modulen."
L["RESET_ALL_POSITIONS"] = "Alle Positionen zurücksetzen"
L["RESET_ALL_POSITIONS_DESC"] = "Setzt alle Module auf ihre ursprünglichen Positionen der freien Platzierung zurück."
L["ANCHOR_POINT"] = "Ankerpunkt"
L["X_POSITION"] = "X-Position"
L["RESET_POSITION"] = "Position zurücksetzen"
L["RESET_POSITION_DESC"] = "Auf die verankerte Position zurücksetzen."
L["RECAPTURE_INITIAL_POSITIONS"] = "Ursprüngliche Positionen neu erfassen"
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Erfasst die aktuellen verankerten Positionen als neue Ausgangspositionen für die freie Platzierung."

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
L["BLIZZARD_MICROMENU_DISCLAIMER"] = "Diese Option ist deaktiviert, da ein externer Bar-Manager erkannt wurde: %s."
L["BLIZZARD_BAGS_BAR"] = "Blizzard Taschenleiste"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Deaktiviert Blizzard Taschenleiste"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = "Diese Option ist deaktiviert, da ein externes Leistenmanagement Addon erkannt wurde: %s."
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Hauptmenü Symbolabstand Rechts"
L["ICON_SPACING"] = "Symbolabstand"
L["HIDE_BNET_APP_FRIENDS"] = "BNet-App Freunde verbergen"
L["OPEN_GUILD_PAGE"] = "Öffnet Gildenfenster"
L["NO_TAG"] = "Keine Markierung"
L["WHISPER_BNET"] = "über BNet anflüstern"
L["WHISPER_CHARACTER"] = "Charakter anflüstern"
L["HIDE_SOCIAL_TEXT"] = "Social Text verstecken"
L["SOCIAL_TEXT_OFFSET"] = "Social Text Versatz"
L["GMOTD_IN_TOOLTIP"] = "Nachricht des Tages im Tooltip"
L["FRIEND_INVITE_MODIFIER"] = "Modifikator für Freundschaftseinladungen"
L["SHOW_HIDE_BUTTONS"] = "Tasten Anzeigen/Verstecken"
L["SHOW_MENU_BUTTON"] = "Menü Taste anzeigen"
L["SHOW_CHAT_BUTTON"] = "Chat Taste anzeigen"
L["SHOW_GUILD_BUTTON"] = "Gilden Tasteanzeigen"
L["SHOW_SOCIAL_BUTTON"] = "Freunde Taste anzeigen"
L["SHOW_CHARACTER_BUTTON"] = "Charakter Taste anzeigen"
L["SHOW_SPELLBOOK_BUTTON"] = "Zauberbuch Taste anzeigen"
L["SHOW_PROFESSIONS_BUTTON"] = "Berufe Taste anzeigen"
L["SHOW_TALENTS_BUTTON"] = "Talente Taste anzeigen"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Erfolge Taste anzeigen"
L["SHOW_QUESTS_BUTTON"] = "Quests Taste anzeigen"
L["SHOW_LFG_BUTTON"] = "LFG Taste anzeigen"
L["SHOW_JOURNAL_BUTTON"] = "Journal Taste anzeigen"
L["SHOW_PVP_BUTTON"] = "PVP Taste anzeigen"
L["SHOW_PETS_BUTTON"] = "Haustier Taste anzeigen"
L["SHOW_SHOP_BUTTON"] = "Shop Taste anzeigen"
L["SHOW_HELP_BUTTON"] = "Hilfe Taste anzeigen"
L["SHOW_HOUSING_BUTTON"] = "Housing Taste anzeigen"
L["NO_INFO"] = "Keine Informationen"
L["Alliance"] = "Allianz"
L["Horde"] = "Horde"
L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Tooltips im Kampf verstecken"

L["DURABILITY_WARNING_THRESHOLD"] = "Haltbarkeitswarnschwelle"
L["SHOW_ITEM_LEVEL"] = "Gegenstandsstufe anzeigen"
L["SHOW_COORDINATES"] = "Koordinaten anzeigen"
L["SET_EQUIPMENT_SET"] = "Ausrüstungsset zuweisen"
L["NO_EQUIPMENT_SETS"] = "Keine Ausrüstungssets"
L["CURRENT_EQUIPMENT_SET"] = "Aktuelles Set"

-- Master Volume
L["MASTER_VOLUME"] = "Hauptlautstärke"
L["VOLUME_STEP"] = "Lautstärken Schritte"
L["ENABLE_MOUSE_WHEEL"] = "Aktiviert MAusrad"
L["CURRENT_AUDIO_OUTPUT"] = "Aktuelle Ausgabe"
L["SET_AUDIO_OUTPUT"] = "Audio Ausgabe festlegen"
L["NO_AUDIO_OUTPUT_DEVICES"] = "Keine Audio Ausgabegeräte"

-- DataBrokers
L["DATABROKERS"] = "DataBroker"
L["DATABROKERS_PLUGINS"] = "DataBroker Plugins"
L["DATABROKERS_NONE_AVAILABLE"] = "Keine DataBroker Plugins erkannt. Aktiviere ein LibDataBroker-Plugin-Addon, um es hier aufzulisten."
L["DATABROKERS_SHOW_ICON"] = "Symbol anzeigen"
L["DATABROKERS_ICON_SIZE"] = "Symbolgröße"
L["DATABROKERS_SHOW_TEXT"] = "Text anzeigen"
L["DATABROKERS_SHOW_DATA_SOURCES"] = "Datenquellen anzeigen"
L["DATABROKERS_SHOW_LAUNCHERS"] = "Starter anzeigen"
L["DATABROKERS_OTHER"] = "Sonstige"

-- Clock
L["TIME_FORMAT"] = "Uhrzeit Format"
L["USE_SERVER_TIME"] = "Serverzeit benutzen"
L["NEW_EVENT"] = "Neue Veranstaltung!"
L["LOCAL_TIME"] = "Lokale Zeit"
L["REALM_TIME"] = "Realm Zeit"
L["OPEN_CALENDAR"] = "Kalendar öffnen"
L["OPEN_CLOCK"] = "Stoppuhr öffnen"
L["HIDE_EVENT_TEXT"] = "Eventtext verstecken"
L["CLOCK_SHOW_LOCKOUTS"] = "Schlachtzugs Zuweisungen im Tooltip anzeigen"
L["CLOCK_SHOW_BOSSES_KILLED"] = "Besiegte Bosse anzeigen"
L["CLOCK_LOCKOUTS_HEADER"] = "Zuweisungen"
L["REST_ICON"] = "Ausgeruhtsymbol"
L["SHOW_REST_ICON"] = "Zeige Ausgeruhtsymbol"
L["TEXTURE"] = "Textur"
L["DEFAULT"] = "Standart"
L["CUSTOM"] = "Benutzerdefiniert"
L["CUSTOM_TEXTURE"] = "Benutzerdefinierte Textur"
L["HIDE_REST_ICON_MAX_LEVEL"] = "Verstecken auf Max Stufe"
L["TEXTURE_SIZE"] = "Texturgröße"
L["POSITION"] = "Position"
L["CUSTOM_TEXTURE_COLOR"] = "Benutzerdefinierte Farbe"
L["COLOR"] = "Farbe"

L["TRAVEL"] = "Reise"
L["PORT_OPTIONS"] = "Teleport Einstellungen"
L["READY"] = "Bereit"
L["TRAVEL_COOLDOWNS"] = "Reise Abklingzeiten"
L["CHANGE_PORT_OPTION"] = "Teleport Einstellungen ändern"

-- Gold
L["REGISTERED_CHARACTERS"] = "Registrierte Charaktere"
L["SHOW_FREE_BAG_SPACE"] = "Zeige Freie Taschenplätze"
L["SHOW_OTHER_REALMS"] = "Zeige andere Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Silber und Kupfer immer anzeigen"
L["SHORTEN_GOLD"] = "Gold abkürzen"
L["TOGGLE_BAGS"] = "Taschen anzeigen"
L["SESSION_TOTAL"] = "Sitzung total"
L["DAILY_TOTAL"] = "Heute total"
L["SHOW_TOKEN_PRICE"] = "Markenpreis anzeigen"
L["SHOW_WARBAND_BANK_GOLD"] = "Kriegsmeuten Bankgold anzeigen"
L["GOLD_ROUNDED_VALUES"] = "Gold runden"
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Charaktere unter Schwelle ausblenden"
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Schwellenwert"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Erfahrungsleiste unter Levelcap anzeigen"
L["CLASS_COLORS_XP_BAR"] = "Klassenfarbe für Erfahrungsleiste benutzen"
L["SHOW_TOOLTIPS"] = "Tooltips anzeigen"
L["TEXT_ON_RIGHT"] = "Text auf der rechten Seite"
L["BAR_CURRENCY_SELECT"] = "Auf der Leiste angezeigte Währungen"
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
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Öffne XIV Währungseinstellungen"

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
L["SHOW_LAST_REPUTATION_GAINED"] = "Zuletzt erhaltenen Ruf anzeigen"
L["FLASH_PARAGON_REWARD"] = "Aufblitzen bei Paragonbelohnung"
L["PROGRESS"] = "Fortschritt"
L["RANK"] = "Rang"
L["PARAGON"] = "Paragon"

-- Tradeskills
L["USE_CLASS_COLORS"] = "Klassenfarben benutzen"
L["USE_INTERACTIVE_TOOLTIP"] = "Interaktiven Tooltip verwenden"
L["COOLDOWNS"] = "Abklingzeiten"
L["TOGGLE_PROFESSION_FRAME"] = "Berufsfenster anzeigen"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Zauberbuch für Berufe anzeigen"

L["SET_SPECIALIZATION"] = "Spezialisierung auswählen"
L["SET_LOADOUT"] = "Konfiguration auswählen"
L["SET_LOOT_SPECIALIZATION"] = "Beute Spezialisierung auswählen"
L["CURRENT_SPECIALIZATION"] = "Aktuelle Spezialisierung"
L["CURRENT_LOOT_SPECIALIZATION"] = "Aktuelle Beute Spezialisierung"
L["ENABLE_LOADOUT_SWITCHER"] = "Ausrüstungsswitcher aktivieren"
L["TALENT_MINIMUM_WIDTH"] = "Minimale Breite für Talente"
L["OPEN_ARTIFACT"] = "Artefakt öffen"
L["REMAINING"] = "Verbleibend"
L["KILLS_TO_LEVEL"] = "Kills bis Stufenaufstieg"
L["LAST_XP_GAIN"] = "Letzter EP Gewinn"
L["AVAILABLE_RANKS"] = "Verfügbare Ränge"
L["ARTIFACT_KNOWLEDGE"] = "Artefaktwissen"

L["SHOW_BUTTON_TEXT"] = "Zeige Tastentext"

-- Travel
L["HEARTHSTONE"] = "Ruhestein"
L["M_PLUS_TELEPORTS"] = "M+ Teleporter"
L["ONLY_SHOW_CURRENT_SEASON"] = "Zeige nur aktuelle Season"
L["MYTHIC_PLUS_TELEPORTS"] = "Mythisch+ Teleporter"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "M+ Teleportertext ausblenden"
L["SHOW_SEASON_DATES"] = "Saisondaten anzeigen"
L["SEASON_DATE_RANGE"] = "Vom %s bis %s"
L["SEASON_DATE_FROM"] = "Ab %s"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Zeige Mythisch+ Teleporter"
L["MYTHIC_TELEPORT_SHARED_CD"] = "Gemeinsame 8-Stunden Abklingzeit (wird nach Abschluss eines Mythisch+-Dungeons zurückgesetzt)"
L["SHOW_MYTHIC_TELEPORT_POPUP"] = "Teleport Popup anzeigen"
L["USE_RANDOM_HEARTHSTONE"] = "Nutze zufälligen Ruhestein"
local retrievingData = "Retrieving data..."
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

-- TODO: L["CLASSIC"] = "Classic"
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
L["NEXT_SEASON"] = "Nächste Season"

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
L["PROFILE_IMPORT_EXPORT"] = "Profile Import/Export"
L["EXPORT_PROFILE"] = "Profil Exportieren"
L["EXPORT_PROFILE_DESC"] = "Exportiere Deine aktuellen Profileinstellungen"
L["IMPORT_PROFILE"] = "Profil Importieren"
L["IMPORT_PROFILE_DESC"] = "Importiere ein Profil von einem anderen Spieler"

L["PROFILE_SETUP_HEADER"] = "XIV_Databar Continued"
L["PROFILE_SETUP_TEXT"] = "Das Profilsystem wurde migriert: Dieser Charakter verwendet noch das alte, geteilte Standardprofil.\n\nWähle, wie dieser Charakter fortfahren soll:\n- |cffffd100Aktuelles Profil behalten:|r Auf dem geteilten Standardprofil bleiben (empfohlen)\n- |cffffd100Geteiltes Profil kopieren:|r Persönliches Profil basierend auf den aktuellen geteilten Einstellungen\n- |cffffd100Leeres Profil erstellen:|r Persönliches Profil mit Standardeinstellungen (setzt diesen Charakter zurück)\n\nDu kannst Profile auch später in den Profileinstellungen verwalten."
L["PROFILE_SETUP_CURRENT"] = "Aktuelles Profil: %s"
L["PROFILE_SETUP_NEW_BLANK"] = "Leeres Profil erstellen"
L["PROFILE_SETUP_NEW_FROM_SHARED"] = "Geteiltes Profil kopieren"
L["PROFILE_SETUP_KEEP_CURRENT"] = "Aktuelles Profil behalten"
L["PROFILE_NEWCHAR_TEXT"] = "Dieser Charakter beginnt mit einem leeren persönlichen Profil.\n\n- |cffffd100Aktuelles Profil behalten:|r Das leere persönliche Profil dieses Charakters behalten\n- |cffffd100Geteiltes Profil nutzen:|r Dem geteilten Standardprofil beitreten (Einstellungen bleiben synchron)\n\nDu kannst dies später in den Profileinstellungen ändern."
L["PROFILE_NEWCHAR_USE_SHARED"] = "Geteiltes Profil nutzen"

L["DISABLE_LOGIN_MESSAGE"] = "Login-Nachricht deaktivieren"
L["ADDON_LOADED_MSG"] = "geladen. Gib /xivc ein, um die Einstellungen zu öffnen."
L["UPDATE_ANNOUNCE"] = "wurde auf %s aktualisiert,"
L["OPEN_CHANGELOG"] = "Änderungsprotokoll öffnen"
L["CHANGELOG_AFTER_COMBAT"] = "Das Änderungsprotokoll wird nach dem Kampf geöffnet"

-- Changelog
L["IMPORTANT"] = "Wichtig"
L["NEW"] = "Neu"
L["IMPROVEMENT"] = "Verbesserung"
L["BUGFIX"] = "Fehlerbehebung"
L["CHANGELOG"] = "Änderungen"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "Die Große Schatzkammer ist derzeit deaktiviert, bis die nächste Saison beginnt."
L["MAX_LEVEL_DISCLAIMER"] = "Dieses Modul wird erst angezeigt, wenn Du die maximale Stufe erreicht hast."
L["VAULT_ALERT_COLOR"] = "Warnfarbe"
L["VAULT_ENABLE_REWARD_ALERT"] = "Warnung für verfügbare Belohnungen aktivieren"
L["VAULT_FLASH_ALERT"] = "Ausstehende Belohnung aufblitzen lassen"
L["VAULT_FLASH_INTERVAL"] = "Blinkintervall"
L["VAULT_REWARD_ALERTS"] = "Belohnungswarnung"
L["VAULT_SNOOZE_CHAT"] = "Schlummer-Chatnachricht anzeigen"
L["VAULT_SNOOZE_CHAT_MESSAGE"] = "Schatzkammer-Warnung für %s stummgeschaltet."
L["VAULT_SNOOZE_FLASH"] = "Warnblinken pausieren"
L["VAULT_SNOOZE_MINUTES"] = "Schlummerdauer für Blinken (Minuten)"
