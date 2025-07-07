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
L["Lock the bar in place"] = "Travar a barra no lugar";
L["Lock the bar to prevent dragging"] = "Travar para impedir movimentação";
L["Makes the bar span the entire screen width"] = "Ocupar toda a largura da tela";
L["Position the bar at the top or bottom of the screen"] = "Posicionar a barra no topo ou embaixo da tela";
L["X Offset"] = "Deslocamento X";
L["Y Offset"] = "Deslocamento Y";
L["Horizontal position of the bar"] = "Posição horizontal da barra";
L["Vertical position of the bar"] = "Posição vertical da barra";
L["Behavior"] = "Comportamento";
L["Spacing"] = "Espaçamento";

-- Positioning Options
L['Positioning Options'] = "Positions Einstellungen";
L['Horizontal Position'] = "Horizontale Position";
L['Bar Width'] = "Leistenbreite";
L['Left'] = "Links";
L['Center'] = "Mitte";
L['Right'] = "Rechts";

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
L['Show Social Tooltips'] = true;
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
L['No Info'] = "Sem Informação";
L['Classic'] = true;
L['Alliance'] = "Aliança";
L['Horde'] = "Horda";

L['Durability Warning Threshold'] = "Aviso de Durabilidade";
L['Show Item Level'] = "Mostrar item level";
L['Show Coordinates'] = "Mostrar coordenadas";

L['Master Volume'] = "Haupt-Lautstärke";
L["Volume step"] = "Lautstärken Schritte";

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
L['Ready'] = true;
L['Travel Cooldowns'] = true;
L['Change Port Option'] = "Teleport Einstellungen ändern";

L["Registered characters"] = true;
L['Show Free Bag Space'] = true;
L['Show Other Realms'] = true;
L['Always Show Silver and Copper'] = "Silber und Kupfer immer anzeigen";
L['Shorten Gold'] = "Gold abkürzen";
L['Toggle Bags'] = "Taschen anzeigen";
L['Session Total'] = "Sitzung total";
L['Daily Total'] = "Heute total";
L['Gold rounded values'] = "Gold runden";

L['Show XP Bar Below Max Level'] = "Erfahrungsleiste unter Levelcap anzeigen";
L['Use Class Colors for XP Bar'] = "Klassenfarbe für Erfahrungsleiste benutzen";
L['Show Tooltips'] = "Tooltips anzeigen";
L['Text on Right'] = "Text auf der rechten Seite";
L['Currency Select'] = "Währung auswählen";
L['First Currency'] = "Währung #1";
L['Second Currency'] = "Währung #2";
L['Third Currency'] = "Währung #3";
L['Rested'] = "Ausgeruht";

L['Show World Ping'] = "Welt-Ping anzeigen";
L['Number of Addons To Show'] = "Maximale Anzahl für Addon Anzeige";
L['Addons to Show in Tooltip'] = "Addons die im Tooltip angezeigt werden";
L['Show All Addons in Tooltip with Shift'] = "Alle Addons im Tooltip anzeigen via Shift";
L['Memory Usage'] = "Speichernutzung";
L['Garbage Collect'] = "Speicher säubern";
L['Cleaned'] = "Gesäubert";

L['Use Class Colors'] = "Klassenfarben benutzen";
L['Cooldowns'] = true;
L['Toggle Profession Frame'] = 'Berufsfenster anzeigen';
L['Toggle Profession Spellbook'] = 'Zauberbuch für Berufe anzeigen';

L['Set Specialization'] = "Spezialisierung auswählen";
L['Set Loadout'] = "Konfiguration auswählen";
L['Set Loot Specialization'] = "Beute Spezialisierung auswählen";
L['Current Specialization'] = "Aktuelle Spezialisierung";
L['Current Loot Specialization'] = "Aktuelle Beute Spezialisierung";
L['Talent Minimum Width'] = "Minimale Breite für Talente";
L['Open Artifact'] = "Artefakt öffen";
L['Remaining'] = "Verbleibend";
L['Available Ranks'] = "Verfügbare Ränge";
L['Artifact Knowledge'] = "Artefaktwissen";

-- Travel (Translation needed)
L['Hearthstone'] = true;
L['M+ Teleports'] = true;
L['Only show current season'] = true;
L["Mythic+ Teleports"] = true;
L['Show Mythic+ Teleports'] = true;
L['Use Random Hearthstone'] = true;
L['Empty Hearthstones List'] = true;
L['Hearthstones Select'] = true;
L['Hearthstones Select Desc'] = true;

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
L["Profile Sharing"] = true;

L["Invalid import string"] = true;
L["Failed to decode import string"] = true;
L["Failed to decompress import string"] = true;
L["Failed to deserialize import string"] = true;
L["Invalid profile format"] = true;
L["Profile imported successfully as"] = true;

L["Copy the export string below:"] = true;
L["Paste the import string below:"] = true;
L["Import or export your profiles to share them with other players."] = true;
L["Profile Import/Export"] = "Importar/Exportar Perfil";
L["Export Profile"] = "Exportar Perfil";
L["Export your current profile settings"] = true;
L["Import Profile"] = "Importar Perfil";
L["Import a profile from another player"] = true;

-- Changelog
L["%month%-%day%-%year%"] = true;
L["Version"] = true;
L["Important"] = "Importante";
L["New"] = "Novo";
L["Improvment"] = "Melhorias";
L["Changelog"] = true;
