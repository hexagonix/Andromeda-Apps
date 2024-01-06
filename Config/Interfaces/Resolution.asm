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

showResolutionInterface:

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs TITLE.resolution

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.resolution

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    call showResolutionWarning

    call showResolution

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 02, resolutionInterfaceData.intro

    xyfputs 02, 03, resolutionInterfaceData.intro2

    xyfputs 02, 06, resolutionInterfaceData.insert

    xyfputs 04, 08, resolutionInterfaceData.option1

    xyfputs 04, 09, resolutionInterfaceData.option2

    mov ah, byte[changed]

    cmp byte ah, 1
    je .hasChanged

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

    cmp al, '1'
    je graphicMode1

    cmp al, '2'
    je graphicMode2

    jmp .getKeys

.hasChanged:

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov dh, 15
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.resolutionChanged

    mov dh, 17
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.changed

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp .getKeys

graphicMode1:

match =SIM, VERBOSE
{

    systemLog Log.Config.logTrocarResolucao800x600, 00h, Log.Priorities.p4

}

    mov eax, 1

    hx.syscall hx.setResolution

    hx.syscall hx.getConsoleInfo

    mov byte[maxColumns], bl
    mov byte[maxRows], bh

    mov byte[changed], 1

    mov dh, 15
    mov dl, 02

    jmp showResolutionInterface

graphicMode2:

match =SIM, VERBOSE
{

    systemLog Log.Config.logTrocarResolucao1024x768, 00h, Log.Priorities.p4

}

    mov eax, 2
    hx.syscall hx.setResolution

    hx.syscall hx.getConsoleInfo

    mov byte[maxColumns], bl
    mov byte[maxRows], bh

    mov byte[changed], 1

    jmp showResolutionInterface

showResolution:

    mov dh, 13
    mov dl, 02

    hx.syscall hx.setCursor

    hx.syscall hx.getResolution

    cmp eax, 1
    je .graphicMode1

    cmp eax, 2
    je .graphicMode2

    ret

.graphicMode1:

    fputs resolutionInterfaceData.mode1

    ret

.graphicMode2:

    fputs resolutionInterfaceData.mode2

   ret

changed: dd 0
