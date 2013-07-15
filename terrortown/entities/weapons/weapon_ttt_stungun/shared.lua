if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName = "P90 Prototype"
   SWEP.Slot      = 6

   SWEP.Icon = "VGUI/ttt/icon_ump"

   SWEP.ViewModelFOV = 72

   SWEP.EquipMenuData = {
      type = "P90 Prototype",
      desc = "Shoots faster then a regular P90, And has electro bullets"
   };
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_STUN
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = false

SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.056
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 50
SWEP.Primary.ClipMax = 100
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil		= 0.4
SWEP.Primary.Sound 		= Sound("NP_P90.Single")
SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.Pistol = false
SWEP.Shotgun = false
SWEP.Rifle = true
SWEP.Sniper = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.HeadshotMultiplier = 2 -- brain fizz

SWEP.IronSightsPos 		= Vector(0, 0, 0)
SWEP.IronSightsAng 		= Vector(0, 0, 0)

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   -- 10% accuracy bonus when sighting
   cone = sights and (cone * 0.9) or cone

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.Force  = 5
   bullet.Damage = dmg

   bullet.Callback = function(att, tr, dmginfo)
                        if SERVER or (CLIENT and IsFirstTimePredicted()) then
                           local ent = tr.Entity
                           if (not tr.HitWorld) and IsValid(ent) then
                              local edata = EffectData()

                              edata:SetEntity(ent)
                              edata:SetMagnitude(3)
                              edata:SetScale(2)

                              util.Effect("TeslaHitBoxes", edata)

                              if SERVER and ent:IsPlayer() then
                                 local eyeang = ent:EyeAngles()

                                 local j = 10
                                 eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
                                 eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
                                 ent:SetEyeAngles(eyeang)
                              end
                           end
                        end
                     end


   self.Owner:FireBullets( bullet )
   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   -- Owner can die after firebullets, giving an error at muzzleflash
   if not IsValid(self.Owner) or not self.Owner:Alive() then return end

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted() )) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.75) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )

   end
end

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(35, 0.3)
       else
          self.Owner:SetFOV(0, 0)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope = surface.GetTextureID("scope/scope_reddot")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2
         local y = ScrH() / 2
         local scope_size = ScrH() / 1

         -- crosshair
         local gap = 1000
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 0
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
		 surface.SetDrawColor(10, 10, 10, 255)
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.4) or nil
   end
end