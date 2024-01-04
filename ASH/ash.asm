;;*************************************************************************************************
;;
;; 88                                                                                88
;; 88                                                                                ""
;; 88
;; 88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8
;; 88P'    "88 a8P     88  `P8, ,8P'  ""     `P8 a8"    `P88 a8"     "8a 88P'   `"88 88  `P8, ,8P'
;; 88       88 8PP"""""""    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(
;; 88       88 "8b,   ,aa  ,d8" "8b,  88,    ,88 "8a,   ,d88 "8a,   ,a8" 88       88 88  ,d8" "8b,
;; 88       88  `"Pbbd8"' 8P'     `P8 `"8bbdP"P8  `"PbbdP"P8  `"PbbdP"'  88       88 88 8P'     `P8
;;                                               aa,    ,88
;;                                                "P8bbdP"
;;
;;                     Sistema Operacional Hexagonix - Hexagonix Operating System
;;
;;                         Copyright (c) 2015-2024 Felipe Miguel Nery Lunkes
;;                        Todos os direitos reservados - All rights reserved.
;;
;;*************************************************************************************************
;;
;; Português:
;;
;; O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
;; a licença que governa este arquivo e verifique a licença de cada repositório para
;; obter mais informações sobre seus direitos e obrigações ao utilizar e reutilizar
;; o código deste ou de outros arquivos.
;;
;; English:
;;
;; Hexagonix and its components are licensed under a BSD-3-Clause license. Read below
;; the license that governs this file and check each repository's license for
;; obtain more information about your rights and obligations when using and reusing
;; the code of this or other files.
;;
;;*************************************************************************************************
;;
;; BSD 3-Clause License
;;
;; Copyright (c) 2015-2024, Felipe Miguel Nery Lunkes
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;; 1. Redistributions of source code must retain the above copyright notice, this
;;    list of conditions and the following disclaimer.
;;
;; 2. Redistributions in binary form must reproduce the above copyright notice,
;;    this list of conditions and the following disclaimer in the documentation
;;    and/or other materials provided with the distribution.
;;
;; 3. Neither the name of the copyright holder nor the names of its
;;    contributors may be used to endorse or promote products derived from
;;    this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;
;; $HexagonixOS$

use32

;; Now let's create a HAPP header for the application

include "HAPP.s" ;; Here is a structure for the HAPP header

;; Instance | Structure | Architecture | Version | Subversion | Entry Point | Image type
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, shellStart, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "erros.s"
include "log.s"
include "macros.s"

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

ASHBannerFontColor = HEXAGONIX_CLASSICO_BRANCO
ASHTheme           = VERDE_MAR
ASHConsoleTheme    = ASHTheme
ASHWarning         = TOMATE
ASHError           = VERMELHO
ASHLimitReached    = AMARELO_ANDROMEDA
ASHSuccess         = VERDE

VERSION             equ "4.7.1"
compatibleHexagonix equ "System I"

;;**************************

ASH:

.invalidCommand:
db 10, 10, "[!] Invalid internal command or application not found.", 10, 0
.bannerASH:
db "ASH - Andromeda SHell", 0
.welcome:
db "Welcome to Andromeda SHell - ASH", 10, 10
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 10
db "All rights reserved.", 10, 0
.copyright:
db 10, 10, "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 10
db "All rights reserved.", 10, 0
.processLimit:
db 10, 10, "[!] There is no available process slot to run the requested application.", 10
db "[!] Try to terminate applications or their instances first, and try again.", 10, 0
.invalidImage:
db ": unable to load image. Unsupported executable format.", 10, 0
.prompt:
db "[/]: ", 0
.license:
db 10, "Licenced under BSD-3-Clause.", 10, 0

.verboseStartingASH:
db "[ASH]: Andromeda SHell (ASH) for Hexagonix ", compatibleHexagonix, " or superior.", 0
.verboseVersionASH:
db "[ASH]: Andromeda SHell version ", VERSION, ".", 0
.verboseAuthors:
db "[ASH]: Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes.", 0
.verboseCopyright:
db "[ASH]: All rights reserved.", 0
.verboseExitASH:
db "[ASH]: Terminating the ASH...", 0
.verboseProcessLimit:
db "[ASH]: Warning: memory full or process limit reached!", 0
.verboseDeprecatedInterface:
db "[ASH]: Warning: performing mount point manipulation using deprecated functions that will be removed.", 0

;;**************************

ASH.commands:

.changeVolume:
db "cvol", 0
.exit:
db "exit",0
.version:
db "ver", 0
.help:
db "help", 0

;;**************************

ASH.help:

