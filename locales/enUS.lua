local AddOnName, _ = ...

local LibStub = LibStub
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "enUS", true, false)

-- NOTE: Some strings are sourced from BlizzardInterfaceResources:
-- https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/GlobalStrings/enUS.lua

L["MODULES"] = "Modules"
L["LEFT_CLICK"] = "Left-Click"
L["RIGHT_CLICK"] = "Right-Click"
L["k"] = true -- short for 1000
L["M"] = true -- short for 1000000
L["B"] = true -- short for 1000000000
L["L"] = true -- For the local ping
L["W"] = true -- For the world ping

-- General
L["POSITIONING"] = "Positioning"
L["BAR_POSITION"] = "Bar Position"
L["TOP"] = "Top"
L["BOTTOM"] = "Bottom"
L["BAR_COLOR"] = "Bar Color"
L["USE_CLASS_COLOR"] = "Use Class Color for Bar"
L["MISCELLANEOUS"] = "Miscellaneous"
L["HIDE_IN_COMBAT"] = "Hide Bar in combat"
L["HIDE_IN_FLIGHT"] = "Hide when in flight"
L["SHOW_ON_MOUSEOVER"] = "Show on mouseover"
L["SHOW_ON_MOUSEOVER_DESC"] = "Show the bar only when you mouseover it"
L["BAR_PADDING"] = "Bar Padding"
L["MODULE_SPACING"] = "Module Spacing"
L["BAR_MARGIN"] = "Bar Margin"
L["BAR_MARGIN_DESC"] = "Leftmost and rightmost margin of the bar modules"
L["HIDE_ORDER_HALL_BAR"] = "Hide order hall bar"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Use ElvUI for tooltips"
L["LOCK_BAR"] = "Lock Bar"
L["LOCK_BAR_DESC"] = "Lock the bar to prevent dragging"
L["BAR_FULLSCREEN_DESC"] = "Makes the bar span the entire screen width"
L["BAR_POSITION_DESC"] = "Position the bar at the top or bottom of the screen"
L["X_OFFSET"] = "X Offset"
L["Y_OFFSET"] = "Y Offset"
L["HORIZONTAL_POSITION"] = "Horizontal position of the bar"
L["VERTICAL_POSITION"] = "Vertical position of the bar"
L["BEHAVIOR"] = "Behavior"
L["SPACING"] = "Spacing"

-- Modules Positioning
L["MODULES_POSITIONING"] = "Modules Positioning"
L["ENABLE_FREE_PLACEMENT"] = "Enable free placement"
L["ENABLE_FREE_PLACEMENT_DESC"] = "Enable independent X positioning for each module and disable inter-module anchors"
L["RESET_ALL_POSITIONS"] = "Reset All Positions"
L["RESET_ALL_POSITIONS_DESC"] = "Reset all modules to their initial free placement positions"
L["ANCHOR_POINT"] = "Anchor Point"
L["X_POSITION"] = "X Position"
L["RESET_POSITION"] = "Reset Position"
L["RESET_POSITION_DESC"] = "Reset to the anchored position"
L["RECAPTURE_INITIAL_POSITIONS"] = "Re-capture initial positions"
L["RECAPTURE_INITIAL_POSITIONS_DESC"] = "Capture the current anchored positions as the new initial free placement positions"

-- Positioning Options
L["BAR_WIDTH"] = "Bar Width"
L["LEFT"] = "Left"
L["CENTER"] = "Center"
L["RIGHT"] = "Right"

-- Media
L["FONT"] = "Font"
L["SMALL_FONT_SIZE"] = "Small Font Size"
L["TEXT_STYLE"] = "Text Style"

-- Text Colors
L["COLORS"] = "Colors"
L["TEXT_COLORS"] = "Text Colors"
L["NORMAL"] = "Normal"
L["INACTIVE"] = "Inactive"
L["USE_CLASS_COLOR_TEXT"] = "Use Class Color for Text"
L["USE_CLASS_COLOR_TEXT_DESC"] = "Only the alpha can be set with the color picker"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Use Class Colors for Hover"
L["HOVER"] = "Hover"

-------------------- MODULES ---------------------------

