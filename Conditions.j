library Conditions needs Constants, Maths, Unit
	// Filters
	function IsHuman takes nothing returns boolean
		return GetPlayerSlotState(GetFilterPlayer()) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(GetFilterPlayer()) == MAP_CONTROL_USER
	endfunction
	
	function IsComputer takes nothing returns boolean
		return GetPlayerSlotState(GetFilterPlayer()) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(GetFilterPlayer()) == MAP_CONTROL_COMPUTER
	endfunction
	
	function IsPlayed takes nothing returns boolean
		return IsHuman() or IsComputer()
	endfunction
	
	function IsHero takes nothing returns boolean
		return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true
	endfunction
	
	function IsTriggerUnitHero takes nothing returns boolean
		return IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true
	endfunction
	
	// Conditions
	function IsSlotHuman takes player p returns boolean
		return GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(p) == MAP_CONTROL_USER
	endfunction
	
	function IsSlotComputer takes player p returns boolean
		return GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(p) == MAP_CONTROL_COMPUTER
	endfunction
	
	function IsSlotPlayed takes player p returns boolean
		return IsSlotHuman(p) or IsSlotComputer(p)
	endfunction
	
	function IsUnitHero takes unit u returns boolean
		return IsUnitType(u, UNIT_TYPE_HERO) == true
	endfunction
	
	function IsUnitBehindTarget takes unit caster, unit target returns boolean
		local real casterFacing = GetUnitFacing(caster)
		local real targetFacing = GetUnitFacing(target)
		local real casterSin = Sin(casterFacing * bj_DEGTORAD)
		local real casterCos = Cos(casterFacing * bj_DEGTORAD)
		local real targetSinMin = Sin(targetFacing * bj_DEGTORAD) - 0.9
		local real targetSinMax = Sin(targetFacing * bj_DEGTORAD) + 0.9
		local real targetCosMin = Cos(targetFacing * bj_DEGTORAD) - 0.9
		local real targetCosMax = Cos(targetFacing * bj_DEGTORAD) + 0.9
		if targetSinMin > 1. then
			set targetSinMin = 1.
		endif
		if targetSinMax > 1. then
			set targetSinMax = 1.
		endif
		if targetCosMin > 1. then
			set targetCosMin = 1.
		endif
		if targetCosMax > 1. then
			set targetCosMax = 1.
		endif
		if targetSinMin < -1. then
			set targetSinMin = -1.
		endif
		if targetSinMax < -1. then
			set targetSinMax = -1.
		endif
		if targetCosMin < -1. then
			set targetCosMin = -1.
		endif
		if targetCosMax < -1. then
			set targetCosMax = -1.
		endif
		return casterSin > targetSinMin and casterSin < targetSinMax and casterCos > targetCosMin and casterCos < targetCosMax
	endfunction

	function UnitHasEmptySlot takes unit u returns boolean
		return UnitItemInSlot(u, 0) == null or UnitItemInSlot(u, 1) == null or UnitItemInSlot(u, 2) == null or UnitItemInSlot(u, 3) == null or UnitItemInSlot(u, 4) == null or UnitItemInSlot(u, 5) == null
	endfunction
	
	function UnitHasItemOfType takes unit u, integer itemid returns boolean
		local integer i = 0
		local boolean result = false
		loop
			exitwhen i >= 6
			if GetItemTypeId(UnitItemInSlot(u, i)) == itemid then
			    set result = true
			endif
			set i = i + 1
		endloop
		return result
	endfunction
	
	function UnitHasItemOfClass takes unit u, itemtype itype returns boolean
		local integer i = 0
		local boolean result = false
		loop
			exitwhen i >= 6
			if GetItemType(UnitItemInSlot(u, i)) == itype then
			    set result = true
			endif
			set i = i + 1
		endloop
		return result
	endfunction

	function IsNearbyUnit takes real x, real y, real range returns boolean
		local group g = GetUnitsInRange(x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyUnitOfUnit takes unit u, real range returns boolean
		return IsNearbyUnit(GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyEnemy takes player p, real x, real y, real range returns boolean
		local group g = GetEnnemiesInRange(p, x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyEnemyOfUnit takes unit u, real range returns boolean
		return IsNearbyEnemy(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyEnemyWithoutStructures takes player p, real x, real y, real range returns boolean
		local group g = GetEnnemiesInRange(p, x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyEnemyOfUnitWithoutStructures takes unit u, real range returns boolean
		return IsNearbyEnemyWithoutStructures(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyAlly takes player p, real x, real y, real range returns boolean
		local group g = GetAlliesInRange(p, x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyAllyOfUnit takes unit u, real range returns boolean
		return IsNearbyAlly(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyHero takes real x, real y, real range returns boolean
		local group g = GetUnitsInRange(x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		call GroupKeepHeroes(g)
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyHeroOfUnit takes unit u, real range returns boolean
		return IsNearbyHero(GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyEnemyHero takes player p, real x, real y, real range returns boolean
		local group g = GetEnnemiesInRange(p, x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		call GroupKeepHeroes(g)
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyEnemyHeroOfUnit takes unit u, real range returns boolean
		return IsNearbyEnemyHero(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
	endfunction

	function IsNearbyAllyHero takes player p, real x, real y, real range returns boolean
		local group g = GetAlliesInRange(p, x, y, range, 0)
		call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
		call GroupKeepHeroes(g)
		set buffer_BOOL = CountUnitsInGroup(g) > 0
		call DeleteGroup(g)
		return buffer_BOOL
	endfunction
	function IsNearbyAllyHeroOfUnit takes unit u, real range returns boolean
		return IsNearbyAllyHero(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
	endfunction
endlibrary
