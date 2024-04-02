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
appHeader headerHAPP HAPP.Architectures.i386, 1, 00, LyokoIDE, 01h

;;*************************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "erros.s"
include "dev.s"
include "macros.s"

;;*************************************************************************************************

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

;; Appearance

HIGHLIGHT_COLOR = HEXAGONIX_BLOSSOM_VERMELHO
BANNER_COLOR    = HEXAGONIX_BLOSSOM_LARANJA

sizeToFilename = 8

;; Variables, constants and structures

VERSION   equ "3.0.0"
ASSEMBLER equ "fasmX"
AUTHOR    equ "Copyright (C) 2017-", __stringano, " Felipe Miguel Nery Lunkes"
TRADEMARK equ "All rights reserved."

Lyoko:

.newFileTitle:
db "New file", 0
.quickWarning:
db "Lyoko uses the '", ASSEMBLER, "' assembler for building applications.", 10
db "This open source assembler has been ported and is fully compatible with Hexagonix.", 10, 10
db "You can use keyboard shortcuts to interact with Lyoko.", 10
db "Shortcuts are triggered by the Ctrl (Control, ^) key, along with an action indicator key.", 10
db "These key combinations can be (the Ctrl key represented by ^):", 10, 10
db " [^A] - Requests to open a previously saved file on disk.", 10
db " [^S] - Request to save changes to a file on disk.", 10
db " [^F] - Close Lyoko after saving confirmation.", 10
db " [^M] - Call '", ASSEMBLER, "' assembler to build the executable image.", 10
db " [^V] - Version information and more about Lyoko.", 10, 10
db "After building an image, you will receive the operation status directly on the screen and, if all", 10
db "is correct, you will find the image with the .app extension on the disk containing your application.", 10
db "You can use the 'lshapp' tool to verify image information if necessary.", 10
db "To learn more about the information the utility can provide when analyzing an image,", 10
db "see manual ('man lshapp') or use 'lshapp ?'.", 0
.encoding:
db "UTF-8", 0
.lineEndEncoding:
db "LF", 0
.comma:
db ", ", 0
.separator:
db " | ", 0
.applicationFooter:
db "[^F] Exit | [^A] Open | [^S] Save | [^M] Assemble", 0
.line:
db "Line: ", 0
.column:
db "Column: ", 0
.fileSaved:
db "File saved.", 0
.requestFile:
db "Filename [ENTER to cancel]: ", 0
.permissionDenied:
db "Only an administrative user can change this file. Press any key to continue...", 0
.unlinkError:
db "Error updating file.", 0
.applicationTitle:
db "Lyoko - An IDE for Hexagonix - Version ", VERSION, 0
.fasmX:
db ASSEMBLER, 0
.withoutSourceCode:
db "No source file specified. Try saving your file to disk first.", 10, 10, 0
.saveWarning:
db "The contents of the file have been changed and not saved. This may lead to data loss.", 10, 10
db "Do you want to save your changes to the file? (Y/n)", 10, 0
.output:
db "appX.app", 0
.fileIdentifier:
db "| File:               ", 0
.assemblerName:
db "| ", ASSEMBLER, 0
.closeWarning:
db 10, 10, "Press [ESC] to close this warning.", 10, 0
.infoLyoko:
db "The name Lyoko comes from a series that marked me a lot in childhood, called Code Lyoko.", 10
db "In a way, this series made me fall even more in love with computing and it is fair to pay a symbolic", 10
db "tribute.", 10, 10
db "Lyoko was designed to be a simple and easy to use IDE for developing applications for Hexagonix on", 10
db "the system itself. It is also being used for development various components of the operating system", 10
db "itself.", 10
db "Lyoko is gaining more and more functions and is also constantly updated.", 10, 10
db "Version of this edition of Lyoko: ", VERSION, 10, 10
db AUTHOR, 10
db TRADEMARK, 10, 0
.welcome:
db "Welcome to Lyoko, the official IDE for Hexagonix!", 10, 10
db "With Lyoko, you can quickly write and build wonderful applications for Hexagonix.", 10
db "You can at any time press [^X] (Ctrl+X) for help.", 10, 10
db "Shall we start?", 10, 10
db "You can start by pressing Ctrl-A [^A] to open a file or press [ESC] and start encode your project", 10
db "right now!" , 10, 10
db "Press [ESC] to close the welcome and go directly to the editor.", 10, 0
.runningAssembler:
db "Running the assembler (", ASSEMBLER, ") to generate your app...", 10, 10, 0
.edited: ;; Has the file been edited?
db " *", 0
.titleChanged:    db 0 ;; Title changed?
.biggerBox:       db 0 ;; Box size (relative to screen resolution)
.fontColor:       dd 0 ;; Color to be used in the font
.backgroundColor: dd 0 ;; Color to be used in the background
.changed:         db 0 ;; Will store whether the buffer has been changed by the user
.firstExecution:  db 0 ;; First time initial function is called?
.lineSize:        dd 0 ;; Line size

