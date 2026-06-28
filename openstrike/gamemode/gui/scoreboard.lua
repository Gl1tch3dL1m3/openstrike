local TERRORISTS_COLOR = Color(255, 204, 93)
local CTERRORISTS_COLOR = Color(113, 145, 173)
local color_red = Color(255,0,0)
local color_lightred = Color(255,110,110)
local color_yellow = Color(196,166,0)
local color_green = Color(0,190,0)
local color_light_yellow = Color(255,241,203)

hook.Add("InitPostEntity", "InitScoreboard", function()
    -- The main scoreboard panel
    local SCOREBOARD = vgui.Create("DPanel")
    SCOREBOARD:SetSize(900, 400)
    SCOREBOARD:SetVisible(false)
    SCOREBOARD:MakePopup()

    local is_teams = true
    local ts_scroll_panel
    local cts_scroll_panel
    local scroll_panel

    if GetGlobal2Var("game_state") >= 2 then
        SCOREBOARD:SetBackgroundColor(Color(0, 0, 0, 0))

        local ts_panel = vgui.Create("DPanel", SCOREBOARD)
        ts_panel:SetSize(450, 400)
        ts_panel:SetBackgroundColor(TERRORISTS_COLOR)

        local cts_panel = vgui.Create("DPanel", SCOREBOARD)
        cts_panel:SetSize(450, 400)
        cts_panel:SetPos(450, 0)
        cts_panel:SetBackgroundColor(CTERRORISTS_COLOR)

        local ts_white_panel = vgui.Create("DPanel", ts_panel)
        ts_white_panel:Dock(FILL)
        ts_white_panel:DockMargin(10,10,10,10)

        local cts_white_panel = vgui.Create("DPanel", cts_panel)
        cts_white_panel:Dock(FILL)
        cts_white_panel:DockMargin(10,10,10,10)

        ts_scroll_panel = vgui.Create("DScrollPanel", ts_white_panel)
        ts_scroll_panel:Dock(FILL)
        cts_scroll_panel = vgui.Create("DScrollPanel", cts_white_panel)
        cts_scroll_panel:Dock(FILL)

    else
        is_teams = false
        SCOREBOARD:SetBackgroundColor(Color(105,105,105))
        
        local white_panel = vgui.Create("DPanel", SCOREBOARD)
        white_panel:Dock(FILL)
        white_panel:DockMargin(10,10,10,10)

        scroll_panel = vgui.Create("DScrollPanel", white_panel)
        scroll_panel:Dock(FILL)
    end

    local function MakePlayer(ply, scroll)
        local ply_panel = scroll:Add("DPanel")
        local TAB_TALL = 42

        ply_panel:Dock(TOP)
        ply_panel:SetTall(TAB_TALL)
        ply_panel:SetBackgroundColor(color_light_yellow)

        local avatar = vgui.Create("AvatarImage", ply_panel)
        avatar:SetSize(32, 32)
        avatar:SetPos(5, 5)
        avatar:SetPlayer(ply, 32)

        local nick = vgui.Create("DLabel", ply_panel)
        local plynick = ply:Nick()
        local w, h = GetTextSize(plynick)
        
        nick:SetFont("TahomaFix")
        nick:SetWide(235)
        nick:SetColor(color_black)
        nick:SetPos(50, (TAB_TALL - h) / 2)
        nick:SetText(plynick)

        if LocalPlayer() ~= ply then
            ply_panel:SetBackgroundColor(color_gray)

            local reportbtn = vgui.Create("DImageButton", ply_panel)
            reportbtn:SetSize(32, 42)
            reportbtn:SetMaterial(Material("vgui/os_report.png"))
            reportbtn:Dock(RIGHT)
            reportbtn:DockMargin(9, 0, 6, 0)
            reportbtn:SetTooltip("Report this player.")
            reportbtn.DoClick = function()
                local frame = vgui.Create("DFrame")
                frame:SetSize(400, 170)
                frame:SetDraggable(false)
                frame:Center()
                frame:MakePopup()
                frame:SetTitle("Report Player")
                frame.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, color_white)
                    draw.RoundedBox(0, 3, 3, w-6, h-6, color_red)

                    draw.DrawText("Please type in the reason for reporting\n" .. plynick .. "!", "Default", w/2, 40, color_white, TEXT_ALIGN_CENTER)
                end

                local reasonfield = vgui.Create("DTextEntry", frame)
                reasonfield:SetPlaceholderText("Wallhack, fly, aimbot, noclip, bad behavior, etc.")
                reasonfield:SetPos(15, 75)
                reasonfield:SetSize(368, 30)

                local sendbtn = vgui.Create("DButton", frame)
                sendbtn:SetSize(80, 30)
                sendbtn:SetPos(160, 120)
                sendbtn:SetText("Report")
                sendbtn.Paint = function(self, w, h)
                    draw.RoundedBox(50, 0, 0, w, h, color_lightred)
                end
                sendbtn.DoClick = function()
                    local reason = reasonfield:GetText()

                    if reason == "" then return
                    
                    elseif IsValid(frame) then
                        frame:Close()
                    end

                    net.Start("ReportPlayer")
                        net.WritePlayer(ply)
                        net.WriteString(reason)
                    net.SendToServer()
                end
            end

            local volumeon = Material("vgui/os_volume.png")
            local volumeoff = Material("vgui/os_volumeoff.png")
            local volumebtn = vgui.Create("DImageButton", ply_panel)
            volumebtn:SetSize(42, 42)

            if ply:GetVoiceVolumeScale() > 0 then
                volumebtn:SetMaterial(volumeon)
            else
                volumebtn:SetMaterial(volumeoff)
            end

            volumebtn:Dock(RIGHT)
            volumebtn:DockMargin(3, 0, 0, 0)
            volumebtn:SetTooltip("Toggle player's volume.")
            volumebtn.DoClick = function(self)
                if ply:GetVoiceVolumeScale() > 0 then
                    ply:SetVoiceVolumeScale(0.0)
                    self:SetMaterial(volumeoff)
                else
                    ply:SetVoiceVolumeScale(1.0)
                    self:SetMaterial(volumeon)
                end
            end
        end

        local pingimg = vgui.Create("DImage", ply_panel)
        pingimg:SetSize(42, 42)
        pingimg:Dock(RIGHT)
        pingimg:DockMargin(0, 0, 6, 0)
        pingimg.Think = function(self)
            local ping = ply:Ping()

            if ping <= 60 then
                self:SetMaterial(Material("vgui/os_lowping.png"))
            elseif ping <= 100 then
                self:SetMaterial(Material("vgui/os_medping.png"))
            elseif ping <= 180 then
                self:SetMaterial(Material("vgui/os_highping.png"))
            else
                self:SetMaterial(Material("vgui/os_badping.png"))
            end
        end

        local pinglbl = vgui.Create("DLabel", pingimg)
        pinglbl:SetPos(0, 0)
        pinglbl.Think = function(self)
            local ping = ply:Ping()
            self:SetText(ping)

            if ping <= 60 then
                self:SetTextColor(color_green)
            elseif ping <= 100 then
                self:SetTextColor(color_yellow)
            elseif ping <= 180 then
                self:SetTextColor(color_lightred)
            else
                self:SetTextColor(color_red)
            end
        end

        return ply_panel
    end

    local function UpdatePlayers()
        local lply = LocalPlayer()

        if is_teams then
            ts_scroll_panel:Clear()
            cts_scroll_panel:Clear()

            MakePlayer(lply, (lply:Team() == 0) and ts_scroll_panel or cts_scroll_panel)

            for _, ply in ipairs(player.GetAll()) do
                if ply ~= lply then
                    MakePlayer(ply, (ply:Team() == 0) and ts_scroll_panel or cts_scroll_panel)
                end
            end

        else
            scroll_panel:Clear()

            MakePlayer(lply, scroll_panel)

            for _, ply in ipairs(player.GetAll()) do
                if ply ~= lply then
                    MakePlayer(ply, scroll_panel)
                end
            end
        end
    end

    hook.Add("ScoreboardShow", "ShowScoreboard", function()
        UpdatePlayers()
        SCOREBOARD:SetPos(ScrW() / 2 - SCOREBOARD:GetWide() / 2, 180)
        SCOREBOARD:SetVisible(true)
        return true
    end)

    hook.Add("Think", "SetScoreboardVisibility", function()
        if GetGlobal2Var("game_state") == 4 then
            SCOREBOARD:SetVisible(not gui.IsGameUIVisible())
        end
    end)

    hook.Add("ScoreboardHide", "HideScoreboard", function()
        SCOREBOARD:SetVisible(false)
    end)

    hook.Add("OnEntityCreated", "UpdatePlayerListJOIN", function(ent)
        timer.Simple(0.1, function()
            if ent:IsPlayer() and ent:Alive() then
                UpdatePlayers()
            end
        end)
    end)

    hook.Add("EntityRemoved", "UpdatePlayerListLEAVE", function(ent)
        timer.Simple(0.1, function()
            if ent:IsPlayer() then
                UpdatePlayers()
            end
        end)
    end)
end)