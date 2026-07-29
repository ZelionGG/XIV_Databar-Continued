# XIV_Databar Continued

## [5.7](https://github.com/ZelionGG/XIV_Databar-Continued/releases/tag/5.7) (2026-07-29)

[Full Changelog](https://github.com/ZelionGG/XIV_Databar-Continued/compare/5.6...5.7) [Previous Releases](https://github.com/ZelionGG/XIV_Databar-Continued/releases)

> **Version 5.7 - DataBrokers, Profiles & Travel**
>
> This update finally ships the long-awaited **DataBrokers** module to display third-party LibDataBroker plugins on the bar.
> It also migrates profiles to per-character defaults, improves **Travel** Mythic+ season navigation, and adds login/update chat messages.

### _Global :_

- 🔥 _**IMPORTANT** -_ Profiles now default to a per-character "Name - Realm" profile. Existing characters on the shared Default profile get a one-time migration prompt; new characters can join Default or keep a blank personal profile.
- 🆕 _**NEW** -_ Added the long-awaited **DataBrokers** module: enable third-party LibDataBroker data sources and launchers as independent bar pieces with icon/text display, click and tooltip forwarding, free placement, per-object toggles, type filters, icon size options, and options nested by source addon.
- 🆕 _**NEW** -_ Added a login chat tip with the /xivc settings command, a **Disable login message** option under **Behavior**, and a chat update announcement with a clickable **Open Changelog** link when the addon version changes.
- 🛠️ _**IMPROVEMENT** -_ Localized dates now use Blizzard's default function for consistent calendar formatting.
- 🛠️ _**IMPROVEMENT** -_ Class color toggles no longer overwrite saved custom colors; disabling a class-color flag restores the previous RGB.

### _Retail :_

- 🆕 _**NEW** -_ Added the Alliance Boralus portal to the **Travel** module
- 🆕 _**NEW** -_ Added Midnight Season 2 Mythic+ teleports to the **Travel** module.
- 🆕 _**NEW** -_ Added Mythic+ season date ranges, a Next season group, and temporary dungeon name fallbacks in the **Travel** Mythic+ Teleports menu.

### _TBC Anniversary :_

- 🛠️ _**IMPROVEMENT** -_ TOC update for patch 2.5.6.

### _Classic SoD :_

- 🛠️ _**IMPROVEMENT** -_ TOC update for patch 1.15.9.

### _Classic :_

- 🐞 _**BUGFIX** -_ Fixed **Armor** durability API usage and hid equipment-set UI on flavors without equipment sets.
