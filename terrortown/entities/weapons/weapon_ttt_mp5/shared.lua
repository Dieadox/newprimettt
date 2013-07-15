

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "MP5 Navy"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_mp5"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Recoil		= 0.4
SWEP.Primary.Delay 		= 0.076
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage		= 18
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.M249 = true
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 65
SWEP.ViewModel			= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound 		= Sound("NP_MP5.Single")

SWEP.IronSightsPos = Vector(4.75, -2, 1.9)
SWEP.IronSightsAng = Vector(1, 0, 0)