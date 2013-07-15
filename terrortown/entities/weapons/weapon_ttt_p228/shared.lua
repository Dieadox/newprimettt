

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"


if CLIENT then

   SWEP.PrintName			= "P228"
   SWEP.Slot				= 1

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Recoil	= 0.5
SWEP.Primary.Damage = 16
SWEP.Primary.Delay = 0.15
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 36
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Pistol = true
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound 		= Sound("NP_P228.Single")

SWEP.IronSightsPos = Vector(-5.97, -4, 2.799)
SWEP.IronSightsAng = Vector(0, -0.05, 0.5)