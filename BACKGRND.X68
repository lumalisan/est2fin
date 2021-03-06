; =============================================================================
; BACKGROUND AND FLOOR RELATED SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
BACKPLOT
; PLOT THE BACKGROUND
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L   D0-D4,-(SP)
            UTDRAWSQ  0,0,640,480,WHITE
            BSR       FLRPLOT
            MOVEM.L   (SP)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
FLRPLOT
; PLOT THE FLOOR
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L   D0-D4,-(SP)
            ;DRAW THE FLOOR RECTANGLE
            UTDRAWSQ  -1,470,640,480,BLACK
            MOVEM.L   (SP)+,D0-D4
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
