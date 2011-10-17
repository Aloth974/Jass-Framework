library Ticker initializer init
	globals
		// Maximum TickPerSecond is 8192, timers can't ticks more often than this value
		constant integer TickPerSecond = 64
		constant real TickerPeriod = 1. / I2R(TickPerSecond)
	endglobals
	
	struct Ticker
		private real duration
		private real interval
		private method create takes real duration, real interval returns thistype
			local thistype this = thistype.allocate()
			set this.duration = duration
			set this.interval = interval
			return this
		endmethod
	endstruct
	
	private function TickerActions takes nothing returns nothing
	endfunction
	
	private function init takes nothing returns nothing
		call TimerStart(CreateTimer(), TickerPeriod, true, TickerActions)
	endfunction
endlibrary

module T32xs
        private thistype next
        private thistype prev
        private boolean runningPeriodic
        
        private static method PeriodicLoop takes nothing returns boolean
            local thistype this=thistype(0).next
            loop
                exitwhen this==0
                call this.periodic()
                set this=this.next
            endloop
            return false
        endmethod

        method startPeriodic takes nothing returns nothing
            if not this.runningPeriodic then
                set thistype(0).next.prev=this
                set this.next=thistype(0).next
                set thistype(0).next=this
                set this.prev=thistype(0)
                
                set this.runningPeriodic=true
            endif
        endmethod
        
        method stopPeriodic takes nothing returns nothing
            if this.runningPeriodic then
                // This is some real magic.
                set this.prev.next=this.next
                set this.next.prev=this.prev
                // This will even work for the starting element.
                
                set this.runningPeriodic=false
            endif
        endmethod
        
        private static method onInit takes nothing returns nothing
            call TriggerAddCondition(Trig,Condition(function thistype.PeriodicLoop))
        endmethod
    endmodule
    
    
    
    
    
    
    
    
    
    
    
    scope test initializer dotest
    private struct teststruct
        private integer endTick
        private method periodic takes nothing returns nothing
            call BJDebugMsg(I2S(this))
            
            if this.endTick == T32_Tick then // no more this.ticksLeft stuff and incrementing.
                call this.stopPeriodic() // never follow with a .startPeriodic() call
                call this.destroy()      // of any sort (when in the .periodic method).
            endif
        endmethod
        implement T32x
        static method create takes real duration returns thistype
            local thistype this = thistype.allocate()
            set this.endTick = T32_Tick + R2I(duration / T32_PERIOD)
            return this
        endmethod
    endstruct
    private function dotest takes nothing returns nothing
        // Creates structs which display their integer id 32 times a second for x seconds.
        call teststruct.create(3.0).startPeriodic()
        call teststruct.create(5.0).startPeriodic()
    endfunction
endscope



library T32 initializer OnInit
    globals
        public constant real PERIOD=0.03125
        public constant integer FPS=R2I(1/PERIOD)
        public integer Tick=0 // very useful.
        
//==============================================================================
        private trigger Trig=CreateTrigger()
    endglobals
    
    //==============================================================================
    // The standard T32 module, T32x.
    //
    module T32x
        private thistype next
        private thistype prev
        
        private static method PeriodicLoop takes nothing returns boolean
            local thistype this=thistype(0).next
            loop
                exitwhen this==0
                call this.periodic()
                set this=this.next
            endloop
            return false
        endmethod

        method startPeriodic takes nothing returns nothing
            debug if this.prev!=0 or thistype(0).next==this then
            debug   call BJDebugMsg("T32 ERROR: Struct #"+I2S(this)+" had startPeriodic called while already running!")
            debug endif
            set thistype(0).next.prev=this
            set this.next=thistype(0).next
            set thistype(0).next=this
            set this.prev=thistype(0)
        endmethod
        
        method stopPeriodic takes nothing returns nothing
            debug if this.prev==0 and thistype(0).next!=this then
            debug   call BJDebugMsg("T32 ERROR: Struct #"+I2S(this)+" had stopPeriodic called while not running!")
            debug endif
            // This is some real magic.
            set this.prev.next=this.next
            set this.next.prev=this.prev
            // This will even work for the starting element.
            debug set this.prev=0
        endmethod
        
        private static method onInit takes nothing returns nothing
            call TriggerAddCondition(Trig,Condition(function thistype.PeriodicLoop))
        endmethod
    endmodule
    
    //==============================================================================
    // The standard T32 module with added safety checks on .startPeriodic() and
    // .stopPeriodic(), T32xs.
    //
    module T32xs
        private thistype next
        private thistype prev
        private boolean runningPeriodic
        
        private static method PeriodicLoop takes nothing returns boolean
            local thistype this=thistype(0).next
            loop
                exitwhen this==0
                call this.periodic()
                set this=this.next
            endloop
            return false
        endmethod

        method startPeriodic takes nothing returns nothing
            if not this.runningPeriodic then
                set thistype(0).next.prev=this
                set this.next=thistype(0).next
                set thistype(0).next=this
                set this.prev=thistype(0)
                
                set this.runningPeriodic=true
            endif
        endmethod
        
        method stopPeriodic takes nothing returns nothing
            if this.runningPeriodic then
                // This is some real magic.
                set this.prev.next=this.next
                set this.next.prev=this.prev
                // This will even work for the starting element.
                
                set this.runningPeriodic=false
            endif
        endmethod
        
        private static method onInit takes nothing returns nothing
            call TriggerAddCondition(Trig,Condition(function thistype.PeriodicLoop))
        endmethod
    endmodule
    
    //==============================================================================
    // The original T32 module, for backwards compatability only.
    //
    module T32 // deprecated.
        private thistype next
        private thistype prev
        
        private static method PeriodicLoop takes nothing returns boolean
            local thistype this=thistype(0).next
            loop
                exitwhen this==0
                if this.periodic() then
                    // This is some real magic.
                    set this.prev.next=this.next
                    set this.next.prev=this.prev
                    // This will even work for the starting element.
                    debug set this.prev=0
                endif
                set this=this.next
            endloop
            return false
        endmethod

        method startPeriodic takes nothing returns nothing
            debug if this.prev!=0 or thistype(0).next==this then
            debug   call BJDebugMsg("T32 ERROR: Struct #"+I2S(this)+" had startPeriodic called while already running!")
            debug endif
            set thistype(0).next.prev=this
            set this.next=thistype(0).next
            set thistype(0).next=this
            set this.prev=thistype(0)
        endmethod
        
        private static method onInit takes nothing returns nothing
            call TriggerAddCondition(Trig,Condition(function thistype.PeriodicLoop))
        endmethod
    endmodule
    
    //==============================================================================
    // System Core.
    //
    private function OnExpire takes nothing returns nothing
        set Tick=Tick+1
        call TriggerEvaluate(Trig)
    endfunction
    
    private function OnInit takes nothing returns nothing
        call TimerStart(CreateTimer(),PERIOD,true,function OnExpire)
    endfunction
endlibrary
