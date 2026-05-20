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
-- Translator ZamestoTV
L["MODULES"] = "Модули"
L["LEFT_CLICK"] = "ЛКМ"
L["RIGHT_CLICK"] = "ПКМ"
L["k"] = "тыс." -- short for 1000
L["M"] = "млн" -- short for 1000000
L["B"] = "млрд" -- short for 1000000000
L["L"] = "Л" -- For the local ping
L["W"] = "М" -- For the world ping

-- General
L["POSITIONING"] = "Расположение"
L["BAR_POSITION"] = "Позиция панели"
L["TOP"] = "Вверху"
L["BOTTOM"] = "Внизу"
L["BAR_COLOR"] = "Цвет панели"
L["USE_CLASS_COLOR"] = "Цвет класса для панели"
L["MISCELLANEOUS"] = "Разное"
L["HIDE_IN_COMBAT"] = "Скрывать панель в бою"
L["HIDE_IN_FLIGHT"] = "Скрывать во время полета"
L["SHOW_ON_MOUSEOVER"] = "Показывать при наведении"
L["SHOW_ON_MOUSEOVER_DESC"] = "Показывать панель только тогда, когда вы наводите на нее курсор мыши"
L["BAR_PADDING"] = "Внутренний отступ панели"
L["MODULE_SPACING"] = "Расстояние между модулями"
L["BAR_MARGIN"] = "Внешний отступ панели"
L["BAR_MARGIN_DESC"] = "Левый и правый внешние отступы для модулей панели"
L["HIDE_ORDER_HALL_BAR"] = "Скрывать панель оплота класса"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Использовать ElvUI для подсказок"
L["LOCK_BAR"] = "Заблокировать панель"
L["LOCK_BAR_DESC"] = "Заблокировать панель, чтобы предотвратить ее перетаскивание"
L["BAR_FULLSCREEN_DESC"] = "Растягивает панель на всю ширину экрана"
L["BAR_POSITION_DESC"] = "Разместить панель вверху или внизу экрана"
L["X_OFFSET"] = "Смещение по X"
L["Y_OFFSET"] = "Смещение по Y"
L["HORIZONTAL_POSITION"] = "Горизонтальное положение панели"
L["VERTICAL_POSITION"] = "Вертикальное положение панели"
L["BEHAVIOR"] = "Поведение"
L["SPACING"] = "Расстояние"

-- Modules Positioning
L["MODULES_POSITIONING"] = "Расположение модулей"
L["ENABLE_FREE_PLACEMENT"] = "Включить свободное перемещение"
L["ENABLE_FREE_PLACEMENT_DESC"] = "Включает независимое позиционирование по оси X для каждого модуля и отключает привязку модулей друг к другу"
L["RESET_ALL_POSITIONS"] = "Сбросить все позиции"
L["RESET_ALL_POSITIONS_DESC"] = "Сбросить все модули в их исходные позиции свободного перемещения"
L["ANCHOR_POINT"] = "Точка привязки"
L["X_POSITION"] = "Позиция по X"
L["RESET_POSITION"] = "Сбросить позицию"
L["RESET_POSITION_DESC"] = "Сбросить к позиции привязки"
L["RECAPTURE_INITIAL_POSITIONS"] = "Перезаписать исходные позиции"
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Зафиксировать текущие позиции привязки как новые исходные позиции для свободного перемещения"

-- Positioning Options
L["BAR_WIDTH"] = "Ширина панели"
L["LEFT"] = "Слева"
L["CENTER"] = "По центру"
L["RIGHT"] = "Справа"

-- Media
L["FONT"] = "Шрифт"
L["SMALL_FONT_SIZE"] = "Маленький размер шрифта"
L["TEXT_STYLE"] = "Стиль текста"

