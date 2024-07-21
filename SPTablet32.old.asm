; +-------------------------------------------------------------------------+
; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |           Copyright (c) 2017 Hex-Rays, <support@hex-rays.com>           |
; |                      License info: 48-3FBD-7F04-2C                      |
; |                      Jiang Ying, Personal license                       |
; +-------------------------------------------------------------------------+
;
; Input SHA256 : 224240BF7E4A61B560617EB696DDE1211B1B52EC1E8CA94E71B38271F793A3C0
; Input MD5    : 5DF4B308E00A53E55E081D9381F88219
; Input CRC32  : 8EC6977D

; File Name   : D:\Working\WORKS\SPTABLET.COM
; Format      : MS-DOS COM-file
; Base Address: 1000h Range: 10100h-10700h Loaded length: 600h
.386
.model flat,stdcall
option casemap:none


include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc

includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.code
start:
;                xor     eax, eax
;                cmp     eax, 0
;                jz      is_correct_system
;                mov     edx, offset aExitWindowsAnd        ; Exit Wiindows, and run this form DOS prompt
;                jmp     @exit_program_with_error
;is_correct_system:                          
main            proc
                mov     dword ptr[choice], -1
@try_parameters_loop:                                                                      
                call    prepare
                jnb     @try_parameter_1
                cmp     eax, -1
                jnz     @post_parameters_loop

@try_parameter_others:                              
                jmp     @show_parameter_error
@try_parameter_1:                              
                cmp     al, '1'
                jnz     @try_parameter_2
                mov     dword ptr[choice], 0
                mov     dword ptr[current_port], 3F8h
                jmp     @try_parameters_loop

@try_parameter_2:                              
                cmp     al, '2'
                jnz     @try_parameter_e
                mov     dword ptr[choice], 0
                mov     dword ptr[current_port], 2F8h
                jmp     @try_parameters_loop

@try_parameter_e:                              
                cmp     al, 'E'
                jnz     @try_parameter_help
                mov     dword ptr[use_emulation], 1
                jmp     @try_parameters_loop

@try_parameter_help:                             
                cmp     al, '?'
                jnz     @try_parameter_mm_series
                jmp     @show_usage

@try_parameter_mm_series:                              
                cmp     al, 'M'
                jnz     @try_parameter_others
                mov     dword ptr[use_mmseries], 0
                jmp     @try_parameters_loop

@post_parameters_loop:                              
                                        
                call    read_mcr
                and     al, 3  ;CTS=1,DTR=1
                jnz     @on_cts_dtr_ready
                call    write_msr_delay
                mov     eax, 1Bh
                call    delay_ms

@on_cts_dtr_ready:                              
                call    do_handshake
                call    set_interrupt
                mov     al, 0
                call    write_data
                mov     eax, 4
                call    delay_ms
                mov     ecx, 2

@retry_rw:                              
                push    ecx
                mov     al, 3Fh
                call    write_data
                call    read_data_wrapper
                pop     ecx
                jnb     @quit_retry_rw
                loopne  @retry_rw
                cmp     dword ptr[choice], -1
                jz      @try_com_other
                jmp     @tablet_is_not_responding

@try_com_other:                              
                mov     dword ptr[choice], 0
                mov     edi, 2F8h
                mov     dword ptr[current_port], edi
                jmp     @post_parameters_loop

@quit_retry_rw:                              
                cmp     al, 4
                jz      @_al_4
                cmp     al, 3
                jz      @_al_3
                cmp     al, 6
                jz      @_al_6
                cmp     al, 2
                jz      @_al_8
                cmp     al, 8
                jz      @_al_8
                jmp     @set_mode

@_al_3:                              
                cmp     dword ptr[use_mmseries], 1
                jnz     @_no_use_mm_3
                mov     al, 0
                jmp     @do_read_write
@_no_use_mm_3:                              
                mov     al, 4Bh
                jmp     @do_read_write
@_al_4:                              
                cmp     dword ptr[use_mmseries], 1
                jnz     @_no_use_mm_4
                cmp     dword ptr[use_emulation], 1
                jz      @_use_emulation_4
                mov     al, 58h
                call    write_data
                mov     al, 6Fh
                jmp     @do_read_write

@_use_emulation_4:                              
                mov     al, 4Fh
                call    write_data
                mov     al, 62h
                jmp     @do_read_write

