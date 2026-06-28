SWEP.Base = "weapon_medkit"

SWEP.DrawAmmo = false
SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false
SWEP.DrawCrosshair = false

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local health = ply:Health()
    self.BaseClass.SecondaryAttack(self)

    if SERVER and health < 100 then
        if health + 50 > 100 then
            ply:SetHealth(100)
        else
            ply:SetHealth(health + 50)
        end

        local t = self:SequenceDuration()
        
        timer.Simple(t, function()
            if IsValid(self) then
                ply:StripWeapon(self:GetClass())

                for _, wep in pairs(ply:GetWeapons()) do
                    if wep:GetSlot() == 0 then
                        ply:SelectWeapon(wep.ClassName)
                        break
                    end
                end
            end
        end)
    end
end

function SWEP:SecondaryAttack()
end