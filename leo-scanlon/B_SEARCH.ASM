;  This procedure searches an ordered List in the extra segment 
;  for the word value contained in AX.
;  The starting address of the List is in DI. The Length of the 
;  List, in words, is in the List's first Location.
;  The results are returned in SI and the Carry Flag (CF), as 
;  follows:
;      1. If the value is in the List, CF is 0 and SI
;         holds the address of the matching element.
;      2. If the value is not in the list, CF is 1 and
;         SI holds the address of the last element to
;         be compared.
;  In either case, AX and DI are unaffected.
;  
;  Set up this variable in memory.
;
START_ADDR  DW ?
;
B_SEARCH    PROC
;
; First find out if AX lies beyond the boundaries of the list.
;
		   CMP   AX,ES:CDI+2]    ;Search value < or = first el. 
		   JA    CHK_LAST 		; No. Check last element
		   LEA   SI,ES:[DI+2]    ; Yes. Fetch address of 1st el. 
		   JE    EXIT_1ST        ;If value = 1st element, exit 
		   STC                   ;If value < 1st element, set CF
EXIT_1ST:  RET                   
CHK_LAST:  MOV   SI,ES:[DI3      ;Point to last element
		   SHL   SI, 1           
		   ADD   SI,DI           
		   CMP   AX,ES:CSI3      ;Search value > or = last el.?
		   JB    SEARCH          ; No. Search list 
		   JE    EXIT_LAST       ; Yes. Exit if value = element 
		   STC   EXIT_LAST:      ;If value > last element, set CF
EXIT_LAST: RET
;
;  Search for the value within the list
;
SEARCH:   MOV   START_ADDR,DI    ;Save starting address in memory 
		  MOV   SI,ES:[DI]       ;Fetch index
EVEN_IDX: TEST  SI,1             ;Force index to an even value
		  JZ	ADD_IDX          
		  INC   SI               
ADD_IDX:  ADD   DI,SI            ;Calculate next search address 
COMPARE:  CMP	AX,ES:[DID       ;Search value found?
	      JE    ALL_D0NE         ; If so, exit
		  JA	HIGHER		     ; Otherwise, find correct half
; Search lower in the list.
		  CMP   SI,2             ;Index = 2?
		  JNE   IDX_0K           
N0_MATCH: STC                    ; If so, set CF 
		  JE    ALL_D0NE         ;  and exit
IDX_0K:   SHR	SI,1             ; If not, divide index by 2 
		  TEST  SI,1             ;Force index to an even value
		  JZ    SUB_IDX          
		  INC   SI               
SUB_IDX:  SUB   DI,SI            ;Calculate next address 
		  JMP   SHORT COMPARE    ;Check this element
;
; Search higher in the list.
;
HIGHER:	  CMP   SI,2             ;Index = 2?
		  JE    NO_MATCH         ; If so, go set CF and exit 
		  SHR   SI, 1            ; If not, divide index by 2 
		  JMP   SHORT EVEN_IDX   ; and go check next element
;
;These are the exit instructions
;
ALL_D0NE: MOV   SI, DI             ;Move compare address into SI 
		  MOV   DI,START_ADDR      ;Restore starting address 
		  RET                      ; and exit
B_SEARCH: ENDP




