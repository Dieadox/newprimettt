
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName = ".357 Magnum"
   SWEP.Slot = 1

   SWEP.EquipMenuData = {
      type = ".357 Magnum",
      desc = "A beast .357 Magnum, looks like a deagle to other players"
   };

   SWEP.Icon = "VGUI/ttt/icon_deagle"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil		= 3
SWEP.Primary.Damage		= 75
SWEP.Primary.Delay 		= 0.2
SWEP.Primary.Cone = 0.1
SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipMax = 18
SWEP.Primary.Ammo = "AlyxGun"

SWEP.Kind = WEAPON_PISTOL
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.HeadshotMultiplier = 1.75

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_357.Single")

SWEP.IronSightsPos 		= Vector (-4.68, -6, 0.73)
SWEP.IronSightsAng 		= Vector (-0.3, -0.2, 1.2)

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.3) or cone
end