local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhCN", false, false)
if not L then return end

-- Reference:
-- Some strings below are sourced from BlizzardInterfaceResources.
-- Source: https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/zhCN.lua
-- @Translation Team: If you find a false positive (a string that should stay identical),
-- add `-- @no-translate` at the end of the line so the locale sync script ignores it.

L["MODULES"] = "模块"
L["LEFT_CLICK"] = "左键单击"
L["RIGHT_CLICK"] = "右键单击"
-- TODO: L["k"] = true -- short for 1000
-- TODO: L["M"] = true -- short for 1000000
-- TODO: L["B"] = true -- short for 1000000000
L["L"] = "本地" -- For the local ping
L["W"] = "世界" -- For the world ping

-- General
L["POSITIONING"] = "位置"
L["BAR_POSITION"] = "条位置"
L["TOP"] = "顶部"
L["BOTTOM"] = "底部"
L["BAR_COLOR"] = "条颜色"
L["USE_CLASS_COLOR"] = "条使用职业颜色"
L["MISCELLANEOUS"] = "杂项"
L["HIDE_IN_COMBAT"] = "战斗中隐藏"
-- TODO: L["HIDE_IN_FLIGHT"] = "Hide when in flight"
-- TODO: L["SHOW_ON_MOUSEOVER"] = "Show on mouseover"
-- TODO: L["SHOW_ON_MOUSEOVER_DESC"] = "Show the bar only when you mouseover it"
L["BAR_PADDING"] = "条填充"
L["MODULE_SPACING"] = "模块间距"
L["BAR_MARGIN"] = "条形边距"
-- TODO: L["BAR_MARGIN_DESC"] = "Leftmost and rightmost margin of the bar modules"
L["HIDE_ORDER_HALL_BAR"] = "隐藏职业大厅条"
L["USE_ELVUI_FOR_TOOLTIPS"] = "使用ElvUI作為工具提示"
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
L["BAR_WIDTH"] = "条宽度"
L["LEFT"] = "左"
L["CENTER"] = "中"
L["RIGHT"] = "右"

-- Media
L["FONT"] = "字体"
L["SMALL_FONT_SIZE"] = "小字体大小"
L["TEXT_STYLE"] = "文字风格"

