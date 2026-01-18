# XIV_Databar Continued

## [4.0](https://github.com/ZelionGG/XIV_Databar-Continued/releases/tag/4.0) (2026-01-18)

[Full Changelog](https://github.com/ZelionGG/XIV_Databar-Continued/compare/v3.9.1...v4.0) [Previous Releases](https://github.com/ZelionGG/XIV_Databar-Continued/releases)

### _Global :_

- Major internal refactor to centralize version-specific logic (compat layer), unify modules/loaders, and reduce duplication across Retail/Classic variants. Common modules now live in shared locations, while version-specific behavior is isolated behind compat helpers. This simplifies long-term maintenance, reduces regressions when new WoW flavors arrive, and makes deployments more consistent. Version bumped to 4.0 due to the scope of these architecture and maintenance changes.

### _Retail :_

- Added Naaru's Embrace hearthstone to the **Travel** module.

### _Mists of Pandaria Classic :_

- Added Naaru's Embrace hearthstone to the **Travel** module.

### _TBC Anniversary :_

- Added full support.

