local AddOnName, XIVBar = ...;

XIVBar.Changelog[4000] = {
    version_string = "4.0",
    release_date = "2026/01/18",
    important = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    new = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {
            "[Global] Major internal refactor to centralize version-specific logic (compat layer), unify modules/loaders, and reduce duplication across Retail/Classic variants. Common modules now live in shared locations, while version-specific behavior is isolated behind compat helpers. This simplifies long-term maintenance, reduces regressions when new WoW flavors arrive, and makes deployments more consistent. Version bumped to 4.0 due to the scope of these architecture and maintenance changes.",
            "[TBC Anniversary] Added full compatibility support.",
            "[Travel] Added Naaru's Embrace hearthstone to the [Travel] module.",
        },
        ["frFR"] = {
            "[Global] Refonte majeure interne pour centraliser la logique spécifique aux versions (compat), unifier modules/loaders et réduire la duplication entre Retail/Classic. Les modules communs sont regroupés, et les comportements spécifiques sont isolés via des helpers de compatibilité. Cela simplifie la maintenance à long terme, limite les régressions lors de l'arrivée de nouvelles \"versions\" de WoW et fiabilise les déploiements. Passage en 4.0 compte-tenu de l'ampleur des changements d'architecture et de maintenance.",
            "[TBC Anniversary] Ajout de la compatibilité complète.",
            "[Travel] Ajout de la pierre de foyer Étreinte des Naaru au module [Voyage].",
        },
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    improvment = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    },
    bugfix = {
        ["zhCN"] = {},
        ["zhTW"] = {},
        ["enUS"] = {},
        ["frFR"] = {},
        ["koKR"] = {},
        ["ruRU"] = {}
    }
}