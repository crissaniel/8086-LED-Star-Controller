;==============================================
;CRISSANIEL
;NOVEMBER 04, 2025 
;==============================================
DATA SEGMENT
   ; -- 8255A #1 Addresses --
    PORTA_1     EQU 0C0H        ; 8255 #1 Port A
    PORTB_1     EQU 0C2H        ; 8255 #1 Port B
    PORTC_1     EQU 0C4H        ; 8255 #1 Port C
    COMREG_1    EQU 0C6H        ; 8255 #1 Control Register
    
    COMBYTE_1   EQU 89H   ; 8255 #1 Config: A=Out, B=Out, C=In (Mode 0)

    ; -- 8255A #2 Addresses (Assuming they are mapped consecutively) --
    PORTA_2     EQU 0F0H        ; 8255 #2 Port A
    PORTB_2     EQU 0F2H        ; 8255 #2 Port B
    PORTC_2     EQU 0F4H        ; 8255 #2 Port C
    COMREG_2    EQU 0F6H        ; 8255 #2 Control Register
    
    COMBYTE_2   EQU 80H  ; 8255 #2 Config: A=Out, B=Out, C=Out (Mode 0) 
    
DATA ENDS

CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE, DS:DATA

START:
   MOV AX, DATA
   MOV DS, AX 
   CALL INIT_8255 
   
MAIN_LOOP:
	    MOV DX,  PORTC_1
	    IN AL, DX	
	    CMP AL, 00000000B 
	    JE OFF
	    CMP AL, 00000001B 
	    JE ON 
	    ;PATTERNS
	    CMP AL, 00011011B  
	    JE  LOOPDLOOP
	    CMP  AL, 00001011B 
	    JE ROTATE
	    CMP  AL, 00010011B 
	    JE ALT_SEQ
	    CMP  AL, 00000011B 
	    JE BLINK
	    JMP MAIN_LOOP 
   
 OFF: ;
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	   
	   JMP MAIN_LOOP
	   
 ON: 
	   MOV DX, PORTA_1
	   MOV AL, 11111111B
	   OUT DX, AL
	   
	   MOV DX, PORTB_1
	   MOV AL, 11111111B
	   OUT DX, AL
	   
	    MOV DX, PORTA_2
	    MOV AL, 11111111B
	    OUT DX, AL
	    
	    JMP MAIN_LOOP

BLINK:
 
   BLINK_OFF:
	   ;OFF
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   
	    MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	   CALL DELAY
	    ;PAUSE
	   MOV DX, PORTC_1
	   IN AL, DX 
	   CMP AL,  00000011B   
	   JE BLINK_ON
	   ;OFF
	   CMP AL,  00000010B ; Check if  ON switch is 0.  
	   JE OFF
	   JNE BLINK_OFF	   
   BLINK_ON:
	   ;ON
	   MOV DX, PORTA_1
	   MOV AL, 11111111B
	   OUT DX, AL
	   
	   MOV DX, PORTB_1
	   MOV AL, 11111111B
	   OUT DX, AL
	   
	    MOV DX, PORTA_2
	    MOV AL, 11111111B
	    OUT DX, AL
	    CALL DELAY 
	    ;PAUSE
	   MOV DX, PORTC_1
	   IN AL, DX 
	   CMP AL,  00000011B   
	   JE MAIN_LOOP
	   ;OFF
	   CMP AL,  00000010B ; Check if  ON switch is 0.  
	   JE OFF
	   JNE BLINK_ON
	    
	     JMP MAIN_LOOP
   