@_no_use_mm_4:                              
                mov     al, 4Bh
                jmp     @do_read_write

@_al_6:                              
                cmp     dword ptr[use_mmseries], 1
                jnz     @no_use_emulation_6
                cmp     dword ptr[use_emulation], 1
                jz      @use_emulation_6
                mov     al, 6Fh
                jmp     @do_read_write

@use_emulation_6:                              
                mov     al, 5Ah
                jmp     @do_read_write

@no_use_emulation_6:                              
                mov     al, 4Bh

@do_read_write:                              
                                       
                call    write_data

@_al_8:                             
                                        
                cmp     dword ptr[use_mmseries], 1
                jnz     @rest_tablet_ok
                mov     edx, offset aSetTabletModeO

                push    MB_OK
                push    offset aTitle
                push    edx
                push    0
                call    MessageBox

                cmp     dword ptr[current_port], 3F8h
                jnz     @not_com_1
                mov     edx, offset aTabletConnectT_1
                jmp     @exit_program_with_ok
                nop

@not_com_1:                              
                mov     edx, offset aTabletConnectT_2
                jmp     @exit_program_with_ok

@rest_tablet_ok:                              
                mov     edx, OFFSET aResetTabletOk

@exit_program_with_ok:
                push MB_OK
                push offset aTitle
                push edx
                push 0
                call MessageBox

                push 0
                call ExitProcess        ;return 0

@tablet_is_not_responding:                              
                mov     edx, offset aTabletIsNotRes

@exit_program_with_error:            
                push MB_OK+MB_ICONASTERISK
                push offset aTitle
                push edx
                push 0
                call MessageBox

                push 1
                call ExitProcess        ;return 1 
                                        

@set_mode:                              
                mov     edx, offset aSetTabletModeO
                jmp     @exit_program_with_error

@show_parameter_error:                              
                mov     edx, offset aParameterError 
                jmp     @exit_program_with_error

@show_usage:                              
                mov     edx, offset aSptabletCanUse
                jmp     @exit_program_with_error
main            endp

write_msr_delay    proc           
                mov     edi, current_port
                lea     edx, [edi+4]    ; MSR
                mov     eax, 0Bh        ; 00001011
                out     dx, al          ; 0B->3fC (com2)
                mov     eax, 1
                call    delay_ms
                retn

write_msr_delay    endp

read_mcr        proc         
                mov     edi, current_port
                lea     edx, [edi+4]
                in      al, dx
                retn
read_mcr        endp

read_lsr        proc
                mov     edi, current_port
                lea     edx, [edi+5]
                in      al, dx
                retn
read_lsr        endp

delay_ms        proc
                push    ebx
                add     eax, dword ptr[46CH]

@delay_ms_repeat:                              
                cmp     eax, es:[46CH]
                jg      @delay_ms_repeat
                pop     ebx
                retn
delay_ms        endp

write_data  proc            
                                       
                push    edx
                mov     ah, al
                mov     edi, current_port
                lea     edx, [edi+4]
                in      al, dx
                lea     edx, [edi+5]

@retry_reading:                              
                in      al, dx
                test    al, 20h
                jz      @retry_reading
                lea     edx, [edi]
                mov     al, ah
                out     dx, al
                pop     edx
                retn

write_data  endp

read_data_wrapper    proc              
                call    read_data
                cmp     al, 53h
                jnz     @not_53h
                mov     al, 6

@not_53h:                             
                cmp     al, 4
                jz      @clc_ret
                cmp     al, 3
                jz      @clc_ret
                cmp     al, 6
                jz      @clc_ret
                cmp     al, 2
                jz      @clc_ret
                cmp     al, 8
                jnz     @stc_ret

@clc_ret:                               
                                    
                clc
                retn
@stc_ret:                              
                stc
                retn

read_data_wrapper    endp              

read_data       proc              
                xor     ax, ax
                mov     es, ax
                mov     edi, current_port
                lea     edx, [edi+5]
                mov     ah, es:46Ch
                mov     ecx, 5

@read_loop:                             
                                    
                in      al, dx
                test    al, 1
                jnz     @quit_read_loop
                cmp     ah, es:46Ch
                jz      @read_loop
                mov     ah, es:46Ch
                loopne  @read_loop

                stc
                retn

