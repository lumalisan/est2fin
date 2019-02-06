; =============================================================================
; IMAGE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
DRAWIMAGE
; DRAW AN IMAGE FROM BITMAP FILE OF SIZE D1.L x D2.L
; INPUT    - D1.L WIDTH OF CHUNK
;          - D2.L HEIGHT OF THE CHUNK
;          - D3.L START OF CHUNK X
;          - D4.L START OF CHUNK Y
;          - D5.L TOP LEFT X
;          - D6.L TOP LEFT Y
;          - A0.L POINTER TO THE .BMP
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  #0, PADDING
            MOVE.L  #36, D0                 ; NUMBER OF 7 ARGUMENTS
            SUB.L   D0, SP                 ; PREPARE STACK TO RECEIVE ARGUMENTS
            MOVE.L  A0, (SP)
            MOVE.L  D1, 4(SP)
            MOVE.L  D2, 8(SP)
            MOVE.L  D5, 12(SP)
            MOVE.L  D6, 16(SP)
            MOVE.L  D3, 20(SP)
            MOVE.L  D4, 24(SP)
            MOVE.L  18(A0), D1
            ROL.W   #8, D1
            SWAP    D1
            ROL.W   #8, D1                  ; GET TRUE WIDTH VALUE TO USE LATER
            MOVE.L  D1, 28(SP)
            MOVE.L  #4, D2
            MULU.W  #3, D1
            DIVU.W  #4, D1
            SWAP    D1
            CLR.L   D4
            MOVE.W  #0, D4
            CMP.W   D1, D4
            BEQ     .RUNPROGRAM
            SUB.W   D1, D2                  ; GET PADDING
            MOVE.L  D2, PADDING
.RUNPROGRAM
            MOVE.L  22(A0), D2              ; GET HEIGHT OF IMAGE
            ROL.W   #8, D2
            SWAP    D2
            ROL.W   #8, D2                  ; GET TRUE HEIGHT VALUE
            MOVE.L  D2, 32(SP)
            JSR     .DRAWCHUNK              ; DRAW CHUNK OF IMAGE
            CLR.L   D0
            MOVE.L  #36, D0
            ADD.L   D0, SP                  ; FIX STACK
            CLR.L   D7
            RTS
.DRAWCHUNK
            MOVE.L  4(SP), A0               ; STORE THE POINTER TO THE IMAGE
            MOVE.L  10(A0), D0              ; GRAB THE OFFSET
            ROL.W   #8, D0
            SWAP    D0
            ROL.W   #8, D0
            ADD.W   D0, A0
            ; CALCULATE BEGINNING POSITION OF CHUNK TO DRAW FROM Y POSITION
            CLR.L   D4
            MOVE.L  36(SP),D4
            MOVE.L  20(SP), D5
            ADD.L   12(SP), D5
            SUB.L   D5, D4
            CLR.L   D5
            MOVE.W  D4, D5
            CLR.L   D4
            MOVE.L  32(SP), D4
            MULU.W  D4, D5
            ; SET POSITION IN ADDRESS AT THE BEGINNING OF CHUNK DRAW
            ADD.L   D5, A0
            ADD.L   D5, A0
            ADD.L   D5, A0
            MOVE.L  12(SP), D3
.OUTERLOOP
            MOVE.W  #0, D6                 ;SET OR RESET X COUNTER FOR FOR LOOP
            MOVE.L  16(SP), D4
            MULU.W  #3, D4
            ADD.W   D4, A0                  ; ADD START OF X TO 0
.INNERLOOP
            CLR.L   D4
            MOVE.B  (A0)+,D4                ; GRAB THE FIRST PIXEL
            SWAP.W  D4
            CLR.L   D5
            MOVE.L  D4, D5
            CLR.L   D4
            MOVE.B  (A0)+, D4               ; GRAB NEXT MEMORY BIT
            LSL     #8, D4                  ; SHIFT LEFT TO GET PIXEL IN TOP
            ADD.L   D4, D5                  ; COMBINE THE DATA
            CLR.L   D4
            MOVE.B  (A0)+, D4               ; GET LAST BIT NEEDED
            ADD.L   D4, D5                  ; GET THE PIXEL VALUE
            CLR.L   D4                      ; IF PIXEL IS PINK, DO NOT DRAW IT
            MOVE.B  $FF, D4
            SWAP    D4
            MOVE.B  $FF, D4
            CMP     D4, D5
            BEQ     .INCREMENT
            BRA     .DRAWPIXEL              ; PIXEL CAN BE PRINTED
.INCREMENT
            CLR.L   D4
            ADD.W   #1,D6
            ; CHECK FOR END OF X ROW
            MOVE.L  16(SP), D4
            ADD.L   D6, D4
            MOVE.L  32(SP), D5
            CMP     D5, D4
            BEQ     .INCREMENTY
            MOVE.L  8(SP), D4               ; STORE WIDTH OF IMAGE
            CMP     D4, D6                  ; SEE IF COUNTER IS BEYOND X BOUNDS
            BNE     .INNERLOOP              ; IF IT IS NOT, LOOP AGAIN
            ; SKIP AFTER OUTSIDE OF BOX ON X AXIS
            CLR.L   D4
            MOVE.L  16(SP), D4
            ADD.L   8(SP), D4
            CLR.L   D5
            MOVE.L  32(SP), D5
            SUB.L   D4, D5
            MULU.W  #3, D5
            ; ADD OFFSET TO ADDRESS
            ADD.L   D5, A0
.INCREMENTY
            ADD.L   PADDING, A0
            SUB.W   #1, D3
            BNE     .OUTERLOOP
            RTS
.DRAWPIXEL
            MOVE.L  D5, D1
            MOVE.L  #80, D0
            TRAP    #15                     ; SET PEN COLOR
            MOVE.L  24(SP), D1              ; STORE THE STARTING X POSITION
            ADD.L   D6, D1
            MOVE.L  28(SP), D2              ; START AT TOP OF CHUNK
            ADD.L   D3, D2
            MOVE.L  #82, D0
            TRAP    #15                     ; DRAW PIXEL AT POSITION
            BRA     .INCREMENT              ; INCREMENT POSITION

; --- BMP INCLUDES ------------------------------------------------------------

GAMEOVERIMG
    INCBIN "GAMEOVER.BMP"
LOADINGIMG
    INCBIN "LOADING.BMP"
TITLEIMG
    INCBIN "TITLE.BMP"

*~font name~courier new~
*~font size~10~
*~tab type~1~
*~tab size~8~
