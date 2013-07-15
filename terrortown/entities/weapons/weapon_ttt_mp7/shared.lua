if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "smg1"

if CLIENT then
   SWEP.PrintName = "MP7"
   SWEP.Slot = 2

   SWEP.EquipMenuData = {
      type = "MP7",
      desc = "A sleek MP7 from the Half Life 2 Universe, looks like a Mac-10 to other players"
   };

   SWEP.Icon = "VGUI/ttt/icon_mac"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil		= 0.5
SWEP.Primary.Damage		= 22
SWEP.Primary.Delay 		= 0.066
SWEP.Primary.Cone = 0.035
SWEP.Primary.ClipSize = 45
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 45
SWEP.Primary.ClipMax = 90
SWEP.Primary.Ammo = "smg1"
SWEP.HeadshotMultiplier = 1.25

SWEP.Kind = WEAPON_HEAVY
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_SMG1.Single")

SWEP.IronSightsPos 		= Vector (-6.43, -3.32, 1.02)
SWEP.IronSightsAng 		= Vector (0, 0, 0)