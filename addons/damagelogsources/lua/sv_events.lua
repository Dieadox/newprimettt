function Damagelog:WeaponFromDmg(dmg)
   local inf = dmg:GetInflictor()
   local wep = nil
   if IsValid(inf) then
      if inf:IsWeapon() or inf.Projectile then
         wep = inf
	  elseif dmg:IsDamageType(DMG_BLAST) then
	      wep = "an explosion"
	  elseif dmg:IsDamageType(DMG_DIRECT) or dmg:IsDamageType(DMG_BURN) then
	      wep = "fire"
      elseif dmg:IsDamageType(DMG_CRUSH) then
         -- DMG_DIRECT is the player burning, no weapon involved
         -- DMG_CRUSH is physics or falling on someone
         wep = "falling or prop-killing"
      elseif inf:IsPlayer() then
         wep = inf:GetActiveWeapon()
         if not IsValid(wep) then
            -- this may have been a dying shot, in which case we need a
            -- workaround to find the weapon because it was dropped on death
            wep = IsValid(inf.dying_wep) and inf.dying_wep or nil
         end
      end
   end
   if type(wep) ~= "string" then
       if not wep then return nil end
       return wep:GetClass()
   else
       return wep
   end
end

-- We must do this after the gamemode initialized
hook.Add("Initialize", "InitializeDamagelogEvents", function()

	-- Damages
    hook.Add("EntityTakeDamage", "EntityTakeDamageDamagelog", function(ent, dmginfo)
		local att = dmginfo:GetAttacker()
		if ent:IsPlayer() and att:IsPlayer() and ent != att then
			if GetRoundState() == ROUND_ACTIVE then
				local damages = dmginfo:GetDamage()
				if math.floor(damages) > 0 then
					Damagelog:CheckDamageTable()
					local damagelog = { 0, ent:Nick(), ent:GetRole(), att:Nick(), att:GetRole(), math.Round(damages), Damagelog.Time, Damagelog:WeaponFromDmg(dmginfo) }
					table.insert(Damagelog.DamageTable, damagelog)
					Damagelog:SendDamageTable(damagelog)
				end
			end
		end
	end)	
	
	-- Deaths
	hook.Add("DoPlayerDeath", "DoPlayerDeathDamagelog", function(ply, attacker, dmginfo)
	    Damagelog:CheckDamageTable()
        if IsValid(attacker) and attacker:IsPlayer() then
		    local damagelog
		    if attacker != ply then
                damagelog = { 1, attacker:Nick(), attacker:GetRole(), ply:Nick(), ply:GetRole(), Damagelog.Time, Damagelog:WeaponFromDmg(dmginfo) } ; 
            else
		        damagelog = { 3, ply:Nick(), ply:GetRole(), Damagelog.Time }  
		    end
            table.insert(Damagelog.DamageTable, damagelog)
			Damagelog:SendDamageTable(damagelog)
        else
		    local damagelog = { 3, ply:Nick(), ply:GetRole(), Damagelog.Time}  
		    table.insert(Damagelog.DamageTable, damagelog)
			Damagelog:SendDamageTable(damagelog)
        end
	end)
	
	-- Here's the funniest part of my code
	-- I want GiveEquipmentWeapon to be global
	-- So I had this idea..
	function weaponryEditCallback()
		local oldGive = GiveEquipmentWeapon
		function GiveEquipmentWeapon(uid, wep)
			oldGive(uid, wep)
			if not timer.Exists("give_equipment"..tostring(uid)) then
				local ply = player.GetByUniqueID(uid)
				Damagelog:CheckDamageTable()
				local info = { 4, ply:GetRole(), ply:Nick(), tostring(wep), Damagelog.Time }
				table.insert(Damagelog.DamageTable, info)
				Damagelog:SendDamageTable(info)
			end
		end
	end
	local weaponry = file.Read("gamemodes/"..GAMEMODE.FolderName.."/gamemode/weaponry.lua", "GAME")
	weaponry = string.gsub(weaponry, "include(\"weaponry_shd.lua\")", "")
	weaponry = string.gsub(weaponry, "GM:", "GAMEMODE:")
	weaponry = string.gsub(weaponry, "local function GiveEquipmentWeapon", "function GiveEquipmentWeapon")
	weaponry = weaponry.."\nweaponryEditCallback()"
	RunString(weaponry)
		
	local function shootCallback(weapon)
		local owner = weapon.Owner
		if GetRoundState() == ROUND_ACTIVE then
			if Damagelog.ShootTables[Damagelog.playedrounds][Damagelog.Time] then
				local info = { owner:Nick(), weapon:GetClass() }
				table.insert(Damagelog.ShootTables[Damagelog.playedrounds][Damagelog.Time], info)			
			else
				table.insert(Damagelog.ShootTables[Damagelog.playedrounds], Damagelog.Time, {})
				local info = { owner:Nick(), weapon:GetClass() }
				table.insert(Damagelog.ShootTables[Damagelog.playedrounds][Damagelog.Time], info)
			end
		end
	end
	for k,v in pairs(weapons.GetList()) do		
		if v.Base == "weapon_tttbase" then
			if not v.PrimaryAttack then
				v.PrimaryAttack = function(self)
					self.BaseClass.PrimaryAttack(self)
					if self.BaseClass.CanPrimaryAttack(self) and IsValid(self.Owner) then
						shootCallback(self)
					end
				end
			end
			if v.ClassName == "weapon_zm_improvised" then
				local oldprimary = v.PrimaryAttack
				v.PrimaryAttack = function(self)
					oldprimary(self)
					shootCallback(self)
				end
			end
		elseif v.Base == "weapon_tttbasegrenade" then
			v.CreateGrenade = function(self, src, ang, vel, angimp, ply)
				if GetRoundState() == ROUND_ACTIVE then
					Damagelog:CheckDamageTable()
					local damagelog = { 5, self.Owner:Nick(), self.Owner:GetRole(), self:GetClass(), Damagelog.Time }
					table.insert(Damagelog.DamageTable, damagelog)
					Damagelog:SendDamageTable(damagelog)
					return self.BaseClass.CreateGrenade(self, src, ang, vel, angimp, ply)
				end
			end
		end
	end
	
	-- Add weapon callbacks
	local dnas = {}
	local oldinsert = table.insert
	table.insert = function(tbl, pos, value)
		if type(pos) == "table" then
			if pos.source and pos.ply and pos.type and pos.cls then
				for k,v in pairs(dnas) do
					if tbl == v.ItemSamples then
						local owner = v.Owner
						if IsValid(owner) then
							local obj
							local weptbl
							if pos.type == 1 then
								obj = IsValid(pos.source) and CORPSE.GetPlayerNick(pos.source).."'s corpse" or "<invalid>"
								weptbl = false
							else
								obj = pos.source:GetClass()
								weptbl = true
							end
							Damagelog:CheckDamageTable()
							local damagelog = { 2, owner:Nick(), owner:GetRole(), pos.ply:Nick(), pos.ply:GetRole(), weptbl, obj, Damagelog.Time }
							table.insert(Damagelog.DamageTable, damagelog)
							Damagelog:SendDamageTable(damagelog)
						end	
					end
				end
			end
		end
		if value then
			return tbl and oldinsert(tbl, pos, value)
		else
			return tbl and oldinsert(tbl, pos)
		end
	end
	hook.Add("OnEntityCreated", "OnEntityCreatedDNA", function(ent)
		if ent:GetClass() == "weapon_ttt_wtester" then
			table.insert(dnas, ent)
		end
	end)
	hook.Add("EntityRemoved", "EntityRemovedDNA", function(ent)
		if ent:GetClass() == "weapon_ttt_wtester" then
			for k,v in pairs(dnas) do
				if v == ent then
					table.remove(dnas, k)
				end
			end
		end
	end)	
	
end)