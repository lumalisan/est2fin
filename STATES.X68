; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            JSR     UTLHW
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI    EQU     PLRINIT
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     PLRUPD
            JSR     SPWUPD
            BRA     AGLUPD

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     BACKPLOT
            JSR     AGLPLOT
            BRA     PLRPLOT

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDVAL)
            BEQ     .END
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1,-(A7)

            TST.B   (CHECKTIT)
            BEQ     .LOADING

            ; LOAD IN THE TITLE IMAGE
            LEA     TITLEIMG, A0
            MOVE.L  #640, D1
            MOVE.L  #480, D2
            MOVE.L  #0, D3
            MOVE.L  #0, D4
            MOVE.L  #0, D5
            MOVE.L  #0, D6
            JSR     DRAWIMAGE

            MOVE.B  #ID1|%10000000,D1         ; PLAY MENU MUSIC2 LOOP
            JSR     AUDPLAY

            ; CLEAN THE BUFFER
            JSR     UTCLEAN

            MOVE.B  #0,(CHECKTIT)

.LOADING    TST.B   (CHECKLOA)
            BNE     .END
            MOVE.B  #1,(CHECKLOA)     ; DON'T DRAW THE LOADING IMAGE ANYMORE
            MOVE.B  #1,(CHECKTIT)     ; DRAW THE TITLE IMAGE ON THE NEXT CYCLE

            ; LOAD IN THE LOADING IMAGE FIRST
            LEA     LOADINGIMG, A0
            MOVE.L  #160, D1
            MOVE.L  #170, D2
            MOVE.L  #240, D3
            MOVE.L  #170, D4
            MOVE.L  #0, D5
            MOVE.L  #0, D6
            JSR     DRAWIMAGE

            ; CLEAN THE BUFFER
            JSR     UTCLEAN

.END        MOVEM.L (A7)+,A1/D0-D1
            RTS

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDVAL)
            BEQ     .END
            MOVE.W  #STAINTR,(STANEXT)
            ; CLEAN CHECK VARS
            CLR.B   (CHECKTIT)
            CLR.B   (CHECKLOA)
            CLR.B   (CHECKGOV)
            ; RESET GAME SPEED
            MOVE.W  #10,(SPEED)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1/D0-D1,-(A7)

            ; STOP MAIN MUSIC
            MOVE.B  #76,D0
            MOVE.L  #3,D2
            TRAP    #15

            TST.B   (CHECKGOV)
            BNE     .END
            MOVE.B  #1,(CHECKGOV)     ; DON'T DRAW THE GAME OVER IMAGE ANYMORE

            ; PLAY GAME OVER MUSIC
            LEA     OOF,A1
            MOVE.B  #73,D0
            TRAP    #15

            ; LOAD IN THE GAME OVER IMAGE
            LEA     GAMEOVERIMG, A0
            MOVE.L  #500, D1        ; WIDTH IN D1
            MOVE.L  #100, D2        ; HEIGHT IN D2
            MOVE.L  #100, D3        ; BEGINNING PRINT LOCATION FOR X AXIS ON STACK
            MOVE.L  #200, D4        ; BEGINNING PRINT LOCATION FOR Y AXIS ON STACK
            MOVE.L  #0, D5          ; TOP LEFT X TO DRAW IMAGE
            MOVE.L  #0, D6          ; TOP LEFT Y TO DRAW IMAGE
            JSR     DRAWIMAGE

            ; CLEAN THE BUFFER
            JSR     UTCLEAN

.END        MOVEM.L (A7)+,A0-A1/D0-D1
            RTS