ALT_SEQ:

   RED:
	    ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;R>B>Y
	    ;RED (PA0,PA4,PB0,PB1,PA10,PA14)
	   MOV DX, PORTA_1
	   MOV AL, 00010001B
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00000011B
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00010001B
	   OUT DX, AL
	   CALL DELAY
	   
	   ;PAUSE
	   MOV DX, PORTC_1
	   IN AL, DX 
	   CMP AL, 00010011B  
	   JE BLUE
	   ;OFF
	   CMP AL, 00010010B; Check if  ON switch is 0.  
	   JE OFF
	   JNE RED
	   
     BLUE:
	   ;BLUE (PA1,PA2,PA3;PB2,PB3,PB4;PA11,PA12,PA13)
	   MOV DX, PORTA_1
	   MOV AL, 00001110B
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00011100B
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00001110B
	   OUT DX, AL
	   CALL DELAY
	   
	   MOV DX, PORTC_1 
	   IN AL, DX 
	   CMP AL, 00010011B 
	   JE YELLOW
	   ;OFF
	   CMP AL, 00010010B; Check if  ON switch is 0.  
	   JE OFF
	   JNE BLUE
	   
     YELLOW:
	   ;YELLOW (PA5,PA6,PA7;PB5,PB6,PB7;PA15,PA16,PA17)
	   MOV DX, PORTA_1
	   MOV AL, 11100000B
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 11100000B
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 11100000B
	   OUT DX, AL
	   CALL DELAY
	   
	   MOV DX, PORTC_1
	   IN AL, DX 
	   CMP AL, 00010011B  
	   JE MAIN_LOOP
	   ;OFF
	   CMP AL, 00010010B; Check if  ON switch is 0.  
	   JE OFF
	   JNE YELLOW
	  
	   JMP MAIN_LOOP
	  
ROTATE:
	    
      R1:
	    ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;12 o clock
	    ;R1
	    ;@PA1-3 (outer) & PA0 (inner)
	    MOV DX, PORTA_1
	    MOV AL, 00001111B
	    OUT DX, AL
	    CALL DELAY
	   
	  ;PAUSE 
	   MOV DX, PORTC_1
	   IN AL, DX 
	   CMP AL, 00001011B  
	   JE R2
	   ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	   JNE R1
	   
	    
      R2:
	    ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	     ;@PA4-7 (outer) & PA14(inner)
	    MOV DX, PORTA_1
	    MOV AL, 11100000B
	    OUT DX, AL
	    ;@PA14
	    MOV DX, PORTA_2
	    MOV AL, 00010000B
	    OUT DX, AL
	    CALL DELAY
	    
	    ;PAUSE
	    MOV DX, PORTC_1
	    IN AL, DX 
	    CMP AL, 00001011B  
	    JE R3
	    ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	    JNE R2
	    
      R3:
	   ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;R3
	    ;@PB2-4 (outer) & PA10(inner)
	    MOV DX, PORTB_1
	    MOV AL, 00011100B
	    OUT DX, AL
	    ;@PA10
	    MOV DX, PORTA_2
	    MOV AL, 00000001B
	    OUT DX, AL
	    CALL DELAY
	    
	    ;PAUSE
	    MOV DX, PORTC_1
	    IN AL, DX 
	    CMP AL, 00001011B  
	    JE R4
	    ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	    JNE R3
	    
      R4:
	   ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;R4
	    ;PB5-7 (outer) & PB1 (inner)
	    MOV DX, PORTB_1
	    MOV AL, 11100010B
	    OUT DX, AL
	    CALL DELAY
	     ;PAUSE
	    MOV DX, PORTC_1
	    IN AL, DX 
	    CMP AL, 00001011B  
	    JE R5
	    ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	    JNE R4
	   
      R5:
	   ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;R5
	    ;PA11-13 (outer) & PB0 (inner)
	    MOV DX, PORTA_2
	    MOV AL, 00001110B
	    OUT DX, AL
	    MOV DX, PORTB_1
	    MOV AL, 00000001B
	    OUT DX, AL
	    CALL DELAY
	  
	   ;PAUSE
	    MOV DX, PORTC_1
	    IN AL, DX 
	    CMP AL, 00001011B  
	    JE R6
	    ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	    JNE R5
	    
      R6:
	   ;TURN OFF ALL LEDs
	   MOV DX, PORTA_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTB_1
	   MOV AL, 00H
	   OUT DX, AL
	   MOV DX, PORTA_2
	   MOV AL, 00H
	   OUT DX, AL
	    ;R6 LAST
	    ;PA15-17 (outer) & PA4 (inner)
	    MOV DX, PORTA_2
	    MOV AL, 11100000B
	    OUT DX, AL
	    MOV DX, PORTA_1
	    MOV AL, 00010000B
	    OUT DX, AL
	    CALL DELAY
	    
	    ;PAUSE
	    MOV DX, PORTC_1
	    IN AL, DX 
	    CMP AL, 00001011B  
	    JE MAIN_LOOP
	    ;OFF
	   CMP AL, 00001010B; Check if  ON switch is 0.  
	   JE OFF
	    JNE R6
	    
