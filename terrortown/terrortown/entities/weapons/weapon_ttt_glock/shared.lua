
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"


if CLIENT then
   SWEP.PrintName = "Glock"
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_glock"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_GLOCK

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil		= 0.3
SWEP.Primary.Damage		= 10
SWEP.Primary.Delay 		= 0.066
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.HeadshotMultiplier = 1.25

SWEP.Pistol = true
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel  = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound = Sound( "NP_Glock.Single" )

SWEP.IronSightsPos 		= Vector (-5.77, -3.36, 2.73)
SWEP.IronSightsAng 		= Vector (0.78, 0.01, 0)

SWEP.HeadshotMultiplier = 1.75
