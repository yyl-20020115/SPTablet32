.386
.model flat,stdcall
option casemap:none


include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc

includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.code
; ===========================================================================

; Attributes: noreturn
public start
start:
                mov     byte_1046C, 0FFh
                nop

loc_1011D:                              
                                        
                call    ProcessArguments
                jnb     short loc_10130
                nop
                nop
                nop
                cmp     eax, -1
                jnz     short loc_1017F
                nop
                nop
                nop

loc_1012D:                              
                jmp     loc_102A0
; ---------------------------------------------------------------------------

loc_10130:                              
                cmp     al, '1'
                jnz     short loc_10145
                nop
                nop
                nop
                mov     byte_1046C, 0
                nop
                mov     port, 3F8h
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_10145:                              
                cmp     al, '2'
                jnz     short loc_1015A
                nop
                nop
                nop
                mov     byte_1046C, 0
                nop
                mov     port, 2F8h
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_1015A:                              
                cmp     al, 45h
                jnz     short loc_10169
                nop
                nop
                nop
                mov     byte_10471, 1
                nop
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_10169:                              
                cmp     al, 3Fh
                jnz     short loc_10173
                nop
                nop
                nop
                jmp     loc_102A5
; ---------------------------------------------------------------------------

loc_10173:                              
                cmp     al, 4Dh
                jnz     short loc_1012D
                mov     byte_10470, 0
                nop
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_1017F:                              
                                        
                call    sub_102C1
                and     al, 3
                jnz     short loc_10192
                nop
                nop
                nop
                call    sub_102AA
                mov     eax, 1Bh
                call    delay_ms

loc_10192:                              
                call    sub_103E0
                call    sub_10377
                mov     al, 0
                call    sub_102E8
                mov     eax, 4
                call    delay_ms
                mov     ecx, 2

loc_101A6:                              
                push    ecx
                mov     al, 3Fh
                call    sub_102E8
                call    sub_10314
                pop     ecx
                jnb     short loc_101D1
                nop
                nop
                nop
                loopne  loc_101A6
                cmp     byte_1046C, 0FFh
                nop
                jz      short loc_101C2
                jmp     loc_1028F
; ---------------------------------------------------------------------------

loc_101C2:                              
                mov     byte_1046C, 0
                nop
                mov     edi, 2F8h
                mov     port, edi
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
                jz      loc_1025B
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
                cmp     byte_10470, 1
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
                cmp     byte_10470, 1
                jnz     short loc_10233
                nop
                nop
                nop
                cmp     byte_10471, 1
                jz      short loc_10229
                nop
                nop
                nop
                mov     al, 58h
                call    sub_102E8
                mov     al, 6Fh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10229:                              
                mov     al, 4Fh
                call    sub_102E8
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
                cmp     byte_10470, 1
                jnz     short loc_10256
                nop
                nop
                nop
                cmp     byte_10471, 1
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
                                        
                call    sub_102E8

loc_1025B:                              
                                        
                cmp     byte_10470, 1
                jnz     short loc_10283
                nop
                nop
                nop
                mov     edx, offset aSetTabletModeO
                
                push    MB_OK
                push    offset aTitle
                push    edx
                push    0
                call    MessageBox

                cmp     port, 3F8h
                jnz     short loc_1027D
                nop
                nop
                nop
                mov     edx, offset aTabletConnectT
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_1027D:                              
                mov     edx, offset aTabletConnectT_0
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10283:                              
                mov     edx, offset aResetTabletOk

loc_10286:                              
                                        
                push    MB_OK
                push    offset aTitle
                push    edx
                push    0
                call    MessageBox

                push    0
                call    ExitProcess        ;return 0
; ---------------------------------------------------------------------------

loc_1028F:                              
                mov     edx, offset aTabletIsNotRes

loc_10292:                              
                                        
                push    MB_OK
                push    offset aTitle
                push    edx
                push    0
                call    MessageBox

                push    1
                call    ExitProcess        ;return 1
; ---------------------------------------------------------------------------

loc_1029B:                              
                mov     edx, offset aNotSpTablet
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A0:                              
                mov     edx, offset aParameterError
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A5:                              
                mov     edx, offset aSptabletCanUse
                jmp     short loc_10292


; =============== S U B R O U T I N E =======================================


sub_102AA:              
                mov     edi, port
                lea     edx, [edi+4]
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
                out     dx, al
                mov     eax, 1
                call    delay_ms
                retn
; =============== S U B R O U T I N E =======================================


sub_102C1       proc            
                mov     edi, port
                lea     edx, [edi+4]
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CA:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CC:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CE:                              
                in      al, dx
                retn

sub_102C1       endp
; =============== S U B R O U T I N E =======================================


delay_ms        proc      
                                        
                push    ebx
                mov     ebx , eax
                call    GetTickCount
                add     ebx, eax

loc_102DB:                              
                nop
                nop
                nop
                call    GetTickCount
                cmp     ebx, eax
                jl      short loc_102DB
                pop     ebx
                retn
