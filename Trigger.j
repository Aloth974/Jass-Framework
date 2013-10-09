library Trigger initializer init needs Hashtable, RecycleGroups, Ticker
	globals
		trigger DamageUnitEvent_RegisterUnitTrigger
		trigger DamageUnitEvent_UnRegisterUnitTrigger
		trigger array DamageUnitEvent_ToExecute
		integer TriggerCounter
	endglobals
	
	function OnDamageEvent takes nothing returns nothing
		local integer i = 1
		loop
			exitwhen i >= TriggerCounter
			if DamageUnitEvent_ToExecute[i] != null then
			    if IsTriggerEnabled(DamageUnitEvent_ToExecute[i]) then
				  if TriggerEvaluate(DamageUnitEvent_ToExecute[i]) then
					call TriggerExecute(DamageUnitEvent_ToExecute[i])
				  endif
			    endif
			else
			    set DamageUnitEvent_ToExecute[i] = DamageUnitEvent_ToExecute[TriggerCounter]
			    set TriggerCounter = TriggerCounter - 1
			    set i = i - 1
			endif
			set i = i + 1
		endloop
	endfunction
	
	function DamageEvent_RemoveUnit takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local trigger trig = HTLoadTriggerHandle(u, DAMAGE_EVENT)
		call TriggerRemoveAction(trig, HTLoadTriggerActionHandle(trig, TRIGGERACTION))
		call HTRemoveSavedHandle(u, DAMAGE_EVENT)
		call HTFlushChildHashtable(trig)
		call DestroyTrigger(trig)
		set trig = null
		set u = null
	endfunction
	
	function DamageEvent_AddUnit takes nothing returns nothing
		local trigger DoAction = CreateTrigger()
		local unit u = GetTriggerUnit()
		call TriggerRegisterUnitEvent(DoAction, u, EVENT_UNIT_DAMAGED)
		call HTSaveTriggerActionHandle(DoAction, TRIGGERACTION, TriggerAddAction(DoAction, function OnDamageEvent))
		call HTSaveTriggerHandle(u, DAMAGE_EVENT, DoAction)
		set u = null
		set DoAction = null
	endfunction
	
	function TriggerRegisterAnyUnitDamaged takes trigger t returns nothing
		set DamageUnitEvent_ToExecute[TriggerCounter] = t
		set TriggerCounter = TriggerCounter + 1
	endfunction
	
	private function init takes nothing returns nothing
		local trigger DoAction = null        
		local group g = NewGroup()
		local unit u = null
		set DamageUnitEvent_RegisterUnitTrigger = CreateTrigger()
		set DamageUnitEvent_UnRegisterUnitTrigger = CreateTrigger()
		set TriggerCounter = 1
		call GroupEnumUnitsInRect(g, bj_mapInitialPlayableArea, null)
		loop
			set u = FirstOfGroup(g)
			exitwhen u == null
			call GroupRemoveUnit(g, u)
			set DoAction = CreateTrigger()
			call TriggerRegisterUnitEvent(DoAction, u, EVENT_UNIT_DAMAGED)
			call HTSaveTriggerActionHandle(DoAction, TRIGGERACTION, TriggerAddAction(DoAction, function OnDamageEvent))
			call HTSaveTriggerHandle(u, DAMAGE_EVENT, DoAction)
		endloop
		call TriggerRegisterEnterRectSimple(DamageUnitEvent_RegisterUnitTrigger, bj_mapInitialPlayableArea)
		call TriggerRegisterAnyUnitEventBJ(DamageUnitEvent_RegisterUnitTrigger, EVENT_PLAYER_HERO_REVIVE_FINISH)
		call TriggerAddAction(DamageUnitEvent_RegisterUnitTrigger, function DamageEvent_AddUnit)
		call TriggerRegisterAnyUnitEventBJ(DamageUnitEvent_UnRegisterUnitTrigger, EVENT_PLAYER_UNIT_DEATH)
		call TriggerRegisterLeaveRectSimple(DamageUnitEvent_UnRegisterUnitTrigger, bj_mapInitialPlayableArea)
		call TriggerAddAction(DamageUnitEvent_UnRegisterUnitTrigger, function DamageEvent_RemoveUnit)
		call DeleteGroup(g)
		set u = null
		set DoAction = null
	endfunction

	function AStopWhenChannelEnd takes nothing returns nothing
		local trigger trig = GetTriggeringTrigger()
		local unit u = GetTriggerUnit()
		local Tick tick = GetTickerByTrigger(HTLoadTriggerHandle(u, ENDCHANNEL))
		if not tick.isExpired() then
			call tick.stop()
			call tick.exec()
		endif
		call TriggerRemoveAction(trig, HTLoadTriggerActionHandle(trig, TRIGGERACTION))
		call TriggerRemoveCondition(trig, HTLoadTriggerConditionHandle(trig, TRIGGERCONDITION))
		call HTRemoveSavedHandle(u, ENDCHANNEL)
		call HTFlushChildHashtable(trig)
		call DestroyTrigger(trig)
		set trig = null
		set u = null
	endfunction
	
	function StopWhenChannelEnd takes unit u, Tick tick, boolexpr filter returns nothing
		local trigger trig = CreateTrigger()
		call HTSaveTriggerHandle(u, ENDCHANNEL, tick.getTrigger())
		call HTSaveTriggerActionHandle(trig, TRIGGERACTION, TriggerAddAction(trig, function AStopWhenChannelEnd))
		call HTSaveTriggerConditionHandle(trig, TRIGGERCONDITION, TriggerAddCondition(trig, filter))
		call TriggerRegisterUnitEvent(trig, u, EVENT_UNIT_SPELL_ENDCAST)
		set trig = null
	endfunction
endlibrary
