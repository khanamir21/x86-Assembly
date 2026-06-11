;  This procedure calculates the square root of a 32-bit integer 
;  in DX (high word) and AX (low word), and returns that square 
;  root as a 16-bit integer in BX. The original number in DX:AX
;  is not affected.
SQRT32    PROC
		  PUSH  BP            ;Save contents of BP
          PUSH  DX            ; and source number DX:AX.
          PUSH  AX
          MOV   BP,SP         ;BP points to AX on the stack.
          MOV   BX,200        ;As a first approximation.
          DIV   BX            ; divide source number by 200,
          ADD   AX,2          ; then add 2.
NXT_APP:  MOV   BX, AX        ;Save this approximation in BX.
          MOV   AX,[BP]       ;Read source number again.
          MOV   DX,[BP+2]
          DIV   BX            ;Divide it by last approximation.
          ADD   AX,BX         ;Average the last two results.
          SHR   AX, 1
          CMP   AX,BX         ;Last two approximations identical?
          JE    DONE
          SUB   BX,AX         ; No. Check for difference of 1.
          CMP   BX, 1
          JE    DONE
		  CMP   BX,-1
	      JNE   NXT_APP
DONE:     MOV   BX,AX         ;Put result in BX.
          POP   AX            ;Restore source number
          POP   DX
          POP   BP            ; and scratch register BP.
          RET
SQRT32    ENDP
