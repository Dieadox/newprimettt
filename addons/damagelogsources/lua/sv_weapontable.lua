
function Damagelog:SaveWeaponTable()
	local encoded = von.serialize(Damagelog.weapon_table)
	file.Write("damagelog/weapon_table.txt", encoded)
end

if not file.Exists("damagelog/weapon_table.txt", "DATA") then
	Damagelog.weapon_table = Damagelog.weapon_table_default
	local encoded = von.serialize(Damagelog.weapon_table_default)
	file.Write("damagelog/weapon_table.txt", encoded)
else
	local encoded = file.Read("damagelog/weapon_table.txt", "DATA")
	Damagelog.weapon_table = von.deserialize(encoded)
end
	

hook.Add("PlayerAuthed", "PlayerAuthedSendWepTable", function(ply)
	for k,v in pairs(Damagelog.weapon_table) do
		net.Start("SendWepTable")
		net.WriteString(k)
		net.WriteString(v)
		net.Send(ply)
	end
end)

net.Receive("AddWeaponDamagelog", function(len,ply)
	if not ply:IsSuperAdmin() then return end
	local class = net.ReadString()
	local name = net.ReadString()
	if class and name then
		Damagelog.weapon_table[class] = name
		net.Start("UpdateWeaponDamagelog")
		net.WriteString(class)
		net.WriteString(name)
		net.Broadcast()
		Damagelog:SaveWeaponTable()
	end
end)

net.Receive("RemoveWeaponClassDamagelog", function(len,ply)
	if not ply:IsSuperAdmin() then return end
	local classes = net.ReadTable()
	for k,v in pairs(classes) do
		Damagelog.weapon_table[v] = nil
	end
	Damagelog:SaveWeaponTable()
	net.Start("RemoveWeaponsDamagelog")
	net.WriteTable(classes)
	net.Broadcast()
end)

net.Receive("WeaponTableDefault", function(len,ply)
	if not ply:IsSuperAdmin() then return end
	Damagelog.weapon_table = Damagelog.weapon_table_default
	Damagelog:SaveWeaponTable()
	net.Start("InformWeaponTableDefault")
	net.Broadcast()
end)
		