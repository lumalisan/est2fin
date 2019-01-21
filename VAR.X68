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

PLRVS       DC.L    1                       ; PLAYER VERTICAL SPEED
PLRAC       DC.L    4                       ; PLAYER ACCELERATION
PLRB        DS.L    1                       ; PLAYER BOTTOM
PLRRIGHT    DS.L    1                       ; PLAYER right side
PLRDI       DC.L    16                      ; PLAYER diameter
PLRRAD      DC.L    8                       ; PLAYER radius
PLRXCENTER  DS.L    1                       ; PLAYER X center
PLRYCENTER  DS.L    1                       ; PLAYER Y center
COUNT       DC.L    0                       ; PLAYER ACCELERATION LOOP COUNTER

PLRENER     DS.W    1                       ; PLAYER ENERGY
PLRSCORE    DS.W    1                       ; PLAYER SCORE
PLRDMG      DS.B    1                       ; BIT0: UPD DAMAGE, BIT1 PLOT DMG
            DS.W    0
            
; --- FLOOR RELATED VARIABLES ------------------------------------------------
          
FLOORX      DC.L    0                       ; Court x postion
FLOORY      DC.L    470                     ; Court y postion
FLOORW      DC.L    640                     ; Court width
FLOORH      DC.L    10                      ; Court height
FLOORDE     DC.L    0                       ; Deceleration caused by court hit

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
SPEED       DC.W    0                       ; GAME SPEED: CONTROLS DIFFICULTY
            DS.W    0                       ;             AND SCROLL


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
