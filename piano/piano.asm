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

    hx.syscall hx.clearConsole

;; Format: title, footer, titleColor, footerColor, titleTextColor,
;; footerTextColor, textColor, backgroundColor

    Andromeda.Estelar.createInterface piano.title, piano.footer, \
    COLOR_HIGHTLIGHT, COLOR_HIGHTLIGHT, COLOR_FONT, COLOR_FONT, \
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

.pianoBlock:

    mov eax, 80  ;; Start of block at X
    mov ebx, 80  ;; Start of block at Y
    mov esi, 635 ;; Block length
    mov edi, 450 ;; Block height
    mov edx, COLOR_BLOCK ;; Block color

    hx.syscall hx.drawBlock

    call assembleKeys

.again:

    hx.syscall hx.waitKeyboard

.noKey: ;; Find the keys and play the sounds

    cmp al, 'q'
    jne .w

    call highlightKeys.highlightQ

    playNote 4000

    jmp .again

.w:

    cmp al, 'w'
    jne .e

    call highlightKeys.highlightW

    playNote 3600

    jmp .again

.e:

    cmp al, 'e'
    jne .r

    call highlightKeys.highlightE

    playNote 3200

    jmp .again


.r:

    cmp al, 'r'
    jne .t

    call highlightKeys.highlightR

    playNote 3000

    jmp .again

.t:

    cmp al, 't'
    jne .y

    call highlightKeys.highlightT

    playNote 2700

    jmp .again

.y:

    cmp al, 'y'
    jne .u

    call highlightKeys.highlightY

    playNote 2400

    jmp .again

.u:

    cmp al, 'u'
    jne .i

    call highlightKeys.highlightU

    playNote 2100

    jmp .again

.i:

    cmp al, 'i'
    jne .spaceKey

    call highlightKeys.highlightI

    playNote 2000

    jmp .again

.spaceKey:

    cmp al, ' '
    jne .getInfo

    call highlightKeys.highlightSpace

    finishNote

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

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.turnOffSound

    hx.syscall hx.clearConsole

    Andromeda.Estelar.finishGraphicProcess 0, 0

;;************************************************************

assembleKeys:

.firstKey:

    mov eax, 144
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.secondKey:

    mov eax, 204
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.thirdKey:

    mov eax, 264
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.fourthKey:

    mov eax, 324
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.fifthKey:

    mov eax, 384
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.sixthKey:

    mov eax, 444
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.seventhKey:

    mov eax, 504
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.eighthKey:

    mov eax, 564
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.spaceBlock:

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, COLOR_KEY_BACKGROUND

    hx.syscall hx.drawBlock

.subtitle:

    mov eax, COLOR_KEY_BACKGROUND
    mov ebx, COLOR_BLOCK

    hx.syscall hx.setColor

.keyQ:

    mov dl, 19
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyQ

.keyW:

    mov dl, 27 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyW

.keyE:

    mov dl, 34 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyE

.keyR:

    mov dl, 42 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyR

.keyT:

    mov dl, 49 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyT

.keyY:

    mov dl, 57 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyY

.keyU:

    mov dl, 64 ;; Previous + 7
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyU

.keyI:

    mov dl, 72 ;; Previous + 8
    mov dh, 22 ;; Do not change! This is the Y position!

    hx.syscall hx.setCursor

    fputs piano.keyI

.keySpace:

    mov eax, COLOR_FONT
    mov ebx, COLOR_KEY_BACKGROUND

    hx.syscall hx.setColor

    mov dl, 45
    mov dh, 29

    hx.syscall hx.setCursor

    fputs piano.keySpace

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

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

    hx.syscall hx.drawBlock

    ret

.highlightW:

    call assembleKeys

    mov eax, 204
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightE:

    call assembleKeys

    mov eax, 264
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightR:

    call assembleKeys

    mov eax, 324
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightT:

    call assembleKeys

    mov eax, 384
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightY:

    call assembleKeys

    mov eax, 444
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightU:

    call assembleKeys

    mov eax, 504
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightI:

    call assembleKeys

    mov eax, 564
    mov ebx, 84 ;; Should not be changed
    mov esi, 30
    mov edi, 250
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    ret

.highlightSpace:

    call assembleKeys

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.drawBlock

    mov eax, COLOR_FONT
    mov ebx, COLOR_KEY_HIGHLIGHT

    hx.syscall hx.setColor

    mov dl, 45
    mov dh, 29

    hx.syscall hx.setCursor

    mov esi, piano.keySpace

    printString

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    ret

;;************************************************************

showInfoInterface:

    hx.syscall hx.turnOffSound

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.clearConsole

;; Prints program title and footer

    mov eax, COLOR_FONT
    mov ebx, COLOR_HIGHTLIGHT

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs piano.title

    mov al, byte[Andromeda.Interface.numRows] ;; Last line

    dec al

    hx.syscall hx.clearLine

    fputs piano.infoFooter

    mov eax, dword[Andromeda.Interface.fontColor]
    mov ebx, dword[Andromeda.Interface.backgroundColor]

    hx.syscall hx.setColor

    mov dh, 02
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.aboutPiano

    mov dh, 03
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.pianoVersion

    mov dh, 05
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.author

    mov dh, 06
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.copyright

    mov dh, 08
    mov dl, 04

    hx.syscall hx.setCursor

    fputs piano.help

    mov dh, 10
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.topic1

    mov dh, 11
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.topic2

    mov dh, 12
    mov dl, 02

    hx.syscall hx.setCursor

    fputs piano.topic3

.getKeys:

    hx.syscall hx.waitKeyboard

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

VERSION equ "1.11.1"

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
db "Copyright (C) 2017-", __stringYear, " Felipe Miguel Nery Lunkes", 0
.copyright:
db "All rights reserved.", 0
.help:
db "A small help topic for this program:", 0
.topic1:
db "+ Use the [QWERTYUI] keys to issue notes.", 0
.topic2:
db "+ Use the [SPACE] key to mute notes when necessary.", 0
.topic3:
db "+ Finally, use the [X] key to terminate this application at any time.", 0
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