filename: ;; Filename biffer
times 13 db 0
totalLines:              dd 0  ;; Line counter in the file
line:                    dd 0  ;; Current line in file
currentLinePosition:     dd 0  ;; Current line position in the entire file
currentPositionInLine:   dd 0  ;; Cursor position on current line
currentLineSize:         dd 0  ;; Current line size
linePositionOnScreen:    dd 1  ;; Position of the line on the display
currentPagePosition:     dd 0  ;; Position of the current page in the file (one screen)
screenRefreshIsRequired: db 1  ;; If not zero, you need to redraw the entire screen
maxColumns:              db 0  ;; Total columns available in the video at the current resolution
maxLines:                db 0  ;; Total lines available in the video at the current resolution
parameterLine:           db 30 ;; Parameter size
resolution:              dd 0  ;; Screen resolution
returnOrigin:            db 0  ;; Used to check if the return comes from a menu (CTRL+option)

;;*************************************************************************************************

LyokoIDE:

    hx.syscall hx.getConsoleInfo

    mov byte[maxColumns], bl
    mov byte[maxLines], bh

    mov byte[Lyoko.firstExecution], 01h

    hx.syscall hx.getColor

    mov dword[Lyoko.fontColor], ecx
    mov dword[Lyoko.backgroundColor], edx

    hx.syscall hx.getResolution

    mov dword[resolution], eax

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

.openFile: ;; Open file

    mov esi, filename

    hx.syscall hx.fileExists

    jc .createNewFile ;; The file does not exist

    mov esi, filename

    mov edi, appFileBuffer ;; Loading address

    hx.syscall hx.open

    mov esi, filename

    hx.syscall hx.stringSize

    mov ecx, eax

.setupTitle: ;; Add file name in program footer

    push es

;; Let's configure DS and ES with user mode data segment

    push ds
    pop es

;; Now the name of the opened file will be displayed in the application interface

    mov edi, Lyoko.fileIdentifier+sizeToFilename ;; Position
    mov esi, filename

    rep movsb

    pop es

    jmp .startInterface

.createNewFile:

    mov byte[filename], 0

;; Add 'New file' to the program title

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov ecx, 12

    mov esi, Lyoko.newFileTitle
    mov edi, Lyoko.fileIdentifier+sizeToFilename ;; Position

    rep movsb

    pop es

.startInterface:

    mov al, 10 ;; New line character

    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

    mov dword[currentLinePosition], 0

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize ;; Find current line size

    mov byte[currentPositionInLine], dl ;; Cursor at the end of the line
    mov byte[currentLineSize], dl   ;; Save current line size

    mov dword[currentPagePosition], 0

.awaitInteraction:

    cmp byte[screenRefreshIsRequired], 00h
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

    add esi, dword[currentPagePosition]

    putNewLine

    movzx ecx, byte[maxLines]

    sub ecx, 2

.printOtherLinesLoop:

    call printLine

    jc .showTitleAndFooter

    putNewLine

    loop .printOtherLinesLoop

.showTitleAndFooter:

;; Prints program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs Lyoko.applicationTitle

    mov al, byte[maxLines] ;; Last line

    dec al

    hx.syscall hx.clearLine

    fputs Lyoko.applicationFooter

    hx.syscall hx.getCursor

    mov dl, byte[maxColumns]

    sub dl, 48

    hx.syscall hx.setCursor

    fputs Lyoko.assemblerName

    mov dl, byte[maxColumns]

    sub dl, 41

    hx.syscall hx.setCursor

    fputs Lyoko.separator

    fputs Lyoko.encoding

    fputs Lyoko.separator

    mov dl, byte[maxColumns]

    sub dl, 30

    mov dh, 0

    hx.syscall hx.setCursor

    fputs Lyoko.fileIdentifier

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

;; Update screen

.updateBuffer:

    hx.syscall hx.updateScreen

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

.otherPrintedLines:

    mov byte[screenRefreshIsRequired], 0

    mov dl, 0
    mov dh, byte[linePositionOnScreen]

    hx.syscall hx.setCursor

