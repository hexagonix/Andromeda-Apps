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

showSerialInterface:

match =SIM, VERBOSE
{

    systemLog Log.Config.logSerial, 00h, Log.Priorities.p4

}

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs TITLE.serialPort

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.serialPort

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    call showResolutionWarning

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 02, serialInterfaceData.intro

    xyfputs 02, 03, serialInterfaceData.intro2

    xyfputs 04, 04, serialInterfaceData.defaultPort

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs Hexagon.LibASM.Dev.serialPorts.com1

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 04, 05, serialInterfaceData.options

    xyfputs 04, 08, serialInterfaceData.options2

    xyfputs 04, 09, serialInterfaceData.options3

.getKeys:

    hx.syscall hx.waitKeyboard

    cmp al, 'b'
    je showConfigInterface

    cmp al, 'B'
    je showConfigInterface

    cmp al, 'x'
    je finishApplication

    cmp al, 'X'
    je finishApplication

    cmp al, 'd'
    je serialPortTest

    cmp al, 'D'
    je serialPortTest

    cmp al, 'e'
    je sendOverSerialPort

    cmp al, 'E'
    je sendOverSerialPort

    jmp .getKeys

;;************************************************************************************

serialPortTest: ;; Automatically send data to the default serial port

match =SIM, VERBOSE
{

    systemLog Log.Config.logSerialAutomatico, 00h, Log.Priorities.p4

}

    mov dh, 10
    mov dl, 04

    hx.syscall hx.setCursor

    fputs serialInterfaceData.msgSending

    mov esi, Hexagon.LibASM.Dev.serialPorts.com1

    hx.syscall hx.open

    jc openError

    mov esi, serialInterfaceData.automaticMessage

    mov [Buffers.msg], esi

    mov si, [Buffers.msg]

    hx.syscall hx.write

    jc error

    mov eax, VERDE_FLORESTA
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs serialInterfaceData.sent

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp showSerialInterface.getKeys

;;************************************************************************************

sendOverSerialPort: ;; Performs manual data sending via the serial port

match =SIM, VERBOSE
{

    systemLog Log.Config.logSerialManual, 00h, Log.Priorities.p4

}

    mov esi, Hexagon.LibASM.Dev.serialPorts.com1

    hx.syscall hx.open

    jc openError

    mov al, 10

    hx.syscall hx.clearLine

    mov dh, 10
    mov dl, 04

    hx.syscall hx.setCursor

    fputs serialInterfaceData.insertMessage

    fputs serialInterfaceData.leftBracket

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs Hexagon.LibASM.Dev.serialPorts.com1

    mov eax,  Andromeda.Estelar.Tema.Fonte.fontePadrao
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs serialInterfaceData.rightBracket

    fputs serialInterfaceData.colon

    mov al, byte[maxColumns] ;; Maximum characters to get
    sub al, 20

    hx.syscall hx.getString

    ;; hx.syscall hx.trimString ;; Remove extra spaces

    mov [Buffers.msg], esi

    mov si, [Buffers.msg]

    hx.syscall hx.write

    jc error

    mov eax, VERDE_FLORESTA
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs serialInterfaceData.sent

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp showSerialInterface.getKeys

;;************************************************************************************

;; General error handlers for serial ports

error:

match =SIM, VERBOSE
{

    systemLog Log.Config.logFalha, 00h, Log.Priorities.p4

}

    fputs serialInterfaceData.sendError

    jmp showSerialInterface.getKeys

openError:

match =SIM, VERBOSE
{

    systemLog Log.Config.logFalha, 00h, Log.Priorities.p4

}

    fputs serialInterfaceData.openError

    jmp showSerialInterface.getKeys
