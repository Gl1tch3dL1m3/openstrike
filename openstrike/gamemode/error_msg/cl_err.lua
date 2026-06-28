local color_red = Color(255,0,0)

net.Receive("ErrorMessage", function()
    local msg = net.ReadString()
    chat.AddText(color_red, msg)
end)
