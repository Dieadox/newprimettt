

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "TMP"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m16"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay 		= 0.066
SWEP.Primary.Recoil			= 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 18
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.IsSilent = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound 		= Sound("NP_TMP.Single")

SWEP.IronSightsPos = Vector(5.23, -0, 2.57)
SWEP.IronSightsAng = Vector(0.5, 0, 0)