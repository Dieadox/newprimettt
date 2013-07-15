AddCSLuaFile("autorun/client/cl_tttkillfeed.lua")

// Chat Kill Feed for TTT: Tells you who killed you and what their role is.

function KillFeed( victim, wep, attacker )
	if GetRoundState() == ROUND_ACTIVE then -- If round isn't active, don't killfeed.
	
		// Traitor
		if ( attacker:IsPlayer() ) and ( attacker ~= victim ) and attacker:IsTraitor() then
			umsg.Start( "KillFeed", victim )
				umsg.String( attacker:Nick() ) 	-- Player Name
				umsg.Char( 2 ) 					-- Team Number
			umsg.End()
		end
		
		// Detective
		if ( attacker:IsPlayer() ) and ( attacker ~= victim	) and attacker:IsDetective() then
			umsg.Start( "KillFeed" , victim	)
				umsg.String( attacker:Nick() )
				umsg.Char( 3 )
			umsg.End()
		end
		
		// Innocent
		if ( attacker:IsPlayer() ) and ( attacker ~= victim	) and !attacker:IsDetective() and !attacker:IsTraitor() then
			umsg.Start( "KillFeed", victim	)
				umsg.String( attacker:Nick() )
				umsg.Char( 1 )
			umsg.End()
		end
		
	end
	
end

hook.Add( "PlayerDeath", "ChatKillFeed", KillFeed )
