local color_red = Color(255,0,0)
local color_yellow = Color(255,217,0)

local pos = Vector(-479, -100, 220)
local ang = Angle(0, 90, 90)

hook.Add("InitPostEntity", "StartInfoAndMenu", function()
    if GetGlobal2Var("game_state") <= 1 then
        hook.Add("PostDrawTranslucentRenderables", "DrawIntroBoard", function()
            local _, introtitle_h = GetTextSize("WELCOME TO OPENSTRIKE!", "3D2DTitle")
            local _, rulestitle_h = GetTextSize("SERVER RULES", "3D2DTitle")

            cam.Start3D2D(pos, ang, 0.4)
                draw.DrawText("WELCOME TO OPENSTRIKE!", "3D2DTitle", 0, 25, color_red)
                draw.DrawText("We are a lightweight Garry's Mod TDM CS:GO server\nthat was created with the idea of using a very small\ndownload size of external addons (~540MB) while still\nkeeping it enjoyable and fun!\n\nThere is a chat command system on the server, but\nyou won't use it much because almost everything\nis converted to GUI. To check it out, type /help to\nshow the command list.\n\nTo change your weapons, press G. You can do this\nwhen you have spawn protection active or right now\nin the lobby!", "3D2DDesc", 0, 45 + introtitle_h, color_white)
                
                draw.DrawText("SERVER RULES", "3D2DTitle", 600, 25, color_yellow)
                draw.DrawText("(By joining the server you automatically agree with these rules.)\n1. Do not abuse the mistakes of the rules. Please use common sense.\n2. We have ABSOLUTELY ZERO tolerance for cheats. This will get you\npermabanned without warning.\n3. Swearing is allowed, but don't swear just because you can. Do it with extent.\n4. Don't troll chat and voice chat. It may result in a permaban (if needed)!\n5. No links or IP addresses.\n6. No advertisements.\n7. Don't insult each other and don't start wars. We're here to have fun.\n8. No political views and nothing about politics.\n\nThere are no warnings here, so there's a chance you could get banned\nstraight away if necessary!", "3D2DDesc", 600, 45 + rulestitle_h, color_white)
            cam.End3D2D()
        end)
    end

    local discord
    local addons

    hook.Add("OnPauseMenuShow", "ShowMenuButtons", function()
        discord = vgui.Create("DImageButton")
        discord:SetMaterial(Material("buttons/os_discord.png"))
        discord:SetPos(85, ScrH() - 150)
        discord:SetSize(80, 80)
        discord:MakePopup()
        discord.OnScreenSizeChanged = function(self, oldW, oldH, w, h)
            self:SetPos(85, ScrH() - 150)
        end
        discord.DoClick = function()
            gui.OpenURL("https://discord.gg/Vsc2veyFNP")
        end

        addons = vgui.Create("DImageButton")
        addons:SetMaterial(Material("buttons/os_addon.png"))
        addons:SetPos(185, ScrH() - 150)
        addons:SetSize(80, 80)
        addons:MakePopup()
        addons.OnScreenSizeChanged = function(self, oldW, oldH, w, h)
            self:SetPos(185, ScrH() - 150)
        end
        addons.DoClick = function()
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3627569366")
        end
    end)
    
    -- HUDPaint is only called when the pause menu is closed
    hook.Add("HUDPaint", "HideMenuButtons", function()
        if IsValid(discord) then discord:Remove() end
        if IsValid(addons) then addons:Remove() end
    end)
end)