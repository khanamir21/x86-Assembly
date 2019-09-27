title timeout
; Program by Chee Yap (fall 1996)
;
; This program will wait for N ticks (N is the value of the
;	variable "HowLong")
; If you type a keyboard character before N ticks,
;	the message "you are in time!" is displayed.
; Otherwise, the message "timeout!" is displayed.
;
; We have 3 GOALS:
;	-- illustrate how to setup interrupts (procedure
;		setup_int is found in file setupint.asm,
;		from p.319, ch.15, pgm15_2a.asm)
;	-- illustrate use of the timer_tick procedure
;		(found in file tick.asm, from p. 344,ch.16)
; 	-- illustrate use of int 16h, function 1
;		(testing if keyboard buffer is empty)
;
; To assemble, run the batfile timeoutX.bat, which contains:
;	-- tasm timeout+setupint+tick
;	-- tlink timeout+setupint+tick
;
PUBLIC timer_flag
EXTRN timer_tick:near, setup_int:near
.model small
.stack 100h
.data
HowLong         dw 50           ; 50 ticks
waitchar        db '.'
timer_flag      db 0    
new_timer_vec   dw ?,?
old_timer_vec   dw ?,?
.code
if1
        include ..\mac\mac.asm
endif
main proc
        init_ds ; macro
; setup timer interrupt
        mov new_timer_vec, offset timer_tick
        mov new_timer_vec+2, cs
        mov al, 1ch
        lea di, old_timer_vec
        lea si, new_timer_vec
        call setup_int
; wait for keyboard
        mov cx,HowLong
waiting:
        cmp timer_flag,1
        jne waiting
        mov timer_flag,0
        mov ah,1
        int 16h         ; zf=1 if buffer empty
        jnz TimeIn
; print waiting character        
        mov ah,02h
        mov dl,waitchar
        int 21h
        loop waiting
; TimeOut
        disp_str 'You are timed out!'
        jmp Done
TimeIn:
        disp_str 'You are in time!'
Done:
; restore old int vector
        lea di,new_timer_vec
        lea si,old_timer_vec
        mov al,1ch
        call setup_int
;
        dos_rtn 0
main    endp
        end main
