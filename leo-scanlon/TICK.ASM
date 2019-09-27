title pgm16_2b, timer_tick
; 
; timer interrupt routine from p.344 of text
;
        EXTRN timer_flag:byte
        PUBLIC timer_tick
.model small
.code
; 
timer_tick proc
        push ds
        push ax
        mov ax,seg timer_flag
        mov ds,ax
        mov timer_flag,1
        pop ax
        pop ds
        iret
timer_tick endp
        end
