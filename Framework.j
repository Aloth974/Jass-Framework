// * * * * * * * * * * * * * * * * * * * * * * * * *
// *
// *            My JASS Framework
// *
// * * * * * * * * * * * * * * * * * * * * * * * * *
//
//      You HAVE TO declare those constants, else it won't compile at all :
// constant integer TimerMax = <Number of timers you need>
// constant integer GroupMax = <Number of groups you need>
// constant real TextPositionX = <Position X of text on screen>
// constant real TextPositionY = <Position Y of text on screen>
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
// * Maths (needs Constants)
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
// IsAngleBetweenAngles(real angle, real middleAngle, real range) -> boolean
// IsPointInCone(real centerX, real centerY, real x, real y, real facingAngle, real range) -> boolean	
// GetAngleDifference(real a1, real a2, boolean absolute) -> real

// * * * * * * * * * *
// * Utilities (needs Constants)
// * * * * * * * * * *
// IsNight() -> boolean
// IsDay() -> boolean
// CombatText(string s, real size, unit u, real r, real g, real b, real angMin, real angMax) -> nothing
// DisplayTextToAll(real duration, string text) -> nothing
// DisplayTextToOne(player p, real duration, string text) -> nothing
// GetColorByPlayerId(integer i) -> string
// TriggerRegisterAnyUnitEvent(trigger trig, playerunitevent ev, boolexpr filt)
// GetItemOfTypeInUnitInventory(unit u, integer itemid) -> item
// GetItemSlot(unit u, item it) -> integer
// ModifyLife(unit u, real delta) -> real
// ModifyMana(unit u, real delta) -> real

// * * * * * * * * * *
// * RecycleTimers (needs Hashtable)
// * * * * * * * * * *
// CleanTimer(timer t) -> timer
// NewTimer() -> timer
// DeleteTimer(timer t) -> nothing
// DisplayTimer() -> nothing

// * * * * * * * * * *
// * RecycleGroups (needs Hashtable)
// * * * * * * * * * *
// CleanGroup(group g) -> group
// NewGroup() -> group
// DeleteGroup(group g) -> nothing
// DisplayGroup() -> nothing

// * * * * * * * * * *
// * RecycleUnits (NOT USED)
// * * * * * * * * * *
// CleanUnit(unit u) -> unit
// NewUnit() -> unit
// DeleteUnit(unit u, real delay) -> nothing
// DisplayUnit() -> nothing

// * * * * * * * * * *
// * Unit (needs Maths, RecycleGroup)
// * * * * * * * * * *
// DeleteUnit(unit u) -> nothing
// StopTarget(unit u) -> nothing
// ResetAbilityCooldown(unit u, integer abilid) -> nothing
// GetUnitsInRange(real x, real y, real range, integer count) -> group
// GetAlliesInRange(player p, real x, real y, real range, integer count) -> group
// GetAlliesInRangeOfUnit(unit u, real range, integer count) -> group
// GetEnnemiesInRange(player p, real x, real y, real range, integer count) -> group
// GetEnnemiesInRangeOfUnit(unit u, real range, integer count) -> group
// GetFarUnitOfGroup(real x, real y, group g) -> unit
// GetNearestAllyInRange(player p, real x, real y, real range) -> unit
// GetNearestAllyInRangeOfUnit(unit u, real range) -> unit
// GetNearestAllyHeroInRange(player p, real x, real y, real range) -> unit
// GetNearestAllyHeroInRangeOfUnit(unit u, real range) -> unit
// GetNearestEnemyInRange(player p, real x, real y, real range) -> unit
// GetNearestEnemyInRangeOfUnit(unit u, real range) -> unit
// GetNearestEnemyHeroInRange(player p, real x, real y, real range) -> unit
// GetNearestEnemyHeroInRangeOfUnit(unit u, real range) -> unit
// GetNearestUnitOfGroup(real x, real y, group g) -> unit
// GetWoundestAllyInRange(player p, real x, real y, real range) -> unit
// GetWoundestAllyInRangeOfUnit(unit u, real range) -> unit
// GetWoundestAllyHeroInRange(player p, real x, real y, real range) -> unit
// GetWoundestAllyHeroInRangeOfUnit(unit u, real range) -> unit
// GetWoundestEnemyInRange(player p, real x, real y, real range) -> unit
// GetWoundestEnemyInRangeOfUnit(unit u,, real range) -> unit
// GetWoundestEnemyHeroInRange(player p, real x, real y, real range) -> unit
// GetWoundestEnemyHeroInRangeOfUnit(unit u, real range) -> unit
// GetWoundestUnitOfGroup(group g) -> unit
// GroupKeepHeroes(group g) -> nothing
// GroupRemoveHeroes(group g) -> nothing
// GroupRemoveStructures(group g) -> nothing
// GroupRemoveUnitsAtXY(group g, real x, real y) -> nothing
// GroupRemoveUnitsInRangeOfXY(group g, real x, real y, real range) -> nothing
// GroupRemoveUnitsOfPlayer(group g, player p) -> nothing
// GroupRemoveUnitsOfType(group g, integer id) -> nothing
// IsUnitAlive(unit u) -> boolean
// IsUnitDead(unit u) -> boolean
// IsUnitUnderPercentLife(unit u, real percent) -> boolean
// IsUnitUnderPercentMana(unit u, real percent) -> boolean

