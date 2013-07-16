function Damagelog:drawMenu(button)
    self.closed = false
	self.menu = vgui.Create("DFrame")
	self.menu:SetSize(665, 680)
	self.menu:Center()
	self.menu:SetTitle("Damagelog menu (by Tommynator) - BETA")
	self.menu:SetDraggable(true)
	self.menu:SetMouseInputEnabled(true)
    self.menu:SetKeyboardInputEnabled(true)
	self.menu:MakePopup();
	self:drawDamageTab(button)
	self:drawTirs()
	self:drawOptions()
end	
      		
function Damagelog:damagelogMenu()
	if LocalPlayer():CanUseDamagelog() then 
		LocalPlayer().chatPrint("Has opened the damage log")
		self:drawMenu()
	else
		chat.AddText(Color(255, 62, 62, 255), "You can't open the menu right now.")
	end
end

concommand.Add("+damagelog", function() Damagelog:damagelogMenu(false) end)		
concommand.Add("-damagelog", function() 
    Damagelog.closed = true
	Damagelog.start_effect = false
	Damagelog.menu:Close()
end)

concommand.Add("damagelog", function() Damagelog:damagelogMenu(true) end);		

local bind = false
hook.Add("Think", "DamagelogMenuOpen", function()
	if (input.IsKeyDown(KEY_F8)) then
		if not bind then
			bind = true
			if Damagelog.menu and Damagelog.menu:IsVisible() then
				Damagelog.menu:Close()
				return false
			else
                RunConsoleCommand("damagelog")
			end
		end
	else
		bind = false
	end
end)

net.Receive("BroadcastSettings", function()
	local tbl = net.ReadTable()
	Damagelog.settings = tbl
end)