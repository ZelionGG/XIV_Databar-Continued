local AddOnName, Engine = ...;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddOnName, "ptBR", false, false);
if not L then return end

L['Modules'] = "Módulos";
L['Left-Click'] = "Clique Esquerdo";
L['Right-Click'] = "Clique Direito";
L['k'] = true; -- short for 1000
L['M'] = true; -- short for 1000000
L['B'] = true; -- short for 1000000000
L['L'] = true; -- For the local ping
L['W'] = true; -- For the world ping

-- General
L["Positioning"] = "Posicionamento";
L['Bar Position'] = "Posição da Barra";
L['Top'] = "Topo";
L['Bottom'] = "Inferior";
L['Bar Color'] = "Cor da Barra";
L['Use Class Color for Bar'] = "Cor da classe na barra";
L["Miscellaneous"] = "Outros";
L['Hide Bar in combat'] = "Ocultar barra em combate";
L["Hide when in flight"] = "Ocultar durante voo";
L['Bar Padding'] = "Preenchimento da Barra";
L['Module Spacing'] = "Espaçamento entre Módulos";
L['Bar Margin'] = "Margem da Barra";
L["Leftmost and rightmost margin of the bar modules"] = "Margem esquerda e direita dos módulos da barra";
L['Hide order hall bar'] = "Ocultar barra dos Salões de Classe";
L['Use ElvUI for tooltips'] = "Usar ElvUI para dicas";
L["Lock Bar"] = "Travar Barra";
L["Lock the bar in place"] = "Travar barra";
L["Lock the bar to prevent dragging"] = "Impedir movimentação";
L["Makes the bar span the entire screen width"] = "Ocupar toda a largura da tela";
L["Position the bar at the top or bottom of the screen"] = "Posicionar a barra no topo ou embaixo da tela";
L["X Offset"] = "Deslocamento X";
L["Y Offset"] = "Deslocamento Y";
L["Horizontal position of the bar"] = "Posição horizontal da barra";
L["Vertical position of the bar"] = "Posição vertical da barra";
L["Behavior"] = "Comportamento";
L["Spacing"] = "Espaçamento";

-- Positioning Options
L['Positioning Options'] = "Configurações de Posicionamento";
L['Horizontal Position'] = "Posição Horizontal";
L['Bar Width'] = "Largura da Barra";
L['Left'] = "Esquerda";
L['Center'] = "Centro";
L['Right'] = "Direita";

-- Media
L['Font'] = "Fonte";
L['Small Font Size'] = "Tamanho da Fonte Pequena";
L['Text Style'] = "Estilo do Texto";

-- Text Colors
L["Colors"] = "Cores";
L['Text Colors'] = "Cores do Texto";
L['Normal'] = "Normal";
L['Inactive'] = "Inativo";
L["Use Class Color for Text"] = "Usar cor da classe para o texto";
L["Only the alpha can be set with the color picker"] = "Transparência apenas no seletor de cores";
L['Use Class Colors for Hover'] = "Usar cor da classe no mouse sobre";
L['Hover'] = "Mouse sobre";

-------------------- MODULES ---------------------------

L['Micromenu'] = true;
L['Show Social Tooltips'] = "Mostrar informações da lista de amigos";
L['Main Menu Icon Right Spacing'] = "Espaçamento à Direita do Ícone do Menu Principal";
L['Icon Spacing'] = "Espaçamento dos Ícones";
L["Hide BNet App Friends"] = "Ocultar Amigos da BNet";
L['Open Guild Page'] = "Abrir Página da Guilda";
L['No Tag'] = true;
L['Whisper BNet'] = "Sussurrar via BNet";
L['Whisper Character'] = "Sussurrar para o Personagem";
L['Hide Social Text'] = "Ocultar Texto Social";
L['Social Text Offset'] = "Deslocamento do Texto Social";
L["GMOTD in Tooltip"] = "Mensagem do Dia na Dica de Tela";
L["Modifier for friend invite"] = "Modificador para Convite de Amigo";

L['Show/Hide Buttons'] = "Mostrar/Ocultar Botões";
L['Show Menu Button'] = "Mostrar Botão de Menu";
L['Show Chat Button'] = "Mostrar Botão de Chat";
L['Show Guild Button'] = "Mostrar Botão da Guilda";
L['Show Social Button'] = "Mostrar Botão Social";
L['Show Character Button'] = "Mostrar Botão do Personagem";
L['Show Spellbook Button'] = "Mostrar Botão de Magias";
L['Show Talents Button'] = "Mostrar Botão de Talentos";
L['Show Achievements Button'] = "Mostrar Botão de Conquistas";
L['Show Quests Button'] = "Mostrar Botão de Missões";
L['Show LFG Button'] = "Mostrar Botão de LFG";
L['Show Journal Button'] = "Mostrar Botão do Diário";
L['Show PVP Button'] = "Mostrar Botão de PVP";
L['Show Pets Button'] = "Mostrar Botão de Mascotes";
L['Show Shop Button'] = "Mostrar Botão da Loja";
L['Show Help Button'] = "Mostrar Botão de Ajuda";
L['Show Housing Button'] = true; -- TODO: translate
L['No Info'] = "Sem Informação";
L['Classic'] = true;
L['Alliance'] = "Aliança";
L['Horde'] = "Horda";

L['Durability Warning Threshold'] = "Aviso de Durabilidade";
L['Show Item Level'] = "Mostrar item level";
L['Show Coordinates'] = "Mostrar coordenadas";

L['Master Volume'] = "Volume geral";
L["Volume step"] = true;

