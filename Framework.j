// * * * * * * * * * * * * * * * * * * * * * * * * *
// *
// *            My JASS Framework
// *
// * * * * * * * * * * * * * * * * * * * * * * * * *
//
//              Error Codes :
//  0 : Timer Concerning
//  1 : Group Concerning
//  8 : Item Concerning
//  0 : Limit has been excedeed
//  1 : No longer exist
//  3 : Not enough
//
//      You HAVE TO declare those constants, else it won't compile :
// constant integer TimerMax = <Number of timers you need>
// constant integer GroupMax = <Number of groups you need>
// constant real TEXTPOSITION_X = <Text position on screen>
// constant real TEXTPOSITION_Y = <Text position on screen>
// constant real AIPATROL_DETECTIONRANGE = <The range to detect a unit patrolling>
// constant real AIPATROL_INTERVAL = <The interval between each patrol orders>
//
//              It will provides you new functions to use :
//      AddAbilityTimed(unit u, real dur, integer abilid) -> nothing
//      AddUnitUserDataTimed(unit u, integer i, real dur) -> nothing
//      AngleBetweenUnits(unit caster, unit target) -> real
//      AngleBetweenXY(real x1, real y1, real x2, real y2) -> real
//      ChangeHeightOverTime(unit u, real dur, real height) -> nothing
//      CheckX(real x) -> real
//      CheckY(real y) -> real
//      CombatText(string s, real size, unit u, real r, real g, real b, real angMin, real angMax) -> nothing
//      CreateDestructableTimed(integer destructid, real x, real y, real dur) -> nothing
//      CreateEffectTimed(unit u, string path, string attach, real dur) -> nothing
//      CreateEffectXYTimed(real x, real y, string path, real dur) -> nothing
//      CreateLightningBetweenUnitsTimed(unit caster, unit target, string codeName, real dur) -> lightning
//      DamageOverTime(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype) -> void
//      DamageOverTimeMatchingBuff(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype, integer buffid) -> void
//      DeleteGroup(group g) -> nothing
//      DeleteTimer(timer t) -> nothing
//      DisplayTextToAll(real dur, string s) -> nothing
//      DisplayTextToOne(player p, real dur, string s) -> nothing
//      DistanceBetweenUnits(unit caster, unit target) -> real
//      DistanceBetweenXY(real x1, real y1, real x2, real y2) -> real
//      DistanceBetweenXYZ(real x1, real y1, real z1, real x2, real y2, real z2) -> real
//      ExecuteFuncTimed(string s, real dur) -> nothing
//      GetAlliesInRange(player p, real x, real y, real range, integer count) -> group
//      GetAlliesInRangeOfUnit(unit u, real range, integer count) -> group
//      GetColorByPlayerId(integer i) -> string
//      GetEnnemiesInRange(player p, real x, real y, real range, integer count) -> group
//      GetEnnemiesInRangeOfUnit(unit u, real range, integer count) -> group
//      GetItemOfTypeInUnitInventory(unit u, integer itemid) -> item
//      GetItemSlot(unit u, item it) -> integer
//      GetNearestAllyInRange(player p, real x, real y, real range) -> unit
//      GetNearestAllyInRangeOfUnit(unit u, real range) -> unit
//      GetNearestAllyHeroInRange(player p, real x, real y, real range) -> unit
//      GetNearestAllyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetNearestEnemyInRange(player p, real x, real y, real range) -> unit
//      GetNearestEnemyInRangeOfUnit(unit u, real range) -> unit
//      GetNearestEnemyHeroInRange(player p, real x, real y, real range) -> unit
//      GetNearestEnemyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetNearestItemInRange(real x, real y, real range) -> item
//      GetNearestUnitOfGroup(real x, real y, group g) -> unit
//      GetRandomX() -> real
//      GetRandomY() -> real
//      GetUnitMissingLife(unit u) -> real
//      GetUnitsInRange(real x, real y, real range, integer count) -> group
//      GetUnitZ(unit u) -> real
//      GetWoundestAllyInRange(player p, real x, real y, real range) -> unit
//      GetWoundestAllyInRangeOfUnit(unit u, real range) -> unit
//      GetWoundestAllyHeroInRange(player p, real x, real y, real range) -> unit
//      GetWoundestAllyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetWoundestEnemyInRange(player p, real x, real y, real range) -> unit
//      GetWoundestEnemyInRangeOfUnit(unit u,, real range) -> unit
//      GetWoundestEnemyHeroInRange(player p, real x, real y, real range) -> unit
//      GetWoundestEnemyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetWoundestUnitOfGroup(group g) -> unit
//      GroupKeepHeroes(group g) -> nothing
//      GroupRemoveHeroes(group g) -> nothing
//      GroupRemoveStructures(group g) -> nothing
//      GroupRemoveUnitsAtXY(group g, real x, real y) -> nothing
//      GroupRemoveUnitsInRangeOfXY(group g, real x, real y, real range) -> nothing
//      GroupRemoveUnitsOfPlayer(group g, player p) -> nothing
//      GroupRemoveUnitsOfType(group g, integer id) -> nothing
//      HTFlushChildHashtable(handle parent) -> nothing
//      HTHaveSaved<Basetype>(handle parent, integer child) -> boolean
//      HTHaveSavedHandle(handle parent, integer child) -> boolean
//      HTLoad<Type>Handle(handle parent, integer child) -> <type>
//      HTLoad<Basetype>(handle parent, integer child) -> <basetype>
//      HTRemoveSaved<Basetype>(handle parent, integer child) -> nothing
//      HTRemoveSavedHandle(handle parent, integer child) -> nothing
//      HTSave<Type>Handle(handle parent, integer child, <type> data) -> nothing
//      HTSave<Basetype>Handle(handle parent, integer child, <basetype> data) -> nothing
//      IsComputer() -> boolean
//      IsHero() -> boolean
//      IsHuman() -> boolean
//      IsNearbyAlly(player p, real x, real y, real range) -> boolean
//      IsNearbyAllyOfUnit(unit u, real range) -> boolean
//      IsNearbyAllyHero(player p, real x, real y, real range) -> boolean
//      IsNearbyAllyHeroOfUnit(unit u, real range) -> boolean
//      IsNearbyEnemy(player p, real x, real y, real range) -> boolean
//      IsNearbyEnemyOfUnit(unit u, real range) -> boolean
//      IsNearbyEnemyHero(player p, real x, real y, real range) -> boolean
//      IsNearbyEnemyHeroOfUnit(unit u, real range) -> boolean
//      IsNearbyHero(real x, real y, real range) -> boolean
//      IsNearbyHeroOfUnit(unit u, real range) -> boolean
//      IsNearbyUnit(real x, real y, real range) -> boolean
//      IsNearbyUnitOfUnit(unit u, real range) -> boolean
//      IsPlayed() -> boolean
//      IsSlotComputer(player p) -> boolean
//      IsSlotHuman(player p) -> boolean
//      IsSlotPlayed(player p) -> boolean
//      IsTriggerUnitHero() -> boolean
//      IsUnitBehindTarget(unit caster, unit target) -> boolean
//      IsUnitHero(unit u) -> boolean
//      ModifyLife(unit u, real delta) -> real
//      ModifyMana(unit u, real delta) -> real
//      NewGroup() -> group
//      NewTimer() -> timer
//      NoPathingTimed(unit u, real dur) -> nothing
//      PolarX(real x, real dist, real angle) -> real
//      PolarY(real x, real dist, real angle) -> real
//      ResetAbilityCooldown(unit u, integer abilid) -> real
//      SetUnitXY(unit u, real x, real y) -> nothing
//      SetUnitZ(unit u, real z) -> nothing
//      SlideUnit(unit u, real dist, real angle, real duration, boolean linear) -> nothing
//      StopTarget(unit u) -> nothing
//      StopWhenChannelEnd(unit u, timer t, boolexpr filter) -> nothing
//      TriggerRegisterAnyUnitDamaged(trigger trig) -> nothing
//      TriggerRegisterAnyUnitEvent(trigger trig, playerunitevent ev, boolexpr filt)
//      UnitHasEmptySlot(unit u) -> boolean
//      UnitHasItemOfClass(unit u, itemtype itype) -> boolean
//      UnitHasItemOfType(unit u, integer itemid) -> boolean
//
//              Advanced systems use :
//      AIGroup <name> = AIGroup.create()
//      <name>.add(unit u)
//      <name>.delete() & <name>.destroy()
//
//      AIPatrol <name> = AIPatrol.create(unit u, real x1, real y1, real x2, real y2)
//      <name>.add(real x, real y)

//      Functions
//! import "F:\Warcraft Projects\Jass\Hashtable.j"
//! import "F:\Warcraft Projects\Jass\RecycleTimers.j"
//! import "F:\Warcraft Projects\Jass\RecycleGroups.j"
//! import "F:\Warcraft Projects\Jass\Constants.j"
//! import "F:\Warcraft Projects\Jass\Maths.j"
//! import "F:\Warcraft Projects\Jass\Conditions.j"
//! import "F:\Warcraft Projects\Jass\Utilities.j"
//! import "F:\Warcraft Projects\Jass\Timed.j"
//! import "F:\Warcraft Projects\Jass\Unit.j"
//      Systems
//! import "F:\Warcraft Projects\Jass\Trigger.j"
//! import "F:\Warcraft Projects\Jass\AIGroup.j"
//! import "F:\Warcraft Projects\Jass\AIPatrol.j"
