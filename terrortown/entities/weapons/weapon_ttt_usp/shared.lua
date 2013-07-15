

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"


if CLIENT then

   SWEP.PrintName			= "USP Tactical"
   SWEP.Slot				= 1

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL

SWEP.Primary.Recoil	= 0.3
SWEP.Primary.Damage = 20
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Pistol = true
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 55
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound 		= Sound("NP_USP.Single")

SWEP.IronSightsPos = Vector(-5.91, -4, 2.7)
SWEP.IronSightsAng = Vector(0, -0.02, 0.2)

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(65, 0.1)
       else
          self.Owner:SetFOV(0, 0.1)
       end
    end
end