-- 3627569366 collection base (used on server)
-- 3653963102 collection for maps
maps = {
    "gm_firing_range", -- 3624574621
    "cs_office_preincident", -- 3674887811
    "gm_chateau_extended", -- 3636489268
    "cs_jungle", -- 1165152208
    "gm_hl2_dust2", -- 2114475699
    "cs_cs16_assault", -- 357662134
    "de_tuscan", -- 1807067202
    "cs_downed_css_b2", -- 3237087610
    "de_mirage_css", -- 2041646618
    "de_airstrip_css" -- 2407547147
}

local current_map = game.GetMap()

if current_map == maps[1] then
    resource.AddWorkshop("3624574621")
elseif current_map == maps[2] then
    resource.AddWorkshop("3674887811")
elseif current_map == maps[3] then
    resource.AddWorkshop("3636489268")
elseif current_map == maps[4] then
    resource.AddWorkshop("1165152208")
elseif current_map == maps[5] then
    resource.AddWorkshop("2114475699")
elseif current_map == maps[6] then
    resource.AddWorkshop("357662134")
elseif current_map == maps[7] then
    resource.AddWorkshop("1807067202")
elseif current_map == maps[8] then
    resource.AddWorkshop("3237087610")
elseif current_map == maps[9] then
    resource.AddWorkshop("2041646618")
elseif current_map == maps[10] then
    resource.AddWorkshop("2407547147")
end

maps_use_default_spawns = {
    "gm_firing_range",
    "cs_office_preincident"
}

sql.Query("CREATE TABLE IF NOT EXISTS reports(reporter INTEGER NOT NULL, target INTEGER NOT NULL, reason TEXT NOT NULL, date TEXT NOT NULL, game_state INTEGER NOT NULL);")
sql.Query("CREATE TABLE IF NOT EXISTS actions(moderator TEXT NOT NULL, player TEXT NOT NULL, action TEXT NOT NULL, reason TEXT NOT NULL);")

util.AddNetworkString("SetWeapon")
util.AddNetworkString("SelectWeapon")
util.AddNetworkString("ErrorMessage")
util.AddNetworkString("ClientCommand")
util.AddNetworkString("ServerChat")
util.AddNetworkString("ReportPlayer")
util.AddNetworkString("PlayerDeath")
util.AddNetworkString("PlayerTakeDamage")

-- gamemode for client (icon and logo only)
resource.AddWorkshop("3654812588")
-- CSS Grenades https://steamcommunity.com/sharedfiles/filedetails/?id=547635114
resource.AddWorkshop("547635114")
-- CS:GO Knives https://steamcommunity.com/sharedfiles/filedetails/?id=2185719675
resource.AddWorkshop("2185719675")
-- CS:GO Weapons https://steamcommunity.com/sharedfiles/filedetails/?id=2180833718
resource.AddWorkshop("2180833718")

resource.AddFile("materials/weapons/icons/os_weapon.png")
resource.AddFile("materials/weapons/icons/os_pistol.png")
resource.AddFile("materials/weapons/icons/os_knife.png")
resource.AddFile("materials/weapons/icons/os_grenade.png")
resource.AddFile("materials/weapons/icons/os_medkit.png")
resource.AddFile("materials/vgui/os_badping.png")
resource.AddFile("materials/vgui/os_highping.png")
resource.AddFile("materials/vgui/os_lowping.png")
resource.AddFile("materials/vgui/os_medping.png")
resource.AddFile("materials/vgui/os_report.png")
resource.AddFile("materials/vgui/os_volume.png")
resource.AddFile("materials/vgui/os_volumeoff.png")
resource.AddFile("materials/buttons/os_discord.png")
resource.AddFile("materials/buttons/os_addon.png")
resource.AddFile("resource/fonts/os_tahoma.ttf")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_events.lua")
AddCSLuaFile("error_msg/cl_err.lua")
AddCSLuaFile("gui/intermission.lua")
AddCSLuaFile("gui/nameplates.lua")
AddCSLuaFile("gui/godmode.lua")
AddCSLuaFile("gui/matchstats.lua")
AddCSLuaFile("gui/killlog.lua")
AddCSLuaFile("gui/endgame.lua")
AddCSLuaFile("gui/scoreboard.lua")
AddCSLuaFile("gui/info_and_menu.lua")
AddCSLuaFile("gui/teamshootnotice.lua")
AddCSLuaFile("chat/cl_chat.lua")
AddCSLuaFile("weapon_manager/cl_weaponselectmenu.lua")
AddCSLuaFile("weapon_manager/cl_weaponmanager.lua")
AddCSLuaFile("commands/cl_commands.lua")

include("shared.lua")
include("variables.lua")
include("error_msg/sv_err.lua")
include("chat/sv_chat.lua")
include("commands/sv_commands.lua")
include("commands/sv_reportmanager.lua")
include("weapon_manager/override_weapons.lua") -- shared file
include("weapon_manager/sv_weaponmanager.lua")
include("match_manager/sv_match_manager.lua")
include("game_manager/sv_game_manager.lua")
include("spawnpoints/sv_spawnpoints.lua")

-- NA KAŽDEJ MAPE MUSÍ BYŤ MINIMÁLNE 18 SPAWNPOINTOV (nerátajú sa team spawny)

-- AKO SPRAVIŤ SPECTATE MODE (asi nevyužijem ale človek nikdy nevie :p)
-- player:KillSilent()
-- player:Spectate(OBS_MODE_IN_EYE)
-- player:SpectateEntity(ply)
-- PRESUNÚŤ / PREROBIŤ VC
-- VYTVORIŤ VOTING SYSTEM MAPY
-- HONORABLE MENTIONS NA KONCI HRY (derma panel ešte pred zobrazením scoreboardu s časovačom)
-- PRIDAŤ MOLOTOV