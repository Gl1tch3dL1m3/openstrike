surface.CreateFont("WepSelectFont2", {
    font = "CreditsText",
    size = 20
})

local wep_images = {}
local wep_indexes = {}
local TERRORISTS_COLOR = Color(201, 185, 117, 200)
local CTERRORISTS_COLOR = Color(113, 145, 173)
local UNACTIVE_COLOR = Color(200,0,0,200)

hook.Add("InitPostEntity", "InitWepSelectMenu", function()
    local ply = LocalPlayer()

    local function GetWeaponClassBySlot(slot)
        for _, wep in pairs(ply:GetWeapons()) do
            if wep:GetSlot() == slot then
                return wep:GetClass()
            end
        end

        return nil
    end

    timer.Create("InitWepSelectMenu", 0.1, 0, function()
        if GetGlobal2Var("game_state") == 3 then
            -- Weapon
            local wep = vgui.Create("DImage")
            wep:SetImage("weapons/icons/os_weapon.png")
            wep:SetSize(397/3, 147/3)
            table.insert(wep_images, wep)

            -- Pistol
            wep = vgui.Create("DImage")
            wep:SetImage("weapons/icons/os_pistol.png")
            wep:SetSize(161/3, 114/3)
            table.insert(wep_images, wep)

            -- Knifes
            wep = vgui.Create("DImage")
            wep:SetImage("weapons/icons/os_knife.png")
            wep:SetSize(235/3, 90/3)
            table.insert(wep_images, wep)

            -- Grenade
            wep = vgui.Create("DImage")
            wep:SetImage("weapons/icons/os_grenade.png")
            wep:SetSize(117/2, 153/2)
            table.insert(wep_images, wep)

            -- Medkit
            wep = vgui.Create("DImage")
            wep:SetImage("weapons/icons/os_medkit.png")
            wep:SetSize(225/4, 225/4)
            table.insert(wep_images, wep)

            for k, v in ipairs(wep_images) do
                local index = vgui.Create("DLabel")
                index:SetFont("BudgetLabel")
                index:SetText(k)
                table.insert(wep_indexes, index)
            end

            -- wep.OnScreenSizeChanged doesn't work for some reason (prolly my fault anyway lol)
            hook.Add("Think", "UpdateWeaponImagesPosition", function()
                local scrw_halved = ScrW() / 2
                local scrh = ScrH()

                wep_images[1]:SetPos(scrw_halved - 397/3/2 - 260, scrh - 147/3 - 30)
                wep_images[2]:SetPos(scrw_halved - 161/3/2 - 120, scrh - 114/3 - 40)
                wep_images[3]:SetPos(scrw_halved - 235/3/2, scrh - 90/3 - 45)
                wep_images[4]:SetPos(scrw_halved - 117/2/2 + 120, scrh - 153/2 - 25)

                for k, v in ipairs(wep_images) do
                    v:SetImageColor((ply:Team() == 0) and TERRORISTS_COLOR or CTERRORISTS_COLOR)
                    wep_indexes[k]:SetPos(v:GetPos() + v:GetWide() / 2 - 3, scrh - 25)
                end

                if ply:HasWeapon("os_ptp_weapon_flash") or ply:HasWeapon("os_ptp_weapon_grenade") or ply:HasWeapon("os_ptp_weapon_smoke") then
                    wep_images[4]:SetImageColor((ply:Team() == 0) and TERRORISTS_COLOR or CTERRORISTS_COLOR)
                else
                    wep_images[4]:SetImageColor(UNACTIVE_COLOR)
                end

                wep_images[5]:SetPos(scrw_halved - 225/4/2 + 245, scrh - 225/4 - 35)

                if ply:HasWeapon("os_weapon_medkit") then
                    wep_images[5]:SetImageColor((ply:Team() == 0) and TERRORISTS_COLOR or CTERRORISTS_COLOR)
                else
                    wep_images[5]:SetImageColor(UNACTIVE_COLOR)
                end

            end)

            local last_slot = 0
            local active_slot = 0
            local is_holding_q = false

            hook.Add("Think", "WeaponSelectMenu", function()
                local wep
                local slot
                local is_q_down = input.IsKeyDown(KEY_Q)

                if is_chatting then return end

                if input.IsKeyDown(KEY_1) then
                    slot = 0
                elseif input.IsKeyDown(KEY_2) then
                    slot = 1
                elseif input.IsKeyDown(KEY_3) then
                    slot = 2
                elseif input.IsKeyDown(KEY_4) then
                    slot = 3
                elseif input.IsKeyDown(KEY_5) then
                    slot = 4
                end

                if is_q_down then
                    if is_holding_q then return end
                    is_holding_q = true
                    slot = last_slot
                else
                    is_holding_q = false
                    if not slot then return
                    elseif slot == active_slot then return end
                end

                last_slot = active_slot
                active_slot = slot
            
                net.Start("SelectWeapon")
                    wep = GetWeaponClassBySlot(slot)

                if wep then
                    net.WriteString(wep)
                    net.SendToServer()
                else
                    net.Abort()
                end
            end)

            timer.Create("HideWepSelectMenu", 0.1, 0, function()
                if GetGlobal2Var("game_state") == 4 then
                    for _, img in ipairs(wep_images) do
                        img:SetVisible(false)
                    end
                    for _, index in ipairs(wep_indexes) do
                        index:SetVisible(false)
                    end
                    timer.Remove("HideWepSelectMenu")
                end
            end)
            timer.Remove("InitWepSelectMenu")
        end
    end)
end)