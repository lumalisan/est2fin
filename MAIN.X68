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
            BNE     .CONT
            JSR     UTLGETC                 ; IF PRESSED, GET CYCLES
           
.CONT       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD                  ; UPDATE DEPENDING ON THE STATE
            TST.B   (PRESSED)
            BNE     .WINT
            JSR     UTLCOUNT                ; IF PRESSED, CALCULATE CYCLES
            JSR     UTLHW
            BRA     .WINT            

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            TST.B   (PRESSED)
            BEQ     .CONT2
            JSR     UTLGETC                 ; IF NOT PRESSED, GET CYCLES
            
.CONT2      JSR     STAPLOT                 ; PLOT DEPENDING ON THE STATE
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            TST.B   (PRESSED)
            BEQ     .LOOP
            JSR     UTLCOUNT                ; IF NOT PRESSED, CALCULATE CYCLES
            JSR     UTLHW
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
