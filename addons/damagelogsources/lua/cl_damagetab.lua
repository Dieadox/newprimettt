local damagelog_loading = {}

Damagelog.DefaultColors = {
	Teamkills = Color(255, 0, 0, 255),
	Damages = Color(0, 0, 0, 255),
	Kills = Color(255, 128, 0, 255),
	DNA = Color(0, 255, 0, 255),
	Suicide = Color(25, 25, 220, 255),
	["Weapons Buy"] = Color(128, 0, 128, 255),
	Grenades = Color(0, 128, 0, 255),
	Misc = Color(0, 179, 179, 255)
}

if not sql.TableExists("damagelog_colors") then
	Damagelog.Colors = Damagelog.DefaultColors
	sql.Query("CREATE TABLE damagelog_colors (color varchar(255), r int, g int, b int)")
	for k,v in pairs(Damagelog.DefaultColors) do
		sql.Query(string.format("INSERT INTO damagelog_colors(`color`, `r`, `g`, `b`) VALUES('%s', %i, %i, %i)", k, v.r, v.g, v.b))
	end
else
	Damagelog.Colors = {}
	local count = sql.QueryValue("SELECT COUNT(*) FROM damagelog_colors")
	for i=1,count do
		local query = sql.QueryRow("SELECT * FROM damagelog_colors WHERE rowid = "..tostring(i))
		Damagelog.Colors[query.color] = Color(query.r, query.g, query.b)
	end
end	

function Damagelog:drawDamageTab(keep)

	table.Empty(self.damagelog_table)
	
	local x, y = self.menu:GetSize()
	self.tabs = vgui.Create("DPropertySheet", self.menu)
	self.tabs:SetParent(self.menu)
	self.tabs:SetPos(5, 30)
	self.tabs:SetSize(x-20, y-40)		
			
	self.frame_damage = vgui.Create("DPanelList");
	self.frame_damage:SetSpacing(10);
			
	local playedrounds = GetGlobalInt("PlayedRounds", 0)
	self.round = vgui.Create("DComboBox")
	self.round:AddChoice("Last round of the previous map", -1)
	if playedrounds > 0 then
		for i=1, playedrounds do
			if i == playedrounds then
				self.round:AddChoice("Current round", i)
			else
				self.round:AddChoice("Round "..tostring(i), i)
			end
		end
		self.round:ChooseOptionID(playedrounds+1)
	else
		self.round:AddChoice("No available logs for the current map")
		self.round:ChooseOptionID(2)
	end
	rounds = playedrounds
	self.frame_damage:AddItem(self.round)
		
	self.round.OnSelect = function(pnl, value, index, data)
		rounds = data
		self.dmg_logsbox:Clear()
		self.dmg_logsbox:AddLine("", "", "Loading..")
		net.Start("AskDamageLog")
		net.WriteInt(rounds, 8)
		net.SendToServer()
	end
		
    self.roles = vgui.Create("DListView")
	self.roles:AddColumn("Player")
	self.roles:AddColumn("Role")
	self.roles:SetHeight(100)
	self.frame_damage:AddItem(self.roles)
		
	self.combo_box = vgui.Create("DListView")
	local c = self.combo_box:AddColumn("Damage informations")
	c.DoClick = function() end
	self.combo_box:SetHeight(80)
	
	function Damagelog:AjouterTirs(debut, fin, tirs, victime, tueur, infotirs)
	    debut = string.FormattedTime(math.Clamp(debut, 0, 999), "%02i:%02i")
		fin = string.FormattedTime(fin, "%02i:%02i")
	    infotirs:Clear()
	    infotirs:AddLine("Shoots of "..victime.." and "..tueur.. " between "..debut.." and "..fin..".")
		if tirs == "nope" then
		    infotirs:AddLine("Couldn't find any shoot.")
			return
		end
		local nums = {}
		for k,v in pairs(tirs) do
		    table.insert(nums, k)
		end
		table.sort(nums)
		local personnes = {}
		personnes[1] = ""
		personnes[2] = ""
		for k,v in ipairs(nums) do
		    local info = tirs[v]
		    for s,i in pairs(info) do
			    if personnes[1] == "" then
			        personnes[1] = i[1]
				else
				    if personnes[2] == "" then
					    personnes[2] = i[1]
					end
				end
				local item
				if i[2] == "crowbartir" then
				    item = infotirs:AddLine(Format("%s - %s has shot with a Crowbar", string.FormattedTime(v, "%02i:%02i"), i[1]))
				elseif i[2] == "crowbarpouss" then
				    item = infotirs:AddLine(Format("%s - %s has pushed %s with a Crowbar", string.FormattedTime(v, "%02i:%02i"), i[1], i[3]))
				else
		            item = infotirs:AddLine(Format("%s - %s has shot with %s", string.FormattedTime(v, "%02i:%02i"), i[1], self.weapon_table[i[2]] or i[2] or "(unknown weapon)"))
				end
				item.PaintOver = function()
				    if i[1] == personnes[1] then
					    if (GetConVar( "dmglog_tirscolor" ):GetBool()) then
					        item.Columns[1]:SetTextColor(Color(25, 25, 220))
						else
						    item.Columns[1]:SetTextColor(Color(0, 0, 0))
						end
					elseif i[1] == personnes[2] then
					    if (GetConVar( "dmglog_tirscolor" ):GetBool()) then
					        item.Columns[1]:SetTextColor(Color(255, 128, 0))
				   		else
						    item.Columns[1]:SetTextColor(Color(0, 0, 0))
						end
					end
				end
			end	
        end			
	end
	
	net.Receive("SendTirs", function()
	    self.combo_box:Clear()
		if net.ReadUInt(1) == 0 then
		    self:AjouterTirs(net.ReadUInt(32), net.ReadUInt(32), "nope", net.ReadString(), net.ReadString(), Damagelog.combo_box)
        else
   		    self:AjouterTirs(net.ReadUInt(32), net.ReadUInt(32), net.ReadTable(), net.ReadString(), net.ReadString(), Damagelog.combo_box)
		end
	end)
		
	self.frame_damage:AddItem(self.combo_box)

	self.dmg_logsbox = vgui.Create("DListView")
	self.dmg_logsbox:SetHeight(360)
	local c1 = self.dmg_logsbox:AddColumn("Time")
	c1:SetFixedWidth(40)
	local c2 = self.dmg_logsbox:AddColumn("Type")
	c2:SetFixedWidth(40)
	self.dmg_logsbox:AddColumn("Event")
	self.frame_damage:AddItem(self.dmg_logsbox)
	self.dmg_logsbox:AddLine("", "", "Loading...")
			
	net.Start("AskDamageLog")
	net.WriteInt(rounds, 8)
	net.SendToServer()
	damagelog_loading = {}

	self.tabs:AddSheet( "Damagelog", self.frame_damage, "icon16/application_view_detail.png", false, false)
		
