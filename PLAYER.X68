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
            MOVE.W  #PLRWIDTH/2,(PLRPOSX)
            MOVE.W  #(SCRHEIGH-PLRHEIGH)/2,(PLRPOSY)
            MOVE.W  #PLRINIEN,(PLRENER)
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
            BCLR.B  #PLRUBDMG,(PLRDMG)
            BEQ     .NODMG
            SUB.W   #ENDMG,(PLRENER)
            BGT     .NODMG
            MOVE.W  #STAGOVR,(STANEXT)      ; IF LIFE IS 0, GAME OVER
.NODMG      MOVE.W  D1,-(A7)
            MOVE.B  (KBDVAL),D1             ; PERFORM MOTION AND CHECK BOUNDS.
            ROR.B   #1,D1
            BCC     .CHKUP
            SUB.W   #PLRSPEED,(PLRPOSX)
            TST.W   (PLRPOSX)
            BGE     .CHKUP
            CLR.W   (PLRPOSX)
.CHKUP      ROR.B   #1,D1
            BCC     .CHKRT
            SUB.W   #PLRSPEED,(PLRPOSY)
            TST.W   (PLRPOSY)
            BGE     .CHKRT
            CLR.W   (PLRPOSY)
.CHKRT      ROR.B   #1,D1
            BCC     .CHKDN
            ADD.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #SCRWIDTH-PLRWIDTH,(PLRPOSX)
            BLE     .CHKDN
            MOVE.W  #SCRWIDTH-PLRWIDTH,(PLRPOSX)
.CHKDN      ROR.B   #1,D1
            BCC     .MDONE
            ADD.W   #PLRSPEED,(PLRPOSY)
            CMP.W   #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            BLE     .MDONE
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)
.MDONE      BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .NOFIRE
            ;MOVEM.L A1-A3/D0-D2,-(A7)
            ;LEA     SHTINIT,A1
            ;LEA     SHTUPD,A2
            ;LEA     SHTPLOT,A3
            ;MOVE.W  #SHTTYPE,D0
            ;MOVE.W  (PLRPOSX),D1
            ;MOVE.W  (PLRPOSY),D2
            ;JSR     AGLADD
            ;MOVEM.L (A7)+,A1-A3/D0-D2
.NOFIRE     MOVE.W  (A7)+,D1
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


            UTLSPEN #BLACK                    ; PLOT THE SCORE TEXT
            UTLSFIL #WHITE
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
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(SP)
            ;Draw t-rex with 5x5 pixels
            ;Patita izq.
            DRAWPIX 150,455,155,470,BLACK
            DRAWPIX 150,450,155,455,OLIVE
            DRAWPIX 150,415,155,450,BLACK
            ;Colita
            DRAWPIX 145,450,150,455,BLACK
            DRAWPIX 145,445,150,450,OLIVE
            DRAWPIX 140,445,145,450,BLACK
            DRAWPIX 140,440,150,445,BLACK
            ;Parte sombra
            DRAWPIX 155,415,160,460,OLIVE
            ;Parte contorno
            DRAWPIX 155,460,160,465,BLACK
            DRAWPIX 160,455,185,460,BLACK
            DRAWPIX 170,460,180,465,BLACK
            DRAWPIX 170,465,175,470,BLACK
            DRAWPIX 180,450,185,455,BLACK
            DRAWPIX 180,445,200,450,BLACK
            DRAWPIX 200,415,205,445,BLACK
            DRAWPIX 155,410,200,415,BLACK
            DRAWPIX 160,420,170,430,BLACK
            ;Parte interior
            DRAWPIX 160,415,170,420,LIME
            DRAWPIX 170,415,200,445,LIME
            DRAWPIX 160,430,170,445,LIME
            DRAWPIX 160,445,165,455,LIME
            DRAWPIX 165,445,180,455,YELLOW
            MOVEM.L (SP)+,D0-D4
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
