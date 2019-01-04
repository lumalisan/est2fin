; =============================================================================
; ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
ENINIT
; INITALIZES AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            JSR     UTLRAND
            ADD.W   #(SCRHEIGH-255-ENSIZE)/2, D0
            MOVE.W  #SCRWIDTH,(A0)          ; X POSITION
            MOVE.W  D0,2(A0)                ; Y POSITION (PSEUDO-RANDOM)
            JSR     UTLRAND
            AND.W   #$000F,D0               ; X SPEED (PSEUDO-RANDOM)
            MOVE.W  D0,4(A0)
            SUBQ.W  #7,D0
            MOVE.W  D0,6(A0)                ; Y SPEED (PSEUDO-RANDOM)
            MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
ENUPD
; UPDATES AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            MOVE.W  4(A0),D0                ; UPDATE COORDINATES
            SUB.W   D0,(A0)
            MOVE.W  6(A0),D0
            ADD.W   D0,2(A0)
            CMP.W   #-ENSIZE,(A0)           ; CHECK BOUNCE
            BLT     .KILL
            TST.W   2(A0)
            BLE     .BOUNCE
            CMP.W   #SCRHEIGH-ENSIZE,2(A0)
            BLT     .COLPLAY
.BOUNCE     NEG.W   6(A0)
.COLPLAY    MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  #ENSIZE,D4
            MOVE.W  D4,D6
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            JSR     UTLCHCOL
            TST.B   D0
            BEQ     .END
            MOVE.B  #PLRUMDMG|PLRPMDMG,(PLRDMG)

.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR     AGLKILL
            BRA     .COLPLAY

; -----------------------------------------------------------------------------
ENPLOT
; PLOTS AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            UTLSPEN #ENPENCL
            UTLSFIL #ENFILCL
            MOVEM.W D1-D4,-(A7)
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #ENSIZE,D3
            ADD.W   #ENSIZE,D4
            MOVE.B  #88,D0
            TRAP    #15
            MOVEM.W (A7)+,D1-D4
            RTS

; -----------------------------------------------------------------------------
ENDEST
; DESTROY AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1-A3/D0-D4,-(A7)
            MOVE.W  #ENNFRAG,D4
.LOOP       LEA     XPLINIT,A1
            LEA     XPLUPD,A2
            LEA     XPLPLOT,A3
            MOVE.W  #XPLTYPE,D0
            MOVE.W  (A0),D1
            ADD.W   #ENSIZE/2,D1
            MOVE.W  2(A0),D2
            ADD.W   #ENSIZE/2,D2
            JSR     AGLADD
            DBRA.W  D4,.LOOP
            JSR     AGLKILL
            MOVEM.L (A7)+,A1-A3/D0-D4
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
