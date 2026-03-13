local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "zhCN", false, false)
if not L then return end

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
L["HIDE_IN_FLIGHT"] = true
L["SHOW_ON_MOUSEOVER"] = true -- Needs translation
L["SHOW_ON_MOUSEOVER_DESC"] = true -- Needs translation
L["BAR_PADDING"] = "条填充"
L["MODULE_SPACING"] = "模块间距"
L["BAR_MARGIN"] = "条形边距"
L["BAR_MARGIN_DESC"] = true -- Need translation
L["HIDE_ORDER_HALL_BAR"] = "隐藏职业大厅条"
L["USE_ELVUI_FOR_TOOLTIPS"] = "使用ElvUI作為工具提示"
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
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = true -- Needs Translation
L["BLIZZARD_MICROMENU"] = true
L["DISABLE_BLIZZARD_MICROMENU"] = true
L["KEEP_QUEUE_STATUS_ICON"] = true
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["BLIZZARD_BAGS_BAR"] = true
L["DISABLE_BLIZZARD_BAGS_BAR"] = true
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "主菜单图标右间距"
L["ICON_SPACING"] = "图标间距"
L["HIDE_BNET_APP_FRIENDS"] = true
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
L["SHOW_HOUSING_BUTTON"] = true -- TODO: translate
L["NO_INFO"] = "暂无信息"
L["CLASSIC"] = "经典怀旧服"
L["ALLIANCE"] = "联盟"
L["HORDE"] = "部落"

L["DURABILITY_WARNING_THRESHOLD"] = "耐久性警告閾值"
L["SHOW_ITEM_LEVEL"] = "顯示物品等級"
L["SHOW_COORDINATES"] = "顯示坐標"

L["MASTER_VOLUME"] = "主音量"
L["VOLUME_STEP"] = "音量调节"

L["TIME_FORMAT"] = "时间格式"
L["USE_SERVER_TIME"] = "使用服务器时间"
L["NEW_EVENT"] = "新事件!"
L["LOCAL_TIME"] = "本地时间"
L["REALM_TIME"] = "服务器时间"
L["OPEN_CALENDAR"] = "打开日历"
L["OPEN_CLOCK"] = "打开时钟"
L["HIDE_EVENT_TEXT"] = "隐藏事件文字"

L["TRAVEL"] = "传送"
L["PORT_OPTIONS"] = "传送选项"
L["READY"] = "就绪"
L["TRAVEL_COOLDOWNS"] = "传送冷却"
L["CHANGE_PORT_OPTION"] = "更改传送选项"

L["REGISTERED_CHARACTERS"] = true
L["SHOW_FREE_BAG_SPACE"] = true
L["SHOW_OTHER_REALMS"] = true
L["ALWAYS_SHOW_SILVER_COPPER"] = "始终显示银币和铜币"
L["SHORTEN_GOLD"] = "金钱缩写"
L["TOGGLE_BAGS"] = "切换背包"
L["SESSION_TOTAL"] = "汇总"
L["DAILY_TOTAL"] = true
L["GOLD_ROUNDED_VALUES"] = true

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
L["SHOW_MORE_CURRENCIES"] = true -- To Translate
L["MAX_CURRENCIES_SHOWN"] = true -- To Translate
L["ONLY_SHOW_MODULE_ICON"] = true -- To Translate
L["CURRENCY_NUMBER"] = true -- To Translate
L["CURRENCY_SELECTION"] = true -- To Translate
L["SELECT_ALL"] = true -- To Translate
L["UNSELECT_ALL"] = true -- To Translate
L["OPEN_XIV_CURRENCY_OPTIONS"] = true -- To Translate

-- System
L["WORLD_PING"] = "显示世界延迟"
L["ADDONS_NUMBER_TO_SHOW"] = "显示插件的数量"
L["ADDONS_IN_TOOLTIP"] = "在提示中显示的插件"
L["SHOW_ALL_ADDONS"] = "按住SHIFT键在提示中显示所有插件"
L["MEMORY_USAGE"] = "内存占用"
L["GARBAGE_COLLECT"] = "垃圾收集"
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

L["USE_CLASS_COLORS"] = "使用职业颜色"
L["COOLDOWNS"] = "冷却"
L["TOGGLE_PROFESSION_FRAME"] = '顯示職業框架'
L["TOGGLE_PROFESSION_SPELLBOOK"] = '表演專業拼寫本'

L["SET_SPECIALIZATION"] = "设置专精"
L["SET_LOADOUT"] = true -- Translation needed
L["SET_LOOT_SPECIALIZATION"] = "设置拾取专精"
L["CURRENT_SPECIALIZATION"] = "当前专精"
L["CURRENT_LOOT_SPECIALIZATION"] = "当前拾取专精"
L["TALENT_MINIMUM_WIDTH"] = "天赋最小宽度"
L["OPEN_ARTIFACT"] = "打开神器"
L["REMAINING"] = "剩余"
L["AVAILABLE_RANKS"] = "神器等级"
L["ARTIFACT_KNOWLEDGE"] = "神器知识"

L["SHOW_BUTTON_TEXT"] = true -- Needs Translation

-- Travel (Translation needed)
L["HEARTHSTONE"] = true
L["M_PLUS_TELEPORTS"] = true
L["ONLY_SHOW_CURRENT_SEASON"] = true
L["MYTHIC_PLUS_TELEPORTS"] = true
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = true -- Needs Translate
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = true
L["USE_RANDOM_HEARTHSTONE"] = true
local retrievingData = "正在读取数据..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "如果你在下面的列表中看到 '" .. retrievingData .. "'，只需切换标签页或重新打开此菜单即可刷新数据。"
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
L["DATE_FORMAT"] = "%year%年%month%月%day%日"
L["VERSION"] = "版本"
L["IMPORTANT"] = "重要"
L["NEW"] = "新增"
L["IMPROVEMENT"] = "改善"
L["BUGFIX"] = true -- To Translate
L["CHANGELOG"] = "更新记录"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."
