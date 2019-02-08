; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWUPD
; UPDATES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1-A3,-(A7)
            MOVE.B  (SCRCYCCT),D0
            AND     #$3F,D0                 ; EVERY 64 CYCLES #$3F
                                            ; EVERY 16 CYCLES #$0F
                                            ; EVERY 32 CYCLES #$1F
            BNE     .END                    ; CREATE A NEW ENEMY
            LEA     ENINIT,A1
            LEA     ENUPD,A2
            LEA     ENPLOT,A3
            MOVE.W  #ENTYPE,D0
            JSR     AGLADD
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
