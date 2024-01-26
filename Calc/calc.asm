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

    Andromeda.Estelar.getConsoleInfo

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.createInterface calc.title, calc.footer, \
    VERDE_ESCURO, VERDE_ESCURO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

    xyfputs 39, 4, calc.bannerHexagonix
    xyfputs 27, 5, calc.copyright
    xyfputs 41, 6, calc.trademark

    call showSystemLogo

    gotoxy 0, 13

;;************************************************************************************

calculate:

;; Get first number

    fputs calc.firstNumber

    call getNumber

    mov dword[firstNumber], eax ;; Save first number

    cmp eax, 0
    je finish

;; Get second number

    fputs calc.secondNumber

    call getNumber

    mov dword[secondNumber], eax ;; Save second number

    cmp eax, 0
    je finish

;; Ask which operation to perform

    fputs calc.operation

    hx.syscall hx.waitKeyboard

    cmp al, '0'
    je addNumbers

    cmp al, '1'
    je subtractNumbers

    cmp al, '2'
    je multiplyNumbers

    cmp al, '3'
    je divideNumbers

    cmp al, '4'
    je finish

;;************************************************************************************

addNumbers:

    mov eax, dword[firstNumber]
    mov ebx, dword[secondNumber]

    add eax, ebx ;; EAX = EAX + EBX

    mov dword[result], eax

    jmp displayResult

;;************************************************************************************

subtractNumbers:

    mov eax, dword[firstNumber]
    mov ebx, dword[secondNumber]

    sub eax, ebx ;; EAX = EAX - EBX

    mov dword[result], eax

    jmp displayResult

;;************************************************************************************

multiplyNumbers:

    mov eax, dword[firstNumber]
    mov ebx, dword[secondNumber]

    mul ebx ;; EAX = EAX * EBX

    mov dword[result], eax

    jmp displayResult

;;************************************************************************************

divideNumbers:

    cmp ebx, 0
    je .divideByZero

    mov eax, dword[firstNumber]
    mov ebx, dword[secondNumber]
    mov edx, 0

    div ebx ;; EAX = EAX / EBX

    mov dword[result], eax

    jmp displayResult

;;************************************************************************************

.divideByZero:

    fputs calc.divideByZero

    jmp displayResult.next

;;************************************************************************************

displayResult:

    putNewLine

    fputs calc.result

    mov eax, dword[result]

    printInteger

.next:

    putNewLine
    putNewLine

    fputs calc.requestKey

    hx.syscall hx.waitKeyboard

    jmp applicationStart

;;************************************************************************************

;; Get a number from the input
;;
;; Output:
;;
;; EAX - Number

getNumber:

    mov al, 10 ;; Maximum 10 characters

    hx.syscall hx.getString

    hx.syscall hx.trimString

    hx.syscall hx.stringToInt

    push eax

    putNewLine

    pop eax

    ret

;;************************************************************************************

finish:

    Andromeda.Estelar.finishGraphicProcess 0, 0

;;************************************************************************************

showSystemLogo:

    Andromeda.Estelar.buildLogo VERDE_ESCURO, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

    ret

;;************************************************************************************

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION equ "1.11.0"

calc:

.divideByZero:
db "Division by zero not allowed!", 0
.firstNumber:
db "Enter the first number (0 to exit): ", 0
.secondNumber:
db "Enter the second number (0 to exit): ", 0
.operation:
db 10, "Enter the operation code, according to the list below:", 10, 10
db "[0] SUM (+)", 10
db "[1] SUB  (-)", 10
db "[2] MUL  (*)", 10
db "[3] DIV  (/)", 10
db "[4] EXIT", 10
db 10, "Option: ", 0
.result:
db 10, 10, "The result is = ", 0
.requestKey:
db 10, 10, "Press any key to continue...", 10, 10, 0
.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.trademark:
db "All rights reserved.", 0
.title:
db "Hexagonix Operating System Basic Calculator",0
.footer:
db "[", VERSION, "] | [F1] Exit",0

firstNumber:  dd 0
secondNumber: dd 0
result:       dd 0