-- Text Colors
L["COLORS"] = "Цвета"
L["TEXT_COLORS"] = "Цвета текста"
L["NORMAL"] = "Обычный"
L["INACTIVE"] = "Неактивный"
L["USE_CLASS_COLOR_TEXT"] = "Цвет класса для текста"
L["USE_CLASS_COLOR_TEXT_DESC"] = "С помощью палитры цветов можно настроить только прозрачность (альфа-канал)"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Цвет класса при наведении"
L["HOVER"] = "Наведение"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Микроменю"
L["SHOW_SOCIAL_TOOLTIPS"] = "Показывать вкладку общения в подсказках"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Показывать подсказки специальных возможностей"
L["BLIZZARD_MICROMENU"] = "Микроменю Blizzard"
L["DISABLE_BLIZZARD_MICROMENU"] = "Отключить микроменю Blizzard"
L["KEEP_QUEUE_STATUS_ICON"] = "Сохранять иконку статуса очереди"
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'Эта опция отключена, так как обнаружен внешний менеджер панелей: %s.'
L["BLIZZARD_BAGS_BAR"] = "Панель сумок Blizzard"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Отключить панель сумок Blizzard"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'Эта опция отключена, так как обнаружен внешний менеджер панелей: %s.'
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Отступ справа для иконки главного меню"
L["ICON_SPACING"] = "Расстояние между иконками"
L["HIDE_BNET_APP_FRIENDS"] = "Скрывать друзей из приложения BNet"
L["OPEN_GUILD_PAGE"] = "Открыть страницу гильдии"
L["NO_TAG"] = "Без тега"
L["WHISPER_BNET"] = "Шепнуть в BNet"
L["WHISPER_CHARACTER"] = "Шепнуть персонажу"
L["HIDE_SOCIAL_TEXT"] = "Скрывать текст общения"
L["SOCIAL_TEXT_OFFSET"] = "Смещение текста общения"
L["GMOTD_IN_TOOLTIP"] = "Сообщение дня гильдии в подсказке"
L["FRIEND_INVITE_MODIFIER"] = "Модификатор для приглашения друга"
L["SHOW_HIDE_BUTTONS"] = "Показать/скрыть кнопки"
L["SHOW_MENU_BUTTON"] = "Показывать кнопку меню"
L["SHOW_CHAT_BUTTON"] = "Показывать кнопку чата"
L["SHOW_GUILD_BUTTON"] = "Показывать кнопку гильдии"
L["SHOW_SOCIAL_BUTTON"] = "Показывать кнопку общения"
L["SHOW_CHARACTER_BUTTON"] = "Показывать кнопку персонажа"
L["SHOW_SPELLBOOK_BUTTON"] = "Показывать кнопку книги заклинаний"
L["SHOW_PROFESSIONS_BUTTON"] = "Показывать кнопку профессий"
L["SHOW_TALENTS_BUTTON"] = "Показывать кнопку талантов"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Показывать кнопку достижений"
L["SHOW_QUESTS_BUTTON"] = "Показывать кнопку заданий"
L["SHOW_LFG_BUTTON"] = "Показывать кнопку поиска группы"
L["SHOW_JOURNAL_BUTTON"] = "Показывать кнопку путеводителя"
L["SHOW_PVP_BUTTON"] = "Показывать кнопку PvP"
L["SHOW_PETS_BUTTON"] = "Показывать кнопку питомцев"
L["SHOW_SHOP_BUTTON"] = "Показывать кнопку магазина"
L["SHOW_HELP_BUTTON"] = "Показывать кнопку помощи"
L["SHOW_HOUSING_BUTTON"] = "Показывать кнопку жилища"
L["NO_INFO"] = "Нет информации"
L["Alliance"] = FACTION_ALLIANCE
L["Horde"] = FACTION_HORDE
L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Скрывать подсказки в бою"

L["DURABILITY_WARNING_THRESHOLD"] = "Порог предупреждения о прочности"
L["SHOW_ITEM_LEVEL"] = "Показывать уровень предметов"
L["SHOW_COORDINATES"] = "Показывать координаты"

-- Master Volume
L["MASTER_VOLUME"] = "Общая громкость"
L["VOLUME_STEP"] = "Шаг изменения громкости"
L["ENABLE_MOUSE_WHEEL"] = "Включить колесико мыши"

-- Clock
L["TIME_FORMAT"] = "Формат времени"
L["USE_SERVER_TIME"] = "Использовать серверное время"
L["NEW_EVENT"] = "Новое событие!"
L["LOCAL_TIME"] = "Местное время"
L["REALM_TIME"] = "Время игрового мира"
L["OPEN_CALENDAR"] = "Открыть календарь"
L["OPEN_CLOCK"] = "Открыть часы"
L["HIDE_EVENT_TEXT"] = "Скрывать текст события"
L["REST_ICON"] = "Иконка отдыха"
L["SHOW_REST_ICON"] = "Показывать иконку отдыха"
L["TEXTURE"] = "Текстура"
L["DEFAULT"] = "По умолчанию"
L["CUSTOM"] = "Пользовательская"
L["CUSTOM_TEXTURE"] = "Пользовательская текстура"
L["HIDE_REST_ICON_MAX_LEVEL"] = "Скрывать на максимальном уровне"
L["TEXTURE_SIZE"] = "Размер текстуры"
L["POSITION"] = "Позиция"
L["CUSTOM_TEXTURE_COLOR"] = "Пользовательский цвет"
L["COLOR"] = "Цвет"

