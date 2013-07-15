/*---------------------------------------------------------
   Thank you : http://lua-users.org/wiki/SortedIteration
---------------------------------------------------------*/

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end
    -- fetch the next value
    key = nil
    for i = 1,table.getn(t.__orderedIndex) do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end


/*---------------------------------------------------------
   Onglet tirs
---------------------------------------------------------*/

function Damagelog:drawTirs()
	self.combo_tirs = vgui.Create("DListView")
	self.combo_tirs:AddColumn("")
	self.tabs:AddSheet( "Shots", self.combo_tirs, "icon16/page_white_find.png", false, false)
	net.Start("AskTirsLogs")
	net.WriteUInt(rounds, 8)
	net.SendToServer()
end

local tircolors = {
    [Color(46,46,46)] = true,
	[Color(66,66,66)] = true,
	[Color(125,125,125)] = true,
	[Color(255,6,13)] = true,
	[Color(0,0,128)] = true,
	[Color(0,0,205)] = true,
	[Color(79,209,204)] = true,
	[Color(165,42,42)] = true,
	[Color(238,59,59)] = true,
	[Color(210,105,30)] = true,
	[Color(255,165,79)] = true,
	[Color(107,66,38)] = true,
	[Color(166,128,100)] = true,
	[Color(0,100,0)] = true,
	[Color(34,139,34)] = true,
	[Color(124,252,0)] = true,
	[Color(78,328,148)] = true,
	[Color(139,10,80)] = true,
	[Color(205,16,118)] = true,
	[Color(205,85,85)] = true,
	[Color(110,6,250)] = true,
	[Color(30,235,0)] = true,
	[Color(205,149,12)] = true,
	[Color(0,0,250)] = true,
	[Color(219,150,50)] = true,
	[Color(255,36,0)] = true,
	[Color(205,104,57)] = true,
	[Color(191,62,255)] = true,
	[Color(99,86,126)] = true,
	[Color(133,99,99)] = true
}

local function TirsLogs(_)
	local len = net.ReadUInt(32)
    local tirs = von.deserialize(util.Decompress(net.ReadData(len)) or "")
    local used_nicks = {}
    for k,v in orderedPairs(tirs) do
	    for c,d in orderedPairs(v) do
		    local color
		    if not used_nicks[d[1]] then
				local found = false
				for k,v in RandomPairs(tircolors) do
				    if v and not found then
					    color = k
						found = true
					end
				end
				if found then
				    tircolors[color] = false
				    used_nicks[d[1]] = color
				else
				    used_nicks[d[1]] = Color(255, 255, 255)
				end
			else
			    color = used_nicks[d[1]]
			end
	     	local item
			if d[2] == "crowbartir" then
				item = Damagelog.combo_tirs:AddLine(Format("%s - %s has shot with a crowbar", string.FormattedTime(k, "%02i:%02i"), d[1]))
			elseif d[2] == "crowbarpouss" then
				item = Damagelog.combo_tirs:AddLine(Format("%s - %s has pushed %s with a crowbar", string.FormattedTime(k, "%02i:%02i"), d[1], d[3]))
			else
		        item = Damagelog.combo_tirs:AddLine(Format("%s - %s has shot with %s", string.FormattedTime(k, "%02i:%02i"), d[1], Damagelog.weapon_table[d[2]] or d[2] or "(unknown weapon)"))
			end
			item.PaintOver = function()
			    item.Columns[1]:SetTextColor(color)
			end
		end
	end
end
net.Receive("SendTirsLogs", TirsLogs)