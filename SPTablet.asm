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
;                .386
;                .model tiny
; ===========================================================================

                org 100h

; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

start:
                mov     ax, 160Ah
                int     2Fh             ; - Multiplex - MS WINDOWS - MS Windows 3.1 - IDENTIFY WINDOWS VERSION AND TYPE
                                        ; Return: AX=0 if supported
                                        ; BX = version (BH=major, BL=minor)
                                        ; CX = mode (2 - standart, 3 - enhanced)
                cmp     ax, 160Ah
                jz      short when_ax_160AH
                nop
                nop
                nop
                mov     dx, aExitWindowsAnd        ; Exit Wiindows, and run this form DOS prompt
                jmp     do_print_string_with_dollar
; ---------------------------------------------------------------------------

when_ax_160AH:                          
                mov     ax, cs
                mov     es, ax          ; es=cs
                mov     byte [byte_1046C], 0FFh
                nop

loc_1011D:                              
                                        
                call    sub_10427
                jnb     short loc_10130
                nop
                nop
                nop
                cmp     ax, 0FFFFh
                jnz     short loc_1017F
                nop
                nop
                nop

loc_1012D:                              
                jmp     loc_102A0
loc_10130:                              
                cmp     al, 31h
                jnz     short loc_10145
                nop
                nop
                nop
                mov     byte [byte_1046C], 0
                nop
                mov     word [_3f8_port], 3F8h
                jmp     short loc_1011D

loc_10145:                              
                cmp     al, 32h
                jnz     short loc_1015A
                nop
                nop
                nop
                mov     byte [byte_1046C], 0
                nop
                mov     word [_3f8_port], 2F8h
                jmp     short loc_1011D

loc_1015A:                              
                cmp     al, 45h
                jnz     short loc_10169
                nop
                nop
                nop
                mov     byte [byte_10471], 1
                nop
                jmp     short loc_1011D

loc_10169:                             
                cmp     al, 3Fh
                jnz     short loc_10173
                nop
                nop
                nop
                jmp     loc_102A5

loc_10173:                              
                cmp     al, 4Dh
                jnz     short loc_1012D
                mov     byte [byte_10470], 0
                nop
                jmp     short loc_1011D

loc_1017F:                              
                                        
                call    _read_3fc
                and     al, 3
                jnz     short loc_10192
                nop
                nop
                nop
                call    test_com2
                mov     ax, 1Bh
                call    check_46c

loc_10192:                              
                call    sub_103E0
                call    comp_2f8
                mov     al, 0
                call    read_3fc_3fd
                mov     ax, 4
                call    check_46c
                mov     cx, 2

loc_101A6:                              
                push    cx
                mov     al, 3Fh
                call    read_3fc_3fd
                call    sub_10314
                pop     cx
                jnb     short loc_101D1
                nop
                nop
                nop
                loopne  loc_101A6
                cmp     byte[byte_1046C], 0FFh
                nop
                jz      short loc_101C2
                jmp     loc_1028F

loc_101C2:                              
                mov     byte [byte_1046C], 0
                nop
                mov     di, 2F8h
                mov     word [_3f8_port], di
                jmp     short loc_1017F

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

loc_101F7:                              
                cmp     byte [byte_10470], 1
                jnz     short loc_10206
                nop
                nop
                nop
                mov     al, 0
                jmp     short loc_10258
                align 2

loc_10206:                              
                mov     al, 4Bh
                jmp     short loc_10258
                nop

loc_1020B:                              
                cmp     byte [byte_10470], 1
                jnz     short loc_10233
                nop
                nop
                nop
                cmp     byte [byte_10471], 1
                jz      short loc_10229
                nop
                nop
                nop
                mov     al, 58h
                call    read_3fc_3fd
                mov     al, 6Fh
                jmp     short loc_10258
                nop

loc_10229:                              
                mov     al, 4Fh
                call    read_3fc_3fd
                mov     al, 62h
                jmp     short loc_10258
                nop

loc_10233:                              
                mov     al, 4Bh
                jmp     short loc_10258
                align 2

loc_10238:                              
                cmp     byte [byte_10470], 1
                jnz     short loc_10256
                nop
                nop
                nop
                cmp     byte [byte_10471], 1
                jz      short loc_10251
                nop
                nop
                nop
                mov     al, 6Fh
                jmp     short loc_10258
                nop

loc_10251:                              
                mov     al, 5Ah
                jmp     short loc_10258
                align 2

