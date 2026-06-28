local txt = "You are hurting your teammate!"
local size = GetTextSize(txt)
local lbl = vgui.Create("DLabel")
lbl:SetColor(Color(255,0,0))
lbl:SetText(txt)
lbl:SetWide(400)
lbl:SetTall(50)
lbl:SetFont("TahomaFix")
lbl:SetVisible(false)

hook.Add("CLPlayerTakeDamage", "ShowTeamShootLabel", function(att, inf, vic)
    if not (att:IsPlayer() and vic:IsPlayer()) then return
    elseif att ~= LocalPlayer() then return
    elseif vic:Team() ~= att:Team() then return end

    print("CLPlayerTakeDamage", att, inf, vic)
    lbl:SetPos(ScrW() / 2 - GetTextSize(txt) / 2, ScrH() / 2 + 100)
    lbl:SetVisible(true)

    timer.Remove("teamshootnotice")
    timer.Create("teamshootnotice", 5, 1, function()
        lbl:SetVisible(false)
    end)
end)