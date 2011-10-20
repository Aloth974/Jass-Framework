library Hashtable initializer init
	globals
		hashtable HashTable
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
