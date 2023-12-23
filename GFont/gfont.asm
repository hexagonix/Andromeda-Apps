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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, applicationStart, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"

;;************************************************************************************

applicationStart:

    push ds ;; User mode data segment (38h selector)
    pop es

   Andromeda.Estelar.obterInfoConsole

.executarInterface:

    hx.syscall limparTela

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.criarInterface gfont.title, gfont.footer, \
    AZUL_ROYAL, AZUL_ROYAL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    xyfputs 39, 4, gfont.bannerHexagonix
    xyfputs 27, 5, gfont.copyright
    xyfputs 41, 6, gfont.trademark

    Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    gotoxy 02, 10

    fputs gfont.welcomeMessage

    fputs gfont.fontFilename

    mov al, byte[Andromeda.Interface.numColunas] ;; Maximum characters to get

    sub al, 20

    hx.syscall obterString

    hx.syscall cortarString ;; Remove extra spaces

    mov [fontFile], esi

    call validateFont

    jc formatError

    hx.syscall alterarFonte

    jc fontError

    fputs gfont.success

    jmp finish

fontError:

    fputs gfont.fileNotFound

    jmp finish

formatError:

    fputs gfont.invalidFormat

    jmp finish

;;************************************************************************************

finish:

    hx.syscall aguardarTeclado

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************

validateFont:

    mov esi, [fontFile]
    mov edi, appFileBuffer

    hx.syscall abrir

    jc .fileNotFound

    mov edi, appFileBuffer

    cmp byte[edi+0], "H"
    jne .invalidHFNT

    cmp byte[edi+1], "F"
    jne .invalidHFNT

    cmp byte[edi+2], "N"
    jne .invalidHFNT

    cmp byte[edi+3], "T"
    jne .invalidHFNT

.verificarTamanho:

    hx.syscall arquivoExiste

;; In EAX, the file size. It must not be larger than 2000 bytes

    mov ebx, 2000

    cmp eax, ebx
    jng .continue

    jmp .sizeExceeded

.continue:

    clc

    ret

.fileNotFound:

    fputs gfont.fileNotFound

    jmp finish

.invalidHFNT:

    stc

    ret

.sizeExceeded:

    fputs gfont.sizeExceeded

    jmp finish

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION equ "2.5.1"

gfont:

.welcomeMessage:
db 10, 10, "Use this program to change the default system display font.", 10, 10
db "Remember that only fonts designed for Hexagonix can be used.", 10, 10, 10, 10, 0
.fontFilename:
db "Filename: ", 0
.success:
db 10, 10, "Font changed successfully.", 10, 10
db "Press any key to continue...", 10, 10, 0
.fileNotFound:
db 10, 10, "The file cannot be found.", 10, 10
db 10, 10, "Press any key to continue...", 10, 10, 0
.invalidFormat:
db 10, 10, "The provided file does not contain a font in Hexagon format.", 10, 10
db "Press any key to continue...", 10, 10, 0
.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.trademark:
db "All rights reserved.", 0
.title:
db "Hexagonix Operating System default font changer utility", 0
.footer:
db "[", VERSION, "] | Use [F1] to cancel loading a new font", 0
.sizeExceeded:
db 10, 10, "This font file exceeds the maximum size of 2 Kb.", 10, 0

commandLine: dd 0
fontFile:    dd ?

appFileBuffer:
