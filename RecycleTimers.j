// You have to define this constants :
// constant integer TimerMax = <Number of timers you want>

library RecycleTimers needs Hashtable initializer init
	integer TimerCount
	integer TimerMin
	timer array TimerPool
	
	function NewTimer takes nothing returns timer
		if TimerCount <= 0 then
			call BJDebugMsg("|cFFF00000Warning: Timer pool empty. Creating a new one.")
			set TimerPool[0] = CreateTimer()
		else
			set TimerCount = TimerCount - 1
			if TimerCount <= TimerMax / 20 then
				call BJDebugMsg("|cFFF00000Warning: Timer pool nearly empty.")
			endif
			if TimerPool[TimerCount] == null then
				call BJDebugMsg("|cFFF00000Warning: Null timer found. Creating a new one instead.")
				set TimerPool[TimerCount] = CreateTimer()
			endif
		endif
		if TimerCount < TimerMin then
			set TimerMin = TimerCount
		endif
		return CleanTimer(TimerPool[TimerCount])
	endfunction
	
	function DeleteTimer takes timer t returns nothing
		if t != null then
			call CleanTimer(t)
			if TimerCount < MaxTimer then
				set TimerPool[TimerCount] = t
				set TimerCount = TimerCount + 1
			else
				call BJDebugMsg("|cFFF00000Warning: Timer pool is full. Destroying the timer.")
				call DestroyTimer(t)
			endif
		endif
	endfunction
	
	function CleanTimer takes timer t returns nothing
		if t != null then
			call PauseTimer(t)
			call HTFlushChildHashtable(t)
		endfunction
		return t
	endfunction
	
	function DisplayTimer takes nothing returns nothing
		call BJDebugMsg("Compteurs utilisés : " + I2S(MaxTimer - TimerMin) + " / " + I2S(MaxTimer))
	endfunction
	
	private function init takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen i >= MaxTimer
			set TimerPool[i] = CreateTimer()
			set i = i + 1
		endloop
		set TimerCount = MaxTimer
		set TimerMin = MaxTimer
	endfunction
endlibrary
