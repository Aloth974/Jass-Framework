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
		local Tick tick = GetTicker()
		local unit u = HTLoadUnitHandle(tick.getHandle(), UNIT)
		if IsUnitDead(u) then	
			call tick.stop()
		endif
		if tick.isExpired() then
			call DeleteUnit(u)
		endif
		set u = null
	endfunction
	function UnitSetTimedLife takes unit u, real time returns nothing
		//local timer t = NewTimer()
		//call HTSaveInteger(t, INTEGER, R2I(time/0.1))
		//call HTSaveUnitHandle(t, UNIT, u)
		//call TimerStart(t, 0.1, false, function UnitSetTimedLifeTick)
		call UnitApplyTimedLife(u, 'BTLF', time)
	endfunction

	function ExecuteFuncTimedEnd takes nothing returns nothing
		call ExecuteFunc(HTLoadStr(GetTicker().getHandle(), STRING))
	endfunction
	function ExecuteFuncTimed takes string funcname, real duration returns nothing
		local Tick tick
		if funcname != null then
			if duration <= 0. then
				call ExecuteFunc(funcname)
			else
				set tick = Tick.create(duration, 1, function ExecuteFuncTimedEnd, false)
				call HTSaveStr(tick.getHandle(), STRING, funcname)
				call tick.start()
			endif
		endif
	endfunction
	
	function AddUnitUserDataTimedEnd takes nothing returns nothing
		local Tick tick = GetTicker()
		local unit u = HTLoadUnitHandle(tick.getHandle(), UNIT)
		call SetUnitUserData(u, GetUnitUserData(u) - HTLoadInteger(tick.getHandle(), INTEGER))
		set u = null
	endfunction
	function AddUnitUserDataTimed takes unit u, integer i, real duration returns nothing
		local Tick tick
		if u != null and duration > 0. then
			call SetUnitUserData(u, GetUnitUserData(u) + i)
			set tick = Tick.create(duration, 1, function AddUnitUserDataTimedEnd, false)
			call HTSaveUnitHandle(tick.getHandle(), UNIT, u)
			call HTSaveInteger(tick.getHandle(), INTEGER, i)
			call tick.start()
		endif
	endfunction
	
	function CreateDestructableTimedEnd takes nothing returns nothing
		local Tick tick = GetTicker()
		local destructable d = HTLoadDestructableHandle(tick.getHandle(), DESTRUCTABLE)
		call KillDestructable(d)
		call RemoveDestructable(d)
		set d = null
	endfunction
	function CreateDestructableTimed takes integer destructid, real x, real y, real duration returns nothing
		local Tick tick
		if duration > 0. then
			set tick = Tick.create(duration, 1, function CreateDestructableTimedEnd, false)
			call HTSaveDestructableHandle(tick.getHandle(), DESTRUCTABLE, CreateDestructable(destructid, CheckX(x), CheckY(y), 0., 1., 0))
			call tick.start()
		endif
	endfunction
	
	function CreateEffectXYTimedEnd takes nothing returns nothing
		call DestroyEffect(HTLoadEffectHandle(GetTicker().getHandle(), EFFECT))
	endfunction
	function CreateEffectXYTimed takes real x, real y, string path, real duration returns nothing
		local Tick tick
		local effect e = AddSpecialEffect(path, CheckX(x), CheckY(y))
		if duration <= 0. then
			call DestroyEffect(e)
		else
			set tick = Tick.create(duration, 1, function CreateEffectXYTimedEnd, false)
			call HTSaveEffectHandle(tick.getHandle(), EFFECT, e)
			call tick.start()
		endif
		set e = null
	endfunction

	function CreateEffectTimedEnd takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local real duration = HTLoadReal(t, REAL)
		if IsUnitDead(HTLoadUnitHandle(t, UNIT)) then
			call tick.stop()
		endif
		if tick.isExpired() then
			call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
		endif
		set t = null
	endfunction
	function CreateEffectTimed takes unit u, string path, string attach, real duration returns nothing
		local Tick tick
		local effect e = null
		if u != null then
			if IsUnitAlive(u) then
				set e = AddSpecialEffectTarget(path, u, attach)
				if duration <= 0. then
					call DestroyEffect(e)
				else
					set tick = Tick.create(duration * 0.1, 10, function CreateEffectTimedEnd, false)
					call HTSaveEffectHandle(tick.getHandle(), EFFECT, e)
					call HTSaveUnitHandle(tick.getHandle(), UNIT, u)
					call HTSaveReal(tick.getHandle(), REAL, duration)
					call tick.start()
				endif
				set e = null
			endif
		endif
	endfunction

	function CreateLightningBetweenUnitsTimedTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local lightning l = HTLoadLightningHandle(t, LIGHTNING)
		local real duration = HTLoadReal(t, REAL)
		if IsUnitDead(target) or IsUnitDead(caster) then
			call tick.stop()
		endif
		if tick.isExpired() then
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
		local Tick tick
		local lightning l = null
		if duration > 0. and caster != null and target != null then
			set tick = Tick.create(duration * 0.1, 10, function CreateLightningBetweenUnitsTimedTick, false)
			set l = AddLightningEx(codeName, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
			call HTSaveReal(tick.getHandle(), REAL, duration)
			call HTSaveUnitHandle(tick.getHandle(), CASTER, caster)
			call HTSaveUnitHandle(tick.getHandle(), TARGET, target)
			call HTSaveLightningHandle(tick.getHandle(), LIGHTNING, l)
			call tick.start()
			set l = null
			return HTLoadLightningHandle(tick.getHandle(), LIGHTNING)
		endif
		return null
	endfunction
	
	function NoPathingTimedTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local unit u = HTLoadUnitHandle(tick.getHandle(), UNIT)
		if IsUnitDead(u) then
			call tick.stop()
		endif
		if tick.isExpired() then
			call SetUnitPathing(u, true)
			call GroupRemoveUnit(NoPathingGroup, u)
		endif
		set u = null
	endfunction
	function NoPathingTimed takes unit u, real duration returns nothing
		local Tick tick
		if u != null then
			if IsUnitAlive(u) then
				set tick = Tick.create(duration * 0.2, 5, function NoPathingTimedTick, false)
				call GroupRemoveUnit(NoPathingGroup, u)
				call GroupAddUnit(NoPathingGroup, u)
				call SetUnitPathing(u, false)
				call HTSaveUnitHandle(tick.getHandle(), UNIT, u)
				call tick.start()
			endif
		endif
	endfunction

	function SlideUnitTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local unit u = HTLoadUnitHandle(t, UNIT) 
		local real duration = HTLoadReal(t, DURATION)
		local real dist = HTLoadReal(t, DISTANCE)
		local real angle = HTLoadReal(t, REAL)
		local integer i = tick.getRemaining()
		local boolean moveSpeed = HTLoadBoolean(t, BOOLEAN + 1)
		if not tick.isExpired() then
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
		local Tick tick
		local handle t
		if u != null and dist != 0. and duration > 0. then
			if IsUnitAlive(u) then
				if dist < 0 then
					set dist = - dist
				endif
				set tick = Tick.create(duration * 0.05, 20, function SlideUnitTick, false)
				set t = tick.getHandle()
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveBoolean(t, BOOLEAN, linear)
				call HTSaveBoolean(t, BOOLEAN + 1, takeCareOfMoveSpeed)
				call HTSaveReal(t, DURATION, duration)
				call HTSaveReal(t, DISTANCE, dist)
				call HTSaveReal(t, REAL, angle)
				call tick.start()
				set t = null
			endif
		endif
	endfunction

	function ChangeHeightOverTimeTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local unit u = HTLoadUnitHandle(t, UNIT)
		local real height = HTLoadReal(t, REAL)
		local real duration = HTLoadReal(t, DURATION)
		if IsUnitDead(u) then
			call tick.stop()
		endif
		if tick.isExpired() then
			call SetUnitFlyHeight(u, GetUnitDefaultFlyHeight(u), 200.)
		elseif tick.getRemaining() > 0 then
			call SetUnitFlyHeight(u, GetUnitFlyHeight(u) + (height * 0.1), 500.)
		else
			call SetUnitFlyHeight(u, GetUnitFlyHeight(u) - (height * 0.1), 500.)
		endif
		set u = null
		set t = null
	endfunction
	function ChangeHeightOverTime takes unit u, real duration, real height returns nothing
		local Tick tick
		local handle t
		if u != null and duration > 0. and height > 0. then
			if IsUnitAlive(u) then
				set tick = Tick.create(duration * 0.05, 10, function ChangeHeightOverTimeTick, false)
				call tick.setLast(-10)
				set t = tick.getHandle()
				call UnitAddAbility(u, 'Arav')
				call UnitRemoveAbility(u, 'Arav')
				call HTSaveUnitHandle(t, UNIT, u)
				call HTSaveReal(t, REAL, height)
				call HTSaveReal(t, DURATION, duration)
				call tick.start()
				set t = null
			endif
		endif
	endfunction

	function AddAbilityTimedTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local integer abilid = HTLoadInteger(t, INTEGER)
		local unit u = HTLoadUnitHandle(t, UNIT)
		if IsUnitDead(u) then
			call tick.stop()
		endif
		if tick.isExpired() then
			call UnitRemoveAbility(u, abilid)
			call HTRemoveSavedHandle(u, abilid)
		endif
		set u = null
		set t = null
	endfunction
	function AddAbilityTimed takes unit u, real duration, integer abilid returns nothing
		local Tick tick
		local handle t
		if u != null and duration > 0. then
			if IsUnitAlive(u) then
				set tick = HTLoadInteger(u, abilid)
				if GetUnitAbilityLevel(u, abilid) > 0 and tick != null then
					call tick.reset()
				else
					call UnitRemoveAbility(u, abilid)
					set tick = Tick.create(duration * 0.1, 10, function AddAbilityTimedTick, false)
					set t = tick.getHandle()
					call UnitAddAbility(u, abilid)
					call HTSaveInteger(u, abilid, tick)
					call HTSaveUnitHandle(t, UNIT, u)
					call HTSaveInteger(t, INTEGER, abilid)
					call tick.start()
				endif
			endif
		endif
	endfunction

	function DamageOverTimeTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		if IsUnitDead(target) then
			call tick.stop()
		endif
		if not tick.isExpired() then
			call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
		endif
		set dmgtype = null
		set target = null
		set caster = null
		set t = null
	endfunction

	function DamageOverTime takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype returns nothing
		local Tick tick
		local handle t
		if target != null and tickcount > 0 and tickinterval > 0. then
			if IsUnitAlive(target) then
				set tick = Tick.create(tickinterval, tickcount, function DamageOverTimeTick, false)
				set t = tick.getHandle()
				call HTSaveUnitHandle(t, CASTER, caster)
				call HTSaveUnitHandle(t, TARGET, target)
				call HTSaveInteger(t, INTEGER, dmgtype)
				call HTSaveReal(t, REAL, tickdamage)
				call tick.start()
				set t = null
			endif
		endif
	endfunction

	function DamageOverTimeMatchingBuffTick takes nothing returns nothing
		local Tick tick = GetTicker()
		local handle t = tick.getHandle()
		local unit caster = HTLoadUnitHandle(t, CASTER)
		local unit target = HTLoadUnitHandle(t, TARGET)
		local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
		local real damage = HTLoadReal(t, REAL)
		local integer buffid = HTLoadInteger(t, INTEGER + 1)
		if GetUnitAbilityLevel(target, buffid) <= 0 then
			call tick.stop()
		endif
		if not tick.isExpired() then
			call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
		endif
		set dmgtype = null
		set target = null
		set caster = null
	endfunction
	function DamageOverTimeMatchingBuff takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype, integer buffid returns nothing
		local Tick tick
		local handle t
		if target != null and tickcount > 0 and tickinterval > 0. then
			if IsUnitAlive(target) then
				set tick = Tick.create(tickinterval, tickcount, function DamageOverTimeMatchingBuffTick, false)
				set t = tick.getHandle()
				call HTSaveUnitHandle(t, CASTER, caster)
				call HTSaveUnitHandle(t, TARGET, target)
				call HTSaveInteger(t, INTEGER, dmgtype)
				call HTSaveReal(t, REAL, tickdamage)
				call HTSaveInteger(t, INTEGER + 1, buffid)
				call tick.start()
				set t = null
			endif
		endif
	endfunction

	private function init takes nothing returns nothing
		set NoPathingGroup = CreateGroup()
	endfunction
endlibrary
