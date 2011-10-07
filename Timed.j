library Timed initializer init needs HandleRecycle, Hashtable, Maths
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
        constant integer UNKNOWN = 0
        constant integer FIRE = 8
        constant integer COLD = 9
        constant integer POISON = 11
        constant integer DISEASE = 12
        constant integer DIVINE = 13
        constant integer MAGIC = 14
        constant integer SONIC = 15
        constant integer ACID = 16
        constant integer DEATH = 18
        constant integer MIND = 19
        constant integer PLANT = 20
        constant integer UNIVERSAL = 26
    endglobals
    function ExecuteFuncTimedEnd takes nothing returns nothing
        local timer t = GetExpiredTimer()
        call ExecuteFunc(HTLoadStr(t, STRING))
        call HTFlushChildHashtable(t)
        call DeleteTimer(t)
    endfunction
    function ExecuteFuncTimed takes string s, real dur returns nothing
        local timer t = null
        if(s==null) then
            return
        endif
        if(dur<=0.) then
            call ExecuteFunc(s)
        else
            set t = NewTimer()
            call HTSaveStr(t, STRING, s)
            call TimerStart(t, dur, false, function ExecuteFuncTimedEnd)
        endif
    endfunction
    
    function AddUnitUserDataTimedEnd takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit u = HTLoadUnitHandle(t, UNIT)
        call SetUnitUserData(u, GetUnitUserData(u)-HTLoadInteger(t, INTEGER))
        set u = null
        call HTFlushChildHashtable(t)
        call DeleteTimer(t)
    endfunction
    function AddUnitUserDataTimed takes unit u, integer i, real dur returns nothing
        local timer t = null
        if(u==null or dur<=0.) then
            return
        endif
        call SetUnitUserData(u, GetUnitUserData(u)+i)
        set t = NewTimer()
        call HTSaveUnitHandle(t, UNIT, u)
        call HTSaveInteger(t, INTEGER, i)
        call TimerStart(t, dur, false, function AddUnitUserDataTimedEnd)
    endfunction
    
    function CreateDestructableTimedEnd takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local destructable d = HTLoadDestructableHandle(t, DESTRUCTABLE)
        call KillDestructable(d)
        call RemoveDestructable(d)
        call HTFlushChildHashtable(t)
        call DeleteTimer(t)
        set d = null
    endfunction
    function CreateDestructableTimed takes integer destructid, real x, real y, real dur returns nothing
        local timer t = null
        if(dur<=0.) then
            return
        endif
        set t = NewTimer()
        call HTSaveDestructableHandle(t, DESTRUCTABLE, CreateDestructable(destructid, CheckX(x), CheckY(y), 0., 1., 0))
        call TimerStart(t, dur, false, function CreateDestructableTimedEnd)
    endfunction
    
    function CreateEffectXYTimedEnd takes nothing returns nothing
        local timer t = GetExpiredTimer()
        call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
        call HTFlushChildHashtable(t)
        call DeleteTimer(t)
    endfunction
    function CreateEffectXYTimed takes real x, real y, string path, real dur returns nothing
        local timer t = null
        local effect e = AddSpecialEffect(path, CheckX(x), CheckY(y))
        if(dur<=0.) then
            call DestroyEffect(e)
        else
            set t = NewTimer()
            call HTSaveEffectHandle(t, EFFECT, e)
            call TimerStart(t, dur, false, function CreateEffectXYTimedEnd)
        endif
        set e = null
    endfunction
    
    function CreateEffectTimedEnd takes nothing returns nothing
        local timer t = GetExpiredTimer() 
        local integer i = HTLoadInteger(t, INDEX)
        if(GetUnitState(HTLoadUnitHandle(t, UNIT), UNIT_STATE_LIFE)<=0.) then
            set i = 0
        endif
        if(i<=0) then
            call DestroyEffect(HTLoadEffectHandle(t, EFFECT))
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            call HTSaveInteger(t, INDEX, i-1)
        endif
    endfunction
    function CreateEffectTimed takes unit u, string path, string attach, real dur returns nothing
        local timer t = null
        local effect e = null
        if(u==null) then
            return
        elseif(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set e = AddSpecialEffectTarget(path, u, attach)
        if(dur<=0.) then
            call DestroyEffect(e)
        else
            set t = NewTimer()
            call HTSaveEffectHandle(t, EFFECT, e)
            call HTSaveUnitHandle(t, UNIT, u)
            call HTSaveInteger(t, INDEX, 10)
            call TimerStart(t, dur*0.1, true, function CreateEffectTimedEnd)
        endif
        set e = null
    endfunction

    function CreateLightningBetweenUnitsTimedTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit caster = HTLoadUnitHandle(t, CASTER)
        local unit target = HTLoadUnitHandle(t, TARGET)
        local lightning l = HTLoadLightningHandle(t, LIGHTNING)
        local integer i = HTLoadInteger(t, INDEX)
        if(i<=0) then
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
            call DestroyLightning(l)
        else
            call MoveLightningEx(l, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
            call SetLightningColor(l, GetLightningColorR(l), GetLightningColorG(l), GetLightningColorB(l), GetLightningColorA(l)-0.04)
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set l = null
        set target = null
        set caster = null
    endfunction
    function CreateLightningBetweenUnitsTimed takes unit caster, unit target, string codeName, real dur returns lightning
        local timer t = null
        local lightning l = null
        if(dur<=0. or caster==null or target==null) then
            return null
        endif
        set t = NewTimer()
        set l = AddLightningEx(codeName, true, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster), GetUnitX(target), GetUnitY(target), GetUnitZ(target))
        call HTSaveInteger(t, INDEX, 10)
        call HTSaveUnitHandle(t, CASTER, caster)
        call HTSaveUnitHandle(t, TARGET, target)
        call HTSaveLightningHandle(t, LIGHTNING, l)
        call TimerStart(t, dur*0.1, true, function CreateLightningBetweenUnitsTimedTick)
        set l = null
        return HTLoadLightningHandle(t, LIGHTNING)
    endfunction
    function NoPathingTimedTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = HTLoadInteger(t, INDEX)
        local unit u = HTLoadUnitHandle(t, UNIT)
        if(GetUnitState(u, UNIT_STATE_LIFE)<=0) then
            set i = 0
        endif
        if(i<=0) then
            call SetUnitPathing(u, true)
            call GroupRemoveUnit(NoPathingGroup, u)
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set u = null
    endfunction
    function NoPathingTimed takes unit u, real dur returns nothing
        local timer t = null
        if(u==null) then
            return
        elseif(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set t = NewTimer()
        call GroupRemoveUnit(NoPathingGroup, u)
        call GroupAddUnit(NoPathingGroup, u)
        call SetUnitPathing(u, false)
        call HTSaveInteger(t, INDEX, 5)
        call HTSaveUnitHandle(t, UNIT, u)
        call TimerStart(t, dur*0.2, true, function NoPathingTimedTick)
    endfunction

    function SlideUnitTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit u = HTLoadUnitHandle(t, UNIT) 
        local integer i = HTLoadInteger(t, INDEX)
        local real dist = HTLoadReal(t, REAL1)
        local real angle = HTLoadReal(t, REAL2)
        local real xc = GetUnitX(u)
        local real yc = GetUnitY(u)
        local real temp = 0.
        if(i<=0) then
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            if(HTLoadBoolean(t, BOOLEAN)) then
                if(GetUnitDefaultMoveSpeed(u)>0.) then
                    if(IsUnitInGroup(u, NoPathingGroup)==true) then
                        call SetUnitX(u, PolarX(xc, dist*0.05, angle))
                        call SetUnitY(u, PolarY(yc, dist*0.05, angle))
                    else
                        call SetUnitXY(u, PolarX(xc, dist*0.05, angle), PolarY(yc, dist*0.05, angle))
                    endif
                else
                    call SetUnitPosition(u, PolarX(xc, dist*0.05, angle), PolarY(yc, dist*0.05, angle))
                endif
            else
                set temp = dist*Pow(0.89,(21.-I2R(i+1)))-dist*Pow(0.89,(21.-I2R(i)))
                if(GetUnitDefaultMoveSpeed(u)>0.) then
                    if(IsUnitInGroup(u, NoPathingGroup)==true) then
                        call SetUnitX(u, PolarX(xc, temp, angle))
                        call SetUnitY(u, PolarY(yc, temp, angle))
                    else
                        call SetUnitXY(u, PolarX(xc, temp, angle), PolarY(yc, temp, angle))
                    endif
                else
                    call SetUnitPosition(u, PolarX(xc, temp, angle), PolarY(yc, temp, angle))
                endif
            endif
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set u = null
    endfunction
    function SlideUnit takes unit u, real dist, real angle, real dur, boolean linear returns nothing
        local timer t = null
        if(u==null or dist<=0. or dur<=0.) then
            return
        elseif(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set t = NewTimer()
        call HTSaveUnitHandle(t, UNIT, u)
        call HTSaveBoolean(t, BOOLEAN, linear)
        call HTSaveInteger(t, INDEX, 20)
        call HTSaveReal(t, REAL1, dist)
        call HTSaveReal(t, REAL2, angle)
        call TimerStart(t, dur*0.05, true, function SlideUnitTick)
    endfunction

    function ChangeHeightOverTimeTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit u = HTLoadUnitHandle(t, UNIT)
        local integer i = HTLoadInteger(t, INDEX)
        local real height = HTLoadReal(t, REAL)
        if(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            set i = -5
        endif
        if(i<=-5) then
            call SetUnitFlyHeight(u, GetUnitDefaultFlyHeight(u), 200.)
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        elseif(i>0) then
            call SetUnitFlyHeight(u, GetUnitFlyHeight(u)+(height*0.2), 500.)
            call HTSaveInteger(t, INDEX, i-1)
        else
            call SetUnitFlyHeight(u, GetUnitFlyHeight(u)-(height*0.2), 500.)
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set u = null
    endfunction
    function ChangeHeightOverTime takes unit u, real dur, real height returns nothing
        local timer t = null
        if(u==null or dur<=0. or height<=0.) then
            return
        elseif(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set t = NewTimer()
        call UnitAddAbility(u, 'Arav')
        call UnitRemoveAbility(u, 'Arav')
        call HTSaveInteger(t, INDEX, 5)
        call HTSaveUnitHandle(t, UNIT, u)
        call HTSaveReal(t, REAL, height)
        call TimerStart(t, dur*0.1, true, function ChangeHeightOverTimeTick)
    endfunction

    function AddAbilityTimedTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = HTLoadInteger(t, INDEX)
        local integer abilid = HTLoadInteger(t, INTEGER)
        local unit u = HTLoadUnitHandle(t, UNIT)
        if(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            set i = 0
        endif
        if(i<=0) then
            call UnitRemoveAbility(u, abilid)
            call HTRemoveSavedHandle(u, abilid)
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set u = null
    endfunction
    function AddAbilityTimed takes unit u, real dur, integer abilid returns nothing
        local timer t = null
        if(u==null) then
            return
        elseif(GetUnitState(u, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        if(GetUnitAbilityLevel(u, abilid)>0) then
            set t = HTLoadTimerHandle(u, abilid)
            if(t!=null) then
                call HTSaveInteger(t, INDEX, 10)
            else
                call UnitRemoveAbility(u, abilid)
                set t = NewTimer()
                call UnitAddAbility(u, abilid)
                call HTSaveTimerHandle(u, abilid, t)
                call HTSaveInteger(t, INDEX, 10)
                call HTSaveUnitHandle(t, UNIT, u)
                call HTSaveInteger(t, INTEGER, abilid)
                call TimerStart(t, dur*0.1, true, function AddAbilityTimedTick)
            endif
        else
            set t = NewTimer()
            call UnitAddAbility(u, abilid)
            call HTSaveTimerHandle(u, abilid, t)
            call HTSaveInteger(t, INDEX, 10)
            call HTSaveUnitHandle(t, UNIT, u)
            call HTSaveInteger(t, INTEGER, abilid)
            call TimerStart(t, dur*0.1, true, function AddAbilityTimedTick)
        endif
    endfunction
    
    function DamageOverTimeTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit caster = HTLoadUnitHandle(t, CASTER)
        local unit target = HTLoadUnitHandle(t, TARGET)
        local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
        local real damage = HTLoadReal(t, REAL)
        local integer i = HTLoadInteger(t, INDEX)
        if(GetUnitState(target, UNIT_STATE_LIFE)<=0) then
            set i = 0
        endif
        if(i<=0) then
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set dmgtype = null
        set target = null
        set caster = null
    endfunction
    function DamageOverTime takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype returns nothing
        local timer t = null
        if(target==null or tickcount<=0 or tickinterval<=0.) then
            return
        elseif(GetUnitState(target, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set t = NewTimer()
        call HTSaveUnitHandle(t, CASTER, caster)
        call HTSaveUnitHandle(t, TARGET, target)
        call HTSaveInteger(t, INDEX, tickcount)
        call HTSaveInteger(t, INTEGER, dmgtype)
        call HTSaveReal(t, REAL, tickdamage)
        call TimerStart(t, tickinterval, true, function DamageOverTimeTick)
    endfunction

    function DamageOverTimeMatchingBuffTick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit caster = HTLoadUnitHandle(t, CASTER)
        local unit target = HTLoadUnitHandle(t, TARGET)
        local damagetype dmgtype = ConvertDamageType(HTLoadInteger(t, INTEGER))
        local real damage = HTLoadReal(t, REAL)
        local integer i = HTLoadInteger(t, INDEX)
        local integer buffid = HTLoadInteger(t, INTEGER2)
        if(GetUnitAbilityLevel(target, buffid)<=0) then
            set i = 0
        endif
        if(i<=0) then
            call HTFlushChildHashtable(t)
            call DeleteTimer(t)
        else
            call UnitDamageTarget(caster, target, damage, true, false, ATTACK_TYPE_NORMAL, dmgtype, WEAPON_TYPE_WHOKNOWS)
            call HTSaveInteger(t, INDEX, i-1)
        endif
        set dmgtype = null
        set target = null
        set caster = null
    endfunction
    function DamageOverTimeMatchingBuff takes unit caster, unit target, real tickdamage, real tickinterval, integer tickcount, integer dmgtype, integer buffid returns nothing
        local timer t = null
        if(target==null or tickcount<=0 or tickinterval<=0.) then
            return
        elseif(GetUnitState(target, UNIT_STATE_LIFE)<=0.) then
            return
        endif
        set t = NewTimer()
        call HTSaveUnitHandle(t, CASTER, caster)
        call HTSaveUnitHandle(t, TARGET, target)
        call HTSaveInteger(t, INDEX, tickcount)
        call HTSaveInteger(t, INTEGER, dmgtype)
        call HTSaveReal(t, REAL, tickdamage)
        call HTSaveInteger(t, INTEGER2, buffid)
        call TimerStart(t, tickinterval, true, function DamageOverTimeMatchingBuffTick)
    endfunction

    private function init takes nothing returns nothing
        set NoPathingGroup = CreateGroup()
    endfunction
endlibrary
