local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "ruRU", false, false)
if not L then return end

-- Reference:
-- Some strings below are sourced from BlizzardInterfaceResources.
-- Source: https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/ruRU.lua
-- @Translation Team: If you find a false positive (a string that should stay identical),
-- add `-- @no-translate` at the end of the line so the locale sync script ignores it.

L["MODULES"] = "Модули"
L["LEFT_CLICK"] = "Левая кнопка мыши"
L["RIGHT_CLICK"] = "Правая кнопка мыши"
L["k"] = "Тыс."
L["M"] = "Млн."
L["B"] = "Млрд."
L["L"] = "Л"
L["W"] = "Г"

-- General
L["POSITIONING"] = "Позиция"
L["BAR_POSITION"] = "Положение полосы"
L["TOP"] = "Вверху"
L["BOTTOM"] = "Внизу"
L["BAR_COLOR"] = "Цвет полосы"
L["USE_CLASS_COLOR"] = "Использовать цвет класса для полосы"
L["MISCELLANEOUS"] = "Разное"
L["HIDE_IN_COMBAT"] = "Прятать полосу во время боя"
-- TODO: L["HIDE_IN_FLIGHT"] = "Hide when in flight"
-- TODO: L["SHOW_ON_MOUSEOVER"] = "Show on mouseover"
-- TODO: L["SHOW_ON_MOUSEOVER_DESC"] = "Show the bar only when you mouseover it"
L["BAR_PADDING"] = "Заполнение"
L["MODULE_SPACING"] = "Расстояние между модулями"
L["BAR_MARGIN"] = "Маржа бара"
-- TODO: L["BAR_MARGIN_DESC"] = "Leftmost and rightmost margin of the bar modules"
L["HIDE_ORDER_HALL_BAR"] = "Прятать полосу оплота класса"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Используйте ElvUI для подсказок"
-- TODO: L["LOCK_BAR"] = "Lock Bar"
-- TODO: L["LOCK_BAR_DESC"] = "Lock the bar to prevent dragging"
-- TODO: L["BAR_FULLSCREEN_DESC"] = "Makes the bar span the entire screen width"
-- TODO: L["BAR_POSITION_DESC"] = "Position the bar at the top or bottom of the screen"
-- TODO: L["X_OFFSET"] = "X Offset"
-- TODO: L["Y_OFFSET"] = "Y Offset"
-- TODO: L["HORIZONTAL_POSITION"] = "Horizontal position of the bar"
-- TODO: L["VERTICAL_POSITION"] = "Vertical position of the bar"
-- TODO: L["BEHAVIOR"] = "Behavior"
-- TODO: L["SPACING"] = "Spacing"

-- Modules Positioning
-- TODO: L["MODULES_POSITIONING"] = "Modules Positioning"
-- TODO: L["ENABLE_FREE_PLACEMENT"] = "Enable free placement"
-- TODO: L["ENABLE_FREE_PLACEMENT_DESC"] = "Enable independent X positioning for each module and disable inter-module anchors"
-- TODO: L["RESET_ALL_POSITIONS"] = "Reset All Positions"
-- TODO: L["RESET_ALL_POSITIONS_DESC"] = "Reset all modules to their initial free placement positions"
-- TODO: L["ANCHOR_POINT"] = "Anchor Point"
-- TODO: L["X_POSITION"] = "X Position"
-- TODO: L["RESET_POSITION"] = "Reset Position"
-- TODO: L["RESET_POSITION_DESC"] = "Reset to the anchored position"
-- TODO: L["RECAPTURE_INITIAL_POSITIONS"] = "Re-capture initial positions"
-- TODO: L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Capture the current anchored positions as the new initial free placement positions"

-- Positioning Options
L["BAR_WIDTH"] = "Ширина полосы"
L["LEFT"] = "Слева"
L["CENTER"] = "По центру"
L["RIGHT"] = "Справа"

