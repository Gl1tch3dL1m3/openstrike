--[[
    ====================
    ====================
    ==== OPENSTRIKE ====
    ====================
    ====================
--]]

-- I'm really sorry if the code is confusing or whatever...it's my first functional gamemode ever
-- I'm always opened to suggestions! :D

AddCSLuaFile()
DeriveGamemode("base")

GM.Name = "OpenStrike"
-- discord server coming soon

hook.Add("PlayerFootstep", "MuteCrouchFootstep", function(ply)
    if ply:Crouching() then return true end
end)

hook.Add("PhysgunPickup", "ForbidMapMovement", function(ply, ent)
    if ent:CreatedByMap() or ent:GetClass() == "worldspawn" then
        return false
    end
end)

function GetRealPlayerCount()
    local count = 0
    for _, ply in ipairs(player.GetAll()) do
        if not (ply:IsBot() and ply:Nick() == "SourceTV") then
            count = count + 1
        end
    end
    return count
end

function GetRealPlayers()
    local plys = player.GetAll()
    for _, ply in ipairs(plys) do
        if ply:IsBot() and ply:Nick() == "SourceTV" then
            table.RemoveByValue(plys, ply)
        end
    end
    return plys
end