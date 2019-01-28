; =============================================================================
; TITLE    : EXAMPLE GAME - TOTALLY NOT GOOGLE CHROME'S DINOSAUR
; AUTHORS  : IZAR CASTORINA & LISANDRO ROCHA
; CREATION : 15/11/18
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; USER CONSTANTS
            INCLUDE "UTIL.X68"              ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT
            INCLUDE "BACKGRND.X68"          ; BACKGROUND SUBROUTINES
            INCLUDE "ENEMY.X68"             ; ENEMY AGENT MANAGEMENT
            INCLUDE "SPAWNER.X68"           ; SPAWNER (CREATES ENEMIES)
            INCLUDE "STATES.X68"            ; GAME STATES MANAGEMENT
            ; TO DO: PUT YOUR GAME-RELATED INCLUDES HERE

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM CODE
            JSR     STAINIT                 ; INITIALIZE GAME STATE
            ; TO DO: CALL GAME INITIALIZATION CODE HERE

; --- UPDATE ------------------------------------------------------------------

.LOOP       TST.B   (PRESSED)
            BEQ     .CONT
            JSR     UTLGETC
           
.CONT       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD                  ; UPDATE DEPENDING ON THE STATE
            TST.B   (PRESSED)
            BEQ     .WINT
            JSR     UTLCOUNT
            BRA     .WINT            

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            TST.B   (PRESSED)
            BNE     .CONT2
            JSR     UTLGETC
            
.CONT2      JSR     STAPLOT                 ; PLOT DEPENDING ON THE STATE
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            TST.B   (PRESSED)
            BNE     .LOOP
            JSR     UTLCOUNT
            
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
