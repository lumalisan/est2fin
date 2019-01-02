; =============================================================================
; SYSTEM MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZES THE SYSTEM
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS
            JSR     KBDINIT                 ; INIT KEYBOARD
            JSR     SCRINIT                 ; INIT SCREEN
            JSR     DMMINIT                 ; INIT DYNAMIC MEMORY
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER
            MOVE.L  A0,-(A7)                ; PUT RETURN ADDRESS
            RTS

; =============================================================================
; SCREEN MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INITIALIZES THE SCREEN, SCREEN-RELATED INTERRUPT AND VARS.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0,D1,D2,D3
; -----------------------------------------------------------------------------
            ; - DISABLE INTS (SET INT BITS IN SR TO 111)

            OR.W    #%0000011100000000,SR

            ; - DISABLE ALL AUTO-IRQ (SEE TRAP #15 TASK 32)

            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #0,D2
            TRAP    #15

            ; - INSTALL SCRUPD INTO TRAP SCRTRAP

            MOVE.L  #SCRUPD,($80+4*SCRTRAP)

            ; - SET RESOLUTION TO SCRWIDTH X SCRHEIGHT

            MOVE.B  #33,D0
            MOVE.L  #(SCRWIDTH*$10000+SCRHEIGH),D1
            TRAP    #15

            ; - SET WINDOWED MODE

            MOVE.L  #1,D1
            TRAP    #15

            ; - CLEAR VISIBLE BUFFER

            MOVE.B  #11,D0
            CLR.L   D1
            MOVE.W  #$FF00,D1
            TRAP    #15

            ; - ENABLE DOUBLE BUFFER

            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15                     ;AHORA DIBUJAMOS EN EL HIDD. BUFF.

            ; - CLEAR HIDDEN BUFFER

            MOVE.B  #11,D0
            CLR.L   D1
            MOVE.W  #$FF00,D1
            TRAP    #15

            ; - INSTALL SCRISR FOR IRQ SCRIRQ (IRQ INTERRUPT VECTOR BEGINS
            ;   AT $60. INSTALLATION IS SIMILAR TO TRAP INSTALLATION)

            MOVE.L  #SCRISR,($60+4*SCRIRQ)

            ; - ENABLE AUTO-IRQ EVERY SCRTIM MS FOR IRQ SCRIRQ (SEE TRAP #15
            ;   TASK 32)

            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.L  #SCRTIM,D3
            MOVE.B  #%10000000,D2
            OR.B    #SCRIRQ,D2
            TRAP    #15

            ; - CLEAR SCRINTCT AND SCRCYCCT

            CLR.B   SCRINTCT
            CLR.B   SCRCYCCT

            ; - ENABLE INTS (SET INT BITS IN SR TO 000)

            AND.W #%1111100011111111,SR

            RTS

; -----------------------------------------------------------------------------
SCRISR
; SCREEN TIMER ISR. INCREASES THE INTERRUPT COUNTER AND UPDATES DOUBLE BUFFER.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)           ; UPDATE INT FLAG/COUNTER
            ADDQ.B  #1,(SCRCYCCT)           ; UPDATE CYCLE COUNTER
            RTE

; -----------------------------------------------------------------------------
SCRUPD
; TRAP SERVICE ROUTINE IN CHARGE OF VISUALIZING CURRENT FRAME AND CLEARING
; BUFFER FOR THE NEXT ONE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE DOUBLE BUFFER AND CLEAR HIDDEN BUFFER

            MOVEM.L D0-D1,-(SP)             ; SAVE REGISTERS

            MOVE.B  #94,D0                  ; DISPLAY HIDDEN BUFFER
            TRAP    #15

            MOVE.B  #11,D0                  ; CLEAR HIDDEN BUFFER
            CLR.L   D1
            MOVE.W  #$FF00,D1
            TRAP    #15

            MOVEM.L (SP)+,D0-D1             ; RESTORE REGISTERS
            RTE

; =============================================================================
; KEYBOARD MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INITIALIZES THE SYSTEM VARIABLES KBDSYS AND KBDVAL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (KBDVAL)                ; INIT VARS
            CLR.B   (KBDEDGE)
            MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALL
            RTS

