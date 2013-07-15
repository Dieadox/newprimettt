if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "M249-SAW"

   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m249"

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M249


SWEP.Primary.Damage		= 15
SWEP.Primary.Delay 		= 0.066
SWEP.Primary.Cone = 0.08
SWEP.Primary.ClipSize = 75
SWEP.Primary.ClipMax = 75
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo        = "smg1"
SWEP.AutoSpawnable      = true
SWEP.Primary.Recoil		= 0.55
SWEP.Primary.Sound			= Sound("NP_M249.Single")
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.Pistol = false
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = false
SWEP.M249 = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 55
SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.IronSightsPos = Vector(-5.94, 0, 1.96)
SWEP.IronSightsAng = Vector(0.6, 0, 0)