-- Media
L["FONT"] = "Шрифт"
L["SMALL_FONT_SIZE"] = "Размер маленького шрифта"
L["TEXT_STYLE"] = "Стиль текста"

-- Text Colors
L["COLORS"] = "Цвета"
L["TEXT_COLORS"] = "Цвета текста"
L["NORMAL"] = "Обычный"
L["INACTIVE"] = "Неактивно"
L["USE_CLASS_COLOR_TEXT"] = "Использовать цвет класса для текста"
L["USE_CLASS_COLOR_TEXT_DESC"] = "В выборе цвета можно указать только прозрачность"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Использовать цвет класса при наведении"
L["HOVER"] = "По наведению"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Микроменю"
L["SHOW_SOCIAL_TOOLTIPS"] = "Показывать подсказки гильдии и друзей"
-- TODO: L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Show Accessibility Tooltips"
-- TODO: L["BLIZZARD_MICROMENU"] = "Blizzard Micromenu"
-- TODO: L["DISABLE_BLIZZARD_MICROMENU"] = "Disable Blizzard Micromenu"
-- TODO: L["KEEP_QUEUE_STATUS_ICON"] = "Keep Queue Status Icon"
-- TODO: L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
-- TODO: L["BLIZZARD_BAGS_BAR"] = "Blizzard Bags Bar"
-- TODO: L["DISABLE_BLIZZARD_BAGS_BAR"] = "Disable Blizzard Bags Bar"
-- TODO: L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Расстояние от кнопки меню до других кнопок"
L["ICON_SPACING"] = "Расстояние между кнопками"
-- TODO: L["HIDE_BNET_APP_FRIENDS"] = "Hide BNet App Friends"
L["OPEN_GUILD_PAGE"] = "Открыть страницу гильдии"
L["NO_TAG"] = "Нет Battletag"
L["WHISPER_BNET"] = "Шепнуть по Battle.Net"
L["WHISPER_CHARACTER"] = "Шепнуть персонажу"
L["HIDE_SOCIAL_TEXT"] = "Скрыть количество онлайна гильдии и друзей"
L["SOCIAL_TEXT_OFFSET"] = "Смещение текста в социальных сетях"
L["GMOTD_IN_TOOLTIP"] = "Сообщение дня гильдии в подсказке"
L["FRIEND_INVITE_MODIFIER"] = "Модификатор для приглашения друзей"
L["SHOW_HIDE_BUTTONS"] = "Показать/скрыть кнопки"
L["SHOW_MENU_BUTTON"] = "Меню"
L["SHOW_CHAT_BUTTON"] = "Выбор чата"
L["SHOW_GUILD_BUTTON"] = "Гильдия"
L["SHOW_SOCIAL_BUTTON"] = "Общение"
L["SHOW_CHARACTER_BUTTON"] = "Информация о персонаже"
L["SHOW_SPELLBOOK_BUTTON"] = "Способности"
-- TODO: L["SHOW_PROFESSIONS_BUTTON"] = "Show Professions Button"
L["SHOW_TALENTS_BUTTON"] = "Специализация и таланты"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Достижения"
L["SHOW_QUESTS_BUTTON"] = "Журнал заданий"
L["SHOW_LFG_BUTTON"] = "Поиск группы"
L["SHOW_JOURNAL_BUTTON"] = "Путеводитель по приключениям"
L["SHOW_PVP_BUTTON"] = "Игрок против игрока"
L["SHOW_PETS_BUTTON"] = "Коллекции"
L["SHOW_SHOP_BUTTON"] = "Магазин"
L["SHOW_HELP_BUTTON"] = "Помощь"
-- TODO: L["SHOW_HOUSING_BUTTON"] = "Show Housing Button"
L["NO_INFO"] = "Нет информации"
-- TODO: L["Alliance"] = FACTION_ALLIANCE
-- TODO: L["Horde"] = FACTION_HORDE
-- TODO: L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Hide Tooltips in Combat"

