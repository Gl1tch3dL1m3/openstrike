local c1 = Color(90,90,90)
local c2 = Color(110,110,110)

hook.Add("HUDPaint", "DrawARoundedBox", function()
    local timer = GetGlobal2Var("timer")
    local game_state = GetGlobal2Var("game_state")
    local txt

    if game_state == 0 then
        -- timer box
        if timer ~= 0 and CurTime() < timer then
            local delta = timer - CurTime()
            txt = string.format("%02d:%02d", math.floor(delta / 60), math.floor(delta % 60))
            w = GetTextSize(txt)+30
            draw.RoundedBox(20, ScrW() / 2 - w / 2, 20, w, 50, c1)
            draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 40, color_white, TEXT_ALIGN_CENTER)

            txt = "INTERMISSION"
            w = GetTextSize(txt)+30
            draw.RoundedBox(20, ScrW() / 2 - w / 2, -15, w, 50, c2)
            draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 5, color_white, TEXT_ALIGN_CENTER)

        elseif CurTime() >= timer then
            game_state = 1
        end
    end
    
    if game_state == 1 then
        txt = "Starting soon..."
        w = GetTextSize(txt)+30
        draw.RoundedBox(20, ScrW() / 2 - w / 2, -15, w, 50, c2)
        draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 5, color_white, TEXT_ALIGN_CENTER)

    elseif game_state == -1 then
        txt = "At least 2 players required to start..."
        w = GetTextSize(txt)+30
        draw.RoundedBox(20, ScrW() / 2 - w / 2, -15, w, 50, c2)
        draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 5, color_white, TEXT_ALIGN_CENTER)

    elseif game_state == 2 then
        txt = "Waiting for players to connect..."
        w = GetTextSize(txt)+30
        draw.RoundedBox(20, ScrW() / 2 - w / 2, -15, w, 50, c2)
        draw.SimpleText(txt, "TahomaFix", ScrW() / 2, 5, color_white, TEXT_ALIGN_CENTER)
    end
end)
