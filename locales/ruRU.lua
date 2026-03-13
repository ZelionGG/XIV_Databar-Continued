local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "ruRU", false, false)
if not L then return end

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
L["HIDE_IN_FLIGHT"] = true
L["SHOW_ON_MOUSEOVER"] = true -- Needs translation
L["SHOW_ON_MOUSEOVER_DESC"] = true -- Needs translation
L["BAR_PADDING"] = "Заполнение"
L["MODULE_SPACING"] = "Расстояние между модулями"
L["BAR_MARGIN"] = "Маржа бара" -- Need Translation ?
L["BAR_MARGIN_DESC"] = true -- Need translation
L["HIDE_ORDER_HALL_BAR"] = "Прятать полосу оплота класса"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Используйте ElvUI для подсказок"
L["LOCK_BAR"] = true
L["LOCK_BAR_DESC"] = true
L["BAR_FULLSCREEN_DESC"] = true
L["BAR_POSITION_DESC"] = true
L["X_OFFSET"] = true
L["Y_OFFSET"] = true
L["HORIZONTAL_POSITION"] = true
L["VERTICAL_POSITION"] = true
L["BEHAVIOR"] = true
L["SPACING"] = true

-- Modules Positioning
L["MODULES_POSITIONING"] = true
L["ENABLE_FREE_PLACEMENT"] = true
L["ENABLE_FREE_PLACEMENT_DESC"] = true
L["RESET_ALL_POSITIONS"] = true
L["RESET_ALL_POSITIONS_DESC"] = true
L["ANCHOR_POINT"] = true
L["X_POSITION"] = true
L["RESET_POSITION"] = true
L["RESET_POSITION_DESC"] = true
L["RECAPTURE_INITIAL_POSITIONS"] = true
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = true

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
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = true -- Needs Translation
L["BLIZZARD_MICROMENU"] = true
L["DISABLE_BLIZZARD_MICROMENU"] = true
L["KEEP_QUEUE_STATUS_ICON"] = true
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["BLIZZARD_BAGS_BAR"] = true
L["DISABLE_BLIZZARD_BAGS_BAR"] = true
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Расстояние от кнопки меню до других кнопок"
L["ICON_SPACING"] = "Расстояние между кнопками"
L["HIDE_BNET_APP_FRIENDS"] = true
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
L["SHOW_TALENTS_BUTTON"] = "Специализация и таланты"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Достижения"
L["SHOW_QUESTS_BUTTON"] = "Журнал заданий"
L["SHOW_LFG_BUTTON"] = "Поиск группы"
L["SHOW_JOURNAL_BUTTON"] = "Путеводитель по приключениям"
L["SHOW_PVP_BUTTON"] = "Игрок против игрока"
L["SHOW_PETS_BUTTON"] = "Коллекции"
L["SHOW_SHOP_BUTTON"] = "Магазин"
L["SHOW_HELP_BUTTON"] = "Помощь"
L["SHOW_HOUSING_BUTTON"] = true -- TODO: translate
L["NO_INFO"] = "Нет информации"
L["CLASSIC"] = true
L["ALLIANCE"] = "Альянс"
L["HORDE"] = "Орда"

L["DURABILITY_WARNING_THRESHOLD"] = "Порог предупреждения о долговечности"
L["SHOW_ITEM_LEVEL"] = "Показать уровень элемента"
L["SHOW_COORDINATES"] = "Показать координаты"

L["MASTER_VOLUME"] = "Громкость игры"
L["VOLUME_STEP"] = "Шаг изменения громкости"

L["TIME_FORMAT"] = "Формат времени"
L["USE_SERVER_TIME"] = "Использовать серверное время"
L["NEW_EVENT"] = "Новое событие!"
L["LOCAL_TIME"] = "Местное время"
L["REALM_TIME"] = "Серверное время"
L["OPEN_CALENDAR"] = "Открыть календарь"
L["OPEN_CLOCK"] = "Открыть часы"
L["HIDE_EVENT_TEXT"] = "Скрыть текст событий"

L["TRAVEL"] = "Перемещение"
L["PORT_OPTIONS"] = "Назначение телепорта"
L["READY"] = "Готово"
L["TRAVEL_COOLDOWNS"] = "Способности для перемещения"
L["CHANGE_PORT_OPTION"] = "Изменить назначение телепорта"

L["REGISTERED_CHARACTERS"] = true
L["SHOW_FREE_BAG_SPACE"] = true
L["SHOW_OTHER_REALMS"] = true
L["ALWAYS_SHOW_SILVER_COPPER"] = "Всегда показывать серебро и медь"
L["SHORTEN_GOLD"] = "Сокращать число золота"
L["TOGGLE_BAGS"] = "Переключить видимость сумок"
L["SESSION_TOTAL"] = "Всего за сессию"
L["DAILY_TOTAL"] = true
L["GOLD_ROUNDED_VALUES"] = true

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Показывать полоску опыта персонажам, не достигшим максимального уровня"
L["CLASS_COLORS_XP_BAR"] = "Использовать цвет класса для полоски опыта"
L["SHOW_TOOLTIPS"] = "Показывать подсказки"
L["TEXT_ON_RIGHT"] = "Текст справа"
L["CURRENCY_SELECT"] = "Выбор валют"
L["FIRST_CURRENCY"] = "Валюта №1"
L["SECOND_CURRENCY"] = "Валюта №2"
L["THIRD_CURRENCY"] = "Валюта №3"
L["RESTED"] = "Отдых"
L["SHOW_MORE_CURRENCIES"] = true -- To Translate
L["MAX_CURRENCIES_SHOWN"] = true -- To Translate
L["ONLY_SHOW_MODULE_ICON"] = true -- To Translate
L["CURRENCY_NUMBER"] = true -- To Translate
L["CURRENCY_SELECTION"] = true -- To Translate
L["SELECT_ALL"] = true -- To Translate
L["UNSELECT_ALL"] = true -- To Translate
L["OPEN_XIV_CURRENCY_OPTIONS"] = true -- To Translate

