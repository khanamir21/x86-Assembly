TITLE	;; (INSERT TITLE HERE)
			PAGE		,132
;; (Insert EXTRN statement, if appropriate

STACK		SEGMENT		PARA STACK 'STACK'
			DB			64 DUP('STACK')		;Stack area
STACK		ENDS

DSEG		SEGMENT		PARA PUBLIC 'DATA'

;; (insert date here)

DSEG		ENDS

CSEG		SEGMENT		PARA PUBLIC 'CODE'
			ASSUME		CS:CSEG,DS:DSEG,SS:STACK
			
ENTRY		PROC		FAR					;Entry point

; Set up the stack to contain the proper values so this
; program can return to DOS or DEBUG

			PUSH		DS
			SUB			AX,AX
			PUSH		AX
			
; Initialize the data segment address.

			MOV			AX,DSEG
			MOV			DS,AX
			
;; (Insert instructions here.)

			RET							;Return to DOS or DEBUG
ENTRY		ENDP
CSEG		ENDS
			END			ENTRY
			
			
			
			