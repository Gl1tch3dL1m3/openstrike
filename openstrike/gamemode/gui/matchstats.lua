local TERRORISTS_COLOR = Color(209, 191, 121)
local CTERRORISTS_COLOR = Color(104, 133, 158)
local plys_kills_ts = {} -- players sorted from least to most frags
local plys_kills_cts = {}
local panels_ts = {} -- avatarimages for each player
local panels_cts = {}

local function UpdatePlayers()
    plys_kills_ts = team.GetPlayers(0)
    plys_kills_cts = team.GetPlayers(1)

	table.sort(plys_kills_ts, function(a, b) return a:Frags() > b:Frags() end)
	table.sort(plys_kills_cts, function(a, b) return a:Frags() > b:Frags() end)
end

local function InitMatchGUI()
	local _timer = GetGlobal2Var("timer")

	for i = 1, 18 do
		local avatarimg = vgui.Create("AvatarImage")
		avatarimg:SetSize(40, 40)
		avatarimg:SetVisible(false)

		if i <= 9 then
			avatarimg:SetPos(ScrW() / 2 - GetTextSize("00:00") - 40 - 45 * (i - 1), 0)
			table.insert(panels_ts, avatarimg)
		else
			avatarimg:SetPos(ScrW() / 2 + GetTextSize("00:00") - 2 + 45 * (i - 10), 0)
			table.insert(panels_cts, avatarimg)
		end
	end

	hook.Add("HUDPaint", "MatchStats", function()
		local scrw = ScrW()
		local scrw_halved = scrw / 2

		local delta = _timer - CurTime()
		local txt = (GetGlobal2Var("game_state") == 3) and string.format("%02d:%02d", math.floor(delta / 60), math.floor(delta % 60)) or "00:00"
		local txtw = GetTextSize(txt)+30
		txtw_halved = txtw / 2

		-- Timer
		draw.RoundedBox(0, scrw_halved - txtw_halved, 0, txtw, 30, color_black)
		draw.SimpleText(txt, "TahomaFix", scrw_halved, 2, color_white, TEXT_ALIGN_CENTER)

        UpdatePlayers()

		-- Player profiles and frags
        for i = 1, 18 do
			local iter_i
			local p
			local plys_kills
			local panels

			if i <= 9 then
				iter_i = i
				p = scrw_halved - GetTextSize("00:00") - 40 - 45 * (i - 1)
				plys_kills = plys_kills_ts
				panels = panels_ts
			else
				iter_i = i-9
				p = scrw_halved + GetTextSize("00:00") - 2 + 45 * (i - 10)
				plys_kills = plys_kills_cts
				panels = panels_cts
			end

			if iter_i <= #plys_kills then
				local ply = plys_kills[iter_i]

				panels[iter_i]:SetPos(p, 0)
				panels[iter_i]:SetVisible(true)
				panels[iter_i]:SetPlayer((ply:IsBot()) and NULL or ply)
				draw.RoundedBox(0, p - 5, 0, 50, 72, color_black)
				draw.RoundedBox(0, p, 43, 40, 5, color_white)
				draw.SimpleText(tostring(ply:Frags()), "TahomaFix", p + 20, 46, color_white, TEXT_ALIGN_CENTER)
			else
				panels[iter_i]:SetVisible(false)
			end
        end

		-- Terrorists total kills
		draw.RoundedBox(0, scrw_halved - txtw_halved, 32, txtw_halved - 3, 25, TERRORISTS_COLOR)
		draw.SimpleText(tostring(team.TotalFrags(0)), "TahomaFix", scrw_halved - txtw_halved + (txtw_halved - 6.5) / 2, 32, color_white, TEXT_ALIGN_CENTER)

		-- CTerrorists total kills
		draw.RoundedBox(0, scrw_halved + 3, 32, txtw_halved - 3, 25, CTERRORISTS_COLOR)
		draw.SimpleText(tostring(team.TotalFrags(1)), "TahomaFix", scrw_halved + 3 + (txtw_halved - 6.5) / 2, 32, color_white, TEXT_ALIGN_CENTER)
	end)
end

hook.Add("InitPostEntity", "InitMatchStats", function()
    local map_name = game.GetMap()
	notification.AddLegacy("Press G to change weapons!", NOTIFY_GENERIC, 8)

	if GetGlobal2Var("game_state") >= 2 then
		notification.AddLegacy("Press E to open doors!", NOTIFY_GENERIC, 8)
		notification.AddLegacy("Press Q to switch to last weapon!", NOTIFY_GENERIC, 8)
	end

    timer.Create("InitMatchStats", 0.1, 0, function()
        if GetGlobal2Var("game_state") == 3 then
            InitMatchGUI()
            timer.Remove("InitMatchStats")
        end
    end)
end)