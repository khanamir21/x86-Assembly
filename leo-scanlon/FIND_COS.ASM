;  This procedure returns the cosine of the angle (0 to 360 
;  degrees) contained in AX.
;  The cosine, a sign-and-magnitude value, is returned in BX. 
;  The contents of AX are unaffected.
;  This procedure calls FIND_SINE (Example 5-9).
;
EXTRN     FIND_SINE:FAR 
FIND_COS  PROC
		  PUSH   AX            ;Save AX
		  ADD    AX,90         ;Add 90 for use by FIND_SINE 
		  CMP    AX,360        ;Is the result greater than 360?
		  JNA    GET_COS        
		  SUB    AX,360        ; If so, subtract 360 
GET_COS:  CALL   FIND_SINE     ;Look-up the cosine
		  POP    AX 
		  RET 
FIND_COS  ENDP
