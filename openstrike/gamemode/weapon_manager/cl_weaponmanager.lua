local _cookie = {["knife"] = "weapon_csgo_knife_default_t", ["pistol"] = "weapon_csgo_pist_glock18", ["grenade"] = "os_ptp_weapon_grenade", ["weapon"] = "weapon_csgo_rif_ak47"}
local alpha_black = Color(0, 0, 0, 150)
local alpha_green = Color(39,196,0,150)

local function MakeGrid(size, scroll)
    local grid = vgui.Create("DGrid", scroll)
    grid:SetPos(0,0)
    grid:SetCols(5)

    grid:SetRowHeight(size)
    grid:SetColWide(size)

    return grid
end

local function MakeScroll(panel)
    local scroll = vgui.Create("DScrollPanel", panel)
    scroll:Dock(FILL)

    return scroll
end

local function MakeLabel(text, parent, grid_col_wide, _type, wepclass)
    local lbl = vgui.Create("DLabel", parent)
    
    lbl:SetText(text)
    lbl:SetPos(0, grid_col_wide-20)
    lbl:SetSize(grid_col_wide, 20)
    lbl:SetContentAlignment(5)
    lbl:SetTextColor(color_white)

    lbl.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, grid_col_wide, h, (_cookie[_type] == wepclass) and alpha_green or alpha_black)
    end
end

local function MakeButton(name, wepbtn, grid, _type, wepclass)
    wepbtn:SetSize(grid:GetColWide(), grid:GetRowHeight())
    MakeLabel(name, wepbtn, grid:GetColWide(), _type, wepclass)
    grid:AddItem(wepbtn)
end

local ply
local tabs = vgui.Create("DPropertySheet")
tabs:SetSize(701, 500)
tabs:SetVisible(false)
tabs:MakePopup()

local p_knifes = vgui.Create("DPanel")

local p_shotguns = vgui.Create("DPanel")
local p_machineguns = vgui.Create("DPanel")
local p_smgs = vgui.Create("DPanel")
local p_rifles = vgui.Create("DPanel")
local p_snipers = vgui.Create("DPanel")

local p_pistols = vgui.Create("DPanel")
local p_grenades = vgui.Create("DPanel")

local weapontabs = vgui.Create("DPropertySheet")
weapontabs:Dock(FILL)
weapontabs:AddSheet("Shotguns", p_shotguns, "icon16/asterisk_orange.png", false, false)
weapontabs:AddSheet("Machine Guns", p_machineguns, "icon16/asterisk_orange.png", false, false)
weapontabs:AddSheet("SMGs", p_smgs, "icon16/asterisk_orange.png", false, false)
weapontabs:AddSheet("Assault Rifles", p_rifles, "icon16/asterisk_orange.png", false, false)
weapontabs:AddSheet("Snipers", p_snipers, "icon16/asterisk_orange.png", false, false)

-- full res: 137
-- scroll res: 134
local knifesgrid = MakeGrid(134, MakeScroll(p_knifes))
local shotgunsgrid = MakeGrid(137, MakeScroll(p_shotguns))
local machinegunsgrid = MakeGrid(137, MakeScroll(p_machineguns))
local smgsgrid = MakeGrid(137, MakeScroll(p_smgs))
local riflesgrid = MakeGrid(137, MakeScroll(p_rifles))
local snipersgrid = MakeGrid(137, MakeScroll(p_snipers))
local pistolsgrid = MakeGrid(137, MakeScroll(p_pistols))
local grenadesgrid = MakeGrid(137, MakeScroll(p_grenades))

