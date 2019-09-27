; This procedure deletes the value in AX from an unordered
; list in the extra segment, if it is in the list.
; The starting address of the list is in DI. The length of the
; list, in words, is in the list's first location.
; DI and AX are returned unaltered.
;
DEL_UL   PROC
		 CLD                 ;Make DF = 0, to scan forward 
		 PUSH   BX           ;Save scratch register BX 
         PUSH   DI           ; and starting address.
         MOV    CX,ES:[DI]   ;Fetch element count.
         ADD    DI,2         
REPNE    SCASW               ;Value in the list?
         JE     DELETE       ; If so, delete it.
         POP    DI           ; Otherwise, restore registers
         POP    BX           
         RET                 ;  and exit.

;
;  The following instructions delete an element from the list, 
;  as follows:
;    (1) If the element is at the end of the list,
;        delete it by decreasing the element count by 1.
;    (2) Otherwise, delete the element by moving all
;        subsequent elements up by one position.
;  
DELETE:  JCXZ   DEC_CNT      ;If (CX) = 0, delete last ele
NEXT_EL: MOV    BX,ES:[DI]   ;Move one element up in list.
         MOV    ES:[DI-2],BX
         ADD    DI,2         ;Point to next element.
         LOOP   NEXT_EL      ;Repeat until all are moved.
DEC_CNT: POP    DI           ;Decrease element count by 1.
         DEC    WORD PTR ES:[DI]
         POP    BX           ;Restore contents of BX
         RET                 ; and exit.
DEL_UL   ENDP

