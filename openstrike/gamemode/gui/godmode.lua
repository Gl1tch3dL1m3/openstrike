hook.Add("InitPostEntity", "InitGodMode", function()
    local ply = LocalPlayer()
    local _timer

    hook.Add("RenderScreenspaceEffects", "GodModeEffect", function()
        local game_state = GetGlobal2Var("game_state")

        if game_state == 3 then
            DrawColorModify({
                [ "$pp_colour_brightness" ] = 0,
                [ "$pp_colour_contrast" ] = 1,
                [ "$pp_colour_colour" ] = (ply:HasGodMode()) and 0 or 1
            })
        end
    end)

    hook.Add("HUDPaint", "GodModeTimer", function()
        local game_state = GetGlobal2Var("game_state")

        if game_state == 3 and ply:HasGodMode() then
            if not _timer then
                _timer = CurTime() + 14
            end

            local txt = "Spawn protection will disable in: " .. tostring(math.floor(_timer - CurTime()))
            local w, h = GetTextSize(txt)
            draw.RoundedBox(0, ScrW() / 2 - w / 2 - 5, 150 - 5, w + 10, h + 10, color_black)
            draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 150, color_white, TEXT_ALIGN_CENTER)
        else
            _timer = nil
        end
    end)
end)