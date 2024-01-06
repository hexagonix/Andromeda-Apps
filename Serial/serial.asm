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

;;************************************************************************************

applicationStart:

    Andromeda.Estelar.obterInfoConsole

    hx.syscall hx.clearConsole

    hx.syscall hx.getConsoleInfo

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.criarInterface serial.title, serial.footer, \
    COLOR_HIGHLIGHT, COLOR_HIGHLIGHT, COLOT_FONT, COLOT_FONT, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    gotoxy 02, 01

    xyfputs 39, 4, serial.bannerHexagonix
    xyfputs 27, 5, serial.copyright
    xyfputs 41, 6, serial.trademark

    Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

    gotoxy 02, 10

    mov esi, serial.deviceName

    hx.syscall hx.open

    jc openError

    push edi

;; Welcome

    xyfputs 01, 14, serial.intro
    xyfputs 01, 15, serial.intro2

    xyfputs 02, 18, serial.category1
    xyfputs 02, 19, serial.category2

    pop edi

.loopCheckCategories:

    hx.syscall hx.waitKeyboard

    cmp al, '1'
    je .continue

    cmp al, '2'
    je finish

    jmp .loopCheckCategories

.continue:

    xyfputs 02, 21, serial.prompt

    fputs serial.separator

    mov al, byte[Andromeda.Interface.numColunas] ;; Maximum characters to get

    sub al, 20

    hx.syscall hx.getString

    ;; hx.syscall hx.trimString ;; Remove extra spaces

    mov [msg], esi

    mov si, [msg]

    hx.syscall hx.write

    jc writeError

    mov eax, COLOR_SUCCESS
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 22, serial.sent

    fputs serial.prompt

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    jmp getKeys

;;************************************************************************************

getKeys:

    hx.syscall hx.waitKeyboard

    push eax

    hx.syscall hx.getKeyState

    bt eax, 0
    jc .controlKeys

    pop eax

    jmp getKeys

.controlKeys:

    pop eax

    cmp al, 'n'
    je applicationStart

    cmp al, 'N'
    je applicationStart

    cmp al, 'x'
    je finish

    cmp al, 'X'
    je finish

    jmp getKeys

;;************************************************************************************

finish:

    Andromeda.Estelar.finishGraphicProcess 0, 0

;;************************************************************************************

writeError:

    xyfputs 02, 22, serial.portError

    hx.syscall hx.waitKeyboard

    hx.syscall hx.clearConsole

    hx.syscall hx.exit

;;************************************************************************************

openError:

    xyfputs 02, 14, serial.openError

    hx.syscall hx.waitKeyboard

    jmp finish

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION equ "1.5.0"

COLOR_HIGHLIGHT = AZUL_ROYAL
COLOT_FONT      = HEXAGONIX_CLASSICO_BRANCO
COLOR_SUCCESS   = VERDE_FLORESTA

serial:

.portError:
db "Unable to use the serial port. Press any key to exit...", 0
.openError:
db "Unable to open device for writing. Press any key to exit...", 0
.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.trademark:
db "All rights reserved.", 0
.intro:
db "This utility will help you send data via serial port.", 0
.intro2:
db "To get started, select one of the options below:", 0
.category1:
db "[1] Send data via serial port.", 0
.category2:
db "[2] Exit.", 0
.prompt:
db "[com1]", 0
.separator:
db ": ", 0
.deviceName:
db "com1", 0
.sent:
db "Data sent via serial port ", 0
.title:
db "Serial port utility for Hexagonix", 0
.footer:
db "[", VERSION, "] | [^N] New message, [^X] Exit", 0

msg: db 0 ;; Buffer
