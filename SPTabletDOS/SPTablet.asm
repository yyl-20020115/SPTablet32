;
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

; File Name   : D:\Working\SPTablet32\SPTabletDOS\SPTABLET.OLD.COM
; Format      : MS-DOS COM-file
; Base Address: 1000h Range: 10100h-10700h Loaded length: 600h

                .8086
                ;.mmx
                .model tiny

; ===========================================================================

; Segment type: Pure code
seg000          segment byte public 'CODE' use16
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
                jz      short loc_10113
                nop
                nop
                nop
                mov     dx, offset aThisProgramCan
                jmp     loc_10292
; ---------------------------------------------------------------------------

loc_10113:                              ; CODE XREF: start+8?j
                mov     ax, cs
                mov     es, ax
                assume es:seg000
                mov     byte_1046C, 0FFh
                nop

loc_1011D:                              ; CODE XREF: start+43?j
                                        ; start+58?j ...
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

loc_1012D:                              ; CODE XREF: start+75?j
                jmp     loc_102A0
; ---------------------------------------------------------------------------

loc_10130:                              ; CODE XREF: start+20?j
                cmp     al, 31h
                jnz     short loc_10145
                nop
                nop
                nop
                mov     byte_1046C, 0
                nop
                mov     word_1046E, 3F8h
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_10145:                              ; CODE XREF: start+32?j
                cmp     al, 32h
                jnz     short loc_1015A
                nop
                nop
                nop
                mov     byte_1046C, 0
                nop
                mov     word_1046E, 2F8h
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_1015A:                              ; CODE XREF: start+47?j
                cmp     al, 45h
                jnz     short loc_10169
                nop
                nop
                nop
                mov     byte_10471, 1
                nop
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_10169:                              ; CODE XREF: start+5C?j
                cmp     al, 3Fh
                jnz     short loc_10173
                nop
                nop
                nop
                jmp     loc_102A5
; ---------------------------------------------------------------------------

loc_10173:                              ; CODE XREF: start+6B?j
                cmp     al, 4Dh
                jnz     short loc_1012D
                mov     byte_10470, 0
                nop
                jmp     short loc_1011D
; ---------------------------------------------------------------------------

loc_1017F:                              ; CODE XREF: start+28?j
                                        ; start+CF?j
                call    sub_102C1
                and     al, 3
                jnz     short loc_10192
                nop
                nop
                nop
                call    sub_102AA
                mov     ax, 1Bh
                call    sub_102D0

loc_10192:                              ; CODE XREF: start+84?j
                call    sub_103E0
                call    sub_10377
                mov     al, 0
                call    sub_102E8
                mov     ax, 4
                call    sub_102D0
                mov     cx, 2

loc_101A6:                              ; CODE XREF: start+B5?j
                push    cx
                mov     al, 3Fh
                call    sub_102E8
                call    sub_10314
                pop     cx
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

loc_101C2:                              ; CODE XREF: start+BD?j
                mov     byte_1046C, 0
                nop
                mov     di, 2F8h
                mov     word_1046E, di
                jmp     short loc_1017F
; ---------------------------------------------------------------------------

loc_101D1:                              ; CODE XREF: start+B0?j
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

loc_101F7:                              ; CODE XREF: start+DA?j
                cmp     byte_10470, 1
                jnz     short loc_10206
                nop
                nop
                nop
                mov     al, 0
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10206:                              ; CODE XREF: start+FC?j
                mov     al, 4Bh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_1020B:                              ; CODE XREF: start+D3?j
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
                db 90h
; ---------------------------------------------------------------------------

loc_10229:                              ; CODE XREF: start+11A?j
                mov     al, 4Fh
                call    sub_102E8
                mov     al, 62h
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_10233:                              ; CODE XREF: start+110?j
                mov     al, 4Bh
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10238:                              ; CODE XREF: start+E1?j
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

loc_10251:                              ; CODE XREF: start+147?j
                mov     al, 5Ah
                jmp     short loc_10258
; ---------------------------------------------------------------------------
                nop

loc_10256:                              ; CODE XREF: start+13D?j
                mov     al, 4Bh

loc_10258:                              ; CODE XREF: start+103?j
                                        ; start+108?j ...
                call    sub_102E8

loc_1025B:                              ; CODE XREF: start+E8?j
                                        ; start+EF?j
                cmp     byte_10470, 1
                jnz     short loc_10283
                nop
                nop
                nop
                mov     dx, offset aSetTabletModeO
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                cmp     word_1046E, 3F8h
                jnz     short loc_1027D
                nop
                nop
                nop
                mov     dx, offset aTabletConnectT
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_1027D:                              ; CODE XREF: start+172?j
                mov     dx, offset aTabletConnectT_0
                jmp     short loc_10286
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_10283:                              ; CODE XREF: start+160?j
                mov     dx, offset aResetTabletOk

loc_10286:                              ; CODE XREF: start+17A?j
                                        ; start+180?j
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C00h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code
; ---------------------------------------------------------------------------

