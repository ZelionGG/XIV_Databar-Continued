local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhCN", false, false)
if not L then return end

-- NOTE : Strings that requires translation are marked with -- TODO: To Translate

L["MODULES"] = "模块"
L["LEFT_CLICK"] = "左键单击"
L["RIGHT_CLICK"] = "右键单击"
L["k"] = true -- short for 1000
L["M"] = true -- short for 1000000
L["B"] = true -- short for 1000000000
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
L["HIDE_IN_FLIGHT"] = "Hide when in flight" -- TODO: To Translate
L["SHOW_ON_MOUSEOVER"] = "Show on mouseover" -- TODO: To Translate
L["SHOW_ON_MOUSEOVER_DESC"] = "Show the bar only when you mouseover it" -- TODO: To Translate
L["BAR_PADDING"] = "条填充"
L["MODULE_SPACING"] = "模块间距"
L["BAR_MARGIN"] = "条形边距"
L["BAR_MARGIN_DESC"] = "Leftmost and rightmost margin of the bar modules" -- TODO: To Translate
L["HIDE_ORDER_HALL_BAR"] = "隐藏职业大厅条"
L["USE_ELVUI_FOR_TOOLTIPS"] = "使用ElvUI作為工具提示"
L["LOCK_BAR"] = "Lock Bar" -- TODO: To Translate
L["LOCK_BAR_DESC"] = "Lock the bar to prevent dragging" -- TODO: To Translate
L["BAR_FULLSCREEN_DESC"] = "Makes the bar span the entire screen width" -- TODO: To Translate
L["BAR_POSITION_DESC"] = "Position the bar at the top or bottom of the screen" -- TODO: To Translate
L["X_OFFSET"] = "X Offset" -- TODO: To Translate
L["Y_OFFSET"] = "Y Offset" -- TODO: To Translate
L["HORIZONTAL_POSITION"] = "Horizontal position of the bar" -- TODO: To Translate
L["VERTICAL_POSITION"] = "Vertical position of the bar" -- TODO: To Translate
L["BEHAVIOR"] = "Behavior" -- TODO: To Translate
L["SPACING"] = "Spacing" -- TODO: To Translate

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
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Show Accessibility Tooltips" -- TODO: To Translate
L["BLIZZARD_MICROMENU"] = "Blizzard Micromenu" -- TODO: To Translate
L["DISABLE_BLIZZARD_MICROMENU"] = "Disable Blizzard Micromenu" -- TODO: To Translate
L["KEEP_QUEUE_STATUS_ICON"] = "Keep Queue Status Icon" -- TODO: To Translate
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- TODO: To Translate
L["BLIZZARD_BAGS_BAR"] = "Blizzard Bags Bar" -- TODO: To Translate
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Disable Blizzard Bags Bar" -- TODO: To Translate
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- TODO: To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "主菜单图标右间距"
L["ICON_SPACING"] = "图标间距"
L["HIDE_BNET_APP_FRIENDS"] = "Hide BNet App Friends" -- TODO: To Translate
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
L["SHOW_TALENTS_BUTTON"] = "显示专精和天赋按钮"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "显示成就按钮"
L["SHOW_QUESTS_BUTTON"] = "显示任务日志按钮"
L["SHOW_LFG_BUTTON"] = "显示地下城和团队副本按钮"
L["SHOW_JOURNAL_BUTTON"] = "显示冒险指南按钮"
L["SHOW_PVP_BUTTON"] = "显示PVP按钮"
L["SHOW_PETS_BUTTON"] = "显示藏品按钮"
L["SHOW_SHOP_BUTTON"] = "显示商城按钮"
L["SHOW_HELP_BUTTON"] = "显示帮助按钮"
L["SHOW_HOUSING_BUTTON"] = "Show Housing Button" -- TODO: translate
L["NO_INFO"] = "暂无信息"
L["CLASSIC"] = "经典怀旧服"
L["Alliance"] = FACTION_ALLIANCE
L["Horde"] = FACTION_HORDE

L["DURABILITY_WARNING_THRESHOLD"] = "耐久性警告閾值"
L["SHOW_ITEM_LEVEL"] = "顯示物品等級"
L["SHOW_COORDINATES"] = "顯示坐標"

-- Master Volume
L["MASTER_VOLUME"] = "主音量"
L["VOLUME_STEP"] = "音量调节"
L["ENABLE_MOUSE_WHEEL"] = "Enable Mouse Wheel" -- TODO: To Translate

