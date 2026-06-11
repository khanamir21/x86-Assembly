; This procedure takes the average of a specified number of 
; unsigned word values in the data segment. The offset of the
; first word is contained in BX, the word count is contained 
; in CX.
; It returns the integer portion of the average in AX and 
; the fractional remainder in DX.
AVERAGE	 PR0C
         SUB   AX,AX    ;Clear dividend to start.
         SUB   DX, DX
         PUSH  CX       ;Save word count on stack.
ADD_W:   ADD   AX,[BXl  ;Add next word to total
         ADC   DX,0
         ADD   BX,2     ; and update the index.
         LOOP  ADD_W    ;A11 words now totaled?
		 POP   CX       ; Yes. Retrieve word count 
         DIV   CX       ; and take the average.
         RET
AVERAGE  ENDP