;; Print current line

    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call printLine

    mov al, ' '

    hx.syscall hx.printCharacter

;; Print current line and column

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, byte[maxColumns]

    sub dl, 30

    mov dh, byte[maxLines]

    dec dh

    hx.syscall hx.setCursor

    fputs Lyoko.line

    mov eax, dword[line]

    inc eax ;; Counting from 1

    printInteger

    fputs Lyoko.comma

    fputs Lyoko.column

    movzx eax, byte[currentPositionInLine]

    inc eax ;; Counting from 1

    printInteger

    mov al, ' '

    hx.syscall hx.printCharacter

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    cmp byte[Lyoko.firstExecution], 01h
    jne .startInputProcessing

    call lyokoShowWelcome

    jmp .awaitInteraction

.startInputProcessing:

;; Place cursor at current position on line

    mov dl, byte[currentPositionInLine]
    mov dh, byte[linePositionOnScreen]

    hx.syscall hx.setCursor

.processInput:

    call processInput

    cmp byte[returnOrigin], 01h
    je .startInputProcessing

    jmp .awaitInteraction

;;*************************************************************************************************

lyokoSaveFile:

    cmp byte[filename], 0
    jne .fileAlreadyOpened

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

    fputs Lyoko.requestFile

    mov eax, 12 ;; Maximum characters

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .end

;; Save filename

    push es

;; Let's configure DS and ES with user mode data segment

    push ds
    pop es

    mov edi, filename
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including NULL

    rep movsb

;; Add to footer

    mov ecx, eax ;; Filename characters

    inc ecx

    mov esi, filename
    mov edi, Lyoko.fileIdentifier+sizeToFilename

    rep movsb

    pop es

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    jmp .continue

.fileAlreadyOpened:

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

    fputs Lyoko.fileSaved

    mov byte [Lyoko.changed], 0 ;; Clear changed status

.end:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

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

    fputs Lyoko.unlinkError

    hx.syscall hx.waitKeyboard

    jmp .end

.permissionDenied:

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov al, byte[maxLines]

    sub al, 2

    hx.syscall hx.clearLine

    mov dl, 0
    mov dh, byte[maxLines]

    sub dh, 2

    hx.syscall hx.setCursor

    fputs Lyoko.permissionDenied

    jmp .end

;;*************************************************************************************************

lyokoOpenFile:

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

    fputs Lyoko.requestFile

    mov eax, 12 ;; Maximum characters

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .end

;; Save filename

    push es

;; Let's configure DS and ES with user mode data segment

    push ds
    pop es

    mov edi, filename
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including NULL

    rep movsb

;; Add to footer

    mov ecx, eax ;; Filename characters

    inc ecx

    mov esi, filename
    mov edi, Lyoko.fileIdentifier+sizeToFilename

    rep movsb

    pop es

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    call clearVideoBuffer

    call clearTextBuffer

    mov byte[screenRefreshIsRequired], 1


    jmp LyokoIDE.openFile

.end:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;************************************************************************************

highlightEdition:

    push es

;; Let's configure DS and ES with user mode data segment

    push ds
    pop es

    mov edi, Lyoko.edited
    mov ecx, eax ;; Characters in the filename

    inc ecx ;; Including NULL

    rep movsb

;; Add to footer

    mov ecx, eax ;; Filename characters

    inc ecx

    mov esi, Lyoko.edited
    mov edi, Lyoko.fileIdentifier+sizeToFilename+8

    rep movsb

    pop es

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

lyokoExecuteAssembler:

    call buildWarning

    fputs Lyoko.runningAssembler

    mov esi, filename

    cmp byte[esi], 0
    je .withoutSourceCode

    mov esi, Lyoko.fasmX
    mov edi, filename

    hx.syscall hx.exec

    jmp .end

.withoutSourceCode:

    fputs Lyoko.withoutSourceCode

.end:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

lyokoShowHelp:

    mov byte[Lyoko.biggerBox], 01h

    call buildWarning

    fputs Lyoko.quickWarning

.end:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

lyokoShowInfo:

    mov byte[Lyoko.biggerBox], 01h

    call buildWarning

    fputs Lyoko.infoLyoko

.end:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

lyokoShowWelcome:

    call buildWarning

    fputs Lyoko.welcome

.end:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.waitKeyboard

    mov byte[screenRefreshIsRequired], 01h

    mov byte[Lyoko.firstExecution], 00h

    ret

