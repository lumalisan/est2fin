; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
UTPLRPIX      MACRO
; DRAW A PIXEL FOR THE PLAYER ON THE SPECIFIED COORDENATES
; INPUT     - \1 LEFT X
;           - \2 UPPER Y
;           - \3 RIGHT X
;           - \4 LOWER Y
;           - \5 COLOR IN FORMAT $00BBGGRR
;           - (PLRPOSY) POS IN Y
; OUTPUT    - NONE
; MODIFIES  - D0.B, D1.W, D2.W, D3.W, D4.W, D5.W
; -----------------------------------------------------------------------------
            ;GET PLAYER Y
            MOVE.W  (PLRPOSY),D5
            ;SET THE COLOR IN D1
            MOVE.L  #\5,D1
            ;SET PEN COLOR
            MOVE.B  #80,D0
            TRAP    #15
            ;SET FILL COLOR
            MOVE.B  #81,D0
            TRAP    #15
            ;DRAW THE PIXEL
            MOVE.W  #\1,D1
            MOVE.W  #\2,D2
            ADD.W   D5,D2
            MOVE.W  #\3,D3
            MOVE.W  #\4,D4
            ADD.W   D5,D4
            MOVE.B  #87,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTENEPIX      MACRO
; DRAW A PIXEL FOR THE ENEMY ON THE SPECIFIED COORDENATES
; INPUT     - \1 LEFT X
;           - \2 UPPER Y
;           - \3 RIGHT X
;           - \4 LOWER Y
;           - \5 COLOR IN FORMAT $00BBGGRR
;           - (A0) POS IN X
; OUTPUT    - NONE
; MODIFIES  - D0.B, D1.W, D2.W, D3.W, D4.W, D5.W
; -----------------------------------------------------------------------------
            ;GET ENEMY X
            MOVE.W  (A0),D5
            ;SET THE COLOR IN D1
            MOVE.L  #\5,D1
            ;SET PEN COLOR
            MOVE.B  #80,D0
            TRAP    #15
            ;SET FILL COLOR
            MOVE.B  #81,D0
            TRAP    #15
            ;DRAW THE PIXEL
            MOVE.W  #\1,D1
            ADD.W   D5,D1
            MOVE.W  #\2,D2
            MOVE.W  #\3,D3
            ADD.W   D5,D3
            MOVE.W  #\4,D4
            MOVE.B  #87,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTDRAWSQ      MACRO
; DRAW A RECTANGLE ON THE SPECIFIED COORDENATES
; INPUT     - \1 LEFT X
;           - \2 UPPER Y
;           - \3 RIGHT X
;           - \4 LOWER Y
;           - \5 COLOR IN FORMAT $00BBGGRR
; OUTPUT    - NONE
; MODIFIES  - D0.B, D1.W, D2.W, D3.W, D4.W
; -----------------------------------------------------------------------------
            ;SET THE COLOR IN D1
            MOVE.L  #\5,D1
            ;SET PEN COLOR
            MOVE.B  #80,D0
            TRAP    #15
            ;SET FILL COLOR
            MOVE.B  #81,D0
            TRAP    #15
            ;DRAW THE PIXEL
            MOVE.W  #\1,D1
            MOVE.W  #\2,D2
            MOVE.W  #\3,D3
            MOVE.W  #\4,D4
            MOVE.B  #87,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLLOCT     MACRO
; WRAPPER TO TEXT POSITIONNING FROM TRAP 15
; INPUT    - \1 X, \2 Y
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM

; =============================================================================
; UTILITY SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
UTLUPDS
; UPDATES GAME SPEED DEPENDING ON PLAYER SCORE/10
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(SP)                ; SAVE REGISTER

            MOVE.W  (PLRSCORE),D0
            ;DIVU.W  #10,D0                   ; DIVIDE BY 10
            ADD.W   #10,D0
            CMP.W   #50,D0                  ; COMPARE IF >= 30
            BGE     .MAX
            MOVE.W  D0,(SPEED)              ; IF < 30, SET AS GAME SPEED
            BRA     .END
.MAX        MOVE.W  #50,(SPEED)             ; IF >=30, SET AS 30

.END        MOVEM.L (SP)+,D0                ; RESTORE REGISTERS
            RTS
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (UTLRNDIX)
            RTS
; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS

; -----------------------------------------------------------------------------
UTCLEAN
; CLEAN THE BUFFER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            MOVE.B  #94,D0                  ; DISPLAY HIDDEN BUFFER
            TRAP    #15

            MOVE.B  #11,D0                  ; CLEAR HIDDEN BUFFER
            MOVE.W  #$FF00,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS


.RANDVEC    DC.B	1, 0, 1, 1, 0, 0, 1, 0
            DC.B	0, 1, 1, 0, 0, 0, 0, 0
            DC.B	1, 1, 1, 1, 1, 0, 1, 1
            DC.B	0, 0, 0, 0, 1, 0, 1, 1
            DC.B	0, 0, 1, 0, 1, 0, 1, 1
            DC.B	1, 1, 1, 0, 0, 1, 1, 1
            DC.B	0, 0, 0, 0, 0, 0, 1, 1
            DC.B	0, 1, 1, 0, 0, 0, 0, 0
            DC.B	1, 0, 0, 1, 1, 1, 1, 0
            DC.B	0, 1, 1, 0, 0, 1, 1, 0
            DC.B	1, 1, 0, 1, 0, 0, 0, 1
            DC.B	0, 0, 1, 1, 1, 0, 1, 0
            DC.B	1, 1, 1, 1, 0, 0, 1, 1
            DC.B	0, 0, 0, 0, 0, 1, 0, 0
            DC.B	0, 0, 1, 0, 1, 1, 0, 1
            DC.B	0, 0, 1, 0, 1, 1, 0, 1
            DC.B	1, 0, 1, 1, 1, 1, 1, 1
            DC.B	0, 1, 1, 0, 1, 1, 1, 1
            DC.B	1, 0, 1, 0, 1, 0, 1, 1
            DC.B	1, 0, 1, 0, 0, 0, 0, 1
            DC.B	1, 1, 0, 0, 0, 1, 1, 1
            DC.B	1, 1, 1, 0, 1, 0, 1, 0
            DC.B	0, 1, 0, 0, 0, 1, 1, 1
            DC.B	1, 1, 0, 1, 1, 1, 0, 0
            DC.B	1, 0, 0, 0, 0, 0, 1, 0
            DC.B	0, 0, 1, 0, 1, 1, 0, 1
            DC.B	1, 1, 1, 1, 1, 1, 1, 1
            DC.B	0, 0, 0, 1, 1, 1, 0, 1
            DC.B	0, 1, 0, 0, 1, 1, 0, 0
            DC.B	0, 1, 0, 1, 1, 0, 1, 0
            DC.B	1, 0, 0, 0, 0, 1, 0, 1
            DC.B	0, 0, 1, 0, 0, 1, 0, 0
            DC.B	1, 1, 1, 1, 0, 1, 1, 1
            DC.B	1, 0, 0, 1, 1, 1, 0, 0
            DC.B	0, 1, 1, 1, 1, 0, 1, 1
            DC.B	0, 0, 1, 0, 0, 1, 1, 0
            DC.B	0, 0, 0, 1, 1, 0, 0, 0
            DC.B	0, 0, 1, 1, 1, 1, 0, 1
            DC.B	0, 1, 1, 0, 1, 0, 1, 0
            DC.B	1, 0, 0, 1, 0, 0, 1, 1
            DC.B	0, 1, 1, 1, 1, 1, 1, 1
            DC.B	1, 0, 0, 0, 0, 1, 1, 1

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
