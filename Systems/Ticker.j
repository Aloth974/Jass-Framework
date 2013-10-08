//
//	HOW TO USE
//
// Instanciate your ticker : local tick = Tick.create(real interval, integer iteration, code callback, boolean startNow)
//	> interval in how often your callback will be called
//	> iteration is how many times your callback will be called
//	> callback is the argumentless function which will be called at every tick
//	> startNow define if Ticks begins juste after instanciation or will start when you will order it
//
// DO NOT USE ATTRIBUTES
//
// Methods are :
//	- tick.start() : start your tick, calling "callback" at every "interval" for "iteration" many times
//	- tick.stop() : stop your ticker
//	- tick.isExpired() : returns true or false, depending if the ticker is still ticking
//	- local handle t = tick.getHandle() : returns handle associated to this ticker, allowing to attach data to it
//	- tick.getRemaining() : return the number of remaining ticks
//	- tick.getCurrent() : return the current tick
//	- tick.reset() : reset the duration of the ticker
//	- tick.setPeriodFactor() : set a period factor. Setting 0,5 will make ticks spawn in half the time they were intended
//	- tick.getPeriodFactor() : retrieve the period factor
//	- tick.resetPeriodFactor() : reset the period factor to the default value 1
//
// Functions are :
//	- local Tick tick = GetTicker() : returns the expiring ticker in the callback method

// Issues : using tick.left = x cause inconsistent data with tick.last

library Ticker initializer init needs Hashtable, Constants

	globals
		// Maximum TickPerSecond is 8192, timers can't ticks more often than this value
		constant integer TickPerSecond = 512
		private Tick array Ticks
		private integer count
		private integer tick
	endglobals

	private function GetNextTick takes real period returns integer
		return tick + R2I(period * I2R(TickPerSecond))
	endfunction

	function GetTicker takes nothing returns Tick
		return Ticks[HTLoadInteger(GetTriggeringTrigger(), TICKER_INDEX)]
	endfunction
	
	function GetTickerByTrigger takes trigger trig returns Tick
		return Ticks[HTLoadInteger(trig, TICKER_INDEX)]
	endfunction

	struct Tick
		// Cannot be changed
		private trigger trig
		private triggeraction action
		private real period
		
		boolean infinite
		integer last
		integer next
		integer done
		integer left
		real periodFactor

		// public
		method getTrigger takes nothing returns trigger
			return .trig
		endmethod
		method getHandle takes nothing returns handle
			return .trig
		endmethod

		// Remaining ticks
		method getRemaining takes nothing returns integer
			return .left
		endmethod
		
		// Current tick
		method getCurrent takes nothing returns integer
			return .done
		endmethod
		
		method reset takes nothing returns nothing
			set .left = .left + .done
			set .done = 0
		endmethod

		// Last tick
		method setLast takes integer i returns nothing
			call .setLastTick(i)
		endmethod
		method setLastTick takes integer i returns nothing
			set .last = i
		endmethod
		method getLastTick takes nothing returns integer
			return .last
		endmethod
		
		// Infinite
		method setInfinite takes boolean b returns nothing
			set .infinite = b
		endmethod
		method isInfinite takes nothing returns boolean
			return .infinite
		endmethod
		
		// Period factors
		method setPeriodFactor takes real factor returns nothing
			set .periodFactor = factor
		endmethod
		method getPeriodFactor takes nothing returns real
			return .periodFactor
		endmethod
		method resetPeriodFactor takes nothing returns nothing
			call .setPeriodFactor(1.)
		endmethod

		method isExpired takes nothing returns boolean
			return .left <= .last
		endmethod
		method isStarted takes nothing returns boolean
			return .next > 0
		endmethod

		method start takes nothing returns nothing
			if .next < 0 then
				call .nextTick()
			endif
		endmethod

		method stop takes nothing returns nothing
			set .left = .last
		endmethod

		// private
		method getIndex takes nothing returns integer
			return HTLoadInteger(.trig, TICKER_INDEX)
		endmethod
		method setIndex takes integer i returns nothing
			call HTSaveInteger(.trig, TICKER_INDEX, i)
		endmethod
		method nextTick takes nothing returns nothing
			set .next = GetNextTick(.period * .periodFactor)
		endmethod

		static method create takes real period, integer ticks, code func, boolean autostart returns Tick
			local Tick this = Tick.allocate()
			set .trig = CreateTrigger()
			set .action = TriggerAddAction(.trig, func)
			set .period = period
			set .infinite = false

			set .last = 0
			set .next = -1
			set .done = 0
			set .left = ticks
			set .periodFactor = 1.

			call .setIndex(count)
			set Ticks[count] = this
			set count = count + 1
			set Ticks[count] = 0
			if autostart then
				call .start()
			endif
			return this
		endmethod

		method exec takes nothing returns nothing
			call TriggerExecute(.trig)
		endmethod

		method delete takes nothing returns nothing
			call HTFlushChildHashtable(.trig)
			call TriggerRemoveAction(.trig, .action)
			call DestroyTrigger(.trig)
			call .destroy()
		endmethod
	endstruct

	private function TickerActions takes nothing returns nothing
		local integer i = 0
		set tick = tick + 1
		
		loop
			exitwhen i >= count
			if Ticks[i] > 0 then
				if Ticks[i].next > -1 then
					if Ticks[i].next <= tick then
						set Ticks[i].left = Ticks[i].left - 1
						set Ticks[i].done = Ticks[i].done + 1
						
						if Ticks[i].left < Ticks[i].last and not Ticks[i].isInfinite() then
							call Ticks[i].delete()

							set count = count - 1
							if i < count then
								set Ticks[i] = Ticks[count]
								call Ticks[i].setIndex(i)
								set Ticks[count] = 0
							endif
						else
							call Ticks[i].exec()
							if Ticks[i].isExpired() and not Ticks[i].isInfinite() then
								set Ticks[i].next = tick + 1
							else
								call Ticks[i].nextTick()
							endif
						endif
					endif
				endif
			endif
			set i = i + 1
		endloop
	endfunction

	private function init takes nothing returns nothing
		set count = 0
		set tick = 0
		set Ticks[count] = 0
		call TimerStart(CreateTimer(), 1. / I2R(TickPerSecond), true, function TickerActions)
	endfunction
endlibrary
