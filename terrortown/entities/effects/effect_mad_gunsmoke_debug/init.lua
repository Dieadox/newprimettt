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
	self.Up 			= self.Angle:Up() + 5
	
	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter 		= ParticleEmitter(self.Position)

			local particle = emitter:Add("effects/muzzleflash"..math.random(3, 4), self.Position + 48 * self.Forward + 24)

				particle:SetVelocity(350 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
				particle:SetAirResistance(160)

				particle:SetDieTime(0.1)

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)

				particle:SetStartSize(10)
				particle:SetEndSize(20)

				particle:SetRoll(math.Rand(180, 480))
				particle:SetRollDelta(math.Rand(-1, 1))

				particle:SetColor(255, 175, 125)	

		local particle = emitter:Add("sprites/heatwave", self.Position + 8 * self.Forward)

			particle:SetVelocity(350 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
			particle:SetAirResistance(160)

			particle:SetDieTime(0.1)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(10)
			particle:SetEndSize(20)

			particle:SetRoll(math.Rand(180, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)	
			
			particle:SetCollide(true)

		for i = 1, 1 do

		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)

			particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(15, 20)))
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))

			particle:SetDieTime(math.Rand(1.0, 10.0))

			particle:SetStartAlpha(math.Rand(100, 150))
			particle:SetEndAlpha(0)

			particle:SetStartSize(math.Rand(5, 7))
			particle:SetEndSize(math.Rand(15, 25))

			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-0.05, 0.05))

			particle:SetColor(120, 120, 120)
			
			particle:SetCollide(true)
		end
			
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
