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

		for i = 1, 32 do
			
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(150, 200)))
				particle:SetDieTime(math.Rand(0.1, 0.15))
				particle:SetStartAlpha(255)
				particle:SetStartSize(2.5)
				particle:SetEndSize(0)
				particle:SetRollDelta(100)
				particle:SetRoll(100)
				particle:SetGravity(Vector(0, 0, 0))
				particle:SetBounce(0.8)
				particle:SetAirResistance(375)
				particle:SetStartLength(6.5)
				particle:SetEndLength(0)
				particle:SetVelocityScale(false)
				particle:SetCollide(true)
		end

		local particle = emitter:Add("effects/muzzleflash"..math.random(3, 3), self.Position + 4 * self.Forward)

				particle:SetVelocity(0 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
				particle:SetAirResistance(160)

				particle:SetDieTime(0.1)

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)

				particle:SetStartSize(20)
				particle:SetEndSize(30)

				particle:SetRoll(math.Rand(180, 480))
				particle:SetRollDelta(math.Rand(-1, 1))

				particle:SetColor(255, 255, 255)
				
		for i = 1, 5 do

		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)

			particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(15, 20)))
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))

			particle:SetDieTime(math.Rand(1.0, 10.0))

			particle:SetStartAlpha(math.Rand(100, 150))
			particle:SetEndAlpha(0)

			particle:SetStartSize(math.Rand(2, 7))
			particle:SetEndSize(math.Rand(15, 25))

			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-0.05, 0.05))

			particle:SetColor(120, 120, 120)
			
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
