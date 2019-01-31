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
PLRVS       DC.W    15                      ; PLAYER VERTICAL SPEED
PLRAC       DC.W    4                       ; PLAYER ACCELERATION
PLRSCORE    DS.W    1                       ; PLAYER SCORE
PLRJUMP     DC.B    0                       ; BIT0: TO CHECK JUMP STATE
            DS.W    0

; --- FLOOR RELATED VARIABLES -------------------------------------------------

FLOORX      DC.W    0                       ; FLOOR X POSTION
FLOORY      DC.W    470                     ; FLOOR Y POSTION
FLOORW      DC.W    640                     ; FLOOR WIDTH
FLOORH      DC.W    10                      ; FLOOR HEIGHT

; --- UTILITY VARIABLES -------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
SPEED       DC.W    10                      ; GAME SPEED: CONTROLS DIFFICULTY
            DS.W    0                       ;             AND SCROLL

; --- SOUND VARIABLES ---------------------------------------------------------

JUMPSOUND   DC.B    'SOUND/JUMP.WAV',0
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
