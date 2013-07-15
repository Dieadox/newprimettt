
AddCSLuaFile("autorun/client/cl_zedtime.lua")
AddCSLuaFile("autorun/sh_zedtime.lua")

resource.AddFile("sound/zt_enter.wav")
resource.AddFile("sound/zt_exit.wav")
resource.AddFile("materials/zedtime_icon.vmt")

util.AddNetworkString("ZedTime")
util.AddNetworkString("ZedTime_Ask")
util.AddNetworkString("SendZTInfos")

CreateConVar("ttt_zedtime_enable", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED)
CreateConVar("ttt_zedtime_endround", "0") -- slow motion effect when a round ends
CreateConVar("ttt_zedtime_duration", "1.2")
CreateConVar("ttt_zedtime_detective", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED)
CreateConVar("ttt_zedtime_detective_loadout", "0")
CreateConVar("ttt_zedtime_traitor", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED)
CreateConVar("ttt_zedtime_traitor_loadout", "0")

local zedtime_active = false
		
local function bool_to_bit(bool)
	return bool and 1 or 0
end
	
-- FCVAR_REPLICATED is broke on gmod, so..
hook.Add("PlayerAuthed", "PlayerAuthedZT", function(ply)
	net.Start("SendZTInfos")
	net.WriteUInt(bool_to_bit(GetConVar("ttt_zedtime_enable"):GetBool()), 1)
	net.WriteUInt(bool_to_bit(GetConVar("ttt_zedtime_traitor"):GetBool()), 1)
	net.WriteUInt(bool_to_bit(GetConVar("ttt_zedtime_detective"):GetBool()), 1)
	net.Send(ply)
end)

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawnZT", function(ply)
	ply:SetUsedZedTime(false)
end)
		
local meta = FindMetaTable("Player")
function meta:SetUsedZedTime(b)
	self:SetNWBool("zedtime", b)
end
meta = nil	
	
local function informZed(bit, ply)
	hook.Call("ZedTime", GAMEMODE, ply, bit)
	net.Start("ZedTime")
	net.WriteUInt(bit and 1 or 0, 1)
	if IsValid(ply) then
		net.WriteUInt(1,1)
		net.WriteEntity(ply)
	else
		net.WriteUInt(0,1)
	end
	net.Broadcast()
end
		
hook.Add("TTTBeginRound", "BeginRoundZT", function()
	for k,v in pairs(player.GetAll()) do
		if v:UsedZedTime() then
		    v:SetUsedZedTime(false)
		end
	end
end)
	
hook.Add("TTTEndRound", "EndRoundZT", function()
	if GetConVar("ttt_zedtime_endround"):GetBool() then 
	    GAMEMODE:EnableZedTime()
    end
end)
	
-- Also using Initialize, so this works with hooks
hook.Add("Initialize", "InitializeZTHooks", function()
	
	-- Called when the player tries to use a zed time, return false to prevent
	function GAMEMODE:CanUseZedTime(ply)
		if not IsValid(ply) then return false end
		if zedtime_active then return false end
		if ply:IsActiveSpecial() then
			local found = false
			for k,v in pairs(EquipmentItems[ply:GetRole()]) do
				if v.id == EQUIP_ZEDTIME then
					found = true
				end
			end
			if not found then
				LANG.Msg(ply, "item_zedtime_role")
				return false
			end
			if ply:HasEquipmentItem(EQUIP_ZEDTIME) then
			    if ply:UsedZedTime() then
					LANG.Msg(ply, "item_zedtime_once")
					return false
				end
				return true
			else
				LANG.Msg(ply, "item_zedtime_nobuy")
				return false
			end
		end
		return false
	end  
		
	-- Called to enable ZedTime
	function GAMEMODE:EnableZedTime(ply)
	    if IsValid(ply) then ply:SetUsedZedTime(true) end
	    game.SetTimeScale(0.3)
		informZed(true, ply)
		zedtime_active = true
		local duration = GetConVar("ttt_zedtime_duration"):GetFloat()
		timer.Simple(duration, function()
		    game.SetTimeScale(1)
			informZed(false)
			zedtime_active = false
		end)
	end
		
	-- Called when ZedTime is enabled or disabled
	function GAMEMODE:ZedTime(ply, enabled)
		if enabled and IsValid(ply) then
			DamageLog(string.format("ZEDTIME:\t %s [%s] used his ZedTime", ply:Nick(), ply:GetRoleString()))
		end
	end
end)
	
net.Receive("ZedTime_Ask", function(len,ply)
	if hook.Call("CanUseZedTime", GAMEMODE, ply) then
		hook.Call("EnableZedTime", GAMEMODE, ply)
	end
end)