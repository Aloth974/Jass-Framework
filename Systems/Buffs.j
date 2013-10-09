library Buffs initializer init needs Hashtable, Ticker, Unit
	globals
		constant integer BuffEvent1 = 1
		constant integer BuffEvent2 = 2
		constant integer BuffEvent3 = 3
		trigger array BuffTriggers__UnitDie
		trigger array BuffTriggers__ExpiresBeforeEnd
		trigger array BuffTriggers__Expires
		integer BuffTriggerCounter__UnitDie
		integer BuffTriggerCounter__ExpiresBeforeEnd
		integer BuffTriggerCounter__Expires
	endglobals
	
	function GetEventBuffSource takes nothing returns unit
		return HTLoadUnitHandle(GetTriggeringTrigger(), CASTER)
	endfunction
	
	function GetEventBuffUnit takes nothing returns unit
		return HTLoadUnitHandle(GetTriggeringTrigger(), TARGET)
	endfunction
	
	function GetEventBuffAbilityId takes nothing returns integer
		return HTLoadInteger(GetTriggeringTrigger(), INTEGER)
	endfunction
	
	function GetEventBuffId takes nothing returns integer
		return HTLoadInteger(GetTriggeringTrigger(), INTEGER + 1)
	endfunction
	
	function GetEventBuffLevel takes nothing returns integer
		return HTLoadInteger(GetTriggeringTrigger(), INTEGER + 2)
	endfunction
	
	private function onEvent takes unit caster, unit target, integer abilid, integer buffid, integer level, integer whichEvent returns nothing
		local integer i = 0
		local trigger t = null
		loop
			if whichEvent == BuffEvent1 then
				exitwhen i >= BuffTriggerCounter__UnitDie
				set t = BuffTriggers__UnitDie[i]
			elseif whichEvent == BuffEvent2 then
				exitwhen i >= BuffTriggerCounter__ExpiresBeforeEnd
				set t = BuffTriggers__ExpiresBeforeEnd[i]
			else
				exitwhen i >= BuffTriggerCounter__Expires
				set t = BuffTriggers__Expires[i]
			endif
			
			if t != null then
				if IsTriggerEnabled(t) then
					call HTSaveUnitHandle(t, CASTER, caster)
					call HTSaveUnitHandle(t, TARGET, target)
					call HTSaveInteger(t, INTEGER, abilid)
					call HTSaveInteger(t, INTEGER + 1, buffid)
					call HTSaveInteger(t, INTEGER + 2, level)
					if TriggerEvaluate(t) then
						call TriggerExecute(t)
					endif
			    endif
			else
				if whichEvent == BuffEvent1 then
					set BuffTriggers__UnitDie[i] = BuffTriggers__UnitDie[BuffTriggerCounter__UnitDie]
					set BuffTriggerCounter__UnitDie = BuffTriggerCounter__UnitDie - 1
				elseif whichEvent == BuffEvent2 then
					set BuffTriggers__ExpiresBeforeEnd[i] = BuffTriggers__ExpiresBeforeEnd[BuffTriggerCounter__ExpiresBeforeEnd]
					set BuffTriggerCounter__ExpiresBeforeEnd = BuffTriggerCounter__ExpiresBeforeEnd - 1
				else
					set BuffTriggers__Expires[i] = BuffTriggers__Expires[BuffTriggerCounter__Expires]
					set BuffTriggerCounter__Expires = BuffTriggerCounter__Expires - 1
				endif
			    set i = i - 1
			endif
			set i = i + 1
		endloop
		set t = null
	endfunction
	
	function TriggerRegisterUnitDieBeforeBuffExpires takes trigger t returns nothing
		set BuffTriggers__UnitDie[BuffTriggerCounter__UnitDie] = t
		set BuffTriggerCounter__UnitDie = BuffTriggerCounter__UnitDie + 1
	endfunction
	
	function TriggerRegisterBuffExpiresBeforeEnd takes trigger t returns nothing
		set BuffTriggers__ExpiresBeforeEnd[BuffTriggerCounter__ExpiresBeforeEnd] = t
		set BuffTriggerCounter__ExpiresBeforeEnd = BuffTriggerCounter__ExpiresBeforeEnd + 1
	endfunction
	
	function TriggerRegisterBuffExpires takes trigger t returns nothing
		set BuffTriggers__Expires[BuffTriggerCounter__Expires] = t
		set BuffTriggerCounter__Expires = BuffTriggerCounter__Expires + 1
	endfunction
	
	function AddBuffTimedTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local unit caster = HTLoadUnitHandle(tick.getHandle(), CASTER)
		local unit target = HTLoadUnitHandle(tick.getHandle(), TARGET)
		local integer abilid = HTLoadInteger(tick.getHandle(), INTEGER)
		local integer buffid = HTLoadInteger(tick.getHandle(), INTEGER + 1)
		local integer stack = HTLoadInteger(tick.getHandle(), INTEGER + 2)
		local integer abilvl = GetUnitAbilityLevel(target, abilid)
		
		if IsUnitDead(target) then
			call onEvent(caster, target, abilid, buffid, abilvl, BuffEvent1)
			call tick.stop()
		elseif GetUnitAbilityLevel(target, abilid) <= 0 then
			call onEvent(caster, target, abilid, buffid, abilvl, BuffEvent2)
			call tick.stop()
		endif
		if tick.isExpired() then
			call onEvent(caster, target, abilid, buffid, abilvl, BuffEvent3)
			if abilvl - stack > 0 and GetWidgetLife(target) > 0. then
				call SetUnitAbilityLevel(target, abilid, abilvl - stack)
			else
				call UnitRemoveAbility(target, abilid)
				call UnitRemoveAbility(target, buffid)
			endif
		endif
		set target = null
		set caster = null
	endfunction

	function AddBuffTimed takes unit caster, unit target, real duration, integer abilid, integer buffid, integer stack returns nothing
		local Tick tick = Tick.create(0.1, 10 * R2I(duration), function AddBuffTimedTick, false)
		local integer abilvl = GetUnitAbilityLevel(target, abilid)
		if stack <= 0 then
			set stack = 1
		endif
		if abilvl <= 0 then
			call UnitAddAbility(target, abilid)
		endif
		call SetUnitAbilityLevel(target, abilid, abilvl + stack)
		call HTSaveUnitHandle(tick.getHandle(), CASTER, caster)
		call HTSaveUnitHandle(tick.getHandle(), TARGET, target)
		call HTSaveInteger(tick.getHandle(), INTEGER, abilid)
		call HTSaveInteger(tick.getHandle(), INTEGER + 1, buffid)
		call HTSaveInteger(tick.getHandle(), INTEGER + 2, stack)
		call tick.start()
	endfunction
	
	private function init takes nothing returns nothing
		set BuffTriggerCounter__UnitDie = 0
		set BuffTriggerCounter__ExpiresBeforeEnd = 0
		set BuffTriggerCounter__Expires = 0
	endfunction
endlibrary
