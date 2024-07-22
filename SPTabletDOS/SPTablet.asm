; File Name   : D:\Working\SPTablet32\SPTabletDOS\SPTABLET.OLD.COM
; Format      : MS-DOS COM-file

                .8086
                .model tiny

; ===========================================================================

; Segment type: Pure code
seg000          segment
                assume cs:seg000
                org 100h
                assume es:nothing, ss:nothing, ds:seg000;, fs:nothing, gs:nothing

; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

                public start
start           proc near
                mov     ax, 160Ah
                int     2Fh             ; - Multiplex - MS WINDOWS - MS Windows 3.1 - IDENTIFY WINDOWS VERSION AND TYPE
                                        ; Return: AX=0 if supported
                                        ; BX = version (BH=major, BL=minor)
                                        ; CX = mode (2 - standart, 3 - enhanced)
                cmp     ax, 160Ah
                jz      short @start_works
                nop
                nop
                nop
                mov     dx, offset aThisProgramCan
                jmp     loc_10292
; ---------------------------------------------------------------------------

@start_works:                              
                mov     ax, cs
                mov     es, ax
                assume es:seg000
                mov     choice, 0FFh
                nop

@main_loop:                                                                      
                call    parse_arguments
                jnb     short loc_10130 ;if carry is set,
                nop
                nop
                nop
                cmp     ax, 0FFFFh
                jnz     short loc_1017F ; if not finished
                nop
                nop
                nop

loc_1012D:                              
                jmp     loc_102A0 ; parameter error 
; ---------------------------------------------------------------------------

loc_10130:                              
                cmp     al, '1'
                jnz     short loc_10145
                nop
                nop
                nop
                mov     choice, 0
                nop
                mov     port, 3F8h
                jmp     short @main_loop
; ---------------------------------------------------------------------------

loc_10145:                              
                cmp     al, '2'
                jnz     short loc_1015A
                nop
                nop
                nop
                mov     choice, 0
                nop
                mov     port, 2F8h
                jmp     short @main_loop
; ---------------------------------------------------------------------------

loc_1015A:                              
                cmp     al, 'E'
                jnz     short loc_10169
                nop
                nop
                nop
                mov     as_emulation, 1
                nop
                jmp     short @main_loop
; ---------------------------------------------------------------------------

loc_10169:                              
                cmp     al, '?'
                jnz     short loc_10173
                nop
                nop
                nop
                jmp     loc_102A5 ; call help
; ---------------------------------------------------------------------------

loc_10173:                              
                cmp     al, 'M'
                jnz     short loc_1012D
                mov     as_mouse, 0; 0 means Mouse System Mouse
                nop
                jmp     short @main_loop
; ---------------------------------------------------------------------------

loc_1017F:                              
                                        
                call    read_mcr
                and     al, 3
                jnz     short loc_10192
                nop
                nop
                nop
                call    write_mcr_1011_and_delay
                mov     ax, 1Bh
                call    delay_ms

loc_10192:                              
                call    do_handshake
                call    set_interrupt
                mov     al, 0
                call    write_data
                mov     ax, 4
                call    delay_ms
                mov     cx, 2

loc_101A6:                              
                push    cx
                mov     al, 3Fh
                call    write_data
                call    read_data_sp
                pop     cx
                jnb     short loc_101D1
                nop
                nop
                nop
                loopne  loc_101A6
                cmp     choice, 0FFh
                jnz     @do_next
                jmp     loc_1028F
; ---------------------------------------------------------------------------
                align   16
@do_next:
                xor     ax,ax     
                mov     choice, 0
                nop
                mov     di, 2F8h
                mov     port, di
                jmp     short loc_1017F
; ---------------------------------------------------------------------------

loc_101D1:                              
                cmp     al, 4
                jz      short loc_1020B
                nop
                nop
                nop
                cmp     al, 3
                jz      short loc_101F7
                nop
                nop
                nop
                cmp     al, 6
                jz      short loc_10238
                nop
                nop
                nop
                cmp     al, 2
                jz      short loc_1025B
                nop
                nop
                nop
                cmp     al, 8
                jz      short loc_1025B
                nop
                nop
                nop
                jmp     loc_1029B
; ---------------------------------------------------------------------------

