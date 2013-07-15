if SERVER then
   AddCSLuaFile( "shared.lua" )
end
 
SWEP.HoldType = "pistol"
 
if CLIENT then
 
   SWEP.PrintName    = "Taser"
   SWEP.Slot         = 6
 
   SWEP.ViewModelFlip = false
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Knock someone out for 30 seconds. Only useable once. Can purchase again."
   };
 
   SWEP.Icon = "vgui/ttt/icon_skull.vmt"
end
 
SWEP.Base               = "weapon_tttbase"
 
SWEP.ViewModel          = "models/weapons/c_pistol.mdl"
SWEP.WorldModel         = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 50
 
SWEP.DrawCrosshair      = true
SWEP.Primary.Damage         = 25
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "XBowBolt"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "XBowBolt"
SWEP.Secondary.Delay = 1.4
 
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.LimitedStock = false -- only buyable once
SWEP.WeaponID = AMMO_TASER
 
SWEP.IsSilent = false
 
-- Pull out faster than standard guns
SWEP.DeploySpeed = 2
 
SWEP.Used = false
 
local taseredrags = {}
 
function SWEP:Initialize()
        hook.Add("TTTEndRound", "DontTaseMeBro", function()
                self.Used = true
        end)
end
 
function SWEP:PrimaryAttack()
if self.Used then
                self.Owner:PrintMessage( HUD_PRINTCENTER, "Batteries Depleted. Taser Useless." )
                return
        end
        local eyetrace = self.Owner:GetEyeTrace();
 
        if !eyetrace.Entity:IsPlayer() then return end
 
        self.Weapon:EmitSound( "Weapon_StunStick.Activate")
 
        self.BaseClass.ShootEffects( self )
 
        if not IsValid(eyetrace.Entity) or (self.Owner:EyePos():Distance(eyetrace.Entity:GetPos()) > 150) or not eyetrace.Entity:IsPlayer() then return end
 
        if CLIENT then return end
 
        if eyetrace.Entity:IsPlayer() then
 
                self.Owner:PrintMessage( HUD_PRINTCENTER, "Now right click to electrocute "..eyetrace.Entity:GetName( ) )
 
                self:tasePlayer(eyetrace.Entity)    // If the it is a player then bring them down tranqPlayer()
                self.Used = true
 
        end
end
 
function SWEP:tasePlayer(ply)
        if not ply:Alive() then return end
 
        if ply:InVehicle() then
                local vehicle = ply:GetParent()
                ply:ExitVehicle()
        end
 
        ULib.getSpawnInfo( ply ) -- Collect information so we can respawn them in the same state.
 
        local ragdoll = ents.Create( "prop_ragdoll" )
        ragdoll.ragdolledPly = ply
 
        ragdoll:SetPos( ply:GetPos() )
        local velocity = ply:GetVelocity()
        ragdoll:SetAngles( ply:GetAngles() )
        ragdoll:SetModel( ply:GetModel() )
        ragdoll:Spawn()
        ragdoll:Activate()
        ply:SetParent( ragdoll ) -- So their player ent will match up (position-wise) with where their ragdoll is.
                                -- Set velocity for each peice of the ragdoll
        local j = 1
        while true do -- Break inside
                local phys_obj = ragdoll:GetPhysicsObjectNum( j )
                if phys_obj then
                        phys_obj:SetVelocity( velocity )
                        j = j + 1
                else
                        break
                end
        end
 
        table.insert(taseredrags, ragdoll)
 
ply:Spectate( OBS_MODE_CHASE )
        ply:SpectateEntity( ragdoll )
        ply:StripWeapons() -- Otherwise they can still use the weapons.
 
        ragdoll:DisallowDeleting( true, function( old, new ) ply.ragdoll = new end )
 
        ply:DisallowSpawning( true )
 
        ply.ragdoll = ragdoll
        ply:PrintMessage( HUD_PRINTCENTER, "You have been tasered. 30 seconds till revival" )
 
        timer.Create("revivedelay"..ply:UniqueID(), 30, 1, function () taserrevive( ply ) end )
end
 
function taserrevive(ply)
        ply:DisallowSpawning( false )
        ply:SetParent()
 
        ply:UnSpectate() -- Need this for DarkRP for some reason, works fine without it in sbox
 
        local ragdoll = ply.ragdoll
        ply.ragdoll = nil -- Gotta do this before spawn or our hook catches it
 
        if not ragdoll:IsValid() then -- Something must have removed it, just spawn
                ULib.spawn( ply, true )
        else
                local pos = ragdoll:GetPos()
                pos.z = pos.z + 10 -- So they don't end up in the ground
 
                ULib.spawn( ply, true )
                ply:SetPos( pos )
                ply:SetVelocity( ragdoll:GetVelocity() )
                local yaw = ragdoll:GetAngles().yaw
                ply:SetAngles( Angle( 0, yaw, 0 ) )
                ragdoll:DisallowDeleting( false )
                ragdoll:Remove()
        end
        for k, v in pairs(taseredrags) do
                table.remove( taseredrags, k )
        end
end
 
function SWEP:SecondaryAttack()
 
        if table.Count( taseredrags ) == 0 then return end
 
 
 
        self.Owner:EmitSound( "Weapon_Pistol.Empty")
 
        self.Owner:EmitSound( "Weapon_SMG1.Empty")
 
        if CLIENT then return end
 
 
 
        for k, v in pairs(taseredrags) do
 
                local shock1 = math.random(-1200, 1200 )
 local shock2 = math.random(-1200, 1200 )
 
                local shock3 = math.random(-1200, 1200 )
 
                if not v:IsValid() then return end
                v:GetPhysicsObject():ApplyForceCenter( Vector( shock1, shock2, shock3 ) )
        end
end