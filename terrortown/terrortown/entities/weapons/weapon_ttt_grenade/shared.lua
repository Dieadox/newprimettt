
if SERVER then
   AddCSLuaFile( "shared.lua" )
   
end

SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName	 = "Frag Grenade"
   SWEP.Slot		 = 3

   SWEP.Icon = "VGUI/ttt/icon_nades"
   
         SWEP.EquipMenuData = {
      type="Weapon",
      desc="An explosive Frag Grenade."
   };
end

SWEP.Base				= "weapon_tttbasegrenade"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_MOLOTOV

SWEP.AutoSpawnable      = false
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = false -- only buyable once

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = false
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_grenade_proj"
end

