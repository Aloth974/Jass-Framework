library Hashtable initializer init
    globals
        hashtable HashTable
        constant integer BOOLEAN = 0
        constant integer INTEGER = 1
        constant integer REAL = 2
        constant integer STRING = 3
        constant integer HANDLE = 4
        constant integer WIDGET = 5
        constant integer ITEM = 6
        constant integer UNIT = 7
        constant integer GROUP = 8
        constant integer PLAYER = 9
        constant integer FORCE = 10
        constant integer EFFECT = 11
        constant integer DESTRUCTABLE = 12
        constant integer LOCATION = 13
        constant integer TIMER = 14
        constant integer TRIGGER = 15
        constant integer TRIGGERACTION = 16
        constant integer TRIGGERCONDITION = 17
        constant integer EVENT = 18
        constant integer TEXTTAG = 19
        constant integer LIGHTNING = 20
        constant integer HASHTABLE = 21
        constant integer ABILITY = 22
        constant integer DIALOG = 23
        constant integer BUTTON = 24
        constant integer INDEX = 27
        constant integer INTEGER1 = 28
        constant integer INTEGER2 = 29
        constant integer INTEGER3 = 30
        constant integer INTERVAL = 31
        constant integer REAL1 = 32
        constant integer REAL2 = 33
        constant integer REAL3 = 34
        constant integer CASTER = 37
        constant integer TARGET = 38
        constant integer DUMMY = 39-60
        constant integer GROUP1 = 70
        constant integer GROUP2 = 71
        constant integer GROUP3 = 72
        constant integer BUTTON1 = 80
        constant integer BUTTON2 = 81
        constant integer BUTTON3 = 82
        constant integer BUTTON4 = 83
        constant integer BUTTON5 = 84
        constant integer DAMAGE_EVENT = 190
        constant integer ENDCHANNEL = 195
        constant integer ENDCHANNELSTOP = 196
        constant integer INCUBATION = 250
        constant integer AIGROUP = 295
        constant integer AIPATROL = 299
        constant integer AIPATROLCURRENT = 300
        constant integer AIPATROLHASH = 301 // use 301-350 range
    endglobals
//! textmacro HTBase takes TYPE, CASETYPE
    function HTSave$CASETYPE$ takes handle parent, integer child, $TYPE$ data returns nothing
        call Save$CASETYPE$(HashTable, GetHandleId(parent), child, data)
    endfunction
    function HTLoad$CASETYPE$ takes handle parent, integer child returns $TYPE$
        return Load$CASETYPE$(HashTable, GetHandleId(parent), child)
    endfunction
    function HTRemoveSaved$CASETYPE$ takes handle parent, integer child returns nothing
        call RemoveSaved$CASETYPE$(HashTable, GetHandleId(parent), child)
    endfunction
    function HTHaveSaved$CASETYPE$ takes handle parent, integer child returns boolean
        return HaveSaved$CASETYPE$(HashTable, GetHandleId(parent), child)
    endfunction
//! endtextmacro
//! textmacro HTHandle takes TYPE, CASETYPE
    function HTSave$CASETYPE$Handle takes handle parent, integer child, $TYPE$ data returns nothing
        call Save$CASETYPE$Handle(HashTable, GetHandleId(parent), child, data)
    endfunction
    function HTLoad$CASETYPE$Handle takes handle parent, integer child returns $TYPE$
        return Load$CASETYPE$Handle(HashTable, GetHandleId(parent), child)
    endfunction
//! endtextmacro
//! runtextmacro HTBase("integer", "Integer")
//! runtextmacro HTBase("real", "Real")
//! runtextmacro HTBase("boolean", "Boolean")
//! runtextmacro HTHandle("player", "Player")
//! runtextmacro HTHandle("widget", "Widget")
//! runtextmacro HTHandle("destructable", "Destructable")
//! runtextmacro HTHandle("item", "Item")
//! runtextmacro HTHandle("unit", "Unit")
//! runtextmacro HTHandle("ability", "Ability")
//! runtextmacro HTHandle("timer", "Timer")
//! runtextmacro HTHandle("trigger", "Trigger")
//! runtextmacro HTHandle("triggercondition", "TriggerCondition")
//! runtextmacro HTHandle("triggeraction", "TriggerAction")
//! runtextmacro HTHandle("event", "TriggerEvent")
//! runtextmacro HTHandle("force", "Force")
//! runtextmacro HTHandle("group", "Group")
//! runtextmacro HTHandle("location", "Location")
//! runtextmacro HTHandle("rect", "Rect")
//! runtextmacro HTHandle("boolexpr", "BooleanExpr")
//! runtextmacro HTHandle("sound", "Sound")
//! runtextmacro HTHandle("effect", "Effect")
//! runtextmacro HTHandle("unitpool", "UnitPool")
//! runtextmacro HTHandle("itempool", "ItemPool")
//! runtextmacro HTHandle("quest", "Quest")
//! runtextmacro HTHandle("questitem", "QuestItem")
//! runtextmacro HTHandle("defeatcondition", "DefeatCondition")
//! runtextmacro HTHandle("timerdialog", "TimerDialog")
//! runtextmacro HTHandle("leaderboard", "Leaderboard")
//! runtextmacro HTHandle("multiboard", "Multiboard")
//! runtextmacro HTHandle("multiboarditem", "MultiboardItem")
//! runtextmacro HTHandle("trackable", "Trackable")
//! runtextmacro HTHandle("dialog", "Dialog")
//! runtextmacro HTHandle("button", "Button")
//! runtextmacro HTHandle("texttag", "TextTag")
//! runtextmacro HTHandle("lightning", "Lightning")
//! runtextmacro HTHandle("image", "Image")
//! runtextmacro HTHandle("ubersplat", "Ubersplat")
//! runtextmacro HTHandle("region", "Region")
//! runtextmacro HTHandle("fogstate", "FogState")
//! runtextmacro HTHandle("fogmodifier", "FogModifier")
//! runtextmacro HTHandle("hashtable", "Hashtable")
    function HTSaveAgentHandle takes handle parent, integer child, agent data returns nothing
        call SaveAgentHandle(HashTable, GetHandleId(parent), child, data)
    endfunction
    function HTSaveStr takes handle parent, integer child, string data returns nothing
        call SaveStr(HashTable, GetHandleId(parent), child, data)
    endfunction
    function HTLoadStr takes handle parent, integer child returns string
        return LoadStr(HashTable, GetHandleId(parent), child)
    endfunction
    function HTRemoveSavedString takes handle parent, integer child returns nothing
        call RemoveSavedString(HashTable, GetHandleId(parent), child)
    endfunction
    function HTHaveSavedString takes handle parent, integer child returns boolean
        return HaveSavedString(HashTable, GetHandleId(parent), child)
    endfunction
    function HTRemoveSavedHandle takes handle parent, integer child returns nothing
        call RemoveSavedHandle(HashTable, GetHandleId(parent), child)
    endfunction
    function HTHaveSavedHandle takes handle parent, integer child returns boolean
        return HaveSavedHandle(HashTable, GetHandleId(parent), child)
    endfunction
    function HTFlushChildHashtable takes handle parent returns nothing
        call FlushChildHashtable(HashTable, GetHandleId(parent))
    endfunction
    function HTFlushParentHashtable takes nothing returns nothing // Should not be used
        call FlushParentHashtable(HashTable)
    endfunction
    private function init takes nothing returns nothing
        set HashTable = InitHashtable()
    endfunction
endlibrary
