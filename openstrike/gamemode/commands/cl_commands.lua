net.Receive("ClientCommand", function()
    local cmd = net.ReadString()

    if cmd == "/help" then
        chat.AddText([[
--- HELP ---
Welcome to our server! OpenStrike is a simple Garry's Mod TDM CS:GO server. It was created with the idea of ​​using as few resources as possible while still being enjoyable and fun!

- /help - This message!
- /rules - Server rules.
- /discord - Our Discord server!
- /users - Show all users with their SteamIDs. (Alternative to chat TAB)
- /report <SteamID> <reason> - Report a user.
- /addons - Opens a Steam collection containing every server addon.
- /maps - Opens a Steam collection containing every amazing map used in the server.

--- ADMIN ONLY ---
(H - Helper, A - Admin)

- [H/A] /kick <SteamID> - Kicks a player.
- [A] /ban <SteamID> <days> <reason> - Bans a player. To permaban, set <days> to 0.
        ]])

    elseif cmd == "/users" then
        local msg = "--- USERS ---"

        for i, ply in ipairs(player.GetAll()) do
            msg = msg .. "\nPlayer: " .. ply:Nick() .. "\nSteamID: " .. ply:SteamID64() .. "\n--------------------"
        end

        chat.AddText(msg)
    
    elseif cmd == "/rules" then
        chat.AddText([[
--- RULES ---
(By joining the server you automatically agree with these rules.)
1. Do not abuse the mistakes of the rules. Please use common sense.
2. We have ABSOLUTELY ZERO tolerance for cheats. This will get you permabanned without warning.
3. Swearing is allowed, but don't swear just because you can. Do it with extent.
4. Don't troll chat and voice chat. It may result in a permaban (if needed)!
5. No links or IP addresses.
6. No advertisements.
7. Don't insult each other and don't start wars. We're here to have fun.
8. No political views and nothing about politics.

There are no warnings here, so there's a chance you could get banned straight away if necessary!

Enjoy your stay!
        ]])

    elseif cmd == "/discord" then
        gui.OpenURL("https://discord.gg/Vsc2veyFNP")

    elseif cmd == "/addons" then
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3627569366")

    elseif cmd == "/maps" then
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3653963102")
    end
end)

hook.Add("InitPostEntity", "ShowStarterInfo", function()
    chat.AddText("Type /help to show list of commands!")
end)