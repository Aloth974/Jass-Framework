library AIPatrol needs Constants, RecycleTimers, Hashtable, Maths
// Allow you to make a unit patrol between multiples locations
// Remember : you CANNOT have MORE than 25 locations on a single unit
// Just instanciate a AIPatrol variable and use constructor :
// AIPatrol.create(unit u, real xFirst, yFirst, xSecond, ySecond)
// -> cause unit need two locations to start patrolling
// Then, start the patrol with AIPatrol.StartPatrol(unit u)
// Note that the unit will be positionned on the first patrol location
// and you won't be able to stop the patrolling loop
// When the unit dying, the loop stop by itself and clean the struct

// You have to declare constants to make this library runnable :
// constant real AIPATROL_DETECTIONRANGE
// constant real AIPATROL_INTERVAL
    struct AIPatrol
        unit u
        integer count
        integer slot
        static method AIPatrolLoop takes nothing returns nothing
            local timer t = GetExpiredTimer()
            local AIPatrol p = HTLoadInteger(t, AIPATROL)
            local integer cur = HTLoadInteger(p.u, AIPATROLCURRENT)
            local real xt = HTLoadReal(p.u, AIPATROLHASH+cur+2)
            local real yt = HTLoadReal(p.u, AIPATROLHASH+cur+3)
            if(GetUnitState(p.u, UNIT_STATE_LIFE)<=0.) then
                call p.delete()
                call p.destroy()
                call HTFlushChildHashtable(t)
                call DeleteTimer(t)
            else
                if(DistanceBetweenXY(GetUnitX(p.u), GetUnitY(p.u), xt, yt)>AIPATROL_DETECTIONRANGE) then
                    call IssuePointOrderById(p.u, ATTACK, xt, yt)
                else
                    if(cur>=p.count-2) then
                        set cur=-4
                    endif
                    call HTSaveInteger(p.u, AIPATROLCURRENT, cur+2)
                endif
                call TimerStart(t, AIPATROL_INTERVAL, false, function AIPatrol.AIPatrolLoop)
            endif
        endmethod
        static method StartPatrol takes AIPatrol p returns nothing
            local timer t = NewTimer()
            call HTSaveInteger(t, AIPATROL, p)
            call HTSaveInteger(p.u, AIPATROLCURRENT, 0)
            call SetUnitXY(p.u, HTLoadReal(p.u, AIPATROLHASH), HTLoadReal(p.u, AIPATROLHASH+1))
            call TimerStart(t, 1., false, function AIPatrol.AIPatrolLoop)
        endmethod
        static method create takes unit u, real x1, real y1, real x2, real y2 returns AIPatrol
            local AIPatrol this = AIPatrol.allocate()
            set .u = u
            set .count = 2
            set .slot = 4
            call HTSaveReal(.u, AIPATROLHASH+0, x1)
            call HTSaveReal(.u, AIPATROLHASH+1, y1)
            call HTSaveReal(.u, AIPATROLHASH+2, x2)
            call HTSaveReal(.u, AIPATROLHASH+3, y2)
            return this
        endmethod
        method delete takes nothing returns nothing
            local integer i = 0
            loop
                exitwhen i>.slot
                call HTRemoveSavedReal(.u, AIPATROLHASH+i)
                set i=i+1
            endloop
            call HTRemoveSavedInteger(.u, AIPATROLCURRENT)
            set .u = null
        endmethod
        method add takes real x, real y returns nothing
            if(.count>=25) then
                call BJDebugMsg("Error : Trying to have more than 25 patrol location on a single unit.")
            else
                call HTSaveReal(.u, AIPATROLHASH+.slot, x)
                call HTSaveReal(.u, AIPATROLHASH+.slot+1, y)
                set .slot = .slot + 2
                set .count = .count + 1
            endif
        endmethod
    endstruct
endlibrary
