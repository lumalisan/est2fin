; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- TRAP RELATED CONSTANTS --------------------------------------------------

KBDTRAP     EQU     0                       ; KEYBOARD UPDATE TRAP
SCRTRAP     EQU     1                       ; SCREEN REFRESH TRAP

; --- KEY CODES (EASy68K)

KBDCHRSP    EQU     $20                     ; SPACE KEY

; --- KEYBOARD MAPPING --------------------------------------------------------

KBDFIRE1    EQU     KBDCHRSP                ; FIRE 1 (SPACE) BUTTON

; --- KEYBOARD BITFIELD MASKS -------------------------------------------------
; CONVENIENCE CONSTANTS TO ACCESS THE FOLLOWING BIT-FIELD.
; THIS BIT-FIELD IS USED BY SYSTEM VARS (KBDVAL) AND (KBDEDGE).
; +---+---+---+---+---+---+---+---+
; | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
; +---+---+---+---+---+---+---+---+
;   |   |   |   |   |   |   |   |
;   |   |   |   |   |   |   |   +---------- LEFT BUTTON
;   |   |   |   |   |   |   +-------------- UP BUTTON
;   |   |   |   |   |   +------------------ RIGHT BUTTON
;   |   |   |   |   +---------------------- DOWN BUTTON
;   |   |   |   +-------------------------- FIRE 1 BUTTON
;   |   |   +------------------------------ FIRE 2 BUTTON
;   |   +---------------------------------- FIRE 3 BUTTON
;   +-------------------------------------- PAUSE BUTTON

KBDMSKLF    EQU     %00000001
KBDMSKUP    EQU     %00000010
KBDMSKRT    EQU     %00000100
KBDMSKDN    EQU     %00001000
KBDMSKF1    EQU     %00010000
KBDMSKF2    EQU     %00100000
KBDMSKF3    EQU     %01000000
KBDMSKPS    EQU     %10000000

; --- KEYBOARD BITFIELD POSITIONS ---------------------------------------------

KBDBITLF    EQU     0
KBDBITUP    EQU     1
KBDBITRT    EQU     2
KBDBITDN    EQU     3
KBDBITF1    EQU     4
KBDBITF2    EQU     5
KBDBITF3    EQU     6
KBDBITPS    EQU     7

; --- SCREEN RELATED CONSTANTS ------------------------------------------------

SCRWIDTH    EQU     640                     ; SCREEN WIDTH (PIXELS)
SCRHEIGH    EQU     480                     ; SCREEN HEIGHT (PIXELS)
SCRIRQ      EQU     1                       ; SCREEN INTERRUPT NUMBER
SCRTIM      EQU     20                      ; SCREEN TIMER (MS)

; --- DYNAMIC MEMORY CONSTANTS ------------------------------------------------

DMMBSIZE    EQU     64                      ; BLOCK SIZE (BYTES). POWER OF TWO
DMMBNUM     EQU     50                      ; NUMBER OF BLOCKS
DMMSYSID    EQU     0                       ; SYSTEM OWNER ID (MUST BE 0)
