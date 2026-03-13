local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhTW", false, false)
if not L then return end

L["MODULES"] = "功能模組"
L["LEFT_CLICK"] = "左鍵"
L["RIGHT_CLICK"] = "右鍵"
L["k"] = "千" -- short for 1000
L["M"] = "百萬" -- short for 1000000
L["B"] = "十億" -- short for 1000000000
L["L"] = "本地" -- For the local ping
L["W"] = "世界" -- For the world ping
L["w"] = "萬"	-- short for 10000, used in zhCN and zhTW
L["e"] = "億" -- short for 100000000
L["c"] = "兆" -- short for 1000000000000

-- General
L["POSITIONING"] = "位置"
L["BAR_POSITION"] = "資訊列位置"
L["TOP"] = "上"
L["BOTTOM"] = "下"
L["BAR_COLOR"] = "資訊列顏色"
L["USE_CLASS_COLOR"] = "使用職業顏色"
L["MISCELLANEOUS"] = "其他"
L["HIDE_IN_COMBAT"] = "戰鬥中隱藏"
L["HIDE_IN_FLIGHT"] = true
L["BAR_PADDING"] = "資訊列內距"
L["MODULE_SPACING"] = "模組間距"
L["BAR_MARGIN"] = "資訊列間距"
L["BAR_MARGIN_DESC"] = "資訊列模組最左邊和最右邊的間距"
L["HIDE_ORDER_HALL_BAR"] = "隱藏職業大廳列"
L["USE_ELVUI_FOR_TOOLTIPS"] = "使用ElvUI浮動提示"
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
L["BAR_WIDTH"] = "資訊列寬度"
L["LEFT"] = "左"
L["CENTER"] = "中"
L["RIGHT"] = "右"

-- Media
L["FONT"] = "字體"
L["SMALL_FONT_SIZE"] = "小字體大小"
L["TEXT_STYLE"] = "文字樣式"

-- Text Colors
L["COLORS"] = "顏色"
L["TEXT_COLORS"] = "文字顏色"
L["NORMAL"] = "平時"
L["INACTIVE"] = "未使用時"
L["USE_CLASS_COLOR_TEXT"] = "使用職業顏色"
L["USE_CLASS_COLOR_TEXT_DESC"] = "顏色選擇器中只能設定透明度"
L["USE_CLASS_COLORS_FOR_HOVER"] = "使用職業顏色"
L["HOVER"] = "滑鼠指向時"

-------------------- MODULES ---------------------------

L["Social"] = "好友"
L["MICROMENU"] = "微型選單"
L["SHOW_SOCIAL_TOOLTIPS"] = "顯示公會/好友名單"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = true -- Needs Translation
L["BLIZZARD_MICROMENU"] = true
L["DISABLE_BLIZZARD_MICROMENU"] = true
L["KEEP_QUEUE_STATUS_ICON"] = true
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["BLIZZARD_BAGS_BAR"] = true
L["DISABLE_BLIZZARD_BAGS_BAR"] = true
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "主選單圖示右方間距"
L["ICON_SPACING"] = "圖示間距"
L["HIDE_BNET_APP_FRIENDS"] = "隱藏戰網 app 好友"
L["OPEN_GUILD_PAGE"] = "開啟公會視窗"
L["NO_TAG"] = "沒有 Tag"
L["WHISPER_BNET"] = "密語 Battle Tag"
L["WHISPER_CHARACTER"] = "密語伺服器角色"
L["HIDE_SOCIAL_TEXT"] = "隱藏人數"
L["SOCIAL_TEXT_OFFSET"] = "人數文字位置偏移"
L["GMOTD_IN_TOOLTIP"] = "顯示公會今日資訊"
L["FRIEND_INVITE_MODIFIER"] = "組隊邀請的組合鍵"
L["SHOW_HIDE_BUTTONS"] = "顯示/隱藏按鈕"
L["SHOW_MENU_BUTTON"] = "顯示選單按鈕"
L["SHOW_CHAT_BUTTON"] = "顯示聊天按鈕"
L["SHOW_GUILD_BUTTON"] = "顯示公會按鈕"
L["SHOW_SOCIAL_BUTTON"] = "顯示好友按鈕"
L["SHOW_CHARACTER_BUTTON"] = "顯示角色按鈕"
L["SHOW_SPELLBOOK_BUTTON"] = "顯示法術書按鈕"
L["SHOW_TALENTS_BUTTON"] = "顯示天賦按鈕"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "顯示成就按鈕"
L["SHOW_QUESTS_BUTTON"] = "顯示任務按鈕"
L["SHOW_LFG_BUTTON"] = "顯示隊伍搜尋器按鈕"
L["SHOW_JOURNAL_BUTTON"] = "顯示冒險指南按鈕"
L["SHOW_PVP_BUTTON"] = "顯示 PVP 按鈕"
L["SHOW_PETS_BUTTON"] = "顯示收藏按鈕"
L["SHOW_SHOP_BUTTON"] = "顯示遊戲商城按鈕"
L["SHOW_HELP_BUTTON"] = "顯示客服支援按鈕"
L["SHOW_HOUSING_BUTTON"] = true -- TODO: translate
L["NO_INFO"] = "沒有資訊"
L["CLASSIC"] = "經典版"
L["ALLIANCE"] = "聯盟"
L["HORDE"] = "部落"

