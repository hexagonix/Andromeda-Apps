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
appHeader headerHAPP HAPP.Architectures.i386, 1, 00, Quartzo, 01h

;;*************************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "erros.s"
include "dev.s"

;;*************************************************************************************************

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

;; Appearance

COLOR_HIGHLIGHT = HEXAGONIX_BLOSSOM_ROXO

;; Variables, constants and structures

VERSION equ "3.4.0"

footerSize = 44

quartzo:

.format:
db "UTF-8", 0
.endLineFormat:
db "LF", 0
.comma:
db ", ", 0
.separator:
db " | ", 0
.applicationFooter:
db "[^F] Exit, [^A] Open, [^S] Save | Filename:               ", 0
.line:
db "Line: ", 0
.column:
db "Column: ", 0
.fileSaved:
db "File saved", 0
.askForFile:
db "Filename [ENTER to cancel]: ", 0
.newFileFooter:
db "New file", 0
.permissionDenied:
db "Only an administrative user can change this file. Press any key to continue...", 0
.unlinkError:
db "Error updating file.", 0
.applicationTitle:
db "Quartzo Text Editor for Hexagonix - Version ", VERSION, 0
.fontColor: dd 0
.backGroundColor: dd 0

filename: ;; Filename
times 13 db 0
totalLines:              dd 0 ;; Line counter in the file
line:                    dd 0 ;; Current line in file
positionCurrentLine:     dd 0 ;; Current line position throughout the file
positionCurrentOnLine:   dd 0 ;; Cursor position on current line
sizeCurrentLine:         dd 0 ;; Current line size
positionLineOnScreen:    dd 1 ;; Line position on the display
positionCurrentPage:     dd 0 ;; Position of the current page in the file (one screen)
screenRefreshIsRequired: db 1 ;; If not zero, you need to redraw the entire screen
maxColumns:              db 0 ;; Total columns available in the video at the current resolution
maxLines:                db 0 ;; Total lines available in the video at the current resolution
returnOrigin:            db 0 ;; Used to check if the return comes from a menu (CTRL+option)

;;*************************************************************************************************

Quartzo:

    hx.syscall hx.getConsoleInfo

    mov byte[maxColumns], bl
    mov byte[maxLines], bh

    hx.syscall hx.getColor

    mov dword[quartzo.fontColor], eax
    mov dword[quartzo.backGroundColor], ebx

    cmp byte[edi], 0 ;; In case of lack of arguments
    je .createNewFile

    mov esi, edi ;; Application arguments

    hx.syscall hx.stringSize

    cmp eax, 12 ;; Invalid filename
    ja .createNewFile

.saveFilename: ;; Save filename

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov edi, filename
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including the NULL character

    rep movsb

    pop es

.loadFile: ;; Open file

    mov esi, filename

    hx.syscall hx.fileExists

    jc .createNewFile ;; The file does not exist

    mov esi, filename

    mov edi, appFileBuffer ;; Loading address

    hx.syscall hx.open

    mov esi, filename

    hx.syscall hx.stringSize

    mov ecx, eax

.configureFooter: ;; Add file name in footer

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

;; Now the name of the opened file will be displayed in the application interface

    mov edi, quartzo.applicationFooter+footerSize ;; Poaition
    mov esi, filename

    rep movsb

    pop es

    jmp .startInterface

.createNewFile:

    mov byte[filename], 0

;; Add 'New file' to the application footer

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov ecx, 12

    mov esi, quartzo.newFileFooter
    mov edi, quartzo.applicationFooter+footerSize

    rep movsb

    pop es

.startInterface:

    mov al, 10 ;; New line character

    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

    mov dword[positionCurrentLine], 0

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize ;; Find current line size

    mov byte[positionCurrentOnLine], dl ;; Cursor at end of line
    mov byte[sizeCurrentLine], dl       ;; Save current line size

    mov dword[positionCurrentPage], 0

.waitInteract:

    cmp byte[screenRefreshIsRequired], 0
    je .otherPrintedLines ;; No need to print other lines

;; Print other lines

    mov esi, Hexagon.LibASM.Dev.video.tty1

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    mov eax, dword[totalLines]

    cmp dword[line], eax
    je .otherPrintedLines

.printOtherLines:

    mov esi, appFileBuffer

    add esi, dword[positionCurrentPage]

    putNewLine

    movzx ecx, byte[maxLines]

    sub ecx, 2

.printOtherLinesLoop:

    call printLine

    jc .printTitle

    putNewLine

    loop .printOtherLinesLoop

