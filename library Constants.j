library Constants initializer init
    globals
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
        player array Players
        player localPlayer
    endglobals
    constant function GetPlayer takes integer i returns player
         return Players[i]
    endfunction
    constant function GetLocal takes nothing returns player
        return localPlayer
    endfunction
    private function init takes nothing returns nothing
        local integer i=15
        loop
            exitwhen i < 0
            set Players[i]=Player(i)
            set i=i-1
        endloop
        set localPlayer=GetLocalPlayer()
    endfunction
endlibrary