L["MICROMENU"] = "Micromenu"
L["SHOW_SOCIAL_TOOLTIPS"] = "Show Social Tooltips"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Show Accessibility Tooltips"
L["BLIZZARD_MICROMENU"] = "Blizzard Micromenu"
L["DISABLE_BLIZZARD_MICROMENU"] = "Disable Blizzard Micromenu"
L["KEEP_QUEUE_STATUS_ICON"] = "Keep Queue Status Icon"
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
L["BLIZZARD_BAGS_BAR"] = "Blizzard Bags Bar"
L["DISABLE_BLIZZARD_BAGS_BAR"] = "Disable Blizzard Bags Bar"
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.'
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Main Menu Icon Right Spacing"
L["ICON_SPACING"] = "Icon Spacing"
L["HIDE_BNET_APP_FRIENDS"] = "Hide BNet App Friends"
L["OPEN_GUILD_PAGE"] = "Open Guild Page"
L["NO_TAG"] = "No Tag"
L["WHISPER_BNET"] = "Whisper BNet"
L["WHISPER_CHARACTER"] = "Whisper Character"
L["HIDE_SOCIAL_TEXT"] = "Hide Social Text"
L["SOCIAL_TEXT_OFFSET"] = "Social Text Offset"
L["GMOTD_IN_TOOLTIP"] = "GMOTD in Tooltip"
L["FRIEND_INVITE_MODIFIER"] = "Modifier for friend invite"
L["SHOW_HIDE_BUTTONS"] = "Show/Hide Buttons"
L["SHOW_MENU_BUTTON"] = "Show Menu Button"
L["SHOW_CHAT_BUTTON"] = "Show Chat Button"
L["SHOW_GUILD_BUTTON"] = "Show Guild Button"
L["SHOW_SOCIAL_BUTTON"] = "Show Social Button"
L["SHOW_CHARACTER_BUTTON"] = "Show Character Button"
L["SHOW_SPELLBOOK_BUTTON"] = "Show Spellbook Button"
L["SHOW_TALENTS_BUTTON"] = "Show Talents Button"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Show Achievements Button"
L["SHOW_QUESTS_BUTTON"] = "Show Quests Button"
L["SHOW_LFG_BUTTON"] = "Show LFG Button"
L["SHOW_JOURNAL_BUTTON"] = "Show Journal Button"
L["SHOW_PVP_BUTTON"] = "Show PVP Button"
L["SHOW_PETS_BUTTON"] = "Show Pets Button"
L["SHOW_SHOP_BUTTON"] = "Show Shop Button"
L["SHOW_HELP_BUTTON"] = "Show Help Button"
L["SHOW_HOUSING_BUTTON"] = "Show Housing Button"
L["NO_INFO"] = "No Info"
L["Alliance"] = FACTION_ALLIANCE
L["Horde"] = FACTION_HORDE

L["DURABILITY_WARNING_THRESHOLD"] = "Durability Warning Threshold"
L["SHOW_ITEM_LEVEL"] = "Show Item Level"
L["SHOW_COORDINATES"] = "Show Coordinates"

-- Master Volume
L["MASTER_VOLUME"] = "Master Volume"
L["VOLUME_STEP"] = "Volume step"
L["ENABLE_MOUSE_WHEEL"] = "Enable Mouse Wheel"

-- Clock
L["TIME_FORMAT"] = "Time Format"
L["USE_SERVER_TIME"] = "Use Server Time"
L["NEW_EVENT"] = "New Event!"
L["LOCAL_TIME"] = "Local Time"
L["REALM_TIME"] = "Realm Time"
L["OPEN_CALENDAR"] = "Open Calendar"
L["OPEN_CLOCK"] = "Open Clock"
L["HIDE_EVENT_TEXT"] = "Hide Event Text"
L["REST_ICON"] = "Rest Icon"
L["SHOW_REST_ICON"] = "Show Rest Icon"
L["TEXTURE"] = "Texture"
L["DEFAULT"] = "Default"
L["CUSTOM"] = "Custom"
L["CUSTOM_TEXTURE"] = "Custom Texture"
L["HIDE_REST_ICON_MAX_LEVEL"] = "Hide at Max Level"
L["TEXTURE_SIZE"] = "Texture Size"
L["POSITION"] = "Position"
L["CUSTOM_TEXTURE_COLOR"] = "Custom Color"
L["COLOR"] = "Color"

L["TRAVEL"] = "Travel"
L["PORT_OPTIONS"] = "Port Options"
L["READY"] = "Ready"
L["TRAVEL_COOLDOWNS"] = "Travel Cooldowns"
L["CHANGE_PORT_OPTION"] = "Change Port Option"

-- Gold
L["REGISTERED_CHARACTERS"] = "Registered characters"
L["SHOW_FREE_BAG_SPACE"] = "Show Free Bag Space"
L["SHOW_OTHER_REALMS"] = "Show Other Realms"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Always Show Silver and Copper"
L["SHORTEN_GOLD"] = "Shorten Gold"
L["TOGGLE_BAGS"] = "Toggle Bags"
L["SESSION_TOTAL"] = "Session Total"
L["DAILY_TOTAL"] = "Daily Total"
L["SHOW_WARBAND_BANK_GOLD"] = "Show " .. ACCOUNT_BANK_PANEL_TITLE .. " Gold"
L["GOLD_ROUNDED_VALUES"] = "Gold rounded values"
L["HIDE_CHAR_UNDER_THRESHOLD"] = "Hide Characters Under Threshold"
L["HIDE_CHAR_UNDER_THRESHOLD_AMOUNT"] = "Threshold"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Show XP Bar Below Max Level"
L["CLASS_COLORS_XP_BAR"] = "Use Class Colors for XP Bar"
L["SHOW_TOOLTIPS"] = "Show Tooltips"
L["TEXT_ON_RIGHT"] = "Text on Right"
L["CURRENCY_SELECT"] = "Currency Select"
L["FIRST_CURRENCY"] = "First Currency"
L["SECOND_CURRENCY"] = "Second Currency"
L["THIRD_CURRENCY"] = "Third Currency"
L["RESTED"] = "Rested"
L["SHOW_MORE_CURRENCIES"] = "Show More Currencies on Shift+Hover"
L["MAX_CURRENCIES_SHOWN"] = "Max currencies shown when holding Shift"
L["ONLY_SHOW_MODULE_ICON"] = "Only Show Module Icon"
L["CURRENCY_NUMBER"] = "Number of Currencies on Bar"
L["CURRENCY_SELECTION"] = "Currency Selection"
L["SELECT_ALL"] = "Select All"
L["UNSELECT_ALL"] = "Unselect All"
L["OPEN_XIV_CURRENCY_OPTIONS"] = "Open XIV's Currency Options"

-- System
L["WORLD_PING"] = "Show World Ping"
L["ADDONS_NUMBER_TO_SHOW"] = "Number of Addons To Show"
L["ADDONS_IN_TOOLTIP"] = "Addons to Show in Tooltip"
L["SHOW_ALL_ADDONS"] = "Show All Addons in Tooltip with Shift"
L["MEMORY_USAGE"] = "Memory Usage"
L["GARBAGE_COLLECT"] = "Garbage Collect"
L["CLEANED"] = "Cleaned"

-- Reputation
L["OPEN_REPUTATION"] = "Open " .. REPUTATION
L["PARAGON_REWARD_AVAILABLE"] = "Paragon Reward available"
L["CLASS_COLORS_REPUTATION"] = "Use Class Colors for Reputation Bar"
L["REPUTATION_COLORS_REPUTATION"] = "Use Reputation Colors for Reputation Bar"
L["FLASH_PARAGON_REWARD"] = "Flash on Paragon Reward"
L["PROGRESS"] = "Progress"
L["RANK"] = "Rank"
L["PARAGON"] = "Paragon"

L["USE_CLASS_COLORS"] = "Use Class Colors"
L["COOLDOWNS"] = "Cooldowns"
L["TOGGLE_PROFESSION_FRAME"] = "Toggle Profession Frame"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Toggle Profession Spellbook"