.printTitle:

;; Prints application title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, COLOR_HIGHLIGHT

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs quartzo.applicationTitle

    mov al, byte[maxLines] ;; Last line

    dec al

    hx.syscall hx.clearLine

    fputs quartzo.applicationFooter

    hx.syscall hx.getCursor

    mov dl, byte[maxColumns]

    sub dl, 41

    hx.syscall hx.setCursor

    fputs quartzo.separator

    fputs quartzo.format

    fputs quartzo.separator

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

;; Refresh tela

.updateBuffer:

    hx.syscall hx.updateScreen

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

.otherPrintedLines:

    mov byte[screenRefreshIsRequired], 0

    mov dl, 0
    mov dh, byte[positionLineOnScreen]

    hx.syscall hx.setCursor

;; Print last line

    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call printLine

    mov al, ' '

    hx.syscall hx.printCharacter

;; Print current line and column

    mov eax, BRANCO_ANDROMEDA
    mov ebx, COLOR_HIGHLIGHT

    hx.syscall hx.setColor

    mov dl, byte[maxColumns]

    sub dl, 30

    mov dh, byte[maxLines]

    dec dh

    hx.syscall hx.setCursor

    fputs quartzo.line

    mov eax, dword[line]

    inc eax ;; Counting from 1

    printInteger

    fputs quartzo.comma

    fputs quartzo.column

    movzx eax, byte[positionCurrentOnLine]

    inc eax ;; Counting from 1

    printInteger

    mov al, ' '

    hx.syscall hx.printCharacter

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

.startProcessingInput:

;; Place cursor at current position on line

    mov dl, byte[positionCurrentOnLine]
    mov dh, byte[positionLineOnScreen]

    hx.syscall hx.setCursor

.processInput:

    call processInput

    cmp byte[returnOrigin], 01h
    je .startProcessingInput

    jmp .waitInteract

;;*************************************************************************************************

saveFileEditor:

    cmp byte[filename], 0
    jne .noNewFile

;; Get filename

    mov eax, PRETO
    mov ebx, CINZA_CLARO

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs quartzo.askForFile

    mov eax, 12 ;; Maximum characters

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .end

;; Save filename

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov edi, filename
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including NULL

    rep movsb

;; Add to footer

    mov ecx, eax ;; Characters in the filename

    inc ecx

    mov esi, filename
    mov edi, quartzo.applicationFooter+footerSize

    rep movsb

    pop es

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

    jmp .continue

.noNewFile:

;; If the file already exists, delete it

    mov esi, filename

    hx.syscall hx.unlink

    jc .unlinkError

.continue:

;; Find file size

    mov esi, appFileBuffer

    hx.syscall hx.stringSize

;; Save file

    mov esi, filename
    mov edi, appFileBuffer

    hx.syscall hx.create

;; Display save message

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERDE

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs quartzo.fileSaved

.end:

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

.unlinkError:

    cmp eax, IO.operationDenied
    je .permissionDenied

    mov eax, PRETO
    mov ebx, CINZA_CLARO

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs quartzo.unlinkError

    hx.syscall hx.waitKeyboard

    jmp .end

.permissionDenied:

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERMELHO_TIJOLO

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs quartzo.permissionDenied

    jmp .end

;;*************************************************************************************************

openFileEditor:

;; Get filename

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERDE

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs quartzo.askForFile

    mov eax, 12 ;; Maximum characters

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .end

;; Save filename

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov edi, filename
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including NULL

    rep movsb

;; Add to footer

    mov ecx, eax ;; Filename characters

    inc ecx

    mov esi, filename
    mov edi, quartzo.applicationFooter+footerSize

    rep movsb

    pop es

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

    call restartVideoBuffer

    call restartTextBuffer

    mov byte[screenRefreshIsRequired], 1

    jmp Quartzo.loadFile

