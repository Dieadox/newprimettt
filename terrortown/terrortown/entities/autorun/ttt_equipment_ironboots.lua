
if SERVER then
	
	local function ScaleFallDamage( ent, inflictor, attacker, amount, dmginfo )
		if ent:IsPlayer() and ent:HasEquipmentItem( EQUIP_IRONBOOTS ) and dmginfo:IsFallDamage() then
			dmginfo:ScaleDamage( ttt_perky_config.ironboots_scale_fall_damage )
			return false
		end
	end
	hook.Add( 'EntityTakeDamage', 'ttt_equipment_ironboots_enttakedamage', ScaleFallDamage )
	
end