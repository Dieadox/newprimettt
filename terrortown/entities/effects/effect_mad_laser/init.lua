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
	
//	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter 		= ParticleEmitter(self.Position)

			local particle = emitter:Add("effects/combinemuzzle1", self.Position + 4 * self.Forward)

				particle:SetVelocity(0 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
				particle:SetAirResistance(160)

				particle:SetDieTime(0.1)

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)

				particle:SetStartSize(5)
				particle:SetEndSize(10)

				particle:SetColor(255, 100, 0)

			local particle = emitter:Add("effects/muzzleflash"..math.random(4, 4), self.Position + 4 * self.Forward)

				particle:SetVelocity(-1 * self.Forward + 1.1 * self.WeaponEnt:GetOwner():GetVelocity())
				particle:SetAirResistance(160)

				particle:SetDieTime(0.1)

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)

				particle:SetStartSize(10)
				particle:SetEndSize(20)

				particle:SetRoll(math.Rand(180, 480))
				particle:SetRollDelta(math.Rand(-1, 1))

				particle:SetColor(150, 0, 0)
			
		for i = 1, 5 do
			
			local particle = emitter:Add("effects/spark", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(250, 300)))
				particle:SetDieTime(math.Rand(0.1, 0.15))
				particle:SetStartAlpha(25)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetRollDelta(100)
				particle:SetRoll(100)
				particle:SetBounce(0.8)
				particle:SetStartLength(4)
				particle:SetEndLength(0)
				particle:SetVelocityScale(false)
				particle:SetCollide(true)
				particle:SetColor(255, 50, 0)
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