L["DURABILITY_WARNING_THRESHOLD"] = "Порог предупреждения о долговечности"
L["SHOW_ITEM_LEVEL"] = "Показать уровень элемента"
L["SHOW_COORDINATES"] = "Показать координаты"

-- Master Volume
L["MASTER_VOLUME"] = "Громкость игры"
L["VOLUME_STEP"] = "Шаг изменения громкости"
-- TODO: L["ENABLE_MOUSE_WHEEL"] = "Enable Mouse Wheel"

-- Clock
L["TIME_FORMAT"] = "Формат времени"
L["USE_SERVER_TIME"] = "Использовать серверное время"
L["NEW_EVENT"] = "Новое событие!"
L["LOCAL_TIME"] = "Местное время"
L["REALM_TIME"] = "Серверное время"
L["OPEN_CALENDAR"] = "Открыть календарь"
L["OPEN_CLOCK"] = "Открыть часы"
L["HIDE_EVENT_TEXT"] = "Скрыть текст событий"
-- TODO: L["REST_ICON"] = "Rest Icon"
-- TODO: L["SHOW_REST_ICON"] = "Show Rest Icon"
-- TODO: L["TEXTURE"] = "Texture"
-- TODO: L["DEFAULT"] = "Default"
-- TODO: L["CUSTOM"] = "Custom"
-- TODO: L["CUSTOM_TEXTURE"] = "Custom Texture"
-- TODO: L["HIDE_REST_ICON_MAX_LEVEL"] = "Hide at Max Level"
-- TODO: L["TEXTURE_SIZE"] = "Texture Size"
-- TODO: L["POSITION"] = "Position"
-- TODO: L["CUSTOM_TEXTURE_COLOR"] = "Custom Color"
-- TODO: L["COLOR"] = "Color"

L["TRAVEL"] = "Перемещение"
L["PORT_OPTIONS"] = "Назначение телепорта"
L["READY"] = "Готово"
L["TRAVEL_COOLDOWNS"] = "Способности для перемещения"
L["CHANGE_PORT_OPTION"] = "Изменить назначение телепорта"

-- Gold
-- TODO: L["REGISTERED_CHARACTERS"] = "Registered characters"
-- TODO: L["SHOW_FREE_BAG_SPACE"] = "Show Free Bag Space"
-- TODO: L["SHOW_OTHER_REALMS"] = "Show Other Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Всегда показывать серебро и медь"
L["SHORTEN_GOLD"] = "Сокращать число золота"
L["TOGGLE_BAGS"] = "Переключить видимость сумок"
L["SESSION_TOTAL"] = "Всего за сессию"
-- TODO: L["DAILY_TOTAL"] = "Daily Total"
-- TODO: L["SHOW_TOKEN_PRICE"] = "Show Token Price"
-- TODO: L["SHOW_WARBAND_BANK_GOLD"] = "Show Bank Gold"
-- TODO: L["GOLD_ROUNDED_VALUES"] = "Gold rounded values"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD"] = "Hide Characters Under Threshold"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Threshold"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Показывать полоску опыта персонажам, не достигшим максимального уровня"
L["CLASS_COLORS_XP_BAR"] = "Использовать цвет класса для полоски опыта"
L["SHOW_TOOLTIPS"] = "Показывать подсказки"
L["TEXT_ON_RIGHT"] = "Текст справа"
-- TODO: L["BAR_CURRENCY_SELECT"] = "Currencies displayed on the bar"
L["FIRST_CURRENCY"] = "Валюта №1"
L["SECOND_CURRENCY"] = "Валюта №2"
L["THIRD_CURRENCY"] = "Валюта №3"
L["RESTED"] = "Отдых"
-- TODO: L["SHOW_MORE_CURRENCIES"] = "Show More Currencies on Shift+Hover"
-- TODO: L["MAX_CURRENCIES_SHOWN"] = "Max currencies shown when holding Shift"
-- TODO: L["ONLY_SHOW_MODULE_ICON"] = "Only Show Module Icon"
-- TODO: L["CURRENCY_NUMBER"] = "Number of Currencies on Bar"
-- TODO: L["CURRENCY_SELECTION"] = "Currency Selection"
-- TODO: L["SELECT_ALL"] = "Select All"
-- TODO: L["UNSELECT_ALL"] = "Unselect All"
-- TODO: L["OPEN_XIV_CURRENCY_OPTIONS"] = "Open XIV's Currency Options"

