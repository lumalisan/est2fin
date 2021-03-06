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
RANDENTY    DC.B    0                       ; RANDOM ENEMY TYPE
            DS.W    0

; --- FLOOR RELATED VARIABLES -------------------------------------------------

FLOORX      DC.W    0                       ; FLOOR X POSTION
FLOORY      DC.W    470                     ; FLOOR Y POSTION
FLOORW      DC.W    640                     ; FLOOR WIDTH
FLOORH      DC.W    10                      ; FLOOR HEIGHT

; --- UTILITY VARIABLES -------------------------------------------------------

SPEED       DC.W    10                      ; GAME SPEED: CONTROLS DIFFICULTY
CHECKTIT    DC.B    0                       ; CHECK IF THE TITLE HAS BEEN DRAWN
CHECKLOA    DC.B    0                     ; CHECK IF THE LOADING HAS BEEN DRAWN
CHECKGOV    DC.B    0                     ; CHECK IF THE GAMEOVR HAS BEEN DRAWN
PADDING     DC.L    0                       ; CHECK PADDING WHEN DRAWING IMAGES
UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0

; --- SOUND VARIABLES ---------------------------------------------------------

JUMPSOUND   DC.B    'SOUND/JUMP.WAV',0      ; JUMPING SOUND FILE
OOF         DC.B    'SOUND/OOF.WAV',0       ; OOF.
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
