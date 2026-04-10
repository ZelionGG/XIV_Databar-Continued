# XIV_Databar Continued

## [5.4](https://github.com/ZelionGG/XIV_Databar-Continued/releases/tag/5.4) (2026-04-10)

[Full Changelog](https://github.com/ZelionGG/XIV_Databar-Continued/compare/5.3...5.4) [Previous Releases](https://github.com/ZelionGG/XIV_Databar-Continued/releases)

> **Version 5.4 - Tooltip Improvements & Classic Fixes**
>
> This update focuses on tooltip improvements across several modules, with updates for **Tradeskill**, **Clock**, **Gold**, and **Travel**.
> It also adds a global option to hide XIV Databar tooltips during combat and fixes Classic Lua errors caused by missing locale strings.

### _Global :_

- 🔥 _**IMPORTANT** -_ Added the **Hide Tooltips in Combat** option to suppress XIV Databar tooltips during combat across supported modules.
- 🆕 _**NEW** -_ Added calendar event lines with formatted start and end times to the **Clock** module tooltip.
- 🛠️ _**IMPROVEMENT** -_ Reworked the **Tradeskill** tooltip with clickable hover handling and added the optional **Use Interactive Tooltip** mode with fallback to the default tooltip.
- 🐞 _**BUGFIX** -_ Fixed **Gold** tooltip totals so negative **Session Total** and **Daily Total** values now keep their minus sign correctly.

### _Retail :_

- 🆕 _**NEW** -_ Added an optional **WoW Token** price line to the **Gold** module tooltip.
- 🆕 _**NEW** -_ Added **Path of the Naaru** to the **Travel** module hearthstone list (thank you **flaicher**).

### _Classic :_

- 🐞 _**BUGFIX** -_ Fixed Lua errors caused by missing locale strings.
