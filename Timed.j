library Timed initializer init needs Hashtable, RecycleTimers, Maths
// Lightnings codes :
//Chain Lightning Primary - "CLPB" / Secondary - "CLSB"
//Drain - "DRAB"
//Drain Life - "DRAL" / Mana - "DRAM"
//Finger of Death - "AFOD" / Forked Lightning - "FORK"
//Healing Wave Primary - "HWPB" / Secondary - "HWSB"
//Lightning Attack - "CHIM" / Magic Leash - "LEAS"
//Mana Burn - "MBUR" / Mana Flare - "MFPB"
//Spirit Link - "SPLK"
	globals
		group NoPathingGroup
	endglobals
	
	function ExecuteFuncTimedEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		call ExecuteFunc(HTLoadStr(t, STRING))
		call DeleteTimer(t)
	endfunction
	function ExecuteFuncTimed takes string funcname, real duration returns nothing
		local timer t = null
		if funcname != null then
			if duration <= 0. then
				call ExecuteFunc(funcname)
			else
				set t = NewTimer()
				call HTSaveStr(t, STRING, funcname)
				call TimerStart(t, duration, false, function ExecuteFuncTimedEnd)
			endif
		endif
	endfunction
	
	function AddUnitUserDataTimedEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = HTLoadUnitHandle(t, UNIT)
		call SetUnitUserData(u, GetUnitUserData(u) - HTLoadInteger(t, INTEGER))
		set u = null
		call DeleteTimer(t)
	endfunction
	function AddUnitUserDataTimed takes unit u, integer i, real duration returns nothing
		local timer t = null
		if u != null and duration > 0. then
			call SetUnitUserData(u, GetUnitUserData(u) + i)
			set t = NewTimer()
			call HTSaveUnitHandle(t, UNIT, u)
			call HTSaveInteger(t, INTEGER, i)
			call TimerStart(t, duration, false, function AddUnitUserDataTimedEnd)
		endif
	endfunction
	
	function CreateDestructableTimedEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local destructable d = HTLoadDestructableHandle(t, DESTRUCTABLE)
		call KillDestructable(d)
		call RemoveDestructable(d)
		call DeleteTimer(t)
		set d = null
	endfunction
	function CreateDestructableTimed takes integer destructid, real x, real y, real duration returns nothing
		local timer t = null
		if duration > 0. then
			set t = NewTimer()
			call HTSaveDestructableHandle(t, DESTRUCTABLE, CreateDestructable(destructid, CheckX(x), CheckY(y), 0., 1., 0))
			call TimerStart(t, duration, false, function CreateDestructableTimedEnd)
		endif
	endfunction
	
	function CreateEffectXYTimedEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
		call DeleteTimer(t)
	endfunction
	function CreateEffectXYTimed takes real x, real y, string path, real duration returns nothing
		local timer t = null
		local effect e = AddSpecialEffect(path, CheckX(x), CheckY(y))
		if duration <= 0. then
			call DestroyEffect(e)
		else
			set t = NewTimer()
			call HTSaveEffectHandle(t, EFFECT, e)
			call TimerStart(t, duration, false, function CreateEffectXYTimedEnd)
		endif
		set e = null
	endfunction

	function CreateEffectTimedEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer i = HTLoadInteger(t, INDEX)
		local real duration = HTLoadReal(t, REAL)
		if GetWidgetLife(HTLoadUnitHandle(t, UNIT)) <= 0. then
			set i = 0
		endif
		if i <= 0 then
			call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
			call DeleteTimer(t)
		else
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.1, false, function CreateEffectTimedEnd)
		endif
	endfunction
	function CreateEffectTimed takes unit u, string path, string attach, real duration returns nothing
		local timer t = null
		local effect e = null
		if u != null then
			if GetWidgetLife(u) > 0. then
				set e = AddSpecialEffectTarget(path, u, attach)
				if duration <= 0. then
					call DestroyEffect(e)
				else
					set t = NewTimer()
					call HTSaveEffectHandle(t, EFFECT, e)
					call HTSaveUnitHandle(t, UNIT, u)
					call HTSaveInteger(t, INDEX, 10)
					call HTSaveReal(t, REAL, duration)
					call TimerStart(t, duration * 0.1, false, function CreateEffectTimedEnd)
				endif
				set e = null
			endif
		endif
	endfunction

	function CreateLightningBetweenUnitsTimedTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local lightning l = HTLoadLightningHandle(t, LIGHTNING)
		local integer i = HTLoadInteger(t, INDEX)
		local real duration = HTLoadReal(t, REAL)
		if i <= 0 then
			call DeleteTimer(t)
			call DestroyLightning(l)
		else
			call MoveLightningEx(l, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
			call SetLightningColor(l, GetLightningColorR(l), GetLightningColorG(l), GetLightningColorB(l), GetLightningColorA(l) - 0.04)
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.1, false, function CreateLightningBetweenUnitsTimedTick)
		endif
		set l = null
		set target = null
		set caster = null
	endfunction
	function CreateLightningBetweenUnitsTimed takes unit caster, unit target, string codeName, real duration returns lightning
		local timer t = null
		local lightning l = null
		if duration > 0. and caster != null and target != null then
			set t = NewTimer()
			set l = AddLightningEx(codeName, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
			call HTSaveInteger(t, INDEX, 10)
			call HTSaveReal(t, REAL, duration)
			call HTSaveUnitHandle(t, CASTER, caster)
			call HTSaveUnitHandle(t, TARGET, target)
			call HTSaveLightningHandle(t, LIGHTNING, l)
			call TimerStart(t, duration * 0.1, false, function CreateLightningBetweenUnitsTimedTick)
			set l = null
			return HTLoadLightningHandle(t, LIGHTNING)
		endif
		return null
	endfunction
	
	function NoPathingTimedTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = HTLoadUnitHandle(t, UNIT)
		local integer i = HTLoadInteger(t, INDEX)
		local real duration = HTLoadReal(t, REAL)
		if GetWidgetLife(u) <= 0 then
			set i = 0
		endif
		if i <= 0 then
			call SetUnitPathing(u, true)
			call GroupRemoveUnit(NoPathingGroup, u)
			call DeleteTimer(t)
		else
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.2, false, function NoPathingTimedTick)
		endif
		set u = null
	endfunction
	function NoPathingTimed takes unit u, real duration returns nothing
		local timer t = null
		if u != null then
			if GetWidgetLife(u) > 0. then
				set t = NewTimer()
				call GroupRemoveUnit(NoPathingGroup, u)
				call GroupAddUnit(NoPathingGroup, u)
				call SetUnitPathing(u, false)
				call HTSaveInteger(t, INDEX, 5)
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveReal(t, REAL, duration)
				call TimerStart(t, duration * 0.2, false, function NoPathingTimedTick)
			endif
		endif
	endfunction

	function SlideUnitTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = HTLoadUnitHandle(t, UNIT) 
		local integer i = HTLoadInteger(t, INDEX)
		local real duration = HTLoadReal(t, REAL)
		local real dist = HTLoadReal(t, REAL1)
		local real angle = HTLoadReal(t, REAL2)
		local real xc = GetUnitX(u)
		local real yc = GetUnitY(u)
		local real temp = 0.
		local boolean moveSpeed = HTLoadBoolean(t, BOOLEAN1)
		if i <= 0 then
			call DeleteTimer(t)
		else
			if moveSpeed then
				set dist = dist * (GetUnitMoveSpeed(u) / GetUnitDefaultMoveSpeed(u))
				if GetUnitMoveSpeed(u) > 0. then
					set moveSpeed = false
				endif
			endif
			
			if not moveSpeed then
				if HTLoadBoolean(t, BOOLEAN) then
					if GetUnitDefaultMoveSpeed(u) > 0. then
						if IsUnitInGroup(u, NoPathingGroup) == true then
							call SetUnitX(u, PolarX(xc, dist * 0.05, angle))
							call SetUnitY(u, PolarY(yc, dist * 0.05, angle))
						else
							call SetUnitXY(u, PolarX(xc, dist * 0.05, angle), PolarY(yc, dist * 0.05, angle))
						endif
					else
						call SetUnitPosition(u, PolarX(xc, dist * 0.05, angle), PolarY(yc, dist * 0.05, angle))
					endif
				else
					set temp = dist * Pow(0.89, (21. - I2R(i + 1))) - dist * Pow(0.89, (21. - I2R(i)))
					if GetUnitDefaultMoveSpeed(u) > 0. then
						if IsUnitInGroup(u, NoPathingGroup) == true then
							call SetUnitX(u, PolarX(xc, temp, angle))
							call SetUnitY(u, PolarY(yc, temp, angle))
						else
							call SetUnitXY(u, PolarX(xc, temp, angle), PolarY(yc, temp, angle))
						endif
					else
						call SetUnitPosition(u, PolarX(xc, temp, angle), PolarY(yc, temp, angle))
					endif
				endif
			endif
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.05, false, function SlideUnitTick)
		endif
		set u = null
	endfunction
	function SlideUnit takes unit u, real dist, real angle, real duration, boolean linear, boolean takeCareOfMoveSpeed returns nothing
		local timer t = null
		if u != null and dist != 0. and duration > 0. then
			if GetWidgetLife(u) > 0. then
				if dist < 0 then
					set dist = - dist
				endif
				set t = NewTimer()
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveBoolean(t, BOOLEAN, linear)
				call HTSaveBoolean(t, BOOLEAN1, takeCareOfMoveSpeed)
				call HTSaveInteger(t, INDEX, 20)
				call HTSaveReal(t, REAL, duration)
				call HTSaveReal(t, REAL1, dist)
				call HTSaveReal(t, REAL2, angle)
				call TimerStart(t, duration * 0.05, false, function SlideUnitTick)
			endif
		endif
	endfunction

	function ChangeHeightOverTimeTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = HTLoadUnitHandle(t, UNIT)
		local integer i = HTLoadInteger(t, INDEX)
		local real height = HTLoadReal(t, REAL)
		local real duration = HTLoadReal(t, REAL1)
		if GetWidgetLife(u) <= 0. then
			set i = -5
		endif
		if i <= -5 then
			call SetUnitFlyHeight(u, GetUnitDefaultFlyHeight(u), 200.)
			call DeleteTimer(t)
		elseif i > 0 then
			call SetUnitFlyHeight(u, GetUnitFlyHeight(u) + (height * 0.2), 500.)
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.1, false, function ChangeHeightOverTimeTick)
		else
			call SetUnitFlyHeight(u, GetUnitFlyHeight(u)-(height*0.2), 500.)
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.1, false, function ChangeHeightOverTimeTick)
		endif
		set u = null
	endfunction
	function ChangeHeightOverTime takes unit u, real duration, real height returns nothing
		local timer t = null
		if u != null and duration > 0. and height > 0. then
			if GetWidgetLife(u) > 0. then
				set t = NewTimer()
				call UnitAddAbility(u, 'Arav')
				call UnitRemoveAbility(u, 'Arav')
				call HTSaveInteger(t, INDEX, 5)
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveReal(t, REAL, height)
				call HTSaveReal(t, REAL1, duration)
				call TimerStart(t, duration * 0.1, false, function ChangeHeightOverTimeTick)
			endif
		endif
	endfunction

	function AddAbilityTimedTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer i = HTLoadInteger(t, INDEX)
		local integer abilid = HTLoadInteger(t, INTEGER)
		local unit u = HTLoadUnitHandle(t, UNIT)
		local real duration = HTLoadReal(t, REAL)
		if GetWidgetLife(u) <= 0. then
			set i = 0
		endif
		if i <= 0 then
			call UnitRemoveAbility(u, abilid)
			call HTRemoveSavedHandle(u, abilid)
			call DeleteTimer(t)
		else
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, duration * 0.1, false, function AddAbilityTimedTick)
		endif
		set u = null
	endfunction
	function AddAbilityTimed takes unit u, real duration, integer abilid returns nothing
		local timer t = null
		if u != null and duration > 0. then
			if GetWidgetLife(u) > 0. then
				if GetUnitAbilityLevel(u, abilid) > 0 then
					set t = HTLoadTimerHandle(u, abilid)
					if t != null then
						call HTSaveInteger(t, INDEX, 10)
					else
						call UnitRemoveAbility(u, abilid)
						set t = NewTimer()
						call UnitAddAbility(u, abilid)
						call HTSaveTimerHandle(u, abilid, t)
						call HTSaveInteger(t, INDEX, 10)
						call HTSaveUnitHandle(t, UNIT, u)
						call HTSaveInteger(t, INTEGER, abilid)
						call HTSaveReal(t, REAL, duration)
						call TimerStart(t, duration * 0.1, false, function AddAbilityTimedTick)
					endif
				else
					set t = NewTimer()
					call UnitAddAbility(u, abilid)
					call HTSaveTimerHandle(u, abilid, t)
					call HTSaveInteger(t, INDEX, 10)
					call HTSaveUnitHandle(t, UNIT, u)
					call HTSaveInteger(t, INTEGER, abilid)
					call HTSaveReal(t, REAL, duration)
					call TimerStart(t, duration * 0.1, false, function AddAbilityTimedTick)
				endif
			endif
		endif
	endfunction

	function DamageOverTimeTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		local real tickinterval = HTLoadReal(t, REAL1)
		local integer i = HTLoadInteger(t, INDEX)
		if GetWidgetLife(target) <= 0. then
			set i = 0
		endif
		if i <= 0 then
			call DeleteTimer(t)
		else
			call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, tickinterval, false, function DamageOverTimeTick)
		endif
		set dmgtype = null
		set target = null
		set caster = null
	endfunction
	function DamageOverTime takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype returns nothing
		local timer t = null
		if target != null and tickcount > 0 and tickinterval > 0. then
			if GetWidgetLife(target) > 0. then
				set t = NewTimer()
				call HTSaveUnitHandle(t, CASTER, caster)
				call HTSaveUnitHandle(t, TARGET, target)
				call HTSaveInteger(t, INDEX, tickcount)
				call HTSaveInteger(t, INTEGER, dmgtype)
				call HTSaveReal(t, REAL, tickdamage)
				call HTSaveReal(t, REAL1, tickinterval)
				call TimerStart(t, tickinterval, false, function DamageOverTimeTick)
			endif
		endif
	endfunction

	function DamageOverTimeMatchingBuffTick takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		local real tickinterval =  HTLoadReal(t, REAL1)
		local integer i = HTLoadInteger(t, INDEX)
		local integer buffid = HTLoadInteger(t, INTEGER2)
		if GetUnitAbilityLevel(target, buffid) <= 0 then
			set i = 0
		endif
		if i <= 0 then
			call DeleteTimer(t)
		else
			call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
			call HTSaveInteger(t, INDEX, i - 1)
			call TimerStart(t, tickinterval, false, function DamageOverTimeMatchingBuffTick)
		endif
		set dmgtype = null
		set target = null
		set caster = null
	endfunction
	function DamageOverTimeMatchingBuff takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype, integer buffid returns nothing
		local timer t = null
		if target != null and tickcount > 0 and tickinterval > 0. then
			if GetWidgetLife(target) > 0. then
				set t = NewTimer()
				call HTSaveUnitHandle(t, CASTER, caster)
				call HTSaveUnitHandle(t, TARGET, target)
				call HTSaveInteger(t, INDEX, tickcount)
				call HTSaveInteger(t, INTEGER, dmgtype)
				call HTSaveReal(t, REAL, tickdamage)
				call HTSaveReal(t, REAL1, tickinterval)
				call HTSaveInteger(t, INTEGER2, buffid)
				call TimerStart(t, tickinterval, false, function DamageOverTimeMatchingBuffTick)
			endif
		endif
	endfunction

	private function init takes nothing returns nothing
		set NoPathingGroup = CreateGroup()
	endfunction
endlibrary
