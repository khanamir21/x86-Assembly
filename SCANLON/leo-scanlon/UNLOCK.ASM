; This procedure removes write-protection by clearing the 
; read-only bit in a file's attribute byte.
;

     EXTRN SH0W_ERR:FAR

; Put the following in the data segment:

PROMPT    DB 'Which fiLe do you want to unlock? '
PROMPTL   DB $-PROMPT
FILESPEC  DB 60 DUP(?)

; Here is the main procedure:

UNLOCK  PROC
	  MOV  AH,40H         ;Display prompt
	  MOV  BX, 1
      MOV  CX,PROMPTL
      LEA  DX,PROMPT
      INT  21H
      MOV  AH,3FH         ;Obtain filespec from user
      MOV  BX,0
      MOV  CX,60
      LEA  DX,FILESPEC
      INT  21H            
	  
;Convert entry to ASCIIZ string by replacing CR with 0.

	  SUB  AX,2           ;Point to CR character
      MOV  BX, AX         ;Put pointer in BX
      MOV  FILESPEC[BX]   ;Replace CR with 0
	  
;Change the file from read-only to read/write-

	  MOV  AH,43H         ;Read the attribute byte
      MOV  AL,0
      LEA  DX,FILESPEC
      INT  21H
      JNC  CLR_ATT        ;Read error?
      CALL SHOW_ERR       ; If so, display error message
CLR_ATT: AND CX,0FEH      ; Otherwise, clear the read-on
      MOV  AL, 1          ;Write the attribute byte
      MOV  AH,43H
      LEA  DX,FILESPEC
      INT  21H
      JNC  LEAVE          ;Write error?
	  CALL SHOW_ERR       ; If so, display error message
LEAVE: RET 
UNLOCK ENDP
