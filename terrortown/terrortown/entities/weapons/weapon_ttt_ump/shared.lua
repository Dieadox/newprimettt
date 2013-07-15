

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "smg"


if CLIENT then

   SWEP.PrintName			= "UMP"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m16"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay 		= 0.095
SWEP.Primary.Recoil		= 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage		= 20
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.Pistol = false
SWEP.Shotgun = false
SWEP.Rifle = true
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 52
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.Primary.Sound 		= Sound("NP_UMP45.Single")

SWEP.IronSightsPos 		= Vector(-8.8, -3.3, 4.3)
SWEP.IronSightsAng 		= Vector(-1.38, -0.36, -2.1)