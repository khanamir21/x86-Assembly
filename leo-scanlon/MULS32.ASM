; This procedure multiplies two 32-bit signed numbers and 
; generates a 64-bit product. Enter with the multiplier in CX 
; (high word) and BX (low word) and the multiplicand in DX 
; (high word) and AX (low word). The product is returned in 
; DX, CX, BX, and AX (high to low order).
; This procedure calls MULU32 (Example 4-1).
;
; Set up this variable in the data segment:
;
NEG_IND  DB    ?
;
;  The main procedure follows.
;
EXTRN	 MULU32:FAR			;MULU32 is an external procedure.
MULS32	 PROC
		 MOV   NEG_IND,0    ;Negative indicator = 0.
		 CMP   DX,0		    ;Mu11ipLicand negative?
         JNS   CHKCX        ; No. Check multiplier.
		 NOT   AX			; Yes. 2s-complement multiplicand
		 NOT   DX			
		 ADD   AX, 1
         ADC   DX,0
         NOT   NEG_IND      ; and 1s-complement indicator.
CHKCX:   CMP   CX,0         ;Multiplier negative?
		 JNS   GOMUL        ; No. Go multiply.
         NOT   BX           ; Yes. 2s-complement multiplier
         NOT   CX         
         ADD   BX, 1
         ADC   CX,0
         NOT   NEG_IND      ; and 1s-complement indicator.
GOMUL:   CALL  MULU32       ;Perform unsigned multiplication.
         CMP   NEG_IND,0    ;Does product have correct sign?
         JZ    DONE         ; Yes. Exit.
         NOT   AX           ; No. 2s-complement product.
         NOT   BX        
         NOT   CX
         NOT   DX
         ADD   AX, 1
         ADC   BX,0
         ADC   CX,0
         ADC   DX,0
DONE:    RET
MULS32   ENDP