L["TRAVEL"] = "Путешествие"
L["PORT_OPTIONS"] = "Варианты телепортации"
L["READY"] = "Готово"
L["TRAVEL_COOLDOWNS"] = "Восстановление телепортов"
L["CHANGE_PORT_OPTION"] = "Изменить вариант телепортации"

-- Gold
L["REGISTERED_CHARACTERS"] = "Зарегистрированные персонажи"
L["SHOW_FREE_BAG_SPACE"] = "Показывать свободное место в сумках"
L["SHOW_OTHER_REALMS"] = "Показывать другие игровые миры"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Всегда показывать серебро и медь"
L["SHORTEN_GOLD"] = "Сокращать золото"
L["TOGGLE_BAGS"] = "Открыть/закрыть сумки"
L["SESSION_TOTAL"] = "Всего за сессию"
L["DAILY_TOTAL"] = "Всего за день"
L["SHOW_TOKEN_PRICE"] = "Показывать цену жетона"
L["SHOW_WARBAND_BANK_GOLD"] = "Показывать золото в банке отряда"
L["GOLD_ROUNDED_VALUES"] = "Округлять значения золота"
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Скрывать персонажей ниже порога"
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Порог"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Показывать панель опыта ниже макс. уровня"
L["CLASS_COLORS_XP_BAR"] = "Цвет класса для панели опыта"
L["SHOW_TOOLTIPS"] = "Показывать подсказки"
L["TEXT_ON_RIGHT"] = "Текст справа"
L["BAR_CURRENCY_SELECT"] = "Валюты, отображаемые на панели"
L["FIRST_CURRENCY"] = "Первая валюта"
L["SECOND_CURRENCY"] = "Вторая валюта"
L["THIRD_CURRENCY"] = "Третья валюта"
L["RESTED"] = "Отдых"
L["SHOW_MORE_CURRENCIES"] = "Показывать больше валют при Shift+наведении"
L["MAX_CURRENCIES_SHOWN"] = "Макс. количество валют при зажатом Shift"
L["ONLY_SHOW_MODULE_ICON"] = "Показывать только иконку модуля"
L["CURRENCY_NUMBER"] = "Количество валют на панели"
L["CURRENCY_SELECTION"] = "Выбор валюты"
L["SELECT_ALL"] = "Выбрать все"
L["UNSELECT_ALL"] = "Снять выделение со всех"
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Открыть настройки валют XIV"

-- System
L["WORLD_PING"] = "Показывать пинг"
L["ADDONS_NUMBER_TO_SHOW"] = "Количество отображаемых аддонов"
L["ADDONS_IN_TOOLTIP"] = "Аддоны для отображения в подсказке"
L["SHOW_ALL_ADDONS"] = "Показывать все аддоны в подсказке при зажатом Shift"
L["MEMORY_USAGE"] = "Использование памяти"
L["GARBAGE_COLLECT"] = "Очистить память"
L["CLEANED"] = "Очищено"

-- Reputation
L["OPEN_REPUTATION"] = "Открыть " .. REPUTATION
L["PARAGON_REWARD_AVAILABLE"] = "Доступна награда идеала"
L["CLASS_COLORS_REPUTATION"] = "Цвет класса для панели репутации"
L["REPUTATION_COLORS_REPUTATION"] = "Цвета репутации для панели репутации"
L["SHOW_LAST_REPUTATION_GAINED"] = "Показывать последнюю полученную репутацию"
L["FLASH_PARAGON_REWARD"] = "Мигать при наличии награды идеала"
L["PROGRESS"] = "Прогресс"
L["RANK"] = "Уровень"
L["PARAGON"] = "Идеал"

-- Tradeskills
L["USE_CLASS_COLORS"] = "Использовать цвета классов"
L["USE_INTERACTIVE_TOOLTIP"] = "Использовать интерактивную подсказку"
L["COOLDOWNS"] = "Время восстановления"
L["TOGGLE_PROFESSION_FRAME"] = "Открыть/закрыть окно профессий"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Открыть/закрыть книгу профессий"