-- Clock
L["TIME_FORMAT"] = "时间格式"
L["USE_SERVER_TIME"] = "使用服务器时间"
L["NEW_EVENT"] = "新事件!"
L["LOCAL_TIME"] = "本地时间"
L["REALM_TIME"] = "服务器时间"
L["OPEN_CALENDAR"] = "打开日历"
L["OPEN_CLOCK"] = "打开时钟"
L["HIDE_EVENT_TEXT"] = "隐藏事件文字"
L["REST_ICON"] = "Rest Icon" -- TODO: To Translate
L["SHOW_REST_ICON"] = "Show Rest Icon" -- TODO: To Translate
L["TEXTURE"] = "Texture" -- TODO: To Translate
L["DEFAULT"] = "Default" -- TODO: To Translate
L["CUSTOM"] = "Custom" -- TODO: To Translate
L["CUSTOM_TEXTURE"] = "Custom Texture" -- TODO: To Translate
L["HIDE_REST_ICON_MAX_LEVEL"] = "Hide at Max Level" -- TODO: To Translate
L["TEXTURE_SIZE"] = "Texture Size" -- TODO: To Translate
L["POSITION"] = "Position" -- TODO: To Translate
L["CUSTOM_TEXTURE_COLOR"] = "Custom Color" -- TODO: To Translate
L["COLOR"] = "Color" -- TODO: To Translate

L["TRAVEL"] = "传送"
L["PORT_OPTIONS"] = "传送选项"
L["READY"] = "就绪"
L["TRAVEL_COOLDOWNS"] = "传送冷却"
L["CHANGE_PORT_OPTION"] = "更改传送选项"

-- Gold
L["REGISTERED_CHARACTERS"] = "Registered characters" -- TODO: To Translate
L["SHOW_FREE_BAG_SPACE"] = "Show Free Bag Space" -- TODO: To Translate
L["SHOW_OTHER_REALMS"] = "Show Other Realms" -- TODO: To Translate
L["ALWAYS_SHOW_SILVER_COPPER"] = "始终显示银币和铜币"
L["SHORTEN_GOLD"] = "金钱缩写"
L["TOGGLE_BAGS"] = "切换背包"
L["SESSION_TOTAL"] = "汇总"
L["DAILY_TOTAL"] = "Daily Total" -- TODO: To Translate
L["GOLD_ROUNDED_VALUES"] = "Gold rounded values" -- TODO: To Translate
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Hide Characters Under Threshold" -- TODO: To Translate
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Threshold" -- TODO: To Translate

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "未满级时显示经验条"
L["CLASS_COLORS_XP_BAR"] = "经验条使用职业颜色"
L["SHOW_TOOLTIPS"] = "显示提示"
L["TEXT_ON_RIGHT"] = "文字在右侧"
L["CURRENCY_SELECT"] = "选择货币"
L["FIRST_CURRENCY"] = "第一种货币"
L["SECOND_CURRENCY"] = "第二种货币"
L["THIRD_CURRENCY"] = "第三种货币"
L["RESTED"] = "精力充沛"
L["SHOW_MORE_CURRENCIES"] = "Show More Currencies on Shift+Hover" -- TODO: To Translate
L["MAX_CURRENCIES_SHOWN"] = "Max currencies shown when holding Shift" -- TODO: To Translate
L["ONLY_SHOW_MODULE_ICON"] = "Only Show Module Icon" -- TODO: To Translate
L["CURRENCY_NUMBER"] = "Number of Currencies on Bar" -- TODO: To Translate
L["CURRENCY_SELECTION"] = "Currency Selection" -- TODO: To Translate
L["SELECT_ALL"] = "Select All" -- TODO: To Translate
L["UNSELECT_ALL"] = "Unselect All" -- TODO: To Translate
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Open XIV's Currency Options" -- TODO: To Translate

-- System
L["WORLD_PING"] = "显示世界延迟"
L["ADDONS_NUMBER_TO_SHOW"] = "显示插件的数量"
L["ADDONS_IN_TOOLTIP"] = "在提示中显示的插件"
L["SHOW_ALL_ADDONS"] = "按住SHIFT键在提示中显示所有插件"
L["MEMORY_USAGE"] = "内存占用"
L["GARBAGE_COLLECT"] = "垃圾收集"
L["CLEANED"] = "已清理"

-- Reputation
L["OPEN_REPUTATION"] = "Open " .. REPUTATION -- TODO: To Translate
L["PARAGON_REWARD_AVAILABLE"] = "Paragon Reward available" -- TODO: To Translate
L["CLASS_COLORS_REPUTATION"] = "Use Class Colors for Reputation Bar" -- TODO: To Translate
L["REPUTATION_COLORS_REPUTATION"] = "Use Reputation Colors for Reputation Bar" -- TODO: To Translate
L["FLASH_PARAGON_REWARD"] = "Flash on Paragon Reward" -- TODO: To Translate
L["PROGRESS"] = "Progress" -- TODO: To Translate
L["RANK"] = "Rank" -- TODO: To Translate
L["PARAGON"] = "Paragon" -- TODO: To Translate

L["USE_CLASS_COLORS"] = "使用职业颜色"
L["COOLDOWNS"] = "冷却"
L["TOGGLE_PROFESSION_FRAME"] = '顯示職業框架'
L["TOGGLE_PROFESSION_SPELLBOOK"] = '表演專業拼寫本'