loc_1028F:                              ; CODE XREF: start+BF?j
                mov     dx, offset aTabletIsNotRes

loc_10292:                              ; CODE XREF: start+10?j
                                        ; start+19E?j ...
                mov     ah, 9
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                mov     ax, 4C01h
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
                                        ; AL = exit code
; ---------------------------------------------------------------------------

loc_1029B:                              ; CODE XREF: start+F4?j
                mov     dx, offset aNotSpTablet
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A0:                              ; CODE XREF: start:loc_1012D?j
                mov     dx, offset aParameterError
                jmp     short loc_10292
; ---------------------------------------------------------------------------

loc_102A5:                              ; CODE XREF: start+70?j
                mov     dx, offset aSptabletCanUse
                jmp     short loc_10292
start           endp


; =============== S U B R O U T I N E =======================================


sub_102AA       proc near               ; CODE XREF: start+89?p
                mov     di, word_1046E
                lea     dx, [di+4]
                mov     al, 0Bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B5:                              ; CODE XREF: sub_102AA+9?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B7:                              ; CODE XREF: sub_102AA:loc_102B5?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102B9:                              ; CODE XREF: sub_102AA:loc_102B7?j
                out     dx, al
                mov     ax, 1
                call    sub_102D0
                retn
sub_102AA       endp


; =============== S U B R O U T I N E =======================================


sub_102C1       proc near               ; CODE XREF: start:loc_1017F?p
                mov     di, word_1046E
                lea     dx, [di+4]
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CA:                              ; CODE XREF: sub_102C1+7?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CC:                              ; CODE XREF: sub_102C1:loc_102CA?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102CE:                              ; CODE XREF: sub_102C1:loc_102CC?j
                in      al, dx
                retn
sub_102C1       endp


; =============== S U B R O U T I N E =======================================


sub_102D0       proc near               ; CODE XREF: start+8F?p
                                        ; start+A0?p ...
                push    bx
                push    es
                xor     bx, bx
                mov     es, bx
                assume es:nothing
                add     ax, es:46Ch

loc_102DB:                              ; CODE XREF: sub_102D0+13?j
                nop
                nop
                nop
                cmp     ax, es:46Ch
                jg      short loc_102DB
                pop     es
                assume es:nothing
                pop     bx
                retn
sub_102D0       endp


; =============== S U B R O U T I N E =======================================


sub_102E8       proc near               ; CODE XREF: start+9A?p
                                        ; start+A9?p ...
                push    dx
                mov     ah, al
                mov     di, word_1046E
                lea     dx, [di+4]
                in      al, dx
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F5:                              ; CODE XREF: sub_102E8+B?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F7:                              ; CODE XREF: sub_102E8:loc_102F5?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_102F9:                              ; CODE XREF: sub_102E8:loc_102F7?j
                lea     dx, [di+5]

loc_102FC:                              ; CODE XREF: sub_102E8:loc_10305?j
                in      al, dx
                test    al, 20h
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10301:                              ; CODE XREF: sub_102E8+17?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10303:                              ; CODE XREF: sub_102E8:loc_10301?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10305:                              ; CODE XREF: sub_102E8:loc_10303?j
                jz      short loc_102FC
                lea     dx, [di]
                mov     al, ah
                out     dx, al
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_1030E:                              ; CODE XREF: sub_102E8+24?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10310:                              ; CODE XREF: sub_102E8:loc_1030E?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_10312:                              ; CODE XREF: sub_102E8:loc_10310?j
                pop     dx
                retn
sub_102E8       endp


; =============== S U B R O U T I N E =======================================


sub_10314       proc near               ; CODE XREF: start+AC?p
                call    sub_10345
                cmp     al, 53h
                jnz     short loc_10320
                nop
                nop
                nop
                mov     al, 6

loc_10320:                              ; CODE XREF: sub_10314+5?j
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

loc_10343:                              ; CODE XREF: sub_10314+E?j
                                        ; sub_10314+15?j ...
                clc
                retn
; ---------------------------------------------------------------------------

loc_1036E_2:                              ; CODE XREF: sub_10314+3B?j
                stc
                retn
sub_10314       endp


; =============== S U B R O U T I N E =======================================


sub_10345       proc near               ; CODE XREF: sub_10314?p
                xor     ax, ax
                mov     es, ax
                assume es:nothing
                mov     di, word_1046E
                lea     dx, [di+5]
                mov     ah, es:46Ch
                mov     cx, 5

loc_10358:                              ; CODE XREF: sub_10345+20?j
                                        ; sub_10345+27?j
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

loc_1036E:                              ; CODE XREF: sub_10314+2A?j
                stc
                retn
; ---------------------------------------------------------------------------

loc_10370:                              ; CODE XREF: sub_10345+16?j
                xor     ax, ax
                lea     dx, [di]
                in      al, dx
                clc
                retn
sub_10345       endp


; =============== S U B R O U T I N E =======================================


