
Damagelog.default_settings = {
	Regular = 2,
	Admin = 4,
	SuperAdmin = 4
}	

if not file.Exists("damagelog/settings_new.txt", "DATA") then
	Damagelog.settings = Damagelog.default_settings
	file.Write("damagelog/settings_new.txt", von.serialize(Damagelog.default_settings))
else
	Damagelog.settings = von.deserialize(file.Read("damagelog/settings_new.txt", "DATA"))
end

function Damagelog:SaveSettings()
	local encoded = von.serialize(Damagelog.settings)
	file.Write("damagelog/settings_new.txt", encoded)
end

net.Receive("AskAdminStuff", function(len,ply)
	net.Start("SendAdminStuff")
	net.WriteTable(Damagelog.settings)
	net.Send(ply)
end)

net.Receive("SetSetting", function(len,ply)
	if not ply:IsSuperAdmin() then return end
	local setting = net.ReadString()
	local value = net.ReadUInt(8)
	Damagelog.settings[setting] = value
	Damagelog:SaveSettings()
	net.Start("BroadcastSettings")
	net.WriteTable(Damagelog.settings)
	net.Broadcast()
end)

hook.Add("PlayerAuthed", "PlayerAuthedSettings", function(ply)
	net.Start("BroadcastSettings")
	net.WriteTable(Damagelog.settings)
	net.Send(ply)
end)