@quit_read_loop:                              
                xor     eax, eax
                lea     edx, [edi]
                in      al, dx
                clc
                retn

read_data       endp              


set_interrupt        proc             
                mov     edi, current_port
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    set_baudrate
                mov     dx, 21h
                in      al, dx          
                cmp     dword ptr[current_port], 2F8h
                jnz     @do_mask
                and     al, 0F7h
                jmp     @do_output

@do_mask:                              
                and     al, 0EFh

@do_output:                              
                out     dx, al          ; Interrupt controller, 8259A.
                lea     edx, [edi+4]
                mov     al, 0Bh
                out     dx, al
                lea     edx, [edi+1]
                mov     al, 1
                out     dx, al
                retn

set_interrupt        endp
set_baudrate proc  
                                        
                mov     edi, current_port
                lea     edx, [edi+3] ; use as lcr
                mov     al, 80h
                out     dx, al
                lea     edx, [edi+1] ;baud rate high
                mov     al, bh
                out     dx, al
                lea     edx, [edi+0]  ;baud rate low
                mov     al, bl
                out     dx, al
                lea     edx, [edi+3] ;lcr
                mov     al, ah
                out     dx, al
                retn

set_baudrate endp  

do_handshake       proc               
                mov     ah, 2
                mov     bx, 60h
                call    set_baudrate
                mov     al, 0
                call    write_data
                mov     eax, 2
                call    delay_ms
                mov     al, 58h
                call    write_data
                mov     eax, 4
                call    delay_ms
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    set_baudrate
                retn

do_handshake       endp               

skip_spaces       proc        
@retry_next:                                        
                mov     al, [ebx]
                cmp     al, 0Dh
                jnz     @next_loop
                xor     al, al
                jmp     @exit_loop
@next_loop:                              
                cmp     al, 0
                jz      @exit_loop
                cmp     al, 20h
                jnz     @exit_loop
                inc     ebx
                jmp     @retry_next

@exit_loop:                           
                                        
                retn
skip_spaces       endp        


prepare       proc
                mov     ebx, counter
                cmp     ebx, 80h
                jnz     @skip_init
                cmp     byte ptr[ebx], 0
                jz      @exit_loop_80
                inc     ebx
                jmp     @skip_init
@exit_loop_80:                              
                                        
                xor     ah, ah
                stc
                retn

@skip_init:                              

                call    skip_spaces
                mov     al, [ebx]
                cmp     al, 2Dh
                jz      @do_next_step
                cmp     al, 2Fh
                jz      @do_next_step
                cmp     al, 0Dh
                jz      @exit_loop_80
                mov     eax, -1
                stc
                retn

@do_next_step:                                                                      
                inc     ebx
                mov     al, [ebx]
                inc     ebx
                mov     dword ptr[counter], ebx
                xor     ah, ah
                clc
                retn
prepare         endp

.data
choice          dd 0                    
current_port    dd 3F8h                                                         
use_mmseries    dd 1                                                           
use_emulation   dd 0                                                            
counter         dd 80h                  
aTitle          db 'SPTablet32',0                                        
aParameterError db 'Parameter error!',0
aUsage          db 'Use  /?, /1, /2 , /E or /M',0
aTabletIsNotRes db 'Tablet is not Responding!',0
aNotSpTablet    db 'No SP Tablet found!',0
aSetTabletModeO db 'Set Tablet Mode OK!',0
aResetTabletOk  db 'Reset Tablet OK!',0
aTabletConnectT_1 db 'Tablet Connect to COM1.',0
aTabletConnectT_2 db 'Tablet Connect to COM2.',0
aThisProgramCan db 'This program can not run within Windows!',0
aExitWindowsAnd db 'Exit Wiindows, and run this form DOS prompt.',0
aSptabletCanUse db 'SPTablet      can use following command.',0Dh,0Ah
                db '  /?          This message.',0Dh,0Ah
                db '  /x          x = 1 or 2 to setup COM1 or COM2.',0Dh,0Ah
                db '  /E          Set Emulation On. SP345 will emulate MM9601,',0Dh,0Ah
                db '                                SP66 will emulate MM1212. ',0Dh,0Ah
                db '  /M          Set Emulation Microsoft Mouse On.',0Dh,0Ah
                db '              If no /M this will set to MM series tablet.',0Dh,0Ah
                db    0
end start