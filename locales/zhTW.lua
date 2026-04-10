local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhTW", false, false)
if not L then return end

-- Reference:
-- Some strings below are sourced from BlizzardInterfaceResources.
-- Source: https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/zhTW.lua
-- @Translation Team: If you find a false positive (a string that should stay identical),
-- add `-- @no-translate` at the end of the line so the locale sync script ignores it.

L["MODULES"] = "功能模組"
L["LEFT_CLICK"] = "左鍵"
L["RIGHT_CLICK"] = "右鍵"
L["k"] = "千" -- short for 1000
L["M"] = "百萬" -- short for 1000000
L["B"] = "十億" -- short for 1000000000
L["L"] = "本地" -- For the local ping
L["W"] = "世界" -- For the world ping

-- General
L["POSITIONING"] = "位置"
L["BAR_POSITION"] = "資訊列位置"
L["TOP"] = "上"
L["BOTTOM"] = "下"
L["BAR_COLOR"] = "資訊列顏色"
L["USE_CLASS_COLOR"] = "使用職業顏色"
L["MISCELLANEOUS"] = "其他"
L["HIDE_IN_COMBAT"] = "戰鬥中隱藏"
L["HIDE_IN_FLIGHT"] = "使用鳥點飛行時隱藏"
-- TODO: L["SHOW_ON_MOUSEOVER"] = "Show on mouseover"
-- TODO: L["SHOW_ON_MOUSEOVER_DESC"] = "Show the bar only when you mouseover it"
L["BAR_PADDING"] = "資訊列內距"
L["MODULE_SPACING"] = "模組間距"
L["BAR_MARGIN"] = "資訊列間距"
L["BAR_MARGIN_DESC"] = "資訊列模組最左邊和最右邊的間距"
L["HIDE_ORDER_HALL_BAR"] = "隱藏職業大廳列"
L["USE_ELVUI_FOR_TOOLTIPS"] = "使用ElvUI浮動提示"
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

L["MICROMENU"] = "微型選單"
L["SHOW_SOCIAL_TOOLTIPS"] = "顯示公會/好友名單"
-- TODO: L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Show Accessibility Tooltips"
-- TODO: L["BLIZZARD_MICROMENU"] = "Blizzard Micromenu"
-- TODO: L["DISABLE_BLIZZARD_MICROMENU"] = "Disable Blizzard Micromenu"
-- TODO: L["KEEP_QUEUE_STATUS_ICON"] = "Keep Queue Status Icon"
-- TODO: L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
-- TODO: L["BLIZZARD_BAGS_BAR"] = "Blizzard Bags Bar"
-- TODO: L["DISABLE_BLIZZARD_BAGS_BAR"] = "Disable Blizzard Bags Bar"
-- TODO: L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
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
-- TODO: L["SHOW_PROFESSIONS_BUTTON"] = "Show Professions Button"
L["SHOW_TALENTS_BUTTON"] = "顯示天賦按鈕"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "顯示成就按鈕"
L["SHOW_QUESTS_BUTTON"] = "顯示任務按鈕"
L["SHOW_LFG_BUTTON"] = "顯示隊伍搜尋器按鈕"
L["SHOW_JOURNAL_BUTTON"] = "顯示冒險指南按鈕"
L["SHOW_PVP_BUTTON"] = "顯示 PVP 按鈕"
L["SHOW_PETS_BUTTON"] = "顯示收藏按鈕"
L["SHOW_SHOP_BUTTON"] = "顯示遊戲商城按鈕"
L["SHOW_HELP_BUTTON"] = "顯示客服支援按鈕"
-- TODO: L["SHOW_HOUSING_BUTTON"] = "Show Housing Button"
L["NO_INFO"] = "沒有資訊"
-- TODO: L["Alliance"] = FACTION_ALLIANCE
-- TODO: L["Horde"] = FACTION_HORDE
-- TODO: L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Hide Tooltips in Combat"

L["DURABILITY_WARNING_THRESHOLD"] = "裝備耐久度警告門檻"
L["SHOW_ITEM_LEVEL"] = "顯示物品等級"
L["SHOW_COORDINATES"] = "顯示座標"

-- Master Volume
L["MASTER_VOLUME"] = "主音量"
L["VOLUME_STEP"] = "每點一下調整的值"
-- TODO: L["ENABLE_MOUSE_WHEEL"] = "Enable Mouse Wheel"

-- Clock
L["TIME_FORMAT"] = "時間格式"
L["USE_SERVER_TIME"] = "使用伺服器時間"
L["NEW_EVENT"] = "新活動!"
L["LOCAL_TIME"] = "本地時間"
L["REALM_TIME"] = "伺服器時間"
L["OPEN_CALENDAR"] = "開啟行事曆"
L["OPEN_CLOCK"] = "開啟時鐘"
L["HIDE_EVENT_TEXT"] = "隱藏活動文字"
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

