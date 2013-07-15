-- derma.DefineControl is bugged (when I tried it), so let's do that

function Damagelog.Combo_SetRank(self, rank, value)

	self.firstselect = true
	self.rank = rank
	for k,v in ipairs(Damagelog.rules) do
		self:AddChoice(v, k)
	end
	self:ChooseOptionID(value)
	
end

function Damagelog.Combo_OnSelect(self, index, value, data)
	
	if not self.firstselect then
		net.Start("SetSetting")
		net.WriteString(self.rank)
		net.WriteUInt(data, 8)
		net.SendToServer()
	end
	self.firstselect = false

end

function Damagelog.Combo_DoClick()
	return
end