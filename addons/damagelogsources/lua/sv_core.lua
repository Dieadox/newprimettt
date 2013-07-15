
Damagelog.playedrounds = 0
Damagelog.DamageTable = {}
Damagelog.ShootTables = {}
Damagelog.DamageTable[1] = "empty"
Damagelog.Roles = {}
Damagelog.Time = 0
Damagelog.oldtables = {}

function Damagelog:CheckDamageTable()
	if Damagelog.DamageTable[1] == "empty" then
		table.Empty(Damagelog.DamageTable)
	end
end

hook.Add("TTTBeginRound", "ClearDamagelog", function(result)
	Damagelog.Time = 0
	if not timer.Exists("TimerDamagelogTime") then
		timer.Create("TimerDamagelogTime", 1, 0, function()
			Damagelog.Time = Damagelog.Time + 1
		end)
	end
	Damagelog.playedrounds = Damagelog.playedrounds + 1
	Damagelog.ShootTables[Damagelog.playedrounds] = {}
	Damagelog.Roles[Damagelog.playedrounds] = {}
	if add_old then
        Damagelog.oldtables[Damagelog.playedrounds-1] = table.Copy(Damagelog.DamageTable)
	else 
	    add_old = true
	end
	table.Empty(Damagelog.DamageTable)
	Damagelog.DamageTable[1] = "empty"
    Damagelog.Time = 0
	SetGlobalInt("PlayedRounds", Damagelog.playedrounds)
	for k,v in pairs(player.GetAll()) do
		Damagelog.Roles[Damagelog.playedrounds][v:Nick()] = v:GetRole()
	end
end)	

hook.Add("TTTEndRound", "SaveDamagelog", function()
    local tbl = {}
	tbl.Logs = Damagelog.DamageTable
	tbl.ShootTable = Damagelog.ShootTables[Damagelog.playedrounds]
	tbl.Map = game.GetMap()
	tbl.Roles = Damagelog.Roles[Damagelog.playedrounds]
	file.Write("damagelog/oldlog.txt", von.serialize(tbl))
end)

if file.Exists("damagelog/oldlog.txt", "DATA") then
    Damagelog.old_logs = von.deserialize(file.Read("damagelog/oldlog.txt", "DATA"))
end