loc_101F7:                              
                cmp     as_mouse, 1
                jnz     short loc_10206
                nop
                nop
                nop
                mov     al, 0
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10206:                              
                mov     al, 4Bh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_1020B:                              
                cmp     as_mouse, 1
                jnz     short loc_10233
                nop
                nop
                nop
                cmp     as_emulation, 1
                jz      short loc_10229
                nop
                nop
                nop
                mov     al, 58h
                call    write_data
                mov     al, 6Fh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10229:                              
                mov     al, 4Fh
                call    write_data
                mov     al, 62h
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10233:                              
                mov     al, 4Bh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10238:                              
                cmp     as_mouse, 1
                jnz     short loc_10256
                nop
                nop
                nop
                cmp     as_emulation, 1
                jz      short loc_10251
                nop
                nop
                nop
                mov     al, 6Fh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10251:                              
                mov     al, 5Ah
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10256:                              
                mov     al, 4Bh

loc_10258:                              
                                        
                call    write_data

loc_1025B:                              
                                        
                cmp     as_mouse, 1
                jnz     short loc_10283
                nop
                nop
                nop
                mov     dx, offset aSetTabletModeO
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                cmp     port, 3F8h
                jnz     short loc_1027D
                nop
                nop
                nop
                mov     dx, offset aTabletConnectT
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_1027D:                              
                mov     dx, offset aTabletConnectT_0
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10283:                              
                mov     dx, offset aResetTabletOk

loc_10286:                              
                                        
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C00h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code
; ---------------------------------------------------------------------------

loc_1028F:                              
                mov     dx, offset aTabletIsNotRes

loc_10292:                              
                                        
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C01h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code
; ---------------------------------------------------------------------------

loc_1029B:                              
                mov     dx, offset aNotSpTablet
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A0:                              
                mov     dx, offset aParameterError 
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A5:                              
                mov     dx, offset aSptabletCanUse
                jmp     short loc_10292
start           endp


; =============== S U B R O U T I N E =======================================


write_mcr_1011_and_delay       proc near               
                mov     di, port
                lea     dx, [di+4] ;mcr
                mov     al, 0Bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B5:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B7:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B9:                              
                call    do_out
                mov     ax, 1
                call    delay_ms
                retn
write_mcr_1011_and_delay       endp


; =============== S U B R O U T I N E =======================================


read_mcr       proc near               
                mov     di, port
                lea     dx, [di+4] ;mcr
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CA:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CC:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CE:                              
                call    do_in
                retn
read_mcr       endp


; =============== S U B R O U T I N E =======================================


delay_ms       proc near               
                                        
                push    bx
                push    es
                xor     bx, bx
                mov     es, bx
                assume es:nothing
                add     ax, es:46Ch

loc_102DB:                              
                nop
                nop
                nop
                cmp     ax, es:46Ch
                jg      short loc_102DB
                pop     es
                assume es:nothing
                pop     bx
                retn
delay_ms       endp


; =============== S U B R O U T I N E =======================================


write_data       proc near               
                                        
                push    dx
                mov     ah, al
                mov     di, port
                lea     dx, [di+4] ;mcr
                call    do_in
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F5:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F7:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F9:                              
                lea     dx, [di+5]

loc_102FC:                              
                call    do_in
                test    al, 20h
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10301:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10303:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10305:                              
                jz      short loc_102FC
                lea     dx, [di]
                mov     al, ah
                call    do_out
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_1030E:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10310:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10312:                              
                pop     dx
                retn
write_data       endp


; =============== S U B R O U T I N E =======================================


read_data_sp       proc near               
                call    read_data
                cmp     al, 53h
                jnz     short loc_10320
                nop
                nop
                nop
                mov     al, 6

loc_10320:                              
                cmp     al, 4
                jz      short loc_10343
                nop
                nop
                nop
                cmp     al, 3
                jz      short loc_10343
                nop
                nop
                nop
                cmp     al, 6
                jz      short loc_10343
                nop
                nop
                nop
                cmp     al, 2
                jz      short loc_10343
                nop
                nop
                nop
                cmp     al, 8
                jnz     short loc_1036E_2
                nop

loc_10343:                              
                                        
                clc
                retn
; ---------------------------------------------------------------------------

loc_1036E_2:                              
                stc
                retn