L["DURABILITY_WARNING_THRESHOLD"] = "裝備耐久度警告門檻"
L["SHOW_ITEM_LEVEL"] = "顯示物品等級"
L["SHOW_COORDINATES"] = "顯示座標"

L["MASTER_VOLUME"] = "主音量"
L["VOLUME_STEP"] = "每點一下調整的值"

L["TIME_FORMAT"] = "時間格式"
L["USE_SERVER_TIME"] = "使用伺服器時間"
L["NEW_EVENT"] = "新活動!"
L["LOCAL_TIME"] = "本地時間"
L["REALM_TIME"] = "伺服器時間"
L["OPEN_CALENDAR"] = "開啟行事曆"
L["OPEN_CLOCK"] = "開啟時鐘"
L["HIDE_EVENT_TEXT"] = "隱藏活動文字"

L["TRAVEL"] = "旅行傳送"
L["PORT_OPTIONS"] = "傳送選項"
L["READY"] = "完成"
L["TRAVEL_COOLDOWNS"] = "旅行傳送冷卻"
L["CHANGE_PORT_OPTION"] = "變更傳送選項"

L["REGISTERED_CHARACTERS"] = true
L["SHOW_FREE_BAG_SPACE"] = true
L["SHOW_OTHER_REALMS"] = true
L["ALWAYS_SHOW_SILVER_COPPER"] = "總是顯示銀和銅"
L["SHORTEN_GOLD"] = "金額縮寫"
L["TOGGLE_BAGS"] = "打開/關閉背包"
L["SESSION_TOTAL"] = "本次登入總計"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "未滿等時顯示經驗條"
L["CLASS_COLORS_XP_BAR"] = "使用職業顏色"
L["SHOW_TOOLTIPS"] = "顯示滑鼠提示"
L["TEXT_ON_RIGHT"] = "文字在右側"
L["CURRENCY_SELECT"] = "要顯示的兌換通貨"
L["FIRST_CURRENCY"] = "第一種兌換通貨"
L["SECOND_CURRENCY"] = "第二種兌換通貨"
L["THIRD_CURRENCY"] = "第三種兌換通貨"
L["RESTED"] = "休息加成"
L["SHOW_MORE_CURRENCIES"] = true -- To Translate
L["MAX_CURRENCIES_SHOWN"] = true -- To Translate
L["ONLY_SHOW_MODULE_ICON"] = true -- To Translate
L["CURRENCY_NUMBER"] = true -- To Translate
L["CURRENCY_SELECTION"] = true -- To Translate
L["SELECT_ALL"] = true -- To Translate
L["UNSELECT_ALL"] = true -- To Translate
L["OPEN_XIV_CURRENCY_OPTIONS"] = true -- To Translate

-- System
L["WORLD_PING"] = "顯示世界延遲"
L["ADDONS_NUMBER_TO_SHOW"] = "顯示的插件數目"
L["ADDONS_IN_TOOLTIP"] = "顯示插件數目"
L["SHOW_ALL_ADDONS"] = "按住 Shift 顯示全部"
L["MEMORY_USAGE"] = "記憶體使用量"
L["GARBAGE_COLLECT"] = "清理記憶體"
L["CLEANED"] = "已清理"

-- Reputation
L["OPEN_REPUTATION"] = "Open " .. REPUTATION -- To Translate
L["PARAGON_REWARD_AVAILABLE"] = true -- To translate
L["CLASS_COLORS_REPUTATION"] = true -- To translate
L["REPUTATION_COLORS_REPUTATION"] = true -- To translate
L["FLASH_PARAGON_REWARD"] = true -- To translate
L["PROGRESS"] = true -- To translate
L["RANK"] = true -- To translate
L["PARAGON"] = true -- To translate

L["USE_CLASS_COLORS"] = "使用職業顏色"
L["COOLDOWNS"] = "冷卻時間"
L["TOGGLE_PROFESSION_FRAME"] = "打開/關閉專業視窗"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "打開/關閉專業技能書"