-- Text Colors
L["COLORS"] = "颜色"
L["TEXT_COLORS"] = "文字颜色"
L["NORMAL"] = "正常"
L["INACTIVE"] = "非活动状态"
L["USE_CLASS_COLOR_TEXT"] = "文字使用职业颜色"
L["USE_CLASS_COLOR_TEXT_DESC"] = "只能用拾色器设置透明度"
L["USE_CLASS_COLORS_FOR_HOVER"] = "鼠标悬停使用职业颜色"
L["HOVER"] = "鼠标悬停"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "微型菜单"
L["SHOW_SOCIAL_TOOLTIPS"] = "显示社交提示"
-- TODO: L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Show Accessibility Tooltips"
-- TODO: L["BLIZZARD_MICROMENU"] = "Blizzard Micromenu"
-- TODO: L["DISABLE_BLIZZARD_MICROMENU"] = "Disable Blizzard Micromenu"
-- TODO: L["KEEP_QUEUE_STATUS_ICON"] = "Keep Queue Status Icon"
-- TODO: L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
-- TODO: L["BLIZZARD_BAGS_BAR"] = "Blizzard Bags Bar"
-- TODO: L["DISABLE_BLIZZARD_BAGS_BAR"] = "Disable Blizzard Bags Bar"
-- TODO: L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "主菜单图标右间距"
L["ICON_SPACING"] = "图标间距"
-- TODO: L["HIDE_BNET_APP_FRIENDS"] = "Hide BNet App Friends"
L["OPEN_GUILD_PAGE"] = "打开工会页面"
L["NO_TAG"] = "无标签"
L["WHISPER_BNET"] = "密语战网"
L["WHISPER_CHARACTER"] = "密语角色"
L["HIDE_SOCIAL_TEXT"] = "隐藏社交文字"
L["SOCIAL_TEXT_OFFSET"] = "社會文字偏移"
L["GMOTD_IN_TOOLTIP"] = "提示每日公会信息"
L["FRIEND_INVITE_MODIFIER"] = "好友邀请"
L["SHOW_HIDE_BUTTONS"] = "显示/隐藏按钮"
L["SHOW_MENU_BUTTON"] = "显示菜单按钮"
L["SHOW_CHAT_BUTTON"] = "显示聊天按钮"
L["SHOW_GUILD_BUTTON"] = "显示公会按钮"
L["SHOW_SOCIAL_BUTTON"] = "显示好友列表按钮"
L["SHOW_CHARACTER_BUTTON"] = "显示角色信息按钮"
L["SHOW_SPELLBOOK_BUTTON"] = "显示法术书和技能按钮"
-- TODO: L["SHOW_PROFESSIONS_BUTTON"] = "Show Professions Button"
L["SHOW_TALENTS_BUTTON"] = "显示专精和天赋按钮"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "显示成就按钮"
L["SHOW_QUESTS_BUTTON"] = "显示任务日志按钮"
L["SHOW_LFG_BUTTON"] = "显示地下城和团队副本按钮"
L["SHOW_JOURNAL_BUTTON"] = "显示冒险指南按钮"
L["SHOW_PVP_BUTTON"] = "显示PVP按钮"
L["SHOW_PETS_BUTTON"] = "显示藏品按钮"
L["SHOW_SHOP_BUTTON"] = "显示商城按钮"
L["SHOW_HELP_BUTTON"] = "显示帮助按钮"
-- TODO: L["SHOW_HOUSING_BUTTON"] = "Show Housing Button"
L["NO_INFO"] = "暂无信息"
-- TODO: L["Alliance"] = FACTION_ALLIANCE
-- TODO: L["Horde"] = FACTION_HORDE
-- TODO: L["DISABLE_TOOLTIPS_IN_COMBAT"] = "Hide Tooltips in Combat"

L["DURABILITY_WARNING_THRESHOLD"] = "耐久性警告閾值"
L["SHOW_ITEM_LEVEL"] = "顯示物品等級"
L["SHOW_COORDINATES"] = "顯示坐標"

-- Master Volume
L["MASTER_VOLUME"] = "主音量"
L["VOLUME_STEP"] = "音量调节"
-- TODO: L["ENABLE_MOUSE_WHEEL"] = "Enable Mouse Wheel"

-- Clock
L["TIME_FORMAT"] = "时间格式"
L["USE_SERVER_TIME"] = "使用服务器时间"
L["NEW_EVENT"] = "新事件!"
L["LOCAL_TIME"] = "本地时间"
L["REALM_TIME"] = "服务器时间"
L["OPEN_CALENDAR"] = "打开日历"
L["OPEN_CLOCK"] = "打开时钟"
L["HIDE_EVENT_TEXT"] = "隐藏事件文字"
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

L["TRAVEL"] = "传送"
L["PORT_OPTIONS"] = "传送选项"
L["READY"] = "就绪"
L["TRAVEL_COOLDOWNS"] = "传送冷却"
L["CHANGE_PORT_OPTION"] = "更改传送选项"