read_data_sp       endp


; =============== S U B R O U T I N E =======================================


read_data       proc near               
                xor     ax, ax
                mov     es, ax
                assume es:nothing
                mov     di, port
                lea     dx, [di+5]
                mov     ah, es:46Ch
                mov     cx, 5

loc_10358:                              
                                        
                call    do_in
                test    al, 1
                jnz     short loc_10370
                nop
                nop
                nop
                cmp     ah, es:46Ch
                jz      short loc_10358
                mov     ah, es:46Ch
                loopne  loc_10358

loc_1036E:                              
                stc
                retn
; ---------------------------------------------------------------------------

loc_10370:                              
                xor     ax, ax
                lea     dx, [di]
                call    do_in
                clc
                retn
read_data       endp


; =============== S U B R O U T I N E =======================================


set_interrupt       proc near               
                mov     di, port
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    set_baud_rate
                mov     dx, 21h
                call    do_in          ; Interrupt controller, 8259A.
                cmp     port, 2F8h
                jnz     short loc_10396
                nop
                nop
                nop
                and     al, 0F7h
                jmp     short loc_10398
; ---------------------------------------------------------------------------

loc_10396:                              
                and     al, 0EFh

loc_10398:                              
                call    do_out          ; Interrupt controller, 8259A.
                lea     dx, [di+4] ;mcr
                mov     al, 0Bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A0:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A2:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A4:                              
                call    do_out
                lea     dx, [di+1]
                mov     al, 1
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103AC:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103AE:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103B0:                              
                call    do_out
                retn
set_interrupt       endp


; =============== S U B R O U T I N E =======================================


set_baud_rate       proc near               
                                        
                mov     di, port
                lea     dx, [di+3]
                mov     al, 80h
                call    do_out
                lea     dx, [di+1]
                mov     al, bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C3:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C5:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C7:                              
                call    do_out
                lea     dx, [di]
                mov     al, bl
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103CE:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103D0:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103D2:                              
                call    do_out
                lea     dx, [di+3]
                mov     al, ah
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DA:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DC:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DE:                              
                call    do_out
                retn
set_baud_rate       endp


; =============== S U B R O U T I N E =======================================


do_handshake       proc near               
                mov     ah, 2
                mov     bx, 60h
                call    set_baud_rate
                mov     al, 0
                call    write_data
                mov     ax, 2
                call    delay_ms
                mov     al, 58h
                call    write_data
                mov     ax, 4
                call    delay_ms
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    set_baud_rate
                retn
do_handshake       endp


; =============== S U B R O U T I N E =======================================


skipws       proc near               
                                        
                mov     al, [bx] ;get char
                cmp     al, '\r'
                jnz     short loc_10415
                nop
                nop
                nop
                xor     al, al ;clear al, and return
                jmp     short locret_10426
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10415:                              
                cmp     al, 0 ;not '\r'
                jz      short locret_10426 ;if NULL, return
                nop
                nop
                nop
                cmp     al, ' '
                jnz     short locret_10426 ;if not ' ' return
                nop
                nop
                nop
                inc     bx  ; next
                jmp     short skipws
; ---------------------------------------------------------------------------

locret_10426:                           
                                        
                retn
skipws       endp


; =============== S U B R O U T I N E =======================================


parse_arguments       proc near               
                mov     bx, argumets_ptr
                cmp     bx, 80h
                jnz     short loc_10444
                nop
                nop
                nop
;starting
                cmp     byte ptr [bx], 0
                jz      short @quit_searching ; if no args found
                nop
                nop
                nop
                inc     bx ;pointer++
                jmp     short loc_10444
; ---------------------------------------------------------------------------
                nop

@quit_searching:

                xor     ah, ah
                stc
                retn
; ---------------------------------------------------------------------------

loc_10444:      ;for args                       
                                        
                call    skipws
                mov     al, [bx]
                cmp     al, '-'
                jz      short loc_10460
                nop
                nop
                nop
                cmp     al, '/'
                jz      short loc_10460
                nop
                nop
                nop
                cmp     al, 0Dh
                jz      short @quit_searching
                mov     ax, 0FFFFh
                stc     ;ax = -1 carry set
                retn
; ---------------------------------------------------------------------------