-- System
L["WORLD_PING"] = "Показывать задержку сервера"
L["ADDONS_NUMBER_TO_SHOW"] = "Сколько аддонов показывать"
L["ADDONS_IN_TOOLTIP"] = "Сколько аддонов показывать"
L["SHOW_ALL_ADDONS"] = "Показывать все аддоны по нажатию кнопки Shift"
L["MEMORY_USAGE"] = "Использование памяти"
L["GARBAGE_COLLECT"] = "Очистить память"
L["CLEANED"] = "Очищено"

-- Reputation
-- TODO: L["OPEN_REPUTATION"] = "Open " .. REPUTATION
-- TODO: L["PARAGON_REWARD_AVAILABLE"] = "Paragon Reward available"
-- TODO: L["CLASS_COLORS_REPUTATION"] = "Use Class Colors for Reputation Bar"
-- TODO: L["REPUTATION_COLORS_REPUTATION"] = "Use Reputation Colors for Reputation Bar"
-- TODO: L["SHOW_LAST_REPUTATION_GAINED"] = "Show last gained reputation"
-- TODO: L["FLASH_PARAGON_REWARD"] = "Flash on Paragon Reward"
-- TODO: L["PROGRESS"] = "Progress"
-- TODO: L["RANK"] = "Rank"
-- TODO: L["PARAGON"] = "Paragon"

-- Tradeskills
L["USE_CLASS_COLORS"] = "Использовать цвет класса"
-- TODO: L["USE_INTERACTIVE_TOOLTIP"] = "Use Interactive Tooltip"
L["COOLDOWNS"] = "Кулдауны"
L["TOGGLE_PROFESSION_FRAME"] = 'Показать кадр профессии'
L["TOGGLE_PROFESSION_SPELLBOOK"] = 'показать книгу заклинаний профессии'

L["SET_SPECIALIZATION"] = "Выбрать специализацию"
-- TODO: L["SET_LOADOUT"] = "Set Loadout"
L["SET_LOOT_SPECIALIZATION"] = "Выбрать специализацию для добычи"
L["CURRENT_SPECIALIZATION"] = "Текущая специализация"
L["CURRENT_LOOT_SPECIALIZATION"] = "Текущая специализация для добычи"
-- TODO: L["ENABLE_LOADOUT_SWITCHER"] = "Enable Loadout Switcher"
L["TALENT_MINIMUM_WIDTH"] = "Минимальная ширина модуля талантов"
L["OPEN_ARTIFACT"] = "Открыть меню артефакта"
L["REMAINING"] = "Осталось"
-- TODO: L["KILLS_TO_LEVEL"] = "Kills to level"
-- TODO: L["LAST_XP_GAIN"] = "Last xp gain"
L["AVAILABLE_RANKS"] = "Доступно уровней"
L["ARTIFACT_KNOWLEDGE"] = "Знание артефакта"

-- TODO: L["SHOW_BUTTON_TEXT"] = "Show Button Text"

