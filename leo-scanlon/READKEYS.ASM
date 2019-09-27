; This procedure reads up to 50 keystrokes. It returns the 
; string address in DS:DX and the character count in CX.
; No other registers are affected.
;
; Put this statement in the data segment:
;
USER_STRING  DB 50,51 DUP(?)
;
; Here is the actual procedure.
;
READ_KEYS  PROC
	 PUSH  AX
	 LEA   DX,USER_STRING     ;Read the string
	 MOV   AH,0AH
	 INT   21H
	 SUB   CH,CH              ;Put character count in CX
	 MOV   CL,USER_STRING+1
	 ADD   DX,2               ;Make DX point to string
	 POP   AX
	 RET
READ_KEYS  ENDP 