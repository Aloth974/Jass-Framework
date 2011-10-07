library Utilities needs Constants
    // You have to declare constants :
    // constant real TEXTPOSITION_X = <Position X on screen>
    // constant real TEXTPOSITION_Y = <Position Y on screen>
    function CombatText takes string s, real size, unit u, real r, real g, real b, real ang1, real ang2 returns nothing
        local texttag t = null
        local real angle = GetRandomReal(ang1, ang2)
        if(IsUnitVisible(u, GetLocal())) then
            set t = CreateTextTag()
            call SetTextTagText(t, s, size*0.023/10)
            call SetTextTagPosUnit(t, u, 0.)
            call SetTextTagColor(t, PercentToInt(r, 255), PercentToInt(g, 255), PercentToInt(b, 255), 255)
            call SetTextTagPermanent(t, false)
            call SetTextTagVelocity(t, 0.035*Cos(angle * bj_DEGTORAD), 0.035*Sin(angle * bj_DEGTORAD))
            call SetTextTagLifespan(t, 2.)
            call SetTextTagFadepoint(t, 1.5)
            call SetTextTagVisibility(t, true)
            set t = null
        endif
    endfunction
    function DisplayTextToAll takes real dur, string s returns nothing
        if(dur<=0.0) then
            call DisplayTextToPlayer(GetLocal(), TEXTPOSITION_X, TEXTPOSITION_Y, s)
        else
            call DisplayTimedTextToPlayer(GetLocal(), TEXTPOSITION_X, TEXTPOSITION_Y, dur, s)
        endif
    endfunction
    function DisplayTextToOne takes player p, real dur, string s returns nothing
        if(dur<=0.0) then
            call DisplayTextToPlayer(p, TEXTPOSITION_X, TEXTPOSITION_Y, s)
        else
            call DisplayTimedTextToPlayer(p, TEXTPOSITION_X, TEXTPOSITION_Y, dur, s)
        endif
    endfunction
    function GetColorByPlayerId takes integer i returns string
        if(i==0) then
            return COLOR_RED
        elseif(i==1) then
            return COLOR_BLUE
        elseif(i==2) then
            return COLOR_CYAN
        elseif(i==3) then
            return COLOR_PURPLE
        elseif(i==4) then
            return COLOR_YELLOW
        elseif(i==5) then
            return COLOR_ORANGE
        elseif(i==6) then
            return COLOR_GREEN
        elseif(i==7) then
            return COLOR_PINK
        elseif(i==8) then
            return COLOR_LIGHT_GREY
        elseif(i==9) then
            return COLOR_LIGHT_BLUE
        elseif(i==10) then
            return COLOR_AQUA
        elseif(i==11) then
            return COLOR_BROWN
        elseif(i==12) then
            return COLOR_DARK_ORANGE
        elseif(i==13) then
            return COLOR_DARK_AQUA
        elseif(i==14) then
            return COLOR_DARK_GREY
        else
            return COLOR_WHITE
        endif
    endfunction
    function TriggerRegisterAnyUnitEvent takes trigger trig, playerunitevent whichEvent, boolexpr filter returns nothing
        local integer index = 0
        loop
            call TriggerRegisterPlayerUnitEvent(trig, GetPlayer(index), whichEvent, filter)
            set index=index+1
            exitwhen index>=bj_MAX_PLAYER_SLOTS
        endloop
    endfunction
    function GetItemOfTypeInUnitInventory takes unit u, integer itemid returns item
        local integer i = 0
        loop
            exitwhen i>=6
            if(GetItemTypeId(UnitItemInSlot(u, i))==itemid) then
                return UnitItemInSlot(u, i)
            endif
            set i = i + 1
        endloop
        return null
    endfunction
    function GetItemSlot takes unit u, item it returns integer
        local integer i = 0
        loop
            exitwhen i>=6
            if(UnitItemInSlot(u, i)==it) then
                return i
            endif
            set i = i + 1
        endloop
        return -1
    endfunction
    function ModifyLife takes unit u, real delta returns real
        local real d = delta
        local real max = GetUnitState(u, UNIT_STATE_MAX_LIFE)
        local real cur = GetUnitState(u, UNIT_STATE_LIFE)
        local real r = cur+delta
        if(r<=0.0) then
            set r = 0.0
            set d = -cur
        elseif(r>=max) then
            set r = max
            set d = max-cur
        endif
        call SetUnitState(u, UNIT_STATE_LIFE, r)
        return d
    endfunction
    function ModifyMana takes unit u, real delta returns real
        local real d = delta
        local real max = GetUnitState(u, UNIT_STATE_MAX_MANA)
        local real cur = GetUnitState(u, UNIT_STATE_MANA)
        local real r = cur+delta
        if(r<=0.0) then
            set r = 0.0
            set d = cur
        elseif(r>=max) then
            set r = max
            set d = max-cur
        endif
        call SetUnitState(u, UNIT_STATE_MANA, r)
        return d
    endfunction
endlibrary
