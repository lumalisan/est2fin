; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #150,(PLRPOSX)
            MOVE.W  #(SCRHEIGH-FLOORHGT),(PLRPOSY)
            ;MOVE.W  #0,(PLRPOSY)
            ;MOVE.W  #470,(PLRBOT)
            ;MOVE.W  #470-PLRHEIGH,(PLRTOP)

            ;MOVE.W  #PLRINIEN,(PLRENER)
            CLR.W   (PLRSCORE)
            CLR.W   (PLRDMG)
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3,-(A7)

            ;BTST.B  #KBDBITF1,(KBDEDGE)
            BTST.B  #KBDBITF1,(KBDVAL)
            BEQ     END

            MOVE.B  (KBDVAL),D0             ; PREPARE MOTION COMMAND BY
            OR.B    (KBDEDGE),D0            ; AND UP FROM KBDEDGE.

            MOVE.W  #STAJUMP,(STANEXT)      ; NI IDEA XDDD, LA IDEA ES QUE CUANDO SALTES SE PASE A UN
                                            ; ESTADO DE SALTO Y CUANDO TOQUE EL SUELO VUELVA AL ESTADO NORMAL
                                            
            BSR     INCPLRSPEED
            BSR     MOVEPLR
            BSR     FLOORCOL
            ;BSR     TOPCOL

END         MOVEM.L (A7)+,D0-D3
            RTS

*******************************************************************************
*******************************************************************************
INCPLRSPEED
            MOVE.W  PLRAC,D2                ; move acceleration rate to D2 for comparison
            ADD.W   #1,COUNT                ; Add 1 to the count
 	*; IF COUNT = BALL ACCELERATION RATE
            IF.W COUNT <EQ> D2 THEN
                ADD.W   #1,PLRVS            ; add 1 to PLAYER vertical speed
                MOVE.W  #0,COUNT            ; reset count to 0
            ENDI
                RTS

*******************************************************************************
*******************************************************************************
MOVEPLR     *UPDATE PLAYER POSITION

                MOVE.W          (PLRPOSY),D1          ; MOVE PLAYER Y POSITION TO D1
                ADD.W           PLRVS,D1              ; ADD PLAYER VERTICAL SPEED TO D1
                MOVE.W          D1,(PLRPOSY)          ; MOVE D1 TO PLRPOSY
                ;ADD.W           #PLRHEIGH,D1
                ;MOVE.W          D1,PLRBOT               ; Move D1 to PLRB
                RTS

*******************************************************************************
*******************************************************************************
FLOORCOL
            MOVE.W          (PLRPOSY),D2           ; Move PLAYER bottom to D2
            * If PLRPOSY > FLOORY
            IF.W D2 <GT> FLOORY THEN

              NEG.W           PLRVS                   ; Reverse ball vertical direction
              MOVE.W          FLOORY,D3               ; Move court top to D3
              ;SUB.W           #1,D3                   ; Get new ball top position
              MOVE.W          D3,(PLRPOSY)            ; Move ball top to new position

            ENDI
            RTS

*******************************************************************************
*******************************************************************************
TOPCOL
            MOVE.W          (PLRPOSY),D2           ; Move PLAYER bottom to D2
            SUB.W           #PLRHEIGH,D2
            * If PLRTOP < 320
            IF.W D2 <LT> #0 THEN

              NEG.W           PLRVS                   ; Reverse ball vertical direction
              MOVE.W          #0,(PLRPOSY)            ; Move ball top to new position

            ENDI
            RTS


; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            JSR     DRAWTREX

            UTLSPEN #OLIVE                    ; PLOT THE SCORE TEXT
            UTLSFIL #OLIVE
            UTLLOCT PLRTXTX,PLRTXTY
            LEA     .SCORESTR,A1
            CLR.L   D1
            MOVE.W  (PLRSCORE),D1
            MOVE.B  #17,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D4
            RTS
.SCORESTR   DC.B    'SCORE: ',0

; -----------------------------------------------------------------------------
DRAWTREX
; DRAW THE PLAYER
; INPUT    - (PLRPOSY) Pos in Y
; OUTPUT   - NONE
; MODIFIES - D0.B, D1.W, D2.W, D3.W, D4.W, D5.W
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5,-(SP)
            ;Draw t-rex with 5x5 pixels
            ;Patita izq.
            PLRPIX 150,-15,155,0,BLACK
            PLRPIX 150,-20,155,-15,OLIVE
            PLRPIX 150,-55,155,-20,BLACK
            ;Colita
            PLRPIX 145,-20,150,-15,BLACK
            PLRPIX 145,-25,150,-20,OLIVE
            PLRPIX 140,-25,145,-20,BLACK
            PLRPIX 140,-30,150,-25,BLACK
            ;Parte sombra
            PLRPIX 155,-55,160,-10,OLIVE
            ;Parte contorno
            PLRPIX 155,-10,160,-5,BLACK
            PLRPIX 160,-15,185,-10,BLACK
            PLRPIX 170,-10,180,-5,BLACK
            PLRPIX 170,-5,175,0,BLACK
            PLRPIX 180,-20,185,-15,BLACK
            PLRPIX 180,-25,200,-20,BLACK
            PLRPIX 200,-55,205,-25,BLACK
            PLRPIX 155,-60,200,-55,BLACK
            PLRPIX 160,-50,170,-40,BLACK
            ;Parte interior
            PLRPIX 160,-55,170,-50,LIME
            PLRPIX 170,-55,200,-25,LIME
            PLRPIX 160,-40,170,-25,LIME
            PLRPIX 160,-25,165,-15,LIME
            PLRPIX 165,-25,180,-15,YELLOW
            MOVEM.L (SP)+,D0-D5
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
