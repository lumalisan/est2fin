; =============================================================================
; IMAGE MANAGEMENT
; =============================================================================

;EQUS FOR TRAP CODE CALLS


DRAWCHUNK
;READS IN FILE INFORMATION AND USER INPUT
;AND SETS THE VARIABLES AT THE BOTTOM AND ON STACK
;WHICH WILL BE USED TO DRAW THE CHUNK OF THE BMP FILE

        MOVE.L  4(SP), A0               ;STORE THE POINTER TO THE IMAGE DATA INTO AN ADDRESS FOR ACCESS
        MOVE.L  10(A0), D0              ;GRAB THE OFFSET FROM HEADER TO PIXELS
        ROL.W   #8, D0                  ;ROTATE THE WORD BY 8 TO MOVE OFFSET TO APPROPRIATE POSITION
        SWAP    D0                      ;NOW SWAP THE WORDS OF THE OFFSET FOR THE NEXT ROTATE
        ROL.W   #8, D0                  ;FINALLY ROTATE THE WORDS ONE TIME TO MAKE THE TRUE OFFSET VALUE READABLE
        ADD.W   D0, A0                  ;CHANGE POSITION IN MEMORY TO PIXEL DATA

        *CALCULATE BEGINNING POSITION OF CHUNK TO DRAW FROM Y POSITION
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
        *SET POSITION IN ADDRESS AT THE BEGINNING OF CHUNK DRAW
        ADD.L   D5, A0
        ADD.L   D5, A0
        ADD.L   D5, A0
        MOVE.L  12(SP), D3

OUTERLOOP
        MOVE.W  #0, D6                  ;SET OR RESET X COUNTER FOR FOR LOOP
        MOVE.L  16(SP), D4
        MULU.W  #3, D4
        ADD.W   D4, A0                  ;ADD START OF X TO 0

INNERLOOP
        CLR.L   D4                      ;MAKE SURE D4 HAS NOTHING IN IT
        MOVE.B  (A0)+,D4                ;GRAB THE FIRST PIXEL
        SWAP.W  D4                      ;SWAP THE PIXEL TO CHANGE ITS POSITION IN MEMORY FOR THE REST OF THE PIXEL DATA
        CLR.L   D5                      ;MAKE SURE D5 IS ALSO CLEAR
        MOVE.L  D4, D5                  ;STORE PREVIOUSLY FOUND PIXEL DATA IN D5 FOR NEXT VALUE
        CLR.L   D4                      ;CLEAR D4 FOR THE NEXT BIT OF MEMORY
        MOVE.B  (A0)+, D4               ;GRAB NEXT MEMORY BIT
        LSL     #8, D4                  ;SHIFT LEFT TO GET PIXEL IN TOP OF SECOND WORD TO COMBINE WITH PREVIOUS PIXEL BIT
        ADD.L   D4, D5                  ;COMBINE THE DATA
        CLR.L   D4                      ;CLEAR D4 ONCE AGAIN
        MOVE.B  (A0)+, D4               ;GET LAST BIT NEEDED
        ADD.L   D4, D5                  ;COMBINE IT TO THE END OF THE PREVIOUS TWO BITS TO GET THE PIXEL VALUE


        CLR.L   D4                      ;IF PIXEL IS PINK, DO NOT DRAW IT
        MOVE.B  $FF, D4
        SWAP    D4
        MOVE.B  $FF, D4

        CMP     D4, D5
        BEQ     INCREMENT
        BRA     DRAWPIXEL               ;PIXEL MEETS CRITERIA AND CAN BE PRINTED

INCREMENT
        CLR.L   D4                      ;MAKE SURE D4 IS EMPTY FOR USE
        ADD.W   #1,D6                   ;INCREMENT X COUNTER BY ONE

        *CHECK FOR END OF X ROW
        MOVE.L  16(SP), D4
        ADD.L   D6, D4
        MOVE.L  32(SP), D5
        CMP     D5, D4
        BEQ     INCREMENTY

        MOVE.L  8(SP), D4               ;MOVE WIDTH OF IMAGE INTO REGISTER
        CMP     D4, D6                  ;SEE IF COUNTER IS BEYOND X BOUNDS
        BNE     INNERLOOP               ;IF IT IS NOT, LOOP AGAIN

        ;SKIP AFTER OUTSIDE OF BOX ON X AXIS
        CLR.L   D4
        MOVE.L  16(SP), D4
        ADD.L   8(SP), D4
        CLR.L   D5
        MOVE.L  32(SP), D5
        SUB.L   D4, D5
        MULU.W  #3, D5
        ;ADD OFFSET TO ADDRESS
        ADD.L   D5, A0

INCREMENTY
        ;TAKE CARE OF PADDING
        ADD.L   PADDING, A0             ;ADD PADDING.  IF THERE IS NONE, THE ADDRESS WON'T SKIP ANYTHING

        SUB.W   #1, D3                  ;DECREMENT Y COUNTER TO SEE IF YOU ARE OUT OF THE Y ITERATION
        BNE     OUTERLOOP               ;IF IT IS NOT, LOOP BACK TO OUTER LOOP
        BRA     ENDROUTINE              ;BRANCH TO END OF SUBROUTINE, WHOLE IMAGE HAS BEEN ITERATED

