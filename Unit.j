library Unit initializer init needs Constants, Maths
    globals
        boolexpr FTRUE
        boolexpr FAlive
        unit buffer_UNIT
        group buffer_GROUP
        integer buffer_INTEGER
        real buffer_X
        real buffer_Y
        real buffer_REAL       
    endglobals
    function StopTarget takes unit u returns nothing
        call IssueImmediateOrderById(u, STOP)
        call SetUnitPosition(u, GetUnitX(u), GetUnitY(u))
    endfunction
    function ResetAbilityCooldown takes unit u, integer abilid returns nothing
        local integer lvl = GetUnitAbilityLevel(u, abilid)
        if(lvl>0) then
            call UnitRemoveAbility(u, abilid)
            call UnitAddAbility(u, abilid)
            call SetUnitAbilityLevel(u, abilid, lvl)
        endif
    endfunction
    
    function TRUEFilt takes nothing returns boolean
        return true
    endfunction
    function AliveFilt takes nothing returns boolean
        return GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE)>0.
    endfunction

    function GetUnitsInRange takes real x, real y, real range, integer count returns group
        local group g = NewGroup()
        if(range <= 0.) then
            set range = - range
        endif
        if(count<=0) then
            call GroupEnumUnitsInRange(g, CheckX(x), CheckY(y), range, FAlive)
        else
            call GroupEnumUnitsInRangeCounted(g, CheckX(x), CheckY(y), range, FAlive, count)
        endif
        return g
    endfunction

    function GetEnnemiesInRangeEnum takes nothing returns nothing
        if(IsUnitEnemy(GetEnumUnit(), buffer_PLAYER)==false) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GetEnnemiesInRange takes player p, real x, real y, real range, integer count returns group
        set buffer_PLAYER = p
        set buffer_GROUP = GetUnitsInRange(x, y, range, count)
        if(p != null) then
            call ForGroup(buffer_GROUP, function GetEnnemiesInRangeEnum)
        endif
        return buffer_GROUP
    endfunction
    function GetEnnemiesInRangeOfUnit takes unit u, real range, integer count returns group
        return GetEnnemiesInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range, count)
    endfunction

    function GetAlliesInRangeEnum takes nothing returns nothing
        if(IsUnitAlly(GetEnumUnit(), buffer_PLAYER)==false) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GetAlliesInRange takes player p, real x, real y, real range, integer count returns group
        set buffer_PLAYER = p
        set buffer_GROUP = GetUnitsInRange(x, y, range, count)
        if(p != null) then
            call ForGroup(buffer_GROUP, function GetAlliesInRangeEnum)
        endif
        return buffer_GROUP
    endfunction
    function GetAlliesInRangeOfUnit takes unit u, real range, integer count returns group
        return GetAlliesInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range, count)
    endfunction

    function GetWoundestUnitOfGroupEnum takes nothing returns nothing
        if(GetUnitMissingLife(GetEnumUnit())>GetUnitMissingLife(buffer_UNIT)) then
            set buffer_UNIT = GetEnumUnit()
        endif
    endfunction
    function GetWoundestUnitOfGroup takes group g returns unit
        set buffer_UNIT = FirstOfGroup(g)
        call ForGroup(g, function GetWoundestUnitOfGroupEnum)
        return buffer_UNIT
    endfunction
    
    function GetNearestUnitOfGroupEnum takes nothing returns nothing
        if(DistanceBetweenXY(GetUnitX(GetEnumUnit()), GetUnitY(GetEnumUnit()), buffer_X, buffer_Y)<DistanceBetweenXY(GetUnitX(buffer_UNIT), GetUnitY(buffer_UNIT), buffer_X, buffer_Y)) then
            set buffer_UNIT = GetEnumUnit()
        endif
    endfunction
    function GetNearestUnitOfGroup takes group g, real x, real y returns unit
        set buffer_GROUP = g
        set buffer_X = CheckX(x)
        set buffer_Y = CheckY(y)
        set buffer_UNIT = FirstOfGroup(g)
        call ForGroup(g, function GetNearestUnitOfGroupEnum)
        return buffer_UNIT
    endfunction
    
    function GroupRemoveStructuresEnum takes nothing returns nothing
        if(IsUnitType(GetEnumUnit(), UNIT_TYPE_STRUCTURE)==true) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveStructures takes group g returns nothing
        set buffer_GROUP = g
        call ForGroup(g, function GroupRemoveStructuresEnum)
    endfunction
    
    function GroupRemoveUnitsOfPlayerEnum takes nothing returns nothing
        if(GetPlayerId(GetOwningPlayer(GetEnumUnit()))==GetPlayerId(buffer_PLAYER)) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveUnitsOfPlayer takes group g, player p returns nothing
        set buffer_GROUP = g
        set buffer_PLAYER = p
        call ForGroup(g, function GroupRemoveUnitsOfPlayerEnum)
    endfunction
    
    function GroupRemoveUnitsOfTypeEnum takes nothing returns nothing
        if(GetUnitTypeId(GetEnumUnit())==buffer_INTEGER) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveUnitsOfType takes group g, integer id returns nothing
        set buffer_GROUP=g
        set buffer_INTEGER=id
        call ForGroup(g, function GroupRemoveUnitsOfTypeEnum)
    endfunction
    
    function GroupRemoveHeroesEnum takes nothing returns nothing
        if(IsUnitType(GetEnumUnit(), UNIT_TYPE_HERO)==true) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveHeroes takes group g returns nothing
        set buffer_GROUP = g
        call ForGroup(g, function GroupRemoveHeroesEnum)
    endfunction
    
    function GroupRemoveUnitsAtXYEnum takes nothing returns nothing
        if(GetUnitX(GetEnumUnit()) == buffer_X and GetUnitY(GetEnumUnit()) == buffer_Y) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveUnitsAtXY takes group g, real x, real y returns nothing
        set buffer_GROUP = g
        set buffer_X = x
        set buffer_Y = y
        call ForGroup(g, function GroupRemoveUnitsAtXYEnum)
    endfunction
    
    function GroupRemoveUnitsInRangeOfXYEnum takes nothing returns nothing
        if(DistanceBetweenXY(GetUnitX(GetEnumUnit()), GetUnitY(GetEnumUnit()), buffer_X, buffer_Y) <= buffer_REAL) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupRemoveUnitsInRangeOfXY takes group g, real x, real y, real delta returns nothing
        set buffer_GROUP = g
        set buffer_X = x
        set buffer_Y = y
        set buffer_REAL = delta
        call ForGroup(g, function GroupRemoveUnitsInRangeOfXYEnum)
    endfunction
    
    function GroupKeepHeroesEnum takes nothing returns nothing
        if(IsUnitType(GetEnumUnit(), UNIT_TYPE_HERO)==false) then
            call GroupRemoveUnit(buffer_GROUP, GetEnumUnit())
        endif
    endfunction
    function GroupKeepHeroes takes group g returns nothing
        set buffer_GROUP = g
        call ForGroup(g, function GroupKeepHeroesEnum)
    endfunction

    function GetNearestAllyInRange takes player p, real x, real y, real range returns unit
        local group g = GetAlliesInRange(p, x, y, range, 0)
        call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
        set buffer_UNIT = GetNearestUnitOfGroup(g, x, y)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetNearestAllyInRangeOfUnit takes unit u, real range returns unit
        return GetNearestAllyInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetWoundestAllyInRange takes player p, real x, real y, real range returns unit
        local group g = GetAlliesInRange(p, x, y, range, 0)
        call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
        set buffer_UNIT = GetWoundestUnitOfGroup(g)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetWoundestAllyInRangeOfUnit takes unit u, real range returns unit
        return GetWoundestAllyInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetNearestEnemyInRange takes player p, real x, real y, real range returns unit
        local group g = GetEnnemiesInRange(p, x, y, range, 0)
        set buffer_UNIT = GetNearestUnitOfGroup(g, x, y)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetNearestEnemyInRangeOfUnit takes unit u, real range returns unit
        return GetNearestEnemyInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetWoundestEnemyInRange takes player p, real x, real y, real range returns unit
        local group g = GetEnnemiesInRange(p, x, y, range, 0)
        set buffer_UNIT = GetWoundestUnitOfGroup(g)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetWoundestEnemyInRangeOfUnit takes unit u, real range returns unit
        return GetWoundestEnemyInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetNearestAllyHeroInRange takes player p, real x, real y, real range returns unit
        local group g = GetAlliesInRange(p, x, y, range, 0)
        call GroupKeepHeroes(g)
        call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
        set buffer_UNIT = GetNearestUnitOfGroup(g, x, y)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetNearestAllyHeroInRangeOfUnit takes unit u, real range returns unit
        return GetNearestAllyHeroInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetWoundestAllyHeroInRange takes player p, real x, real y, real range returns unit
        local group g = GetAlliesInRange(p, x, y, range, 0)
        call GroupKeepHeroes(g)
        call GroupRemoveUnitsOfPlayer(g, GetPlayer(15))
        set buffer_UNIT = GetWoundestUnitOfGroup(g)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetWoundestAllyHeroInRangeOfUnit takes unit u, real range returns unit
        return  GetWoundestAllyHeroInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetNearestEnemyHeroInRange takes player p, real x, real y, real range returns unit
        local group g = GetEnnemiesInRange(p, x, y, range, 0)
        call GroupKeepHeroes(g)
        set buffer_UNIT = GetNearestUnitOfGroup(g, x, y)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetNearestEnemyHeroInRangeOfUnit takes unit u, real range returns unit
        return GetNearestEnemyHeroInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    function GetWoundestEnemyHeroInRange takes player p, real x, real y, real range returns unit
        local group g = GetEnnemiesInRange(p, x, y, range, 0)
        call GroupKeepHeroes(g)
        set buffer_UNIT = GetWoundestUnitOfGroup(g)
        call DeleteGroup(g)
        return buffer_UNIT
    endfunction
    function GetWoundestEnemyHeroInRangeOfUnit takes unit u, real range returns unit
        return GetWoundestEnemyHeroInRange(GetOwningPlayer(u), GetUnitX(u), GetUnitY(u), range)
    endfunction

    private function init takes nothing returns nothing
        set FTRUE = Filter(function TRUEFilt)
        set FAlive = Filter(function AliveFilt)
    endfunction
endlibrary
