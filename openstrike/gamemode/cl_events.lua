net.Receive("PlayerDeath", function()
    local att = net.ReadPlayer()
    local inf = net.ReadString()
    local vic = net.ReadPlayer()
    local is_headshot = net.ReadBool()
    
    hook.Run("CLPlayerDeath", att, inf, vic, is_headshot)
end)

net.Receive("PlayerTakeDamage", function()
    local att = net.ReadPlayer()
    local inf = net.ReadString()
    local vic = net.ReadPlayer()

    hook.Run("CLPlayerTakeDamage", att, inf, vic)
end)