function SendErrorMsgToClient(ply, msg)
    net.Start("ErrorMessage")
        net.WriteString(msg)
    net.Send(ply)
end