hook.Add("InitPostEntity", "InitWeaponMenu", function()
    ply = LocalPlayer()

    for k, v in pairs(_cookie) do
        local wep = cookie.GetString(k)
        wep = wep or v
        _cookie[k] = wep

        net.Start("SetWeapon")
            net.WriteString(wep)
        net.SendToServer()
    end

    for _, wep in pairs(weapons.GetList()) do
        local wepclass = wep.ClassName
        
        if not (string.StartsWith(wepclass, "weapon_csgo") or string.StartsWith(wepclass, "os_ptp_weapon")) or wepclass == "weapon_csgobase" or wepclass == "weapon_csgobase_knife" or string.EndsWith(wepclass, "scopeless") or string.EndsWith(wepclass, "dual") then continue end

        local wepbtn

        if string.StartsWith(wepclass, "os_ptp_weapon") then
            wepbtn = vgui.Create("SpawnIcon", wepbtn)
            wepbtn:SetSize(grenadesgrid:GetColWide(), grenadesgrid:GetRowHeight())
            wepbtn:SetModel(weapons.GetStored(string.sub(wepclass, 4)).WorldModel)
            wepbtn:SetTooltip(false)

            MakeLabel(wep.PrintName, wepbtn, grenadesgrid:GetColWide(), "grenade", wepclass)
            
            wepbtn.PaintOver = function()
                return true
            end

            wepbtn.DoClick = function()
                net.Start("SetWeapon")
                    net.WriteString(wepclass)
                net.SendToServer()

                cookie.Set("grenade", wepclass)
                _cookie["grenade"] = wepclass
            end
            grenadesgrid:AddItem(wepbtn)
        
        else
            local sub = string.sub(wepclass, 13, 16)

            wepbtn = vgui.Create("DImageButton")
            wepbtn:SetMaterial(Material("vgui/entities/" .. wepclass))
            wepbtn.DoClick = function()
                net.Start("SetWeapon")
                    net.WriteString(wepclass)
                net.SendToServer()

                if string.StartsWith(wepclass, "weapon_csgo_knife") then
                    cookie.Set("knife", wepclass)
                    _cookie["knife"] = wepclass
                elseif string.StartsWith(wepclass, "weapon_csgo_pist") then
                    cookie.Set("pistol", wepclass)
                    _cookie["pistol"] = wepclass
                else
                    cookie.Set("weapon", wepclass)
                    _cookie["weapon"] = wepclass
                end
            end

            if string.StartsWith(wepclass, "weapon_csgo_knife") then
                MakeButton(wep.PrintName, wepbtn, knifesgrid, "knife", wepclass)

            elseif string.StartsWith(wepclass, "weapon_csgo_pist") then
                MakeButton(wep.PrintName, wepbtn, pistolsgrid, "pistol", wepclass)

            elseif sub == "shot" then
                MakeButton(wep.PrintName, wepbtn, shotgunsgrid, "weapon", wepclass)

            elseif sub == "mach" then
                MakeButton(wep.PrintName, wepbtn, machinegunsgrid, "weapon", wepclass)

            elseif sub == "smg_" then
                MakeButton(wep.PrintName, wepbtn, smgsgrid, "weapon", wepclass)

            elseif sub == "rif_" then
                MakeButton(wep.PrintName, wepbtn, riflesgrid, "weapon", wepclass)
            
            elseif sub == "snip" then
                MakeButton(wep.PrintName, wepbtn, snipersgrid, "weapon", wepclass)
            end
        end
    end

    tabs:AddSheet("Knifes", p_knifes, "icon16/lightning.png", false, false, "Only for cosmetic purposes!")
    tabs:AddSheet("Primary", weapontabs, "icon16/gun.png", false, false, "Here you can choose your main weapon!")
    tabs:AddSheet("Secondary", p_pistols, "icon16/gun.png", false, false, "Here you can choose your secondary weapon (pistol)!")
    tabs:AddSheet("Grenades", p_grenades, "icon16/bomb.png", false, false, "Here you can choose your grenade! You can only have one grenade. If you use it in a match, you'll get another after respawning!")

    local is_holding = false
    local is_holding_slot = false

    hook.Add("Think", "ShowWeaponMenu", function()
        tabs:Center()
        local game_state = GetGlobal2Var("game_state")
        local focus = vgui.GetKeyboardFocus()

        if game_state >= 3 and not ply:HasGodMode() then
            tabs:SetVisible(false)

        elseif input.IsKeyDown(KEY_G) and (game_state <= 2 or ply:HasGodMode()) and (not IsValid(focus) or focus:GetClassName() ~= "TextEntry") then
            if not is_holding then
                tabs:SetVisible(not tabs:IsVisible())
                is_holding = true
            end

        else
            is_holding = false
        end
    end)
end)