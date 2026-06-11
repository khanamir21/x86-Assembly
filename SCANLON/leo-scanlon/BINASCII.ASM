; This procedure converts a signed binary number to a six-byt 
; ASCII string (sign plus five digits) in the data segment.
; Enter with the number to be converted in AX and the 
; starting address of the memory buffer in BX.
; Upon return, BX holds the address of the converted output 
; string and CX holds the length of the string.
; Other registers are preserved.
;
BIN_ASCII   PR0C
            PUSH  DX         ;Save affected registers
            PUSH  SI
            PUSH  AX         ;Save binary value
            MOV   CX,6       ;Fill buffer with spaces
FILL_BUFF:  MOV   BYTE PTR [BX], ' '
            INC   BX
            LOOP  FILL_BUFF
            MOV   SI,10      ;Get ready to divide by 10
            OR    AX,AX      ;If value is negative.
            JNS   CLR_DVD
            NEG   AX         ; make it positive
CLR_DVD:    SUB   DX, DX     ;Clear upper half of dividend
            DIV   SI         ;Divide AX by 10
            ADD   DX,'O'     ;Convert remainder to ASCII digit
            DEC   BX         ;Back up through buffer
            MOV   [BX],DL    ;Store this char, in the string
            INC   CX         ;Count converted character
            OR    AX,AX      ;All done?
            JNZ   CLR_DVD    ; No. Get next digit
            POP   AX         ; Yes. Retrieve original value
            OR    AX,AX      ;Was it negative?
            JNS   N0_M0RE
            DEC   BX         ; Yes. Store sign
            MOV   BYTE PTR [BX],'-'
            INC   CX         ; and increase character count
N0_M0RE:    POP   SI         ;Restore registers
            POP   DX
            RET              ; and exit
BIN_ASCII   ENDP