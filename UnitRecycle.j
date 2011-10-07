library UnitRecycle initializer init
	struct UnitRecyclePool
		private integer max
		private integer count
		private integer unitid
		private unit array pool
		
		method NewUnit takes player p, real x, real y returns unit
			if(.count <= 0) then
				set .pool[0] = CreateUnit()
			else
				set .count = .count - 1
				if(.count <= .max / 20) then
					// warning
				endif
				if(.pool[.count] == null) then
					// error
					set .pool[.count] = CreateUnit()
				endif
			endif
			// Change owner of unit to p and move it to x and y
			return .pool[.count]
		endmethod
		
		method CastAndDelete takes integer abilid, unit u returns nothing
			// Add abilid, start a timer
		endmethod
		method CastAndDeleteEnd takes nothing returns nothing
			// Remove abilid and delete unit properly
		endmethod
		
		method DeleteUnit takes unit u returns nothing
			// Reset owner of unit to neutral and move it to center of map
			set .pool[.count] = u
			set .count = .count + 1
		endmethod
		
		static method create takes integer unitid, integer max returns UnitRecyclePool
			local UnitRecyclePool p = UnitRecyclePool.allocate()
			local integer i = 1
			set p.unitid = unitid
			set p.max = max
			set p.count = max
			loop
				exitwhen i >= p.max
				set p.pool[i] = CreateUnit()
				set i = i + 1
			endloop
			return p
		endmethod
	endstruct
endlibrary

globals
	UnitRecyclePool DummyPool = UnitRecyclePool.create()
endglobals

function DummyCastSpell takes integer abilid returns nothing
	DummyPool.CastAndDelete(abilid, DummyPool.NewUnit())
endfunction
