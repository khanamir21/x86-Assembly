; This procedure returns the sine of the angle (0 to 360 
; degrees) contained in AX.
; The sine, a sign-and-magnitude value, is returned in BX.
; The contents of AX are unaffected.
;
;  Store this sine look-up table in the data segment.
;
SINES  DW  0,175,349,523,698,872     ;0-5
       DW  1045,1219,1392,1564,1736  ;6-10
       DW  1908,2079,2250,2419,2588  ;11-15
	   DW  2756,2924,3090,3256,3420  ;16-20
       DW  3584,3746,3907,4067,4226  ;21-25
	   DW  4384,4540,4695,4848,5000  ;26-30
	   DW  5150,5299,5446,5592,5736  ;31-35
       DW  5878,6018,6157,6293,6428  ;36-40
       DW  6561,6691,6820,6947,7071  ;41-45
       DW  7193,7313,7431,7547,7660  ;46-50
       DW  7771,7880,7986,8090,8191  ;51-55
       DW  8290,8387,8480,8572,8660  ;56-60
       DW  8746,8829,8910,8988,9063  ;61-65
       DW  9135,9205,9272,9336,9397  ;66-70
       DW  9455,9511,9563,9613,9659  ;71-75
       DW  9703,9744,9781,9816,9848  ;76-80
       DW  9877,9903,9926,9945,9962  ;81-85
       DW  9976,9986,9994,9998,10000 ;86-90
;
; This is the Look-up procedure.
;
FIND_SINE  PR0C
		   PUSH   AX 		    ;Save AX
           PUSH   CX 		    ; and CX
		   SUB    CX,CX 	    ;Initialize sign to 0
		   CMP    AX,181        ;Angle < 181 degrees?
		   JB     SIN_P0S       ; Yes. Continue with sign = 0
           MOV    CX,8000H      ; No.  Set sign = 1
		   SUB    AX,180        ;  and 1 subtract 180 from angle
SIN_P0S:   CMP    AX,91         ;Angle < 91 degrees?
           JB     GET_SIN       ; Yes. Go Look up sine
           NEG    AX            ; No. Subtract angle from 180
           ADD    AX,180        
GET_SIN:   MOV    BX,AX         ;Make angle a word index
           SHL    BX, 1
           MOV    BX,SINES[BX]  ; and look up the sine value
           OR     BX,CX         ;Combine sine with sign bit
           POP    CX
		   POP    AX 
		   RET
FIND_SINE  ENDP
