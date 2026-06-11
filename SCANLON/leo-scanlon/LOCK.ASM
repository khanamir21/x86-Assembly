; This procedure write-protects a file by setting the 
; read-only bit in its attribute byte.

     EXTRN SHOW_ERR:FAR
	 
; Put the following in the data segment:

PROMPT    DB 'Which file do you want to lock? ' 
PROMPTL   DB $-PROMPT 
FILESPEC DB 60 DUP(?)

; Here is the main procedure:

LOCK  PROC
	  MOV   AH,40H             ;Display prompt
	  MOV   BX,1
	  MOV	CX,PROMPTL
	  LEA   DX,PROMPT
	  INT   21H
	  MOV   AH,3FH             ;Obtain filespec from user
	  MOV   BX,0
      MOV   CX,60
      LEA   DX,FILESPEC
      INT   21H                
	  
;Convert entry to ASCIIZ string by replacing CR with 0.

	  SUB   AX,2               ;Point to CR character
      MOV   BX, AX             ;Put pointer in BX
      MOV   FILESPECCBX]       ;Replace CR with 0
                         
;Change the file to read-only.

	  MOV   AH,43H             ;Read the attribute byte
      MOV   AL,0
      LEA   DX,FILESPEC
      INT   21H
      JNC   SET_ATT            ;Read error?
      CALL  SH0W_ERR           ; If so, display error message
      RET
SET__ATT:   OR CX,1            ; Otherwise, set the read-only
      MOV   AL,1               ;Write the attribute byte
      MOV   AH,43H
      LEA   DX,FILESPEC
      INT   21H
      JNC   LEAVE              ;Write error?
      CALL  SHOW_ERR           ; If so, display error message
LEAVE: RET 
LOCK  ENDP
