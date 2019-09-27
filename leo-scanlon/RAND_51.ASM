;  This procedure uses TIMER__L0W from the Type 1A interrupt to 
;  generate a pseudo-random number between 0 and 51. The
;  number is returned in AH. No other registers are affected.
;
RAND_51  PROC
		 PUSH CX 	   ;Save registers affected by INT 1AH
		 PUSH DX 
		 PUSH AX
		 MOV  AH,0     ;Read the timer
		 INT  1AH
	     MOV  AX,DX    ;Move Low count into AX
		 AND  AX,1FFFH ; and strip off high 3
		 MOV  DL,52    ;Divide Low count by 52
		 DIV  DL
		 POP  DX       ;Restore AL
		 MOV  AL,DL
	     POP  DX       ;Restore DX and CX,
		 POP  CX
		 RET           ; then exit
RAND_51  ENDP