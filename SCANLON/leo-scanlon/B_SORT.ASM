; This procedure arranges the 16-bit elements of a list in 
; ascending order in memory, using bubble sort.
; The list is in the extra segment, and its starting address 
; is in DI. The length of the list, in words, is in its 
; first location.
; DI is returned unaltered.
;
; Set up these variables in the data segment.
;
SAVE_CNT   DW    ?
START_ADDR DW    ?
;
B_SORT   PROC
		 PUSH  AX             ;Save scratch registers
		 PUSH  BX
		 PUSH  CX
         MOV   START_ADDR,DI  ;Save starting address
		 MOV   CX,ES:[DI]     ;Fetch element count
         DEC   CX             ;Get ready for count-1 compares
         MOV   SAVE_CNT,CX    ;Save this value in memory
INIT:    MOV   BX, 1          ;Exchange flag (BX) - 1
		 MOV   CX,SAVE_CNT    ;Load count into CX
		 MOV   DI,START_ADDR  ; and start address into DI
NEXT:    ADD   DI,2           ;Address a data element
         MOV   AX,ES:EDI]     ; and load it into AX
		 CMP   ES:[DI+2],AX   ;Is next element < this one?
         JAE   CONT           ; No. Check next pair
         XCHG  ES:[DI+2],AX   ; Yes. Exchange these elements
         MOV   ES:[DI],AX
		 SUB   BX,BX          ;  and make exchange flag 0
CONT:    LOOP  NEXT           ;Process entire list
         CMP   BX,0           ;Were any exchanges made?
         JE    INIT           ; If so, make another pass
         MOV   DI,START_ADDR  ; If not, restore registers
         POP   CX
		 POP   BX
		 POP   AX
		 RET                  ; and exit.
B_SORT   ENDP



