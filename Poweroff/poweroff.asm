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
appHeader headerHAPP HAPP.Architectures.i386, 1, 00, applicationStart, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"
include "log.s"

;;************************************************************************************

applicationStart:

    push ds ;; User mode data segment (38h selector)
    pop es

    mov [parameter], edi ;; Save command line parameters

    mov esi, [parameter]

    jmp buildInterface

;;************************************************************************************

buildInterface:

    Andromeda.Estelar.getConsoleInfo

    hx.syscall hx.clearConsole

    hx.syscall hx.getConsoleInfo

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.createInterface poweroff.title, poweroff.footer, \
    COLOR_HIGHLIGHT, COLOR_HIGHLIGHT, COLOR_FONT, COLOR_FONT, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

    Andromeda.Estelar.buildLogo COLOR_HIGHLIGHT, COLOR_FONT,\
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

;; Operating system information messages

    xyfputs 39, 4, poweroff.bannerHexagonix
    xyfputs 27, 5, poweroff.copyright
    xyfputs 41, 6, poweroff.trademark

;; Welcome

    xyfputs 01, 14, poweroff.intro
    xyfputs 01, 15, poweroff.intro2

;; Shutdown options

    xyfputs 02, 18, poweroff.shutdownOption
    xyfputs 02, 19, poweroff.rebootOption

    call getKeys

;;************************************************************************************

 shutdownSystem:

    xyfputs 02, 18, poweroff.shutdownMessage

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    fputs poweroff.done

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    ret

;;************************************************************************************

getKeys:

    hx.syscall hx.waitKeyboard

    push eax

    hx.syscall hx.getKeyState

    bt eax, 0
    jc .controlKeys

    pop eax

    cmp al, 'x'
    je finish

    cmp al, 'X'
    je finish

    jmp getKeys

.controlKeys:

    pop eax

    cmp al, 's'
    je shutdownHexagonix

    cmp al, 'S'
    je shutdownHexagonix

    cmp al, 'r'
    je rebootHexagonix

    cmp al, 'R'
    je rebootHexagonix

    jmp getKeys

;;************************************************************************************

shutdownHexagonix:

    call shutdownSystem

    call runUnixShutdownUtilityPoweroff

    jmp finish

;;************************************************************************************

rebootHexagonix:

    call shutdownSystem

    call runUnixShutdownUtilityReboot

    jmp finish

;;************************************************************************************

runUnixShutdownUtilityPoweroff:

    mov esi, poweroff.shutdownUtility
    mov edi, poweroff.shutdownParameter
    mov eax, 01h

    hx.syscall hx.exec

    jc shutdowUtilityError

;;************************************************************************************

runUnixShutdownUtilityReboot:

    mov esi, poweroff.shutdownUtility
    mov edi, poweroff.rebootParameter
    mov eax, 01h

    hx.syscall hx.exec

    jc shutdowUtilityError

;;************************************************************************************

shutdowUtilityError:

    fputs poweroff.failureShutdownUtility

    hx.syscall hx.waitKeyboard

    jmp finish

;;************************************************************************************

finish:

    Andromeda.Estelar.finishGraphicProcess 0, 0

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

SHUTDOWN equ "shutdown"
VERSION  equ "1.9.0"

COLOR_HIGHLIGHT = HEXAGONIX_BLOSSOM_AZUL_ANDROMEDA
COLOR_FONT      = HEXAGONIX_CLASSICO_BRANCO

poweroff:

.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.trademark:
db "All rights reserved.", 0
.shutdownUtility:
db SHUTDOWN, 0
.shutdownParameter:
db "-de", 0
.rebootParameter:
db "-re", 0
.shutdownMessage:
db 10, 10, "The system is coming down. Please wait... ", 0
.rebootMessage:
db "Rebooting the computer...", 10, 10, 0
.intro:
db "Here you will find options to shutdown or restart your device.", 0
.intro2:
db "Select any of the key combinations below to continue:", 0
.rebootOption:
db "[Ctrl-R] to reboot the device.", 10, 0
.shutdownOption:
db "[Ctrl-S] to power off the device.", 10, 0
.done:
db "[Done]", 0
.failure:
db "[Fail]", 0
.failureShutdownUtility:
db 10, 10, "Failed to run Unix shutdown utility. Try again later.", 10
db "Press any key to end this application...", 0
.title:
db "Hexagonix shutdown options",0
.footer:
db "[", VERSION, "] | [X] Exit",0

parameter: dd ? ;; Buffer
