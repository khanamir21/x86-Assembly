$2BIN MACRO string_name

	 LOCAL   BLANKS,CHK_NEG,CHK_POS,GO_CONV,GOOD,N0_G00D,THRU 
	 LOCAL   CONV_AB,RANGE,NON_DIG,DIGIT,END_C0NV,SKIPIT
;;
;;  Convert the specified string to a signed binary number 
;;  in AX. The first bye in the string must hold the
;;  character count.
;;  If the conversion is successful, CF = 0;; otherwise CF = 1.
;;

	PUSH BX                     ;;Save working registers.
	PUSH CX                     
	SUB AX,AX                   ;;To start, result = 0.
	SUB CH,CH                   ;;Read count into CX. 
	MOV CL,string_name 
	LEA BX,string_name+1        ;;Put first address in BX.
BLANKS: CMP BYTE PTR EBX],' '   ;;Scan past leading blanks.
	JNE CHK_NEG
	INC BX
	LOOP BLANKS
;;	
;; Execute these instructions if the string starts with a 
;; minus sign.
;;
CHK_NEG:   CMP BYTE PTR [BX],'-'
	JNE CHK_POS
	INC BX 						;;Increment the pointer.
	DEC CX 						;;Decrement the count.
    CALL C0NV_AB 			    ;;Convert the string.
	JC	THRU
	CMP AX,32768 				;;Is the number too large?
	JA  NO_GOOD
	NEG AX
	JS	G00D
;;
;;  Execute these instructions if the first string character;; 
;;  is not a minus sign.
;;
CHK_POS:  CMP  BYTE PTR [BX],'+'
     JNE    GO_CONV
	 INC    BX					;;Increment the pointer
	 DEC    CX                  ;;Decrement the count.
GO_CONV:  CALL  CONV_AB         ;;Convert the string
	 JC     THRU
	 CMP    AX,32767            ;;Is the number too large?
	 JA     NO_GOOD
GOOD:  CLC	
	JNC THRU
N0_G00D:  STC                   ;; If so, set Carry.
THRU: POP CX                    ;; Restore registers.
	  POP BX
	  JMP SKIPIT

;;
;; This subroutine performs the actual conversion.
;;
C0NV__AB PROC
	PUSH BP						;;Save scratch registers.
	PUSH BX
	PUSH SI
	MOV  BP,BX					;;Put pointer in BP
	SUB  BX,BX					;; and clear BX.
RANGE: CMP BYTE PTR DS:EBP],'0'		;;If character is not
	JB	 END_CONV					;; a digit,
	CMP	 BYTE PTR DS:[BP],'9'
	JBE  DIGIT
N0N_DIG: STC						;; set Carry
	JC   END_C0NV					;; and exit.
DIGIT: MOV SI,10				;;The character is a digit,
	PUSH DX
	MUL	 SI						;; so multiply AX by 10.
	POP  DX						
	MOV  BL,DS:[BP]				;;Fetch ASCII code,
	AND  BX,0FH					;; save only low bits,
	ADD  AX,BX					;; and update result.
	JC   END__C0NV				;;Exit if result is too large.
	INC  BP						;;Otherwise increment BP
	LOOP RANGE					;; and continue.
	CLC							;;When done, clear Carry.
END_C0NV: POP SI				;;Restore registers.
	POP  BX
	POP  BP
	RET
C0NV_AB  ENDP
SKIPIT:  NOP
	ENDM

BEEP MACRO

;;
;;  Beep the speaker for 1/2 second at a frequency of 1000 Hz.
;;
	SOUND  1000,50
	 ENDM
	 
BIN2$ MACRO string_name

     LOCAL FILL_BUF F,CLR_DVD,N0_M0RE
;;
;;  Convert a signed number in AX to a string in the data segment.
;;  String must be seven bytes Long. The first byte receives the
;;  character count.
;;
     PUSH   DX			;;Save affected registers.
	 PUSH	CX
	 PUSH   BX
	 PUSH   SI
	 PUSH   AX
	 LEA    BX,string_name+1  ;;BX points to first character.
	 