.end:

    mov eax, dword[quartzo.fontColor]
    mov ebx, dword[quartzo.backGroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

restartVideoBuffer:

    mov esi, Hexagon.LibASM.Dev.video.tty1

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    ret

;;*************************************************************************************************

restartTextBuffer:

    mov dword[appFileBuffer], 10 ;; Let's clear the text buffer

    mov esi, appFileBuffer
    mov eax, 0
    mov dword[line], eax

    mov byte[positionLineOnScreen], 01h
    mov eax, dword[positionCurrentLine]
    mov dword[positionCurrentPage], eax

    ret

;;************************************************************************************

processInput:

    hx.syscall hx.waitKeyboard

;; Let's check if the CTRL key is pressed and take the necessary action

    push eax

    hx.syscall hx.getKeyState

    bt eax, 0
    jc .controlKeys

    pop eax

;; Let's now interpret the keyboard scan codes

    cmp ah, 28
    je .returnKeys

    cmp ah, 15 ;; Tab
    je .printableCharacter

    cmp ah, 71
    je .homeKey

    cmp ah, 79
    je .endKey

    cmp ah, 14
    je .backspaceKey

    cmp ah, 83
    je .deleteKey

    cmp ah, 75
    je .leftKey

    cmp ah, 77
    je .rightKey

    cmp ah, 72
    je .upKey

    cmp ah, 80
    je .downKey

    cmp ah, 81
    je .pageDownKey

    cmp ah, 73
    je .pageUpKey

;; If the character was not printable

    cmp al, ' '
    jl .prepareReturn

    cmp al, '~'
    ja .prepareReturn

;; Other key

.printableCharacter:

;; No more than 79 characters per line are supported

    mov bl, byte[maxColumns]

    dec bl

    cmp byte[sizeCurrentLine], bl
    jae .prepareReturn

    mov edx, 0
    movzx esi, byte[positionCurrentOnLine] ;; Position for inserting characters

    add esi, dword[positionCurrentLine]
    add esi, appFileBuffer

    hx.syscall hx.insertCharacter ;; Insert char into string

    inc byte[positionCurrentOnLine] ;; A character has been added
    inc byte[sizeCurrentLine]

;; More keys

    jmp .prepareReturn

;; Return or Enter key

.returnKeys:

    mov byte[screenRefreshIsRequired], 1

    mov edx, 0

    movzx esi, byte[positionCurrentOnLine]

    add esi, appFileBuffer
    add esi, dword[positionCurrentLine]

    mov al, 10

    hx.syscall hx.insertCharacter

;; New line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize ;; Find size for this line

    mov byte[positionCurrentOnLine], 0 ;; Cursor at end of line
    mov byte[sizeCurrentLine], dl  ;; Save current line size

    mov al, 10 ;; New line character
    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

;; Try moving the cursor down

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[positionLineOnScreen], bl
    jb .returnKeys.cursorNextLine

;; If it's the last line, scroll down

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[positionLineOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentPage], esi

    jmp .prepareReturn

.returnKeys.cursorNextLine:

    inc byte[positionLineOnScreen]

    jmp .prepareReturn

;; Control keys

.controlKeys:

    pop eax

    cmp al, 's'
    je .controlSKeys

    cmp al, 'S'
    je .controlSKeys

    cmp al, 'a'
    je .controlAKeys

    cmp al, 'A'
    je .controlAKeys

    cmp al, 'f'
    je finishApplication

    cmp al, 'F'
    je finishApplication

    jmp .prepareReturn

.backspaceKey:

;; If in the first column, do nothing

    cmp byte[positionCurrentOnLine], 0
    je .backspaceKey.firstColumn

;; Remove character from left

    movzx eax, byte[positionCurrentOnLine]

    add eax, dword[positionCurrentLine]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[positionCurrentOnLine] ;; A character has been removed
    dec byte[sizeCurrentLine]

    jmp .prepareReturn

.backspaceKey.firstColumn:

    cmp byte[line], 0
    je .prepareReturn

;; Calculate previous line size

    mov esi, appFileBuffer
    mov eax, dword[line]

    dec eax ;; Previous line

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov edx, 0

    add esi, appFileBuffer

    call lineSize ;; Find size

    push edx ;; Save line size

    add dl, byte[sizeCurrentLine]

;; Backspace not enabled (support up to 79 characters per line)

    mov bl, byte[maxColumns]

    dec bl

    cmp dl, bl ;; Counting from 0
    jnae .continue

    pop edx

    ret

.continue:

;; Remove newline character

    mov byte[screenRefreshIsRequired], 1

    movzx eax, byte[positionCurrentOnLine]

    add eax, dword[positionCurrentLine]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[totalLines] ;; A line has been removed
    dec dword[line]

;; Previous line

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .pushReturn

    sub esi, appFileBuffer

    push esi

;; Calculate values ​​for this line

    mov edx, 0

    pop esi

    push esi

    add esi, appFileBuffer

    call lineSize ;; Find current line size

    mov byte[sizeCurrentLine], dl ;; Save line size

    pop dword[positionCurrentLine]

    pop edx

    mov byte[positionCurrentOnLine], dl

    jmp .upKey.cursorMoved

.pushReturn:

    pop edx

    ret

.deleteKey:

;; If in the last column, do nothing

    mov dl, byte[sizeCurrentLine]

    cmp byte[positionCurrentOnLine], dl
    jae .prepareReturn

    movzx eax, byte[positionCurrentOnLine]

    add eax, dword[positionCurrentLine]

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[sizeCurrentLine] ;; A character has been removed

    inc byte[positionCurrentOnLine]

.leftKey:

;; If in the first column, do nothing

    cmp byte[positionCurrentOnLine], 0
    jne .leftKey.moveLeft

    cmp byte[line], 0
    je .prepareReturn

    mov bl, byte[maxColumns]
    mov byte[positionCurrentOnLine], bl

    jmp .upKey

;; Move cursor left

.leftKey.moveLeft:

    dec byte[positionCurrentOnLine]

    jmp .prepareReturn

.rightKey:

;; If in the last column, do nothing

    mov dl, byte[sizeCurrentLine]

    cmp byte[positionCurrentOnLine], dl
    jnae .rightKey.moveRight

;; New line not allowed

    mov eax, dword[line]

    inc eax

    cmp dword[totalLines], eax
    je .prepareReturn

;; New line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], 0 ;; Cursor at end of line
    mov byte[sizeCurrentLine], dl      ;; Save line size

    jmp .downKey.next

