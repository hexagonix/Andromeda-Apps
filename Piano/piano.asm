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
;;                        Todos os copyright reservados - All rights reserved.
;;
;;*************************************************************************************************
;;
;; Português:
;;
;; O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
;; a licença que governa este arquivo e verifique a licença de cada repositório para
;; obter mais informações sobre seus copyright e obrigações ao utilizar e reutilizar
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

    Andromeda.Estelar.obterInfoConsole

    hx.syscall limparTela

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.criarInterface piano.title, piano.footer, \
    COLOR_HIGHTLIGHT, COLOR_HIGHTLIGHT, COLOR_FONT, COLOR_FONT, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

.pianoBlock:

    mov eax, 80  ;; Start of block at X
    mov ebx, 80  ;; Start of block at Y
    mov esi, 635 ;; Block length
    mov edi, 450 ;; Block height
    mov edx, COLOR_BLOCK ;; Block color

    hx.syscall desenharBloco

    call assembleKeys

.again:

    hx.syscall aguardarTeclado

.noKey: ;; Find the keys and play the sounds

    cmp al, 'q'
    jne .w

    call highlightKeys.highlightQ

    tocarNota 4000

    jmp .again

.w:

    cmp al, 'w'
    jne .e

    call highlightKeys.highlightW

    tocarNota 3600

    jmp .again

.e:

    cmp al, 'e'
    jne .r

    call highlightKeys.highlightE

    tocarNota 3200

    jmp .again


.r:

    cmp al, 'r'
    jne .t

    call highlightKeys.highlightR

    tocarNota 3000

    jmp .again

.t:

    cmp al, 't'
    jne .y

    call highlightKeys.highlightT

    tocarNota 2700

    jmp .again

.y:

    cmp al, 'y'
    jne .u

    call highlightKeys.highlightY

    tocarNota 2400

    jmp .again

.u:

    cmp al, 'u'
    jne .i

    call highlightKeys.highlightU

    tocarNota 2100

    jmp .again

.i:

    cmp al, 'i'
    jne .spaceKey

    call highlightKeys.highlightI

    tocarNota 2000

    jmp .again

.spaceKey:

    cmp al, ' '
    jne .getInfo

    call highlightKeys.highlightSpace

    finalizarNota

    jmp .again

.getInfo:

    cmp al, 'a'
    jne .exitPiano

    jmp showInfoInterface

.exitPiano:

    cmp al, 'x'
    je .end

    cmp al, 'X'
    je .end

    jmp .now

.now:

    jmp .again

.end:

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    hx.syscall desligarSom

    hx.syscall limparTela

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************

assembleKeys:

.firstKey:

    mov eax, 144
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.secondKey:

    mov eax, 204
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.thirdKey:

    mov eax, 264
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.fourthKey:

    mov eax, 324
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.fifthKey:

    mov eax, 384
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.sixthKey:

    mov eax, 444
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.seventhKey:

    mov eax, 504
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.eighthKey:

    mov eax, 564
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.spaceBlock:

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall desenharBloco

.subtitle:

    mov eax, COLOR_KEY_BACKGROUND
    mov ebx, COLOR_BLOCK

    hx.syscall definirCor

.keyQ:

    mov dl, 19
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyQ

.keyW:

    mov dl, 27 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyW

.keyE:

    mov dl, 34 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyE

.keyR:

    mov dl, 42 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyR

.keyT:

    mov dl, 49 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyT

.keyY:

    mov dl, 57 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyY

.keyU:

    mov dl, 64 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyU

.keyI:

    mov dl, 72 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall definirCursor

    fputs piano.keyI

.keySpace:

    mov eax, COLOR_FONT
    mov ebx, COLOR_KEY_BACKGROUND

    hx.syscall definirCor

    mov dl, 45
    mov dh, 29

    hx.syscall definirCursor

    fputs piano.keySpace

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    ret

;;************************************************************

highlightKeys:

.highlightQ:

    call assembleKeys

    mov eax, 144
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightW:

    call assembleKeys

    mov eax, 204
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightE:

    call assembleKeys

    mov eax, 264
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightR:

    call assembleKeys

    mov eax, 324
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightT:

    call assembleKeys

    mov eax, 384
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightY:

    call assembleKeys

    mov eax, 444
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightU:

    call assembleKeys

    mov eax, 504
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightI:

    call assembleKeys

    mov eax, 564
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    ret

.highlightSpace:

    call assembleKeys

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall desenharBloco

    mov eax, COLOR_FONT
    mov ebx, COLOR_KEY_HIGHLIGHT

    hx.syscall definirCor

    mov dl, 45
    mov dh, 29

    hx.syscall definirCursor

    mov esi, piano.keySpace

    imprimirString

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    ret

;;************************************************************

showInfoInterface:

    hx.syscall desligarSom

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    hx.syscall limparTela

;; Prints program title and footer

    mov eax, COLOR_FONT
    mov ebx, COLOR_HIGHTLIGHT

    hx.syscall definirCor

    mov al, 0

    hx.syscall limparLinha

    fputs piano.title

    mov al, byte[Andromeda.Interface.numLinhas] ;; Last line

    dec al

    hx.syscall limparLinha

    fputs piano.infoFooter

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    mov dh, 02
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.aboutPiano

    mov dh, 03
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.pianoVersion

    mov dh, 05
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.author

    mov dh, 06
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.copyright

    mov dh, 08
    mov dl, 04

    hx.syscall definirCursor

    fputs piano.help

    mov dh, 10
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topic1

    mov dh, 11
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topic2

    mov dh, 12
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topic3

.getKeys:

    hx.syscall aguardarTeclado

    cmp al, 'b'
    je applicationStart

    cmp al, 'B'
    je applicationStart

    cmp al, 'x'
    je applicationStart.end

    cmp al, 'X'
    je applicationStart.end

    jmp .getKeys

;;************************************************************

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION equ "1.8.0"

COLOR_HIGHTLIGHT     = HEXAGONIX_BLOSSOM_AZUL
COLOR_FONT           = HEXAGONIX_CLASSICO_BRANCO
COLOR_BLOCK          = HEXAGONIX_BLOSSOM_LAVANDA
COLOR_KEY_HIGHLIGHT  = HEXAGONIX_BLOSSOM_VERMELHO
COLOR_KEY_BACKGROUND = HEXAGONIX_CLASSICO_PRETO

piano:

.aboutPiano:
db "return PIANO; for Hexagonix Operating System", 0
.pianoVersion:
db "Version ", VERSION, 0
.author:
db "Copyright (C) 2017-", __stringano, " Felipe Miguel Nery Lunkes", 0
.copyright:
db "All rights reserved.", 0
.help:
db "A small help topic for this program:", 0
.topic1:
db "+ Use the [QWERTYUI] keys to issue notes.", 0
.topic2:
db "+ Use the [SPACE] key to mute notes when necessary.", 0
.topic3:
db "+ Finally, use the [Z] key to terminate this application at any time.", 0
.title:
db "return PIANO;", 0
.footer:
db "[", VERSION, "] | [X] Exit, [A] About and help, [SPACE] Mute", 0
.infoFooter:
db "[", VERSION, "] | [X] Exit, [B] Back", 0

.keyQ:
db "Q", 0
.keyW:
db "W", 0
.keyE:
db "E", 0
.keyR:
db "R", 0
.keyT:
db "T", 0
.keyY:
db "Y", 0
.keyU:
db "U", 0
.keyI:
db "I", 0
.keySpace:
db "[SPACE]", 0
