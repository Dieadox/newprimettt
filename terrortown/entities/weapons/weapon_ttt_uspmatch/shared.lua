
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName = "USP Match"
   SWEP.Slot = 1

   SWEP.EquipMenuData = {
      type = "USP Match",
      desc = "A USP Match, looks like a fiveseven to other players"
   };

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil		= 0.3
SWEP.Primary.Damage		= 27
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 16
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 16
SWEP.Primary.ClipMax = 32
SWEP.Primary.Ammo = "pistol"

SWEP.Kind = WEAPON_PISTOL
SWEP.CanBuy = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_Pistol.Single")

SWEP.IronSightsPos = Vector(-5.85, -7.795, 3.07)

SWEP.IronSightsAng = Vector(0.3, -1.3, 2)