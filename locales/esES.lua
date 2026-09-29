local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhCN", false, false)
if not L then return end

-- Reference:
-- Some strings below are sourced from BlizzardInterfaceResources.
-- Source: https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/esES.lua
-- @Translation Team: If you find a false positive (a string that should stay identical),
-- add `-- @no-translate` at the end of the line so the locale sync script ignores it.

L["MODULES"] = "Módulos"
L["LEFT_CLICK"] = "Clic izquierdo"
L["RIGHT_CLICK"] = "Clic derecho"
L["k"] = "mil"   -- short for 1000
L["M"] = "mill." -- short for 1000000
L["B"] = "MM"    -- short for 1000000000
L["L"] = true    -- For the local ping
L["W"] = "M"     -- For the world ping

-- General
L["POSITIONING"] = "Posicionamiento"
L["BAR_POSITION"] = "Posición de barra"
L["TOP"] = "Superior"
L["BOTTOM"] = "Inferior"
L["BAR_COLOR"] = "Color de barra"
L["USE_CLASS_COLOR"] = "Usa colores de clase para la barra"
L["MISCELLANEOUS"] = "Miscelánea"
L["HIDE_IN_COMBAT"] = "Ocultar barra en combate"
L["HIDE_IN_FLIGHT"] = "Ocultar en vuelo"
L["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar al ratón"
L["SHOW_ON_MOUSEOVER_DESC"] = "Mostrar la barra sólo pasar al ratón"
L["BAR_PADDING"] = "Espaciado de barra"
L["MODULE_SPACING"] = "Espaciado de módulos"
L["BAR_MARGIN"] = "Margen de la barra"
L["BAR_MARGIN_DESC"] = "Márgen más a la izquierda y más a la derecha de los módulos de barra"
L["HIDE_ORDER_HALL_BAR"] = "Ocultar la barra de sala de orden"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Usa ElvUI para descripciones"
L["LOCK_BAR"] = "Bloquear barra"
L["LOCK_BAR_DESC"] = "Bloquear la barra para impedir arrastrando"
L["BAR_FULLSCREEN_DESC"] = "Hace la barra a la anchura de la pantalla toda"
L["BAR_POSITION_DESC"] = "Coloca la barra al superior o inferior de la pantalla"
L["X_OFFSET"] = "Desplazamiento X"
L["Y_OFFSET"] = "Desplazamiento Y"
L["HORIZONTAL_POSITION"] = "Posición horizontal de la barra"
L["VERTICAL_POSITION"] = "Posición vertical de la barra"
L["BEHAVIOR"] = "Configuración"
L["SPACING"] = "Espaciado"

-- Modules Positioning
L["MODULES_POSITIONING"] = "Posicionamiento de módulos"
L["ENABLE_FREE_PLACEMENT"] = "Habilitar colocación libre"
L["ENABLE_FREE_PLACEMENT_DESC"] = "Habilitar posicionamiento independiente de X por cada módulo y desactivar anclajes entre módulos"
L["RESET_ALL_POSITIONS"] = "Reiniciar todos los posiciones"
L["RESET_ALL_POSITIONS_DESC"] = "Restablecer todos módulos a posiciones de colocación libre inicial"
L["ANCHOR_POINT"] = "Punto de anclaje"
L["X_POSITION"] = "Posición X"
L["RESET_POSITION"] = "Reiniciar posición"
L["RESET_POSITION_DESC"] = "Restablecer a la posición anclada"
L["RECAPTURE_INITIAL_POSITIONS"] = "Re-capturar las posiciones inciales"
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Capturar las posiciones anclados actual como la nueva posiciones de colocación libre inicial"

-- Positioning Options
L["BAR_WIDTH"] = "Anchura de la barra"
L["LEFT"] = "Izquierda"
L["CENTER"] = "Centro"
L["RIGHT"] = "Derecha"

-- Media
L["FONT"] = "Fuente"
L["SMALL_FONT_SIZE"] = "Tamaño de la fuente pequeña"
L["TEXT_STYLE"] = "Estilo del texto"

-- Text Colors
L["COLORS"] = "Colores"
L["TEXT_COLORS"] = "Colores de texto"
L["NORMAL"] = "Normal"
L["INACTIVE"] = "Inactivo"
L["USE_CLASS_COLOR_TEXT"] = "Usa colores de clase para texto"
L["USE_CLASS_COLOR_TEXT_DESC"] = "Soló la alfa se puede establecer con el selector de color"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Usa colores de clase por ratón sobre"
L["HOVER"] = "Ratón sobre"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Micro menú"
L["SHOW_SOCIAL_TOOLTIPS"] = "Mostrar descripciones de Social"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Mostrar descripciones de accesibilidad"
L["BLIZZARD_MICROMENU"] = "Micro menú de Blizzard"
L["DISABLE_BLIZZARD_MICROMENU"] = "Desactivar micro menú de Blizzard"
L["KEEP_QUEUE_STATUS_ICON"] = "Mantener icono del estado de cola"
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'Este opción está desactivado porque un gestor externo se ha detectado: %s.'
L["BLIZZARD_BAGS_BAR"] = "Barra de bolsas de Blizzard"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Desactivar la barra de bolsas de Blizzard"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'Este opción está desactivado porque un gestor externo se ha detectado: %s.'
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Espaciado derecho del icono del menú principal"
L["ICON_SPACING"] = "Espaciado de iconos"
L["HIDE_BNET_APP_FRIENDS"] = "Ocultar amigos de BNet"
L["OPEN_GUILD_PAGE"] = "Abrir pagína de hermandad"
L["NO_TAG"] = "No etiqueta"
L["WHISPER_BNET"] = "Susurrar de BNet"
L["WHISPER_CHARACTER"] = "Susurra personaje"
L["HIDE_SOCIAL_TEXT"] = "Ocultar texto de social"
L["SOCIAL_TEXT_OFFSET"] = "Desplazamiento del texto social"
L["GMOTD_IN_TOOLTIP"] = "GMOTD en descripción"
L["FRIEND_INVITE_MODIFIER"] = "Modificar para invitación de amistad"
L["SHOW_HIDE_BUTTONS"] = "Mostrar/Ocultar botones"
L["SHOW_MENU_BUTTON"] = "Mostrar botón de menú"
L["SHOW_CHAT_BUTTON"] = "Mostrar botón de chat"
L["SHOW_GUILD_BUTTON"] = "Mostrar botón de hermandad"
L["SHOW_SOCIAL_BUTTON"] = "Mostrar botón social"
L["SHOW_CHARACTER_BUTTON"] = "Mostrar botón de personaje"
L["SHOW_SPELLBOOK_BUTTON"] = "Mostrar botón del libro de hechizos"
L["SHOW_PROFESSIONS_BUTTON"] = "Mostrar botón de profesiones"
L["SHOW_TALENTS_BUTTON"] = "Mostrar botón de talentos"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Mostrar botón de logros"
L["SHOW_QUESTS_BUTTON"] = "Mostrar botón de misiones"
L["SHOW_LFG_BUTTON"] = "Mostrar botón de LFG"
L["SHOW_JOURNAL_BUTTON"] = "Mostrar botón de diario"
L["SHOW_PVP_BUTTON"] = "Mostrar botón de JcJ"
L["SHOW_PETS_BUTTON"] = "Mostrar botón de mascotas"
L["SHOW_SHOP_BUTTON"] = "Mostrar botón de tienda"
L["SHOW_HELP_BUTTON"] = "Mostrar botón de ayuda"
L["SHOW_HOUSING_BUTTON"] = "Mostrar butón de hogares"
L["NO_INFO"] = "No Info" -- @no-translate
L["Alliance"] = FACTION_ALLIANCE
L["Horde"] = FACTION_HORDE
L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Mostrar descripciones en combate"

L["DURABILITY_WARNING_THRESHOLD"] = "Límite de aviso de durabilidad"
L["SHOW_ITEM_LEVEL"] = "Mostrar nivel de objecto"
L["SHOW_COORDINATES"] = "Mostrar coordenadas"
L["SET_EQUIPMENT_SET"] = "Establecer equipo"
L["NO_EQUIPMENT_SETS"] = "No equipamientos"
L["CURRENT_EQUIPMENT_SET"] = "Equipamiento actual"

-- Master Volume
L["MASTER_VOLUME"] = "Volumen general"
L["VOLUME_STEP"] = "Paso de volumen"
L["ENABLE_MOUSE_WHEEL"] = "Activar rueda del ratón"
L["CURRENT_AUDIO_OUTPUT"] = "Salida actual"
L["SET_AUDIO_OUTPUT"] = "Establecer salida de audio"
L["NO_AUDIO_OUTPUT_DEVICES"] = "No periféricos de salida"

-- DataBrokers
L["DATABROKERS"] = "DataBrokers" -- @no-translate
L["DATABROKERS_PLUGINS"] = "Plugins de DataBroker"
L["DATABROKERS_NONE_AVAILABLE"] = "No plugins de DataBroker son detectado. Habilitar un plugin addon de LibDataBroker a listar lo aquí."
L["DATABROKERS_SHOW_ICON"] = "Mostrar icono"
L["DATABROKERS_ICON_SIZE"] = "Tamaño de icono"
L["DATABROKERS_SHOW_TEXT"] = "Mostrar texto"
L["DATABROKERS_SHOW_DATA_SOURCES"] = "Mostrar origenes de datos"
L["DATABROKERS_SHOW_LAUNCHERS"] = "Mostrar lanzadores"
L["DATABROKERS_OTHER"] = "Otros"

-- Clock
L["TIME_FORMAT"] = "Formato de tiempo"
L["USE_SERVER_TIME"] = "Usar tiempo de servidor"
L["NEW_EVENT"] = "Nuevo evento!"
L["LOCAL_TIME"] = "Hora local"
L["REALM_TIME"] = "Hora del reino"
L["OPEN_CALENDAR"] = "Abrir calendario"
L["OPEN_CLOCK"] = "Abrir reloj"
L["HIDE_EVENT_TEXT"] = "Ocultar texto de evento"
L["CLOCK_SHOW_LOCKOUTS"] = "Mostrar registros en descripción"
L["CLOCK_SHOW_BOSSES_KILLED"] = "Mostrar jefes derrotados"
L["CLOCK_LOCKOUTS_HEADER"] = "Registros"
L["REST_ICON"] = "Icono de descansa"
L["SHOW_REST_ICON"] = "Mostrar icono de descansa"
L["TEXTURE"] = "Textura"
L["DEFAULT"] = "Predeterminado"
L["CUSTOM"] = "Personalizado"
L["CUSTOM_TEXTURE"] = "Textura personalizado"
L["HIDE_REST_ICON_MAX_LEVEL"] = "Ocultar a nivel máximo"
L["TEXTURE_SIZE"] = "Tamaño de textura"
L["POSITION"] = "Posición"
L["CUSTOM_TEXTURE_COLOR"] = "Color personalizado"
L["COLOR"] = "Color"

L["TRAVEL"] = "Viajar"
L["PORT_OPTIONS"] = "Opciones de portales"
L["READY"] = "Listo"
L["TRAVEL_COOLDOWNS"] = "Tiempos de reutilización de viajar"
L["CHANGE_PORT_OPTION"] = "Cambiar opción de portal"

-- Gold
L["REGISTERED_CHARACTERS"] = "Personajes registrados"
L["SHOW_FREE_BAG_SPACE"] = "Mostrar huecos en bolsas"
L["SHOW_OTHER_REALMS"] = "Mostrar otros reinos"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Siempre mostrar Plata y Cobre"
L["SHORTEN_GOLD"] = "Acortar oro"
L["TOGGLE_BAGS"] = "Mostrar/Ocultar bolsas"
L["SESSION_TOTAL"] = "Total de sesión"
L["DAILY_TOTAL"] = "Total de hoy"
L["SHOW_TOKEN_PRICE"] = "Mostrar precio de Ficha"
L["SHOW_WARBAND_BANK_GOLD"] = "Mostrar Oro en Banco"
L["GOLD_ROUNDED_VALUES"] = "Valores de oro redondeados"
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Ocultar personajes debajo del límite"
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Límite"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Muestra barra de experiencia debajo del nivel máximo"
L["CLASS_COLORS_XP_BAR"] = "Usa colores de clase para la barra de experiencia"
L["SHOW_TOOLTIPS"] = "Mostrar descripciones"
L["TEXT_ON_RIGHT"] = "Texto a la derecha"
L["BAR_CURRENCY_SELECT"] = "Monedas mostradas de la barra"
L["FIRST_CURRENCY"] = "Primera moneda"
L["SECOND_CURRENCY"] = "Segunda moneda"
L["THIRD_CURRENCY"] = "Tercera moneda"
L["RESTED"] = "Descansado"
L["SHOW_MORE_CURRENCIES"] = "Mostrar más monedas en Mayús+ratón sobre"
L["MAX_CURRENCIES_SHOWN"] = "Monedas máximas a mostrar cuando mantener pulsado Mayús"
L["ONLY_SHOW_MODULE_ICON"] = "Mostrar sólo icono de módulo"
L["CURRENCY_NUMBER"] = "Número de monedas en barra"
L["CURRENCY_SELECTION"] = "Seleccionar moneda"
L["SELECT_ALL"] = "Seleccionar todo"
L["UNSELECT_ALL"] = "Deseleccionar todo"
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Abrir opciones de moneda de XIV"

-- System
L["WORLD_PING"] = "Mostrar el ping de mundo"
L["ADDONS_NUMBER_TO_SHOW"] = "Número de addons a mostrar"
L["ADDONS_IN_TOOLTIP"] = "Addons a mostrar en la descripcion"
L["SHOW_ALL_ADDONS"] = "Mostrar todos los addons en descripción con Mayús"
L["MEMORY_USAGE"] = "Uso de memoria"
L["GARBAGE_COLLECT"] = "Recolectar basura"
L["CLEANED"] = "Limpiado"

-- Reputation
L["OPEN_REPUTATION"] = "Abrir " .. REPUTATION
L["PARAGON_REWARD_AVAILABLE"] = "Recompensa de reputación de dechado está disponible"
L["CLASS_COLORS_REPUTATION"] = "Usa colores de clase para barra de reputación"
L["REPUTATION_COLORS_REPUTATION"] = "Usa colores de reputación para barra de reputación"
L["SHOW_LAST_REPUTATION_GAINED"] = "Mostrar última reputación obtenida"
L["FLASH_PARAGON_REWARD"] = "Destella en recompensa de reputación de dechado"
L["PROGRESS"] = "Progreso"
L["RANK"] = "Rango"
L["PARAGON"] = "Dechado"

-- Tradeskills
L["USE_CLASS_COLORS"] = "Usa colores de clase"
L["USE_INTERACTIVE_TOOLTIP"] = "Usa descripción interactivo"
L["COOLDOWNS"] = "Tiempos de reutilización"
L["TOGGLE_PROFESSION_FRAME"] = "Mostrar/Ocultar marco de profesión"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Mostrar/Ocultar libro de hechizos de profesión"

L["SET_SPECIALIZATION"] = "Establece especialización"
L["SET_LOADOUT"] = "Establece configuración"
L["SET_LOOT_SPECIALIZATION"] = "Establece especialización de botín"
L["CURRENT_SPECIALIZATION"] = "Especialización actual"
L["CURRENT_LOOT_SPECIALIZATION"] = "Especialización actual de botín"
L["ENABLE_LOADOUT_SWITCHER"] = "Habilitar el selector de configuraciones"
L["TALENT_MINIMUM_WIDTH"] = "Anchura mínima de talento"
L["OPEN_ARTIFACT"] = "Abrir artefacto"
L["REMAINING"] = "Restante"
L["KILLS_TO_LEVEL"] = "Muertes para sube de nivel"
L["LAST_XP_GAIN"] = "Última obtención de experiencia"
L["AVAILABLE_RANKS"] = "Rangos disponibles"
L["ARTIFACT_KNOWLEDGE"] = "Conocimiento del artefacto"

L["SHOW_BUTTON_TEXT"] = "Mostrar texto del botón"

-- Travel
L["HEARTHSTONE"] = "Piedra de Hogar"
L["M_PLUS_TELEPORTS"] = "Teletransportes de M+"
L["ONLY_SHOW_CURRENT_SEASON"] = "Mostrar sólo temporada actual"
L["MYTHIC_PLUS_TELEPORTS"] = "Teletransportes de Mítica+"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Ocultar texto de teletransportes M+"
L["SHOW_SEASON_DATES"] = "Mostrar fechas de temporada"
L["SEASON_DATE_RANGE"] = "De %s a %s"
L["SEASON_DATE_FROM"] = "De %s"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Mostrar teletransportes Míticas+"
L["MYTHIC_TELEPORT_SHARED_CD"] = "Tiempo de reutilización compartido de ocho horas (Reinicio después completado una mazmorra Mítica+)"
L["SHOW_MYTHIC_TELEPORT_POPUP"] = "Mostrar ventana emergente de teletransportar"
L["USE_RANDOM_HEARTHSTONE"] = "Usa piedra de hogar aleatoria"
local retrievingData = "Obtenido datos..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Si ves '" .. retrievingData .. "' en la lista abajo, simplemente cambia pestañas o reabre este menú a actualizar el dato."
L["HEARTHSTONES_SELECT"] = "Seleccionar piedras de hogar"
L["HEARTHSTONES_SELECT_DESC"] = "Seleccionar cuales piedras de hogar a usar (tenga cuidado si selecciones muchas piedras de hogar, quizás quieras marca la opción 'Seleccionar piedras de hogar')"
L["HIDE_HEARTHSTONE_BUTTON"] = "Ocultar botón de piedra de hogar"
L["HIDE_PORT_BUTTON"] = "Mostrar botón de portal"
L["HIDE_HOME_BUTTON"] = "Ocultar botón de hogar"
L["HIDE_HEARTHSTONE_TEXT"] = "Ocultar texto de piedra de hogar"
L["HIDE_PORT_TEXT"] = "Ocultar texto de portal"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Ocultar texto adicional a descripción"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Ocultar la ubicación ligado de la piedra de hogar y el botón de seleccionar portales en la descripción."
L["NOT_LEARNED"] = "No aprendido"
L["SHOW_UNLEARNED_TELEPORTS"] = "Mostrar teletransportes desconocidos"
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Ocultar botón cuando no temporada"

-- House/Home Selection
L["HOME"] = "Hogar"
L["UNKNOWN_HOUSE"] = "Hogar desconocido"
L["HOUSE"] = "Casa"
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Seleccionadas"
L["CHANGE_HOME"] = "Cambia Casa"
L["NO_HOUSES_OWNED"] = "No casas posees"
L["VISIT_SELECTED_HOME"] = "Visitar hogar seleccionado"

L["CLASSIC"] = "Clásico"
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
L["CURRENT_SEASON"] = "Temporada actual"
L["NEXT_SEASON"] = "Temporada próxima"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Compartiendo de perfil"

L["INVALID_IMPORT_STRING"] = "La cadena de importación no válido"
L["FAILED_DECODE_IMPORT_STRING"] = "Falló descodificar la cadena de importación"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Falló descomprimir la cadena de importación"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Falló deserializar la cadena de importación"
L["INVALID_PROFILE_FORMAT"] = "El formato de perfil no válido"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Perfil importé correctamente a"

L["COPY_EXPORT_STRING"] = "Copiar la cadena de exportación abajo:"
L["PASTE_IMPORT_STRING"] = "Pegar la cadena de importación abajo:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Importar o exportar tus perfiles a compartirlos con otros jugadores."
L["PROFILE_IMPORT_EXPORT"] = "Importar/Exportar un perfil"
L["EXPORT_PROFILE"] = "Exportar un perfil"
L["EXPORT_PROFILE_DESC"] = "Exportar tuyo configuraciones de perfil actual"
L["IMPORT_PROFILE"] = "Importar un perfil"
L["IMPORT_PROFILE_DESC"] = "Importar un perfil de un otro jugador"

L["PROFILE_SETUP_HEADER"] = "XIV_Databar Continued" -- @no-translate
L["PROFILE_SETUP_TEXT"] = "La sistema de perfil ha emigrado: este personaje todavía usando el perfil legado de defecto compartido.\n\nElige como este personaje debe continuar:\n- |cffffd100Mantenga perfil actual:|r queda en el perfil de defecto (recomendado)\n- |cffffd100Copiar perfil compartido:|r perfil personal basada en tuyo configuraciones compartidos actual\n- |cffffd100Creer perfil en blanco:|r perfil personal con configuraciones de defecto (restablece este personaje)\n\nTambién puedes gestionar perfiles más tarde en las configuraciones Perfiles."
L["PROFILE_SETUP_CURRENT"] = "Perfil actual: %s"
L["PROFILE_SETUP_NEW_BLANK"] = "Creer perfil en blanco"
L["PROFILE_SETUP_NEW_FROM_SHARED"] = "Copiar perfil compartido"
L["PROFILE_SETUP_KEEP_CURRENT"] = "Mantener perfil actual"
L["PROFILE_NEWCHAR_TEXT"] = "Este personaje empieze con un perfil personal en blanco.\n\n- |cffffd100Mantenga perfil actual:|r mantenga el perfil personal en blanco de este personaje\n- |cffffd100Usa perfil compartido:|r unir el perfil compartido de defecto (configuraciones se mantiene en sincronía)\n\nPuedes cambiar lo este más tarde en las configuraciones Perfiles."
L["PROFILE_NEWCHAR_USE_SHARED"] = "Usa perfil compartido"

L["DISABLE_LOGIN_MESSAGE"] = "Desactivar mensaje de inicio de sesión"
L["ADDON_LOADED_MSG"] = "cargado, escribe /xivc a abrir configuraciones."
L["UPDATE_ANNOUNCE"] = "se actualizó a %s,"
L["OPEN_CHANGELOG"] = "Abrir registro de cambias"
L["CHANGELOG_AFTER_COMBAT"] = "Registro de cambias se abriré después el combate termina."

-- Changelog
L["DATE_FORMAT"] = "%month%-%day%-%year%" -- @no-translate
L["IMPORTANT"] = "Importante"
L["NEW"] = "Nuevo"
L["IMPROVEMENT"] = "Mejora"
L["BUGFIX"] = "Corrección de errores"
L["CHANGELOG"] = "Registro de cambios"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "La gran cámara está desactivado hasta la temporada próxima comienza."
L["MAX_LEVEL_DISCLAIMER"] = "Este módulo sólo aparecer cuando llegas al nivel máximo."
L["VAULT_ALERT_COLOR"] = "Color de alerta"
L["VAULT_ENABLE_REWARD_ALERT"] = "Habilitar alerta de recompensa disponible"
L["VAULT_FLASH_ALERT"] = "Destello recompensa pendiente"
L["VAULT_FLASH_INTERVAL"] = "Destello intervalo"
L["VAULT_REWARD_ALERTS"] = "Alerta de recompensa"
L["VAULT_SNOOZE_CHAT"] = "Mostrar mensaje de 'Posponer Chat'"
L["VAULT_SNOOZE_CHAT_MESSAGE"] = "Destello de alerta de Cámara posponé para %s."
L["VAULT_SNOOZE_FLASH"] = "Destello de alerta de posponer"
L["VAULT_SNOOZE_MINUTES"] = "Duración del destello de posponer (minutos)"
