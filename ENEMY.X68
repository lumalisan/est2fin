; =============================================================================
; ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; =============================================================================

; -----------------------------------------------------------------------------
ENINIT
; INITALIZES AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            MOVE.W  #SCRWIDTH,(A0)              ; X POSITION EN (A0)
            MOVE.W  #(SCRHEIGH-FLOORHGT),2(A0)  ; Y POSITION EN 2(A0)
            ;JSR     UTLRAND
            ;AND.W   #$000F,D0                   ; X SPEED (PSEUDO-RANDOM)
            ;MOVE.W  (SPEED),4(A0)                ; X SPEED EN 4(A0)
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
            MOVE.W  (SPEED),D0                ; UPDATE COORDINATES IN X
            SUB.W   D0,(A0)
            ;SUB.W   #10,(A0)
            CMP.W   #-ENEHEIGH,(A0)           ; KILL ENEMY WHEN OUT OF SCREEN
            BLT     .KILL
.COLPLAY    MOVE.W  (A0),D0                 ;X POS EN D0
            MOVE.W  2(A0),D1                ;Y POS EN D1
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #ENEWIDTH,D4
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #ENEHEIGH,D6
            MOVE.W  #PLRHEIGH,D7
            JSR     UTLCHCOL
            TST.B   D0
            BEQ     .END                    ;SI NO HAY COLISION NO HACEMOS NADA
            MOVE.W  #STAGOVR,(STANEXT)      ; IF COLLISION, GAME OVER

.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR     AGLKILL
            ;SUMAR UNO A SCORE BY FREE SYNC
            ADDQ.W  #1,(PLRSCORE)
            JSR     UTLUPDS
            BRA     .COLPLAY

; -----------------------------------------------------------------------------
ENPLOT
; PLOTS AN ENEMY
; INPUT    - (A0) POS IN X
; OUTPUT   - NONE
; MODIFIES - D0.B, D1.W, D2.W, D3.W, D4.W, D5.W
; -----------------------------------------------------------------------------
            MOVEM.W D0-D5,-(A7)
            UTENEPIX 0,390,5,420,GREEN
            UTENEPIX 5,420,10,425,GREEN
            UTENEPIX 10,425,15,430,GREEN
            UTENEPIX 5,385,10,390,GREEN
            UTENEPIX 5,390,10,420,OLIVE
            UTENEPIX 10,415,15,425,OLIVE
            UTENEPIX 15,420,25,430,OLIVE
            UTENEPIX 10,390,15,415,GREEN
            UTENEPIX 15,415,20,420,GREEN
            UTENEPIX 20,420,25,385,GREEN
            UTENEPIX 20,430,25,470,GREEN
            UTENEPIX 15,430,20,435,GREEN
            UTENEPIX 25,385,35,470,OLIVE
            UTENEPIX 25,380,35,385,GREEN
            UTENEPIX 35,385,40,425,GREEN
            UTENEPIX 35,395,40,470,GREEN
            UTENEPIX 35,425,45,435,OLIVE
            UTENEPIX 40,420,45,425,GREEN
            UTENEPIX 40,435,45,440,GREEN
            UTENEPIX 45,430,50,435,GREEN
            UTENEPIX 50,425,55,430,GREEN
            UTENEPIX 55,400,60,425,GREEN
            UTENEPIX 50,400,55,425,OLIVE
            UTENEPIX 50,395,55,400,GREEN
            UTENEPIX 45,400,50,420,GREEN
            UTENEPIX 45,420,50,430,OLIVE
            MOVEM.W (A7)+,D0-D5
            RTS

; -----------------------------------------------------------------------------
ENDEST
; DESTROY AN ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     AGLKILL
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
