local AddOnName, _ = ...

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
---@class XIV_DatabarLocale : table<string, boolean|string>
local L ---@type XIV_DatabarLocale
L = AceLocale:NewLocale(AddOnName, "ptBR", false, false)
if not L then return end

L["MODULES"] = "Módulos"
L["LEFT_CLICK"] = "Clique Esquerdo"
L["RIGHT_CLICK"] = "Clique Direito"
L["k"] = true -- short for 1000
L["M"] = true -- short for 1000000
L["B"] = true -- short for 1000000000
L["L"] = true -- For the local ping
L["W"] = true -- For the world ping

-- General
L["POSITIONING"] = "Posicionamento"
L["BAR_POSITION"] = "Posição da Barra"
L["TOP"] = "Topo"
L["BOTTOM"] = "Inferior"
L["BAR_COLOR"] = "Cor da Barra"
L["USE_CLASS_COLOR"] = "Cor da classe na barra"
L["MISCELLANEOUS"] = "Outros"
L["HIDE_IN_COMBAT"] = "Ocultar barra em combate"
L["HIDE_IN_FLIGHT"] = "Ocultar durante voo"
L["SHOW_ON_MOUSEOVER"] = true -- Needs translation
L["SHOW_ON_MOUSEOVER_DESC"] = true -- Needs translation
L["BAR_PADDING"] = "Preenchimento da Barra"
L["MODULE_SPACING"] = "Espaçamento entre Módulos"
L["BAR_MARGIN"] = "Margem da Barra"
L["BAR_MARGIN_DESC"] = "Margem esquerda e direita dos módulos da barra"
L["HIDE_ORDER_HALL_BAR"] = "Ocultar barra dos Salões de Classe"
L["USE_ELVUI_FOR_TOOLTIPS"] = "Usar ElvUI para dicas"
L["LOCK_BAR"] = "Travar Barra"
L["LOCK_BAR_DESC"] = "Impedir movimentação"
L["BAR_FULLSCREEN_DESC"] = "Ocupar toda a largura da tela"
L["BAR_POSITION_DESC"] = "Posicionar a barra no topo ou embaixo da tela"
L["X_OFFSET"] = "Deslocamento X"
L["Y_OFFSET"] = "Deslocamento Y"
L["HORIZONTAL_POSITION"] = "Posição horizontal da barra"
L["VERTICAL_POSITION"] = "Posição vertical da barra"
L["BEHAVIOR"] = "Comportamento"
L["SPACING"] = "Espaçamento"

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
L["BAR_WIDTH"] = "Largura da Barra"
L["LEFT"] = "Esquerda"
L["CENTER"] = "Centro"
L["RIGHT"] = "Direita"

-- Media
L["FONT"] = "Fonte"
L["SMALL_FONT_SIZE"] = "Tamanho da Fonte Pequena"
L["TEXT_STYLE"] = "Estilo do Texto"

-- Text Colors
L["COLORS"] = "Cores"
L["TEXT_COLORS"] = "Cores do Texto"
L["NORMAL"] = "Normal"
L["INACTIVE"] = "Inativo"
L["USE_CLASS_COLOR_TEXT"] = "Usar cor da classe para o texto"
L["USE_CLASS_COLOR_TEXT_DESC"] = "Transparência apenas no seletor de cores"
L["USE_CLASS_COLORS_FOR_HOVER"] = "Usar cor da classe no mouse sobre"
L["HOVER"] = "Mouse sobre"

-------------------- MODULES ---------------------------

