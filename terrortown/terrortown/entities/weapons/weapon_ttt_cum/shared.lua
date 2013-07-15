 
if SERVER then
	
	AddCSLuaFile ("shared.lua")
 
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then

	SWEP.PrintName = "Semen Launcher"
	SWEP.Slot = 7
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
 
end
 
SWEP.Base = "weapon_tttbase"
SWEP.Author = "Tenshi"
SWEP.Contact = "zvwv@live.co.uk"
SWEP.Purpose = "Launch hot white stuff at those you hate, or love, whatever."
SWEP.Instructions = "Primary Attack to bust those nuts"
 
SWEP.Category = "Tenshi"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0.5
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
 
local ShootSound = Sound("vo/ravenholm/engage03.wav")
 
local HitSounds = {"vo/k_lab/ba_guh.wav",
"ambient/voices/m_scream1.wav",
"vo/coast/odessa/male01/nlo_cubdeath01.wav",
"vo/npc/male01/answer20.wav",
"vo/npc/male01/answer39.wav",
"vo/npc/male01/fantastic01.wav",
"vo/npc/male01/goodgod.wav",
"vo/npc/male01/gordead_ans05.wav",
"vo/npc/male01/gordead_ans04.wav",
"vo/npc/male01/gordead_ans19.wav",
"vo/npc/male01/ohno.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pardonme01.wav",
"vo/npc/male01/stopitfm.wav",
"vo/npc/male01/uhoh.wav",
"vo/npc/male01/vanswer01.wav",
"vo/npc/male01/vanswer14.wav",
"vo/npc/male01/watchwhat.wav",
"vo/trainyard/male01/cit_hit01.wav",
"vo/trainyard/male01/cit_hit02.wav",
"vo/trainyard/male01/cit_hit03.wav",
"vo/trainyard/male01/cit_hit04.wav",
"vo/trainyard/male01/cit_hit05.wav"}



/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()
	
    self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( (self.Owner:GetPos() + Vector(0,0,23)) + (self.Owner:GetForward() * 5))
		effectdata:SetAngles( self.Owner:GetAngles() )
	util.Effect( "Sementrail", effectdata )
	
	self.Weapon:EmitSound( ShootSound, 100, math.random(100,110) )
	//self.BaseClass.ShootEffects( self )
	
	if tr.Hit then
		util.Decal("BirdPoop",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		if tr.HitNonWorld then
			if tr.Entity:IsPlayer() then
				tr.Entity:SetNWFloat("cum",(tr.Entity:GetNWFloat("cum") or 1) + 1)
				local rand = math.random(1,5)
				if rand == 5 then
					tr.Entity:EmitSound(Sound(HitSounds[math.random(1,table.Count(HitSounds))]),100,math.random(95,105))
				end
			end
		end
	end
	
end