delay_ms        endp
; =============== S U B R O U T I N E =======================================

sub_102E0:              
                mov     edi, port
                lea     edx, [edi+4]
; =============== S U B R O U T I N E =======================================


sub_102E8:           
                                        
                push    edx
                mov     ah, al
                mov     edi, port
                lea     edx, [edi+4]
                in      al, dx
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F5:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F7:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F9:                              
                lea     edx, [edi+5]

loc_102FC:                              
                in      al, dx
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
                lea     edx, [edi]
                mov     al, ah
                out     dx, al
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_1030E:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10310:                              
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10312:                              
                pop     edx
                retn


; =============== S U B R O U T I N E =======================================


sub_10314:              
                call    sub_10345
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


; =============== S U B R O U T I N E =======================================


sub_10345:           
                xor     eax, eax
                mov     edi, port
                lea     edx, [edi+5]
                call    GetTickCount
                mov     ebx, eax
                mov     ecx, 5

loc_10358:                              
                                        
                in      al, dx
                test    al, 1
                jnz     short loc_10370
                nop
                nop
                nop
                call    GetTickCount
                cmp     ebx, eax
                jz      short loc_10358
                mov     ebx, eax
                loopne  loc_10358

loc_1036E:                              
                stc
                retn
; ---------------------------------------------------------------------------

loc_10370:                              
                xor     eax, eax
                lea     edx, [edi]
                in      al, dx
                clc
                retn


; =============== S U B R O U T I N E =======================================


sub_10377:               
                mov     edi, port
                mov     ah, 0Bh
                mov     ebx, 0Ch
                call    sub_103B2
                mov     edx, 21h
                in      al, dx          ; Interrupt controller, 8259A.
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
                out     dx, al          ; Interrupt controller, 8259A.
                lea     edx, [edi+4]
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
                out     dx, al
                lea     edx, [edi+1]
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
                out     dx, al
                retn


; =============== S U B R O U T I N E =======================================


sub_103B2:             
                                        
                mov     edi, port
                lea     edx, [edi+3]
                mov     al, 80h
                out     dx, al
                lea     edx, [edi+1]
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
                out     dx, al
                lea     edx, [edi]
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
                out     dx, al
                lea     edx, [edi+3]
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
                out     dx, al
                retn


; =============== S U B R O U T I N E =======================================


sub_103E0:             
                mov     ah, 2
                mov     bx, 60h
                call    sub_103B2
                mov     al, 0
                call    sub_102E8
                mov     ax, 2
                call    delay_ms
                mov     al, 58h
                call    sub_102E8
                mov     ax, 4
                call    delay_ms
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    sub_103B2
                retn


; =============== S U B R O U T I N E =======================================


SkipWhitespaces:              
                                        
                mov     al, [ebx]
                cmp     al, 0Dh
                jnz     short loc_10415
                nop
                nop
                nop
                xor     al, al
                jmp     short locret_10426
; ---------------------------------------------------------------------------
                nop
; ---------------------------------------------------------------------------

loc_10415:                              ; 
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
                inc     ebx
                jmp     short SkipWhitespaces
; ---------------------------------------------------------------------------

locret_10426:                           
                                        
                retn


; =============== S U B R O U T I N E =======================================


ProcessArguments:          
                mov     ebx, args
                cmp     ebx, 80h
                jnz     short loc_10444
                nop
                nop
                nop
                cmp     byte ptr [ebx], 0
                jz      short loc_10440
                nop
                nop
                nop
                inc     ebx
                jmp     short loc_10444
; ---------------------------------------------------------------------------
                nop

loc_10440:                              
                                        
                xor     ah, ah
                stc
                retn
; ---------------------------------------------------------------------------

loc_10444:                              
                                        
                call    SkipWhitespaces
                mov     al, [ebx]
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
; ---------------------------------------------------------------------------

loc_10460:                              
                                        
                inc     ebx
                mov     al, [ebx]
                inc     ebx
                mov     args, ebx
                xor     ah, ah
                clc
                retn


.data

byte_1046C      db 0                    
                db 10h
port            dd 3F8h                 
                                        
byte_10470      db 1                    
byte_10471      db 0                    
args            dd 80h                  

aTitle          db 'SPTablet32',0                             
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
aSptabletCanUse db 'SPTablet      ;can use following command.',0Dh,0Ah
                db '  /?          ;This message.',0Dh,0Ah
                db '  /x          ;x = 1 or 2 to setup COM1 or COM2.',0Dh,0Ah
                db '  /E          ;Set Emulation On. SP345 will emulate MM9601,',0Dh,0Ah
                db '              ;                  SP66 will emulate MM1212. ',0Dh,0Ah
                db '  /M          ;Set Emulation Microsoft Mouse On.',0Dh,0Ah
                db '              ;If no /M this will set to MM series tablet.',0Dh,0Ah
                db '$'
                db    0
                db 13 dup(0)
end
