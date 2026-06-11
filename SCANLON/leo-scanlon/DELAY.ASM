;  This procedure makes the processor wait for a specified 
;  interval. Enter with minutes in AL, seconds in BH, and 
;  hundredths in BL.
;  No registers are affected.
;  
DELAY   PROC
		PUSH   AX        ;Save affected registers
		PUSH   BX 
		PUSH   CX 
		PUSH   DX
		
		MOV	   AH,2CH    ;Read the current time
		INT	   21H
;
; Add the cur rent time to the input values.
;
	    MOV    AH,CH     ;Hours
	    ADD    AL,CL     ;Minutes
        ADD    BH, DH    ;Seconds
        ADD    BL, DL    ;Hundredths
;
; Adjust the results to produce a legal target time.
;
        CMP    BL,100    ;Hundredths must be < 100
	    JB     SECS
	    SUB    BL,100
        INC    BH
SECS:   CMP    BH,60     ;Minutes must be < 60
		JB     MINS
        SUB    BH,60
        INC    AL
MINS:   CMP    AL,60     ;Seconds must be < 60
        JB     HRS
        SUB    AL,60
        INC    AH
HRS:    CMP    AH,24     ;Hours must be < 24
        JNE    CHECK
        SUB    AH,AH
;
; Wait unti time matches target.
;
CHECK:  PUSH   AX        ;Read the time again
        MOV    AH,2CH
	    INT    21H
	    POP    AX
        CMP    CX, AX    ;Compare hours and minutes
        JA     QUIT
        JB     CHECK
        CMP    DX,BX     ;Compare seconds and hundredth
        JB     CHECK
QUIT:   POP    DX        ;Restore registers
        POP    CX
        POP    BX
        POP    AX
        RET   
DELAY   ENDP

