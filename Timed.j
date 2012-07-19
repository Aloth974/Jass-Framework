library Timed initializer init needs Ticker, Utilities, Unit
// Lightnings codes :
//Chain Lightning Primary - "CLPB" / Secondary - "CLSB"
//Drain - "DRAB"
//Drain Life - "DRAL" / Mana - "DRAM"
//Finger of Death - "AFOD" / Forked Lightning - "FORK"
//Healing Wave Primary - "HWPB" / Secondary - "HWSB"
//Lightning Attack - "CHIM" / Magic Leash - "LEAS"
//Mana Burn - "MBUR" / Mana Flare - "MFPB"
//Spirit Link - "SPLK"

	function UnitSetTimedLifeTick takes nothing returns nothing
		local integer index = GetTickerIndex()
		local integer i = GetTickerTickLeft(index)
		local unit u = HTLoadUnitHandle(GetTickerDataHandler(index), UNIT)
		if IsTickerExpired(index) or IsUnitDead(u) then
			call DeleteUnit(u)
		endif
	endfunction
	function UnitSetTimedLife takes unit u, real time returns nothing
		local integer index = Ticker(0.1, R2I(time/0.1), function UnitSetTimedLifeTick)
		call HTSaveUnitHandle(GetTickerDataHandler(index), UNIT, u)
		call TickerStart(index)
	endfunction

	function ExecuteFuncTimedEnd takes nothing returns nothing
		call ExecuteFunc(HTLoadStr(GetTickerDataHandler(GetTickerIndex()), STRING))
	endfunction
	function ExecuteFuncTimed takes string funcname, real duration returns nothing
		local integer index
		if funcname != null then
			if duration <= 0. then
				call ExecuteFunc(funcname)
			else
				set index = Ticker(duration, 1, function ExecuteFuncTimedEnd)
				call HTSaveStr(GetTickerDataHandler(index), STRING, funcname)
				call TickerStart(index)
			endif
		endif
	endfunction
	
	function AddUnitUserDataTimedEnd takes nothing returns nothing
		local integer index = GetTickerIndex()
		local unit u = HTLoadUnitHandle(GetTickerDataHandler(index), UNIT)
		call SetUnitUserData(u, GetUnitUserData(u) - HTLoadInteger(GetTickerDataHandler(index), INTEGER))
		set u = null
	endfunction
	function AddUnitUserDataTimed takes unit u, integer i, real duration returns nothing
		local integer index
		if u != null and duration > 0. then
			call SetUnitUserData(u, GetUnitUserData(u) + i)
			set index = Ticker(duration, 1, function AddUnitUserDataTimedEnd)
			call HTSaveUnitHandle(GetTickerDataHandler(index), UNIT, u)
			call HTSaveInteger(GetTickerDataHandler(index), INTEGER, i)
			call TickerStart(index)
		endif
	endfunction
	
	function CreateDestructableTimedEnd takes nothing returns nothing
		local integer index = GetTickerIndex()
		local destructable d = HTLoadDestructableHandle(GetTickerDataHandler(index), DESTRUCTABLE)
		call KillDestructable(d)
		call RemoveDestructable(d)
		set d = null
	endfunction
	function CreateDestructableTimed takes integer destructid, real x, real y, real duration returns nothing
		local integer index
		if duration > 0. then
			set index = Ticker(duration, 1, function CreateDestructableTimedEnd)
			call HTSaveDestructableHandle(GetTickerDataHandler(index), DESTRUCTABLE, CreateDestructable(destructid, CheckX(x), CheckY(y), 0., 1., 0))
			call TickerStart(index)
		endif
	endfunction
	
	function CreateEffectXYTimedEnd takes nothing returns nothing
		call DestroyEffect(HTLoadEffectHandle(GetTickerDataHandler(GetTickerIndex()), EFFECT))
	endfunction
	function CreateEffectXYTimed takes real x, real y, string path, real duration returns nothing
		local integer index
		local effect e = AddSpecialEffect(path, CheckX(x), CheckY(y))
		if duration <= 0. then
			call DestroyEffect(e)
		else
			set index = Ticker(duration, 1, function CreateEffectXYTimedEnd)
			call HTSaveEffectHandle(GetTickerDataHandler(index), EFFECT, e)
			call TickerStart(index)
		endif
		set e = null
	endfunction

	function CreateEffectTimedEnd takes nothing returns nothing
		local integer index = GetTickerIndex()
		local handle t = GetTickerDataHandler(index)
		local real duration = HTLoadReal(t, REAL)
		if GetWidgetLife(HTLoadUnitHandle(t, UNIT)) <= 0. then
			call StopTicker(index)
		endif
		if IsTickerExpired(index) then
			call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
		endif
		set t = null
	endfunction
	function CreateEffectTimed takes unit u, string path, string attach, real duration returns nothing
		local integer index
		local effect e = null
		if u != null then
			if GetWidgetLife(u) > 0. then
				set e = AddSpecialEffectTarget(path, u, attach)
				if duration <= 0. then
					call DestroyEffect(e)
				else
					set index = Ticker(duration * 0.1, 1, function CreateEffectTimedEnd)
					call HTSaveEffectHandle(GetTickerDataHandler(index), EFFECT, e)
					call HTSaveUnitHandle(GetTickerDataHandler(index), UNIT, u)
					call HTSaveReal(GetTickerDataHandler(index), REAL, duration)
					call TickerStart(index)
				endif
				set e = null
			endif
		endif
	endfunction

	function CreateLightningBetweenUnitsTimedTick takes nothing returns nothing
		local integer index = GetTickerIndex()
		local handle t = GetTickerDataHandler(index)
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local lightning l = HTLoadLightningHandle(t, LIGHTNING)
		local real duration = HTLoadReal(t, REAL)
		if IsTickerExpired(index) then
			call DestroyLightning(l)
		else
			call MoveLightningEx(l, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
			call SetLightningColor(l, GetLightningColorR(l), GetLightningColorG(l), GetLightningColorB(l), GetLightningColorA(l) - 0.04)
		endif
		set l = null
		set target = null
		set caster = null
		set t = null
	endfunction
	function CreateLightningBetweenUnitsTimed takes unit caster, unit target, string codeName, real duration returns lightning
		local integer index
		local lightning l = null
		local handle t
		if duration > 0. and caster != null and target != null then
			set index = Ticker(duration * 0.1, 1, function CreateLightningBetweenUnitsTimedTick)
			set t = GetTickerDataHandler(index)
			set l = AddLightningEx(codeName, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
			call HTSaveReal(t, REAL, duration)
			call HTSaveUnitHandle(t, CASTER, caster)
			call HTSaveUnitHandle(t, TARGET, target)
			call HTSaveLightningHandle(t, LIGHTNING, l)
			call TickerStart(index)
			set l = null
			set t = null
			return HTLoadLightningHandle(t, LIGHTNING)
		endif
		return null
	endfunction
	
	function NoPathingTimedTick takes nothing returns nothing
		local integer index = GetTickerIndex()
		local handle t = GetTickerDataHandler(index)
		local unit u = HTLoadUnitHandle(t, UNIT)
		local integer i = HTLoadInteger(t, INDEX)
		local real duration = HTLoadReal(t, REAL)
		if GetWidgetLife(u) <= 0 then
			set i = 0
		endif
		if IsTickerExpired(index) then
			call SetUnitPathing(u, true)
			call GroupRemoveUnit(NoPathingGroup, u)
		endif
		set u = null
		set t = null
	endfunction
	function NoPathingTimed takes unit u, real duration returns nothing
		local integer index
		local handle t
		if u != null then
			if GetWidgetLife(u) > 0. then
				set index = Ticker(duration * 0.2, 5, function NoPathingTimedTick)
				set t = GetTickerDataHandler(index)
				call GroupRemoveUnit(NoPathingGroup, u)
				call GroupAddUnit(NoPathingGroup, u)
				call SetUnitPathing(u, false)
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveReal(t, REAL, duration)
				call TickerStart(index)
				set t = null
			endif
		endif
	endfunction

	function SlideUnitTick takes nothing returns nothing
		local integer index = GetTickerIndex()
		local handle t = GetTickerDataHandler(index)
		local unit u = HTLoadUnitHandle(t, UNIT) 
		local real duration = HTLoadReal(t, DURATION)
		local real dist = HTLoadReal(t, DISTANCE)
		local real angle = HTLoadReal(t, REAL)
		local integer i = GetTickerTickLeft(index)
		local boolean moveSpeed = HTLoadBoolean(t, BOOLEAN + 1)
		if not IsTickerExpired(index) then
			if moveSpeed then
				set dist = dist * (GetUnitMoveSpeed(u) / GetUnitDefaultMoveSpeed(u))
				if GetUnitMoveSpeed(u) > 0. and dist > 0. then
					set moveSpeed = false
				endif
			endif
			
			if not moveSpeed then
				if HTLoadBoolean(t, BOOLEAN) then
					set dist = dist * 0.05
				else
					set dist = dist * Pow(0.89, (21. - I2R(i + 1))) - dist * Pow(0.89, (21. - I2R(i)))
				endif
				call MoveUnit(u, PolarX(GetUnitX(u), dist, angle), PolarY(GetUnitY(u), dist, angle))
			endif
		endif
		set u = null
		set t = null
	endfunction
	function SlideUnit takes unit u, real dist, real angle, real duration, boolean linear, boolean takeCareOfMoveSpeed returns nothing
		local integer index
		local handle t
		if u != null and dist != 0. and duration > 0. then
			if GetWidgetLife(u) > 0. then
				if dist < 0 then
					set dist = - dist
				endif
				set index = Ticker(duration * 0.05, 20, function SlideUnitTick)
				set t = GetTickerDataHandler(index)
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveBoolean(t, BOOLEAN, linear)
				call HTSaveBoolean(t, BOOLEAN + 1, takeCareOfMoveSpeed)
				call HTSaveReal(t, DURATION, duration)
				call HTSaveReal(t, DISTANCE, dist)
				call HTSaveReal(t, REAL, angle)
				call TickerStart(index)
				set t = null
			endif
		endif
	endfunction

	function ChangeHeightOverTimeTick takes nothing returns nothing
		local timer t = GetTimer()
		local unit u = HTLoadUnitHandle(t, UNIT)
		local integer i = HTLoadInteger(t, INDEX)
		local real height = HTLoadReal(t, REAL)
		local real duration = HTLoadReal(t, DURATION)
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
				call HTSaveReal(t, DURATION, duration)
				call TimerStart(t, duration * 0.1, false, function ChangeHeightOverTimeTick)
			endif
		endif
	endfunction

	function AddAbilityTimedTick takes nothing returns nothing
		local timer t = GetTimer()
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
		local timer t = GetTimer()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		local real tickinterval = HTLoadReal(t, REAL + 1)
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
				call HTSaveReal(t, REAL + 1, tickinterval)
				call TimerStart(t, tickinterval, false, function DamageOverTimeTick)
			endif
		endif
	endfunction

	function DamageOverTimeMatchingBuffTick takes nothing returns nothing
		local timer t = GetTimer()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		local real tickinterval =  HTLoadReal(t, REAL + 1)
		local integer i = HTLoadInteger(t, INDEX)
		local integer buffid = HTLoadInteger(t, INTEGER + 2)
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
				call HTSaveReal(t, REAL + 1, tickinterval)
				call HTSaveInteger(t, INTEGER + 2, buffid)
				call TimerStart(t, tickinterval, false, function DamageOverTimeMatchingBuffTick)
			endif
		endif
	endfunction

	private function init takes nothing returns nothing
		set NoPathingGroup = CreateGroup()
	endfunction
endlibrary