L["TRAVEL"] = "旅行傳送"
L["PORT_OPTIONS"] = "傳送選項"
L["READY"] = "完成"
L["TRAVEL_COOLDOWNS"] = "旅行傳送冷卻"
L["CHANGE_PORT_OPTION"] = "變更傳送選項"

-- Gold
L["REGISTERED_CHARACTERS"] = "記錄的角色"
-- TODO: L["SHOW_FREE_BAG_SPACE"] = "Show Free Bag Space"
-- TODO: L["SHOW_OTHER_REALMS"] = "Show Other Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "總是顯示銀和銅"
L["SHORTEN_GOLD"] = "金額縮寫"
L["TOGGLE_BAGS"] = "打開/關閉背包"
L["SESSION_TOTAL"] = "本次登入總計"
L["DAILY_TOTAL"] = "本日總計"
-- TODO: L["SHOW_TOKEN_PRICE"] = "Show " .. TOKEN_FILTER_LABEL .. " Price"
-- TODO: L["SHOW_WARBAND_BANK_GOLD"] = "Show " .. ACCOUNT_BANK_PANEL_TITLE .. " Gold"
L["GOLD_ROUNDED_VALUES"] = "只顯示金的部分"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD"] = "Hide Characters Under Threshold"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Threshold"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "未滿等時顯示經驗條"
L["CLASS_COLORS_XP_BAR"] = "使用職業顏色"
L["SHOW_TOOLTIPS"] = "顯示滑鼠提示"
L["TEXT_ON_RIGHT"] = "文字在右側"
-- TODO: L["BAR_CURRENCY_SELECT"] = "Currencies displayed on the bar"
L["FIRST_CURRENCY"] = "第一種兌換通貨"
L["SECOND_CURRENCY"] = "第二種兌換通貨"
L["THIRD_CURRENCY"] = "第三種兌換通貨"
L["RESTED"] = "休息加成"
-- TODO: L["SHOW_MORE_CURRENCIES"] = "Show More Currencies on Shift+Hover"
-- TODO: L["MAX_CURRENCIES_SHOWN"] = "Max currencies shown when holding Shift"
-- TODO: L["ONLY_SHOW_MODULE_ICON"] = "Only Show Module Icon"
-- TODO: L["CURRENCY_NUMBER"] = "Number of Currencies on Bar"
-- TODO: L["CURRENCY_SELECTION"] = "Currency Selection"
-- TODO: L["SELECT_ALL"] = "Select All"
-- TODO: L["UNSELECT_ALL"] = "Unselect All"
-- TODO: L["OPEN_XIV_CURRENCY_OPTIONS"] = "Open XIV's Currency Options"

-- System
L["WORLD_PING"] = "顯示世界延遲"
L["ADDONS_NUMBER_TO_SHOW"] = "顯示的插件數目"
L["ADDONS_IN_TOOLTIP"] = "顯示插件數目"
L["SHOW_ALL_ADDONS"] = "按住 Shift 顯示全部"
L["MEMORY_USAGE"] = "記憶體使用量"
L["GARBAGE_COLLECT"] = "清理記憶體"
L["CLEANED"] = "已清理"

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
L["USE_CLASS_COLORS"] = "使用職業顏色"
-- TODO: L["USE_INTERACTIVE_TOOLTIP"] = "Use Interactive Tooltip"
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
-- TODO: L["KILLS_TO_LEVEL"] = "Kills to level"
-- TODO: L["LAST_XP_GAIN"] = "Last xp gain"
L["AVAILABLE_RANKS"] = "神兵武器等級"
L["ARTIFACT_KNOWLEDGE"] = "神兵知識等級"

-- TODO: L["SHOW_BUTTON_TEXT"] = "Show Button Text"

-- Travel
L["HEARTHSTONE"] = "爐石戰記"
-- TODO: L["M_PLUS_TELEPORTS"] = "M+ Teleports"
-- TODO: L["ONLY_SHOW_CURRENT_SEASON"] = "Only show current season"
-- TODO: L["MYTHIC_PLUS_TELEPORTS"] = "Mythic+ Teleports"
-- TODO: L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Hide M+ Teleports text"
-- TODO: L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Show Mythic+ Teleports"
L["USE_RANDOM_HEARTHSTONE"] = "使用隨機爐石"
local retrievingData = "Retrieving data..."
-- TODO: L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "如果你在下方的清單中看到 '" .. retrievingData .. "'，只需切換分頁或重新開啟此選單即可重新整理資料。"
L["HEARTHSTONES_SELECT"] = "選擇爐石"
L["HEARTHSTONES_SELECT_DESC"] = "選擇要使用哪個爐石 (如果選擇了多個爐石，請勾選 \"使用隨機爐石\" 選項)"
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

L["CLASSIC"] = "《經典版》"
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
L["DATE_FORMAT"] = "%year%年%month%月%day%日"
L["IMPORTANT"] = "重要"
L["NEW"] = "新增"
L["IMPROVEMENT"] = "改善"
-- TODO: L["BUGFIX"] = "Bugfix"
L["CHANGELOG"] = "更新記錄"

-- Vault Module
-- TODO: L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
-- TODO: L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
