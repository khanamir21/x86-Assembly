TITLE 	EX_PR0G - Example Program 
		PAGE ,132

STACK 	SEGMENT PARA STACK 'STACK'
DB 64 DUP('STACK ')
STACK 	ENDS

DSEG 	SEGMENT PARA PUBLIC 'DATA'
SOURCE 	DB 10,20,30,40 	;This table will be copied into
DEST 	DB 4 DUP(?) 	; this table, in reverse order
DSEG 	ENDS

SUBTTL Here is the main program.
		PAGE
CSEG 	SEGMENT PARA PUBLIC 'CODE'
OUR_PROG PROC FAR
		ASSUME CS:CSEG,DS:DSEG,SS:STACK
;
;  Set up the stack to contain the proper values so this
;  program can return to DEBUG.
;

		  PUSH  DS 		;Put return seg. addr. on stack
		  MOV   AX,0 		;Clear a register
		  PUSH  AX 		;Put zero return addr. on stack
;
;  Initialize the data segment address.
;
		  MOV   AX,DSEG 	;initialize DS
		  MOV   DS,AX	
;
;  Initialize DEST with zeroes.
;
          MOV   DEST,0 	;First byte
          MOV   DEST+1,0 	;Second byte
          MOV   DEST+2,0  ;Third byte
          MOV   DEST+3,0  ;Fourth byte
;
;  Copy SOURCE table into DEST table, in reverse order.
;
		  MOV   AL,SOURCE 	;Copy first byte
		  MOV   DEST+3,AL
		  MOV   AL,SOURCE+1 	;Copy second byte
		  MOV   DEST+2,AL
		  MOV   AL,SOURCE+2 	;Copy third byte
		  MOV   DEST+1,AL
		  MOV   AL,SOURCE+3 	;Copy fourth byte
		  MOV   DEST,AL
		  RET					;Return to DEBUG
OUR_PROG  ENDP
CSEG 	  ENDS
		  END   OUR_PROG
		