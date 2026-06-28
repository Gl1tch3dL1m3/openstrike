print("Report Database Manager loaded! Type 'reportmgr' to begin...")

concommand.Add("reportmgr", function(ply, cmd, args, argsstr)
    if IsValid(ply) then return

    elseif #args == 0 then
        print("---------------------------------")
        print("---- REPORT DATABASE MANAGER ----")
        print("---------------------------------")
        print("Commands:\n- reportmgr show (shows all reports)\n- reportmgr show <SteamID> (shows all reports from a user)\n- reportmgr delete <index> (deletes a report)\n- reportmgr sql <SQL> (execute SQL query)")
    
    elseif args[1] == "show" then
        local usr = args[2]

        sql.Begin()
        print("Printing reports...")
        PrintTable(sql.Query("SELECT * FROM reports" .. ((usr) and (" WHERE reporter=" .. usr) or "")) or {"No report has been found."})
        sql.Commit()

    elseif args[1] == "delete" then
        local i = args[2]

        if i == nil or i == "" then
            print("Invalid argument for 'delete'. Make sure to type the report index!")
            return
        end

        sql.Begin()
        local report = sql.Query("SELECT * FROM reports")[tonumber(i)]

        if not report then
            print("Report index out of range. Recheck the index number.")
            return
        end

        sql.Query("DELETE FROM reports WHERE reporter=" .. report["reporter"] .. " AND target=" .. report["target"])
        sql.Commit()
        print("Successfully deleted report from " .. report["reporter"] .. " targeting " .. report["target"] .. "!")

    elseif args[1] == "sql" then
        sql.Begin()
        local result = sql.Query(string.sub(argsstr, 5)) -- false = error

        if result == false then
            print("[SQL Error] " .. sql.LastError())
        elseif result then
            PrintTable(result)
        else
            sql.Commit()
        end
    else
        print("Unrecognized parameter.")

    end
end)