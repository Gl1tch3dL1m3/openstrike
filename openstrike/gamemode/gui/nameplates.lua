local alpha_black = Color(0,0,0,100)
local darker_white = Color(230,230,230)
local TERRORISTS_COLOR = Color(107, 98, 62)
local CTERRORISTS_COLOR = Color(83, 107, 128)

surface.CreateFont("PlayerNameplates", {
    font = (system.IsLinux()) and "tahoma.ttf" or "Tahoma",
    size = 120,
    antialias = true
})

hook.Add("PostDrawTranslucentRenderables", "PlayerNameTagsDepthFix", function()
    local lp = LocalPlayer()

    for k, ply in ipairs(GetRealPlayers()) do
        if not IsValid(ply) then continue
        elseif ply:Team() ~= lp:Team() then continue
        elseif not ply:Alive() then continue
        elseif ply == lp then continue
        elseif ply:GetPos():Distance(EyePos()) > 512 then continue
        end

        local is_lobby = GetGlobal2Var("game_state")
        local team = ply:Team()
        local nameplate_color = color_black

        if is_lobby == 0 or is_lobby == 1 then
            nameplate_color = alpha_black
        elseif team == 0 then
            nameplate_color = TERRORISTS_COLOR
        elseif team == 1 then
            nameplate_color = CTERRORISTS_COLOR
        end

        local pos = ply:GetPos() + ply:GetUp() * (ply:OBBMaxs().z + (ply:Crouching() and 30 or 10))
        local eyeang = lp:EyeAngles()
        local ang = Angle(0, eyeang.y - 90, 90)
        
        render.OverrideDepthEnable(true, false)
        render.SuppressEngineLighting(true)

        cam.Start3D2D(pos, ang, 0.05)
            surface.SetFont("PlayerNameplates")
            local tW, tH = surface.GetTextSize(ply:Nick())

            local padX = 25
            local padY = 5

            draw.RoundedBox(30, -tW / 2 - padX, padY, tW + padX * 2, tH + padY * 2 + 5, nameplate_color)
            draw.SimpleText(ply:Nick(), "PlayerNameplates", 0, 15, darker_white, TEXT_ALIGN_CENTER)
        cam.End3D2D()
        
        render.OverrideDepthEnable(false, false)
        render.SuppressEngineLighting(false)
    end
end)
