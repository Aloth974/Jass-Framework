// You have to define this constants :
// constant integer GroupMax = <Number of groups you want>

library RecycleGroups needs Hashtable initializer init
	integer GroupCount
	integer GroupMin
	group array GroupPool
	
	function NewGroup takes nothing returns group
		if GroupCount <= 0 then
			call BJDebugMsg("|cFFF00000Warning: Group pool empty. Creating a new one.")
			set GroupPool[0] = CreateGroup()
		else
			set GroupCount = GroupCount - 1
			if GroupCount <= GroupMax / 20 then
				call BJDebugMsg("|cFFF00000Warning: Group pool nearly empty.")
			endif
			if GroupPool[GroupCount] == null then
				call BJDebugMsg("|cFFF00000Warning: Null Group found. Creating a new one instead.")
				set GroupPool[GroupCount] = CreateGroup()
			endif
		endif
		if GroupCount < GroupMin then
			set GroupMin = GroupCount
		endif
		return CleanGroup(GroupPool[GroupCount])
	endfunction
		
	function DeleteGroup takes group g returns nothing
		if g != null then
			call CleanGroup(g)
			if GroupCount < MaxGroup then
				set GroupPool[GroupCount] = g
				set GroupCount = GroupCount + 1
			else
				call BJDebugMsg("|cFFF00000Warning: Group pool is full. Destroying the Group.")
				call DestroyGroup(t)
			endif
		endif
	endfunction
    
	function CleanGroup takes group g returns nothing
		if g != null then
			call GroupClear(GroupPool[GroupCount])
			call HTFlushChildHashtable(g)
		endfunction
		return g
	endfunction
	
	function DisplayGroup takes nothing returns nothing
		call BJDebugMsg("Groupes utilisés : " + I2S(MaxGroup - GroupMin) + " / " + I2S(MaxGroup))
	endfunction
	
	private function init takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen i >= MaxGroup
			set GroupPool[i] = CreateGroup()
			set i = i + 1
		endloop
		set GroupCount = MaxGroup
		set GroupMin = MaxGroup
	endfunction
endlibrary
