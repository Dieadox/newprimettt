
------------------------
---Server/Client Info---
------------------------
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
   SWEP.PrintName = "Pulse Rifle"
   SWEP.Slot      = 2
   SWEP.Icon = "VGUI/ttt/icon_skull"
   SWEP.ViewModelFOV = 72
   SWEP.EquipMenuData = {
      type = "Pulse Rifle",
      desc = "Combine Pulse Rifle, Taken from the world of Half Life 2. Does ALOT of damage"
   };
end

-----------------
---Weapon Info---
-----------------
SWEP.Base = "weapon_tttbase"

SWEP.Primary.Damage = 26
SWEP.Primary.Delay = 0.09
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil		= 0.4
SWEP.HeadshotMultiplier = 1.25

SWEP.AR2 = true

SWEP.Tracer = "AR2Tracer"

----------------
---Model Info---
----------------
SWEP.HoldType = "ar2"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_irifle.mdl"
SWEP.WorldModel			= "models/weapons/w_irifle.mdl"
SWEP.IronSightsPos 		= Vector (-5.86, -6.4377, 1.2)
SWEP.IronSightsAng 		= Vector (1.1388, -0.6003, 0)

----------------
---Sound Info---
----------------
SWEP.Primary.Sound 		= Sound("Weapon_AR2.Single")
SWEP.Primary.Reload 		= Sound("Weapon_AR2.Reload")

-------------------
---TTT Variables---
-------------------
SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_AR2
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = false