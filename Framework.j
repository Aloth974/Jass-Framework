// * * * * * * * * * * * * * * * * * * * * * * * * *
// *
// *            My JASS Framework
// *
// * * * * * * * * * * * * * * * * * * * * * * * * *
//
//      You HAVE TO declare those constants, else it won't compile at all :
// constant integer TimerMax = <Number of timers you need>
// constant integer GroupMax = <Number of groups you need>
// constant real TEXTPOSITION_X = <Text position on screen>
// constant real TEXTPOSITION_Y = <Text position on screen>
// constant real AIPATROL_DETECTIONRANGE = <The range to detect a unit patrolling>
// constant real AIPATROL_INTERVAL = <The interval between each patrol orders>

// * * * * * * * * * *
// * Hashtable
// * * * * * * * * * *
// HTSave<Basetype>(handle parent, integer child, <basetype> data) -> nothing
// HTLoad<Basetype>(handle parent, integer child) -> <basetype>
// HTHaveSaved<Basetype>(handle parent, integer child) -> boolean
// HTRemoveSaved<Basetype>(handle parent, integer child) -> nothing
// HTSave<Type>Handle(handle parent, integer child, <type> data) -> nothing
// HTLoad<Type>Handle(handle parent, integer child) -> <type>
// HTHaveSavedHandle(handle parent, integer child) -> boolean
// HTRemoveSavedHandle(handle parent, integer child) -> nothing
// HTFlushChildHashtable(handle parent) -> nothing
// /!\ Should not be used :
// HTFlushParentHashtable() -> nothing

// * * * * * * * * * *
// * Maths
// * * * * * * * * * *
// CheckX(real x) -> real
// CheckY(real y) -> real
// GetRandomX() -> real
// GetRandomY() -> real
// PolarX(real x, real dist, real angle) -> real
// PolarY(real x, real dist, real angle) -> real
// DistanceBetweenUnits(unit caster, unit target) -> real
// DistanceBetweenXY(real x1, real y1, real x2, real y2) -> real
// DistanceBetweenXYZ(real x1, real y1, real z1, real x2, real y2, real z2) -> real
// AngleBetweenUnits(unit caster, unit target) -> real
// AngleBetweenXY(real x1, real y1, real x2, real y2) -> real
// GetUnitZ(unit u) -> real
// SetUnitXY(unit u, real x, real y) -> nothing
// SetUnitZ(unit u, real z) -> nothing
// GetUnitMissingLife(unit u) -> real
// GetNearestItemInRange(real x, real y, real range) -> item

// * * * * * * * * * *
// * RecycleTimers
// * * * * * * * * * *
// CleanTimer(timer t) -> timer
// NewTimer() -> timer
// DeleteTimer(timer t) -> nothing
// DisplayTimer() -> nothing

// * * * * * * * * * *
// * RecycleGroups
// * * * * * * * * * *
// CleanGroup(group g) -> group
// NewGroup() -> group
// DeleteGroup(group g) -> nothing
// DisplayGroup() -> nothing

// * * * * * * * * * *
// * RecycleUnits
// * * * * * * * * * *
// CleanUnit(unit u) -> unit
// NewUnit() -> unit
// DeleteUnit(unit u, real delay) -> nothing
// DisplayUnit() -> nothing

// * * * * * * * * * *
// * Utilities
// * * * * * * * * * *
// CombatText(string s, real size, unit u, real r, real g, real b, real angMin, real angMax) -> nothing
// DisplayTextToAll(real dur, string s) -> nothing
// DisplayTextToOne(player p, real dur, string s) -> nothing
// GetColorByPlayerId(integer i) -> string
// TriggerRegisterAnyUnitEvent(trigger trig, playerunitevent ev, boolexpr filt)
// GetItemOfTypeInUnitInventory(unit u, integer itemid) -> item
// GetItemSlot(unit u, item it) -> integer
// ModifyLife(unit u, real delta) -> real
// ModifyMana(unit u, real delta) -> real

//              It will provides you new functions to use :
//      AddAbilityTimed(unit u, real dur, integer abilid) -> nothing
//      AddUnitUserDataTimed(unit u, integer i, real dur) -> nothing
//      ChangeHeightOverTime(unit u, real dur, real height) -> nothing
//      CreateDestructableTimed(integer destructid, real x, real y, real dur) -> nothing
//      CreateEffectTimed(unit u, string path, string attach, real dur) -> nothing
//      CreateEffectXYTimed(real x, real y, string path, real dur) -> nothing
//      CreateLightningBetweenUnitsTimed(unit caster, unit target, string codeName, real dur) -> lightning
//      DamageOverTime(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype) -> void
//      DamageOverTimeMatchingBuff(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype, integer buffid) -> void
//      ExecuteFuncTimed(string s, real dur) -> nothing
//      GetAlliesInRange(player p, real x, real y, real range, integer count) -> group
//      GetAlliesInRangeOfUnit(unit u, real range, integer count) -> group
//      GetEnnemiesInRange(player p, real x, real y, real range, integer count) -> group
//      GetEnnemiesInRangeOfUnit(unit u, real range, integer count) -> group
//      GetNearestAllyInRange(player p, real x, real y, real range) -> unit
//      GetNearestAllyInRangeOfUnit(unit u, real range) -> unit
//      GetNearestAllyHeroInRange(player p, real x, real y, real range) -> unit
//      GetNearestAllyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetNearestEnemyInRange(player p, real x, real y, real range) -> unit
//      GetNearestEnemyInRangeOfUnit(unit u, real range) -> unit
//      GetNearestEnemyHeroInRange(player p, real x, real y, real range) -> unit
//      GetNearestEnemyHeroInRangeOfUnit(unit u, real range) -> unit
//      GetNearestUnitOfGroup(real x, real y, group g) -> unit
//      GetUnitsInRange(real x, real y, real range, integer count) -> group
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
//      NoPathingTimed(unit u, real dur) -> nothing
//      ResetAbilityCooldown(unit u, integer abilid) -> real
//      SlideUnit(unit u, real dist, real angle, real duration, boolean linear) -> nothing
//      StopTarget(unit u) -> nothing
//      StopWhenChannelEnd(unit u, timer t, boolexpr filter) -> nothing
//      TriggerRegisterAnyUnitDamaged(trigger trig) -> nothing
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
//! import "\\ALDORANDE\Developpement\Jass\Framework\Constants.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Hashtable.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\RecycleTimers.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\RecycleGroups.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\RecycleUnits.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Maths.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Conditions.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Utilities.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Timed.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\Unit.j"
//      Systems
//! import "\\ALDORANDE\Developpement\Jass\Framework\Trigger.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\AIGroup.j"
//! import "\\ALDORANDE\Developpement\Jass\Framework\AIPatrol.j"
