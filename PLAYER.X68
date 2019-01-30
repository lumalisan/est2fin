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
            CLR.W   (PLRSCORE)
            MOVE.B  #76,D0
            MOVE.L  #3,D2
            TRAP    #15
            MOVE.B  #ID0|%10000000,D1    ; PLAY MAIN MUSIC1 LOOP
            JSR     AUDPLAY
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3,-(A7)
            TST.B   (PLRJUMP)
            BNE     .JUMP
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.B  #1,(PLRJUMP)              ;
.JUMP       BSR     PLRSPINC
            BSR     PLRMOVE
            BSR     PLRFLCOL
.END        MOVEM.L (A7)+,D0-D3
            RTS

; -----------------------------------------------------------------------------
PLRSPINC
; ADD 1 TO PLAYER VERTICAL SPEED
; INPUT    - NONE
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; NOTE     - ITS JUST A WRAPPER
; -----------------------------------------------------------------------------
            ADD.W   #1,(PLRVS)
            RTS

; -----------------------------------------------------------------------------
PLRMOVE
; UPDATE PLAYER POSITION
; INPUT    - NONE
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  (PLRPOSY),D1              ; MOVE PLAYER Y POSITION TO D1
            ADD.W   (PLRVS),D1                ; ADD PLAYER VERTICAL SPEED TO D1
            MOVE.W  D1,(PLRPOSY)              ; MOVE D1 TO PLRPOSY
            RTS

; -----------------------------------------------------------------------------
PLRFLCOL
; CHECKS FLOOR COLLISION WITH PLAYER
; INPUT    - NONE
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  (PLRPOSY),D2
            CMP.W   (FLOORY),D2
            BLE     .ENDFC                    ; IF PLRPOSY <= FLOORY DO NOTHING
            MOVE.W  #15,(PLRVS)               ; RESTORE VERTICAL SPEED
            NEG.W   (PLRVS)                   ; REVERSE PLR VERTICAL SPEED
            MOVE.W  (FLOORY),D3               ; MOVE FLOOR Y TO D3
            MOVE.W  D3,(PLRPOSY)              ; MOVE PLAYER Y TO NEW POSITION
            CLR.B   (PLRJUMP)
.ENDFC      RTS


; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            JSR     PLRDRAW
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
PLRDRAW
; DRAW THE PLAYER
; INPUT    - (PLRPOSY)
; OUTPUT   - NONE
; MODIFIES - D0.B, D1.W, D2.W, D3.W, D4.W, D5.W
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5,-(SP)
            UTPLRPIX 150,-15,155,0,BLACK
            UTPLRPIX 150,-20,155,-15,OLIVE
            UTPLRPIX 150,-55,155,-20,BLACK
            UTPLRPIX 145,-20,150,-15,BLACK
            UTPLRPIX 145,-25,150,-20,OLIVE
            UTPLRPIX 140,-25,145,-20,BLACK
            UTPLRPIX 140,-30,150,-25,BLACK
            UTPLRPIX 155,-55,160,-10,OLIVE
            UTPLRPIX 155,-10,160,-5,BLACK
            UTPLRPIX 160,-15,185,-10,BLACK
            UTPLRPIX 170,-10,180,-5,BLACK
            UTPLRPIX 170,-5,175,0,BLACK
            UTPLRPIX 180,-20,185,-15,BLACK
            UTPLRPIX 180,-25,200,-20,BLACK
            UTPLRPIX 200,-55,205,-25,BLACK
            UTPLRPIX 155,-60,200,-55,BLACK
            UTPLRPIX 160,-50,170,-40,BLACK
            UTPLRPIX 160,-55,170,-50,LIME
            UTPLRPIX 170,-55,200,-25,LIME
            UTPLRPIX 160,-40,170,-25,LIME
            UTPLRPIX 160,-25,165,-15,LIME
            UTPLRPIX 165,-25,180,-15,YELLOW
            MOVEM.L (SP)+,D0-D5
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