;;*************************************************************************************************

buildWarning:

    cmp byte[Lyoko.biggerBox], 01h
    je .checkResolutionLargerBox

.checkResolutionSmallBox:

    cmp dword[resolution], 01h
    je .smallBoxResolution1

    cmp dword[resolution], 02h
    je .smallBoxResolution2

    jmp .end

.checkResolutionLargerBox:

    cmp dword[resolution], 01h
    je .largerBoxResolution1

    cmp dword[resolution], 02h
    je .largerBoxResolution2

    jmp .end

.smallBoxResolution1:

    mov eax, 0   ;; Start of block at X
    mov ebx, 350 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 200 ;; Block height
    mov edx, HIGHLIGHT_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Start of block at X
    mov ebx, 340 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 10  ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Start of block at X
    mov ebx, 550 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 10  ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 22

    hx.syscall hx.setCursor

    jmp .end

.smallBoxResolution2:

    mov eax, 0    ;; Start of block at X
    mov ebx, 470  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 250  ;; Block height
    mov edx, HIGHLIGHT_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Start of block at X
    mov ebx, 460  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 10   ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Start of block at X
    mov ebx, 710  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 10   ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 30

    hx.syscall hx.setCursor

    jmp .end

.largerBoxResolution1:

    mov eax, 0   ;; Start of block at X
    mov ebx, 200 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 360 ;; Block height
    mov edx, HIGHLIGHT_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Start of block at X
    mov ebx, 190 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 10  ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Start of block at X
    mov ebx, 550 ;; Start of block at Y
    mov esi, 800 ;; Block length
    mov edi, 10  ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 14

    hx.syscall hx.setCursor

    jmp .end

.largerBoxResolution2:

    mov eax, 0    ;; Start of block at X
    mov ebx, 200  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 510  ;; Block height
    mov edx, HIGHLIGHT_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Start of block at X
    mov ebx, 190  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 10   ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Start of block at X
    mov ebx, 710  ;; Start of block at Y
    mov esi, 1024 ;; Block length
    mov edi, 10   ;; Block height
    mov edx, BANNER_COLOR ;; Block color

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 14

    hx.syscall hx.setCursor

    jmp .end

.end:

    mov byte[Lyoko.biggerBox], 00h

    ret

;;*************************************************************************************************

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
    je .returnKey

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

    mov byte [Lyoko.changed], 1

    mov bl, byte[maxColumns]

    dec bl

    cmp byte[currentLineSize], bl
    jae .prepareReturn

    mov edx, 0
    movzx esi, byte[currentPositionInLine] ;; Position to insert characters

    add esi, dword[currentLinePosition]
    add esi, appFileBuffer

    hx.syscall hx.insertCharacter ;; Insert char into string

    inc byte[currentPositionInLine] ;; A character has been added
    inc byte[currentLineSize]

;; More keys

    jmp .prepareReturn

;; Return/Enter key

.returnKey:

    mov byte[screenRefreshIsRequired], 1

    mov edx, 0

    movzx esi, byte[currentPositionInLine]

    add esi, appFileBuffer
    add esi, dword[currentLinePosition]

    mov al, 10

    hx.syscall hx.insertCharacter

;; New line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize ;; Find size for this line

    mov byte[currentPositionInLine], 0 ;; Cursor at the end of the line
    mov byte[currentLineSize], dl  ;; Save current line size

    mov al, 10 ;; New line character
    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

;; Try moving the cursor down

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jb .returnKey.cursorNextLine

