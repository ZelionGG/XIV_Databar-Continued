local AddOnName, Engine = ...;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddOnName, "ruRU", false, false);
if not L then return end

L['Modules'] = "Модули";
L['Left-Click'] = "Левая кнопка мыши";
L['Right-Click'] = "Правая кнопка мыши";
L['k'] = "Тыс.";
L['M'] = "Млн.";
L['B'] = "Млрд.";
L['L'] = "Л";
L['W'] = "Г";

-- General
L["Positioning"] = "Позиция";
L['Bar Position'] = "Положение полосы";
L['Top'] = "Вверху";
L['Bottom'] = "Внизу";
L['Bar Color'] = "Цвет полосы";
L['Use Class Color for Bar'] = "Использовать цвет класса для полосы";
L["Miscellaneous"] = "Разное";
L['Hide Bar in combat'] = "Прятать полосу во время боя";
L['Bar Padding'] = "Заполнение";
L['Module Spacing'] = "Расстояние между модулями";
L['Bar Margin'] = "Маржа бара"; -- Need Translation ?
L["Leftmost and rightmost margin of the bar modules"] = true; -- Need translation
L['Hide order hall bar'] = "Прятать полосу оплота класса";
L['Use ElvUI for tooltips'] = "Используйте ElvUI для подсказок";

-- Positioning Options
L['Positioning Options'] = "Настройки позиционированя";
L['Horizontal Position'] = "Позиция по горизонтали";
L['Bar Width'] = "Ширина полосы";
L['Left'] = "Слева";
L['Center'] = "По центру";
L['Right'] = "Справа";

-- Media
L['Font'] = "Шрифт";
L['Small Font Size'] = "Размер маленького шрифта";
L['Text Style'] = "Стиль текста";

-- Text Colors
L["Colors"] = "Цвета";
L['Text Colors'] = "Цвета текста";
L['Normal'] = "Обычный";
L['Inactive'] = "Неактивно";
L["Use Class Color for Text"] = "Использовать цвет класса для текста";
L["Only the alpha can be set with the color picker"] = "В выборе цвета можно указать только прозрачность";
L['Use Class Colors for Hover'] = "Использовать цвет класса при наведении";
L['Hover'] = "По наведению";

-------------------- MODULES ---------------------------

L['Micromenu'] = "Микроменю";
L['Show Social Tooltips'] = "Показывать подсказки гильдии и друзей";
L['Main Menu Icon Right Spacing'] = "Расстояние от кнопки меню до других кнопок";
L['Icon Spacing'] = "Расстояние между кнопками";
L["Hide BNet App Friends"] = true;
L['Open Guild Page'] = "Открыть страницу гильдии";
L['No Tag'] = "Нет Battletag";
L['Whisper BNet'] = "Шепнуть по Battle.Net";
L['Whisper Character'] = "Шепнуть персонажу";
L['Hide Social Text'] = "Скрыть количество онлайна гильдии и друзей";
L['Social Text Offset'] = "Смещение текста в социальных сетях";
L["GMOTD in Tooltip"] = "Сообщение дня гильдии в подсказке";
L["Modifier for friend invite"] = "Модификатор для приглашения друзей";
L['Show/Hide Buttons'] = "Показать/скрыть кнопки";
L['Show Menu Button'] = "Меню";
L['Show Chat Button'] = "Выбор чата";
L['Show Guild Button'] = "Гильдия";
L['Show Social Button'] = "Общение";
L['Show Character Button'] = "Информация о персонаже";
L['Show Spellbook Button'] = "Способности";
L['Show Talents Button'] = "Специализация и таланты";
L['Show Achievements Button'] = "Достижения";
L['Show Quests Button'] = "Журнал заданий";
L['Show LFG Button'] = "Поиск группы";
L['Show Journal Button'] = "Путеводитель по приключениям";
L['Show PVP Button'] = "Игрок против игрока";
L['Show Pets Button'] = "Коллекции";
L['Show Shop Button'] = "Магазин";
L['Show Help Button'] = "Помощь";
L['No Info'] = "Нет информации";
L['Classic'] = true;
L['Alliance'] = "Альянс";
L['Horde'] = "Орда";

