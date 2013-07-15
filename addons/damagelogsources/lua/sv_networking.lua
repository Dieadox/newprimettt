util.AddNetworkString("AskDamageLog")
util.AddNetworkString("TransferDamage")
util.AddNetworkString("AskTirs")
util.AddNetworkString("SendTirs")
util.AddNetworkString("SendRoles")
util.AddNetworkString("SendTirsLogs")
util.AddNetworkString("AskTirsLogs")
util.AddNetworkString("Realtime_damagelog")
util.AddNetworkString("AskAdminStuff")
util.AddNetworkString("SendAdminStuff")
util.AddNetworkString("SetSetting")
util.AddNetworkString("BroadcastSettings")
util.AddNetworkString("SendWepTable")
util.AddNetworkString("AddWeaponDamagelog")
util.AddNetworkString("UpdateWeaponDamagelog")
util.AddNetworkString("RemoveWeaponClassDamagelog")
util.AddNetworkString("RemoveWeaponsDamagelog")
util.AddNetworkString("WeaponTableDefault")
util.AddNetworkString("InformWeaponTableDefault")
	
function Damagelog:SendDamageLog(ply)
    if not ply:CanUseDamagelog() then return end
	local round = net.ReadInt(8)
	local damage_send
	local rolestbl
	if round == -1 then
		damage_send = self.old_logs.Logs or {}
		rolestbl = self.old_logs.Roles or {}
	elseif round == self.playedrounds then
	    damage_send = self.DamageTable
		rolestbl = self.Roles[round]
	else
		damage_send = self.oldtables[round]
		rolestbl = self.Roles[round]
    end
	net.Start("SendRoles")
	net.WriteTable(rolestbl or {})
	net.Send(ply)
	if not damage_send then damage_send = { "empty" } end
	for k,v in ipairs(damage_send or { "empty" }) do
	    net.Start("TransferDamage")
		if v == "empty" then
		    net.WriteUInt(1,1)
		else
		    net.WriteUInt(0,1)
		    net.WriteTable(v)
		end
		if k == #damage_send then
		   net.WriteUInt(1,1)
		else
		   net.WriteUInt(0,1)
		end
		net.Send(ply)
	end
end
net.Receive("AskDamageLog", function(len,ply) Damagelog:SendDamageLog(ply) end)

function Damagelog:SendTirs(ply)
	local time = net.ReadUInt(32)
	local affichage = net.ReadUInt(8)
	local victime = net.ReadString()
	local tueur = net.ReadString()
	local round = net.ReadUInt(8)
	local temps = {}
	local found = false
	for k,v in pairs(round > 0 and self.ShootTables[round] or self.old_logs.ShootTables or {}) do
	    if k >= time - affichage and k <= time then
		    for s,i in pairs(v) do
		        if i[1] == victime or i[1] == tueur then
		            if temps[k] == nil then
					    table.insert(temps, k, {})
					end
					table.insert(temps[k], i)
			        found = true
				end
			end
		end
	end
	local temps_debut = time-affichage
	if found then
	  net.Start("SendTirs")
	  net.WriteUInt(1,1)
	  net.WriteUInt(temps_debut, 32)
	  net.WriteUInt(time, 32)
	  net.WriteTable(temps)
	  net.WriteString(victime)
	  net.WriteString(tueur)
	  net.Send(ply)
	else 
	  net.Start("SendTirs")
	  net.WriteUInt(0,1)
	  net.WriteUInt(temps_debut, 32)
	  net.WriteUInt(time, 32)
	  net.WriteString(victime)
	  net.WriteString(tueur)
	  net.Send(ply)
    end
end
net.Receive("AskTirs", function(len,ply) Damagelog:SendTirs(ply) end)

function Damagelog:SendTirsLogs(ply)
   net.Start("SendTirsLogs")
   local compressed = util.Compress(von.serialize(self.ShootTables[net.ReadUInt(8)] or {}) or "")
   local len = string.len(compressed or "")
   net.WriteUInt(len, 32)
   net.WriteData(compressed or "", len)
   net.Send(ply)
end
net.Receive("AskTirsLogs", function(len,ply) Damagelog:SendTirsLogs(ply) end)

function Damagelog:SendDamageTable(tbl)
    for k,v in pairs(player.GetHumans()) do
	    if v:CanUseDamagelog() then 
		    net.Start("Realtime_damagelog")
			net.WriteTable(tbl)
			net.Send(v)
		end
	end
end