-- Gold
-- TODO: L["REGISTERED_CHARACTERS"] = "Registered characters"
-- TODO: L["SHOW_FREE_BAG_SPACE"] = "Show Free Bag Space"
-- TODO: L["SHOW_OTHER_REALMS"] = "Show Other Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "始终显示银币和铜币"
L["SHORTEN_GOLD"] = "金钱缩写"
L["TOGGLE_BAGS"] = "切换背包"
L["SESSION_TOTAL"] = "汇总"
-- TODO: L["DAILY_TOTAL"] = "Daily Total"
-- TODO: L["SHOW_TOKEN_PRICE"] = "Show " .. TOKEN_FILTER_LABEL .. " Price"
-- TODO: L["SHOW_WARBAND_BANK_GOLD"] = "Show " .. ACCOUNT_BANK_PANEL_TITLE .. " Gold"
-- TODO: L["GOLD_ROUNDED_VALUES"] = "Gold rounded values"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD"] = "Hide Characters Under Threshold"
-- TODO: L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Threshold"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "未满级时显示经验条"
L["CLASS_COLORS_XP_BAR"] = "经验条使用职业颜色"
L["SHOW_TOOLTIPS"] = "显示提示"
L["TEXT_ON_RIGHT"] = "文字在右侧"
-- TODO: L["BAR_CURRENCY_SELECT"] = "Currencies displayed on the bar"
L["FIRST_CURRENCY"] = "第一种货币"
L["SECOND_CURRENCY"] = "第二种货币"
L["THIRD_CURRENCY"] = "第三种货币"
L["RESTED"] = "精力充沛"
-- TODO: L["SHOW_MORE_CURRENCIES"] = "Show More Currencies on Shift+Hover"
-- TODO: L["MAX_CURRENCIES_SHOWN"] = "Max currencies shown when holding Shift"
-- TODO: L["ONLY_SHOW_MODULE_ICON"] = "Only Show Module Icon"
-- TODO: L["CURRENCY_NUMBER"] = "Number of Currencies on Bar"
-- TODO: L["CURRENCY_SELECTION"] = "Currency Selection"
-- TODO: L["SELECT_ALL"] = "Select All"
-- TODO: L["UNSELECT_ALL"] = "Unselect All"
-- TODO: L["OPEN_XIV_CURRENCY_OPTIONS"] = "Open XIV's Currency Options"

-- System
L["WORLD_PING"] = "显示世界延迟"
L["ADDONS_NUMBER_TO_SHOW"] = "显示插件的数量"
L["ADDONS_IN_TOOLTIP"] = "在提示中显示的插件"
L["SHOW_ALL_ADDONS"] = "按住SHIFT键在提示中显示所有插件"
L["MEMORY_USAGE"] = "内存占用"
L["GARBAGE_COLLECT"] = "垃圾收集"
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
L["USE_CLASS_COLORS"] = "使用职业颜色"
-- TODO: L["USE_INTERACTIVE_TOOLTIP"] = "Use Interactive Tooltip"
L["COOLDOWNS"] = "冷却"
L["TOGGLE_PROFESSION_FRAME"] = '顯示職業框架'
L["TOGGLE_PROFESSION_SPELLBOOK"] = '表演專業拼寫本'

L["SET_SPECIALIZATION"] = "设置专精"
-- TODO: L["SET_LOADOUT"] = "Set Loadout"
L["SET_LOOT_SPECIALIZATION"] = "设置拾取专精"
L["CURRENT_SPECIALIZATION"] = "当前专精"
L["CURRENT_LOOT_SPECIALIZATION"] = "当前拾取专精"
-- TODO: L["ENABLE_LOADOUT_SWITCHER"] = "Enable Loadout Switcher"
L["TALENT_MINIMUM_WIDTH"] = "天赋最小宽度"
L["OPEN_ARTIFACT"] = "打开神器"
L["REMAINING"] = "剩余"
-- TODO: L["KILLS_TO_LEVEL"] = "Kills to level"
-- TODO: L["LAST_XP_GAIN"] = "Last xp gain"
L["AVAILABLE_RANKS"] = "神器等级"
L["ARTIFACT_KNOWLEDGE"] = "神器知识"

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
L["EMPTY_HEARTHSTONES_LIST"] = "如果你在下面的列表中看到 '" .. retrievingData .. "'，只需切换标签页或重新打开此菜单即可刷新数据。"
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
-- TODO: L["CURRENT_SEASON"] = "Current season"

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
L["CHANGELOG"] = "更新记录"

-- Vault Module
-- TODO: L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
-- TODO: L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
