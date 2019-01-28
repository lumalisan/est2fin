; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
DRAWPIX     MACRO
; Draw a pixel on the specified coordenates
; Input     - \1 Left X
;           - \2 Upper Y
;           - \3 Right X
;           - \4 Lower Y
;           - \4 Color in format $00BBGGRR
;           - (PLRPOSY) Movement in Y
; Output    - None
; Modifies  - D0.B, D1.W, D2.W, D3.W, D4.W
; -----------------------------------------------------------------------------
            ;Set the color in D1
            MOVE.L  #\5,D1
            ;Set pen color
            MOVE.B  #80,D0
            TRAP    #15
            ;Set fill color
            MOVE.B  #81,D0
            TRAP    #15
            ;Draw the pixel
            MOVE.W  #\1,D1
            MOVE.W  #\2,D2
            SUB.W   (PLRPOSY),D2
            MOVE.W  #\3,D3
            MOVE.W  #\4,D4
            SUB.W   (PLRPOSY),D4
            MOVE.B  #87,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
DRAWSQ      MACRO
; Draw a rectangle on the specified coordenates
; Input     - \1 Left X
;           - \2 Upper Y
;           - \3 Right X
;           - \4 Lower Y
;           - \4 Color in format $00BBGGRR
; Output    - None
; Modifies  - D0.B, D1.W, D2.W, D3.W, D4.W
; -----------------------------------------------------------------------------
            ;Set the color in D1
            MOVE.L  #\5,D1
            ;Set pen color
            MOVE.B  #80,D0
            TRAP    #15
            ;Set fill color
            MOVE.B  #81,D0
            TRAP    #15
            ;Draw the pixel
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
            DIVU.W  #10,D0                  ; DIVIDE BY 10
            CMP.W   #30,D0                  ; COMPARE IF >= 30
            BLE     .MAX
            MOVE.W  D0,(SPEED)              ; IF < 30, SET AS GAME SPEED
            BRA     .END
.MAX        MOVE.W  #30,(SPEED)             ; IF >=30, SET AS 30

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
UTLGETC
; GETS THE CYCLES NUMBER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - CYCLES
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1,-(A7)
            
            MOVE.B  #31,D0
            CLR.L   D1
            TRAP    #15
            MOVE.L  D1,(CYCLES)
            
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
UTLCOUNT
; RETURNS THE DIFFERENCE WITH THE CYCLE COUNTER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - CYCLES
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2,-(A7)
            
            MOVE.B  #31,D0
            CLR.L   D1
            TRAP    #15
            MOVE.L  (CYCLES),D2
            SUB.L   D2,D1
            MOVE.L  D1,(CYCLES)             ; SAVE DIFFERENCE
            
            MOVEM.L (A7)+,D0-D2
            RTS

; -----------------------------------------------------------------------------
UTLHW
; UPDATES THE HARDWARE WINDOW
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - PRESSED
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D1/A0-A2,-(A7)
            
            MOVE.L DISPADDR,A0
            MOVE.L SWADDR,A2                ; COGEMOS LA DIRECCION DE LOS PULSADORES
            MOVE.L (A2),D1                  ; PONEMOS LOS VALORES DE LOS PULSADORES EN D1
            NOT D1                          ; NEGAMOS D1 (1 = APAGADO)
            BTST.L #24,D1                   ; TEST DEL SWITCH MAS A LA DERECHA
            BNE .PRESSED                    ; SI = 0, AÑADE 1, SI NO, NO HACES NADA
            
.NOTPRESSED                                 ; CYCLES DRAWING
            MOVE.B  #0,(PRESSED)
            BRA .END
.PRESSED                                    ; CYCLES UPDATE
            MOVE.B  #1,(PRESSED)
            BRA .END

            
.END        LEA.L   CYCLES,A1
            BSR     MWRTSEGM

            MOVEM.L  (A7)+,D0-D1/A0-A2
            RTS
            
; -------
MWRTSEGM:

            MOVEM.L D0, -(SP)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$0000000F,D0
            BSR WRTSEGM
            MOVE.B D0,14(A0)                ; CIFRA 0 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$000000F0,D0
            LSR.L #4,D0
            BSR WRTSEGM
            MOVE.B D0,12(A0)                ; CIFRA 1 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$00000F00,D0
            LSR.L #8,D0
            BSR WRTSEGM
            MOVE.B D0,10(A0)                ; CIFRA 2 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$0000F000,D0
            LSR.L #8,D0
            LSR.L #4,D0
            BSR WRTSEGM
            MOVE.B D0,8(A0)                 ; CIFRA 3 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$000F0000,D0
            LSR.L #8,D0
            LSR.L #8,D0
            BSR WRTSEGM
            MOVE.B D0,6(A0)                 ; CIFRA 4 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$00F00000,D0
            LSR.L #8,D0
            LSR.L #8,D0
            LSR.L #4,D0
            BSR WRTSEGM
            MOVE.B D0,4(A0)                 ; CIFRA 5 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$0F000000,D0
            LSR.L #8,D0
            LSR.L #8,D0
            LSR.L #8,D0
            BSR WRTSEGM
            MOVE.B D0,2(A0)                 ; CIFRA 6 (DERECHA)
            
            MOVE.L (A1),D0                  ; NUMERO EN HEXADECIMAL
            AND.L #$F0000000,D0
            LSR.L #8,D0
            LSR.L #8,D0
            LSR.L #8,D0
            LSR.L #4,D0
            BSR WRTSEGM
            MOVE.B D0,(A0)                  ; CIFRA 7 (DERECHA)
            
            
            MOVEM.L (SP)+, D0
            RTS
            
WRTSEGM:
            CMP #0,D0
            BEQ .WRITE0
            CMP #1,D0
            BEQ .WRITE1
            CMP #2,D0
            BEQ .WRITE2
            CMP #3,D0
            BEQ .WRITE3
            CMP #4,D0
            BEQ .WRITE4
            CMP #5,D0
            BEQ .WRITE5
            CMP #6,D0
            BEQ .WRITE6
            CMP #7,D0
            BEQ .WRITE7
            CMP #8,D0
            BEQ .WRITE8
            CMP #9,D0
            BEQ .WRITE9
            CMP #$A,D0
            BEQ .WRITEA
            CMP #$B,D0
            BEQ .WRITEB
            CMP #$C,D0
            BEQ .WRITEC
            CMP #$D,D0
            BEQ .WRITED
            CMP #$E,D0
            BEQ .WRITEE
            CMP #$F,D0
            BEQ .WRITEF
                
.WRITE0     
            MOVE.B #$3F,D0
            RTS
.WRITE1     
            MOVE.B #$6,D0
            RTS
.WRITE2     
            MOVE.B #$5B,D0
            RTS
.WRITE3     
            MOVE.B #$4F,D0
            RTS
.WRITE4     
            MOVE.B #$66,D0
            RTS
.WRITE5     
            MOVE.B #$6D,D0
            RTS
.WRITE6     
            MOVE.B #$7D,D0
            RTS
.WRITE7     
            MOVE.B #$7,D0
            RTS
.WRITE8     
            MOVE.B #$7F,D0
            RTS
.WRITE9     
            MOVE.B #$6F,D0
            RTS
.WRITEA     
            MOVE.B #$77,D0
            RTS
.WRITEB     
            MOVE.B #$7C,D0
            RTS
.WRITEC     
            MOVE.B #$39,D0
            RTS
.WRITED     
            MOVE.B #$5E,D0
            RTS
.WRITEE     
            MOVE.B #$79,D0
            RTS
.WRITEF     
            MOVE.B #$71,D0
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


.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