// * * * * * * * * * *
// * Conditions (needs Unit)
// * * * * * * * * * *
// IsComputer() -> boolean
// IsHero() -> boolean
// IsHuman() -> boolean
// IsNearbyAlly(player p, real x, real y, real range) -> boolean
// IsNearbyAllyOfUnit(unit u, real range) -> boolean
// IsNearbyAllyHero(player p, real x, real y, real range) -> boolean
// IsNearbyAllyHeroOfUnit(unit u, real range) -> boolean
// IsNearbyEnemy(player p, real x, real y, real range) -> boolean
// IsNearbyEnemyOfUnit(unit u, real range) -> boolean
// IsNearbyEnemyHero(player p, real x, real y, real range) -> boolean
// IsNearbyEnemyHeroOfUnit(unit u, real range) -> boolean
// IsNearbyHero(real x, real y, real range) -> boolean
// IsNearbyHeroOfUnit(unit u, real range) -> boolean
// IsNearbyUnit(real x, real y, real range) -> boolean
// IsNearbyUnitOfUnit(unit u, real range) -> boolean
// IsPlayed() -> boolean
// IsSlotComputer(player p) -> boolean
// IsSlotHuman(player p) -> boolean
// IsSlotPlayed(player p) -> boolean
// IsTriggerUnitHero() -> boolean
// IsUnitBehindTarget(unit caster, unit target) -> boolean
// IsUnitHero(unit u) -> boolean
// UnitHasEmptySlot(unit u) -> boolean
// UnitHasItemOfClass(unit u, itemtype itype) -> boolean
// UnitHasItemOfType(unit u, integer itemid) -> boolean

// * * * * * * * * * *
// * Timed (needs RecycleTimers, Utilities, Unit)
// * * * * * * * * * *
// AddAbilityTimed(unit u, real dur, integer abilid) -> nothing
// AddUnitUserDataTimed(unit u, integer i, real dur) -> nothing
// ChangeHeightOverTime(unit u, real dur, real height) -> nothing
// CreateDestructableTimed(integer destructid, real x, real y, real dur) -> nothing
// CreateEffectTimed(unit u, string path, string attach, real dur) -> nothing
// CreateEffectXYTimed(real x, real y, string path, real dur) -> nothing
// CreateLightningBetweenUnitsTimed(unit caster, unit target, string codeName, real dur) -> lightning
// DamageOverTime(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype) -> void
// DamageOverTimeMatchingBuff(unit caster, unit target, real tickdmg, real tickinterval, integer tickcount, integer dmgtype, integer buffid) -> void
// ExecuteFuncTimed(string s, real dur) -> nothing
// NoPathingTimed(unit u, real dur) -> nothing
// SlideUnit(unit u, real dist, real angle, real duration, boolean linear, boolean takeCareOfMoveSpeed) -> nothing
// UnitSetTimedLife(unit u, real time -> nothing

// * * * * * * * * * *
// * Trigger (needs RecycleTimers)
// * * * * * * * * * *
// StopWhenChannelEnd(unit u, timer t, boolexpr filter) -> nothing
// TriggerRegisterAnyUnitDamaged(trigger trig) -> nothing

// * * * * * * * * * *
// * AIGroup
// * * * * * * * * * *
// AIGroup <name> = AIGroup.create()
// <name>.add(unit u)
// <name>.delete() & <name>.destroy()

// * * * * * * * * * *
// * AIPatrol
// * * * * * * * * * *
// AIPatrol <name> = AIPatrol.create(unit u, real x1, real y1, real x2, real y2)
// <name>.add(real x, real y)

//      Functions
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Constants.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Hashtable.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\RecycleTimers.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\RecycleGroups.j"
// import "X:\home\olivier\Documents\Developpement\Jass\Framework\RecycleUnits.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Maths.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Conditions.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Utilities.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Timed.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Unit.j"
//      Systems
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Trigger.j"
// import "X:\home\olivier\Documents\Developpement\Jass\Framework\AIGroup.j"
// import "X:\home\olivier\Documents\Developpement\Jass\Framework\AIPatrol.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Systems\Buffs.j"
//! import "X:\home\olivier\Documents\Developpement\Jass\Framework\Systems\Ticker.j"