end

function Damagelog:FinishedLoading()
    if self.closed then return end
	for k,v in pairs(self.damagelog_table) do
	    self:AddItem(v, self.dmg_logsbox, self.combo_box)
	end
end

net.Receive("TransferDamage", function()
    if not Damagelog.closed then Damagelog.dmg_logsbox:Clear() end
    if net.ReadUInt(1) == 1 then
        if not Damagelog.closed then
		    Damagelog.dmg_logsbox:AddLine("", "", "Empty damagelog..")
        end
	else
	    table.insert(damagelog_loading, net.ReadTable())
		if net.ReadUInt(1) == 1 then
		    Damagelog.damagelog_table = table.Copy(damagelog_loading)
			Damagelog:FinishedLoading()
			damagelog_loading = {}
		end
	end
end)

local function StrRole(role)
   if role == ROLE_TRAITOR then return "traitor"
   elseif role == ROLE_DETECTIVE then return "detective"
   else return "innocent" end
end

net.Receive("SendRoles", function()
    local roles = net.ReadTable()
	Damagelog.roles:Clear()
	for k,v in pairs(roles) do
	    Damagelog.roles:AddLine(k, StrRole(v))
	end
end)

local oldlogs_loading = {}
local function OldLogs()
    local str = net.ReadString()
    local logs = von.deserialize(util.Decompress(str))
	if logs then
	    if not Damagelog.closed then Damagelog.dmg_logsbox:Clear() end
	    Damagelog.dmg_logsbox:AddLine("","","Last round logs of the previous map ("..tostring(logs.Map)..").")
	    if logs.Logs[1] == "empty" then
            if not Damagelog.closed then
		        Damagelog.dmg_logsbox:AddLine("","","Empty damagelog..")
            end
		else
		    Damagelog.damagelog_table = logs.Logs
			Damagelog.ShootTable = logs.ShootTable
			Damagelog.Old = true
		    Damagelog:FinishedLoading()
		end
	end
end
net.Receive("SendOldMapsLogs", OldLogs)

net.Receive("Realtime_damagelog", function()
    local tbl = net.ReadTable()
	if Damagelog.dmg_logsbox and Damagelog.dmg_logsbox.GetLines then
	    local lines = Damagelog.dmg_logsbox:GetLines()
		if lines[1] and lines[1].Columns[3] == "Empty damagelog.." then
		    Damagelog.dmg_logsbox:Clear()
		end 
		Damagelog:AddItem(tbl, Damagelog.dmg_logsbox, Damagelog.combo_box)
    end
end)