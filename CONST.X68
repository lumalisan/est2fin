; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS JUMP STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE

; --- AGENT TYPES -------------------------------------------------------------

SHTTYPE     EQU     1
ENTYPE      EQU     2
DESTTYPE    EQU     3

; --- PLAYER RELATED CONSTANTS ------------------------------------------------

PLRWIDTH    EQU     65                      ; PLAYER WIDTH (PIXELS)
PLRHEIGH    EQU     60                      ; PLAYER HEIGHT (PIXELS)
PLRSPEED    EQU     5                       ; PLAYER SPEED (PIXELS PER IRQ)
PLRTXTX     EQU     2                       ; SCORE X COORDINATE
PLRTXTY     EQU     1                       ; SCORE Y COORDINATE
PLRNRMCL    EQU     $000E9274               ; PLAYER NORMAL COLOR (OLIVE)
PLRDMGCL    EQU     $000000FF               ; PLAYER DAMAGED COLOR (RED)
PLRUMDMG    EQU     %00000001               ; UPDATE DAMAGE MASK
PLRPMDMG    EQU     %00000010               ; PLOT DAMAGE MASK
PLRUBDMG    EQU     0                       ; UPDATE DAMAGE BIT
PLRPBDMG    EQU     1                       ; PLOT DAMAGE BIT

; --- AUDIO RELATED CONSTANTS ------------------------------------------------

ID0         EQU     0                       ; 'MUSIC1' ID
ID1         EQU     1                       ; 'MUSIC2' ID
ID2         EQU     2                       ; CURRENTLY UNUSED

; --- ENEMY RELATED CONSTANTS -------------------------------------------------

ENEHEIGH    EQU     90                      ; ENEMY HEIGHT
ENEWIDTH    EQU     60                      ; ENEMY WIDTH
ENPENCL     EQU     $00FFFFFF               ; ENEMY PEN COLOR
ENFILCL     EQU     $0000FF00               ; ENEMY FIL COLOR

; --- GAME FIELD RELATED CONSTANTS --------------------------------------------

FLOORHGT    EQU     10                      ; FLOOR HEIGHT IN PIXELS

; --- COLOR CONSTANTS ---------------------------------------------------------

WHITE       EQU     $00FFFFFF
BLACK       EQU     $00000000
OLIVE       EQU     $000E9274
LIME        EQU     $001BBF9A
YELLOW      EQU     $0058F5D8
GREEN       EQU     $00008000
RED         EQU     $000000FF
BROWN       EQU     $00424554

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
