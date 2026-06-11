;  This procedure finds the maximum and minimum word values in ar 
;  unordered list in the extra segment, and returns those values 
;  in AX and BX, respectively.
;  The starting address of the list is in DI. The length of the 
;  list, in words, is in the list's first location.
;  DI is returned unaltered.
MINMAX   PROC
         PUSH  CX
		 PUSH  DI            ;Save starting address.
		 MOV   CX,ES:[DI]    ;Fetch word count.
         DEC   CX            ;Get ready for count-1 comparisons.
         PUSH  CX            ;Save this count value.
         MOV   BX,ES:[DI+2]  ;To start, make 1st element minimum
		 MOV   AX,BX         ; and maximum.
;
; These instructions find the minimum value in the list.
;
		 ADD   DI,4          ;Point to 2nd element in the list 
		 PUSH  DI            ; and save this pointer.
CHKMIN:  CMP   ES:[DI],BX    ;Compare next element to minimum. 
         JAE   NOMIN         ;New minimum found?
		 MOV   BX,ES:[DI]    ; Yes. Put it in BX.
NOMIN:   ADD   DI,2          ;Point to next element.
         LOOP  CHKMIN        ;Check entire list.
;
;  These instructions find the maximum value in the list.
;
		 POP   DI            ;Point to 2nd element in the list. 
		 POP   CX            ;Reload comparison counter. 
CHKMAX:  CMP   ES:[DI],AX    ;Compare next element to maximum. 
		 JBE   NOMAX         ;New maximum found?
		 MOV   AX,ES:[DI]    ; Yes.  Put it in AX.
NOMAX:   ADD   DI,2          ;Point to next element
		 LOOP  CHKMAX        ;Check entire list.
		 POP   DI
		 POP   CX
		 RET
MINMAX   ENDP

