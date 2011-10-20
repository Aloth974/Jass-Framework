// Okay it works ... but you cannot pass any data to your tick function ...

library Ticker initializer init
	globals
		// Maximum TickPerSecond is 8192, timers can't ticks more often than this value
		constant integer TickPerSecond = 32
		//private handle array TickerDataBindHandle
		private string array TickerExecute
		private integer array TickerTickNext
		private integer array TickerTickLeft
		private real array TickerTickPeriod
		private integer count
		private integer tick
	endglobals
	
	constant function GetNextTick takes real period returns integer
		return tick + I2R(period * R2I(TickPerSecond))
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
				call ExecuteFunc(TickerExecute[i])
			endif
			set i = i + 1
		endloop
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
		set count = count - 1
	endfunction
	
	function Ticker takes real period, integer ticks, string funcname returns integer
		set TickerExecute[count] = funcname
		set TickerTickNext[count] = GetNextTick(period)
		set TickerTickLeft[count] = ticks
		set TickerTickPeriod[count] = period
		set count = count + 1
		return count - 1
	endfunction
	
	private function init takes nothing returns nothing
		set count = 0
		set tick = 0
		call TimerStart(CreateTimer(), 1. / I2R(TickPerSecond), true, TickerActions)
	endfunction
endlibrary
