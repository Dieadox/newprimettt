/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	self.WeaponEnt 		= data:GetEntity()
	self.Attachment 		= data:GetAttachment()
	
	self.Position 		= self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward 		= data:GetNormal()
	self.Angle 			= self.Forward:Angle()
	self.Right 			= self.Angle:Right()
	self.Up 			= self.Angle:Up()
	
	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter 		= ParticleEmitter(self.Position)
			
		for i = 1, 12 do
			
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(200, 300)))
				particle:SetDieTime(math.Rand(0.05, 0.1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(1)
				particle:SetEndSize(0)
				particle:SetRollDelta(100)
				particle:SetRoll(100)
				particle:SetGravity(Vector(0, 0, 0))
				particle:SetBounce(0.8)
				particle:SetAirResistance(375)
				particle:SetStartLength(5)
				particle:SetEndLength(0)
				particle:SetVelocityScale(false)
				particle:SetCollide(true)
		end
				

	emitter:Finish()
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()

	return false
end

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
end
