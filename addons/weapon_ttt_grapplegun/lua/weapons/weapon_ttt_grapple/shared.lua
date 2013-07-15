SWEP.Base = "weapon_tttbase"
SWEP.Author			= "Darkfortune"
SWEP.Contact		= "Darkfortune202@gmail.com"
SWEP.Purpose		= "The Spiderman's Swep!"
SWEP.Instructions	= "Left click to fire a rope"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_EQUIP
SWEP.PrintName			= "Grapple Hook"
SWEP.Icon = "VGUI/ttt/icon_crossbow"		
SWEP.Slot				= 7
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"

SWEP.Primary.Delay 		= 2

local sndPowerUp			= Sound("rope_hit.wav")
local sndPowerDown		= Sound ("shoot_rope.wav")
local sndTooFar			= Sound ("to_far.wav")

function SWEP:Initialize()

	nextshottime = CurTime()
	self:SetWeaponHoldType( "crossbow" )
	
end

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL) then return end
	
	if ( self.Owner:KeyPressed( IN_ATTACK ) ) then
	
		self:StartAttack()
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) && inRange ) then
	
		self:UpdateAttack()
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) && inRange ) then
	
		self:EndAttack( true )
	
	end
	
	if ( self.Owner:KeyPressed( IN_ATTACK2 ) ) then
	
		self:Attack2()
		
	end

end

function SWEP:DoTrace( endpos )
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 14096)
		if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
		trace.filter = { self.Owner, self.Weapon }
		
	self.Tr = nil
	self.Tr = util.TraceLine( trace )
end

function SWEP:StartAttack()
	local gunPos = self.Owner:GetShootPos()
	local disTrace = self.Owner:GetEyeTrace()
	local hitPos = disTrace.HitPos
	
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
	
	local distanceCvar = GetConVarNumber("rope_distance")
	inRange = false
	if distance <= distanceCvar then
		inRange = true
	end
	
	if inRange then
		if (SERVER) then
			
			if (!self.Beam) then
				self.Beam = ents.Create( "rope" )
					self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
		
		end
		
		self:DoTrace()
		self.speed = 10000
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dt = -1
		
		if (SERVER && self.Beam) then
			self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
		end
		
		self:UpdateAttack()
		
		self.Weapon:EmitSound( sndPowerDown )
	else
		self.Weapon:EmitSound( sndTooFar )
	end
end

function SWEP:UpdateAttack()

	self.Owner:LagCompensation( true )
	
	if (!endpos) then endpos = self.Tr.HitPos end
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( endpos )
	end

	lastpos = endpos
	
	
			if ( self.Tr.Entity:IsValid() ) then
			
					endpos = self.Tr.Entity:GetPos()
					if ( SERVER ) then
					self.Beam:GetTable():SetEndPos( endpos )
					end
			
			end
			
			local vVel = (endpos - self.Owner:GetPos())
			local Distance = endpos:Distance(self.Owner:GetPos())
			
			local et = (self.startTime + (Distance/self.speed))
			if(self.dt != 0) then
				self.dt = (et - CurTime()) / (et - self.startTime)
			end
			if(self.dt < 0) then
				self.Weapon:EmitSound( sndPowerUp )
				self.dt = 0
			end
			
			if(self.dt == 0) then
			zVel = self.Owner:GetVelocity().z
			vVel = vVel:GetNormalized()*(math.Clamp(Distance,0,7))
				if( SERVER ) then
				local gravity = GetConVarNumber("sv_Gravity")
				vVel:Add(Vector(0,0,(gravity/100)*1.5))
				if(zVel < 0) then
					vVel:Sub(Vector(0,0,zVel/100))
				end
				self.Owner:SetVelocity(vVel)
				end
			end
	
	endpos = nil
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:EndAttack( shutdownsound )
	
	if ( shutdownsound ) then
		self.Weapon:EmitSound( sndPowerDown )
	end
	
	if ( CLIENT ) then return end
	if ( !self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	
end

function SWEP:Attack2()
			

	if (CLIENT) then return end
		local CF = self.Owner:GetFOV()
		if CF == 90 then
			self.Owner:SetFOV(30,.3)
		elseif CF == 30 then
			self.Owner:SetFOV(90,.3)
	end
end

function SWEP:Holster()
	self:EndAttack( false )
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end


function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end
-- TTT STUFF-----------------------------------------------
SWEP.Base = "weapon_tttbase"	
SWEP.Kind = WEAPON_EQUIP1	
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE } 		
SWEP.Icon = "materials/VGUI/ttt/icon_wd_grapplegun.vtf"					
SWEP.LimitedStock = true		
SWEP.EquipMenuData = {	
  type = "item_weapon",		
  name = "Grapple Gun",  	
  desc = "Fly around and shit"	
};
SWEP.AllowDrop = false	
SWEP.NoSights = true		
	
if SERVER then
   AddCSLuaFile()
   resource.AddFile("materials/VGUI/ttt/GrappleGunWD.vmt")
end
