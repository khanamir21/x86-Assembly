;  This procedure converts a hexadecimal digit in AL to its 
;  ASCII, BCD, and EBCDIC equivalents. The converted values 
;  are returned in CH, CL and AH, respectively.
;  The contents of AL are unaffected.
;  Store these look-up tables in the data segment.
;
ASCII  DB   '10123456789ABCDEF1'
BCD    DB   0,1,2,3,4,5,6,7,8,9,1OH,11H,12H,13H,14H,15H
EBCDIC DB   0F0H,0F1H,0F2H,0F3H,0F4H,0F5H,QF6H,0F7H
       DB   0F8H,0F9H,0C1H,0C2H,0C3H,0C4H,0C5H,0C6H
;
;  Here is the conversion procedure.
;
CONV_HEX  PROC
          PUSH  BX         ;Save BX and DX
		  PUSH  DX         
		  MOV   DL,AL      ;Save the input value in DL
		  LEA   BX,ASCII   ;Look-up the ASCII value
		  XLAT  ASCII      
		  MOV   CH,AL      ; and load it into CH
		  MOV   AL,DL      
		  LEA   BX,BCD     ;Look-up the BCD value
		  XLAT  BCD        
		  MOV   CL,AL      ; and load it into CL
          MOV   AL,DL
          LEA   BX,EBCDIC ;Look-up the EBCDIC value XLAT EBCDIC
          MOV   AH,AL     ; and load it into AH
          MOV   AL,DL     ;Restore registers
          POP   DX
          POP   BX
          RET  
CONV_HEX  ENDP