LOOPDLOOP:
	  ; TURN OFF ALL LEDs before starting
	  MOV DX, PORTA_1
	  MOV AL, 00H
	  OUT DX, AL
	  MOV DX, PORTB_1
	  MOV AL, 00H
	  OUT DX, AL
	  MOV DX, PORTA_2
	  MOV AL, 00H
	  OUT DX, AL
	  
	  ; @ 12 oclock
      L1:
	  ; PA3 PEAK
	  MOV DX, PORTA_1
	  MOV AL, 00001000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B        ; Check for the step key
	  JE L2                   ; Jump to next step if pressed
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L1                  ; Stay here if not pressed
	  
      L2:
	  ; PA2
	  MOV DX, PORTA_1
	  MOV AL, 00000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L3
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L2
	
      L3:
	  ; PA1
	  MOV DX, PORTA_1
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L4
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L3
	 
      L4:
	  ; OFF
	  MOV DX, PORTA_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L5
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L4
	
      L5:
	  ; 1 o clock
	  ; Start @ PA4
	  MOV DX, PORTA_1
	  MOV AL, 00010000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L6
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L5
      L6:
	  ; PA5
	  MOV DX, PORTA_1
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L7
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L6
      L7:
	  ; PA6
	  MOV DX, PORTA_1
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L8
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L7
      L8:
	  ; PA7 PEAK
	  MOV DX, PORTA_1
	  MOV AL, 10000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L9
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L8
      L9:
	  ; PA6
	  MOV DX, PORTA_1
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L10
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L9
      L10:
	  ; PA5
	  MOV DX, PORTA_1
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L11
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L10
      L11:
	  ; PA4
	  MOV DX, PORTA_1
	  MOV AL, 00010000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L12
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L11
      L12:
	  ; OFF
	  MOV DX, PORTA_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY              ; PA7 peak note seems misplaced, was likely for the OFF step
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L13
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L12
      L13:
	  ; @ 3 o clock
	  ; Start @ PB0
	  MOV DX, PORTB_1
	  MOV AL, 00000001B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L14
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L13
      L14:
	  ; OFF
	  MOV DX, PORTB_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY              ; PB0 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L15
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L14
      L15:
	  ; @4 o clock
	  ; Start @PB1
	  MOV DX, PORTB_1
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L16
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L15
      L16:
	  ; PB2
	  MOV DX, PORTB_1
	  MOV AL, 00000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L17
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L16
      L17:
	  ; PB3
	  MOV DX, PORTB_1
	  MOV AL, 00001000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L18
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L17
      L18:
	  ; PB4 PEAK
	  MOV DX, PORTB_1
	  MOV AL, 00010000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L19
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L18
      L19:
	  ; PB3
	  MOV DX, PORTB_1
	  MOV AL, 00001000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L20
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L19
      L20:
	  ; PB2
	  MOV DX, PORTB_1
	  MOV AL, 00000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L21
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L20
      L21:
	  ; PB1
	  MOV DX, PORTB_1
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L22
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L21
      L22:
	  ; OFF
	  MOV DX, PORTB_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY              ; PB4 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L23
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L22
      L23:
	  ; 6 o clock
	  ; Start @ PB5
	  MOV DX, PORTB_1
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L24
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L23
      L24:
	  ; PB6
	  MOV DX, PORTB_1
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L25
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L24
      L25:
	  ; PB7 PEAK
	  MOV DX, PORTB_1
	  MOV AL, 10000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L26
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L25
      L26:
	  ; PB6
	  MOV DX, PORTB_1
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L27
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L26
      L27:
	  ; PB5
	  MOV DX, PORTB_1
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L28
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L27
      L28:
	  ; OFF
	  MOV DX, PORTB_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY              ; PB7 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L29
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L28
      L29:
	  ; 7 o clock
	  ; Start @PA10
	  MOV DX, PORTA_2
	  MOV AL, 00000001B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L30
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L29
      L30:
	  ; PA11
	  MOV DX, PORTA_2
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L31
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L30
      L31:
	  ; PA12
	  MOV DX, PORTA_2
	  MOV AL, 00000100B       ; Corrected from 0000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L32
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L31
      L32:
	  ; PA13 PEAK
	  MOV DX, PORTA_2
	  MOV AL, 00001000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L33
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L32
      L33:
	  ; PA12
	  MOV DX, PORTA_2
	  MOV AL, 00000100B       ; Corrected from 0000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L34
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L33
      L34:
	  ; PA11
	  MOV DX, PORTA_2
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L35
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L34
      L35:
	  ; PA10
	  MOV DX, PORTA_2
	  MOV AL, 00000001B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L36
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L35
      L36:
	  ; OFF
	  MOV DX, PORTA_2
	  MOV AL, 00000000B       ; Corrected from 0000000B
	  OUT DX, AL
	  CALL DELAY              ; PA13 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L37
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L36
      L37:
	  ; 9 o clock
	  ; Start @PA14
	  MOV DX, PORTA_2
	  MOV AL, 00010000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L38
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L37
      L38:
	  ; OFF
	  MOV DX, PORTA_2
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY              ; PA14 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L39
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L38
      L39:
	  ; 11 o clock
	  ; Start PA0
	  MOV DX, PORTA_1
	  MOV AL, 00000001B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L40
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L39
      L40:
	  ; OFF
	  MOV DX, PORTA_1
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L41
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L40
      L41:
	  ; PA15
	  MOV DX, PORTA_2
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L42
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L41
      L42:
	  ; PA16
	  MOV DX, PORTA_2
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L43
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L42
      L43:
	  ; PA17 PEAK
	  MOV DX, PORTA_2
	  MOV AL, 10000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L44
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L43
      L44:
	  ; PA16
	  MOV DX, PORTA_2
	  MOV AL, 01000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L45
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L44
      L45:
	  ; PA15
	  MOV DX, PORTA_2
	  MOV AL, 00100000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L46
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L45
      L46:
	  ; PA15 OFF (This step might be redundant if PA0 lights up next)
	  MOV DX, PORTA_2
	  MOV AL, 00000000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L47
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L46
      L47:
	  ; PA0
	  MOV DX, PORTA_1
	  MOV AL, 00000001B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L48
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L47
      L48:
	  ; OFF
	  MOV DX, PORTA_1
	  MOV AL, 00000000B       ; Corrected from 0000000B
	  OUT DX, AL
	  CALL DELAY              ; PA17 peak note
	  ; PAUSE - Added
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B 
	  JE L49    ; Jump to return point if pressed
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L48                 ; Stay here if not pressed
	  
