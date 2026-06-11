; This procedure adds the value in AX to an unordered list in 
; the extra segment, if it is not already in the list.
; The starting address of the list is in DI. The length of the
; list, in words, is in the list's first location. 
; DI and AX are returned unaltered.
;
ADD_TO_UL  PROC
		   CLD                ;Make DF = 0, to scan forward.
           PUSH   DI          ;Save starting address.
           PUSH   CX
           MOV    CX,ES:[DI]  ;Fetch word count.
           ADD    DI,2        ;Make DI point to 1st data element
REPNE      SCASW              ;Value already in the list?
           POP    CX
           JNE    ADD_IT
           POP    DI          ; Yes. Restore starting address
		   RET                ;  and exit.
ADD_IT:    STOSW              ; No. Add it to end of list.
           POP    DI          ;  then update element count.
		   INC    WORD PTR ES:[DI]
		   RET
ADD_TO_UL  ENDP