.intro:
db 10, 10, "Andromeda SHell version ", VERSION, 10
db "Compatible with Hexagonix ", compatibleHexagonix, " or superior.", 0
.helpContent:
db 10, 10, "Internal commands available:", 10, 10
db " VER  - Displays information about the running ASH version.", 10
db " EXIT - Terminate this ASH session.", 10, 0

;;**************************

ASH.volume:

.hd0:
db "hd0", 0
.hd1:
db "hd1", 0
.hd2:
db "hd2", 0
.hd3:
db "hd3", 0
.info:
db "info", 0
.currentVolume:
db 10, 10, "Current volume used by the system: ", 0
.mountError:
db 10, 10, "A valid volume or parameter was not provided for this command.", 10, 10
db "Cannot change default volume.", 10, 10
db "Use a device name as an argument or 'info' for current disk information.", 10, 0
.volumeLabel:
db 10, 10, "Volume label: ", 0
.deprecatedInterfaceWarning:
db 10, 10, "Warning! This is an obsolete built-in Andromeda SHell command.", 10
db "Be aware that it may be removed soon. Use the Unix 'mount' tool instead.", 10
db "You can find documentation for mount using 'man mount' anytime.", 0

;; Buffers

currentVolume: times 3 db 0

;;************************************************************************************

shellStart:

    logSistema ASH.verboseStartingASH, 00h, Log.Prioridades.p4
    logSistema ASH.verboseVersionASH, 00h, Log.Prioridades.p4
    logSistema ASH.verboseAuthors, 00h, Log.Prioridades.p4
    logSistema ASH.verboseCopyright, 00h, Log.Prioridades.p4

;; Start console configuration

    Andromeda.Estelar.obterInfoConsole

    hx.syscall limparTela

    putNewLine

    call showBanner

    fputs ASH.welcome

;;************************************************************************************

.getCommand:

    call showBanner

    hx.syscall obterCursor

    hx.syscall definirCursor

    push ecx

    xor ecx, ecx

    mov eax, ASHConsoleTheme
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.prompt

    mov ecx, 01h

    call changeColor

    mov al, byte[Andromeda.Interface.numColunas] ;; Maximum characters to get

    sub al, 20

    hx.syscall obterString

    hx.syscall cortarString ;; Remove extra spaces

    cmp byte[esi], 0 ;; No command entered
    je .getCommand

;; Compare with available internal commands

    ;; EXIT command

    mov edi, ASH.commands.exit

    hx.syscall compararPalavrasString

    jc .finishShell

    ;; VER command

    mov edi, ASH.commands.version

    hx.syscall compararPalavrasString

    jc .commandVER

    ;; HELP command

    mov edi, ASH.commands.help

    hx.syscall compararPalavrasString

    jc .commandHELP

    ;; CVOL command

    mov edi, ASH.commands.changeVolume

    hx.syscall compararPalavrasString

    jc .commandCVOL

;;************************************************************************************

;; Try to load a program

    call getArguments ;; Separate command and arguments

    push esi
    push edi

    jmp .loadApplication

.failedToExecute:

;; Now the error sent by the system will be analyzed, so that the shell knows its nature

    cmp eax, Hexagon.limiteProcessos ;; Limit of running processes reached
    je .limitReached                 ;; If yes, display the appropriate message

    cmp eax, Hexagon.imagemInvalida ;; Invalid HAPP image
    je .invalidHAPPImage            ;; If yes, display the appropriate message

    hx.syscall obterCursor

    push ecx

    xor ecx, ecx

    mov eax, ASHError
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.invalidCommand

    mov ecx, 01h

    call changeColor

    jmp .getCommand

.invalidHAPPImage:

    push esi

    putNewLine
    putNewLine

    pop esi

    imprimirString

    push ecx

    xor ecx, ecx

    mov eax, ASHError
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.invalidImage

    mov ecx, 01h

    call changeColor

    jmp .getCommand

.limitReached:

    logSistema ASH.verboseProcessLimit, 00h, Log.Prioridades.p4

    push ecx

    xor ecx, ecx

    mov eax, ASHLimitReached
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.processLimit

    mov ecx, 01h

    call changeColor

    clc

    jmp .getCommand

.loadApplication:

    pop edi

    mov esi, edi

    hx.syscall cortarString

    pop esi

    mov eax, edi

    stc

    hx.syscall iniciarProcesso

    jc .failedToExecute

    jmp .getCommand

;;************************************************************************************

.commandHELP:

    fputs ASH.help.helpContent

    jmp .getCommand

;;************************************************************************************

