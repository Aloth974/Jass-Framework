// You have to define these constants :
// constant real TextPositionX = <Position X of text on screen>
// constant real TextPositionY = <Position Y of text on screen>

library Utilities initializer init needs Constants
	globals
		string array PlayerColor[15]
	endglobals
	
	function CombatText takes string s, real size, unit u, real r, real g, real b, real ang1, real ang2 returns nothing
		local texttag t = null
		local real angle = 0.
		if IsUnitVisible(u, GetLocal()) then
			set t = CreateTextTag()
			set angle = GetRandomReal(ang1, ang2)
			call SetTextTagText(t, s, size * 0.023 / 10)
			call SetTextTagPosUnit(t, u, 0.)
			call SetTextTagColor(t, PercentToInt(r, 255), PercentToInt(g, 255), PercentToInt(b, 255), 255)
			call SetTextTagPermanent(t, false)
			call SetTextTagVelocity(t, 0.035 * Cos(angle * bj_DEGTORAD), 0.035 * Sin(angle * bj_DEGTORAD))
			call SetTextTagLifespan(t, 2.)
			call SetTextTagFadepoint(t, 1.5)
			call SetTextTagVisibility(t, true)
			set t = null
		endif
	endfunction
	
	function DisplayTextToAll takes real duration, string text returns nothing
		if duration <= 0. then
			call DisplayTextToPlayer(GetLocal(), TextPositionX, TextPositionY, text)
		else
			call DisplayTimedTextToPlayer(GetLocal(), TextPositionX, TextPositionY, duration, text)
		endif
	endfunction
	
	function DisplayTextToOne takes player p, real duration, string text returns nothing
		if duration <= 0. then
			call DisplayTextToPlayer(p, TextPositionX, TextPositionY, text)
		else
			call DisplayTimedTextToPlayer(p, TextPositionX, TextPositionY, duration, text)
		endif
	endfunction
	
	function GetColorByPlayerId takes integer i returns string
		if i < 0 or i > 14 then
			return COLOR_WHITE
		else
			return PlayerColor[i]
		endif
	endfunction
	
	function TriggerRegisterAnyUnitEvent takes trigger trig, playerunitevent whichEvent, boolexpr filter returns nothing
		local integer index = 0
		loop
			call TriggerRegisterPlayerUnitEvent(trig, GetPlayer(index), whichEvent, filter)
			set index = index + 1
			exitwhen index >= bj_MAX_PLAYER_SLOTS
		endloop
	endfunction
	
	function GetItemOfTypeInUnitInventory takes unit u, integer itemid returns item
		local integer i = 0
		loop
			exitwhen i >= 6
			if GetItemTypeId(UnitItemInSlot(u, i)) == itemid then
			    return UnitItemInSlot(u, i)
			endif
			set i = i + 1
		endloop
		return null
	endfunction
	
	function GetItemSlot takes unit u, item it returns integer
		local integer i = 0
		local integer result = -1
		loop
			exitwhen i >= 6
			if UnitItemInSlot(u, i) == it then
			    set result = i
			    exitwhen true
			endif
			set i = i + 1
		endloop
		return result
	endfunction
	
	function ModifyLife takes unit u, real delta returns real
		local real d = delta
		local real max = GetUnitState(u, UNIT_STATE_MAX_LIFE)
		local real cur = GetWidgetLife(u)
		local real r = cur + delta
		if r <= 0. then
			set r = 0.
			set d = -cur
		elseif r >= max then
			set r = max
			set d = max - cur
		endif
		call SetWidgetLife(u, r)
		return d
	endfunction
	
	function ModifyMana takes unit u, real delta returns real
		local real d = delta
		local real max = GetUnitState(u, UNIT_STATE_MAX_MANA)
		local real cur = GetUnitState(u, UNIT_STATE_MANA)
		local real r = cur + delta
		if r <= 0. then
			set r = 0.
			set d = cur
		elseif r >= max then
			set r = max
			set d = max-cur
		endif
		call SetUnitState(u, UNIT_STATE_MANA, r)
		return d
	endfunction

	private function init takes nothing returns nothing
		set PlayerColor[0] = COLOR_RED
		set PlayerColor[1] = COLOR_BLUE
		set PlayerColor[2] = COLOR_CYAN
		set PlayerColor[3] = COLOR_PURPLE
		set PlayerColor[4] = COLOR_YELLOW
		set PlayerColor[5] = COLOR_ORANGE
		set PlayerColor[6] = COLOR_GREEN
		set PlayerColor[7] = COLOR_PINK
		set PlayerColor[8] = COLOR_LIGHT_GREY
		set PlayerColor[9] = COLOR_LIGHT_BLUE
		set PlayerColor[10] = COLOR_AQUA
		set PlayerColor[11] = COLOR_BROWN
		set PlayerColor[12] = COLOR_DARK_ORANGE
		set PlayerColor[13] = COLOR_DARK_AQUA
		set PlayerColor[14] = COLOR_DARK_GREY
	endfunction
endlibrary
