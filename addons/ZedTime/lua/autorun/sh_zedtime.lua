-- Item IDs have to be powers of 2, so let's find the biggest ID
local function getMaxID()
    local max_id = 4
    for k,v in pairs(EquipmentItems) do
        for role, item in pairs(v) do
	        if item.id > max_id and bit.band(item.id, item.id-1) == 0 then
		        max_id = item.id
		    end
	    end
    end
    return max_id
end    

-- Using Initialize hook because this has to be done after the gamemode has loaded
local function InitializeZedTime()
    if not EquipmentItems then return end
	local enabled = SERVER and GetConVar("ttt_zedtime_enable"):GetBool() or net.ReadUInt(1) == 1
	local enabled_traitor = SERVER and GetConVar("ttt_zedtime_traitor"):GetBool() or net.ReadUInt(1) == 1
	local enabled_detective = SERVER and GetConVar("ttt_zedtime_detective"):GetBool() or net.ReadUInt(1) == 1
	if not enabled then return end
    EQUIP_ZEDTIME = getMaxID()*2
    local tbl = {
        id = EQUIP_ZEDTIME,
	    type = "item_active",
	    material = "zedtime_icon",
	    name = "item_zedtime",
	    desc = "item_zedtime_desc"
    }
	if enabled_traitor then
        if SERVER and GetConVar("ttt_zedtime_traitor_loadout"):GetBool() then
		    tbl["loadout"] = true
		end
		table.insert(EquipmentItems[ROLE_TRAITOR], tbl)    
    end
	if enabled_detective then
        if SERVER and GetConVar("ttt_zedtime_detective_loadout"):GetBool() then
		    tbl["loadout"] = true
		end
	    table.insert(EquipmentItems[ROLE_DETECTIVE], tbl)
	end	
end
if SERVER then
    hook.Add("Initialize", "InitializeZedTime", InitializeZedTime)
else
    net.Receive("SendZTInfos", InitializeZedTime)
end

local meta = FindMetaTable("Player")
function meta:UsedZedTime()
    return self:GetNWBool("zedtime", true)
end