L["MICROMENU"] = true
L["SHOW_SOCIAL_TOOLTIPS"] = "Mostrar informações da lista de amigos"
L["SHOW_ACCESSIBILITY_TOOLTIPS"] = "Mostrar informações de acessibilidade"
L["BLIZZARD_MICROMENU"] = true
L["DISABLE_BLIZZARD_MICROMENU"] = true
L["KEEP_QUEUE_STATUS_ICON"] = true
L["BLIZZARD_MICROMENU_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["BLIZZARD_BAGS_BAR"] = true
L["DISABLE_BLIZZARD_BAGS_BAR"] = true
L["BLIZZARD_BAGS_BAR_DISCLAIMER"] = 'This option is disabled because an external bar manager was detected: %s.' -- To Translate
L["MAIN_MENU_ICON_RIGHT_SPACING"] = "Espaçamento à Direita do Ícone do Menu Principal"
L["ICON_SPACING"] = "Espaçamento dos Ícones"
L["HIDE_BNET_APP_FRIENDS"] = "Ocultar Amigos da BNet"
L["OPEN_GUILD_PAGE"] = "Abrir Página da Guilda"
L["NO_TAG"] = true
L["WHISPER_BNET"] = "Sussurrar via BNet"
L["WHISPER_CHARACTER"] = "Sussurrar para o Personagem"
L["HIDE_SOCIAL_TEXT"] = "Ocultar Texto Social"
L["SOCIAL_TEXT_OFFSET"] = "Deslocamento do Texto Social"
L["GMOTD_IN_TOOLTIP"] = "Mensagem do Dia na Dica de Tela"
L["FRIEND_INVITE_MODIFIER"] = "Modificador para Convite de Amigo"

L["SHOW_HIDE_BUTTONS"] = "Mostrar/Ocultar Botões"
L["SHOW_MENU_BUTTON"] = "Mostrar Botão de Menu"
L["SHOW_CHAT_BUTTON"] = "Mostrar Botão de Chat"
L["SHOW_GUILD_BUTTON"] = "Mostrar Botão da Guilda"
L["SHOW_SOCIAL_BUTTON"] = "Mostrar Botão Social"
L["SHOW_CHARACTER_BUTTON"] = "Mostrar Botão do Personagem"
L["SHOW_SPELLBOOK_BUTTON"] = "Mostrar Botão de Magias"
L["SHOW_TALENTS_BUTTON"] = "Mostrar Botão de Talentos"
L["SHOW_ACHIEVEMENTS_BUTTON"] = "Mostrar Botão de Conquistas"
L["SHOW_QUESTS_BUTTON"] = "Mostrar Botão de Missões"
L["SHOW_LFG_BUTTON"] = "Mostrar Botão de LFG"
L["SHOW_JOURNAL_BUTTON"] = "Mostrar Botão do Diário"
L["SHOW_PVP_BUTTON"] = "Mostrar Botão de PVP"
L["SHOW_PETS_BUTTON"] = "Mostrar Botão de Mascotes"
L["SHOW_SHOP_BUTTON"] = "Mostrar Botão da Loja"
L["SHOW_HELP_BUTTON"] = "Mostrar Botão de Ajuda"
L["SHOW_HOUSING_BUTTON"] = true -- TODO: translate
L["NO_INFO"] = "Sem Informação"
L["CLASSIC"] = true
L["ALLIANCE"] = "Aliança"
L["HORDE"] = "Horda"

L["DURABILITY_WARNING_THRESHOLD"] = "Aviso de Durabilidade"
L["SHOW_ITEM_LEVEL"] = "Mostrar item level"
L["SHOW_COORDINATES"] = "Mostrar coordenadas"

L["MASTER_VOLUME"] = "Volume geral"
L["VOLUME_STEP"] = true

L["TIME_FORMAT"] = "Formato da Hora"
L["USE_SERVER_TIME"] = "Usar hora do Servidor"
L["NEW_EVENT"] = "Novo Evento!"
L["LOCAL_TIME"] = "Horário Local"
L["REALM_TIME"] = "Horário do Servidor"
L["OPEN_CALENDAR"] = "Abrir Calendário"
L["OPEN_CLOCK"] = "Abrir Relógio"
L["HIDE_EVENT_TEXT"] = "Ocultar texto do evento"

L["TRAVEL"] = true
L["PORT_OPTIONS"] = "Opções de Teleporte"
L["READY"] = "Pronto"
L["TRAVEL_COOLDOWNS"] = "Recargas de Teleporte"
L["CHANGE_PORT_OPTION"] = "Alterar Opção de Teleporte"

L["REGISTERED_CHARACTERS"] = "Personagens registrados"
L["SHOW_FREE_BAG_SPACE"] = "Mostrar espaço livre na bolsa"
L["SHOW_OTHER_REALMS"] = "Mostrar Outros Servidores"
L["ALWAYS_SHOW_SILVER_COPPER"] = "Sempre mostrar Prata e Bronze"
L["SHORTEN_GOLD"] = "Encurtar Ouro"
L["TOGGLE_BAGS"] = "Mostrar bolsa"
L["SESSION_TOTAL"] = "Total da Sessão"
L["DAILY_TOTAL"] = "Total do Dia"
L["GOLD_ROUNDED_VALUES"] = "Valores arredondados de ouro"

-- Currency
L["SHOW_XP_BAR_BELOW_MAX_LEVEL"] = "Mostrar barra de XP abaixo do nível máximo"
L["CLASS_COLORS_XP_BAR"] = "Usar cores de classe para a barra de XP"
L["SHOW_TOOLTIPS"] = "Mostrar informações"
L["TEXT_ON_RIGHT"] = "Texto à Direita"
L["CURRENCY_SELECT"] = "Seleção de Moeda"
L["FIRST_CURRENCY"] = "Moeda #1"
L["SECOND_CURRENCY"] = "Moeda #2"
L["THIRD_CURRENCY"] = "Moeda #3"
L["RESTED"] = "Descansado"
L["SHOW_MORE_CURRENCIES"] = true -- To Translate
L["MAX_CURRENCIES_SHOWN"] = true -- To Translate
L["ONLY_SHOW_MODULE_ICON"] = true -- To Translate
L["CURRENCY_NUMBER"] = true -- To Translate
L["CURRENCY_SELECTION"] = true -- To Translate
L["SELECT_ALL"] = true -- To Translate
L["UNSELECT_ALL"] = true -- To Translate
L["OPEN_XIV_CURRENCY_OPTIONS"] = true -- To Translate

-- System
L["WORLD_PING"] = "Mostrar Ping Global"
L["ADDONS_NUMBER_TO_SHOW"] = "Número de Addons a Mostrar"
L["ADDONS_IN_TOOLTIP"] = "Addons a Mostrar no Tooltip"
L["SHOW_ALL_ADDONS"] = "Mostrar todos os addons no tooltip com Shift"
L["MEMORY_USAGE"] = "Uso de Memória"
L["GARBAGE_COLLECT"] = "Limpeza de Memória"
L["CLEANED"] = "Limpo"

-- Reputation
L["OPEN_REPUTATION"] = "Open " .. REPUTATION -- To Translate
L["PARAGON_REWARD_AVAILABLE"] = true -- To translate
L["CLASS_COLORS_REPUTATION"] = true -- To translate
L["REPUTATION_COLORS_REPUTATION"] = true -- To translate
L["FLASH_PARAGON_REWARD"] = true -- To translate
L["PROGRESS"] = true -- To translate
L["RANK"] = true -- To translate
L["PARAGON"] = true -- To translate

L["USE_CLASS_COLORS"] = "Usar Cores de Classe"
L["COOLDOWNS"] = "Tempo de Recarga"
L["TOGGLE_PROFESSION_FRAME"] = "Profissões"
L["TOGGLE_PROFESSION_SPELLBOOK"] = "Magias de Profissão"

L["SET_SPECIALIZATION"] = "Trocar Especialização"
L["SET_LOADOUT"] = "Trocar Loadout"
L["SET_LOOT_SPECIALIZATION"] = "Trocar Especialização de Saque"
L["CURRENT_SPECIALIZATION"] = "Especialização Atual"
L["CURRENT_LOOT_SPECIALIZATION"] = "Especialização de Saque Atual"
L["TALENT_MINIMUM_WIDTH"] = "Largura Mínima dos Talentos"
L["OPEN_ARTIFACT"] = "Abrir Artefato"
L["REMAINING"] = "Restante"
L["AVAILABLE_RANKS"] = "Ranks Disponíveis"
L["ARTIFACT_KNOWLEDGE"] = "Conhecimento de Artefato"

L["SHOW_BUTTON_TEXT"] = true -- Needs Translation

-- Travel (Translation needed)
L["HEARTHSTONE"] = "Pedra de Regresso"
L["M_PLUS_TELEPORTS"] =  "Teleportes de M+"
L["ONLY_SHOW_CURRENT_SEASON"] = "Mostrar Temporada Atual"
L["MYTHIC_PLUS_TELEPORTS"] = "Teleportes de Mitica+"
L["HIDE_M_PLUS_TELEPORTS_TEXT"] = true -- Needs Translate
L["SHOW_MYTHIC_PLUS_TELEPORTS"] = "Mostrar Teleportes de Mitica+"
L["USE_RANDOM_HEARTHSTONE"] = "Usar Pedra de Regresso aleatória"
local retrievingData = "Recuperando dados..."
L["RETRIEVING_DATA"] = retrievingData
L["EMPTY_HEARTHSTONES_LIST"] = "Se você vir '" .. retrievingData .. "' na lista abaixo, basta mudar de aba ou reabrir este menu para atualizar os dados."
L["HEARTHSTONES_SELECT"] = "Selecionar Pedra de Regresso"
L["HEARTHSTONES_SELECT_DESC"] = "Selecionar a Pedra de Regresso"
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
L["CURRENT_SEASON"] = "Temporada Atual"

-- Profile Import/Export
L["PROFILE_SHARING"] = "Compartilhamento de perfis"

L["INVALID_IMPORT_STRING"] = "String de importação inválida"
L["FAILED_DECODE_IMPORT_STRING"] = "Falha ao decodificar a string de importação"
L["FAILED_DECOMPRESS_IMPORT_STRING"] = "Falha ao descomprimir a string de importação"
L["FAILED_DESERIALIZE_IMPORT_STRING"] = "Falha ao desserializar a string de importação"
L["INVALID_PROFILE_FORMAT"] = "Formato de perfil inválido"
L["PROFILE_IMPORTED_SUCCESSFULLY_AS"] = "Perfil importado com sucesso como"

L["COPY_EXPORT_STRING"] = "Copie a string de exportação abaixo:"
L["PASTE_IMPORT_STRING"] = "Cole a string de importação abaixo:"
L["IMPORT_EXPORT_PROFILES_DESC"] = "Importe ou exporte seus perfis para compartilhá-los com outros jogadores."
L["PROFILE_IMPORT_EXPORT"] = "Importar/Exportar Perfil"
L["EXPORT_PROFILE"] = "Exportar Perfil"
L["EXPORT_PROFILE_DESC"] = "Exportar as configurações do seu perfil atual"
L["IMPORT_PROFILE"] = "Importar Perfil"
L["IMPORT_PROFILE_DESC"] = "Importar perfil de outro jogador"

-- Changelog
L["DATE_FORMAT"] = true
L["VERSION"] = "Versão"
L["IMPORTANT"] = "Importante"
L["NEW"] = "Novo"
L["IMPROVEMENT"] = "Melhorias"
L["BUGFIX"] = "Correções de bugs"
L["CHANGELOG"] = true

-- Vault Module
L["GREAT_VAULT_DISABLED"] = "The " .. DELVES_GREAT_VAULT_LABEL .. " is currently disabled until the next season starts."
L["MAX_LEVEL_DISCLAIMER"] = "This module will only show when you reach max level."