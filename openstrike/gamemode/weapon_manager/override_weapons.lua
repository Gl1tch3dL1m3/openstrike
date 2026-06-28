-- Override weapon specs (slot, name, maybe more)

AddCSLuaFile()

hook.Add("Initialize", "OverrideWeapons", function()
    for _, wep in pairs(weapons.GetList()) do
        local wepclass = wep.ClassName
        if wepclass == "weapon_csgobase" or wepclass == "weapon_csgobase_knife" or wepclass == "ptp_weapon_base" then continue

        elseif string.StartsWith(wepclass, "weapon_csgo_knife") then
            wep.Slot = 2
        elseif string.StartsWith(wepclass, "weapon_csgo_pist") then
            wep.Slot = 1
        elseif wepclass == "os_weapon_medkit" then
            wep.Slot = 4
        elseif string.StartsWith(wepclass, "os_ptp_weapon") then
            wep.Slot = 3
        else
            wep.Slot = 0
        end

        function wep:CustomAmmoDisplay()
            self.AmmoDisplay = self.AmmoDisplay or {}
	        self.AmmoDisplay.Draw = wep.PrintName != "Grenade" and wep.PrintName != "Flash Grenade" and wep.PrintName != "Smoke Grenade"
            self.AmmoDisplay.PrimaryClip = self:Clip1()
            self.AmmoDisplay.PrimaryAmmo = -1
            self.AmmoDisplay.SecondaryAmmo = -1
            return self.AmmoDisplay
        end

        if wepclass == "weapon_csgo_pist_cz75" then
            function wep:Holster()
                pcall(function()
                    self:GetOwner():GetViewModel():SetBodygroup(2, 0)
                end)
                return true
            end
        end
    end
end)