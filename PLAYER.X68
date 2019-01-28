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
            MOVE.W  0,(PLRPOSY)
            MOVE.W  0,(PLRBOT)
            MOVE.W  60,(PLRTOP)

            ;MOVE.W  #(SCRHEIGH-PLRHEIGH)/2,(PLRPOSY)
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
            MOVEM.L D0,-(A7)

            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     END
            ;SUB.W   #PLRSPEED,(PLRPOSY)

            ;MOVE.B  (KBDVAL),D0             ; PREPARE MOTION COMMAND BY
            ;OR.B    (KBDEDGE),D0            ; AND UP FROM KBDEDGE.

            BSR     INCPLRSPEED
            BSR     MOVEPLR
            BSR     FLOORCOL
            BSR     TOPCOL
            ;BSR     ENEMYCOL
            ;BSR     SCORE

END         MOVEM.L (A7)+,D0
            RTS

*******************************************************************************
*******************************************************************************
INCPLRSPEED
            MOVE.L  PLRAC,D2                ; move acceleration rate to D2 for comparison
            ADD.L   #1,COUNT                ; Add 1 to the count
 	*; IF COUNT = BALL ACCELERATION RATE
            IF.L COUNT <EQ> D2 THEN
                ADD.L   #1,PLRVS            ; add 1 to PLAYER vertical speed
                MOVE.L  #0,COUNT            ; reset count to 0
            ENDI
                RTS

*******************************************************************************
*******************************************************************************
MOVEPLR     *UPDATE PLAYER POSITION
                MOVE.L          (PLRPOSY),D1          ; MOVE PLAYER Y POSITION TO D1
                ADD.L           PLRVS,D1              ; ADD PLAYER VERTICAL SPEED TO D1
                MOVE.L          D1,(PLRPOSY)          ; MOVE D1 TO PLRPOSY
                ADD.L           PLRHEIGH,D1
                MOVE.L          D1,PLRBOT               ; Move D1 to PLRB

                RTS

*******************************************************************************
*******************************************************************************
FLOORCOL
            MOVE.L          PLRBOT,D2           ; Move PLAYER bottom to D2
            * If PLRBOTTOM > FLOORY
            IF.L D2 <GT> FLOORY THEN

              NEG.L           PLRVS                   ; Reverse ball vertical direction
              MOVE.L          FLOORDE,D2              ; Move deceleration of ball caused by court hit to D2
              ADD.L           D2,PLRVS                ; Decrease speed
              MOVE.L          FLOORY,D3               ; Move court top to D3
              SUB.L           #10,D3                  ; Get new ball top position
              MOVE.L          D3,(PLRPOSY)            ; Move ball top to new position

            ENDI
            RTS

*******************************************************************************
*******************************************************************************
TOPCOL
            MOVE.L          (PLRPOSY),D2           ; Move PLAYER bottom to D2
            * If PLRTOP < 0
            IF.L D2 <LE> #0 THEN

              NEG.L           PLRVS                   ; Reverse ball vertical direction
              MOVE.L          #0,D3
              ADD.L           #1,D3                   ; Get new ball top position
              MOVE.L          D3,(PLRPOSY)            ; Move ball top to new position

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

            ; MOVE.L  #PLRNRMCL,D1            ; DECIDE COLOR
            BCLR.B  #PLRPBDMG,(PLRDMG)
            BEQ     .NODMG
            ; IF THE PLAYER IS DAMAGED PUT THE DAMAGED COLOR IN D1
            ; Nota Lisandro: No se como haremos para cambiar el color del dinosaurio
            MOVE.L  #PLRDMGCL,D1
            ; COLOR BY BURGUERA
.NODMG      ; MOVE.B  #80,D0
            ; TRAP    #15
            ; ADDQ.B  #1,D0
            ; TRAP    #15
            ; DRAW THE PLAYER BY BURGUERA
            ; MOVE.W  (PLRPOSX),D1
            ; MOVE.W  (PLRPOSY),D2
            ; MOVE.W  D1,D3
            ; MOVE.W  D2,D4
            ; ADD.W   #PLRWIDTH,D3            ; D3 = X + PLRWIDTH
            ; ADD.W   #PLRHEIGH,D4            ; D4 = Y + PLRHEIGH
            ; MOVE.B  #88,D0
            ; TRAP    #15
            ; SUB.W   #PLRWIDTH/2,D3
            ; MOVE.B  #87,D0
            ; TRAP    #15

            ; DRAW THE PLAYER BY US
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
            PLRPIX 150,455,155,470,BLACK
            PLRPIX 150,450,155,455,OLIVE
            PLRPIX 150,415,155,450,BLACK
            ;Colita
            PLRPIX 145,450,150,455,BLACK
            PLRPIX 145,445,150,450,OLIVE
            PLRPIX 140,445,145,450,BLACK
            PLRPIX 140,440,150,445,BLACK
            ;Parte sombra
            PLRPIX 155,415,160,460,OLIVE
            ;Parte contorno
            PLRPIX 155,460,160,465,BLACK
            PLRPIX 160,455,185,460,BLACK
            PLRPIX 170,460,180,465,BLACK
            PLRPIX 170,465,175,470,BLACK
            PLRPIX 180,450,185,455,BLACK
            PLRPIX 180,445,200,450,BLACK
            PLRPIX 200,415,205,445,BLACK
            PLRPIX 155,410,200,415,BLACK
            PLRPIX 160,420,170,430,BLACK
            ;Parte interior
            PLRPIX 160,415,170,420,LIME
            PLRPIX 170,415,200,445,LIME
            PLRPIX 160,430,170,445,LIME
            PLRPIX 160,445,165,455,LIME
            PLRPIX 165,445,180,455,YELLOW
            MOVEM.L (SP)+,D0-D5
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
