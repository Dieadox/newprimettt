if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"


if CLIENT then
   SWEP.PrintName			= "Pain Station"
   SWEP.Slot				= 6
   SWEP.SlotPos			= 0

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type="Weapon",
      model="models/props/cs_office/microwave.mdl",
      desc="If someone uses this health station, they will be damaged."
   };

   SWEP.Icon = "VGUI/ttt/icon_health"
end

SWEP.Base = "weapon_tttbase"

SWEP.Spawnable          = true
SWEP.AdminSpawnable     = false
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/microwave.mdl"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.DrawCrosshair      = true
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

-- This is special equipment


SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_PAINSTATION

SWEP.AllowDrop = false

SWEP.NoSights = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:HealthDrop(20)
end
function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:HealthDrop()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- ye olde droppe code
function SWEP:HealthDrop()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end


      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      local health = ents.Create("ttt_pain_station")
      if IsValid(health) then
         health:SetPos(vsrc + vang * 10)
         health:SetOwner(ply)
         health:Spawn()

         health:PhysWake()
         local phys = health:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end   
         self:Remove()

         self.Planted = true
      end
   end

   self.Weapon:EmitSound(throwsound)
end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

if CLIENT then
   local hudtxt = {text="Click to place the health station", font="TabLarge", xalign=TEXT_ALIGN_RIGHT}
   function SWEP:DrawHUD()
      hudtxt.pos = {ScrW() - 80, ScrH() - 80}
      draw.Text(hudtxt)
      draw.TextShadow(hudtxt, 2)
   end
end
-- Invisible, same hacks as holstered weapon

local hidden = false
function SWEP:Deploy()
   hidden = false
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

-- not able to do DrawModel stuff in Deploy, so here's a hack
function SWEP:Think()
   if SERVER and not hidden and ValidEntity(self.Owner) and self.Owner:GetActiveWeapon() == self.Weapon then
      self.Owner:DrawViewModel(false)
      self.Owner:DrawWorldModel(false)
      hidden = true
   end
end


SWEP.AllowDrop = True