;; If it is the last line, rotate the screen

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[linePositionOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    jmp .prepareReturn

.returnKey.cursorNextLine:

    inc byte[linePositionOnScreen]

    jmp .prepareReturn

;; Control keys

.controlKeys:

    pop eax

    cmp al, 's'
    je .ControlSKeys

    cmp al, 'S'
    je .ControlSKeys

    cmp al, 'x'
    je .ControlXKeys

    cmp al, 'X'
    je .ControlXKeys

    cmp al, 'a'
    je .ControlAKeys

    cmp al, 'A'
    je .ControlAKeys

    cmp al, 'v'
    je .ControlVKeys

    cmp al, 'V'
    je .ControlVKeys

    cmp al, 'm'
    je .ControlMKeys

    cmp al, 'M'
    je .ControlMKeys

    cmp al, 'f'
    je lyokoExitIDE

    cmp al, 'F'
    je lyokoExitIDE

    jmp .prepareReturn

.backspaceKey:

;; If in the first column, do nothing

    cmp byte[currentPositionInLine], 0
    je .backspaceKey.firstColumn

;; Remove character from left

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[currentPositionInLine] ;; A character has been removed
    dec byte[currentLineSize]

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

    add dl, byte[currentLineSize]

;; Backspace not enabled (support of up to 79 characters per line)

    mov bl, byte[maxColumns]

    dec bl

    cmp dl, bl ;; Counting from 0
    jnae .continue

    pop edx

    ret

.continue:

;; Remove newline character

    mov byte[screenRefreshIsRequired], 1

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[totalLines] ;; One line was removed
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

    call lineSize ;; Find size of current line

    mov byte[currentLineSize], dl ;; Save line size

    pop dword[currentLinePosition]

    pop edx

    mov byte[currentPositionInLine], dl

    jmp .upKey.cursorMoved

.pushReturn:

    pop edx

    ret

.deleteKey:

;; If in the last column, do nothing

    mov dl, byte[currentLineSize]

    cmp byte[currentPositionInLine], dl
    jae .prepareReturn

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[currentLineSize] ;; A character has been removed

    inc byte[currentPositionInLine]

.leftKey:

;; If in the first column, do nothing

    cmp byte[currentPositionInLine], 0
    jne .leftKey.moveToLeft

    cmp byte[line], 0
    je .prepareReturn

    mov bl, byte[maxColumns]
    mov byte[currentPositionInLine], bl

    jmp .upKey

;; Move cursor left

.leftKey.moveToLeft:

    dec byte[currentPositionInLine]

    jmp .prepareReturn

.rightKey:

;; If in the last column, do nothing

    mov dl, byte[currentLineSize]

    cmp byte[currentPositionInLine], dl
    jnae .rightKey.moveToRight

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

    mov dword[currentLinePosition], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], 0 ;; Cursor at the end of the line
    mov byte[currentLineSize], dl  ;; Save line size

    jmp .downKey.next

.rightKey.moveToRight:

    inc byte[currentPositionInLine]

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

    mov dword[currentLinePosition], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentLineSize], dl

    cmp dl, byte[currentPositionInLine]
    jb .upKey.moveCursorToTheEnd

    jmp .upKey.cursorMoved ;; Do not change the cursor column

.upKey.moveCursorToTheEnd:

    mov byte[currentPositionInLine], dl ;; Cursor at the end of the line

.upKey.cursorMoved:

;; Try moving the cursor up

    cmp byte[linePositionOnScreen], 1
    ja .upKey.moveCursorToPreviousLine

;; If the cursor is on the first line, scroll up

    mov byte[linePositionOnScreen], 1
    mov eax, dword[currentLinePosition]
    mov dword[currentPagePosition], eax

    mov byte[screenRefreshIsRequired], 1

    jmp .prepareReturn

.upKey.moveCursorToPreviousLine:

    dec byte[linePositionOnScreen]

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

    mov dword[currentLinePosition], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentLineSize], dl

    cmp dl, byte[currentPositionInLine]
    jb .downKey.moveCursorToTheEnd

    jmp .downKey.cursorMoved ;; Do not change the column

.downKey.moveCursorToTheEnd:

    mov byte[currentPositionInLine], dl ;; Cursor at the end of the line

.downKey.cursorMoved:

.downKey.next:

;; Try moving the cursor down

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jb .downKey.cursorNextLine

;; If in the last line, scroll the screen down

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[linePositionOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    mov byte[screenRefreshIsRequired], 1

    jmp .prepareReturn

.downKey.cursorNextLine:

    inc byte[linePositionOnScreen]

    jmp .prepareReturn

.homeKey:

;; Move cursor to first column

    mov byte[currentPositionInLine], 0

    jmp .prepareReturn

.endKey:

;; Move cursor to last column

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], dl

    jmp .prepareReturn

.pageUpKey:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    cmp eax, 0
    jle .pageUpKey.goToFirstLine

;; Do not redraw if in the last line

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jae .pageUpKey.noNeedToRedraw

    mov byte[screenRefreshIsRequired], 1

.pageUpKey.noNeedToRedraw:

;; Previous line

    movzx ebx, byte[maxLines]

    sub bl, 3
    sub dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], dl ;; Cursor at the end of the line
    mov byte[currentLineSize], dl

.pageUpKey.end:

    mov byte[linePositionOnScreen], 1
    mov eax, dword[currentLinePosition]
    mov dword[currentPagePosition], eax

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

    mov dword[currentLinePosition], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], dl ;; Cursor at the end of the line
    mov byte[currentLineSize], dl

    jmp .pageUpKey.end

