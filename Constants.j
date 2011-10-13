library Constants initializer init
	globals
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
		constant integer INTEGER = 1
		constant integer REAL = 2
		constant integer STRING = 3
		constant integer HANDLE = 4
		constant integer WIDGET = 5
		constant integer ITEM = 6
		constant integer UNIT = 7
		constant integer GROUP = 8
		constant integer PLAYER = 9
		constant integer FORCE = 10
		constant integer EFFECT = 11
		constant integer DESTRUCTABLE = 12
		constant integer LOCATION = 13
		constant integer TIMER = 14
		constant integer TRIGGER = 15
		constant integer TRIGGERACTION = 16
		constant integer TRIGGERCONDITION = 17
		constant integer EVENT = 18
		constant integer TEXTTAG = 19
		constant integer LIGHTNING = 20
		constant integer HASHTABLE = 21
		constant integer ABILITY = 22
		constant integer DIALOG = 23
		constant integer BUTTON = 24
		constant integer INDEX = 25
		constant integer INTEGER = 26
		constant integer INTEGER1 = 27
		constant integer INTEGER2 = 28
		constant integer INTEGER3 = 29
		constant integer INTERVAL = 30
		constant integer REAL = 31
		constant integer REAL1 = 32
		constant integer REAL2 = 33
		constant integer REAL3 = 34
		constant integer CASTER = 37
		constant integer TARGET = 38
		constant integer DUMMY = 39-60
		constant integer GROUP1 = 70
		constant integer GROUP2 = 71
		constant integer GROUP3 = 72
		constant integer BUTTON1 = 80
		constant integer BUTTON2 = 81
		constant integer BUTTON3 = 82
		constant integer BUTTON4 = 83
		constant integer BUTTON5 = 84
		constant integer DAMAGE_SYSTEM = 175
		constant integer DAMAGE_CASTER = 180
		constant integer DAMAGE_EVENT = 190
		constant integer ENDCHANNEL = 195
		constant integer ENDCHANNELSTOP = 196
		constant integer INCUBATION = 250
		constant integer AIGROUP = 295
		constant integer AIPATROL = 299
		constant integer AIPATROLCURRENT = 300
		constant integer AIPATROLHASH = 301 // use 301-350 range
		
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
