-- SERVER-SIDE VARIABLES TO SAVE
server_only_variables = {
    sv_playercount = nil
}

-- SERVER-SIDE
player_weapons = {}
player_default_weapons = {["knife"] = "weapon_csgo_knife_default_t", ["pistol"] = "weapon_csgo_pist_glock18", ["grenade"] = "os_ptp_weapon_grenade", ["weapon"] = "weapon_csgo_rif_ak47"}

-- SHARED
-- -1 - Waiting for players
-- 0 - Intermission
-- 1 - Getting started
-- 2 - Waiting for players to connect
-- 3 - Playing
-- 4 - Endgame
SetGlobal2Var("game_state", -1)
SetGlobal2Var("timer", 0)

function saveVariables()
    local t = Entity(0):GetNW2VarTable()
    
    for k, v in pairs(t) do
        t[k] = v["value"]
    end

    table.Merge(t, server_only_variables)
    file.Write("os_variables_temp.txt", util.TableToJSON(t))
    print("[SERVER] Stored OS_variables into os_variables_temp.txt!")
end

-- Load data from previous session (if any)
if file.Exists("os_variables_temp.txt", "DATA") then
    for k, v in pairs(util.JSONToTable(file.Read("os_variables_temp.txt"))) do
        print(k .. ": " .. tostring(v))
        if string.sub(k, 0, 3) == "sv_" then
            -- Server-side only variables
            server_only_variables[k] = v
        else
            -- Shared variables
            SetGlobal2Var(k, v)
        end
    end
    print("[SERVER] Successfully loaded temp variables!")
    file.Delete("os_variables_temp.txt")
end
