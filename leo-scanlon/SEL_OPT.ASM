; This procedure calls one of four routines based on a 
; user selection code in AL.
; The contents of AX and DI are affected.
;
; This offset table must be stored in the data segment.
;
CHOICE  DW   ADDITION,SUBTRACTION,MULTIPLICATION,DIVISION
;
; Here is the selection procedure.
SEL_OPT  PROC  FAR 
         CMP   AL,3          ;Invalid choice?
		 JA    ERROR CBW     ; No. Convert code to a word, 
         MOV   DI,AX         ; then move code into DI 
		 SHL   DI,1          ; and convert it to an index 
		 JMP   CHOICE[DI]    ;Jump to routine
ERROR: 
		 RET
ADDITION:
		 RET
SUBTRACTION:
		 RET
MULTIPLICATION:
		 RET
DIVISION:
		 RET
SEL_OPT  ENDP





