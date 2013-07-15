CreateClientConVar("dmglog_tirscolor", "1", true, true)

local function StrRole(role)
   if role == ROLE_TRAITOR then return "traitor"
   elseif role == ROLE_DETECTIVE then return "detective"
   else return "innocent" end
end

function Damagelog:trouverTirs(victime, tueur, temps, round, affichage, shoottable, infotirs)
    local trouver = {}
	local found = false
	for k,v in pairs(shoottable or {}) do
	    if k >= temps - affichage and k <= temps then
		    for s,i in pairs(v) do
		        if i[1] == victime or i[1] == tueur then
		            if trouver[k] == nil then
					    table.insert(trouver, k, {})
					end
					table.insert(trouver[k], i)
			        found = true
				end
			end
		end
	end
	local temps_debut = temps-affichage
	if found then
	    self:AjouterTirs(temps_debut, temps, trouver, victime, tueur, infotirs)
	else 
	    self:AjouterTirs("nope", temps, trouver, victime, tueur, infotirs)
    end
end

function Damagelog:AddItem(v, box, infotirs, realold)
    local item = nil
	local texte
	if v[1] == 0 then
		local arme = self.weapon_table[v[8]] or v[8] or nil
	    texte = string.format("%s [%s] has damaged %s [%s] for %s damages (armes inconnue)", v[4], StrRole(v[5]), v[2], StrRole(v[3]), v[6]) 
		if arme then
		    texte = string.format("%s [%s] has damaged %s [%s] for %s damages with %s", v[4], StrRole(v[5]), v[2], StrRole(v[3]), v[6], arme) 
		end
        item = box:AddLine(util.SimpleTime(v[7], "%02i:%02i"), "DMG", texte);
	    item.PaintOver = function()
		    if (v[3] == ROLE_DETECTIVE) then
		        v[3] = ROLE_INNOCENT
		    end
            if (v[5] == ROLE_DETECTIVE) then
                v[5] = ROLE_INNOCENT
            end			
	        if (v[3] == v[5]) then
			    item.Columns[1]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
				item.Columns[2]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
				item.Columns[3]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
			else
			    item.Columns[1]:SetTextColor(self.Colors["Damages"] or self.DefaultColors["Damages"]) 
				item.Columns[2]:SetTextColor(self.Colors["Damages"] or self.DefaultColors["Damages"]) 
				item.Columns[3]:SetTextColor(self.Colors["Damages"] or self.DefaultColors["Damages"])
		    end
        end	    
    elseif v[1] == 1 then	
	    local arme = self.weapon_table[v[7]] or v[7] or nil
		texte = string.format("%s [%s] has killed %s [%s] (unknown weapon)", v[2], StrRole(v[3]), v[4], StrRole(v[5])) 
		if arme then
            texte = string.format("%s [%s] has killed %s [%s] with %s", v[2], StrRole(v[3]), v[4], StrRole(v[5]), arme)
        end			
	    item = box:AddLine(util.SimpleTime(v[6], "%02i:%02i"), "KILL", texte)
		item.PaintOver = function()
		    if (v[3] == ROLE_DETECTIVE) then
		        v[3] = ROLE_INNOCENT
		    end
            if (v[5] == ROLE_DETECTIVE) then
                v[5] = ROLE_INNOCENT
            end			
	        if (v[3] == v[5]) then
		        item.Columns[1]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
				item.Columns[2]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
				item.Columns[3]:SetTextColor(self.Colors["Teamkills"] or self.DefaultColors["Teamkills"])
            else
                item.Columns[1]:SetTextColor(self.Colors["Kills"] or self.DefaultColors["Kills"])
				item.Columns[2]:SetTextColor(self.Colors["Kills"] or self.DefaultColors["Kills"])
				item.Columns[3]:SetTextColor(self.Colors["Kills"] or self.DefaultColors["Kills"])
            end					
		end				
	elseif v[1] == 2 then
		print(v[6], v[7])
		if v[6] then
			texte = string.format("%s [%s] has retreived the DNA of %s [%s] from %s", v[2], StrRole(v[3]), v[4], StrRole(v[5]), self.weapon_table[v[7]] or "Unknown object")
		else
			texte = string.format("%s [%s] has retreived the DNA of %s [%s] from %s", v[2], StrRole(v[3]), v[4], StrRole(v[5]), v[7])
		end
	    item = box:AddLine(util.SimpleTime(v[8], "%02i:%02i"), "DNA", texte)
	    item.PaintOver = function()
			item.Columns[1]:SetTextColor(self.Colors["DNA"] or self.DefaultColors["DNA"])
			item.Columns[2]:SetTextColor(self.Colors["DNA"] or self.DefaultColors["DNA"])
			item.Columns[3]:SetTextColor(self.Colors["DNA"] or self.DefaultColors["DNA"])
		end
	elseif v[1] == 3 then
        texte = string.format("<something/world> killed %s [%s]", v[2], StrRole(v[3]))			
		item = box:AddLine(util.SimpleTime(v[4], "%02i:%02i"), "DEATH", texte)
	    item.PaintOver = function()
		    item.Columns[1]:SetTextColor(self.Colors["Suicide"] or self.DefaultColors["Suicide"])
			item.Columns[2]:SetTextColor(self.Colors["Suicide"] or self.DefaultColors["Suicide"])
			item.Columns[3]:SetTextColor(self.Colors["Suicide"] or self.DefaultColors["Suicide"])
		end
	elseif v[1] == 4 then
		texte = string.format("%s [%s] has bought %s", v[3], StrRole(v[2]), self.weapon_table[v[4]] or "Unknown weapon")
		item = box:AddLine(util.SimpleTime(v[5], "%02i:%02i"), "BUY", texte)
		item.PaintOver = function()
		    item.Columns[1]:SetTextColor(self.Colors["Weapons Buy"] or self.DefaultColors["Weapons Buy"])
			item.Columns[2]:SetTextColor(self.Colors["Weapons Buy"] or self.DefaultColors["Weapons Buy"])
			item.Columns[3]:SetTextColor(self.Colors["Weapons Buy"] or self.DefaultColors["Weapons Buy"])
		end
	elseif v[1] == 5 then
	    local arme = self.weapon_table[v[4]] or v[4] or nil
		texte = string.format("%s [%s] has thrown a %s", v[2], StrRole(v[3]), arme) 
		item = box:AddLine(util.SimpleTime(v[5], "%02i:%02i"), "GRENADE", texte)
		item.PaintOver = function()
		    item.Columns[1]:SetTextColor(self.Colors["Grenades"] or self.DefaultColors["Grenades"])
			item.Columns[2]:SetTextColor(self.Colors["Grenades"] or self.DefaultColors["Grenades"])
			item.Columns[3]:SetTextColor(self.Colors["Grenades"] or self.DefaultColors["Grenades"])
		end
	else 
	    return 
	end
	
	item.OnRightClick = function()	
		    local menuOptions = DermaMenu()
            local copy = menuOptions:AddOption("Copy", function()  
		        SetClipboardText(texte)
			end)		
			copy:SetImage("icon16/tab_edit.png")
			if v[1] == 1 or v[1] == 0 then
			    local shot = menuOptions:AddOption("Who shot first?", function()
				    local victime
					local temps
					local tueur
					if v[1] == 1 then
					    victime = v[4]
						temps = v[6]
						tueur = v[2]
					else
					    victime = v[2]
						temps = v[7]
						tueur = v[4]
					end
					if victime and temps and tueur then
					    if self.Old then
						    self:trouverTirs(victime, tueur, temps, round, 15, Damagelog.shoottable, infotirs)
						elseif realold then
						    Damagelog:trouverTirs(victime, tueur, temps, round, 15, Damagelog.OldShoot, infotirs)
						else 					
				           net.Start("AskTirs")
						   net.WriteUInt(temps, 32)
						   net.WriteUInt(15, 8)
						   net.WriteString(victime)
						   net.WriteString(tueur)
						   net.WriteUInt(rounds, 8)
						   net.SendToServer()
						end
					end
				end)
				shot:SetImage("icon16/gun.png")
			end
			local display = menuOptions:AddOption("Text too long?", function()
			    Derma_Message(texte, "Full display", "Close")
			end)
			display:SetImage("icon16/eye.png")
            menuOptions:Open() 
	end
end	  