local is_linux = system.IsLinux()

surface.CreateFont("TahomaFix", {
    -- font system on Linux is different, so we must use the filename of the font
    -- https://wiki.facepunch.com/gmod/Finding_the_Font_Name#findthefontsname
    font = (is_linux) and "os_tahoma.ttf" or "Tahoma",
    size = (is_linux) and 25 or 24,
    antialias = true
})

surface.CreateFont("CSSKillIcons", {
    font = (is_linux) and "csd.ttf" or "csd",
    size = (is_linux) and 30 or 42,
    additive = true,
    antialiasing = true
})

surface.CreateFont("KillText", {
    font = (is_linux) and "os_tahoma.ttf" or "DermaDefault",
    size = 15,
    weight = 600
})

surface.CreateFont("3D2DTitle", {
    font = "TahomaFix",
    size = 44,
    antialias = true
})

surface.CreateFont("3D2DDesc", {
    font = "TahomaFix",
    size = (is_linux) and 25 or 24,
    antialias = true
})

function GetTextSize(txt, font)
    surface.SetFont((font == nil) and "TahomaFix" or font)
    local tw,th = surface.GetTextSize(txt)
    return tw, th
end

include("shared.lua")
include("cl_events.lua")
include("error_msg/cl_err.lua")
include("chat/cl_chat.lua")
include("gui/intermission.lua")
include("gui/nameplates.lua")
include("gui/godmode.lua")
include("gui/matchstats.lua")
include("gui/killlog.lua")
include("gui/scoreboard.lua")
include("gui/endgame.lua")
include("gui/info_and_menu.lua")
include("gui/teamshootnotice.lua")
include("weapon_manager/override_weapons.lua")
include("weapon_manager/cl_weaponmanager.lua")
include("weapon_manager/cl_weaponselectmenu.lua")
include("commands/cl_commands.lua")

hook.Add("HUDShouldDraw", "Hide", function(name)
	if name == "CHudNameDump" or name == "CHudWeaponSelection" or (name == "CHudHealth" and GetGlobal2Var("game_state") ~= 3) then
		return false
	end
end)

-- Disable pointing crosshair player info
hook.Add("HUDDrawTargetID", "StopTargetID", function()
    return false
end)

hook.Add("PlayerBindPress", "BindKeys", function(ply, bind, pressed, code)
    if string.find(bind, "+zoom") or (GetGlobal2Var("game_state") == 4 and string.find(bind, "score")) then
        return true
    end
end)