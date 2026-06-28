local PLAYER_SPEED = 250
local PLAYER_DUCK_SPEED = 0.4
local INTERMISSION_TIME = 60
local WAIT_CONNECT_TIME = 100
local MATCH_TIME = 600

team.SetUp(0, "Terrorists", Color(184, 169, 110), false)
team.SetUp(1, "Counter-Terrorists", Color(96, 122, 145), false)

local function ChangeToLobby(changemap)
    changemap = changemap == nil or changemap
    print("[SERVER] Stopping the game/intermission, because there aren't enough players!")
    SetGlobal2Var("timer", 0)
    SetGlobal2Var("game_state", -1)

    if changemap then
        game.ConsoleCommand("tv_stoprecord\n")

        RunConsoleCommand("changelevel", "gm_lobby")
    end
end

if GetGlobal2Var("game_state") == 2 then
    local switch_team = 0
    demo_file = "demos/" .. os.date("%d-%m-%Y-%H-%M-%S")

    game.ConsoleCommand("tv_record " .. demo_file .. "\n")

    timer.Create("StartMatch", WAIT_CONNECT_TIME, 1, function()
        if GetRealPlayerCount() <= 1 then
            ChangeToLobby()
        else
            print("[SERVER] Match started! (by timer)")
            SetGlobal2Var("game_state", 3)
            SetGlobal2Var("timer", CurTime() + MATCH_TIME)
        end
    end)
end

hook.Add("PlayerInitialSpawn", "GameManagerConnect", function(ply)
    local game_state = GetGlobal2Var("game_state")
    ply.SpawnCount = -1
    
    timer.Simple(0, function()
        local isbot = ply:IsBot()

        if isbot and ply:Nick() == "SourceTV" then
            return
        else
            if not isbot and not ply:IsFullyAuthenticated() then
                ply:Kick("You must have an authenticated SteamID to connect. Please try connecting again")
            end

            local sourcetv = player.GetBots()[1]
            if sourcetv then
                -- Don't send any info about the SourceTV bot to players
                sourcetv:SetPreventTransmit(ply, true)
            end
        end

        ply:AllowFlashlight(true)
        local playercount = GetRealPlayerCount()

        if game_state <= 0 then
            ply:SetModel((math.random(2) == 1) and "models/player/phoenix.mdl" or "models/player/swat.mdl")
        end

        if game_state == -1 and playercount >= 2 then
            print("[SERVER] Starting intermission!")
            SetGlobal2Var("timer", CurTime() + INTERMISSION_TIME)
            SetGlobal2Var("game_state", 0)

        elseif game_state >= 2 then
            local steamID = ply:SteamID64()
            
            if team.NumPlayers(0) <= team.NumPlayers(1) then
                ply:SetTeam(0)
            else
                ply:SetTeam(1)
            end
            
            print("[SERVER] Player " .. ply:Nick() .. " has joined " .. ply:Team())

            ply:SetModel((ply:Team() == 0) and "models/player/phoenix.mdl" or "models/player/swat.mdl")
            ply:Spawn()

            if game_state == 2 and playercount == server_only_variables["sv_playercount"] then
                print("[SERVER] Match started!")
                
                timer.Remove("StartMatch")
                SetGlobal2Var("game_state", 3)
                SetGlobal2Var("timer", CurTime() + MATCH_TIME)
            end
        end
    end)
end)

