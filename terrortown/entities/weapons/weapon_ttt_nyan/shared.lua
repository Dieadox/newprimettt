if ( SERVER ) then
	AddCSLuaFile()
	
		resource.AddFile( "materials/entities/weapon_nyangun.png" )

		resource.AddFile( "materials/nyan/selection.png" )
		resource.AddFile( "materials/nyan/cat.png" )
		resource.AddFile( "materials/nyan/cat_reversed.png" )
		resource.AddFile( "materials/nyan/cat.vmt" )
		resource.AddFile( "materials/nyan/killicon.vmt" )
		resource.AddFile( "materials/nyan/rainbow.vmt" )

		resource.AddFile( "sound/weapons/nyan/nya1.wav" )
		resource.AddFile( "sound/weapons/nyan/nya2.wav" )

		resource.AddFile( "sound/weapons/nyan/nyan_loop.wav" )
		resource.AddFile( "sound/weapons/nyan/nyab_beat.wav" )
end
		
if ( CLIENT ) then
	SWEP.Slot = 7
	
	   SWEP.EquipMenuData = {
      type = "Nyan Gun",
      desc = "Kill people with nyan cats!"
   };

   SWEP.Icon = "VGUI/ttt/icon_nyanalpha"
end

SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "Nyan Gun"
SWEP.Category = "Robotboy655's Weapons"
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.HoldType = "smg"

SWEP.Primary.Recoil		= 0.5
SWEP.Primary.ClipSize = 60
SWEP.Primary.Delay = 0.093
SWEP.Primary.Cone = 0
SWEP.Primary.ClipMax = 180
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

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
		self:EmitSound( "weapons/nyan/nya" .. math.random( 1, 2 ) .. ".wav", 500, math.random ( 85, 99 ) )
	else
		if ( self.LoopSound ) then
			self.LoopSound:ChangeVolume( 1, 0.1 )
		else
			self.LoopSound = CreateSound( self.Owner, Sound( "weapons/nyan/nyan_loop.wav" ) )
			if ( self.LoopSound ) then self.LoopSound:Play() end
		end
		if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 0, 0.1 ) end
	end
	
	self:TakePrimaryAmmo( 1 )

	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.025, 0.01, 0 )
	bullet.Tracer = 1
	bullet.Force = 200
	bullet.Damage = 17
	//bullet.AmmoType = "Ar2AltFire" -- For some extremely stupid reason this breaks the tracer effect
	bullet.TracerName = "rb655_nyan_tracer"
	self.Owner:FireBullets( bullet )

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	self:EmitSound( "weapons/nyan/nya" .. math.random( 1, 2 ) .. ".wav", 500, math.random ( 85, 99 ) )

	self:TakePrimaryAmmo( 5 )
	
	local bullet = {}
	bullet.Num = 5
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.10, 0.1, 0 )
	bullet.Tracer = 1
	bullet.Force = 200
	bullet.Damage = 20
	//bullet.AmmoType = "Ar2AltFire"
	bullet.TracerName = "rb655_nyan_tracer"
	self.Owner:FireBullets( bullet )

	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
end

function SWEP:Reload()
   self.Weapon:DefaultReload(self.ReloadAnim)
   self:SetIronsights( false )
end

function SWEP:DoImpactEffect( trace, damageType )
	local effectdata = EffectData()
	effectdata:SetStart( trace.HitPos )
	effectdata:SetOrigin( trace.HitNormal + Vector( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ) )
	util.Effect( "rb655_nyan_bounce", effectdata )

	return true
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

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

	if ( CLIENT ) then return true end

	self.BeatSound = CreateSound( self.Owner, Sound( "weapons/nyan/nyan_beat.wav" ) )
	if ( self.BeatSound ) then self.BeatSound:Play() end

	return true
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

if ( SERVER ) then return end

--------------------------------------------------------------------------------------

local EFFECT = {}

local Cat = Material( "nyan/cat" )
local Rainbow = Material( "nyan/rainbow" )

function EFFECT:Init( data )
	self.StartPos = data:GetStart()
	self.Direction = data:GetOrigin()

	self.Dist = math.random( 32, 64 )
	self.EndPos = self.StartPos + self.Direction * self.Dist
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.LifeTime = 1
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
	render.DrawBeam( self.StartPos, a, v2 * 6, 0, self.StartPos:Distance( self.EndPos ) / 10, Color( 255, 255, 255, v2 * 255 ) )
	render.SetMaterial( Cat )
	render.DrawBeam( a + self.Direction * 8, a + self.Direction * -8, 16, 0, 1, Color( 255, 255, 255, math.min( ( v2 * 3 ) * 200, 255 ) ) )
end


effects.Register( EFFECT, "rb655_nyan_bounce" )

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
	
	self.LifeTime = 1 - ( 1 / self.Dist )
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	if ( CurTime() > self.DieTime ) then return false end
	return true
end

function EFFECT:Render()
	local v1 = ( CurTime() - self.DieTime ) / self.LifeTime
	local v2 = ( self.DieTime - CurTime() ) / self.LifeTime
	local a = self.EndPos - self.Dir * math.min( 1 - ( v1 * self.Dist ), self.Dist )

	render.SetMaterial( Rainbow )
	render.DrawBeam( a, self.EndPos, v2 * 6, 0, self.Dist / 10, Color( 255, 255, 255, v2 * 255 ) )
end

effects.Register( EFFECT, "rb655_nyan_tracer" )