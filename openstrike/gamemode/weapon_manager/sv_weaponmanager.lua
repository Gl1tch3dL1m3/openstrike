net.Receive("SetWeapon", function(len, ply)
    local wep = net.ReadString()
    local wep_obj = weapons.GetStored(wep)
    local steamID = ply:SteamID64()
    local game_state = GetGlobal2Var("game_state")
    local _type
    print("[SERVER] " .. ply:Nick() .. " tried to set weapon " .. wep .. "...")

    if (string.StartsWith(wep, "weapon_csgo") or string.StartsWith(wep, "os_ptp_weapon")) and not (wep == "weapon_csgobase" or wep == "weapon_csgobase_knife" or string.EndsWith(wep, "scopeless") or string.EndsWith(wep, "dual")) and wep_obj then
        if not player_weapons[steamID] then
            player_weapons[steamID] = {}
        end

        local slot = wep_obj.Slot
        local weps = ply:GetWeapons()
        local is_slot_taken = false

        if weps and (game_state == 2 or game_state == 3) and ply:HasGodMode() then
            for _, iter_wep in pairs(weps) do
                if iter_wep:GetSlot() == slot then
                    is_slot_taken = true
                    ply:StripWeapon(iter_wep.ClassName)
                    break
                end
            end
        end

        if string.StartsWith(wep, "weapon_csgo_knife") then
            _type = "knife"
        elseif string.StartsWith(wep, "weapon_csgo_pist") then
            _type = "pistol"
        elseif string.StartsWith(wep, "os_ptp_weapon") then
            _type = "grenade"
        else
            _type = "weapon"
        end

        player_weapons[steamID][_type] = wep

        if (game_state == 2 or game_state == 3) and (ply:HasGodMode() or not is_slot_taken) then
            ply:Give(wep)
            ply:SelectWeapon(wep)
        end
        
        print("[SERVER] " .. "Success!")
        
    else
        SendErrorMsgToClient(ply, "Invalid weapon.")
    end
end)

net.Receive("SelectWeapon", function(len, ply)
    local wep = net.ReadString()

    for _, iter_wep in pairs(ply:GetWeapons()) do
        if iter_wep:GetClass() == wep then
            ply:SelectWeapon(iter_wep)
        end
    end
end)

function GiveWeapons(ply)
    local steamID = ply:SteamID64()
    local ply_weps = player_weapons[steamID]
    print("[SERVER] Giving player " .. ply:Nick() .. " (" .. steamID .. ") weapons...")

    if not ply_weps then
        ply_weps = {}
        player_weapons[steamID] = {}
        table.CopyFromTo(player_default_weapons, ply_weps)
    end

    for k, v in pairs(ply_weps) do
        player_weapons[steamID][k] = v
        
        ply:Give(v)
    end

    ply:SelectWeapon(ply_weps["weapon"])
end