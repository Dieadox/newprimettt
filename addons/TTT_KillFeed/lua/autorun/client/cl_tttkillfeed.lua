// Determined by team number
local roles = {
" innocent!", 
" traitor!", 
" detective!"
}

// In Order: Green, Red, Blue
local rolecolors = {
Color(0, 255, 0), 
Color(255, 0, 0), 
Color(0, 85, 255)
} 

// Notifying player in chat.
function PrintKillFeed(um)
	local nick = um:ReadString()
	local team = um:ReadChar()
	chat.AddText(Color(255, 255, 255), "You've been killed by ", rolecolors[team], nick, Color(255, 255, 255), ", they are a", rolecolors[team], roles[team])
end

usermessage.Hook("KillFeed", PrintKillFeed)