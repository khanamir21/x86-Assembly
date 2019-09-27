;  This procedure deletes the value in AX from an ordered list 
;  in the extra segment, if it is in the list.
;  The starting address of the list is in DI. The length 
;  of the list, in words, is in its first location.
;  AX and DI are unaffected.
;  The B_SEARCH procedure (Example 5-6) is used to conduct 
;  the search.
;
EXTRN   B_SEARCH:FAR
DEL_0L  PROC
		PUSH  SI
		PUSH  CX
		PUSH  BX
		CALL  B_SEARCH      ;Is the value in the list?
		JC    ADIOS         ; No. Exit
        MOV   CX,ES:[DI]    ; Yes. Find address of last element
        SHL   CX,1
		ADD   CX, DI        ; and put it in CX
		CMP   CX,SI         ;Is the last element to be deleted?
		JE    CNT_M1        ; Yes. Decrement element count
		SUB   CX,SI			; No. Calculate move count
		SHR   CX,1
MOVEM:  MOV   BX,ES:[SI+2]  ;Move one element up in list
		MOV   ES:[SI],BX
		ADD   SI,2			;Point to next element
		LOOP  MOVEM			;Repeat until all are moved
CNT_M1: DEC   WORD PTR ES:[DI] ;Decrease element count
ADIOS:  POP   BX			;Restore registers
		POP   CX
		POP   SI
		RET					; and exit
DEL_0L  ENDP