loc_10256:                              
                mov     al, 4Bh

loc_10258:                              
                                       
                call    read_3fc_3fd

loc_1025B:                             
                                        
                cmp     byte [byte_10470], 1
                jnz     short loc_10283
                nop
                nop
                nop
                mov     dx, 4D6h
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                cmp     word [_3f8_port], 3F8h
                jnz     short loc_1027D
                nop
                nop
                nop
                mov     dx, 4FFh
                jmp     short loc_10286
                nop

loc_1027D:                              
                mov     dx, 519h
                jmp     short loc_10286
                nop

loc_10283:                              
                mov     dx, 4ECh

loc_10286:                              
                                        
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C00h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code

loc_1028F:                              
                mov     dx, 4A5h

do_print_string_with_dollar:            
                                        
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C01h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code

loc_1029B:                              
                mov     dx, 4C3h
                jmp     short do_print_string_with_dollar

loc_102A0:                              
                mov     dx, 474h
                jmp     short do_print_string_with_dollar
; ---------------------------------------------------------------------------

loc_102A5:                              
                mov     dx, 58Eh
                jmp     short do_print_string_with_dollar


test_com2:           
                mov     di, _3f8_port
                lea     dx, [di+4]
                mov     al, 0Bh
                jmp     short $+2

loc_102B5:                              
                jmp     short $+2

loc_102B7:                             
                jmp     short $+2       ; 0B->3fC (com2)

loc_102B9:                              
                out     dx, al          ; 0B->3fC (com2)
                mov     ax, 1
                call    check_46c
                retn


_read_3fc:            
                mov     di, _3f8_port
                lea     dx, [di+4]
                jmp     short $+2

loc_102CA:                             
                jmp     short $+2

loc_102CC:                              
                jmp     short $+2

loc_102CE:                              
                in      al, dx
                retn


check_46c:     
                push    bx
                push    es
                xor     bx, bx
                mov     es, bx
                add     ax, es:46Ch

loc_102DB:                              
                nop
                nop
                nop
                cmp     ax, es:46Ch
                jg      short loc_102DB
                pop     es
                pop     bx
                retn

read_3fc_3fd:             
                                       
                push    dx
                mov     ah, al
                mov     di, _3f8_port
                lea     dx, [di+4]
                in      al, dx
                jmp     short $+2

loc_102F5:                              
                jmp     short $+2

loc_102F7:                              
                jmp     short $+2

loc_102F9:                              
                lea     dx, [di+5]

loc_102FC:                              
                in      al, dx
                test    al, 20h
                jmp     short $+2

loc_10301:                              
                jmp     short $+2

loc_10303:                             
                jmp     short $+2

loc_10305:                              
                jz      short loc_102FC
                lea     dx, [di]
                mov     al, ah
                out     dx, al
                jmp     short $+2

loc_1030E:                             
                jmp     short $+2

loc_10310:                              
                jmp     short $+2

loc_10312:                              
                pop     dx
                retn


sub_10314:               
                call    read_3f8_plus_5
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
                jnz     short loc_1036E
                nop
                nop
                nop

loc_10343:                              
                                    
                clc
                retn


read_3f8_plus_5:              
                xor     ax, ax
                mov     es, ax
                mov     di, _3f8_port
                lea     dx, [di+5]
                mov     ah, es:46Ch
                mov     cx, 5

loc_10358:                             
                                    
                in      al, dx
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

loc_10370:                              
                xor     ax, ax
                lea     dx, [di]
                in      al, dx
                clc
                retn



comp_2f8:              
                mov     di, _3f8_port
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    write_3fb_3f8_with_80
                mov     dx, 21h
                in      al, dx          
                cmp     word [_3f8_port], 2F8h
                jnz     short loc_10396
                nop
                nop
                nop
                and     al, 0F7h
                jmp     short loc_10398

loc_10396:                              
                and     al, 0EFh

loc_10398:                              
                out     dx, al          ; Interrupt controller, 8259A.
                lea     dx, [di+4]
                mov     al, 0Bh
                jmp     short $+2

loc_103A0:                              
                jmp     short $+2

loc_103A2:                              
                jmp     short $+2

loc_103A4:                              
                out     dx, al
                lea     dx, [di+1]
                mov     al, 1
                jmp     short $+2

loc_103AC:                              
                jmp     short $+2

loc_103AE:                              
                jmp     short $+2

loc_103B0:                              
                out     dx, al
                retn