L['Time Format'] = "Formato da Hora";
L['Use Server Time'] = "Usar hora do Servidor";
L['New Event!'] = "Novo Evento!";
L['Local Time'] = "Horário Local";
L['Realm Time'] = "Horário do Servidor";
L['Open Calendar'] = "Abrir Calendário";
L['Open Clock'] = "Abrir Relógio";
L['Hide Event Text'] = "Ocultar texto do evento";

L['Travel'] = true;
L['Port Options'] = "Opções de Teleporte";
L['Ready'] = "Pronto";
L['Travel Cooldowns'] = "Recargas de Teleporte";
L['Change Port Option'] = "Alterar Opção de Teleporte";

L["Registered characters"] = "Personagens registrados";
L['Show Free Bag Space'] = "Mostrar espaço livre na bolsa";
L['Show Other Realms'] = "Mostrar Outros Servidores";
L['Always Show Silver and Copper'] = "Sempre mostrar Prata e Bronze";
L['Shorten Gold'] = "Encurtar Ouro";
L['Toggle Bags'] = "Mostrar bolsa";
L['Session Total'] = "Total da Sessão";
L['Daily Total'] = "Total do Dia";
L['Gold rounded values'] = "Valores arredondados de ouro";

L['Show XP Bar Below Max Level'] = "Mostrar barra de XP abaixo do nível máximo";
L['Use Class Colors for XP Bar'] = "Usar cores de classe para a barra de XP";
L['Show Tooltips'] = "Mostrar informações";
L['Text on Right'] = "Texto à Direita";
L['Currency Select'] = "Seleção de Moeda";
L['First Currency'] = "Moeda #1";
L['Second Currency'] = "Moeda #2";
L['Third Currency'] = "Moeda #3";
L['Rested'] = "Descansado";

L['Show World Ping'] = "Mostrar Ping Global";
L['Number of Addons To Show'] = "Número de Addons a Mostrar";
L['Addons to Show in Tooltip'] = "Addons a Mostrar no Tooltip";
L['Show All Addons in Tooltip with Shift'] = "Mostrar todos os addons no tooltip com Shift";
L['Memory Usage'] = "Uso de Memória";
L['Garbage Collect'] = "Limpeza de Memória";
L['Cleaned'] = "Limpo";

L['Use Class Colors'] = "Usar Cores de Classe";
L['Cooldowns'] = "Tempo de Recarga";
L['Toggle Profession Frame'] = "Profissões";
L['Toggle Profession Spellbook'] = "Magias de Profissão";

L['Set Specialization'] = "Trocar Especialização";
L['Set Loadout'] = "Trocar Loadout";
L['Set Loot Specialization'] = "Trocar Especialização de Saque";
L['Current Specialization'] = "Especialização Atual";
L['Current Loot Specialization'] = "Especialização de Saque Atual";
L['Talent Minimum Width'] = "Largura Mínima dos Talentos";
L['Open Artifact'] = "Abrir Artefato";
L['Remaining'] = "Restante";
L['Available Ranks'] = "Ranks Disponíveis";
L['Artifact Knowledge'] = "Conhecimento de Artefato";

-- Travel (Translation needed)
L['Hearthstone'] = "Pedra de Regresso";
L['M+ Teleports'] =  "Teleportes de M+";
L['Only show current season'] = "Mostrar Temporada Atual";
L["Mythic+ Teleports"] = "Teleportes de Mitica+";
L['Show Mythic+ Teleports'] = "Mostrar Teleportes de Mitica+";
L['Use Random Hearthstone'] = "Usar Pedra de Regresso aleatória";
local retrievingData = "Recuperando dados..."
L['Retrieving data'] = retrievingData;
L['Empty Hearthstones List'] = "Se você vir '" .. retrievingData .. "' na lista abaixo, basta mudar de aba ou reabrir este menu para atualizar os dados."
L['Hearthstones Select'] = "Selecionar Pedra de Regresso";
L['Hearthstones Select Desc'] = "Selecionar a Pedra de Regresso";

L["Classic"] = true;
L["Burning Crusade"] = true;
L["Wrath of the Lich King"] = true;
L["Cataclysm"] = true;
L["Mists of Pandaria"] = true;
L["Warlords of Draenor"] = true;
L["Legion"] = true;
L["Battle for Azeroth"] = true;
L["Shadowlands"] = true;
L["Dragonflight"] = true;
L["The War Within"] = true;
L["Current season"] = "Temporada Atual";

-- Profile Import/Export
L["Profile Sharing"] = "Compartilhamento de perfis";

L["Invalid import string"] = "String de importação inválida";
L["Failed to decode import string"] = "Falha ao decodificar a string de importação";
L["Failed to decompress import string"] = "Falha ao descomprimir a string de importação";
L["Failed to deserialize import string"] = "Falha ao desserializar a string de importação";
L["Invalid profile format"] = "Formato de perfil inválido";
L["Profile imported successfully as"] = "Perfil importado com sucesso como";

L["Copy the export string below:"] = "Copie a string de exportação abaixo:";
L["Paste the import string below:"] = "Cole a string de importação abaixo:";
L["Import or export your profiles to share them with other players."] = "Importe ou exporte seus perfis para compartilhá-los com outros jogadores.";
L["Profile Import/Export"] = "Importar/Exportar Perfil";
L["Export Profile"] = "Exportar Perfil";
L["Export your current profile settings"] = "Exportar as configurações do seu perfil atual";
L["Import Profile"] = "Importar Perfil";
L["Import a profile from another player"] = "Importar perfil de outro jogador";

-- Changelog
L["%month%-%day%-%year%"] = true;
L["Version"] = "Versão";
L["Important"] = "Importante";
L["New"] = "Novo";
L["Improvment"] = "Melhorias";
L["Changelog"] = true;
