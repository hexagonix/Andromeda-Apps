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

mostrarInterfaceInfo:

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0
    hx.syscall hx.clearLine

    fputs TITLE.info

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.info

    call setDefaultTheme

    call showResolutionWarning

    call setDefaultColor

    call showHexagonixLogo

    call setDefaultTheme

    xyfputs 20, 02, infoInterfaceData.intro

    call setDefaultColor

    xyfputs 18, 04, infoInterfaceData.systemName

    call setDefaultTheme

    fputs systemName

    call setDefaultColor

    xyfputs 18, 05, infoInterfaceData.systemVersion

    call setDefaultTheme

    call printSystemVersion

    mov al, ' '

    hx.syscall hx.printCharacter

    mov al, '['

    hx.syscall hx.printCharacter

    fputs release

    mov al, ']'

    hx.syscall hx.printCharacter

    call setDefaultColor

    xyfputs 18, 06, infoInterfaceData.systemBuild

    call setDefaultTheme

    fputs buildObtained

    call setDefaultColor

    xyfputs 18, 07, infoInterfaceData.systemType

    call setDefaultTheme

    fputs infoInterfaceData.systemModel

    call setDefaultColor

    xyfputs 18, 08, infoInterfaceData.updatePackage

    call setDefaultTheme

    fputs updatePackage

    call setDefaultColor

;; Now let's display information about Hexagon

    xyfputs 18, 09, infoInterfaceData.Hexagon

    call setDefaultTheme

    hx.syscall hx.uname

    push ecx
    push ebx

    printInteger

    fputs infoInterfaceData.dot

    pop eax

    printInteger

    pop ecx

    cmp ecx, 0
    je .continue

    push ecx

    fputs infoInterfaceData.dot

    pop eax

    printInteger

.continue:

    call setDefaultColor

;; We return to normal programming

    xyfputs 18, 11, systemFullName

    call setDefaultTheme

;; Show licensing

    xyfputs 18, 13, infoInterfaceData.license

    call setDefaultColor

    xyfputs 18, 15, infoInterfaceData.copyright

    xyfputs 18, 16, infoInterfaceData.trademark

    call setDefaultTheme

    xyfputs 30, 18, infoInterfaceData.hardwareIntro

    call setDefaultColor

    xyfputs 02, 20, infoInterfaceData.mainProcessor

    xyfputs 04, 22, infoInterfaceData.processorNumber

    call setDefaultTheme

    call exibirProcessadorInstalado

    call setDefaultColor

    xyfputs 08, 23, infoInterfaceData.processorOperationMode

    xyfputs 02, 25, infoInterfaceData.availableMemory

    call setDefaultTheme

    hx.syscall hx.memoryUsage

    mov eax, ecx

    printInteger

    call setDefaultColor

    fputs infoInterfaceData.kbytes

.getKeys:

    hx.syscall hx.waitKeyboard

    cmp al, 'b'
    je showMainInterface

    cmp al, 'B'
    je showMainInterface

    cmp al, 'x'
    je finishApplication

    cmp al, 'X'
    je finishApplication

    jmp .getKeys