DRAWPIXEL
        MOVE.L  D5, D1                  ;MOVE PIXEL DATA INTO D1 FOR PEN COLOR
        MOVE.L  #80, D0       ;SET TRAP CODE FOR SETTING THE PEN COLOR
        TRAP    #15                     ;SET PEN COLOR

        MOVE.L   24(SP), D1             ;STORE THE STARTING X POSITION OF THE CHUNK
        ADD.L    D6, D1                 ;ADD ITERATION POSITION OF X TO START OF CHUNK

        MOVE.L  28(SP), D2              ;START AT TOP OF CHUNK TO FLIP IMAGE
        ADD.L   D3, D2                  ;SUBTRACT CURRENT Y POSITION
        MOVE.L  #82, D0      ;SET TRAP CODE TO DRAW PIXEL AT POSITION
        TRAP    #15                     ;DRAW PIXEL AT POSITION

        BRA     INCREMENT               ;INCREMENT POSITION

ENDROUTINE
        ;MOVEM.L (A7)+,A0/D0-D7
        RTS                             ;BRANCH BACK TO END OF PROGRAM

DRAWIMAGE
        ;MOVEM.L A0/D0-D7,-(A7)
*...
*SETUP BEFORE SUBROUTINE
*...'
        *RESET PADDING FOR MULTIPLE CALLS
        MOVE.L  #0, PADDING

        MOVE.L  #36, D0                 ;NUMBER OF 7 4 BYTE ARGUMENTS TO PREPARE STACK TO RECEIVE
        SUB.L   D0, SP                  ;PREPARE STACK TO RECEIVE ARGUMENTS

        MOVE.L  A0, (SP)                ;LOAD POINTER TO THE .BMP FILE ONTO THE STACK

        ;STORE WIDTH OF CHUNK ON THE STACK
        MOVE.L  D1, 4(SP)
        ;STORE HEIGHT OF THE CHUNK ON THE STACK
        MOVE.L  D2, 8(SP)

        ;ADD START OF CHUNK TO MOVE WITH IMAGE
        MOVE.L   D5, 12(SP)             ;STORE TOP LEFT X OF DRAW CHUNK ON STACK

        ;SUBTRACT Y POSITION FROM HEIGHT TO GET START Y
        MOVE.L  D6, 16(SP)              ;STORE TOP LEFT Y OF DRAW CHUNK ON STACK

        MOVE.L  D3, 20(SP)              ;STORE BEGINNING PRINT LOCATION FOR X AXIS ON STACK
        MOVE.L  D4, 24(SP)              ;STORE BEGINNING PRINT LOCATION FOR Y AXIS ON STACK

        MOVE.L  18(A0), D1              ;GET WIDTH OF IMAGE FROM .BMP FILE
        ROL.W   #8, D1
        SWAP    D1
        ROL.W   #8, D1                  ;ROTATE AND SWAP LONG WORD TO GET TRUE WIDTH VALUE TO USE LATER
        MOVE.L  D1, 28(SP)              ;STORE WIDTH OF IMAGE TO MAKE VARIABLE NOT GLOBAL


        ;CALCULATE FOR PADDING.
        ;THIS ONLY CONCERNS WIDTH
        MOVE.L  #4, D2                  ;MOVE 4 INTO REGISTER FOR PADDING CALCULATION
        MULU.W  #3, D1                  ;MULTIPLY IMAGE WIDTH BY 3 FOR FORMULA
        DIVU.W  #4, D1                  ;DIVIDE BY FOUR TO FIND REMAINDER
        SWAP    D1                      ;SWAP REMAINDER INTO LOWER WORD
        CLR.L   D4                      ;MAKE SURE D4 IS EMPTY
        MOVE.W  #0, D4                  ;MOVE 0 INTO D4
        CMP.W   D1, D4                  ;IF EQUAL, THERE IS NO PADDING
        BEQ     RUNPROGRAM              ;CONTINUE IN PROGRAM FOR SPECIAL CASE OF BEING DIVISIBLE BY 4

ACCOUNTFORPADDING
        SUB.W   D1, D2                  ;SUBTRACT REMAINDER FROM 4 TO GET PADDING
        MOVE.L  D2, PADDING             ;STORE PADDING FOR LATER USE


RUNPROGRAM
        MOVE.L  22(A0), D2              ;GET HEIGHT OF IMAGE FROM .BMP FILE
        ROL.W   #8, D2
        SWAP    D2
        ROL.W   #8, D2                  ;ROTATE AND SWAP LONG WORD TO GET TRUE HEIGHT VALUE TO USE LATER
        MOVE.L  D2, 32(SP)              ;STORE HEIGHT OF IMAGE TO MAKE VARIABLE NOT GLOBAL

        JSR     DRAWCHUNK               ;CALL SUBROUTINE TO DRAW CHUNK OF IMAGE

        CLR.L   D0
        MOVE.L  #36, D0
        ADD.L   D0, SP                  ;FIX STACK

        CLR.L   D7
        ;MOVEM.L (A7)+,A0/D0-D7
        RTS

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
