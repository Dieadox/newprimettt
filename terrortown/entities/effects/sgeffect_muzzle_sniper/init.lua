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

		for i = 1, 5 do
	
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 3) * math.Rand(50, 100)))
				particle:SetDieTime(math.Rand(0.1,0.1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(1)
				particle:SetEndSize(0)
				particle:SetRoll(0)
				particle:SetGravity(Vector(0, 0, 0))
				particle:SetCollide(false)
				particle:SetBounce(0.8)
				particle:SetAirResistance(375)
				particle:SetStartLength(2.5)
				particle:SetEndLength(0)
				particle:SetVelocityScale(false)
		end
			
		for i = 1, 3 do
			
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)

			particle:SetVelocity(((self.Forward + VectorRand() * 1) * math.Rand(50, 100)))
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))

			particle:SetDieTime(math.Rand(1.0, 2.0))

			particle:SetStartAlpha(25)
			particle:SetEndAlpha(0)

			particle:SetStartSize(math.Rand(5, 7))
			particle:SetEndSize(math.Rand(20, 25))

			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-0.05, 0.05))
			particle:SetColor(255, 255, 255)
		end

		local particle = emitter:Add("effects/ttt/sg_flash"..math.random(1, 4), self.Position + 0 * self.Forward)

			particle:SetVelocity(0 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
			particle:SetAirResistance(160)

			particle:SetDieTime(0.07)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(15)
			particle:SetEndSize(15)

			particle:SetRoll(math.Rand(180, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)

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
