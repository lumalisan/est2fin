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

PLRWIDTH    EQU     5                       ; PLAYER WIDTH (PIXELS)
PLRHEIGH    EQU     5                       ; PLAYER HEIGHT (PIXELS)
PLRINIEN    EQU     500                     ; PLAYER INITIAL ENERGY (<SCRWIDTH)
PLRSPEED    EQU     5                       ; PLAYER SPEED (PIXELS PER INT)
PLRTXTCL    EQU     $00FFFFFF               ; FONT COLOR
PLRTXTX     EQU     2                       ; SCORE X COORDINATE
PLRTXTY     EQU     1                       ; SCORE Y COORDINATE
PLRNRMCL    EQU     $000E9274               ; PLAYER NORMAL COLOR (OLIVE)
PLRDMGCL    EQU     $000000FF               ; PLAYER DAMAGED COLOR (RED)
PLRUMDMG    EQU     %00000001               ; UPDATE DAMAGE MASK
PLRPMDMG    EQU     %00000010               ; PLOT DAMAGE MASK
PLRUBDMG    EQU     0                       ; UPDATE DAMAGE BIT
PLRPBDMG    EQU     1                       ; PLOT DAMAGE BIT

; --- ENEMY RELATED CONSTANTS -------------------------------------------------

ENSIZE      EQU     60                      ; ENEMY DIAMETER
ENPENCL     EQU     $00FFFFFF               ; ENEMY PEN COLOR
ENFILCL     EQU     $0000FF00               ; ENEMY FIL COLOR
ENDMG       EQU     10                      ; ENEMY DAMAGE TO PLAYER

; --- DESTRUCTION RELATED CONSTANTS -------------------------------------------

DESTSIZE    EQU     20                      ; DESTRUCTION ITEM DIAMETER (PIXELS)
DESTPENCL   EQU     $00DDDDDD               ; DESTRUCTION ITEM PEN COLOR
DESTFILCL   EQU     $00CCCCCC               ; DESTRUCTION ITEM FIL COLOR

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     31                      ; TITLE X COORDINATE
INTTITY     EQU     5                       ; TITLE Y COORDINATE
INTTITC     EQU     $000000FF               ; TITLE COLOR
INTPRSY     EQU     26                      ; PRESS JUMP Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS FIRE COLOR

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     35                      ; TITLE X COORDINATE
GOVSTRY     EQU     15                      ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR

; --- COLOR CONSTANTS ---------------------------------------------------------

WHITE       EQU     $00FFFFFF
BLACK       EQU     $00000000
OLIVE       EQU     $000E9274
LIME        EQU     $001BBF9A
YELLOW      EQU     $0058F5D8

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
