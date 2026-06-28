local alpha_white = Color(255,255,255,200)

function GetInflictor(inf)
    if IsValid(inf) then
        if inf:IsWeapon() then
            return inf:GetClass()
        elseif inf:IsPlayer() then
            local active = inf:GetActiveWeapon()
            if IsValid(active) then
                return active:GetClass()
            end
        else
            return inf:GetClass()
        end
    end
end

hook.Add("EntityTakeDamage", "AntiTeamKillBomb", function(vic, dmginfo)
    local att = dmginfo:GetAttacker()
    local inf = dmginfo:GetInflictor()
    local game_state = GetGlobal2Var("game_state")

    if not att:IsPlayer() or not vic:IsPlayer() then return end

    if not (game_state == 3 and (inf:GetClass() == "env_explosion" or vic:Team() ~= att:Team())) then
        dmginfo:SetDamage(0)
    end

    local wep = GetInflictor(inf)

    net.Start("PlayerTakeDamage")
        net.WritePlayer(att)
        net.WriteString((wep) and wep or "death")
        net.WritePlayer(vic)
    net.Broadcast()
end)

hook.Add("PlayerDeath", "AutoRespawn", function(vic, inf, att)
    local wep = GetInflictor(inf)
    
    net.Start("PlayerDeath")
        net.WritePlayer(att)
        net.WriteString((wep) and wep or "death")
        net.WritePlayer(vic)
        net.WriteBool(vic:LastHitGroup() == 1)
    net.Broadcast()

    timer.Create("respawn_" .. vic:SteamID64(), 5, 1, function()
        if IsValid(vic) and not vic:Alive() then
            vic:Spawn()
        end
    end)

    if att == vic then
        att:AddFrags(1) -- because gmod substracts 1 from total frags when player suicides
        return

    elseif vic:Team() == att:Team() then
        att:AddFrags(-1)
        return
    end

    if not att:HasWeapon("os_weapon_medkit") then
        att.MedKills = att.MedKills + 1

        if att.MedKills == 3 then
            att:Give("os_weapon_medkit") -- give medkit after every 3 kills
            att.MedKills = 0
        end
    end
end)

hook.Add("PlayerSpawn", "SetGodModeCooldown", function(ply)
    timer.Simple(0, function()
        if ply:IsBot() and ply:Nick() == "SourceTV" then
            ply:SetNoDraw(true)
            ply:SetNotSolid(true)
            ply:DrawShadow(false)
            ply:SetMoveType(MOVETYPE_NONE)
            ply:SetPos(Vector(0, 0, -10000))
            return
        end

        if IsValid(ply.Spawnpoint) then
            ply.Spawnpoint:Remove()
        end

        ply.SpawnCount = ply.SpawnCount + 1
        ply.MedKills = 0 -- kills since last usage of medkit
        ply:SetColor(alpha_white)
        ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

        if GetGlobal2Var("game_state") == 3 then
            ply:GodEnable()

            -- Automatically give weapons after respawn
            if ply.SpawnCount > 1 then
                print("[SERVER] Activating GiveWeapons for " .. ply:Nick() .. " (" .. ply:SteamID64() .. ").")
                GiveWeapons(ply)
            end

            timer.Remove("respawn_" .. ply:SteamID64())
            timer.Create("cooldown_" .. ply:SteamID64(), 13, 1, function()
                ply:GodDisable()
            end)
        end
    end)
end)

hook.Add("EntityFireBullets", "PreventSpawnFire", function(ent, data)
    local wep = ent:GetActiveWeapon()
    local maxclip = wep:GetMaxClip1()
    
    ent:GiveAmmo(1, wep:GetPrimaryAmmoType(), true)

    if GetGlobal2Var("game_state") == 3 and ent:HasGodMode() then
        timer.Remove("cooldown_" .. ent:SteamID64())
        ent:GodDisable()
    end
end)

hook.Add("StartCommand", "DisableGodModeOnMove", function(ply, cmd)
    if GetGlobal2Var("game_state") == 3 and ply:HasGodMode() and cmd:GetForwardMove() != 0 or cmd:GetSideMove() != 0 then
        timer.Remove("cooldown_" .. ply:SteamID64())
        ply:GodDisable()
    end
end)