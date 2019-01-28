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

PLRVS       DC.W    10                       ; PLAYER VERTICAL SPEED
PLRAC       DC.W    4                       ; PLAYER ACCELERATION

PLRBOT      DS.W    1                       ; PLAYER BOTTOM
PLRTOP      DS.W    1                       ; PLAYER TOP
PLRRIG      DS.W    1                       ; PLAYER RIGHT

COUNT       DC.W    0                       ; PLAYER ACCELERATION LOOP COUNTER

PLRENER     DS.W    1                       ; PLAYER ENERGY
PLRSCORE    DS.W    1                       ; PLAYER SCORE
PLRDMG      DS.B    1                       ; BIT0: UPD DAMAGE, BIT1 PLOT DMG
            DS.W    0

; --- FLOOR RELATED VARIABLES ------------------------------------------------

FLOORX      DC.W    0                       ; Court x postion
FLOORY      DC.W    470                     ; Court y postion
FLOORW      DC.W    640                     ; Court width
FLOORH      DC.W    10                      ; Court height
FLOORDE     DC.W    0                       ; Deceleration caused by court hit

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
SPEED       DC.W    10                      ; GAME SPEED: CONTROLS DIFFICULTY
            DS.W    0                       ;             AND SCROLL



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