.pageDownKey:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3

    add eax, ebx

    cmp eax, dword[totalLines]
    jae .pageDownKey.goToLastLine

;; Do not redraw the first line

    cmp byte[linePositionOnScreen], 1
    jle .pageDownKey.noNeedToRedraw

    mov byte[screenRefreshIsRequired], 1

.pageDownKey.noNeedToRedraw:

;; Next line

    movzx ebx, byte[maxLines]

    sub bl, 3

    add dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calculate values ​​for the line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], dl
    mov byte[currentLineSize], dl

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[linePositionOnScreen], bl

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    mov esi, appFileBuffer

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

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

    mov dword[currentLinePosition], esi

;; Calculate values ​​for this line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call lineSize

    mov byte[currentPositionInLine], dl
    mov byte[currentLineSize], dl

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

    mov byte[linePositionOnScreen], bl

    mov eax, dword[line]

    sub eax, ebx

    inc eax

    mov esi, appFileBuffer

    call linePosition

    jc .prepareReturn

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    jmp .prepareReturn

.ControlSKeys:

    call lyokoSaveFile

    jmp .prepareSpecialReturn

.ControlXKeys:

    call lyokoShowHelp

    jmp .prepareSpecialReturn

.ControlVKeys:

    call lyokoShowInfo

    jmp .prepareSpecialReturn

.ControlMKeys:

    call lyokoExecuteAssembler

    jmp .prepareSpecialReturn

.ControlAKeys:

    call lyokoOpenFile

    jmp .prepareReturn

.prepareReturn:

    mov byte[returnOrigin], 00h

    ret

.prepareSpecialReturn:

    hx.syscall hx.waitKeyboard

    mov byte[returnOrigin], 00h

    ret

;;*************************************************************************************************

lyokoExitIDE:

    mov ah, byte[Lyoko.changed]

    cmp ah, 0
    je .finish

    call buildWarning

    fputs Lyoko.saveWarning

.loopKeys:

    hx.syscall hx.waitKeyboard

    cmp al, 's'
    je .startSavingFile

    cmp al, 'S'
    je .startSavingFile

    cmp al, 'n'
    je .finish

    cmp al, 'N'
    je .finish

jmp .loopKeys

.startSavingFile:

    call lyokoSaveFile

.finish:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.scrollConsole

    mov ebx, 00h

    hx.syscall hx.exit

;;*************************************************************************************************

;;*************************************************************************************************
;;
;; Other application functions
;;
;;*************************************************************************************************

;; Print a line of string
;;
;; Input:
;;
;; ESI - Buffer Address
;;
;; Output:
;;
;; ESI - Next buffer
;; Carry defined at the end of the file

printLine:

    mov edx, 0 ;; Character counter

.printLoop:

    lodsb

    cmp al, 10 ;; End of the line
    je .end

    cmp al, 0 ;; End of String
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
;; ESI - Buffer address
;;
;; Output:
;;
;; ESI - Next Buffer
;; EDX - Line size

lineSize:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; End of the line
    je .end

    cmp al, 0 ;; End of string
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
;; Carry defined if line not found

linePosition:

    push ebx

    cmp eax, 0
    je .linhaDesejadaEncontrada ;; Already in the first line

    mov edx, 0   ;; Line counter
    mov ebx, eax ;; Save line

    dec ebx

.nextCharacter:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; New line character
    je .lineFound

    cmp al, 0 ;; End of string
    je .lineNotFound

    jmp .nextCharacter

.lineFound:

    cmp edx, ebx
    je .linhaDesejadaEncontrada

    inc edx ;; Line counter

    jmp .nextCharacter

.linhaDesejadaEncontrada:

    clc

    jmp .end

.lineNotFound:

    stc

.end:

    pop ebx

    ret


;;*************************************************************************************************

clearVideoBuffer:

    mov esi, Hexagon.LibASM.Dev.video.tty1

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    ret

;;************************************************************************************

clearTextBuffer:

    mov dword[appFileBuffer], 10 ;; Let's clear the text buffer

    mov esi, appFileBuffer
    mov eax, 0
    mov dword[line], eax

    mov byte[linePositionOnScreen], 01h
    mov eax, dword[currentLinePosition]
    mov dword[currentPagePosition], eax

    ret

;;*************************************************************************************************

;;*************************************************************************************************
;;
;; Buffer for storing the requested file
;;
;;*************************************************************************************************

appFileBuffer: db 10
