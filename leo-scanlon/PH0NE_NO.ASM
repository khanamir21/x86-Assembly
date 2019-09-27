; This procedure sorts a telephone list alphabetically. The 
; list contains a word that holds a count of the entries,
; followed by the entries.
; Each entry is 42 bytes long, and divided into three fields 
; a 15-byte surname, a 15-byte first name/initial, and a 
; 12-byte phone number.
; The list is in the extra segment, and its starting address
; (the address of the count word) is in DI.
;
; Set up these variables in the data segment.
;
FIRST_ENT  DW  9
SAVE_CNT   DW  9
;
; Here is the main procedure.
;
PH0NE_NOS  PROC
		   PUSH  AX                     ;Save scratch registers
		   PUSH  BX
		   PUSH  CX
		   PUSH  BP
		   PUSH  DI
		   PUSH  SI
		   PUSH  DS
		   CLD                          ;Set (DF) = 0, to move forward 
		   MOV   CX,ES:[DI]             ;Fetch entry count 
		   MOV   SAVE_CNT,CX            ; and save it in memory 
		   ADD   DI,2                   ;Get address of first entry 
		   MOV   FIRST_ENT,DI           ; and save it in memory 
INIT: 	   MOV   BX, 1                  ;Exchange flag (BX) = 1 
		   DEC   SAVE_CNT               ;Get ready for count-1 compares 
		   JZ    SORTED                 ;Exit if SAVE_CNT is 0 
		   MOV   CX,SAVE_CNT            ;Load compare count into CX 
		   MOV   BP,FIRST_ENT           ; and first entry addr. into BP 
NEXT:      MOV   DI,BP                  ;Point to one entry with DI 
           MOV   SI,BP                  ; and the next with SI
           ADD   SI,42                  
           PUSH  CX                     ;Save current compare count 
           MOV   CX,15                  ;Compare 15-byte surname fields 
                                        ;Is next surname < this surname , ES:[DI]
REPE	   CMPS  ES:BYTE PTR[SI], ES:[DS]
		   JAE   CONT                   ; No. Check next pair 
		   MOV   CX,42                  ; Yes. Exchange these entries
SWAPEM:    MOV   AL,ES:[BP]
		   XCHG  ES:[BP+42],AL
           MOV   ES:[BP],AL
           INC   BP
		   LOOP  SWAPEM
		   SUB   BX,BX                  ;Set exchange flag = 0 
CONT:      POP   CX                     ;Reload compare count 
           LOOP  NEXT                   ; and compare next two names 
           CMP   BX,0                   ;Were any exchanges made?
           JE    INIT                   ; If so, make another pass 
SORTED:    POP   DS                     ; If not, restore registers
           POP   SI
           POP   DI 
           POP   BP
           POP   CX
           POP   BX
           POP   AX
           RET                          ; and exit
PH0NE_NOS  ENDP


