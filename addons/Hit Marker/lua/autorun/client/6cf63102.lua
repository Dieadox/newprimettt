--======== Copyleft © 2010, Andrew McWatters, Some rights reserved. =========--
--
-- Purpose: Displays MW2-esque hit markers on damage.
--
--===========================================================================--

local bHitActive = false
local bHitSound = false
local flFrameTime = 0
local x
local y

local Underwater = {}
Underwater.BulletImpact =
{
	"serenity_gaming/hit.wav",
	"serenity_gaming/hit.wav",
	"serenity_gaming/hit.wav"
}

hook.Add( "PlayerTraceAttack", "PlayerHitMarker", function( ply, dmginfo, dir, trace )
  if ( dmginfo:GetAttacker() == LocalPlayer() ) then
    bHitActive = true
	bHitSound = true
	flFrameTime = CurTime() + FrameTime() * 9
  end
end )

hook.Add( "HUDPaint", "CHitMarker", function()

  local player	= LocalPlayer()
  if ( !player:Alive() ) then return end

  // Ask the gamemode if it's ok to do this
  if ( !gamemode.Call( "HUDShouldDraw", "CHitMarker" ) ) then return end

  if ( bHitSound ) then
    bHitSound = false
	surface.PlaySound( table.Random( Underwater.BulletImpact ) )
  end

  if ( bHitActive and flFrameTime > CurTime() ) then
		x = ScrW() / 2
		y = ScrH() / 2
		
		surface.SetDrawColor(245,10,10,255)
		surface.DrawLine( x + 15, y - 15, x + 5, y - 5)
		surface.DrawLine( x - 15, y + 15, x - 5, y + 5)
		surface.DrawLine( x + 15, y + 15, x + 5, y + 5)
		surface.DrawLine( x - 15, y - 15, x - 5, y - 5)
  else
    bHitActive = false
  end

end )
