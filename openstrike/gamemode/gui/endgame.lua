hook.Add("InitPostEntity", "Endgame", function()
    timer.Create("WaitForEndgame", 0.1, 0, function()
        if GetGlobal2Var("game_state") == 4 then
            RunConsoleCommand("+score")

            hook.Add("HUDPaint", "DrawEndgameTimerHUDPaint", function()
                local txt = "You will be spawned to lobby in: " .. tostring(math.floor(GetGlobal2Var("timer") - CurTime()))
                local w, h = GetTextSize(txt)
                draw.RoundedBox(0, ScrW() / 2 - w / 2 - 5, 130 - 5, w + 10, h + 10, color_black)
                draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 130, color_white, TEXT_ALIGN_CENTER)
            end)

            timer.Remove("WaitForEndgame")
        end
    end)
end)