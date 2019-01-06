*-----------------------------------------------------------
* Title      : Programa de Prueba Inicial
* Written by : Lisandro Rocha
* Date       : 15/11/18
* Description: Pequeï¿½a introducciï¿½n a la prï¿½ctica final
*-----------------------------------------------------------
    ORG    $1000

; -----------------------------------------------------------------------------
DRAWPIX     MACRO
; Draw a pixel on the specified coordenates
; Input     - \1 Left X
;           - \2 Upper Y
;           - \3 Right X
;           - \4 Lower Y
;           - \4 Color in hex
;           - D5.W Movement in Y
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
            SUB.W   D5,D2
            MOVE.W  #\3,D3
            MOVE.W  #\4,D4
            SUB.W   D5,D4
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
;           - \4 Color in hex
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


PRINT:
            MOVEM.L D0/A1,-(SP)
            MOVE.B  #14,D0
            LEA     HELLO,A1
            TRAP    #15
            MOVEM.L (SP)+,D0/A1
            RTS

TAKEINPUT:
            MOVEM.L D0-D4,-(SP)
            MOVE.B  #19,D0                  ;Put key code in D1.L
            CLR.L   D1
            MOVE.L  #' '<<24,D1             ;Check for keypress
            TRAP    #15
            BTST.L  #24,D1
            IF <NE> THEN                    ;if ' '
              DRAWSQ  0,0,640,480,WHITE
              BSR     DRAWFLOOR
              ADD.W   #10,D5
            ENDI
            MOVEM.L (SP)+,D0-D4
            RTS

WAIT:
            MOVEM.L D0-D2,-(SP)
            MOVE.L  #8,D0		;Get time since midnight
            TRAP    #15
            MOVE.L  D1,D2
.TIMELOOP
            MOVE.B  #23,D0		;Delay n/100 sec to reduce cpu load
            MOVE.L  #1,D1		;Delay amount 1/100 sec
            TRAP    #15		;Execute delay
            MOVE.L  #8,D0		;Get time since midnight
            TRAP    #15                     ;Limit Framerate.
            SUB.L   D2,D1
            CMP     #15,D1
            BLT     .TIMELOOP
            MOVEM.L (SP)+,D0-D2
            RTS

DRAWTREX:
            MOVEM.L D0-D4,-(SP)
            ;Draw t-rex with 5x5 pixels
            ;Patita izq.
            DRAWPIX 150,455,155,470,BLACK
            DRAWPIX 150,450,155,455,OLIVE
            DRAWPIX 150,415,155,450,BLACK
            ;Colita
            DRAWPIX 145,450,150,455,BLACK
            DRAWPIX 145,445,150,450,OLIVE
            DRAWPIX 140,445,145,450,BLACK
            DRAWPIX 140,440,150,445,BLACK
            ;Parte sombra
            DRAWPIX 155,415,160,460,OLIVE
            ;Parte contorno
            DRAWPIX 155,460,160,465,BLACK
            DRAWPIX 160,455,185,460,BLACK
            DRAWPIX 170,460,180,465,BLACK
            DRAWPIX 170,465,175,470,BLACK
            DRAWPIX 180,450,185,455,BLACK
            DRAWPIX 180,445,200,450,BLACK
            DRAWPIX 200,415,205,445,BLACK
            DRAWPIX 155,410,200,415,BLACK
            DRAWPIX 160,420,170,430,BLACK
            ;Parte interior
            DRAWPIX 160,415,170,420,LIME
            DRAWPIX 170,415,200,445,LIME
            DRAWPIX 160,430,170,445,LIME
            DRAWPIX 160,445,165,455,LIME
            DRAWPIX 165,445,180,455,YELLOW
            MOVEM.L (SP)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
DRAWCACT
; DRAW THE CACTUS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(SP)

            ; BRAZO IZQ.
            DRAWPIX 0,390,5,420,GREEN
            DRAWPIX 5,420,10,425,GREEN
            DRAWPIX 10,425,15,430,GREEN
            DRAWPIX 5,385,10,390,GREEN
            DRAWPIX 5,390,10,420,OLIVE
            DRAWPIX 10,415,15,425,OLIVE
            DRAWPIX 15,420,25,430,OLIVE
            DRAWPIX 10,390,15,415,GREEN
            DRAWPIX 15,415,20,420,GREEN
            ; PUNTITA MEDIO
            DRAWPIX 20,420,25,385,GREEN
            DRAWPIX 20,430,25,470,GREEN
            DRAWPIX 15,430,20,435,GREEN
            DRAWPIX 25,385,35,470,OLIVE
            DRAWPIX 25,380,35,385,GREEN
            DRAWPIX 35,385,40,425,GREEN
            DRAWPIX 35,395,40,470,GREEN
            ; BRAZO DERECHO
            DRAWPIX 35,425,45,435,OLIVE
            DRAWPIX 40,420,45,425,GREEN
            DRAWPIX 40,435,45,440,GREEN
            DRAWPIX 45,430,50,435,GREEN
            DRAWPIX 50,425,55,430,GREEN
            DRAWPIX 55,400,60,425,GREEN
            DRAWPIX 50,400,55,425,OLIVE
            DRAWPIX 50,395,55,400,GREEN
            DRAWPIX 45,400,50,420,GREEN
            DRAWPIX 45,420,50,430,OLIVE

            MOVEM.L (SP)+,D0-D4
            RTS

DRAWFLOOR:
            MOVEM.L D0-D4,-(SP)
            ;Draw the floor rectangle
            DRAWSQ  -1,470,640,480,BLACK
            MOVEM.L (SP)+,D0-D4
            RTS

SETWINDOW:
            MOVEM.L D0-D4,-(SP)
            MOVE.L  #640*$10000+480,D1
            MOVE.B  #33,D0
            TRAP    #15
            MOVEM.L (SP)+,D0-D4
            RTS

START:
            ;Set screen resolution
            BSR     SETWINDOW
            ;Enable double buffer
            MOVE.B  #17, D1
            MOVE.B  #92, D0
            TRAP    #15
            ;Set the screen color to white
            DRAWSQ  0,0,640,480,WHITE
            ;Draw the floor
            BSR     DRAWFLOOR
.GAMELOOP
            BSR     WAIT
            ;Check if the user press spacebar
            BSR     TAKEINPUT
            ;Draw the t-rex, this subroutine receives in D5.W the actual Y pos
            ;of the player
            BSR     DRAWTREX
            BSR     DRAWCACT
            ;Draw some obstacles
            ;BSR     DRAWTHINGS
            MOVE.B  #94, D0
            TRAP    #15                     ;Paint screen: double buffer
            BRA     .GAMELOOP

    SIMHALT

HELLO       DC.B    'Welcome to the T-Rex game!',0
WHITE       EQU     $00FFFFFF
BLACK       EQU     $00000000
OLIVE       EQU     $000E9274
LIME        EQU     $001BBF9A
YELLOW      EQU     $0058F5D8
GREEN       EQU     $00008000


    END    START