; -----------------------------------------------------------------------------
KBDREAD
; TRAP SERVICE ROUTINE.
; UPDATES THE SYSTEM VARIABLES KBDEDGE AND KBDVAL ACCORDING TO THE BITFIELD
; DESCRIBED IN SYSCONST. KBDVAL HOLDS THE CURRENT VALUES AND KBDEFGE HOLDS
; RISING EDGES FROM PREVIOUS CALL TO THE CURRENT ONE.
; INPUT    - NONE
; OUTPUT   - (KBDVAL) AND (KBDEDGE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE KBDVAL AND KBDEDGE

            MOVEM.L D0-D3,-(SP)             ; SAVE REGISTERS

            CLR.L   D2                      ; USE D2 TO STORE BITS
            CLR.L   D3                      ; USE D3 TO STORE OLD VALUES
            MOVE.B  (KBDVAL),D3

            MOVE.B  #19,D0                  ; SET TASK NUMBER
            
.READSET1   ; MONITOR FIRST 4 KEYS
            MOVE.L  #KBDCHRSP<<24+KBDCHRMK<<16+KBDCHRSH<<8+KBDCHRPK,D1
            ;MOVE.L  #$20<<24+'M'<<16+$10<<8+'P',D1
            TRAP    #15
.READSP     BTST.L  #24,D1                  ; TEST FOR SPACE
            BEQ     .READM
            BSET.L  #KBDBITF1,D2
.READM      BTST.L  #16,D1                  ; TEST FOR M
            BEQ     .READSH
            BSET.L  #KBDBITF2,D2
.READSH     BTST.L  #8,D1                   ; TEST FOR SHIFT
            BEQ     .READP
            BSET.L  #KBDBITF3,D2
.READP      BTST.L  #0,D1                   ; TEST FOR P
            BEQ     .READSET2
            BSET.L  #KBDBITPS,D2
            BRA     .READSET2

.READSET2   ; MONITOR SECOND 4 KEYS
            MOVE.L  #KBDCHRLF<<24+KBDCHRUP<<16+KBDCHRRT<<8+KBDCHRDN,D1
            ;MOVE.L  #$25<<24+$26<<16+$27<<8+$28,D1
            TRAP    #15
.READLEFT   BTST.L  #24,D1                   ; TEST FOR LEFT
            BEQ     .READUP
            BSET.L  #KBDBITLF,D2
.READUP     BTST.L  #16,D1                  ; TEST FOR UP
            BEQ     .READRIGH
            BSET.L  #KBDBITUP,D2
.READRIGH   BTST.L  #8,D1                   ; TEST FOR RIGHT
            BEQ     .READDOWN
            BSET.L  #KBDBITRT,D2
.READDOWN   BTST.L  #0,D1                   ; TEST FOR DOWN
            BEQ     .CONT
            BSET.L  #KBDBITDN,D2
            
.CONT       MOVE.B  D2,(KBDVAL)             ; STORE KEYBOARD VALUES
            EOR.B   D2,D3                   ; CHECK FOR CHANGES
            MOVE.B  D3,(KBDEDGE) 

            MOVEM.L (SP)+,D0-D3             ; RESTORE REGISTERS
            RTE

; =============================================================================
; DYNAMIC MEMORY MANAGEMENT (SYSTEM CODE)
; DYNAMIC MEMORY IS A SET OF DMMBNUM SLOTS OF DMMBSIZE BYTES EACH ONE.
; DMMBSIZE MUST BE POWER OF TWO. A SLOT HAS:
; - HEADER - 1 WORD. SPECIFIES THE OWNER (0 MEANS OWNED BY SYSTEM)
; - DATA   - DMMBSIZE - 2 BYTES. MAY CONTAIN VARS AND ANY KIND OF DATA RELATED
;            THE THE OWNER. IF OWNER==0, DATA IS MEANINGLESS.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INITIALIZES THE DYNAMIC MEMORY TO ALL OWNED BY SYSTEM.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; SEARCHES THE FIRST MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - NONE
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; SEARCHES THE NEXT MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM

; -----------------------------------------------------------------------------
DMMFRSTO
; SEARCHES THE FIRST MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; SEARCHES THE NEXT MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
;            A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; SEARCHES THE FIRST FREE (SYS OWNED) SLOT, ASSIGNS TO THE SPECIFIED OWNER
; AND RETURNS A POINTER TO THE CORRESPONDING DATA (SLOT ADDRESS + 2)
; INPUT    - D0.W : ID TO ASSIGN
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FREE SPACE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; FREES THE SLOT TO WHICH THE PROVIDED POINTER BELONGS BY SETTING ITS OWNED TO
; SYSTEM (0)
; INPUT    - A0   : POINTER BELONGING TO THE SLOT TO FREE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