sub_10377       proc near               ; CODE XREF: start+95?p
                mov     di, word_1046E
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    sub_103B2
                mov     dx, 21h
                in      al, dx          ; Interrupt controller, 8259A.
                cmp     word_1046E, 2F8h
                jnz     short loc_10396
                nop
                nop
                nop
                and     al, 0F7h
                jmp     short loc_10398
; ---------------------------------------------------------------------------

loc_10396:                              ; CODE XREF: sub_10377+16?j
                and     al, 0EFh

loc_10398:                              ; CODE XREF: sub_10377+1D?j
                out     dx, al          ; Interrupt controller, 8259A.
                lea     dx, [di+4]
                mov     al, 0Bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A0:                              ; CODE XREF: sub_10377+27?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A2:                              ; CODE XREF: sub_10377:loc_103A0?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103A4:                              ; CODE XREF: sub_10377:loc_103A2?j
                out     dx, al
                lea     dx, [di+1]
                mov     al, 1
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103AC:                              ; CODE XREF: sub_10377+33?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103AE:                              ; CODE XREF: sub_10377:loc_103AC?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103B0:                              ; CODE XREF: sub_10377:loc_103AE?j
                out     dx, al
                retn
sub_10377       endp


; =============== S U B R O U T I N E =======================================


sub_103B2       proc near               ; CODE XREF: sub_10377+9?p
                                        ; sub_103E0+5?p ...
                mov     di, word_1046E
                lea     dx, [di+3]
                mov     al, 80h
                out     dx, al
                lea     dx, [di+1]
                mov     al, bh
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C3:                              ; CODE XREF: sub_103B2+F?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C5:                              ; CODE XREF: sub_103B2:loc_103C3?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103C7:                              ; CODE XREF: sub_103B2:loc_103C5?j
                out     dx, al
                lea     dx, [di]
                mov     al, bl
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103CE:                              ; CODE XREF: sub_103B2+1A?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103D0:                              ; CODE XREF: sub_103B2:loc_103CE?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103D2:                              ; CODE XREF: sub_103B2:loc_103D0?j
                out     dx, al
                lea     dx, [di+3]
                mov     al, ah
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DA:                              ; CODE XREF: sub_103B2+26?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DC:                              ; CODE XREF: sub_103B2:loc_103DA?j
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_103DE:                              ; CODE XREF: sub_103B2:loc_103DC?j
                out     dx, al
                retn
sub_103B2       endp


; =============== S U B R O U T I N E =======================================


sub_103E0       proc near               ; CODE XREF: start:loc_10192?p
                mov     ah, 2
                mov     bx, 60h
                call    sub_103B2
                mov     al, 0
                call    sub_102E8
                mov     ax, 2
                call    sub_102D0
                mov     al, 58h
                call    sub_102E8
                mov     ax, 4
                call    sub_102D0
                mov     ah, 0Bh
                mov     bx, 0Ch
                call    sub_103B2
                retn
sub_103E0       endp


; =============== S U B R O U T I N E =======================================


sub_10407       proc near               ; CODE XREF: sub_10407+1D?j
                                        ; sub_10427:loc_10444?p
                mov     al, [bx]
                cmp     al, 0Dh
                jnz     short loc_10415
                nop
                nop
                nop
                xor     al, al
                jmp     short locret_10426
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_10415:                              ; CODE XREF: sub_10407+4?j
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
; ---------------------------------------------------------------------------

locret_10426:                           ; CODE XREF: sub_10407+B?j
                                        ; sub_10407+10?j ...
                retn
sub_10407       endp


; =============== S U B R O U T I N E =======================================


sub_10427       proc near               ; CODE XREF: start:loc_1011D?p
                mov     bx, word_10472
                cmp     bx, 80h
                jnz     short loc_10444
                nop
                nop
                nop
                cmp     byte ptr [bx], 0
                jz      short loc_10440
                nop
                nop
                nop
                inc     bx
                jmp     short loc_10444
; ---------------------------------------------------------------------------
                nop

loc_10440:                              ; CODE XREF: sub_10427+10?j
                                        ; sub_10427+32?j
                xor     ah, ah
                stc
                retn
; ---------------------------------------------------------------------------

loc_10444:                              ; CODE XREF: sub_10427+8?j
                                        ; sub_10427+16?j
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
; ---------------------------------------------------------------------------

loc_10460:                              ; CODE XREF: sub_10427+24?j
                                        ; sub_10427+2B?j
                inc     bx
                mov     al, [bx]
                inc     bx
                mov     word_10472, bx
                xor     ah, ah
                clc
                retn
sub_10427       endp

; ---------------------------------------------------------------------------
byte_1046C      db 0                    ; DATA XREF: start+17?w
                                        ; start+37?w ...
                db 10h
word_1046E      dw 3F8h                 ; DATA XREF: start+3D?w
                                        ; start+52?w ...
byte_10470      db 1                    ; DATA XREF: start+77?w
                                        ; start:loc_101F7?r ...
byte_10471      db 0                    ; DATA XREF: start+61?w
                                        ; start+115?r ...
word_10472      dw 80h                  ; DATA XREF: sub_10427?r
                                        ; sub_10427+3D?w
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
seg000          ends


                 end start