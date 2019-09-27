; This procedure converts an ASCII string in the data segment 
; to its 16-bit, two's-compLement binary equivalent.
; Enter with the starting address of the string in BX 
; and the character count in CX.
; Upon return, the 16-bit value is in AX, a count of the 
; number of digits after the decimal point is in DX, and the 
; address of the first non-convertible character is in DI.
; If the string contains more than seven characters, or the 
; number is out of range (greater than 32,767 or less than 
; -32,768), or the string contains a non-convertible
; character, the Carry Flag (CF) is set to 1. If the conver- 
; sion was made without error, CF is 0 and DI contains OFFH.
; The contents of BX and CX are unaffected.
;
ASCII_BIN  PROC
           PUSH  BX                 ;Save BX and CX
           PUSH  CX
           SUB   AX,AX              ;To start, result = 0,
           SUB   DX, DX             ; decimal count = 0,
           MOV   DI,0FFH            ; assume no bad characters
           CMP   CX,7               ;String too long?
           JA    N0_G00D            ; If so, go set CF and exit
BLANKS:    CMP   BYTE PTR [BX],' '  ;Scan past leading blanks
           JNE   CHKL.NEG
           INC   BX
           LOOP  BLANKS
CHK_NEG:   CMP   BYTE PTR [BX],'-' ;Negative number?
           JNE   CHK_POS
           INC   BX                ; If so, increment pointer.
           DEC   CX                ; decrement the count.
           CALL  CONV_AB           ; and convert the string
           JC    THRU
           CMP   AX,32768          ;Is the number too small?
           JA    N0_G00D
           NEG   AX                ; No. Complement the result
           JS    GOOD
CHK_P0S:   CMP   BYTE PTR [BX],'+' ;Positive number?
           JNE   GO_CONV
           INC   BX                ; If so, increment pointer.
           DEC   CX                ; decrement the count.
G0_C0NV:   CALL  CONV_AB           ; and convert the string
           JC    THRU
           CMP   AX,32767          ;Is the number too big?
           JA    NO_GOOD
GOOD:      CLC
           JNC   THRU
N0_G00D:   STC                     ; If so, set Carry Flag
THRU:      POP   CX                ;Restore registers
           POP   BX
           RET                     ; and exit
ASCII_BIN ENDP

;
; This procedure performs the actual conversion.
;
CONV_AB   PROC
          PUSH   BP                ;Save scratch registers
          PUSH   BX
          PUSH   SI
          MOV    BP,BX             ;Put pointer in BP
	      SUB    BX,BX             ; and clear BX
CHK_PT:   CMP    DX,0              ;Decimal point already found?
          JNZ    RANGE             ; If so, skip following check
          CMP    BYTE PTR DS:[BP],'.' ;Decimal point?
          JNE    RANGE
          DEC    CX                ; If so, decrement count.
          MOV    DX, CX            ; and record it in DX
          JZ     END_CONV          ; Exit if CX = 0
          INC    BP                ; Increment pointer
RANGE:    CMP    BYTE PTR DS:[BP],'0' ;If the character is not a
          JB     NON_DIG           ; digit...
          CMP    BYTE PTR DS:[BP],'9'
          JBE    DIGIT
NON_DIG:  MOV    DI,BP             ; put its address in DI,
          STC                      ; set the Carry Flag,
          JC     END_CONV          ; and exit
DIGIT:    MOV    SI,10             ;The character is a digit.
          PUSH   DX
          MUL    SI                ; so multiply AX by 10
          POP    DX
          MOV    BL,DS:[BP]        ; Fetch ASCII code.
          AND    BX,0FH            ; save only Low bits.
          ADD    AX,BX             ; and update partial result
          JC     END_C0NV          ; Exit if result is too
          INC    BP                ; Otherwise, increment BP
          LOOP   CHK_PT            ; and continue
          CLC                      ;When done, clear Carry
END_C0NV: POP    SI                ;Restore registers
          POP    BX
          POP    BP
          RET                      ; and return to caller
CONV_AB   ENDP
