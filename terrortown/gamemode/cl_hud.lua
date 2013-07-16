local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp

-- Fonts
surface.CreateFont("TraitorState", {font = "Trebuchet24",
                                    size = 28,
                                    weight = 1000})
surface.CreateFont("TimeLeft",     {font = "Trebuchet24",
                                    size = 24,
                                    weight = 800})
surface.CreateFont("HealthAmmo",   {font = "Trebuchet24",
                                    size = 24,
                                    weight = 750})
surface.CreateFont("HealthAmmoB",   {font = "Trebuchet18",
                                    size = 18,
                                    weight = 800})
									
surface.CreateFont( "npttt_tstate", {
	font = "Coolvetica",
	size = 34,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_tstate2", {
	font = "Coolvetica",
	size = 34,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true
} )

surface.CreateFont( "npttt_time", {
	font = "Coolvetica",
	size = 27,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_health", {
	font = "Coolvetica",
	size = 15,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_ammo", {
	font = "Coolvetica",
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_coins", {
	font = "Coolvetica",
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_name", {
	font = "Coolvetica",
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_ban", {
	font = "Coolvetica",
	size = 10,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "npttt_water", {
	font = "Coolvetica",
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true
} )
									
-- Colors
local bg_colors = {
   background_main = Color(0, 0, 10, 0),

   noround = Color(100,100,100,200),
   traitor = Color(200, 25, 25, 200),
   innocent = Color(25, 200, 25, 200),
   detective = Color(25, 25, 200, 200)
};

local health_colors = {
   background = Color(100, 25, 25, 0),
   fill = Color(200, 50, 50, 250)
};

local ammo_colors = {
   background = Color(20, 20, 5, 0),
   fill = Color(0,85,160, 255)
};

local ammo_colorsb = {
   background = Color(20, 20, 5, 0),
   fill = Color(255,255,255, 5)
};


-- Modified RoundedBox
local Tex_Corner8 = surface.GetTextureID( "" )
local function RoundedMeter( bs, x, y, w, h, color)
   surface.SetDrawColor(clr(color))

   surface.DrawRect( x+bs, y, w-bs*2, h )
   surface.DrawRect( x, y+bs, bs, h-bs*2 )

   surface.SetTexture( Tex_Corner8 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + bs/2, bs, bs, 0 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + h -bs/2, bs, bs, 90 )

   if w > 14 then
      surface.DrawRect( x+w-bs, y+bs, bs, h-bs*2 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + bs/2, bs, bs, 270 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + h - bs/2, bs, bs, 180 )
   else
      surface.DrawRect( x + math.max(w-bs, bs), y, bs/2, h )
   end

end

local function PaintBar(x, y, w, h, colors, value)
   draw.RoundedBox(0, x-1, y-1, w+2, h+2, colors.background)

   -- Fill
   local width = w * math.Clamp(value, 0, 1)

   if width > 0 then
      RoundedMeter(0, x, y, width, h, colors.fill)
   end
end

local roundstate_string = {
   [ROUND_WAIT]   = "round_wait",
   [ROUND_PREP]   = "round_prep",
   [ROUND_ACTIVE] = "round_active",
   [ROUND_POST]   = "round_post"
};

-- Returns player's ammo information
local function GetAmmo(ply)
   local weap = ply:GetActiveWeapon()
   if not weap or not ply:Alive() then return -1 end

   local ammo_inv = weap:Ammo1()
   local ammo_clip = weap:Clip1()
   local ammo_max = weap.Primary.ClipSize

   return ammo_clip, ammo_max, ammo_inv
end

local function DrawBg(x, y, width, height, client)
   -- Traitor area sizes
   local th = 30
   local tw = 170

   -- Adjust for these
   y = y - th
   height = height + th

   -- main bg area, invariant
   -- encompasses entire area
   draw.RoundedBox(0, x, y, width, height, bg_colors.background_main)

   -- main border, traitor based
   local col = bg_colors.innocent
   if GAMEMODE.round_state != ROUND_ACTIVE then
      col = bg_colors.noround
   elseif client:GetTraitor() then
      col = bg_colors.traitor
   elseif client:GetDetective() then
      col = bg_colors.detective
   end

   draw.RoundedBox(8, x, y, tw, th, col)
end

local sf = surface
local dr = draw

local function ShadowedText(text, font, x, y, color, xalign, yalign)

   dr.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)

   dr.SimpleText(text, font, x, y, color, xalign, yalign)
