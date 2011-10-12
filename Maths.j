library Maths initializer init needs Constants
	globals
		real MAP_MIN_X
		real MAP_MAX_X
		real MAP_MIN_Y
		real MAP_MAX_Y
		real MAP_CENTER_X
		real MAP_CENTER_Y
		location ENUMLOC
		item ENUMITEM
		rect ENUMRECT
		boolexpr GetNearestItemInRangeFilt = null
	endglobals

	function GetRandomX takes nothing returns real
		return GetRandomReal(MAP_MIN_X, MAP_MAX_X)
	endfunction
	
	function GetRandomY takes nothing returns real
		return GetRandomReal(MAP_MIN_Y, MAP_MAX_Y)
	endfunction
	
	function CheckX takes real x returns real
		if x > MAP_MAX_X then
			return MAP_MAX_X
		elseif x < MAP_MIN_X then
			return MAP_MIN_X
		else
			return x
		endif
	endfunction
	
	function CheckY takes real y returns real
		if y > MAP_MAX_Y then
			return MAP_MAX_Y
		elseif y < MAP_MIN_Y then
			return MAP_MIN_Y
		else
			return y
		endif
	endfunction
	
	function PolarX takes real x, real dist, real angle returns real
		return CheckX((x + dist * Cos(angle * bj_DEGTORAD)))
	endfunction
	
	function PolarY takes real y, real dist, real angle returns real
		return CheckY((y + dist * Sin(angle * bj_DEGTORAD)))
	endfunction
	
	function DistanceBetweenUnits takes unit caster, unit target returns real
		local real r1 = GetUnitX(target)-GetUnitX(caster)
		local real r2 = GetUnitY(target)-GetUnitY(caster)
		return SquareRoot(r1*r1+r2*r2)
	endfunction
	
	function DistanceBetweenXY takes real xc, real yc, real xt, real yt returns real
		return SquareRoot((xt - xc) * (xt - xc) + (yt - yc) * (yt - yc))
	endfunction
	
	function DistanceBetweenXYZ takes real xc, real yc, real zc, real xt, real yt, real zt returns real
		return SquareRoot((xt - xc) * (xt - xc) + (yt - yc) * (yt - yc) + (zt - zc) * (zt - zc))
	endfunction
	
	function AngleBetweenUnits takes unit caster, unit target returns real
		return Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * bj_RADTODEG
	endfunction
	
	function AngleBetweenXY takes real xc, real yc, real xt, real yt returns real
		return Atan2(yt - yc, xt - xc) * bj_RADTODEG
	endfunction

	function GetUnitZ takes unit u returns real
		if u == null then
			return 0.
		endif
		call MoveLocation(ENUMLOC, GetUnitX(u), GetUnitY(u))
		return GetLocationZ(ENUMLOC) + GetUnitFlyHeight(u)
	endfunction
	
	function SetUnitZ takes unit u, real z returns nothing
		call UnitAddAbility(u, 'Arav')
		call UnitRemoveAbility(u, 'Arav')
		call MoveLocation(ENUMLOC, GetUnitX(u), GetUnitY(u))
		if(z <= GetLocationZ(ENUMLOC)) then
			call SetUnitFlyHeight(u, 0., 200.)
		else
			call SetUnitFlyHeight(u, GetLocationZ(ENUMLOC) + z, 200.)
		endif
	endfunction
	
	function SetUnitXY takes unit u, real x, real y returns nothing
		local real xt = 0.
		local real yt = 0.
		if u != null then
			if ENUMITEM == null then
				call BJDebugMsg("|cFFF00000Warning: Dummy item empty. Creating a new one.")
				set ENUMITEM = CreateItem('phea', CheckX(x), CheckY(y))
			else
				call SetItemVisible(ENUMITEM, true)
				call SetItemPosition(ENUMITEM, CheckX(x), CheckY(y))
			endif
			set xt = GetItemX(ENUMITEM)
			set yt = GetItemY(ENUMITEM)
			call SetItemVisible(ENUMITEM, false)
			call SetUnitX(u, xt)
			call SetUnitY(u, yt)
		endif
	endfunction
	
	function GetUnitMissingLife takes unit u returns real
		return GetUnitState(u, UNIT_STATE_MAX_LIFE) - GetWidgetLife(u)
	endfunction
	
	function FGetNearestItemInRange takes nothing returns boolean
		local item it = GetFilterItem()
		if IsItemVisible(it) and GetWidgetLife(it) > 0. and it != ENUMITEM then
			if buffer_ITEM == null then
				set buffer_ITEM = it
			elseif DistanceBetweenXY(GetItemX(it), GetItemY(it), buffer_X, buffer_Y) < DistanceBetweenXY(GetItemX(ENUMITEM), GetItemY(ENUMITEM), buffer_X, buffer_Y) then
				set buffer_ITEM = it
			endif
		endif
		set it = null
		return false
	endfunction
	
	function GetNearestItemInRange takes real x, real y, real range returns item
		call MoveRectTo(ENUMRECT, x, y)
		call SetRect(ENUMRECT, x - range, y - range, x + range, y + range)
		set buffer_ITEM = null
		set buffer_X = x
		set buffer_Y = y
		call EnumItemsInRect(ENUMRECT, GetNearestItemInRangeFilt, function DoNothing)
		return buffer_ITEM
	endfunction

	private function init takes nothing returns nothing
		set MAP_MIN_X = GetRectMinX(bj_mapInitialPlayableArea)
		set MAP_MAX_X = GetRectMaxX(bj_mapInitialPlayableArea)
		set MAP_MIN_Y = GetRectMinY(bj_mapInitialPlayableArea)
		set MAP_MAX_Y = GetRectMaxY(bj_mapInitialPlayableArea)
		set MAP_CENTER_X = (MAP_MAX_X + MAP_MIN_X) / 2
		set MAP_CENTER_Y = (MAP_MAX_Y + MAP_MIN_Y) / 2
		set ENUMLOC = Location(0., 0.)
		set ENUMITEM = CreateItem('phea', 0., 0.)
		call SetItemVisible(ENUMITEM, false)
		set ENUMRECT = Rect(0., 0., 0., 0.)
		set GetNearestItemInRangeFilt = Filter(function FGetNearestItemInRange)
	endfunction
endlibrary
