if SERVER then
   AddCSLuaFile( "shared.lua" )
end
 
SWEP.HoldType           = "ar2"
 
if CLIENT then
   SWEP.PrintName          = "Headcrab Infector"
   SWEP.ViewModelFlip		= true
   SWEP.ViewModelFov		= 50
   SWEP.Slot               = 6
 
   SWEP.Icon = "VGUI/ttt/icon_zomb"
         SWEP.EquipMenuData = {
      type="Weapon",
      model="models/weapons/w_snip_scout.mdl",
      desc="Kills the target and Infects them in 15 seconds."
   };
   
end
SWEP.AutoSpawnable      = false
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
 
SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_RIFLE
 
SWEP.Primary.Delay          = 1.5
SWEP.Primary.Recoil         = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = nil
SWEP.Primary.Damage = 0
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1-- keep mirrored to ammo
SWEP.Primary.DefaultClip = 1
 
SWEP.HeadshotMultiplier = 4
 
SWEP.AmmoEnt = "nil"
SWEP.ViewModel          = Model("models/weapons/v_snip_scout.mdl")
SWEP.WorldModel         = Model("models/weapons/w_snip_scout.mdl")
 
SWEP.Primary.Sound = Sound("NP_USP.Silenced")
 
SWEP.Secondary.Sound = Sound("Default.Zoom")
 
SWEP.IronSightsPos      = Vector(5, -30, 2.5)
SWEP.IronSightsAng      = Vector(0, 0, 0)
 
SWEP.ZoomAmount         = 35
SWEP.ZoomTime           = 0.5
 
function SWEP:PrimaryAttack(worldsnd)
 
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
   if not self:CanPrimaryAttack() then return end
 
   if not worldsnd then
      self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end
 
   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
 
   self:TakePrimaryAmmo( 1 )
 
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
 
   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end
 
 
function SWEP:ShootBullet( dmg, recoil, numbul, cone )
 
        function damage(t)
                t:TakeDamage(5)
        end
 
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
                                                                timer.Simple(4.9, function() spot = ent:GetPos() zed = ents.Create("npc_headcrab_fast")end)
																timer.Simple(5,function() damage(ent);
                                                                if SERVER then
--local ply = self.Owner -- The first entity is always the first player
 
zed:SetPos(spot) -- This positions the zombie at the place our trace hit.
zed:Spawn() -- This method spawns the zombie into the world, run for your lives! ( or just crowbar it dead(er) )
                                                                        ent:Kill()
                                                                        end
                                                                end) --20
                                                               
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
      recoil = sights and (recoil * 0.5) or recoil
 
   end
end
 
 
 
function SWEP:SetZoom(state)
    if CLIENT then
       return
    else
       if state then
          self.Owner:SetFOV(25, 0.3)
       else
          self.Owner:SetFOV(0, 0.1)
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
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()
 
         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
 
         gap = 0
         length = 100
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
 
 
         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
 
         surface.SetDrawColor(0, 0, 0, 255)
 
         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)
 
         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
 
      else
         return self.BaseClass.DrawHUD(self)
      end
   end
 
   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end