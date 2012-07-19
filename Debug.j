library Debug initializer init needs Constants
	globals
		boolean Debug
	endglobals

	function ADebugOff takes nothing returns nothing
		set Debug = false
		call BJDebugMsg("You can reactivate debugging thanks to command 'debug on'.")
	endfunction

	function ADebugOn takes nothing returns nothing
		set Debug = true
		call BJDebugMsg("You can deactivate debugging thanks to command 'debug off'.")
	endfunction

	function DebugMsg takes string msg returns nothing
		if Debug then
			call BJDebugMsg(msg + " This message can be deactivated using command 'debug off'.")
		endif
	endfunction

	private function init takes nothing returns nothing
		local trigger debuggeron = CreateTrigger()
		local trigger debuggeroff = CreateTrigger()
		set Debug = true
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(0), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(1), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(2), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(3), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(4), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(5), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(6), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(7), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(8), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(9), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(10), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(11), "debug off", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(0), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(1), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(2), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(3), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(4), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(5), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(6), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(7), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(8), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(9), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(10), "debug on", false)
		call TriggerRegisterPlayerChatEvent(debuggeroff, GetPlayer(11), "debug on", false)
		call TriggerAddAction(debuggeroff, function ADebugOff)
		call TriggerAddAction(debuggeron, function ADebugOn)
	endfunction
endlibrary