.rightKey.moveRight:

    inc byte[positionCurrentOnLine]

    jmp .prepareReturn

.upKey:

;; Previous line not allowed

    cmp dword[line], 0
    je .prepareReturn

;; Previous line

    dec dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[sizeCurrentLine], dl

    cmp dl, byte[positionCurrentOnLine]
    jb .upKey.moveCursorToEnd

    jmp .upKey.cursorMoved ;; Do not change the cursor column

.upKey.moveCursorToEnd:

    mov byte[positionCurrentOnLine], dl ;; Cursor at end of line

.upKey.cursorMoved:

;; Try moving the cursor up

    cmp byte[positionLineOnScreen], 1
    ja .upKey.cursorPreviousLine

;; If the cursor is on the first line, scroll up

    mov byte[positionLineOnScreen], 1
    mov eax, dword[positionCurrentLine]
    mov dword[positionCurrentPage], eax

    mov byte[screenRefreshIsRequired], 1

    jmp .prepareReturn

.upKey.cursorPreviousLine:

    dec byte[positionLineOnScreen]

    jmp .prepareReturn

.downKey:

;; Next line not available

    mov eax, dword[line]

    inc eax

    cmp dword[totalLines], eax
    je .prepareReturn

;; Next line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[sizeCurrentLine], dl

    cmp dl, byte[positionCurrentOnLine]
    jb .downKey.moveCursorToEnd

    jmp .downKey.cursorMoved ;; Do not change the column

.downKey.moveCursorToEnd:

    mov byte[positionCurrentOnLine], dl ;; Cursor at end of line

.downKey.cursorMoved:

.downKey.next:

;; Try moving the cursor down

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[positionLineOnScreen], bl
    jb .downKey.cursorNextLine

;; If in the last line, rotate screen down

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[positionLineOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentPage], esi

    mov byte[screenRefreshIsRequired], 1

    jmp .prepareReturn

.downKey.cursorNextLine:

    inc byte[positionLineOnScreen]

    jmp .prepareReturn

.homeKey:

;; Move cursor to first column

    mov byte[positionCurrentOnLine], 0

    jmp .prepareReturn

.endKey:

;; Move cursor to last column

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], dl

    jmp .prepareReturn

.pageUpKey:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    cmp eax, 0
    jle .pageUpKey.goToFirstLine

;; Do not redraw if on the last line

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[positionLineOnScreen], bl
    jae .pageUpKey.notNecessaryRefresh

    mov byte[screenRefreshIsRequired], 1

.pageUpKey.notNecessaryRefresh:

;; Previous line

    movzx ebx, byte[maxLines]

    sub bl, 3
    sub dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], dl ;; Cursor at end of line
    mov byte[sizeCurrentLine], dl

.pageUpKey.end:

    mov byte[positionLineOnScreen], 1
    mov eax, dword[positionCurrentLine]
    mov dword[positionCurrentPage], eax

    jmp .prepareReturn

.pageUpKey.goToFirstLine:

;; Page Up not available

    cmp dword[line], 0
    je .prepareReturn

    mov byte[screenRefreshIsRequired], 1

    mov esi, appFileBuffer
    mov eax, 0
    mov dword[line], eax

    call linePosition

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], dl ;; Cursor at end of line
    mov byte[sizeCurrentLine], dl

    jmp .pageUpKey.end