L["SET_SPECIALIZATION"] = "切換專精"
L["SET_LOADOUT"] = "切換天賦配置"
L["SET_LOOT_SPECIALIZATION"] = "切換優先拾取的專精"
L["CURRENT_SPECIALIZATION"] = "目前職業專精"
L["CURRENT_LOOT_SPECIALIZATION"] = "目前優先拾取的專精"
L["ENABLE_LOADOUT_SWITCHER"] = "啟用切換天賦配置"
L["TALENT_MINIMUM_WIDTH"] = "天賦最小寬度"
L["OPEN_ARTIFACT"] = "檢視神兵武器"
L["REMAINING"] = "還需要"
L["AVAILABLE_RANKS"] = "神兵武器等級"
L["ARTIFACT_KNOWLEDGE"] = "神兵知識等級"

L["SHOW_BUTTON_TEXT"] = true -- Needs Translation

-- Travel
L["HEARTHSTONE"] = true
L["M_PLUS_TELEPORTS"] = true
L["ONLY_SHOW_CURRENT_SEASON"] = true
L["MYTHIC_PLUS_TELEPORTS"] = true
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = true -- Needs Translate
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = true -- Translation needed
L["USE_RANDOM_HEARTHSTONE"] = "使用隨機爐石"
local retrievingData = "正在讀取資料..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "如果你在下方的清單中看到 '" .. retrievingData .. "'，只需切換分頁或重新開啟此選單即可重新整理資料。"
L["HEARTHSTONES_SELECT"] = "選擇爐石"
L["HEARTHSTONES_SELECT_DESC"] = "選擇要使用哪個爐石 (如果選擇了多個爐石，請勾選 \"使用隨機爐石\" 選項)"
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

-- Additional
L["XIV Bar Continued"] = "資訊列"  -- used for config menu
L["Profiles"] = "設定檔"
L["Money"] = "金錢"
L["Enable in combat"] = "戰鬥中可使用"
L["GOLD_ROUNDED_VALUES"] = "只顯示金的部分"
L["DAILY_TOTAL"] = "本日總計"
L["REGISTERED_CHARACTERS"] = "記錄的角色"
L["All the characters listed above are currently registered in the gold database. To delete one or several character, plase uncheck the box correponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), untill you reload or logout/login"] = "上方列出金錢資料庫中有記錄的所有角色。\n\n要刪除角色的記錄，請取消勾選角色前方的核取方塊。\n\n取消勾選的角色會暫時保存，直到重新載入介面或重新登入遊戲才會刪除。"
L["Overwatch"] = "鬥陣特攻"
L["Heroes of the Storm"] = "暴雪英霸"
L["HEARTHSTONE"] = "爐石戰記"
L["Starcraft 2"] = "星海爭霸II"
L["Diablo 3"] = "暗黑破壞神III"
L["Starcraft Remastered"] = "星海爭霸 高畫質重製版"
L["Destiny 2"] = "天命 2"
L["Call of Duty: BO4"] = "決勝時刻: 黑色行動4"
L["Call of Duty: MW"] = "決勝時刻: 現代戰爭"
L["Call of Duty: MW2"] = "決勝時刻: 現代戰爭2"
L["Call of Duty: BOCW"] = "決勝時刻: 黑色行動冷戰"
L["Call of Duty: Vanguard"] = "決勝時刻: 先鋒"
L["HIDE_IN_FLIGHT"] = "使用鳥點飛行時隱藏"
L["SHOW_ON_MOUSEOVER"] = true -- Needs translation
L["SHOW_ON_MOUSEOVER_DESC"] = true -- Needs translation
L["CLASSIC"] = "《經典版》"
L["Warcraft 3 Reforged"] = "魔獸爭霸III: 淬鍊重生"
L["Diablo II: Resurrected"] = "暗黑破壞神II: 獄火重生"
L["Call of Duty: Vanguard"] = "決勝時刻: 先鋒"
L["Diablo Immortal"] = "暗黑破壞神 永生不朽"
L["Warcraft Arclight Rumble"] = "魔獸兵團"
L["Call of Duty: Modern Warfare II"] = "決勝時刻: 現代戰爭II 2022"
L["Diablo 4"] = "暗黑破壞神IV"
L["Blizzard Arcade Collection"] = "暴雪遊樂場典藏系列"
L["Crash Bandicoot 4"] = "袋狼大進擊4"
L["Hide Friends Playing Other Games"] = "隱藏其他遊戲好友" -- used for the friend list function I added myself

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
L["DATE_FORMAT"] = "%year%年%month%月%day%日"
L["VERSION"] = "版本"
L["IMPORTANT"] = "重要"
L["NEW"] = "新增"
L["IMPROVEMENT"] = "改善"
L["BUGFIX"] = true -- To Translate
L["CHANGELOG"] = "更新記錄"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
