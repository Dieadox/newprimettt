

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "M16"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m16"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay			= 0.075
SWEP.Primary.Recoil			= 0.65
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Damage = 21
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 35
SWEP.Primary.ClipMax = 105
SWEP.Primary.DefaultClip = 35
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.HeadshotMultiplier = 1.25

SWEP.Pistol = false
SWEP.Shotgun = false
SWEP.Rifle = true
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 65
SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Primary.Sound = Sound( "NP_M4A1.Single" )

SWEP.IronSightsPos = Vector(6.045, 0, 1.05)
SWEP.IronSightsAng = Vector(2.6, 1.4, 3.5)