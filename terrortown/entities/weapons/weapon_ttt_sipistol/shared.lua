
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName = "sipistol_name"
   SWEP.Slot = 6

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "sipistol_desc"
   };

   SWEP.Icon = "VGUI/ttt/icon_silenced"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 0.3
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 80
SWEP.Primary.Ammo = "Pistol"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.HeadshotMultiplier = 1.75

SWEP.IsSilent = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound 		= Sound("NP_USP.Silenced")
SWEP.Primary.SoundLevel = 45

SWEP.IronSightsPos = Vector(-5.87, -2, 2.69)
SWEP.IronSightsAng = Vector(0, 0.1, 0)

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self.Owner
      buyer:GiveAmmo( 20, "Pistol" )
   end
end