.pageDownKey:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3

    add eax, ebx

    cmp eax, dword[totalLines]
    jae .pageDownKey.goToLastLine

;; Don't redraw if it's the first line

    cmp byte[positionLineOnScreen], 1
    jle .pageDownKey.notNecessaryRefresh

    mov byte[screenRefreshIsRequired], 1

.pageDownKey.notNecessaryRefresh:

;; Next line

    movzx ebx, byte[maxLines]

    sub bl, 3

    add dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], dl
    mov byte[sizeCurrentLine], dl

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[positionLineOnScreen], bl

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    mov esi, appFileBuffer

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentPage], esi

    jmp .prepareReturn

.pageDownKey.goToLastLine:

;; Page Down not available

    mov eax, dword[line]

    inc eax

    cmp eax, dword[totalLines]
    jae .prepareReturn

    mov byte[screenRefreshIsRequired], 1

;; Next line

    mov eax, dword[totalLines] ;; Last line is the total number of lines - 1

    dec eax

    mov dword[line], eax ;; Make the last line the current line

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentLine], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[positionCurrentLine]

    call lineSize

    mov byte[positionCurrentOnLine], dl
    mov byte[sizeCurrentLine], dl

    movzx ebx, byte[maxLines]

    sub ebx, 3

    cmp dword[totalLines], ebx ;; Check for small or large files
    jae .moreThanOnePage

;; If small file

    mov ebx, dword[totalLines]

    dec ebx

;; If large file

.moreThanOnePage:

    inc bl

    mov byte[positionLineOnScreen], bl

    mov eax, dword[line]

    sub eax, ebx

    inc eax

    mov esi, appFileBuffer

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[positionCurrentPage], esi

    jmp .prepareReturn

.controlSKeys:

    call saveFileEditor

    jmp .prepareSpecialReturn

.controlAKeys:

    call openFileEditor

    jmp .prepareReturn

.prepareReturn:

    mov byte[returnOrigin], 00h

    ret

.prepareSpecialReturn:

    mov byte[returnOrigin], 01h

    ret

;;*************************************************************************************************

finishApplication:

    ;; call saveFileEditor

    hx.syscall hx.scrollConsole

    mov ebx, 00h

    hx.syscall hx.exit

;;*************************************************************************************************

;;*************************************************************************************************
;;
;; Accessory functions
;;
;;*************************************************************************************************

;; Print a line of String
;;
;; Input:
;;
;; ESI - Buffer Address
;;
;; Output:
;;
;; ESI - Next Buffer
;; Carry defined at the end of the file

printLine:

    mov edx, 0 ;; Character counter

.printLoop:

    lodsb

    cmp al, 10 ;; Line end
    je .end

    cmp al, 0 ;; String end
    je .fileEnd

    movzx ebx, byte[maxColumns]
    dec bl

    cmp edx, ebx
    jae .maxLineSize

    pushad

    mov ebx, 01h

    hx.syscall hx.printCharacter ;; Print character in AL

    popad

    inc edx

    jmp .printLoop ;; More characters

.maxLineSize:

    jmp .printLoop

.fileEnd:

    stc

.end:

    ret

;;*************************************************************************************************

;; Find line size
;;
;; Input:
;;
;; ESI - Buffer Address
;;
;; Output:
;;
;; ESI - Next Buffer
;; EDX - += line size

lineSize:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; Line end
    je .end

    cmp al, 0 ;; String end
    je .end

    inc edx

    jmp lineSize ;; More characters

.end:

    ret

;;*************************************************************************************************

;; Find line address in string
;;
;; Input:
;;
;; ESI - String
;; EAX - Line number (counting from 0)
;;
;; Output:
;;
;; ESI - Position of the string on the line
;; Carry defined in line not found

linePosition:

    push ebx

    cmp eax, 0
    je .desiredLineFound ;; Already in the first line

    mov edx, 0   ;; Line counter
    mov ebx, eax ;; Save line

    dec ebx

.nextCharacter:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; New line character
    je .lineFound

    cmp al, 0 ;; String end
    je .lineNotFound

    jmp .nextCharacter

.lineFound:

    cmp edx, ebx
    je .desiredLineFound

    inc edx ;; Line counter

    jmp .nextCharacter

.desiredLineFound:

    clc

    jmp .end

.lineNotFound:

    stc

.end:

    pop ebx

    ret

;;*************************************************************************************************

appFileBuffer: db 10 ;; Address for opening files