L["SET_SPECIALIZATION"] = "设置专精"
L["SET_LOADOUT"] = "Set Loadout" -- TODO: To Translate
L["SET_LOOT_SPECIALIZATION"] = "设置拾取专精"
L["CURRENT_SPECIALIZATION"] = "当前专精"
L["CURRENT_LOOT_SPECIALIZATION"] = "当前拾取专精"
L["TALENT_MINIMUM_WIDTH"] = "天赋最小宽度"
L["OPEN_ARTIFACT"] = "打开神器"
L["REMAINING"] = "剩余"
L["AVAILABLE_RANKS"] = "神器等级"
L["ARTIFACT_KNOWLEDGE"] = "神器知识"

L["SHOW_BUTTON_TEXT"] = "Show Button Text" -- TODO: To Translate

-- Travel (Translation needed)
L["HEARTHSTONE"] = "Hearthstone" -- TODO: To Translate
L["M_PLUS_TELEPORTS"] = "M+ Teleports" -- TODO: To Translate
L["ONLY_SHOW_CURRENT_SEASON"] = "Only show current season" -- TODO: To Translate
L["MYTHIC_PLUS_TELEPORTS"] = "Mythic+ Teleports" -- TODO: To Translate
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Hide M+ Teleports text" -- TODO: To Translate
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Show Mythic+ Teleports" -- TODO: To Translate
L["USE_RANDOM_HEARTHSTONE"] = "Use Random Hearthstone" -- TODO: To Translate
local retrievingData = "正在读取数据..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "如果你在下面的列表中看到 '" .. retrievingData .. "'，只需切换标签页或重新打开此菜单即可刷新数据。"
L["HEARTHSTONES_SELECT"] = "Hearthstones Select" -- TODO: To Translate
L["HEARTHSTONES_SELECT_DESC"] = "Select which hearthstones to use (be careful if you select multiple hearthstones, you might want to check the 'Hearthstones Select' option)" -- TODO: To Translate
L["HIDE_HEARTHSTONE_BUTTON"] = "Hide Hearthstone Button" -- TODO: To Translate
L["HIDE_PORT_BUTTON"] = "Hide Port Button" -- TODO: To Translate
L["HIDE_HOME_BUTTON"] = "Hide Home Button" -- TODO: To Translate
L["HIDE_HEARTHSTONE_TEXT"] = "Hide Hearthstone Text" -- TODO: To Translate
L["HIDE_PORT_TEXT"] = "Hide Port Text" -- TODO: To Translate
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Hide Additional Tooltip Text" -- TODO: To Translate
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Hide the hearthstone bind location and the select port button in the tooltip." -- TODO: To Translate
L["NOT_LEARNED"] = "Not learned" -- TODO: To Translate
L["SHOW_UNLEARNED_TELEPORTS"] = "Show unlearned teleports" -- TODO: To Translate
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Hide button during off-season" -- TODO: To Translate

-- House/Home Selection
L["HOME"] = "Home" -- TODO: To Translate
L["UNKNOWN_HOUSE"] = "Unknown House" -- TODO: To Translate
L["HOUSE"] = "House" -- TODO: To Translate
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Selected" -- TODO: To Translate
L["CHANGE_HOME"] = "Change Home" -- TODO: To Translate
L["NO_HOUSES_OWNED"] = "No Houses Owned" -- TODO: To Translate
L["VISIT_SELECTED_HOME"] = "Visit Selected Home" -- TODO: To Translate

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
L["CURRENT_SEASON"] = "Current season" -- TODO: To Translate

-- Profile Import/Export
L["PROFILE_SHARING"] = "Profile Sharing" -- TODO: To Translate

L["INVALID_IMPORT_STRING"] = "Invalid import string" -- TODO: To Translate
L["FAILED_DECODE_IMPORT_STRING"] = "Failed to decode import string" -- TODO: To Translate
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Failed to decompress import string" -- TODO: To Translate
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Failed to deserialize import string" -- TODO: To Translate
L["INVALID_PROFILE_FORMAT"] = "Invalid profile format" -- TODO: To Translate
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Profile imported successfully as" -- TODO: To Translate

L["COPY_EXPORT_STRING"] = "Copy the export string below:" -- TODO: To Translate
L["PASTE_IMPORT_STRING"] = "Paste the import string below:" -- TODO: To Translate
L["IMPORT_EXPORT_PROFILES_DESC"] = "Import or export your profiles to share them with other players." -- TODO: To Translate
L["PROFILE_IMPORT_EXPORT"] = "Profile Import/Export" -- TODO: To Translate
L["EXPORT_PROFILE"] = "Export Profile" -- TODO: To Translate
L["EXPORT_PROFILE_DESC"] = "Export your current profile settings" -- TODO: To Translate
L["IMPORT_PROFILE"] = "Import Profile" -- TODO: To Translate
L["IMPORT_PROFILE_DESC"] = "Import a profile from another player" -- TODO: To Translate

-- Changelog
L["DATE_FORMAT"] = "%year%年%month%月%day%日"
L["IMPORTANT"] = "重要"
L["NEW"] = "新增"
L["IMPROVEMENT"] = "改善"
L["BUGFIX"] = "Bugfix" -- TODO: To Translate
L["CHANGELOG"] = "更新记录"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts." -- TODO: To Translate
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level." -- TODO: To Translate