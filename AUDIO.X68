; =============================================================================
; AUDIO MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
AUDINIT
; INITALIZES THE AUDIO MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A2,-(A7)
            LEA     .AUDLIST,A0
            LEA     .IDLIST,A2
.LOOP       MOVE.L  (A0)+,D0                ; LOAD AUDIO MUSIC FILES
            BEQ     .END
            MOVE.B  (A2)+,D1
            MOVE.L  D0,A1
            MOVE.B  #71,D0
            TRAP    #15
            BRA     .LOOP
.END        MOVEM.L (A7)+,D0-D1/A0-A2
            RTS
.AUDLIST    DC.L    .MUSIC1,.MUSIC2,0
.MUSIC1     DC.B    'SOUND/MUSIC1.WAV',0
.MUSIC2     DC.B    'SOUND/MUSIC2.WAV',0
.IDLIST     DC.B    ID0, ID1
            DS.W    0

; -----------------------------------------------------------------------------
AUDPLAY
; CHANGES AUDIO TO PLAY (USES DIRECTX PLAYER)
; INPUT    - D1.B   BIT 7 = 1 LOOP, BIT 7 = 0 PLAY ONLY ONCE
;                   BITS 6-0 SOUND ID
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2,-(A7)
            CLR.L   D2
            BCLR    #7,D1                   ; CLEAR MSB AND CHECK
            BEQ     .CONT                   ; IF ZERO, CONTINUE
            ADDQ.W  #1,D2                   ; IF ONE, ACTIVATE LOOP
.CONT       MOVE.B  #76,D0                  ; SELECT DIRECTX PLAYER
            TRAP    #15                     ; AND PLAY
.DONE       MOVEM.L (A7)+,D0-D2
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
