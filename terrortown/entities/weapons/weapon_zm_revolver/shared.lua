if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "revolver"

if CLIENT then
   SWEP.PrintName			= "Desert Eagle"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ttt/icon_deagle"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo       = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil		= 0.75
SWEP.Primary.Damage		= 35
SWEP.Primary.Delay 		= 0.27
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 8
SWEP.Primary.ClipMax = 36
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 5

SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.Primary.Sound			= Sound( "NP_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 55
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos = Vector(-6.36, -3, 2.0)
SWEP.IronSightsAng = Vector(0.5, 0, 0)
