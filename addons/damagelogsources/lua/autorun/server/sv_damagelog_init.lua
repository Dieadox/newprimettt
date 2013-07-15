AddCSLuaFile("autorun/client/cl_damagelog_autorun.lua")
AddCSLuaFile("vgui/drulescombobox.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_core.lua")
AddCSLuaFile("cl_options.lua")
AddCSLuaFile("cl_damagetab.lua")
AddCSLuaFile("cl_tirs.lua")
AddCSLuaFile("not_my_code/von.lua")
AddCSLuaFile("sh_privileges.lua")
AddCSLuaFile("sh_weapontable.lua")
AddCSLuaFile("cl_weapontable.lua")

if not von then
	include("not_my_code/von.lua")
end

Damagelog = {}
file.CreateDir("damagelog")

include("sv_core.lua")
include("sv_networking.lua")
include("sh_privileges.lua")
include("sv_events.lua")
include("sh_weapontable.lua")
include("sv_weapontable.lua")
include("sv_settings.lua")