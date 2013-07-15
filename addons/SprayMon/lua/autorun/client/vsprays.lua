local sprays = {}

net.Receive("vAddSpray", function()
	local ply = net.ReadEntity()
	if ply.SteamID then
		local normal = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local ang = normal:Angle()
		local vec = ang:Forward() * .001 + (ang:Right() + ang:Up()) * 32
		local pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat()) + ang:Up() * 4
		sprays[ply:SteamID()] = {name = ply:Name(), pos1 = pos - vec, pos2 = pos + vec, normal = normal, clears = 0}
	end
end)

local function clear()
	for k, v in pairs(sprays) do
		v.clears = v.clears + 1
		if v.clears >= 2 then
			sprays[k] = nil
		end
	end
end
net.Receive("vClearDecals", clear)

local old = RunConsoleCommand
RunConsoleCommand = function(cmd, ...)
	if cmd == "r_cleardecals" then
		clear()
	end
	return old(cmd, ...)
end

local function isin(num, num1, num2)
	return (num >= num1 and num <= num2) or (num <= num1 and num >= num2)
end

surface.CreateFont("vSpray", {font = "Trebuchet MS", size = 24, weight = 900})

local first = true

hook.Add("HUDPaint", "vPrintSprays", function()
	local todraw = {}
	local trace = LocalPlayer():GetEyeTrace()
	for k, v in pairs(sprays) do
		if v.normal == trace.HitNormal and isin(trace.HitPos.x, v.pos1.x, v.pos2.x) and isin(trace.HitPos.y, v.pos1.y, v.pos2.y) and isin(trace.HitPos.z, v.pos1.z, v.pos2.z) then
			table.insert(todraw, k)
		end
	end
	if #todraw > 0 then
		if first then
			chat.AddText(Color(128, 128, 128), "You can view SteamID of spray owner by holding ALT while looking at it.")
			first = false
		end
		local y = ScrH() / 2 - #todraw * 12
		draw.SimpleText("Sprayed by:", "vSpray", 10, y, Color(0, 63.75, 255), 0, 1)
		for k, v in pairs(todraw) do
			y = y + 24
			draw.SimpleText(sprays[v].name .. (input.IsKeyDown(KEY_LALT) and (": " .. v) or ""), "vSpray", 10, y, Color(0, 63.75, 255), 0, 1)
		end
	end
end)

hook.Add("PlayerBindPress", "vNoSprayDelay", function(_, cmd)
	if string.find(cmd, "impulse 201") then
		net.Start("vSpray")
		net.SendToServer()
	end
end)