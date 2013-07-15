
/*---------------------------------------------------------
   Options
---------------------------------------------------------*/

function Damagelog:drawOptions()

    local selectedcolor

    self.frame_options = vgui.Create("DPanelList")
	self.frame_options:SetSpacing(10)
	self.frame_options:EnableVerticalScrollbar(true)
	
	self.form4 = vgui.Create("DForm")
	self.form4:SetName("Color settings")
	
	self.colorchoice = vgui.Create("DComboBox")
	for k,v in pairs(self.Colors or self.DefaultColors) do
	    self.colorchoice:AddChoice(k)
	end
	self.colorchoice:ChooseOptionID(1)
	self.colorchoice.OnSelect = function(index,value,data)
	    self.colormixer:SetColor(self.Colors[data] or self.DefaultColors[data])
		selectedcolor = data
	end
	self.form4:AddItem(self.colorchoice)
	
	self.colormixer = vgui.Create("DColorMixer")
	self.colormixer:SetHeight(200)
	local found = false
	for k,v in pairs(self.Colors or self.DefaultColors) do
	    if not found then
	        self.colormixer:SetColor(v)
			selectedcolor = k
			found = true
		end
	end
	self.form4:AddItem(self.colormixer)
	
	self.changecolor = vgui.Create("DButton")
	self.changecolor:SetText("Save changes")
	self.changecolor.DoClick = function()
	    local c = self.colormixer:GetColor()
		self.Colors[selectedcolor] = c
		sql.Query(string.format("UPDATE damagelog_colors SET r = %i, g = %i, b = %i WHERE color = '%s'", c.r, c.g, c.b, selectedcolor))
	end
	self.form4:AddItem(self.changecolor)
	
	self.defaultcolor = vgui.Create("DButton")
	self.defaultcolor:SetText("Set the default value to this color")
	self.defaultcolor.DoClick = function()
		local c = self.DefaultColors[selectedcolor]
	    self.colormixer:SetColor(c)
		self.Colors[selectedcolor] = c
		sql.Query(string.format("UPDATE damagelog_colors SET r = %i, g = %i, b = %i WHERE color = '%s'", c.r, c.g, c.b, selectedcolor))
	end	
	self.form4:AddItem(self.defaultcolor)
	
	self.frame_options:AddItem(self.form4)
	
	local function addAdminStuff()
			
		local tbl = net.ReadTable()
					
		self.weaponedit = vgui.Create("DForm")
		self.weaponedit:SetName("Edit weapon/entity names (only superadmins)")
		
		self.addweapon = vgui.Create("DButton")
		self.addweapon:SetText("Add a new weapon or entity")
		self.addweapon.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then return end
			Derma_StringRequest("Weapon class", "What's the class of the weapon/entity you want to add? Example : weapon_zm_mac10", "weapon_", function(class)
				Derma_StringRequest("Weapon text", "What name should be displayed? Example : a MAC10", "", function(name)
					net.Start("AddWeaponDamagelog")
					net.WriteString(class)
					net.WriteString(name)
					net.SendToServer()
				end)
			end)
		end
		self.weaponedit:AddItem(self.addweapon)
		
		self.removeweapon = vgui.Create("DButton")
		self.removeweapon:SetText("Remove the selected weapons/entities")
		self.removeweapon.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then return end
			local classes = {}
			for k,v in pairs(self.weplistview:GetSelected()) do
				table.insert(classes, v:GetValue(1))
			end
			net.Start("RemoveWeaponClassDamagelog")
			net.WriteTable(classes)
			net.SendToServer()
		end
		self.weaponedit:AddItem(self.removeweapon)
		
		self.defaultwep = vgui.Create("DButton")
		self.defaultwep:SetText("Set the table to default")
		self.defaultwep.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then return end
			Derma_Query("Set the table to default", "Are you sure?", "Yes", function()
				net.Start("WeaponTableDefault")
				net.SendToServer()
			end, "No", function() end)
		end
		self.weaponedit:AddItem(self.defaultwep)
		
		self.weplistview = vgui.Create("DListView")
		self.weplistview:SetHeight(136)
		self.weplistview:AddColumn("Weapon/entity class")
		self.weplistview:AddColumn("Text")
		
		local function updateListView(e)
			self.weplistview:Clear()
			for k,v in pairs(Damagelog.weapon_table) do
				local line = self.weplistview:AddLine(k,v)
				if not self.weapon_table_default[k] then
					line.PaintOver = function()
						line.Columns[1]:SetTextColor(Color(50, 255, 50))
						line.Columns[2]:SetTextColor(Color(50, 255, 50))
					end
				end
			end
		end
		updateListView()
		
		self.weaponedit:AddItem(self.weplistview)
		
		function Damagelog:update_callback()
			updateListView()
		end
		
		self.frame_options:AddItem(self.weaponedit)

		self.admin = vgui.Create("DForm")
		self.admin:SetName("Privileges settings (only superadmins)")
		
		local function customizeComboBox(combobox)
			if not LocalPlayer():IsSuperAdmin() then
				combobox.DoClick = self.Combo_DoClick
			end
			combobox.SetRank = self.Combo_SetRank
			combobox.OnSelect = self.Combo_OnSelect
		end
		
		self.label_regular = vgui.Create("DLabel", self.admin)
		self.label_regular:SetText("Regular players rules :")
		self.label_regular:SetPos(5, 30)
		self.label_regular:SizeToContents()
		
		self.combo_regular = vgui.Create("DComboBox", self.admin)
		customizeComboBox(self.combo_regular)
		self.combo_regular:SetRank("Regular", tbl.Regular)
		self.combo_regular:SetSize(400, 20)
		self.combo_regular:SetPos(130, 27)
		
		self.label_admin = vgui.Create("DLabel", self.admin)
		self.label_admin:SetText("Admin rules :")
		self.label_admin:SetPos(5, 55)
		self.label_admin:SizeToContents()
		
		self.combo_admin = vgui.Create("DComboBox", self.admin)
		customizeComboBox(self.combo_admin)
		self.combo_admin:SetRank("Admin", tbl.Admin)
		self.combo_admin:SetSize(400, 20)
		self.combo_admin:SetPos(130, 52)
		
		self.label_superadmin = vgui.Create("DLabel", self.admin)
		self.label_superadmin:SetText("SuperAdmin rules :")
		self.label_superadmin:SetPos(5, 80)
		self.label_superadmin:SizeToContents()
		
		self.combo_superadmin = vgui.Create("DComboBox", self.admin)
		customizeComboBox(self.combo_superadmin)
		self.combo_superadmin:SetRank("SuperAdmin", tbl.SuperAdmin)
		self.combo_superadmin:SetSize(400, 20)
		self.combo_superadmin:SetPos(130, 77)
		
		self.frame_options:AddItem(self.admin)
		
	end
	net.Receive("SendAdminStuff", addAdminStuff)
	
	net.Start("AskAdminStuff")
	net.SendToServer()
		
	self.tabs:AddSheet( "Settings", self.frame_options, "icon16/wrench.png", false, false)
end