; =============================================================================
; GAME VARS
; =============================================================================

; TO DO: DECLARE GAME VARIABLES HERE.

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY     DS.W    1                       ; PLAYER Y POSITION (PIXELS)
PLRSCORE    DS.W    1                       ; PLAYER SCORE
            DS.W    0

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0
