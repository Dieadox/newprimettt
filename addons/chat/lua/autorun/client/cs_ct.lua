--Chat Tags by Tyguy
CreateClientConVar("chat_tags_color_r", 255, true, false)
CreateClientConVar("chat_tags_color_g", 255, true, false)
CreateClientConVar("chat_tags_color_b", 255, true, false)
CreateClientConVar("chat_tags_color_a", 255, true, false)

local Tags = 
{

--Group    --Tag     --Color
{"user", "[Guest] ", Color(255,255,255, 255) },
{"trusted", "[Trusted] ", Color(154,205,50, 255) },
--VIP ranks
{"bronze", "[Bronze] ", Color(205,133,63, 255) },
{"silver", "[Silver] ", Color(192,192,192, 255) },
{"gold", "[Gold] ", Color(255,215,0, 255) },
{"diamond", "[Diamond] ", Color(0,204,204, 255) },
{"demi-god", "[Demi-God] ", Color(183,0,106, 255) },
{"moderator", "[MODERATOR] ", Color(153,204,255, 255) },
{"admin", "[ADMIN] ", Color(0,102,204, 255) },
{"sadmin", "[S.ADMIN] ", Color(153,51,255, 255) },
{"coowner", "[Co-Owner] ", Color(153,51,255, 255) },
{"owner", "[Owner] ", Color(204, 0, 0, 255) },

}

hook.Add("OnPlayerChat", "Tags", function(ply, strText, bTeamOnly)
	if IsValid(ply) and ply:IsPlayer() then
		for k,v in pairs(Tags) do
			if ply:IsUserGroup(v[1]) then
			local R = GetConVarNumber("chat_tags_color_r")
			local G = GetConVarNumber("chat_tags_color_g")
			local B = GetConVarNumber("chat_tags_color_b")
			local A = GetConVarNumber("chat_tags_color_a")
			local nickteam = team.GetColor(ply:Team())
				if !bTeamOnly then
				chat.AddText(v[3], v[2], nickteam, ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
				return true
				else
				chat.AddText(v[3], v[2], nickteam, "(TEAM) ", ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
				return true
				end
			end
		end
	end
	if !IsValid(ply) and !ply:IsPlayer() then
	local ConsoleColor = Color(0, 255, 0) --Change this to change Console name color
	chat.AddText(ConsoleColor, "Console", color_white, ": ", strText)
	return true
	end
end )