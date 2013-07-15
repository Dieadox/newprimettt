
Damagelog.weapon_table = {}

net.Receive("SendWepTable", function()
	local key = net.ReadString()
	local value = net.ReadString()
	if key and value then
		Damagelog.weapon_table[key] = value
	end
end)

net.Receive("UpdateWeaponDamagelog", function()
	local class = net.ReadString()
	local name = net.ReadString()
	Damagelog.weapon_table[class] = name
	if Damagelog.update_callback then
		Damagelog:update_callback()
	end
end)

net.Receive("RemoveWeaponsDamagelog", function()
	local weps = net.ReadTable()
	for k,v in pairs(weps) do
		Damagelog.weapon_table[v] = nil
	end
	if Damagelog.update_callback then
		Damagelog:update_callback()
	end
end)	

net.Receive("InformWeaponTableDefault", function()
	Damagelog.weapon_table = Damagelog.weapon_table_default
	if Damagelog.update_callback then
		Damagelog:update_callback()
	end
end)	