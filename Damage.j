// * * * * *
// * You have to declare this function : function MeleeCriticalStrikeHandler takes unit caster, unit target, real damage returns nothing
// *
// * Based on system here : http://www.hiveworkshop.com/forums/jass-ai-scripts-tutorials-280/attack-damage-detection-engine-jass-33123/
// * 
// * Really disappointed on this system thought because of non-interoperability with other damage system :
// * If unit A attacks unit B, unit B in critical-enabled for a short amout of time to detect the attack damage. But if another kind of damage come such as a spell, then this spell could take advantage of that critical system and thus cannot have is own critical system otherwise it could be critical twice.
// * We can obviously try to tricks this as ading a trigger which detech spell cast and remove critical system on target, but then again, what about DoTs spells ? You can still attack after the spell was cast and add some extra critical damage to DoT tick.
// * So we can disable critical system on target before each spell damage ? And but again, if a DoT tick between the time your unit attack and the target actually take the damage ? Your attack won't benefit from critical system.
// * * * * *

library Damage needs Hashtable, RecycleTimers initializer init
	globals
		constant real DAMAGE_TRIGGER_TIMEOUT = 5
		private trigger AttackTrigger
		private boolexpr DamageTriggerCond
		private boolexpr AttackTriggerCond
	endglobals
	
	function CleanDamageTrigger takes trigger t returns nothing
		local triggeraction action = HTLoadTriggerActionHandle(t, TRIGGERACTION)
		local unit caster = HTLoadUnitHandle(t, DAMAGE_CASTER)
		if(HTHaveSavedBoolean(caster, DAMAGE_SYSTEM)) then
			call HTRemoveSavedBoolean(caster, DAMAGE_SYSTEM)
		endif
		call TriggerRemoveAction(t, action)
		call TriggerRemoveCondition(t, DamageTriggerCond)
		call HTFlushChildHashtable(DamageTrigger)
		call DestroyTrigger(DamageTrigger)
		set caster = null
		set action = null
	endfunction
	
	function DamageTriggerConditions takes nothing returns boolean
		return GetEventDamageSource() == HTLoadUnitHandle(GetTriggeringTrigger(), DAMAGE_CASTER)
	endfunction
	
	function AttackTriggerConditions takes nothing returns boolean
		return IsUnitHero(GetAttacker()) and not HTHaveSavedBoolean(GetAttacker(), DAMAGE_SYSTEM)
	endfunction
	
	function DamageTriggerActions takes nothing returns nothing
		local unit caster = GetEventDamageSource()
		local unit target = GetTriggerUnit()
		local trigger DamageTrigger = GetTriggeringTrigger()
		local real damage = GetEventDamage()
		call CleanDamageTrigger(DamageTrigger)
		set DamageTrigger = null
		
		call MeleeCriticalStrikeHandler(caster, target, damage)
		
		set target = null
		set caster = null
	endfunction
	
	function AttackTriggerActionsTimeout takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local trigger trig = null
		
		if(HTHaveSavedHandle(t, TRIGGER)) then
			set trig = HTLoadTriggerHandle(t, TRIGGER)
			if(trig != null) then
				call CleanDamageTrigger()
				set trig = null
			endif
		endif
		
		call DeleteTimer(t)
	endfunction
	
	function AttackTriggerActions takes nothing returns nothing
		local unit caster = GetAttacker()
		local unit target = GetTriggerUnit()
		local trigger DamageTrigger = CreateTrigger()
		local timer t = NewTimer()
		call TriggerRegisterUnitEvent(DamageTrigger, target, EVENT_UNIT_DAMAGED)
		call TriggerAddCondition(DamageTrigger, DamageTriggerCond)
		call HTSaveUnitHandle(DamageTrigger, DAMAGE_CASTER, caster)
		call HTSaveTriggerActionHandle(DamageTrigger, TRIGGERACTION, TriggerAddAction(DamageTrigger, function DamageTriggerActions))
		
		call HTSaveBoolean(caster, DAMAGE_SYSTEM)
		
		call HTSaveTriggerHandle(t, TRIGGER, DamageTrigger)
		call TimerStart(t, DAMAGE_TRIGGER_TIMEOUT, false, function AttackTriggerActionsTimeout)

		set DamageTrigger = null
		set target = null
		set caster = null
	endfunction
	
	function init takes nothing returns nothing
		set Damage_AttackTrigger = CreateTrigger()
		set DamageTriggerCond = Condition(function DamageTriggerConditions)
		set AttackTriggerCond = Condition(function AttackTriggerConditions)
		call TriggerRegisterAnyUnitEventBJ(AttackTrigger, EVENT_PLAYER_UNIT_ATTACKED)
		call TriggerAddCondition(AttackTrigger, AttackTriggerCond)
		call TriggerAddAction(AttackTrigger, function AttackTriggerActions)
	endfunction
endlibrary