-- Travel
-- TODO: L["HEARTHSTONE"] = "Hearthstone"
-- TODO: L["M_PLUS_TELEPORTS"] = "M+ Teleports"
-- TODO: L["ONLY_SHOW_CURRENT_SEASON"] = "Only show current season"
-- TODO: L["MYTHIC_PLUS_TELEPORTS"] = "Mythic+ Teleports"
-- TODO: L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Hide M+ Teleports text"
-- TODO: L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Show Mythic+ Teleports"
-- TODO: L["USE_RANDOM_HEARTHSTONE"] = "Use Random Hearthstone"
local retrievingData = "Retrieving data..."
-- TODO: L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Если вы видите '" .. retrievingData .. "' в списке ниже, просто переключите вкладку или откройте это меню заново, чтобы обновить данные."
-- TODO: L["HEARTHSTONES_SELECT"] = "Hearthstones Select"
-- TODO: L["HEARTHSTONES_SELECT_DESC"] = "Select which hearthstones to use (be careful if you select multiple hearthstones, you might want to check the 'Hearthstones Select' option)"
-- TODO: L["HIDE_HEARTHSTONE_BUTTON"] = "Hide Hearthstone Button"
-- TODO: L["HIDE_PORT_BUTTON"] = "Hide Port Button"
-- TODO: L["HIDE_HOME_BUTTON"] = "Hide Home Button"
-- TODO: L["HIDE_HEARTHSTONE_TEXT"] = "Hide Hearthstone Text"
-- TODO: L["HIDE_PORT_TEXT"] = "Hide Port Text"
-- TODO: L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Hide Additional Tooltip Text"
-- TODO: L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Hide the hearthstone bind location and the select port button in the tooltip."
-- TODO: L["NOT_LEARNED"] = "Not learned"
-- TODO: L["SHOW_UNLEARNED_TELEPORTS"] = "Show unlearned teleports"
-- TODO: L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Hide button during off-season"

-- House/Home Selection
-- TODO: L["HOME"] = "Home"
-- TODO: L["UNKNOWN_HOUSE"] = "Unknown House"
-- TODO: L["HOUSE"] = "House"
-- TODO: L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
-- TODO: L["SELECTED"] = "Selected"
-- TODO: L["CHANGE_HOME"] = "Change Home"
-- TODO: L["NO_HOUSES_OWNED"] = "No Houses Owned"
-- TODO: L["VISIT_SELECTED_HOME"] = "Visit Selected Home"

-- TODO: L["CLASSIC"] = "Classic"
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
L["CURRENT_SEASON"] = true

-- Profile Import/Export
-- TODO: L["PROFILE_SHARING"] = "Profile Sharing"

-- TODO: L["INVALID_IMPORT_STRING"] = "Invalid import string"
-- TODO: L["FAILED_DECODE_IMPORT_STRING"] = "Failed to decode import string"
-- TODO: L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Failed to decompress import string"
-- TODO: L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Failed to deserialize import string"
-- TODO: L["INVALID_PROFILE_FORMAT"] = "Invalid profile format"
-- TODO: L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Profile imported successfully as"

-- TODO: L["COPY_EXPORT_STRING"] = "Copy the export string below:"
-- TODO: L["PASTE_IMPORT_STRING"] = "Paste the import string below:"
-- TODO: L["IMPORT_EXPORT_PROFILES_DESC"] = "Import or export your profiles to share them with other players."
-- TODO: L["PROFILE_IMPORT_EXPORT"] = "Profile Import/Export"
-- TODO: L["EXPORT_PROFILE"] = "Export Profile"
-- TODO: L["EXPORT_PROFILE_DESC"] = "Export your current profile settings"
-- TODO: L["IMPORT_PROFILE"] = "Import Profile"
-- TODO: L["IMPORT_PROFILE_DESC"] = "Import a profile from another player"

-- Changelog
L["DATE_FORMAT"] = "%day%-%month%-%year%"
L["IMPORTANT"] = "Важные"
L["NEW"] = "Новые"
L["IMPROVEMENT"] = "Улучшения"
-- TODO: L["BUGFIX"] = "Bugfix"
L["CHANGELOG"] = "Журнал изменений"

-- Vault Module
-- TODO: L["GREAT_VAULT_DISABLED"] = "The Great Vault is currently disabled until the next season starts."
-- TODO: L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
