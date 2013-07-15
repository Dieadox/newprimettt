-- Poison Box
if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "VGUI/ttt/icon_health"
   ENT.PrintName = "hstation_name"

   local GetPTranslation = LANG.GetParamTranslation

   ENT.TargetIDHint = {
      name = "hstation_name",
      hint = "hstation_hint",
      fmt  = function(ent, txt)
                return GetPTranslation(txt,
                                       { usekey = Key("+use", "USE"),
                                         num    = ent:GetStoredHealth() or 0 } )
             end
   };

end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/microwave.mdl")

ENT.CanUseKey = true
ENT.CanHavePrints = true
ENT.MaxHeal = 25
ENT.MaxStored = 200
ENT.RechargeRate = 1
ENT.RechargeFreq = 2 -- in seconds

AccessorFuncDT(ENT, "StoredHealth", "StoredHealth")

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "StoredHealth")
end

function ENT:Initialize()
   self.Entity:SetModel(self.Model)

   self.Entity:PhysicsInit(SOLID_VPHYSICS)
   self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
   self.Entity:SetSolid(SOLID_VPHYSICS)
   self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
   if SERVER then
      self.Entity:SetMaxHealth(200)

      local phys = self.Entity:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(200)
      end
   end
   self.Entity:SetHealth(200)

   self.Entity:SetColor(180, 180, 255, 255)

   self:SetStoredHealth(200)

   self.fingerprints = {}
end

function ENT:UseOverride(activator)
   if ValidEntity(activator) and activator:IsPlayer() and activator:IsActive() then
      self:GiveHealth(activator)
   end
end

function ENT:AddToStorage(amount)
   self:SetStoredHealth(math.min(self.MaxStored, self:GetStoredHealth() + amount))
end

function ENT:TakeFromStorage(amount)
   -- if we only have 5 healthpts in store, that is the amount we heal
   amount = math.min(amount, self:GetStoredHealth())
   self:SetStoredHealth(math.max(0, self:GetStoredHealth() - amount))
   return amount
end

local healsound = Sound("items/medshot4.wav")
local failsound = Sound("items/medshotno1.wav")
function ENT:GiveHealth(ply)
   if self:GetStoredHealth() > 0 and not ply:IsActiveTraitor() then
		-- constant clamping, no risks
		local healed = self:TakeFromStorage(math.min(self.MaxHeal, dmg))
		local new = ply:Health() - healed

		-- Set health
			ply:SetHealth( new )

		-- Poison
		ply.poisoned = {
		['attacker'] = self:GetOwner(),
		['inflictor'] = self
		}

		self:EmitSound(healsound)

		if not table.HasValue(self.fingerprints, ply) then
		   table.insert(self.fingerprints, ply)
		end
   else
      	self:EmitSound(failsound)
   end
end

-- traditional equipment destruction effects
function ENT:OnTakeDamage(dmginfo)
   if dmginfo:GetAttacker() == self:GetOwner() then return end

   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   if self:Health() < 0 then
      self:Remove()

      util.EquipmentDestroyed(self:GetPos())

      if IsValid(self:GetOwner()) then
         LANG.Msg(self:GetOwner(), "hstation_broken")
      end
   end
end

if SERVER then
   -- recharge
   local nextcharge = 0
   function ENT:Think()
      if nextcharge < CurTime() then
         self:AddToStorage(self.RechargeRate)

         nextcharge = CurTime() + self.RechargeFreq
      end
   end
end

