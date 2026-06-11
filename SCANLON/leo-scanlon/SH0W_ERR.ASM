;  Displays a message based on an error code in AX. 
;  No registers are affected.
;
;  Put these values in the data segment:
;
CR EQU 13 
LF EQU 10 
EOM EQU '$' 
0UT_0F_RANGE  DB   'Error code CR,LF,E0M is not in valid range (1-18)'
			  DB   CR,LF,EOM

ER1   DB    'Invalid function number',CR,LF,EOM 
ER2   DB    'File not found',CR,LF,E0M 
ER3   DB    'Path not found',CR,LF,E0M
ER4   DB    'Too many open files (No handles left)',CR,LF,E0M 
ER5   DB    'Invalid handle',CR,LF,EOM
ER6   DB    'Access denied',CR,LF,EOM 
ER7   DB    'Memory control blocks destroyed',CR,LF,EOM
ER8   DB    'Insufficient memory',CR,LF,EOM
ER9   DB    'Invalid memory block address',CR,LF,EOM
ER10  DB    'Invalid environment',CR,LF,E0M
ER11  DB    'Invalid format',CR,LF,E0M
ER12  DB    'Invalid access code',CR,LF,EOM
ER13  DB    'Invalid data',CR,LF,E0M
ER14  DB    'No such message',CR,LF,EOM
ER15  DB    'Invalid drive was specified',CR,LF,E0M
ER16  DB    'Attempted to remove current directory',CR,LF,EOM
ER17  DB    'Not same device',CR,LF,E0M
ER18  DB    'No more fi les',CR,LF,E0M
ERTAB DW    ER1,ER2,ER3,ER4,ER5,ER6,ER7,ER8,ER9
      DW    ER10,ER11,ER12,ER13,ER14,ER15,ER16,ER17,ER18

SH0W_ERR  PROC
		  PUSH  AX              ;Save input error code
		  PUSH  BX 				;Save other working registers
		  PUSH  CX
		  CMP   AX,18 			;Make sure error code is < 18
		  JG    O_O_R
		  CMP   AX,0
		  JG    IN_RANGE
O_O_R:    LEA   DX,OUT_OF_RANGE
          JMP   SHORT DISP_MSG
IN_RANGE: LEA   BX,ERTAB-2
		  SHL   AX, 1
		  ADD   BX, AX
		  MOV   DX,[BX]         ;Put nessage address into BX 
DISP_MSG: MOV   AH,9            ;Display message string   
		  INT   21H
		  POP   DX
		  POP   BX
		  POP   AX
		  RET
SH0W_ERR  ENDP