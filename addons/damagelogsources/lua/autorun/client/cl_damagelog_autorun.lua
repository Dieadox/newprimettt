
Damagelog = {}
Damagelog.firsttime = true
Damagelog.closed = true
Damagelog.f8_used = false
Damagelog.damagelog_table = {}

if not von then
	include("not_my_code/von.lua")
end

include("vgui/drulescombobox.lua")
include("sh_weapontable.lua")
include("cl_weapontable.lua")
include("sh_privileges.lua")
include("cl_menu.lua")
include("cl_core.lua")
include("cl_options.lua")
include("cl_damagetab.lua")
include("cl_tirs.lua")
