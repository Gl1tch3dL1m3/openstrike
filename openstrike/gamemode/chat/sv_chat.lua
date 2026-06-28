function ServerChat(msg)
    net.Start("ServerChat")
        net.WriteString(msg)
    net.Broadcast()
end