end

local margin = 10

local function PunchPaint(client)
   local L = GetLang()
   local punch = client:GetNWFloat("specpunches", 0)

   local width, height = 200, 25
   local x = ScrW() / 2 - width/2
   local y = margin/2 + height

   PaintBar(x, y, width, height, ammo_colors, punch)

   local color = bg_colors.background_main

   dr.SimpleText(L.punch_title, "HealthAmmo", ScrW() / 2, y, color, TEXT_ALIGN_CENTER)

   dr.SimpleText(L.punch_help, "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   local bonus = client:GetNWInt("bonuspunches", 0)
   if bonus != 0 then
      local text
      if bonus < 0 then
         text = interp(L.punch_bonus, {num = bonus})
      else
         text = interp(L.punch_malus, {num = bonus})
      end

      dr.SimpleText(text, "TabLarge", ScrW() / 2, y * 2, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local key_params = { usekey = Key("+use", "USE") }

local function SpecHUDPaint(client)
   local L = GetLang()

   local x       = margin
   local height  = 32
   local width   = 250
   local round_y = ScrH() - height - margin
   
	local round_state = GAMEMODE.round_state
	local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()
	local text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
   
   local centerx, centery = ScrW() / 2, ScrH() / 2

   if ScrW() < 1000 then round_y = round_y - 15 end

   local time_x = x + 170
   local time_y = round_y + 4
   
	draw.DrawText(text,"npttt_time",centerx, 45,Color(255,255,255,225),TEXT_ALIGN_CENTER)
   
	if round_state == ROUND_PREP then
	draw.DrawText("Preparing","npttt_tstate2",centerx, 20,Color(255,255,255,200),TEXT_ALIGN_CENTER)
	
	elseif round_state == ROUND_POST then
	draw.DrawText("Round Over","npttt_tstate2",centerx, 20,Color(255,255,255,200),TEXT_ALIGN_CENTER)
	
	elseif round_state == ROUND_WAIT then
	draw.DrawText("Waiting","npttt_tstate2",centerx, 20,Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end


   local tgt = client:GetObserverTarget()
   if IsValid(tgt) and tgt:IsPlayer() then
      ShadowedText(tgt:Nick(), "TimeLeft", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   elseif IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == client then
      PunchPaint(client)
   else
      ShadowedText(interp(L.spec_help, key_params), "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local ttt_health_label = CreateClientConVar("ttt_health_label", "0", true)



local function InfoPaint(client)
	local L = GetLang()
	local ply = LocalPlayer()
	local HP = ply:Health()
	local centerx, centery = ScrW() / 2, ScrH() / 2
	
	--Images
	sgh_font = Material("vgui/ttt/npttt_name3.png")
	sgh_karma_gradient = Material("vgui/ttt/gg_karmagrad.png")
	sgh_health = Material("vgui/ttt/gg_health.png")
	sgh_ammo = Material("vgui/ttt/gg_ammo.png")
	sgh_coins = Material("vgui/ttt/gg_coins.png")
	sgh_coins2 = Material("vgui/ttt/gg_coins2.png")
	sgh_karma = Material("vgui/ttt/gg_karma.png")
	
	local round_state = GAMEMODE.round_state
	local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()
	local text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
	
	
	local width = 128
	local height = 97

	local x = margin
	local y = ScrH() - margin - height

	local bar_height = 25
	local bar_width = width - (margin*0.8)
	
--  Draw health
	local health = math.max(0, client:Health())
	local health_y = y + margin
	
		draw.RoundedBox(10, 5,ScrH() - 200,230,195,Color(10,10,10,200))
		draw.RoundedBox(0, 70, ScrH() - 113,150,25,Color(0, 0, 0, 255))
		draw.RoundedBox(0, 72, ScrH() - 111,146,21,Color(50, 50, 50, 255))
		draw.RoundedBox(0, 72, ScrH() - 111,146,10,Color(255, 255, 255, 5))
		draw.DrawText("No Ammo","npttt_ammo",145,ScrH() -111,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		draw.DrawText("New Prime Gaming","npttt_water",centerx,5,Color(255,255,255,25),TEXT_ALIGN_CENTER)		
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(sgh_health)
		surface.DrawTexturedRect( 10, ScrH() - 169, 50, 50 )
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(sgh_coins)
		surface.DrawTexturedRect( 12, ScrH() - 60, 50, 50 )
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(sgh_ammo)
		surface.DrawTexturedRect( 16, ScrH() - 125, 40, 50 )
	
	if ( LocalPlayer():GetRole() == ROLE_INNOCENT ) then
		draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(10,160,10,255))
		draw.DrawText("Innocent","npttt_tstate",10,ScrH() - 193,Color(255, 255, 255,255),TEXT_ALIGN_LEFT)
	elseif ( LocalPlayer():GetRole() == ROLE_TRAITOR ) then
		draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(160,10,10,255))
		draw.DrawText("Traitor","npttt_tstate",10,ScrH() - 193,Color(255, 255,255,255),TEXT_ALIGN_LEFT)
		draw.DrawText(L.hastemode,"TabLarge", 15,ScrH() - 203,Color(255,255,255,0),TEXT_ALIGN_CENTER)
	elseif ( LocalPlayer():GetRole() == ROLE_DETECTIVE ) then
		draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(0,85,160,255))
		draw.DrawText("Detective","npttt_tstate",10,ScrH() - 193,Color(255, 255, 255,255),TEXT_ALIGN_LEFT)
	end

	if round_state == ROUND_PREP then
	draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(50,50,50,255))
	draw.DrawText("Preparing","npttt_tstate",10,ScrH() -193,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	
	elseif round_state == ROUND_POST then
	draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(50,50,50,255))
	draw.DrawText("Round Over","npttt_tstate",10,ScrH() -193,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	
	elseif round_state == ROUND_WAIT then
	draw.RoundedBox(0, 5,ScrH() - 190,230,25,Color(50,50,50,255))
	draw.DrawText("Waiting","npttt_tstate",10,ScrH() -193,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	end

// Points
    draw.DrawText(""..ply:PS_GetPoints(),"npttt_coins",70,ScrH() - 60,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	
--  HP
	draw.RoundedBox(0, 70,ScrH() - 155,150,25,Color(0,0,0,255))
	draw.RoundedBox(0, 72,ScrH() - 153,math.Clamp(HP,0,100)*1.46,21,Color(160,20,20,255))
	draw.RoundedBox(0, 72,ScrH() - 153,math.Clamp(HP,0,100)*1.46,10,Color(200,200,200,5))
	draw.DrawText(""..HP.."","npttt_ammo", 145,ScrH() - 154,Color(255,255,255,255),TEXT_ALIGN_CENTER)
	
--  Haste
	draw.DrawText(text,"npttt_time",230,ScrH() - 190,Color(255,255,255,255),TEXT_ALIGN_RIGHT)
	
--  Draw ammo
    if client:GetActiveWeapon().Primary then
		local ammo_clip, ammo_max, ammo_inv = GetAmmo(client)
		if ammo_clip != -1 then
		local ammo_y = health_y + bar_height + margin
			draw.RoundedBox(0, 70, ScrH() - 113,150,25,Color(0, 0, 0, 255))
			PaintBar( 72, ScrH() - 111, bar_width + 26, bar_height - 4, ammo_colors, ammo_clip/ammo_max)
			PaintBar( 72, ScrH() - 111, bar_width + 26, bar_height - 15, ammo_colorsb, ammo_clip/ammo_max)
			draw.DrawText(""..ammo_clip.."/"..ammo_inv.."","npttt_ammo", 145, ScrH() - 112,Color(255,255,255,255),TEXT_ALIGN_CENTER)
         local text = string.format("%i + %02i", ammo_clip, ammo_inv)
		end
    end
end

local function PaintBar(x, y, w, h, colors, value)
   draw.RoundedBox(8, x-1, y-1, w+2, h+2, Color(0,0,0,255))
   
   local width = w * math.Clamp(value, 0, 1)

   if width > 0 then
      RoundedMeter(8, x, y, width, h, Color(0,0,0,255))
   end
end


-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
   local client = LocalPlayer()

   GAMEMODE:HUDDrawTargetID()

   MSTACK:Draw(client)

   if (not client:Alive()) or client:Team() == TEAM_SPEC then
      SpecHUDPaint(client)

      return
   end


   RADAR:Draw(client)
   TBHUD:Draw(client)
   WSWITCH:Draw(client)

   VOICE.Draw(client)
   DISGUISE.Draw(client)

   GAMEMODE:HUDDrawPickupHistory()

   InfoPaint(client)
end

local hud = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}
function GM:HUDShouldDraw(name)
   for k, v in pairs(hud) do
      if name == v then return false end
   end

   return true
end