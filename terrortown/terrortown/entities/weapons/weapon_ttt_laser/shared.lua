if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "Laser Rifle"
   SWEP.Slot				= 2
   SWEP.Icon = "VGUI/ttt/icon_m16"
   
   SWEP.EquipMenuData = {
      type = "Laser Rifle",
      desc = "Does EXTREME damage, and fires LAZOR BEEMS!"
   };
end

SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_STUN
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = false


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Tracer = "Ar2Tracer"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay 		= 0.089
SWEP.Primary.Recoil		= 0.85
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage		= 28
SWEP.Primary.Cone = 0.025
SWEP.Primary.ClipSize = 35
SWEP.Primary.ClipMax = 105
SWEP.Primary.DefaultClip = 35
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.AR2 = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.Primary.Sound = Sound( "NP_Galil.Single" )

SWEP.IronSightsPos = Vector(-6.36, -3.473, 2.55)
SWEP.IronSightsAng = Vector(0, -0.01, 0)

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )


   if not IsFirstTimePredicted() then return end

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 10
   bullet.Damage = dmg

   self.Owner:FireBullets( bullet )

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
	
   if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end

    if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
	   
		if (self.Shotgun) then
			util.Effect("effect_mad_shotgunsmoke", effectdata)
		elseif (self.AR2) then
			util.Effect("effect_mad_laser", effectdata)
		elseif (self.IsFireWeapon) then
			util.Effect("effect_mad_fire", effectdata)
		else
			util.Effect("effect_mad_gunsmoke", effectdata)
		end

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.375) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )
   end

end