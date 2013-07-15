
------------------------
---Server/Client Info---
------------------------
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "AK-47"
	SWEP.Slot				= 2
	SWEP.Icon = "VGUI/ttt/icon_m16"
end

-----------------
---Weapon Info---
-----------------
SWEP.Base				= "weapon_tttbase"

SWEP.Primary.Delay 		= 0.092
SWEP.Primary.Recoil		= 0.9
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 25
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.HeadshotMultiplier = 1.25
SWEP.AmmoEnt = "item_ammo_smg1_ttt"


----------------
---Model Info---
----------------
SWEP.HoldType			= "ar2"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.IronSightsPos = Vector(-6.59, -6.473, 2.32)
SWEP.IronSightsAng = Vector(2.5, 0, 0.9)

----------------
---Sound Info---
----------------
SWEP.Primary.Sound 		= Sound("NP_AK47.Single")

-------------------
---TTT Variables---
-------------------
SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_AK47