hook.Add("Move", "ManageMoving", function(ply, mv)
    local game_state = GetGlobal2Var("game_state")
    local wep = ply:GetActiveWeapon()

    ply:SetWalkSpeed(PLAYER_SPEED)
    ply:SetCrouchedWalkSpeed(PLAYER_DUCK_SPEED)
    ply:SetRunSpeed(PLAYER_SPEED)
    
    if game_state == 2 or game_state == 4 then
        mv:SetMaxSpeed(0)

    elseif ply:Crouching() then
        return

    elseif IsValid(wep) then
        local wepclass = wep:GetClass()

        if string.sub(13, 17) == "knife" then return

        -- Pistols
        elseif wepclass == "weapon_csgo_pist_cz75" then
            mv:SetMaxSpeed(185)
        elseif wepclass == "weapon_csgo_pist_deagle" then
            mv:SetMaxSpeed(170)
        elseif wepclass == "weapon_csgo_pist_elite" then
            mv:SetMaxSpeed(190)
        elseif wepclass == "weapon_csgo_pist_fiveseven" then
            mv:SetMaxSpeed(188)
        elseif wepclass == "weapon_csgo_pist_glock18" then
            mv:SetMaxSpeed(192)
        elseif wepclass == "weapon_csgo_pist_p2000" then
            mv:SetMaxSpeed(188)
        elseif wepclass == "weapon_csgo_pist_revolver" then
            mv:SetMaxSpeed(175)
        elseif wepclass == "weapon_csgo_pist_tec9" then
            mv:SetMaxSpeed(190)
        elseif wepclass == "weapon_csgo_pist_usps" then
            mv:SetMaxSpeed(188)

        -- Shotguns
        elseif wepclass == "weapon_csgo_shot_mag7" then
            mv:SetMaxSpeed(165)
        elseif wepclass == "weapon_csgo_shot_nova" then
            mv:SetMaxSpeed(160)
        elseif wepclass == "weapon_csgo_shot_sawedoff" then
            mv:SetMaxSpeed(162)
        elseif wepclass == "weapon_csgo_shot_xm1014" then
            mv:SetMaxSpeed(167)

        -- Machine Guns
        elseif wepclass == "weapon_csgo_mach_m249" then
            mv:SetMaxSpeed(145)
        elseif wepclass == "weapon_csgo_mach_negev" then
            mv:SetMaxSpeed(140)

        -- SMGs
        elseif wepclass == "weapon_csgo_smg_mac10" then
            mv:SetMaxSpeed(185)
        elseif wepclass == "weapon_csgo_smg_mp5sd" then
            mv:SetMaxSpeed(183)
        elseif wepclass == "weapon_csgo_smg_mp7" then
            mv:SetMaxSpeed(187)
        elseif wepclass == "weapon_csgo_smg_mp9" then
            mv:SetMaxSpeed(189)
        elseif wepclass == "weapon_csgo_smg_p90" then
            mv:SetMaxSpeed(192)
        elseif wepclass == "weapon_csgo_smg_bizon" then
            mv:SetMaxSpeed(186)
        elseif wepclass == "weapon_csgo_smg_ump45" then
            mv:SetMaxSpeed(184)

        -- Assault Rifles
        elseif wepclass == "weapon_csgo_rif_ak47" then
            mv:SetMaxSpeed(175)
        elseif wepclass == "weapon_csgo_rif_aug" then
            mv:SetMaxSpeed(178)
        elseif wepclass == "weapon_csgo_rif_famas" then
            mv:SetMaxSpeed(180)
        elseif wepclass == "weapon_csgo_rif_galil" then
            mv:SetMaxSpeed(180)
        elseif wepclass == "weapon_csgo_rif_m4a1s" then
            mv:SetMaxSpeed(178)
        elseif wepclass == "weapon_csgo_rif_m4a4" then
            mv:SetMaxSpeed(177)
        elseif wepclass == "weapon_csgo_rif_sg553" then
            mv:SetMaxSpeed(178)

        -- Snipers
        elseif wepclass == "weapon_csgo_snip_awp" then
            mv:SetMaxSpeed(150)
        elseif wepclass == "weapon_csgo_snip_g3sg1" then
            mv:SetMaxSpeed(165)
        elseif wepclass == "weapon_csgo_snip_scar20" then
            mv:SetMaxSpeed(165)
        elseif wepclass == "weapon_csgo_snip_ssg08" then
            mv:SetMaxSpeed(168)

        --[[
        -- Extras
        elseif wepclass == "weapon_csgo_pist_deagle_dual" then
            mv:SetMaxSpeed(175)
        elseif wepclass == "weapon_csgo_smg_mac10_dual" then
            mv:SetMaxSpeed(187)
        elseif wepclass == "weapon_csgo_rif_aug_scopeless" then
            mv:SetMaxSpeed(182)
        elseif wepclass == "weapon_csgo_rif_sg553_scopeless" then
            mv:SetMaxSpeed(182)
        elseif wepclass == "weapon_csgo_snip_awp_scopeless" then
            mv:SetMaxSpeed(155)
        elseif wepclass == "weapon_csgo_snip_g3sg1_scopeless" then
            mv:SetMaxSpeed(168)
        elseif wepclass == "weapon_csgo_snip_scar20_scopeless" then
            mv:SetMaxSpeed(168)
        elseif wepclass == "weapon_csgo_snip_ssg08_scopeless" then
            mv:SetMaxSpeed(170)
        ]]
        end
    end
end)

hook.Add("Tick", "GameManagerTick", function()
    local game_state = GetGlobal2Var("game_state")
    local _timer = GetGlobal2Var("timer")

    if game_state == 0 and GetRealPlayerCount() <= 1 then
        ChangeToLobby(false)

    elseif game_state == 3 and (team.NumPlayers(0) == 0 or team.NumPlayers(1) == 0) then
        ChangeToLobby()

    elseif game_state == 0 and CurTime() >= _timer then
        print("[SERVER] Getting started...")

        SetGlobal2Var("timer", 0)
        SetGlobal2Var("game_state", 1)

        timer.Simple(3, function()
            SetGlobal2Var("game_state", 2)
            server_only_variables["sv_playercount"] = GetRealPlayerCount()

            saveVariables() -- Save variables to data/os_variables_temp.txt

            local map = table.Random(maps)

            print("[SERVER] Started new game!")
            game.ConsoleCommand("tv_enable 1\n")
            RunConsoleCommand("changelevel", map)
        end)

    elseif game_state == 3 and CurTime() >= _timer then
        SetGlobal2Var("game_state", 4)
        SetGlobal2Var("timer", CurTime() + 10)

        timer.Simple(10, function()
            ChangeToLobby()
        end)
    end
end)

-- Disable sprays because I said so lol
hook.Add("PlayerSpray", "DisablePlayerSpray", function()
    return true
end)

hook.Add("PlayerCanPickupItem", "DisableItemPickup", function()
    return false
end)

hook.Add("AllowPlayerPickup", "DisableUSEKeyPickup", function()
    return false
end)

net.Receive("Flashlight", function(len, ply)
    for _, map in pairs(dark_maps) do
        if map == map_name then
            ply:Flashlight(true)
            break
        end
    end
end)