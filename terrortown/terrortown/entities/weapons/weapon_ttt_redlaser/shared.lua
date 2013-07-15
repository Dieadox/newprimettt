if ( SERVER ) then
	AddCSLuaFile()
end
		
if ( CLIENT ) then
	SWEP.Slot = 2
    SWEP.Icon = "VGUI/ttt/icon_shotgun"
	
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Prototype M3 Shotgun, shoots lasers."
   };
end

SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "Shotgun T-900"
SWEP.ViewModel			= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.IronSightsPos = Vector(-7.65, -4.898, 3.23)
SWEP.IronSightsAng = Vector(0.6, 0, 0)
SWEP.AutoSpawnable = false
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.HoldType = "shotgun"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_AK47

SWEP.Primary.Delay 		= 1
SWEP.Primary.Recoil		= 2
SWEP.Primary.ClipSize = 24
SWEP.Primary.Cone = 0
SWEP.Primary.ClipMax = 48
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.AmmoEnt = "item_box_shotgun_ttt"

SWEP.Primary.Sound 		= Sound("NP_M3.Single")

SWEP.Secondary.Recoil		= 0.5
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Delay = 0.5
SWEP.Secondary.Cone = 0
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	if (self.Owner:IsNPC()) then
		self:EmitSound( ("NP_M3.Single"), 100, 99 )
		util.Effect("effect_mad_laser", effectdata)
	else
		self:EmitSound( ("NP_M3.Single"), 100, 99 )
	end
	
	self:TakePrimaryAmmo( 1 )

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
	
	local bullet = {}
	bullet.Num = 8
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.05, 0.05, 1 )
	bullet.Tracer = 1
	bullet.Force = 0
	bullet.Damage = 15
	bullet.TracerName = "redlaser_tracer"
	self.Owner:FireBullets( bullet )

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	util.Effect("effect_mad_laser", effectdata)
	
	self.Primary.Recoil		= 2
	
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.1,-0.15) * self.Primary.Recoil, math.Rand(-0.1,0.15) *self.Primary.Recoil, 0.05 ) )
end

function SWEP:Reload()
   self.Weapon:DefaultReload(self.ReloadAnim)
   self:SetIronsights( false )
end

function SWEP:FireAnimationEvent( pos, ang, event )
	return true
end

function SWEP:KillSounds()
	if ( self.BeatSound ) then self.BeatSound:Stop() self.BeatSound = nil end
	if ( self.LoopSound ) then self.LoopSound:Stop() self.LoopSound = nil end
end

function SWEP:OnRemove()
	self:KillSounds()
end

function SWEP:OnDrop()
	self:KillSounds()
end

function SWEP:Holster()
	self:KillSounds()
	return true
end

function SWEP:Think()
	if ( self.Owner:IsPlayer() && ( self.Owner:KeyReleased( IN_ATTACK ) || !self.Owner:KeyDown( IN_ATTACK ) ) ) then
		if ( self.LoopSound ) then self.LoopSound:ChangeVolume( 0, 0.1 ) end
		if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 1, 0.1 ) end
	end
end

function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(55, 0.25)
       else
          self.Owner:SetFOV(0, 0.25)
       end
    end
end

if ( SERVER ) then return end

--------------------------------------------------------------------------------------

local EFFECT = {}

local Cat = Material( "" )
local Rainbow = Material( "trails/laser.vmt" )

function EFFECT:Init( data )
	self.StartPos = data:GetStart()
	self.Direction = data:GetOrigin()

	self.Dist = math.random( 32, 64 )
	self.EndPos = self.StartPos + self.Direction * self.Dist
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.LifeTime = 0
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	if ( CurTime() > self.DieTime ) then return false end
	return true
end

function EFFECT:Render()
	local v1 = ( CurTime() - self.DieTime ) / self.LifeTime
	local v2 = ( self.DieTime - CurTime() ) / self.LifeTime
	local a = self.EndPos + self.Direction * math.min( v1 * self.Dist, 0 )

	render.SetMaterial( Rainbow )
	render.DrawBeam( self.StartPos, a, v2 * 6, 0, self.StartPos:Distance( self.EndPos ) / 10, Color( 255, 25, 0, v2 * 255 ) )
	render.SetMaterial( Cat )
	render.DrawBeam( a + self.Direction * 4, a + self.Direction * -8, 16, 0, 1, Color( 255, 25, 0, math.min( ( v2 * 3 ) * 200, 255 ) ) )
end

--------------------------------------------------------------------------------------

local EFFECT = {}

function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.Dir = ( self.EndPos - self.StartPos ):GetNormalized()
	self.Dist = self.StartPos:Distance( self.EndPos )
	
	self.LifeTime = 0.05 - ( 0.05 / self.Dist )
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	if ( CurTime() > self.DieTime ) then return false end
	return true
end

function EFFECT:Render()
	local v1 = ( CurTime() - self.DieTime ) / self.LifeTime
	local v2 = ( self.DieTime - CurTime() ) / self.LifeTime
	local a = self.EndPos - self.Dir * math.min( 0 - ( v1 * self.Dist ), self.Dist )

	render.SetMaterial( Rainbow )
	render.DrawBeam( a, self.EndPos, v2 * 6, 10, self.Dist / 0, Color( 255, 25, 0, v2 * 255 ) )
end

effects.Register( EFFECT, "redlaser_tracer" )