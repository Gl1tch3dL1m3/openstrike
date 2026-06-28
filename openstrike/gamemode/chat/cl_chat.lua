is_chatting = false
local TERRORISTS_COLOR = Color(233,207,105)
local CTERRORISTS_COLOR = Color(142, 168, 190)
local color_red = Color(255,40,40)
local color_blue = Color(96,96,255)
local color_green = Color(46,192,46)
local label_size_x, label_size_y = GetTextSize("Press TAB to copy a specific player's SteamID!", "DermaDefault")

local tablabelbg = vgui.Create("Panel")
tablabelbg:SetVisible(false)
tablabelbg:SetWide(label_size_x + 19)
tablabelbg:SetTall(label_size_y + 15)
tablabelbg.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, color_black)
end

local tablabel = vgui.Create("DLabel")
tablabel:SetVisible(false)
tablabel:SetWide(500)
tablabel:SetText("Press TAB to copy a specific player's SteamID!")
tablabel:SetColor(Color(255,0,0))

function SelectUserSteamID()
    local playerselector = vgui.Create("DMenu")
    local posx, posy = chat.GetChatBoxPos()
    local scalex, scaley = chat.GetChatBoxSize()
    posy = posy + scaley

    playerselector:SetPos(posx, posy)
    playerselector:SetSize(150, 100)
    playerselector:SetMaxHeight(100)

    for _, option in ipairs(playerselector:GetCanvas():GetChildren()) do
        if IsValid(option) then
            option:Remove()
        end
    end

    for _, ply in ipairs(player.GetAll()) do
        local option = playerselector:AddOption(ply:Nick(), function()
            notification.AddLegacy("Copied user's SteamID to clipboard!", NOTIFY_CLEANUP, 5)
            SetClipboardText(ply:SteamID64())
        end)
    end

    playerselector:MakePopup()
end

hook.Add("OnChatTab", "OpenSteamIDSelector", function()
    SelectUserSteamID()
end)

hook.Add("StartChat", "ShowTABInstruction", function()
    is_chatting = true
    local posx, posy = chat.GetChatBoxPos()
    tablabelbg:SetPos(posx, posy - 30)
    tablabelbg:SetVisible(true)
    tablabel:SetPos(posx + 10, posy - 25)
    tablabel:SetVisible(true)
end)

hook.Add("FinishChat", "HideTABInstruction", function()
    is_chatting = false
    tablabel:SetVisible(false)
    tablabelbg:SetVisible(false)
end)

hook.Add("OnPlayerChat", "ReplaceChats", function( ply, text, is_team, is_dead )
    if not IsValid(ply) then return false end

    local tag = {}
    local team_color = (ply:Team() == 1) and CTERRORISTS_COLOR or TERRORISTS_COLOR

    if ply:IsUserGroup("owner") then
        tag[1] = color_red
        tag[2] = "[OWNER] "
    elseif ply:IsUserGroup("admin") then
        tag[1] = color_blue
        tag[2] = "[ADMIN] "
    elseif ply:IsUserGroup("helper") then
        tag[1] = color_green
        tag[2] = "[HELPER] "
    end

    chat.AddText(
        tag[1],
        tag[2],
        team_color,
        ply:Name() .. ": ",
        (is_team) and team_color or color_white,
        text
    )

    return true
end)

net.Receive("ServerChat", function()
    local msg = net.ReadString()

    chat.AddText("[SERVER] " .. msg)
end)