.commandCVOL:

    push esi
    push edi

    push ecx

    xor ecx, ecx

    mov eax, ASHWarning
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.volume.deprecatedInterfaceWarning

    mov ecx, 01h

    call changeColor

    pop edi
    pop esi

    add esi, 04h

    hx.syscall cortarString

    mov edi, ASH.volume.hd0

    hx.syscall compararPalavrasString

    jc .changeToHD0

    mov edi, ASH.volume.hd1

    hx.syscall compararPalavrasString

    jc .changeToHD1

    mov edi, ASH.volume.hd2

    hx.syscall compararPalavrasString

    jc .changeToHD2

    mov edi, ASH.volume.hd3

    hx.syscall compararPalavrasString

    jc .changeToHD3

    mov edi, ASH.volume.info

    hx.syscall compararPalavrasString

    jc .volumeInfo

    jmp .mountError

.changeToHD0:

    logSistema ASH.verboseDeprecatedInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.volume.hd0

    hx.syscall abrir

    putNewLine

    jmp .getCommand

.changeToHD1:

    logSistema ASH.verboseDeprecatedInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.volume.hd1

    hx.syscall abrir

    putNewLine

    jmp .getCommand

.changeToHD2:

    logSistema ASH.verboseDeprecatedInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.volume.hd2

    hx.syscall abrir

    putNewLine

    jmp .getCommand

.changeToHD3:

    logSistema ASH.verboseDeprecatedInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.volume.hd3

    hx.syscall abrir

    putNewLine

    jmp .getCommand

.mountError:

    fputs ASH.volume.mountError

    jmp .getCommand

.volumeInfo:

    fputs ASH.volume.currentVolume

    hx.syscall obterDisco

    push edi
    push esi

    push ecx

    xor ecx, ecx

    mov eax, ASHTheme
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    pop esi

    imprimirString

    mov ecx, 01h

    call changeColor

    fputs ASH.volume.volumeLabel

    push ecx

    xor ecx, ecx

    mov eax, ASHTheme
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    pop edi

    fputs edi

    mov ecx, 01h

    call changeColor

.putNewLine:

    putNewLine

    jmp .getCommand

;;************************************************************************************

.commandVER:

    push ecx

    xor ecx, ecx

    mov eax, ASHTheme
    mov ebx, dword[Andromeda.Interface.corFundo]

    call changeColor

    pop ecx

    fputs ASH.help.intro

    mov ecx, 01h

    call changeColor

    fputs ASH.copyright

    fputs ASH.license

    jmp .getCommand

;;************************************************************************************

.finishShell:

    logSistema ASH.verboseExitASH, 00h, Log.Prioridades.p4

    putNewLine

    mov ebx, 00h

    hx.syscall encerrarProcesso

    jmp .getCommand

    hx.syscall aguardarTeclado

    hx.syscall encerrarProcesso

;;************************************************************************************

;;************************************************************************************
;;
;; End of ASH internal commands
;;
;; Useful functions for manipulating data in the ASH shell
;;
;;************************************************************************************

;; Separate command name and arguments
;;
;; Input:
;;
;; ESI - Command address
;;
;; Output:
;;
;; ESI - Command address
;; EDI - Command arguments
;; CF  - Set in case of lack of extension

getArguments:

    push esi

.loop:

    lodsb ;; mov AL, byte[ESI] & inc ESI

    cmp al, 0
    je .notFound

    cmp al, ' '
    je .spaceFound

    jmp .loop

.notFound:

    pop esi

    mov edi, 0

    stc

    jmp .end

.spaceFound:

    mov byte[esi-1], 0
    mov ebx, esi

    hx.syscall tamanhoString

    mov ecx, eax

    inc ecx ;; Including the last character (NULL)

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov esi, ebx
    mov edi, appFileBuffer

    rep movsb ;; Copy (ECX) string characters from ESI to EDI

    pop es

    mov edi, appFileBuffer

    pop esi

    clc

.end:

    ret

;;************************************************************************************

;; Change font and background color
;;
;; Input:
;;
;; EAX - Font color
;; EBX - Background Color
;; ECX - 01h to restore to system default

changeColor:

    cmp ecx, 01h
    je .default

    hx.syscall definirCor

    ret

.default:

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    ret

;;************************************************************************************

showBanner:

    hx.syscall obterCursor

    push edx

    push ecx

    xor ecx, ecx

    mov eax, ASHBannerFontColor
    mov ebx, ASHTheme

    call changeColor

    pop ecx

    mov al, 0

    hx.syscall limparLinha

    fputs ASH.bannerASH

    mov ecx, 01h

    call changeColor

    pop edx

    inc dh

    mov dl, 00h

    hx.syscall definirCursor

    ret

;;************************************************************************************

appFileBuffer: ;; Address for opening files
