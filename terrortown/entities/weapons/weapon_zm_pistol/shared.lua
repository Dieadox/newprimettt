
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "pistol"
   

if CLIENT then
   SWEP.PrintName = "Five Seven"
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL
SWEP.InLoadoutFor = { ROLE_INNOCENT }

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil		= 0.6
SWEP.Primary.Damage		= 13
SWEP.Primary.Delay 		= 0.13
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel  = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound = Sound( "NP_P228.Single" )
SWEP.IronSightsPos 		= Vector (-5.91, -4.52, 2.985)
SWEP.IronSightsAng 		= Vector (-0.3, 0.1, 0)
