library Constants initializer init
	globals
		// Some vars
		group NoPathingGroup
		
		// Buffer variables
		unit buffer_UNIT
		group buffer_GROUP
		player buffer_PLAYER
		item buffer_ITEM
		integer buffer_INTEGER
		real buffer_X
		real buffer_Y
		real buffer_REAL
		boolean buffer_BOOL
		
		// Hashtable constants
		constant integer BOOLEAN = 0
		constant integer INTEGER = 20
		constant integer REAL = 40
		constant integer STRING = 60
		constant integer HANDLE = 80
		constant integer WIDGET = 100
		constant integer ITEM = 120
		constant integer UNIT = 140
		constant integer GROUP = 160
		constant integer PLAYER = 180
		constant integer FORCE = 200
		constant integer EFFECT = 220
		constant integer DESTRUCTABLE = 240
		constant integer LOCATION = 260
		constant integer TIMER = 280
		constant integer TRIGGER = 300
		constant integer TRIGGERACTION = 320
		constant integer TRIGGERCONDITION = 340
		constant integer EVENT = 360
		constant integer TEXTTAG = 380
		constant integer LIGHTNING = 400
		constant integer HASHTABLE = 420
		constant integer ABILITY = 440
		constant integer DIALOG = 460
		constant integer BUTTON = 480
		constant integer INDEX = 500
		constant integer INTERVAL = 501
		constant integer DISTANCE = 502
		constant integer DURATION = 503
		constant integer CASTER = 504
		constant integer TARGET = 505
		constant integer TICKER_NEXT = 1000
		constant integer TICKER_LEFT = 1001
		constant integer TICKER_PERIOD = 1002
		constant integer TICKER_INDEX = 1003
		constant integer TICKER_ACTION = 1004
		constant integer DAMAGE_SYSTEM = 1100
		constant integer DAMAGE_CASTER = 1101
		constant integer DAMAGE_EVENT = 1102
		constant integer ENDCHANNEL = 1200
		constant integer ENDCHANNELSTOP = 1201
		constant integer AIGROUP = 1300
		constant integer AIPATROL = 1301
		constant integer AIPATROLCURRENT = 1302
		constant integer AIPATROLHASH = 1349 // use 1349 - 1400 range
		constant integer INCUBATION = 1500
		
		// Orders constants
		constant integer SMART = 851971
		constant integer STOP = 851972
		constant integer SETRALLY = 851980
		constant integer GETITEM = 851981
		constant integer ATTACK = 851983
		constant integer ATTACKGROUND = 851984
		constant integer ATTACKONCE = 851985
		constant integer MOVE = 851986
		constant integer AIMOVE = 851988
		constant integer PATROL = 851990
		constant integer HOLDPOSITION = 851993
		constant integer BUILD = 851994
		constant integer HUMANBUILD = 851995
		constant integer ORCBUILD = 851996
		constant integer NIGHTELFBUILD = 851997
		constant integer UNDEADBUILD = 851998
		constant integer RESUMEBUILD = 851999
		constant integer DROPITEM = 852001
		constant integer INVSWITCHSLOT0 = 852002
		constant integer INVSWITCHSLOT1 = 852003
		constant integer INVSWITCHSLOT2 = 852004
		constant integer INVSWITCHSLOT3 = 852005
		constant integer INVSWITCHSLOT4 = 852006
		constant integer INVSWITCHSLOT5 = 852007
		constant integer DETECTAOE = 852015
		constant integer RESUMEHARVESTING = 852017
		constant integer HARVEST = 852018
		constant integer REPAIR = 852024
		constant integer REPAINON = 852025
		constant integer REPAIROFF = 852026
		constant integer ABILORDERFIRST = 1093677104
		
		// Colors constants
		constant string COLOR_RED = "|c00FF0303"
		constant string COLOR_BLUE = "|c000042FF"
		constant string COLOR_CYAN = "|c001CE6B9"
		constant string COLOR_PURPLE = "|c00540081"
		constant string COLOR_YELLOW = "|c00FFFC01"
		constant string COLOR_ORANGE = "|c00FF8000"
		constant string COLOR_GREEN = "|c0020C000"
		constant string COLOR_PINK = "|c00E55BB0"
		constant string COLOR_LIGHT_GREY = "|c00959697"
		constant string COLOR_LIGHT_BLUE = "|c007EBFF1"
		constant string COLOR_AQUA = "|c00106246"
		constant string COLOR_BROWN = "|c004E2A04"
		constant string COLOR_DARK_ORANGE = "|c00994000"
		constant string COLOR_DARK_AQUA = "|c00083123"
		constant string COLOR_DARK_GREY = "|c004A4B4C"
		constant string COLOR_WHITE = "|c00FFFFFF"
		constant string COLOR = "|cfffccc66"
		constant string ENDCOLOR = "|r"
		
		// Players constants
		player array Players
		player localPlayer
		
		// Damage type constants
		constant integer UNKNOWN = 0
		constant integer FIRE = 8
		constant integer COLD = 9
		constant integer POISON = 11
		constant integer DISEASE = 12
		constant integer DIVINE = 13
		constant integer MAGIC = 14
		constant integer SONIC = 15
		constant integer ACID = 16
		constant integer DEATH = 18
		constant integer MIND = 19
		constant integer PLANT = 20
		constant integer UNIVERSAL = 26
	endglobals
	
	constant function GetPlayer takes integer i returns player
		return Players[i]
	endfunction
	
	constant function GetLocal takes nothing returns player
		return localPlayer
	endfunction

	private function init takes nothing returns nothing
		local integer i = 15
		loop
		exitwhen i < 0
		set Players[i] = Player(i)
		set i = i - 1
		endloop
		set localPlayer = GetLocalPlayer()
	endfunction
endlibrary
