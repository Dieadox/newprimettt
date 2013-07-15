
------------------------
---Server/Client Info---
------------------------
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
   SWEP.PrintName          = "AWP"
   SWEP.Slot               = 7
   SWEP.Icon = "VGUI/ttt/icon_scout"
   SWEP.EquipMenuData = {
      type = "AWP",
      desc = "The AWP is the largest and most powerful sniper rifle, killing in one shot."
   };
end

-----------------
---Weapon Info---
-----------------
SWEP.Base               = "weapon_tttbase"

SWEP.Primary.Delay 		= 2.25
SWEP.Primary.Recoil		= 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SniperPenetrated"
SWEP.Primary.Damage		= 1000
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = 3
SWEP.Primary.ClipMax = 0
SWEP.Primary.DefaultClip = 3
SWEP.AutoSpawnable      = true
SWEP.HeadshotMultiplier = 4
SWEP.DeploySpeed = 0.8

SWEP.Pistol = false
SWEP.Shotgun = false
SWEP.Rifle = false
SWEP.Sniper = true

----------------
---Model Info---
----------------
SWEP.HoldType           = "ar2"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

----------------
---Sound Info---
----------------
SWEP.Primary.Sound 		= Sound("new_prime/weaponsv2/awp/awp1.wav")
SWEP.Secondary.Sound = Sound("Default.Zoom")

-------------------
---TTT Variables---
-------------------
SWEP.LimitedStock = true -- only buyable once
SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_RIFLE
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

-------------------------
---Special Weapon Info---
-------------------------

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(25, 0.3)
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
   local scope = surface.GetTextureID("scope/gdcw_scopesight")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2
         local y = ScrH() / 2
         local scope_size = ScrH()

         -- crosshair
         local gap = 1000
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 1000
         length = 1000
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2

         surface.SetDrawColor(255, 0, 0, 100)

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

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0) or cone
end