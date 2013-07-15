
Damagelog.rules = {
	[1] = "Can't use the damagelog",
	[2] = "Can only use the damagelog when the round isn't active",
	[3] = "Can use the damagelog when spectating and when the round isn't active",
	[4] = "Can always use the damagelog"
}

local function checkSettings(self, str)
	local value = Damagelog.settings[str]
	if value == 1 then
		return false
	elseif value == 2 then
		return GetRoundState() != ROUND_ACTIVE
	elseif value == 3 then
		return GetRoundState() != ROUND_ACTIVE or self:IsSpec()
	elseif value == 4 then
		return true
	end
	return false
end
	

local meta = FindMetaTable("Player")

function meta:CanUseDamagelog()
	if self:IsSuperAdmin() then
		return checkSettings(self, "SuperAdmin")
	elseif self:IsAdmin() then
		return checkSettings(self, "Admin")
	else
		return checkSettings(self, "Regular")
	end
end