;Added last sequence	
      L49:
	  MOV DX, PORTA_1
	  MOV AL, 00000010B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B         ; Check for the step key
	  JE L50                  ; Jump to next step if pressed
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L49                  ; Stay here if not pressed
	
     L50:
	  MOV DX, PORTA_1
	  MOV AL, 00000100B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B         ; Check for the step key
	  JE L51                ; Jump to next step if pressed
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L50                  ; Stay here if not pressed
	  
      L51:
	  MOV DX, PORTA_1
	  MOV AL, 00001000B
	  OUT DX, AL
	  CALL DELAY
	  ; PAUSE
	  MOV DX, PORTC_1
	  IN AL, DX
	  CMP AL, 00011011B         ; Check for the step key
	  JE MAIN_LOOP             ; Jump to next step if pressed
	   ;OFF
	  CMP AL, 00011010B; Check if  ON switch is 0.  
	  JE OFF
	  JNE L51                  ; Stay here if not pressed
	  
      JMP MAIN_LOOP

INIT_8255: 
	   MOV DX, COMREG_1
	   MOV AL, COMBYTE_1
	   OUT DX, AL
	   
	   MOV DX, COMREG_2
	   MOV AL, COMBYTE_2
	   OUT DX, AL
	   
	   RET
 
DELAY:
   MOV CX, 0FFFFH
DELAY_LOOP:
   NOP
   LOOP DELAY_LOOP
   RET
   
CODE    ENDS
        END START