if SERVER then
   AddCSLuaFile( "shared.lua" )
end
 
SWEP.HoldType           = "pistol"
 
if CLIENT then
   SWEP.PrintName           = "Poison Dart"
   SWEP.Author              = "TTT"
   SWEP.Slot                = 6
   SWEP.SlotPos         = 0
 
   SWEP.EquipMenuData = {
      type="Weapon",
      --model="models/weapons/w_pist_usp.mdl",
      desc="Shoot someone to poison him."
   };
 
   SWEP.Icon = "VGUI/ttt/icon_poison_dart"
end
 
SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 1
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 0.0
SWEP.Primary.ClipSize = 3
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 3
SWEP.Primary.ClipMax = 3
SWEP.Primary.Ammo = "" --"Pistol"
 
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
--SWEP.WeaponID = AMMO_SIPISTOL
 
SWEP.AmmoEnt = "" --"item_ammo_pistol_ttt"
 
SWEP.IsSilent = true
SWEP.LimitedStock = true
SWEP.NoSights = true
 
SWEP.ViewModel          = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel         = "models/weapons/w_pist_usp.mdl"
 
SWEP.Primary.Sound = Sound( "NP_USP.Silenced" )
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
 
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
 
function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end
 
--[[-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self.Owner
      buyer:GiveAmmo( 16, "Pistol" )
   end
end]]
function SWEP:PrimaryAttack(worldsnd)
 
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
   if not self:CanPrimaryAttack() then return end
    
   if not worldsnd then
      self.Weapon:EmitSound( self.Primary.Sound )
   else
      WorldSound(self.Primary.Sound, self:GetPos())
   end
 
 
   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone, self.Doors, self.Force, self.TracerName )
   if SERVER then
   if self.Owner:GetEyeTrace().HitNonWorld and self.Owner:GetEyeTrace().Entity:IsPlayer() then
  
   local en = self.Owner:GetEyeTrace().Entity
   local uni = en:UniqueID()
   en:EmitSound("ambient/voices/citizen_beaten" .. math.random(1,5) .. ".wav",500,100)
   timer.Create(en:UniqueID() .. "poisondart", 1, 0, function()
    
   if IsValid(en) and en:IsTerror() then
   if IsValid(self.Owner) then
   en:TakeDamage(2,self.Weapon,self.Owner)
   else
      en:TakeDamage(2,self.Weapon,self.Weapon)
   end
else
timer.Destroy(uni .. "poisondart")
end
   end)
    
   end
   end
   self:TakePrimaryAmmo( 1 )
    
   if not IsValid(self.Owner) or self.Owner:IsNPC() or (not self.Owner.ViewPunch) then return end
    
   self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
    
   if ( (game.SinglePlayer() and SERVER) or CLIENT ) then
      self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
   end
 
end