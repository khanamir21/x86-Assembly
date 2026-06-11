; This procedure multiplies two 32-bit unsigned numbers and 
; generates a 64-bit product. Enter with the multiplier in CX 
; (high word) and BX (low word) and the multiplicand in DX 
; (high word) and AX (low word). The product is returned in 
; DX, CX, BX and AX (high to low order).
;
; Set up these variables in the data segment:
;
HI_MCND	DW	9
LO_MCND	DW	9
HI_PP1	DW	9
L0_PP1	DW	9
HI_PP2	DW	9
L0_PP2	DW	9
HI_PP3	DW	9
L0_PP3	DW	9
HI_PP4	DW	9
L0_PP4	DW	9
;
; The main procedure follows.
;
MULU32	PROC
		MOV		HI_MCND,DX		;Save multipiicand in memory
		MOV		L0_MCND,AX
		MUL		BX				; Form	partial	product	#1
		MOV		HI_PP1,DX		; and save it in memory.
		MOV		L0_PP1,AX
		MOV		AX,HI_MCND		; Form partial product #2
		MUL		BX
		MOV		HI_PP2,DX		; and save it in memory.
		MOV		L0_PP2,AX
		MOV		AX,LO_MCND		; Form partial product #3
		MUL		CX
		MOV		HI_PP3,DX		; and save it in memory.
		MOV		L0_PP3,AX		
		MOV		AX,HI_MCND		; Form partial product #4
		
		MUL 	CX
		MOV 	HI_PP4,DX 		; and save it in memory. 
		MOV 	LO_PP4,AX
;
; Add the partial products to form the 64-bit final product.
;
		MOV		AX,L0_PP1		;Low 16 bits.
		MOV		BX,HI_PP1		;Form mid-lower 16 bi ts
		ADD		BX,L0_PP2		; with sum #1.
		ADC		HI_PP2,0		
		ADD		BX,L0_PP3		; and sum #2.
		MOV		CX,HI_PP2		;Form mid-upper 16 bits
		ADC		CX,HI_PP3       ; with sum #3
		ADD		HI_PP4,0		
		ADD		CX,L0_PP4		; and sum #4.
		MOV		DX,HI_PP4		;Form high 16 bits
		ADC		DX,0			; with propagated
		RET
MULU32	ENDP
		