L["SET_SPECIALIZATION"] = "Сменить специализацию"
L["SET_LOADOUT"] = "Выбрать комплект талантов"
L["SET_LOOT_SPECIALIZATION"] = "Выбрать специализацию для добычи"
L["CURRENT_SPECIALIZATION"] = "Текущая специализация"
L["CURRENT_LOOT_SPECIALIZATION"] = "Текущая специализация для добычи"
L["ENABLE_LOADOUT_SWITCHER"] = "Включить переключатель комплектов талантов"
L["TALENT_MINIMUM_WIDTH"] = "Минимальная ширина талантов"
L["OPEN_ARTIFACT"] = "Открыть артефакт"
L["REMAINING"] = "Осталось"
L["KILLS_TO_LEVEL"] = "Убийств до уровня"
L["LAST_XP_GAIN"] = "Последнее получение опыта"
L["AVAILABLE_RANKS"] = "Доступные ранги"
L["ARTIFACT_KNOWLEDGE"] = "Знание артефакта"

L["SHOW_BUTTON_TEXT"] = "Показывать текст кнопок"

-- Travel
L["HEARTHSTONE"] = "Камень возвращения"
L["M_PLUS_TELEPORTS"] = "Телепорты М+"
L["ONLY_SHOW_CURRENT_SEASON"] = "Показывать только текущий сезон"
L["MYTHIC_PLUS_TELEPORTS"] = "Телепорты в эпохальные+ подземелья"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Скрывать текст телепортов М+"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Показывать телепорты в эпохальные+ подземелья"
L["USE_RANDOM_HEARTHSTONE"] = "Случайный камень возвращения"
local retrievingData = "Получение данных..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Если вы видите '" .. retrievingData .. "' в списке ниже, просто переключите вкладку или заново откройте это меню для обновления данных."
L["HEARTHSTONES_SELECT"] = "Выбор камней возвращения"
L["HEARTHSTONES_SELECT_DESC"] = "Выберите, какие камни возвращения использовать (будьте внимательны, если выбираете несколько камней)"
L["HIDE_HEARTHSTONE_BUTTON"] = "Скрывать кнопку камня возвращения"
L["HIDE_PORT_BUTTON"] = "Скрывать кнопку телепорта"
L["HIDE_HOME_BUTTON"] = "Скрывать кнопку дома"
L["HIDE_HEARTHSTONE_TEXT"] = "Скрывать текст камня возвращения"
L["HIDE_PORT_TEXT"] = "Скрывать текст телепорта"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Скрывать дополнительный текст подсказки"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Скрывать место привязки камня возвращения и кнопку выбора порта в подсказке."
L["NOT_LEARNED"] = "Не изучено"
L["SHOW_UNLEARNED_TELEPORTS"] = "Показывать неизученные телепорты"
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Скрывать кнопку в межсезонье"

-- House/Home Selection
L["HOME"] = "Дом"
L["UNKNOWN_HOUSE"] = "Неизвестный дом"
L["HOUSE"] = "Дом"
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Выбрано"
L["CHANGE_HOME"] = "Сменить дом"
L["NO_HOUSES_OWNED"] = "Нет домов в собственности"
L["VISIT_SELECTED_HOME"] = "Посетить выбранный дом"

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
L["CURRENT_SEASON"] = "Текущий сезон"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Обмен профилями"

L["INVALID_IMPORT_STRING"] = "Неверная строка импорта"
L["FAILED_DECODE_IMPORT_STRING"] = "Не удалось декодировать строку импорта"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Не удалось распаковать строку импорта"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Не удалось десериализовать строку импорта"
L["INVALID_PROFILE_FORMAT"] = "Неверный формат профиля"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Профиль успешно импортирован как"

L["COPY_EXPORT_STRING"] = "Скопируйте строку экспорта ниже:"
L["PASTE_IMPORT_STRING"] = "Вставьте строку импорта ниже:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Импортируйте или экспортируйте свои профили, чтобы поделиться ими с другими игроками."
L["PROFILE_IMPORT_EXPORT"] = "Импорт/Экспорт профиля"
L["EXPORT_PROFILE"] = "Экспорт профиля"
L["EXPORT_PROFILE_DESC"] = "Экспортировать настройки вашего текущего профиля"
L["IMPORT_PROFILE"] = "Импорт профиля"
L["IMPORT_PROFILE_DESC"] = "Импортировать профиль другого игрока"

-- Changelog
L["DATE_FORMAT"] = "%day%.%month%.%year%"
L["IMPORTANT"] = "Важное"
L["NEW"] = "Новое"
L["IMPROVEMENT"] = "Улучшение"
L["BUGFIX"] = "Исправление"
L["CHANGELOG"] = "Список изменений"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "Великое хранилище сейчас заблокировано до начала следующего сезона."
L["MAX_LEVEL_DISCLAIMER"] = "Этот модуль будет отображаться только после достижения максимального уровня."
