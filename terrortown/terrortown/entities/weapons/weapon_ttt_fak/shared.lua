if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Flame AK-47"
	SWEP.Slot				= 2
	SWEP.Icon = "VGUI/ttt/icon_m16"
	
   SWEP.EquipMenuData = {
      type = "Flame AK-47",
      desc = "Regular AK-47 with incendiary ammo."
   };
end

-----------------
---Weapon Info---
-----------------
SWEP.Base				= "weapon_tttbase"

SWEP.Primary.Delay 		= 0.1
SWEP.Primary.Recoil		= 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 25
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.HeadshotMultiplier = 1.25

SWEP.FireM = true

----------------
---Model Info---
----------------
SWEP.HoldType			= "ar2"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.IronSightsPos = Vector(-6.59, -6.473, 2.32)
SWEP.IronSightsAng = Vector(2.5, 0, 0.9)

----------------
---Sound Info---
----------------
SWEP.Primary.Sound 		= Sound("NP_AK47.Single")

-------------------
---TTT Variables---
-------------------
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_FLARE

SWEP.Tracer = "AR2Tracer"

local function RunIgniteTimer(ent, timer_name)
   if IsValid(ent) and ent:IsOnFire() then
      if ent:WaterLevel() > 0 then
         ent:Extinguish()
      elseif CurTime() > ent.burn_destroy then
         ent:SetNotSolid(true)
         ent:Remove()
      else
         -- keep on burning
         return
      end
   end

   timer.Destroy(timer_name) -- stop running timer
end

local SendScorches

if CLIENT then
   local function ReceiveScorches(um)
      local ent = um:ReadEntity()
      local num = um:ReadChar()
      for i=1, num do
         util.PaintDown(um:ReadVector(), "FadingScorch", ent)
      end

      if IsValid(ent) then
         util.PaintDown(ent:LocalToWorld(ent:OBBCenter()), "Scorch", ent)
      end
   end
   usermessage.Hook("flare_scorch", ReceiveScorches)
else
   -- it's sad that decals are so unreliable when drawn serverside, failing to
   -- draw more often than they work, that I have to do this
   SendScorches = function(ent, tbl)
      umsg.Start("flare_scorch")
      umsg.Entity(ent)
      umsg.Char(#tbl)
      for _, p in pairs(tbl) do
         umsg.Vector(p)
      end
      umsg.End()
   end
   usermessage.Hook("flare_scorch") -- pools it
end


local function ScorchUnderRagdoll(ent)
   if SERVER then
      local postbl = {}
      -- small scorches under limbs
      for i=0, ent:GetPhysicsObjectCount()-1 do
         local subphys = ent:GetPhysicsObjectNum(i)
         if IsValid(subphys) then
            local pos = subphys:GetPos()
            util.PaintDown(pos, "FadingScorch", ent)

            table.insert(postbl, pos)
         end
      end

      SendScorches(ent, postbl)
   end

   -- big scorch at center
   local mid = ent:LocalToWorld(ent:OBBCenter())
   mid.z = mid.z + 25
   util.PaintDown(mid, "Scorch", ent)
end


function IgniteTarget(att, path, dmginfo)
   local ent = path.Entity
   if not IsValid(ent) then return end

   if CLIENT and IsFirstTimePredicted() then
      if ent:GetClass() == "prop_ragdoll" then
         ScorchUnderRagdoll(ent)
      end
      return
   end

   if SERVER then

      local dur = ent:IsPlayer() and 5 or 10

      -- disallow if prep or post round
      if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end

      ent:Ignite(dur, 100)

      ent.ignite_info = {att=dmginfo:GetAttacker(), infl=dmginfo:GetInflictor()}

      if ent:IsPlayer() then
         timer.Simple(dur + 0.1, function()
                                    if IsValid(ent) then
                                       ent.ignite_info = nil
                                    end
                                 end)

      elseif ent:GetClass() == "prop_ragdoll" then
         ScorchUnderRagdoll(ent)

         local burn_time = 6
         local tname = Format("ragburn_%d_%d", ent:EntIndex(), math.ceil(CurTime()))

         ent.burn_destroy = CurTime() + burn_time

         timer.Create(tname,
                      0.1,
                      math.ceil(1 + burn_time / 0.1), -- upper limit, failsafe
                      function()
                         RunIgniteTimer(ent, tname)
                      end)
      end
   end
end

function SWEP:ShootFlare()
   local cone = self.Primary.Cone
   local bullet = {}
   bullet.Num       = 1
   bullet.Src       = self.Owner:GetShootPos()
   bullet.Dir       = self.Owner:GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Force     = 2
   bullet.Damage    = self.Primary.Damage
   bullet.TracerName = self.Tracer
   bullet.Callback = IgniteTarget

   self.Owner:FireBullets( bullet )
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   self.Weapon:EmitSound( self.Primary.Sound )

   self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

   self:ShootFlare()

   self:TakePrimaryAmmo( 1 )
   
   	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
		
	local owner = self.Owner

   if IsValid(self.Owner) then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )
      owner:ViewPunch( Angle( math.Rand(-1,-1) * self.Primary.Recoil, math.Rand(-1,1) *self.Primary.Recoil, 0 ) )
   end

   if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
      self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
   end
end

function SWEP:SecondaryAttack()
   if self.NoSights or (not self.IronSightsPos) then return end
   --if self:GetNextSecondaryFire() > CurTime() then return end

   self:SetIronsights(not self:GetIronsights())

   self:SetNextSecondaryFire(CurTime() + 0.3)
end