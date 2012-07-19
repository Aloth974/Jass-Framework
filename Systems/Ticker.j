library Ticker initializer init needs Hashtable, Constants
	globals
		// Maximum TickPerSecond is 8192, timers can't ticks more often than this value
		constant integer TickPerSecond = 32
		private trigger array TickerTrigger
		private integer array TickerTickNext
		private integer array TickerTickLeft
		private real array TickerTickPeriod
		private integer count
		private integer tick
		private boolean lock
	endglobals

	function SetTickerPeriod takes integer index, real newPeriod returns boolean
		if newPeriod <= -1. then
			return false
		endif
		set TickerTickPeriod[index] = newPeriod
		return true
	endfunction
	
	function GetTickerIndex takes nothing returns integer
		return HTLoadInteger(GetTriggeringTrigger(), TICKER_INDEX)
	endfunction
	
	function AddTickerTick takes integer index, integer count returns nothing
		set TickerTickLeft[index] = TickerTickLeft[index] + count
	endfunction
	
	function GetTickerTickLeft takes integer index returns integer
		return TickerTickLeft[index]
	endfunction
	
	function GetTickerPeriod takes integer index returns real
		return TickerTickPeriod[index]
	endfunction
	
	function GetTickerDataHandler takes integer index returns handle
		return TickerTrigger[index]
	endfunction
	
	private function GetNextTick takes real period returns integer
		return tick + R2I(period * I2R(TickPerSecond))
	endfunction
	
	function StopTicker takes integer index returns nothing
		set TickerTickLeft[index] = 0
		set TickerTickNext[index] = tick + 1
	endfunction

	function Ticker takes real period, integer ticks, code func returns integer
		local integer index = count

		if period <= 0. then
			return -1
		endif
		
		if count + 1 > 8191 then
			call BJDebugMsg("|cFFF00000Error: Ticker pool full. Aborting.")
			return -1
		endif
		
		set TickerTrigger[count] = CreateTrigger()
		set TickerTickLeft[count] = ticks
		set TickerTickPeriod[count] = period
		set TickerTickNext[count] = -1
		call HTSaveInteger(TickerTrigger[count], TICKER_INDEX, count)
		call HTSaveTriggerActionHandle(TickerTrigger[count], TICKER_ACTION, TriggerAddAction(TickerTrigger[count], func))
		
		set count = count + 1
		return index
	endfunction
	
	function TickerStart takes integer index returns nothing
		set TickerTickNext[index] = GetNextTick(TickerTickPeriod[index])
	endfunction

	private function TickerActions takes nothing returns nothing
		local integer i = 0
		set tick = tick + 1
		
		loop
			exitwhen i >= count

			if TickerTickNext[i] > -1 then
				if TickerTickNext[i] <= tick then
					set TickerTickLeft[i] = TickerTickLeft[i] - 1
					
					if TickerTickLeft[i] < 0 then
						call TriggerRemoveAction(TickerTrigger[i], HTLoadTriggerActionHandle(TickerTrigger[i], TICKER_ACTION))
						call HTFlushChildHashtable(TickerTrigger[i])
						call DestroyTrigger(TickerTrigger[i])

						set count = count - 1
						if i < count then
							set TickerTrigger[i] = TickerTrigger[count]
							set TickerTickNext[i] = TickerTickNext[count]
							set TickerTickLeft[i] = TickerTickLeft[count]
							set TickerTickPeriod[i] = TickerTickPeriod[count]
							call HTSaveInteger(TickerTrigger[count], TICKER_INDEX, i)
						endif

						set i = i - 1

						set TickerTrigger[count] = null
						set TickerTickNext[count] = -1
						set TickerTickLeft[count] = -1
						set TickerTickPeriod[count] = 0.
					else
						set TickerTickNext[i] = GetNextTick(TickerTickPeriod[i])
						call TriggerExecute(TickerTrigger[i])
					endif
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