loc_10460:                              
                                        
                inc     bx
                mov     al, [bx]
                inc     bx
                mov     argumets_ptr, bx
                xor     ah, ah
                clc
                retn
parse_arguments       endp

do_out          proc
                out  dx, al
                ;call do_print_out
                ret
do_out          endp
do_in           proc
                in      al, dx
                ;call    do_print_in
                ret
do_in           endp


do_print_out    proc;dx,al
                push ax
                push dx
                ; print al
                call do_print_chex
                mov  dl,'-'
                mov  ah, 2
                int  21h
                mov  dl,'>'
                mov  ah, 2
                int  21h
                pop  dx
                push dx
                mov  ax,dx
                call do_print_whex
                mov  dl,' '
                mov  ah, 2
                int  21h
                
                pop  dx
                pop  ax
                ret
do_print_out    endp
do_print_in     proc ;al,dx
                push ax
                push dx
                ; print al
                call do_print_chex
                mov  dl,'<'
                mov  ah, 2
                int  21h
                mov  dl,'-'
                mov  ah, 2
                int  21h
                pop  dx
                push dx
                mov  ax,dx
                call do_print_whex
                mov  dl,' '
                mov  ah, 2
                int  21h
                
                pop  dx
                pop  ax
                ret
do_print_in     endp 
do_print_whex   proc ;ax=word
                push bx
                push ax
                mov bx, ax
                mov al, ah
                call do_print_chex

                mov al, bl
                call do_print_chex
                mov dl, ' '
                mov ah, 2
                int 21h ;print space
                pop ax
                pop bx
                ret
do_print_whex   endp
do_print_half   proc ;al:half
                push bx
                push dx
                push ax
                mov  bl,al
                and  al,0fh
                cmp  al,10
                jb   @less_10
                ;>=10
                sub  al,10
                add  al,'A'
                jmp  @do_store
        @less_10:
                add  al,'0'
        @do_store:        
                mov  ah,2
                mov  dl,al
                int  21h
                pop  ax
                pop  dx
                pop  bx
                ret
do_print_half   endp
do_print_chex   proc ;al= byte to show
                push dx
                push ax
                mov  dl,al
                shr al,1
                shr al,1
                shr al,1
                shr al,1
                ;high
                call do_print_half
                ;low
                mov al,dl
                call do_print_half
                pop ax
                pop dx
                ret
do_print_chex   endp

; ---------------------------------------------------------------------------
choice        db 0                    
                                        
              db 10h
port          dw 3F8h                 
                                        
as_mouse      db 1                    
                                        
as_emulation  db 0                    
                                        
argumets_ptr  dw 80h                  
                                        
aParameterError db 'Parameter error!',0Dh,0Ah
                db 'Use  /?, /1, /2 , /E or /M',7,7,0Dh,0Ah,'$'
aTabletIsNotRes db 'Tablet is not Responding!',7,7,0Dh,0Ah,'$'
aNotSpTablet    db 'Not SP Tablet!',7,7,0Dh,0Ah,'$'
aSetTabletModeO db 'Set Tablet Mode OK!',0Dh,0Ah,'$'
aResetTabletOk  db 'Reset Tablet OK!',0Dh,0Ah,'$'
aTabletConnectT db 'Tablet Connect to COM1.',0Dh,0Ah,'$'
aTabletConnectT_0 db 'Tablet Connect to COM2.',0Dh,0Ah,'$'
aThisProgramCan db 'This program can not run within Windows!',0Dh,0Ah
                db 'Exit Wiindows, and run this form DOS prompt.',7,7,0Dh,0Ah,'$'
aSptabletCanUse db 'SPTablet      can use following command.',0Dh,0Ah
                db '  /?          This message.',0Dh,0Ah
                db '  /x          x = 1 or 2 to setup COM1 or COM2.',0Dh,0Ah
                db '  /E          Set Emulation On. SP345 will emulate MM9601,',0Dh,0Ah
                db '                                SP66 will emulate MM1212. ',0Dh,0Ah
                db '  /M          Set Emulation Microsoft Mouse On.',0Dh,0Ah
                db '              If no /M this will set to MM series tablet.',0Dh,0Ah
                db '$'
                db  0
                db 13 dup(0)
seg000          ends


                 end start
