library HandleRecycle initializer init
    // constant integer MaxTimer = <Number of timers you want>
    // constant integer MaxGroup = <Number of groups you want>
    
    globals
        integer TimerCounter
        integer GroupCounter
        timer array TimerPool
        group array GroupPool
    endglobals
    
    function NewTimer takes nothing returns timer
        if(TimerCounter<=0) then
            call BJDebugMsg("|cFFF00000Error: Code 0-0.")
            set TimerPool[0]=CreateTimer()
        else
            set TimerCounter=TimerCounter-1
            if(TimerCounter<=MaxTimer/20) then
                call BJDebugMsg("|cFFF00000Warning: Code 0-3.")
            endif
            if(TimerPool[TimerCounter]==null) then
                call BJDebugMsg("|cFFF00000Error: Code 0-1.")
                set TimerPool[TimerCounter]=CreateTimer()
            endif
        endif
        return TimerPool[TimerCounter]
    endfunction
    
    function DeleteTimer takes timer t returns nothing
        call PauseTimer(t)
        set TimerPool[TimerCounter]=t
        set TimerCounter=TimerCounter+1
    endfunction

    function NewGroup takes nothing returns group
        if(GroupCounter<=0) then
            call BJDebugMsg("|cFFF00000Error: Code 1-0.")
            set GroupPool[0]=CreateGroup()
        else
            set GroupCounter=GroupCounter-1
            if(GroupCounter<=MaxGroup/20) then
                call BJDebugMsg("|cFFF00000Warning: Code 1-3.")
            endif
            if(GroupPool[GroupCounter]==null) then
                call BJDebugMsg("|cFFF00000Error: Code 1-1")
                set GroupPool[GroupCounter]=CreateGroup()
            endif
        endif
        call GroupClear(GroupPool[GroupCounter])
        return GroupPool[GroupCounter]
    endfunction
    
    function DeleteGroup takes group g returns nothing
        call GroupClear(g)
        set GroupPool[GroupCounter]=g
        set GroupCounter=GroupCounter+1
    endfunction
    
    private function init takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i>=MaxTimer
            set TimerPool[i]=CreateTimer()
            set i=i+1
        endloop
        set i=1
        loop
            exitwhen i>=MaxGroup
            set GroupPool[i]=CreateGroup()
            set i=i+1
        endloop
        set TimerCounter = MaxTimer
        set GroupCounter = MaxGroup
    endfunction
endlibrary