-- System
L["WORLD_PING"] = "Показывать задержку сервера"
L["ADDONS_NUMBER_TO_SHOW"] = "Сколько аддонов показывать"
L["ADDONS_IN_TOOLTIP"] = "Сколько аддонов показывать"
L["SHOW_ALL_ADDONS"] = "Показывать все аддоны по нажатию кнопки Shift"
L["MEMORY_USAGE"] = "Использование памяти"
L["GARBAGE_COLLECT"] = "Очистить память"
L["CLEANED"] = "Очищено"

-- Reputation
L["OPEN_REPUTATION"] = "Open " .. REPUTATION -- To Translate
L["PARAGON_REWARD_AVAILABLE"] = true -- To translate
L["CLASS_COLORS_REPUTATION"] = true -- To translate
L["REPUTATION_COLORS_REPUTATION"] = true -- To translate
L["FLASH_PARAGON_REWARD"] = true -- To translate
L["PROGRESS"] = true -- To translate
L["RANK"] = true -- To translate
L["PARAGON"] = true -- To translate

L["USE_CLASS_COLORS"] = "Использовать цвет класса"
L["COOLDOWNS"] = "Кулдауны"
L["TOGGLE_PROFESSION_FRAME"] = 'Показать кадр профессии'
L["TOGGLE_PROFESSION_SPELLBOOK"] = 'показать книгу заклинаний профессии'

L["SET_SPECIALIZATION"] = "Выбрать специализацию"
L["SET_LOADOUT"] = true -- Translation needed
L["SET_LOOT_SPECIALIZATION"] = "Выбрать специализацию для добычи"
L["CURRENT_SPECIALIZATION"] = "Текущая специализация"
L["CURRENT_LOOT_SPECIALIZATION"] = "Текущая специализация для добычи"
L["TALENT_MINIMUM_WIDTH"] = "Минимальная ширина модуля талантов"
L["OPEN_ARTIFACT"] = "Открыть меню артефакта"
L["REMAINING"] = "Осталось"
L["AVAILABLE_RANKS"] = "Доступно уровней"
L["ARTIFACT_KNOWLEDGE"] = "Знание артефакта"

L["SHOW_BUTTON_TEXT"] = true -- Needs Translation

-- Travel (Translation needed)
L["HEARTHSTONE"] = true
L["M_PLUS_TELEPORTS"] = true
L["ONLY_SHOW_CURRENT_SEASON"] = true
L["MYTHIC_PLUS_TELEPORTS"] = true
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = true -- Needs Translate
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = true
L["USE_RANDOM_HEARTHSTONE"] = true
local retrievingData = "Получение данных..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Если вы видите '" .. retrievingData .. "' в списке ниже, просто переключите вкладку или откройте это меню заново, чтобы обновить данные."
L["HEARTHSTONES_SELECT"] = true
L["HEARTHSTONES_SELECT_DESC"] = "Select which hearthstones to use (be careful if you select multiple hearthstones, you might want to check the 'Hearthstones Select' option)"
L["HIDE_HEARTHSTONE_BUTTON"] = true -- To Translate
L["HIDE_PORT_BUTTON"] = true -- To Translate
L["HIDE_HOME_BUTTON"] = true -- To Translate
L["HIDE_HEARTHSTONE_TEXT"] = true -- To Translate
L["HIDE_PORT_TEXT"] = true -- To Translate
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = true -- To Translate
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Hide the hearthstone bind location and the select port button in the tooltip." -- To Translate
L["NOT_LEARNED"] = true -- To Translate
L["SHOW_UNLEARNED_TELEPORTS"] = true -- To Translate
L["HIDE_BUTTON_DURING_OFF_SEASON"] = true -- To Translate

-- House/Home Selection
L["HOME"] = true -- To Translate
L["UNKNOWN_HOUSE"] = true -- To Translate
L["HOUSE"] = true -- To Translate
L["PLOT"] = true -- To Translate
L["SELECTED"] = true -- To Translate
L["CHANGE_HOME"] = true -- To Translate
L["NO_HOUSES_OWNED"] = true -- To Translate
L["VISIT_SELECTED_HOME"] = true -- To Translate

L["CLASSIC"] = true
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
L["PROFILE_SHARING"] = true

L["INVALID_IMPORT_STRING"] = true
L["FAILED_DECODE_IMPORT_STRING"] = true
L["FAILED_DECOMPRESS_IMPORT_STRING"] = true
L["FAILED_DESERIALIZE_IMPORT_STRING"] = true
L["INVALID_PROFILE_FORMAT"] = true
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = true

L["COPY_EXPORT_STRING"] = true
L["PASTE_IMPORT_STRING"] = true
L["IMPORT_EXPORT_PROFILES_DESC"] = true
L["PROFILE_IMPORT_EXPORT"] = true
L["EXPORT_PROFILE"] = true
L["EXPORT_PROFILE_DESC"] = true
L["IMPORT_PROFILE"] = true
L["IMPORT_PROFILE_DESC"] = true

-- Changelog
L["DATE_FORMAT"] = "%day%-%month%-%year%"
L["VERSION"] = "Версия"
L["IMPORTANT"] = "Важные"
L["NEW"] = "Новые"
L["IMPROVEMENT"] = "Улучшения"
L["BUGFIX"] = true -- To Translate
L["CHANGELOG"] = "Журнал изменений"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
