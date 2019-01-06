; =============================================================================
; AGENT MANAGEMENT - CODE SHARED BY PLAYER AND ENEMIES
;
; AN AGENT DATA BLOCK HAS THE FOLLOWING STRUCTURE.
; PROVIDED NAMES REFERS TO THE OFFSET (SEE CONST.X68) TO ACCESS THE FIELD.
;
; * VARIABLES. VALUES THAT THE AGENT CAN CHANGE DURING EXECUTION
;   - AGNFRAOF (WORD) THE GRAPHIC ID IF THE BASE FRAME TO PLOT. ONLY TWO FRAME
;                     ANIMATIONS ARE ALLOWED, THE SECOND FRAME BEING THIS ONE
;                     PLUS ONE.
;   - AGNPOXOF (WORD) THE X POSITION IN PIXELS.
;   - AGNPOYOF (LONG) THE Y POSITION IN PIXELS. FIXED POINT 16.16
;   - AGNSPYOF (LONG) THE Y SPEED IN PIXELS PER FRAME. FIXED POINT 16.16
;
; * COMMANDS. VALUES PROVIDED TO THE AGENT FOR IT TO ACT ACCORDING TO THEM
; OFFSETS TO AGENT COMMANDS
;   - AGNMOTOF (BYTE) DESIRED MOTION IN THE SAME FORMAT THAT KBDVAL
;
; * PARAMETERS. VALUES FIXED FOR A GIVEN AGENT
;   - AGNTYPOF (BYTE) SUBTYPE OF THE AGENT. THIS ALLOWS A SECOND CATEGORIZATION
;                     OTHER THAN THE ONE PROVIDED BY THE OWNER.
;   - AGNFRMOF (LONG) FRAME TO SHOW WHEN THE AGENT MOVES LEFT (HIGH WORD) AND
;                     RIGHT (LOW WORD)
; =============================================================================

; -----------------------------------------------------------------------------
AGNGRAV
; APPLIES GRAVITY TO AGENT.
; INPUT    - A2 POINTER TO AGENT DATA BLOCK
; OUTPUT   - THE AGENT DATA IS PROPERLY UPDATED
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D4/D7,-(A7)
            JSR     AGNACC                  ; ACCELERATE
            AND.B   #KBDMSKUP|KBDMSKDN,D7   ; FILTER UP/DOWN ONLY
            TST.B   D7                      ; OBSTACLES TOUCHED?
            BEQ     .END                    ; NO: END
            BTST    #KBDBITUP,D7            ; OBSTACLE UP?
            BNE     .ADJTOP                 ; YES: ADJUST Y COORDINATE
.ADJBOT     CLR.L   AGNSPYOF(A2)            ; SPEED TO ZERO
            BRA     .END
.ADJTOP     MOVE.L  #1,AGNSPYOF(A2)         ; SET SPEED CLOSE TO ZERO
.END        MOVEM.L (A7)+,D4/D7
            RTS

; -----------------------------------------------------------------------------
AGNACC
; APPLIES VERTICAL ACCELERATION TO AN AGENT AND CHECKS OBSTACLES UP AND DOWN.
; INPUT    - A2 POINTER TO AGENT DATA BLOCK
; OUTPUT   - D7.B = 0        -> NO COLLISION
;            D7.B = KBDMSKUP -> TOP COLLISION
;            D7.B = KBDMSKDN -> BOTTOM COLLISION
; MODIFIES - D4,D7
; -----------------------------------------------------------------------------
            MOVEM.L D4-D6,-(A7)
            ADD.L   #AGNGACC,AGNSPYOF(A2)   ; ACCELERATE
            MOVE.L  AGNPOYOF(A2),D4         ; Y COORDINATE
            ADD.L   AGNSPYOF(A2),D4         ; PROPOSE NEW Y
            MOVE.W  AGNPOXOF(A2),D5         ; GET X
            MOVE.L  D4,D6                   ; COPY Y
            SWAP    D6                      ; GET INTEGER PART OF Y
            JSR     AGNOBSV                 ; CHECK OBSTACLES TOP
            TST.B   D7                      ; ARE THERE?
            BNE     .ADJTOP                 ; YES: STATE OBSTACLES TOP
            ADD.W   #AGNHEIGH,D6            ; GO TO AGENT DOWN PART
            JSR     AGNOBSV                 ; CHECK OBSTACLES
            TST.B   D7                      ; ARE THERE?
            BEQ     .STORE                  ; NO: STATE NO OBSTACLES
            MOVE.B  #KBDMSKDN,D7            ; STATE OBSTACLES DOWN
.ADJBOT     AND.L   #~(MAPTILEH-1)<<16,D4   ; IF OBST TOUCHED, ALIGN Y TO IT
            BRA     .STORE
.ADJTOP     MOVE.B  #KBDMSKUP,D7            ; STATE OBSTACLES UP
            AND.L   #~(MAPTILEH-1)<<16,D4   ; IF OBSTACLE TOUCHED, ALIGN THE
            ADD.L   #MAPTILEH<<16,D4        ; INT PART OF Y TO IT
.STORE      MOVE.L  D4,AGNPOYOF(A2)         ; STORE Y
            MOVEM.L (A7)+,D4-D6
            RTS

; -----------------------------------------------------------------------------
AGNPLOT
; PLOTS THE AGENT
; INPUT    - A2 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ONLY WORKS WITH TWO-FRAME ANIMATIONS WHOSE FIRST FRAME IS AT AN
;            EVEN ADDRESS.
; -----------------------------------------------------------------------------
            MOVEM.L D0/D5-D7/A0,-(A7)
            MOVE.W  AGNPOXOF(A2),D5         ; GET AGENT X
            MOVE.W  AGNPOYOF(A2),D6         ; GET AGENT Y (INTEGER PART)
            MOVE.W  AGNFRAOF(A2),D7         ; GET AGENT BASE FRAME
            LEA     GFXLST,A0               ; GET GRAPHICS DATA
            MOVE.B  (GENFRMCT),D0           ; GET OFFSET
            LSR.B   #3,D0
            AND     #1,D0
            OR.B    D0,D7                   ; ADD OFFSET
            JSR     GFXDRIDP                ; PLOT
            MOVEM.L (A7)+,D0/D5-D7/A0
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
