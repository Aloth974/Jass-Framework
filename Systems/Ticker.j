// Okay it works ... but you cannot pass any data to your tick function ...

library Ticker initializer init
	globals
		// Maximum TickPerSecond is 8192, timers can't ticks more often than this value
		constant integer TickPerSecond = 32
		private handle array TickerDataHandler
		private string array TickerExecute
		private integer array TickerTickNext
		private integer array TickerTickLeft
		private real array TickerTickPeriod
		private integer count
		private integer tick
		private integer last_index
	endglobals
	
	function SetTickerPeriod takes integer index, real newPeriod returns boolean
		if newPeriod <= -1. then
			return false
		endif
		set TickerTickPeriod[index] = newPeriod
		return true
	endfunction
	
	function GetTickerIndex takes nothing returns integer
		return last_index
	endfunction
	
	function AddTickerTick takes integer index, integer count returns nothing
		set TickerTickLeft[index] = TickerTickLeft[index] + count
	endfunction
	
	function GetTickerTickLeft takes integer index returns integer
		return TickerTickLeft[index]
	endfunction
	
	function GetTickerTimeLeft takes integer index returns real
		return I2R(TickerTickLeft[index]) * TickerTickPeriod[index]
	endfunction
	
	function GetTickerDataHandler takes integer index returns handle
		return TickerDataHandler[index]
	endfunction
	
	private function GetNextTick takes real period returns integer
		return tick + R2I(period * I2R(TickPerSecond))
	endfunction
	
	function EndTicker takes integer number returns nothing
		set TickerExecute[number] = TickerExecute[count]
		set TickerTickNext[number] = TickerTickNext[count]
		set TickerTickLeft[number] = TickerTickLeft[count]
		set TickerTickPeriod[number] = TickerTickPeriod[count]
		set TickerExecute[count] = null
		set TickerTickNext[count] = -1
		set TickerTickLeft[count] = -1
		set TickerTickPeriod[count] = 0.
		call HTFlushChildHashtable(TickerDataHandler[count])
		set count = count - 1
	endfunction
	
	function Ticker takes real period, integer ticks, string funcname returns integer
		if period <= 0. then
			return -1
		endif
		
		if count + 1 > 8191 then
			call BJDebugMsg("|cFFF00000Error: Ticker pool full. Aborting.")
			return -1
		endif
		
		set TickerExecute[count] = funcname
		set TickerTickNext[count] = GetNextTick(period)
		set TickerTickLeft[count] = ticks
		set TickerTickPeriod[count] = period
		
		if TickerDataHandler[count] == null then
			set TickerDataHandler[count] = Location(0., 0.)
		endif
		
		set count = count + 1
		return count - 1
	endfunction

	private function TickerActions takes nothing returns nothing
		local integer i = 0
		set tick = tick + 1
		
		loop
			exitwhen i >= count
			if TickerTickNext[i] <= tick then
				if TickerTickLeft[i] <= 1 then
					call EndTicker(i)
				else
					set TickerTickLeft[i] = TickerTickLeft[i] - 1
					set TickerTickNext[i] = GetNextTick(TickerTickPeriod[i])
				endif

				if TickerExecute[i] != null then
					set last_index = i
					call ExecuteFunc(TickerExecute[i])
				endif
			endif
			set i = i + 1
		endloop
	endfunction
	
	private function init takes nothing returns nothing
		set count = 0
		set tick = 0
		call TimerStart(CreateTimer(), 1. / I2R(TickPerSecond), true, function TickerActions)
	endfunction
endlibrary
