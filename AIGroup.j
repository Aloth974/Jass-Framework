library AIGroup needs HandleRecycle, Hashtable, Trigger
    struct AIGroup
        group g
        trigger trig
        triggeraction trigAct
        static method AIGroupMemberDamaged takes nothing returns nothing
            local unit u = GetTriggerUnit()
            local unit v = null
            local group g = null
            if(HTHaveSavedHandle(u, AIGROUP)) then
                set g = NewGroup()
                call GroupAddGroup(HTLoadGroupHandle(u, AIGROUP), g)
                loop
                    set v = FirstOfGroup(g)
                    exitwhen v==null
                    call GroupRemoveUnit(g, v)
                    call IssuePointOrder(v, "attack", GetUnitX(u), GetUnitY(u))
                endloop
                set v = null
                call DeleteGroup(g)
            endif
            set u = null
        endmethod
        static method create takes nothing returns AIGroup
            local AIGroup this = AIGroup.allocate()
            set .g = NewGroup()
            set .trig = CreateTrigger()
            set .trigAct = TriggerAddAction(.trig, function AIGroup.AIGroupMemberDamaged)
            call TriggerRegisterAnyUnitDamaged(.trig)
            return this
        endmethod
        method delete takes nothing returns nothing
            call TriggerRemoveAction(.trig, .trigAct)
            call DestroyTrigger(.trig)
            call DeleteGroup(.g)
        endmethod
        method add takes unit u returns nothing
            if(GetUnitState(u, UNIT_STATE_LIFE)>0.) then
                call HTSaveGroupHandle(u, AIGROUP, .g)
            endif
        endmethod
        method remove takes unit u returns nothing
            call HTRemoveSavedHandle(u, AIGROUP)
        endmethod
    endstruct
endlibrary
