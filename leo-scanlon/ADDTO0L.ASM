;  This procedure adds the value in AX to an ordered list 
;  in the extra segment, if it is not already in the list.
;  The starting address of the list is in DI. The length 
;  of the list, in words, is in its first location.
;  AX and DI are unaffected.
;  The B_SEARCH procedure (Example 5-6) is used to conduct
;  the search.
;  
EXTRN 	   B_SEARCH:FAR
ADD_T0_0L  PROC
		   PUSH  SI 
		   PUSH  CX 
		   PUSH  BX
		   CALL  B_SEARCH       ;Is the value in the list?
		   JNC   GOODBYE 		; Yes. Exit
		   MOV   BX,SI 			; No. Copy compare addr. to BX
		   MOV   CX,ES:[DI] 	;Find address of last element
		   SHL   CX,1
		   ADD   CX,DI          ; and put it in CX
		   PUSH  CX             ;Save end address on the stack
		   SUB   CX,SI          ;Calculate no- of words to be moved
           SHR   CX,1
           CMP   AX,ES:[SI]     ;Should compare el. be moved, too?
		   JA    EXCLUDE
		   INC   CX             ; Yes. Increase move count by 1
           JNZ   CHECK_CNT
EXCLUDE:   ADD   BX,2			; No. Adjust insert pointer
CHECK_CNT: CMP   CX,0           ;Move count = 0?
           JNE   M0VE_ELS
           POP   SI             ; If so, store value at end of list
           MOV   ES:[SI+2],AX   
		   JMP   SHORT INC_CNT  ; then go increase element count
M0VE_ELS:  POP   SI             ;Start move at end of list
           PUSH  BX             ;Save insert address on stack
M0VE_0NE   MOV   BX,ES:[SI]	 	;Move one element down in list
		   MOV   ES:[SI+2],BX   
		   SUB   SI,2           ;Point to next element
           LOOP  M0VE_0NE       ;Repeat until all are moved
           POP   BX             ;Retrieve insert address
           MOV   ES:[BX],AX     ;Insert AX in the list
INC_CNT	   INC   WORD PTR ES:[DI] ;Add 1 to element count
GOODBYE:   POP   BX             ;Restore registers
           POP   CX
           POP   SI
           RET                  ; and exit
ADD_T0_0L  ENDP