net.Receive("ZedTime", function()
	local enabled = net.ReadUInt(1) == 1
	local validply = net.ReadUInt(1) == 1
	local ply
	if validply then
		ply = net.ReadEntity()
	end
	hook.Call("ZedTime", GAMEMODE, ply, enabled)
end)
	
hook.Add("Initialize", "InitializeZedTimeClient", function()

	LANG.AddToLanguage("english", "item_zedtime", "ZedTime")
	LANG.AddToLanguage("english", "item_zedtime_desc", "A Killing Floor like ZedTime.\nOne use only; it slows down the game for a short time,\nmaking aiming and stuff easy.\nbind a key for 'zedtime' or use the\n'hold gravity gun' key.")
	LANG.AddToLanguage("english", "item_zedtime_once", "You can only use the ZedTime once.")
	LANG.AddToLanguage("english", "item_zedtime_nobuy", "You can't use the ZedTime because you didn't buy it.")
	LANG.AddToLanguage("english", "item_zedtime_role", "Your role doesn't allow using the ZedTime.")
	
	function GAMEMODE:ZedTime(ply, enabled)
		local str = enabled and "enter" or "exit"
		local sound = "/zt_"..str..".wav"
		surface.PlaySound(sound)
	end
	
end)
	
local function askZedTime()
	net.Start("ZedTime_Ask")
	net.SendToServer()
end
	
hook.Add("PlayerBindPress", "PlayerBindPressZedTime", function(ply,key,pressed)
	if string.find(string.lower(key), "phys_swap") and pressed then
		askZedTime()
	end
end)
	
concommand.Add("zedtime", askZedTime)