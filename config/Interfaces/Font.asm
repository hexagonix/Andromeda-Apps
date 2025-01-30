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
;;                         Copyright (c) 2015-2025 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2025, Felipe Miguel Nery Lunkes
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

showFontInterface:

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0
    hx.syscall hx.clearLine

    fputs TITLE.font

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.font

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    call showResolutionWarning

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 02, fontInterfaceData.intro

    xyfputs 02, 03, fontInterfaceData.intro2

    xyfputs 02, 06, fontInterfaceData.requestFile

match =YES, VERBOSE
{

    systemLog Log.Config.logPedirArquivoFonte, 00h, Log.Priorities.p4

}

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov al, 13

    hx.syscall hx.getString

    hx.syscall hx.trimString ;; Remove extra spaces

    mov dword[font], esi

    cmp byte[esi], 0
    je .withoutFile

match =YES, VERBOSE
{

    systemLog Log.Config.logFontes, 00h, Log.Priorities.p4

}

    mov esi, dword[font]

    clc

    hx.syscall hx.fileExists

    jc .fileError

    clc

    hx.syscall hx.changeConsoleFont

    jc .fontError

match =YES, VERBOSE
{

    systemLog Log.Config.logSucessoFonte, 00h, Log.Priorities.p4

}

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 04, 08, fontInterfaceData.success

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs dword[font]

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs fontInterfaceData.closure

    fputs fontInterfaceData.testIntro

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs dword[font]

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    fputs fontInterfaceData.dot

    fputs fontInterfaceData.fontTest

    jmp .getKeys

.withoutFile:

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 04, 08, fontInterfaceData.withoutFile

    jmp .getKeys

.fileError:

match =YES, VERBOSE
{

    systemLog Log.Config.logFonteAusente, 00h, Log.Priorities.p4

}

    xyfputs 04, 08, fontInterfaceData.fileNotFound

    jmp .getKeys

.fontError:

    cmp eax, 01h
    je .fileNotFound

    cmp eax, 02h
    je .invalidFile

    jmp .unknownError

.fileNotFound:

match =YES, VERBOSE
{

    systemLog Log.Config.logFalhaFonte, 00h, Log.Priorities.p4

}

    xyfputs 04, 08, fontInterfaceData.fileNotFound

    jmp .getKeys

.invalidFile:

match =YES, VERBOSE
{

    systemLog Log.Config.logFalhaFonte, 00h, Log.Priorities.p4

}

    xyfputs 04, 08, fontInterfaceData.invalidFile

    jmp .getKeys

.unknownError:

match =YES, VERBOSE
{

    systemLog Log.Config.logFalhaFonte, 00h, Log.Priorities.p4

}

    xyfputs 04, 08, fontInterfaceData.unknownError

    jmp .getKeys

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

    jmp .getKeys