L["SET_SPECIALIZATION"] = "Set Specialization"
L["SET_LOADOUT"] = "Set Loadout"
L["SET_LOOT_SPECIALIZATION"] = "Set Loot Specialization"
L["CURRENT_SPECIALIZATION"] = "Current Specialization"
L["CURRENT_LOOT_SPECIALIZATION"] = "Current Loot Specialization"
L["ENABLE_LOADOUT_SWITCHER"] = "Enable Loadout Switcher"
L["TALENT_MINIMUM_WIDTH"] = "Talent Minimum Width"
L["OPEN_ARTIFACT"] = "Open Artifact"
L["REMAINING"] = "Remaining"
L["KILLS_TO_LEVEL"] = "Kills to level"
L["LAST_XP_GAIN"] = "Last xp gain"
L["AVAILABLE_RANKS"] = "Available Ranks"
L["ARTIFACT_KNOWLEDGE"] = "Artifact Knowledge"

L["SHOW_BUTTON_TEXT"] = "Show Button Text"

-- Travel
L["HEARTHSTONE"] = "Hearthstone"
L["M_PLUS_TELEPORTS"] = "M+ Teleports"
L["ONLY_SHOW_CURRENT_SEASON"] = "Only show current season"
L["MYTHIC_PLUS_TELEPORTS"] = "Mythic+ Teleports"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = "Hide M+ Teleports text"
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Show Mythic+ Teleports"
L["USE_RANDOM_HEARTHSTONE"] = "Use Random Hearthstone"
local retrievingData = "Retrieving data..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "If you see '" .. retrievingData .. "' in the list below, simply switch tabs or reopen this menu to refresh the data."
L["HEARTHSTONES_SELECT"] = "Hearthstones Select"
L["HEARTHSTONES_SELECT_DESC"] = "Select which hearthstones to use (be careful if you select multiple hearthstones, you might want to check the 'Hearthstones Select' option)"
L["HIDE_HEARTHSTONE_BUTTON"] = "Hide Hearthstone Button"
L["HIDE_PORT_BUTTON"] = "Hide Port Button"
L["HIDE_HOME_BUTTON"] = "Hide Home Button"
L["HIDE_HEARTHSTONE_TEXT"] = "Hide Hearthstone Text"
L["HIDE_PORT_TEXT"] = "Hide Port Text"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT"] = "Hide Additional Tooltip Text"
L["HIDE_ADDITIONAL_TOOLTIP_TEXT_DESC"] = "Hide the hearthstone bind location and the select port button in the tooltip."
L["NOT_LEARNED"] = "Not learned"
L["SHOW_UNLEARNED_TELEPORTS"] = "Show unlearned teleports"
L["HIDE_BUTTON_DURING_OFF_SEASON"] = "Hide button during off-season"

-- House/Home Selection
L["HOME"] = "Home"
L["UNKNOWN_HOUSE"] = "Unknown House"
L["HOUSE"] = "House"
L["PLOT"] = NEIGHBORHOOD_ROSTER_COLUMN_TITLE_PLOT
L["SELECTED"] = "Selected"
L["CHANGE_HOME"] = "Change Home"
L["NO_HOUSES_OWNED"] = "No Houses Owned"
L["VISIT_SELECTED_HOME"] = "Visit Selected Home"

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
L["CURRENT_SEASON"] = "Current season"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Profile Sharing"

L["INVALID_IMPORT_STRING"] = "Invalid import string"
L["FAILED_DECODE_IMPORT_STRING"] = "Failed to decode import string"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Failed to decompress import string"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Failed to deserialize import string"
L["INVALID_PROFILE_FORMAT"] = "Invalid profile format"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Profile imported successfully as"

L["COPY_EXPORT_STRING"] = "Copy the export string below:"
L["PASTE_IMPORT_STRING"] = "Paste the import string below:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Import or export your profiles to share them with other players."
L["PROFILE_IMPORT_EXPORT"] = "Profile Import/Export"
L["EXPORT_PROFILE"] = "Export Profile"
L["EXPORT_PROFILE_DESC"] = "Export your current profile settings"
L["IMPORT_PROFILE"] = "Import Profile"
L["IMPORT_PROFILE_DESC"] = "Import a profile from another player"

-- Changelog
L["DATE_FORMAT"] = "%month%-%day%-%year%"
L["IMPORTANT"] = "Important"
L["NEW"] = "New"
L["IMPROVEMENT"] = "Improvement"
L["BUGFIX"] = "Bugfix"
L["CHANGELOG"] = "Changelog"

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."