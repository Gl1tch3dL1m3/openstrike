function ReportPlayer(reporter, target, reason)
    if not target or (target:IsBot() and target:Nick() == "SourceTV") or target:IsUserGroup("owner") then
        return 1
    else
        local targetID = target:SteamID64()
        local reporterID = reporter:SteamID64()

        if targetID == reporterID then
            return 3
        elseif #sql.QueryTyped("SELECT reporter FROM reports WHERE reporter=? AND target=?", reporterID, targetID) == 0 then
            sql.Begin()
            sql.QueryTyped("INSERT INTO reports VALUES (?, ?, ?, ?, ?)", reporterID, targetID, reason, os.date("%d-%m-%Y %H:%M:%S"), GetGlobal2Var("game_state"))
            sql.Commit()
            return 0
        else
            return 2
        end
    end
end

local function ReportPlayerWithResponse(reporter, target, reason)
    local status = ReportPlayer(reporter, target, reason)

    if status == 0 then
        reporter:ChatPrint("[SERVER] Successfully sent your report! Thank you for making OpenStrike better!")
    elseif status == 1 then
        SendErrorMsgToClient(reporter, "The SteamID you typed in is invalid. To get a player's SteamID, press TAB, select the player (their SteamID will be copied), paste the SteamID.")
    elseif status == 2 then
        SendErrorMsgToClient(reporter, "You have already reported this player!")
    else
        SendErrorMsgToClient(reporter, "Why?")
    end
end

net.Receive("ReportPlayer", function(len, ply)
    local target = net.ReadPlayer()
    local reason = net.ReadString()
    ReportPlayerWithResponse(ply, target, reason)
end)

hook.Add("PlayerSay", "ExecuteCommands", function(ply, text)
    if not (ply:IsUserGroup("helper") or ply:IsUserGroup("admin") or ply:IsUserGroup("owner")) and (string.find(text, "https?://[%w-_%.%?%.:/%+=&]+") or string.find(text, "www%.[%w-_%.%?%.:/%+=&]+") or string.find(text, "%d+%.%d+%.%d+%.%d+")) then
        ply:ChatPrint("[SERVER] Don't send links and IP addresses!")
        return ""
    end

    text = string.Trim(text)

    if string.StartsWith(text, "/") then
        local plysteamID = ply:SteamID64()

        if text == "/help" or
            text == "/users" or
            text == "/rules" or
            text == "/discord" or
            text == "/addons" or
            text == "/maps"
            then
            net.Start("ClientCommand")
                net.WriteString(text)
            net.Send(ply)
        
        elseif string.StartsWith(text, "/report") then
            local args = string.Split(text, " ")
            local target = player.GetBySteamID64(args[2])

            if #args <= 2 then
                SendErrorMsgToClient(ply, "Invalid usage of /report. Usage: /report <SteamID> <reason>")
            else
                ReportPlayerWithResponse(ply, target, table.concat(args, " ", 3))
            end
        --[=[
        Probably won't be added

        elseif string.StartsWith(text, "/votekick") then
            local args = string.Split(text, " ")

            if #args == 1 then
                SendErrorMsgToClient(ply, "Invalid usage of /votekick. Usage: /votekick <SteamID>")
            else
                local cache = votekick[args[2]]

                if not player.GetBySteamID64(args[2]) then
                    SendErrorMsgToClient(ply, "The SteamID you typed in is invalid. To get a player's SteamID, press TAB, select the player (their SteamID will be copied), paste the SteamID.")
                elseif not (cache and table.HasValue(cache[args[2]], plysteamID)) then
                    SendErrorMsgToClient(ply, "You have already voted for this player!")
                else
                    if not cache then
                        votekick[args[2]] = {}
                    end

                    table.insert(votekick[args[2]], plysteamID)
                    ply:ChatPrint("[SERVER] Successfully voted for this player!\nVotes: " .. tostring(#votekick[args[2]]) .. "/" .. )
                end
            end
        
        elseif string.StartsWith(text, "/ignore")
            local args = string.Split(text, " ")

            if #args == 1 then
                SendErrorMsgToClient(ply, "Invalid usage of /ignore. Usage: /ignore <SteamID>")
            else
                if not player.GetBySteamID64(args[2]) then
                    SendErrorMsgToClient(ply, "The SteamID you typed in is invalid. To get a player's SteamID, press TAB, select the player (their SteamID will be copied), paste the SteamID.")
                else
                end
            end
        ]=]

        -- Lazy to make functions from these conditions - they would be useless anyway
        elseif string.StartsWith(text, "/kick") then
            local args = string.Split(text, " ")
            local target = player.GetBySteamID64(args[2])

            if not (ply:IsUserGroup("helper") or ply:IsUserGroup("admin") or ply:IsUserGroup("owner")) then
                SendErrorMsgToClient(ply, "You aren't allowed to use this command.")
            elseif #args <= 2 then
                SendErrorMsgToClient(ply, "Invalid usage of /kick. Usage: /kick <SteamID> <reason>")
            elseif not target or (target:IsBot() and target:Nick() == "SourceTV") or target:IsUserGroup("owner") then
                SendErrorMsgToClient(ply, "The SteamID you typed in is invalid. To get a player's SteamID, press TAB, select the player (their SteamID will be copied), paste the SteamID.")
            elseif args[2] == plysteamID then
                SendErrorMsgToClient(ply, "Why?")
            else
                local reason = table.concat(args, " ", 3)
                sql.QueryTyped("INSERT INTO actions VALUES (?, ?, ?, ?)", plysteamID, args[2], "kick", reason)
                ply:Kick(reason)
                ServerChat(ply:Nick() .. " kicked " .. target:Nick() .. "!\nReason: " .. reason)
            end

        elseif string.StartsWith(text, "/ban") then
            local args = string.Split(text, " ")
            local target = player.GetBySteamID64(args[2])
            local days = tonumber(args[3])

            if not (ply:IsUserGroup("admin") or ply:IsUserGroup("owner")) then
                SendErrorMsgToClient(ply, "You aren't allowed to use this command.")
            elseif #args <= 3 and not days then
                SendErrorMsgToClient(ply, "Invalid usage of /ban. Usage: /ban <SteamID> <days> <reason>")
            elseif not target or (target:IsBot() and target:Nick() == "SourceTV") or target:IsUserGroup("owner") then
                SendErrorMsgToClient(ply, "The SteamID you typed in is invalid. To get a player's SteamID, press TAB, select the player (their SteamID will be copied), paste the SteamID.")
            elseif args[2] == plysteamID then
                SendErrorMsgToClient(ply, "Why?")
            else
                local reason = table.concat(args, " ", 4)
                local minutes = days * 1440
                local strdays = tostring(days)

                sql.QueryTyped("INSERT INTO actions VALUES (?, ?, ?, ?)", plysteamID, args[2], "ban " .. strdays, reason)
                ply:Ban(minutes, true)
                ServerChat(ply:Nick() .. " banned " .. target:Nick() .. "! (" .. ((minutes == 0) and "permaban" or "for " .. strdays .. " day(s)") .. ")\nReason: " .. reason)
            end
        else
            SendErrorMsgToClient(ply, "Unrecognized command. Type /help to get started.")
        end

        return ""
    end
end)