L['Durability Warning Threshold'] = "Порог предупреждения о долговечности";
L['Show Item Level'] = "Показать уровень элемента";
L['Show Coordinates'] = "Показать координаты";

L['Master Volume'] = "Громкость игры";
L["Volume step"] = "Шаг изменения громкости";

L['Time Format'] = "Формат времени";
L['Use Server Time'] = "Использовать серверное время";
L['New Event!'] = "Новое событие!";
L['Local Time'] = "Местное время";
L['Realm Time'] = "Серверное время";
L['Open Calendar'] = "Открыть календарь";
L['Open Clock'] = "Открыть часы";
L['Hide Event Text'] = "Скрыть текст событий";

L['Travel'] = "Перемещение";
L['Port Options'] = "Назначение телепорта";
L['Ready'] = "Готово";
L['Travel Cooldowns'] = "Способности для перемещения";
L['Change Port Option'] = "Изменить назначение телепорта";

L["Registered characters"] = true;
L['Show Free Bag Space'] = true;
L['Show Other Realms'] = true;
L['Always Show Silver and Copper'] = "Всегда показывать серебро и медь";
L['Shorten Gold'] = "Сокращать число золота";
L['Toggle Bags'] = "Переключить видимость сумок";
L['Session Total'] = "Всего за сессию";
L['Daily Total'] = true;
L['Gold rounded values'] = true;

L['Show XP Bar Below Max Level'] = "Показывать полоску опыта персонажам, не достигшим максимального уровня";
L['Use Class Colors for XP Bar'] = "Использовать цвет класса для полоски опыта";
L['Show Tooltips'] = "Показывать подсказки";
L['Text on Right'] = "Текст справа";
L['Currency Select'] = "Выбор валют";
L['First Currency'] = "Валюта №1";
L['Second Currency'] = "Валюта №2";
L['Third Currency'] = "Валюта №3";
L['Rested'] = "Отдых";

L['Show World Ping'] = "Показывать задержку сервера";
L['Number of Addons To Show'] = "Сколько аддонов показывать";
L['Addons to Show in Tooltip'] = "Сколько аддонов показывать";
L['Show All Addons in Tooltip with Shift'] = "Показывать все аддоны по нажатию кнопки Shift";
L['Memory Usage'] = "Использование памяти";
L['Garbage Collect'] = "Очистить память";
L['Cleaned'] = "Очищено";

L['Use Class Colors'] = "Использовать цвет класса";
L['Cooldowns'] = "Кулдауны";
L['Toggle Profession Frame'] = 'Показать кадр профессии';
L['Toggle Profession Spellbook'] = 'показать книгу заклинаний профессии';

L['Set Specialization'] = "Выбрать специализацию";
L['Set Loadout'] = true; -- Translation needed
L['Set Loot Specialization'] = "Выбрать специализацию для добычи";
L['Current Specialization'] = "Текущая специализация";
L['Current Loot Specialization'] = "Текущая специализация для добычи";
L['Talent Minimum Width'] = "Минимальная ширина модуля талантов";
L['Open Artifact'] = "Открыть меню артефакта";
L['Remaining'] = "Осталось";
L['Available Ranks'] = "Доступно уровней";
L['Artifact Knowledge'] = "Знание артефакта";

-- Travel (Translation needed)
L['M+ Teleports'] = true;
L['Only show current season'] = true;
L["Mythic+ Teleports"] = true;
L['Show Mythic+ Teleports'] = true;
L['Use Random Hearthstone'] = true;
L['Empty Hearthstones List'] = "If you see an empty list, /reload your UI a few seconds after the initial loading (Blizzard is loading items informations asynchronously so that's the only solution for now)."
L['Hearthstones Select'] = true;
L['Hearthstones Select Desc'] = "Select which hearthstones to use (be careful if you select multiple hearthstones, you might want to check the 'Hearthstones Select' option)";

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
L["Current season"] = true;

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
L["%month%-%day%-%year%"] = "%day%-%month%-%year%";
L["Version"] = "Версия";
L["Important"] = "Важные";
L["New"] = "Новые";
L["Improvment"] = "Улучшения";
L["Changelog"] = "Журнал изменений";