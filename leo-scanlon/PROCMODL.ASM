TITLE	;; (INSERT TITLE HERE)
			PAGE		,132
			PUBLIC		PNAME
;; Insert PUBLIC for data segment variables, if appropriate.)			

DSEG		SEGMENT		PARA PUBLIC 'DATA'

;; (insert date here)
DSEG		ENDS

CSEG		SEGMENT		PARA PUBLIC 'CODE'
			ASSUME		CS:CSEG, D:DSEG

PNAME		PROC		NEAR

;; (Insert instructions here.)

			RET							;Return to calling program
PNAME		ENDP
CSEG		ENDS
			END
			
			
			