write_3fb_3f8_with_80:   
                                        
                mov     di, _3f8_port
                lea     dx, [di+3]
                mov     al, 80h
                out     dx, al
                lea     dx, [di+1]
                mov     al, bh
                jmp     short $+2

loc_103C3:                             
                jmp     short $+2

loc_103C5:                              
                jmp     short $+2

loc_103C7:                              
                out     dx, al
                lea     dx, [di]
                mov     al, bl
                jmp     short $+2

loc_103CE:                              
                jmp     short $+2

loc_103D0:                              
                jmp     short $+2

loc_103D2:                              
                out     dx, al
                lea     dx, [di+3]
                mov     al, ah
                jmp     short $+2

loc_103DA:                              
                jmp     short $+2

loc_103DC:                              
                jmp     short $+2

loc_103DE:                             
                out     dx, al
                retn


sub_103E0:               
                mov     ah, 2
                mov     bx, 60h
                call    write_3fb_3f8_with_80
                mov     al, 0
                call    read_3fc_3fd
                mov     ax, 2
                call    check_46c
                mov     al, 58h
                call    read_3fc_3fd
                mov     ax, 4
                call    check_46c
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    write_3fb_3f8_with_80
                retn


sub_10407:              
                                        
                mov     al, [bx]
                cmp     al, 0Dh
                jnz     short loc_10415
                nop
                nop
                nop
                xor     al, al
                jmp     short locret_10426
                nop

loc_10415:                              
                cmp     al, 0
                jz      short locret_10426
                nop
                nop
                nop
                cmp     al, 20h
                jnz     short locret_10426
                nop
                nop
                nop
                inc     bx
                jmp     short sub_10407

locret_10426:                           
                                        
                retn


sub_10427:          
                mov     bx, word_10472
                cmp     bx, 80h
                jnz     short loc_10444
                nop
                nop
                nop
                cmp     byte [bx], 0
                jz      short loc_10440
                nop
                nop
                nop
                inc     bx
                jmp     short loc_10444
                align 2

loc_10440:                              
                                        
                xor     ah, ah
                stc
                retn

loc_10444:                              
                                        
                call    sub_10407
                mov     al, [bx]
                cmp     al, 2Dh
                jz      short loc_10460
                nop
                nop
                nop
                cmp     al, 2Fh
                jz      short loc_10460
                nop
                nop
                nop
                cmp     al, 0Dh
                jz      short loc_10440
                mov     ax, 0FFFFh
                stc
                retn

loc_10460:                              
                                        
                inc     bx
                mov     al, [bx]
                inc     bx
                mov     word [word_10472], bx
                xor     ah, ah
                clc
                retn

byte_1046C      db 0                    
                                        
                db 10h
_3f8_port       dw 3F8h                 
                                        
byte_10470      db 1                    
                                        
byte_10471      db 0                    
                                        
word_10472      dw 80h                  
                                        
aParameterError db 'Parameter error!',0Dh,0Ah
                db 'Use  /?, /1, /2 , /E or /M',7,7,0Dh,0Ah,'$'
aTabletIsNotRes db 'Tablet is not Responding!',7,7,0Dh,0Ah,'$'
aNotSpTablet    db 'Not SP Tablet!',7,7,0Dh,0Ah,'$'
aSetTabletModeO db 'Set Tablet Mode OK!',0Dh,0Ah,'$'
aResetTabletOk  db 'Reset Tablet OK!',0Dh,0Ah,'$'
aTabletConnectT db 'Tablet Connect to COM1.',0Dh,0Ah,'$'
aTabletConnectT_0 db 'Tablet Connect to COM2.',0Dh,0Ah,'$'
aThisProgramCan db 'This program can not run within Windows!',0Dh,0Ah
aExitWindowsAnd db 'Exit Wiindows, and run this form DOS prompt.',7,7,0Dh,0Ah,'$'
aSptabletCanUse db 'SPTablet      ;can use following command.',0Dh,0Ah
                db '  /?          ;This message.',0Dh,0Ah
                db '  /x          ;x = 1 or 2 to setup COM1 or COM2.',0Dh,0Ah
                db '  /E          ;Set Emulation On. SP345 will emulate MM9601,',0Dh,0Ah
                db '              ;                  SP66 will emulate MM1212. ',0Dh,0Ah
                db '  /M          ;Set Emulation Microsoft Mouse On.',0Dh,0Ah
                db '              ;If no /M this will set to MM series tablet.',0Dh,0Ah
                db '$'
                db    0
                align 10h