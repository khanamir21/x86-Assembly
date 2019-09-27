; This divide procedure determines the correct quotient and 
; remainder, regardless of overflow. Enter with the 16-bit 
; divisor in BX and the 32-bit dividend in DX (high word) and
; AX (Low word).
; The 32-bit quotient is returned in BX:AX and the 16-bit 
; remainder is returned in DX.
;
DIVUO    PROC
		 CMP   BX,0                ;Divisor = 0?
	     JNZ   DVROK
         INT   0                   ; Yes. Abort the divide.
DVROK:   PUSH  ES                  ;Save current ES register.
		 PUSH  DI		           ; DI register
		 PUSH  CX                  ; and CX register.
	     MOV   DI,0                ;Fetch current INT 0 vector
		 MOV   ES, DI
	     PUSH  ES:[DI]             ; and save it on the stack.
		 PUSH  ES:[DI+2]
         LEA   CX,OVR_INT          ;Make INT 0 vector
         MOV   ES:[DI],CX          ; point to OVR_INT.
         MOV   CX,SEG OVR_INT
         MOV   ES:[DI+2],CX
         DIV   BX                  ;Perform the division.
         SUB   BX,BX               ;If no overflow, make BX zero
RESTORE: POP   ES:[DI+2]           ;Restore INT 0 vector.
         POP   ES:[DI]
         POP   CX                  ;Restore original CX,
         POP   DI                  ; DI
         POP   ES                  ; and ES.
         RET
;
;  This interrupt service routine is executed if the divide
;  operation produces overflow.
;
OVR_INT: POP   CX                  ;Modify return address offset
         LEA   CX,RESTORE          ; to skip SUB BX,BX.
         PUSH  CX
         PUSH  AX                  ;Save current AX register.
         MOV   AX, DX              ;Set up first dividend, 0-Y1.
         SUB   DX, DX
         DIV   BX                  ;Q1 is in AX, R1 is in DX.
         POP   CX                  ;Fetch original AX into CX.
         PUSH  AX                  ;Save Q1 on the stack.
         MOV   AX, CX              ;Set up second dividend, R1-Y0
         DIV   BX                  ;Q0 is in AX, RO is in DX.
         POP   BX                  ;Final quotient is in BX:AX.
         IRET
DIVUO    ENDP

