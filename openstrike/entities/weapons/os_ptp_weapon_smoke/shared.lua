SWEP.Base = "ptp_weapon_smoke"
SWEP.PrintName = "Smoke Grenade"

SWEP.DrawAmmo = false
SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false
SWEP.DrawCrosshair = false

function SWEP:Think()
    if self.Primed == 1 and self.PrimaryThrow then
        if self.Throw < CurTime() then
            local ply = self:GetOwner()

			self.Primed = 2
			self.Throw = CurTime() + 1.5

			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			ply:SetAnimation(PLAYER_ATTACK1)

			timer.Simple( 0.35, function()
				if (!self or !IsValid(self)) then return end
				self:ThrowFar()

                if SERVER then
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
			end)
		end
    end
end

function SWEP:PrimaryAttack()
    if self.Primed == 0 then
        self:SendWeaponAnim(ACT_VM_PULLPIN)
        self.Primed = 1
        self.Throw = CurTime() + 1
        self.PrimaryThrow = true

        if self:GetSequenceName(self:GetSequence()) == "deploy" then
            return
        end
    end
end

function SWEP:SecondaryAttack()
end