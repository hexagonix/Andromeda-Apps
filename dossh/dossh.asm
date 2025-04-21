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

use32

;; Now let's create a HAPP header for the application

include "HAPP.s" ;; Here is a structure for the HAPP header

;; Instance | Structure | Architecture | Version | Subversion | Entry Point | Image type
appHeader headerHAPP HAPP.Architectures.i386, 1, 3, shellStart, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "errors.s"
include "log.s"
include "macros.s"

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION             equ "0.2.1"
compatibleHexagonix equ "Dormin"

;;**************************

DOSsh:

.starting:
db 10, "Starting HX-DOS...", 10, 10
db "HIMEM is testing extended memory... done.", 10, 0
.invalidCommand:
db "Bad command or filename.", 0
.copyright:
db 10, 10, "Copyright (C) 2022-", __stringYear, " Felipe Miguel Nery Lunkes", 10
db "All rights reserved.", 10, 0
.processLimit:
db 10, 10, "There is not enough memory available to run the requested application.", 10
db "Try to terminate applications or their instances first, and try again.", 0
.invalidImage:
db ": unable to load image. Unsupported executable format.", 10, 0
.prompt:
db "C:\> ", 0
.fileNotFound:
db 10, "File not found.", 0
.errorChangingDirectory:
db 10, "Directory not found or invalid.", 0
.directory:
db "<DIR> ", 0
.license:
db 10, "Licenced under BSD-3-Clause.", 0
.extensionCOW:
db ".COW",0
.extensionMAN:
db ".MAN",0
.extensionOCL:
db ".OCL",0

;; Verbose

.verboseStartingDOSsh:
db "[DOSsh]: DOSsh for Hexagonix version ", compatibleHexagonix, " or superior.", 0
.verboseDOSshVersion:
db "[DOSsh]: DOSsh version ", VERSION, ".", 0
.verboseAuthor:
db "[DOSsh]: Copyright (C) 2022-", __stringYear, " Felipe Miguel Nery Lunkes.", 0
.verboseCopyright:
db "[DOSsh]: All rights reserved.", 0
.verboseExitDOSsh:
db "[DOSsh]: Terminating DOSsh and returning control to the parent process...", 0
.verboseProcessLimit:
db "[DOSsh]: Memory or process limit reached!", 0

;; Relative to the dir command

DOSsh.dir:

.dirLine1:
db 10, 10, "Volume in drive C is ", 0
.dirLine2:
db 10, "Volume Serial Number is HXHX-HXHX", 0
.dirLine3:
db 10, "Directory of C:\", 10, 10, 0

DOSsh.commands:

.exit:
db "exit",0
.version:
db "ver", 0
.help:
db "help", 0
.cls:
db "cls", 0
.dir:
db "dir", 0
.type:
db "type", 0
.cd:
db "cd", 0

;; Regarding the help and ver commands

DOSsh.help:

.intro:
db 10, 10, "HX-DOS version 6.22", 10
db "DOSsh version ", VERSION, 0
.helpContent:
db 10, 10, "Internal commands available:", 10, 10
db " CD   - Change current directory.", 10
db " DIR  - Displays files on the current volume.", 10
db " TYPE - Displays the contents of a file given as a parameter.", 10
db " CLS  - Clears the screen (in the case of Hexagonix, the terminal opened at tty0).", 10
db " VER  - Displays version information of DOSsh running.", 10
db " EXIT - Terminate this DOSsh session.", 10, 0

;; Buffers

remainingList: dd ?
currentFile:   dd ' '

;;************************************************************************************

shellStart:

    systemLog DOSsh.verboseStartingDOSsh, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseDOSshVersion, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseAuthor, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseCopyright, 00h, Log.Priorities.p4

;; Start console configuration

    Andromeda.Estelar.getConsoleInfo

    hx.syscall hx.clearConsole

    fputs DOSsh.starting

;;************************************************************************************

getCommand:

    putNewLine

.withoutNewLine:

    fputs DOSsh.prompt

    mov al, byte[Andromeda.Interface.numColumns] ;; Maximum characters to get

    sub al, 20

    hx.syscall hx.getString

    hx.syscall hx.trimString ;; Remove extra spaces

    cmp byte[esi], 0 ;; Nenhum comando inserido
    je getCommand

;; Compare with available internal commands

    ;; EXIT command

    mov edi, DOSsh.commands.exit

    hx.syscall hx.compareWordsString

    jc finishShell

    ;; VER command

    mov edi, DOSsh.commands.version

    hx.syscall hx.compareWordsString

    jc commandVER

    ;; HELP command

    mov edi, DOSsh.commands.help

    hx.syscall hx.compareWordsString

    jc commandHELP

    ;; CLS command

    mov edi, DOSsh.commands.cls

    hx.syscall hx.compareWordsString

    jc commandCLS

    ;; DIR command

    mov edi, DOSsh.commands.dir

    hx.syscall hx.compareWordsString

    jc commandDIR

    ;; TYPE command

    mov edi, DOSsh.commands.type

    hx.syscall hx.compareWordsString

    jc commandTYPE

    ;; CD command

    mov edi, DOSsh.commands.cd

    hx.syscall hx.compareWordsString

    jc commandCD

;;************************************************************************************

loadImage:

;; Try to load a program

    call getArguments ;; Separate command and arguments

    push esi
    push edi

    jmp .loadApplication

.failedToExecute:

;; Now the error sent by the system will be analyzed, so that the shell knows its nature

    cmp eax, Hexagon.processesLimit ;; Limit of running processes reached
    je .limitReached                ;; If yes, display the appropriate message

    cmp eax, Hexagon.invalidImage ;; Invalid HAPP image
    je .invalidHAPPImage          ;; If yes, display the appropriate message

    push esi

    putNewLine

    pop esi

    fputs DOSsh.invalidCommand

    jmp getCommand

.limitReached:

    fputs DOSsh.processLimit

    clc

    jmp getCommand

.invalidHAPPImage:

    push esi

    putNewLine
    putNewLine

    pop esi

    printString

    fputs DOSsh.invalidImage

    jmp getCommand

.loadApplication:

    pop edi

    mov esi, edi

    hx.syscall hx.trimString

    pop esi

    mov eax, edi

    stc

    hx.syscall hx.exec

    jc .failedToExecute

    jmp getCommand

;;************************************************************************************

commandHELP:

    fputs DOSsh.help.helpContent

    jmp getCommand

;;************************************************************************************

commandCLS:

    hx.syscall hx.clearConsole

    jmp getCommand

;;************************************************************************************

commandDIR:

    fputs DOSsh.dir.dirLine1

    hx.syscall hx.getVolume

    mov esi, edi

    printString

    fputs DOSsh.dir.dirLine2

    fputs DOSsh.dir.dirLine3

.obterListaArquivos:

    hx.syscall hx.listFiles ;; Get files in ESI

   ;; jc .listError

    mov [remainingList], esi

    push eax

    pop ebx

    xor ecx, ecx
    xor edx, edx

.fileLoop:

    push ds ;; User mode data segment (38h selector)
    pop es

    push ebx
    push ecx

    call readFileList

    push esi

    cmp eax, 02h
    je .printDirectory

    cmp eax, 00h
    je getCommand

    sub esi, 5

    mov edi, DOSsh.extensionMAN

    hx.syscall hx.compareWordsString ;; Check for .MAN extension

    jc .hide

    mov edi, DOSsh.extensionOCL

    hx.syscall hx.compareWordsString ;; Check for .OCL extension

    jc .hide

    mov edi, DOSsh.extensionCOW

    hx.syscall hx.compareWordsString ;; Check for .COW extension

    jc .hide

jmp .continue

.printDirectory:

    fputs DOSsh.directory

.continue:

    pop esi

    fputs [currentFile]

    push ecx
    push ebx
    push eax

    putNewLine

    pop eax
    pop ebx
    pop ecx

    jmp .count

.hide:

    pop esi

    inc ecx

.count:

    pop ecx
    pop ebx

    cmp ecx, ebx
    je .finished

    inc ecx

    jmp .fileLoop

.finished:

    jmp getCommand.withoutNewLine

;;************************************************************************************

commandCD:

    call getArguments

    clc

    mov esi, edi

    hx.syscall hx.changeDirectory

    jc .errorChangingDirectory

    jmp getCommand

.errorChangingDirectory:

    fputs DOSsh.errorChangingDirectory

    jmp getCommand

;;************************************************************************************

commandTYPE:

    call getArguments

    push edi

    mov esi, edi

    hx.syscall hx.fileExists

    jc fileNotFound

    mov esi, edi
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc fileNotFound

    putNewLine
    putNewLine

    fputs appFileBuffer

    jmp getCommand

;;************************************************************************************

commandVER:

    fputs DOSsh.help.intro

    fputs DOSsh.copyright

    fputs DOSsh.license

    putNewLine

    jmp getCommand

;;************************************************************************************

finishShell:

    systemLog DOSsh.verboseExitDOSsh, 00h, Log.Priorities.p4

    putNewLine

    mov ebx, 00h

    hx.syscall hx.exit

    jmp getCommand

    hx.syscall hx.waitKeyboard

    hx.syscall hx.exit

;;************************************************************************************

fileNotFound:

    fputs DOSsh.fileNotFound

    jmp getCommand

;;************************************************************************************

;;************************************************************************************
;;
;; End of DOSsh internal commands
;;
;; Useful functions for manipulating data in the DOSsh shell
;;
;;************************************************************************************

;; Separate command name and arguments
;;
;; Input:
;;
;; ESI - Command address
;;
;; Output:
;;
;; ESI - Command address
;; EDI - Command arguments
;; CF  - Set in case of lack of extension

getArguments:

    push esi

.loop:

    lodsb ;; mov AL, byte[ESI] & inc ESI

    cmp al, 0
    je .notFound

    cmp al, ' '
    je .spaceFound

    jmp .loop

.notFound:

    pop esi

    mov edi, 0

    stc

    jmp .end

.spaceFound:

    mov byte[esi-1], 0
    mov ebx, esi

    hx.syscall hx.stringSize

    mov ecx, eax

    inc ecx ;; Including the last character (NULL)

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov esi, ebx
    mov edi, appFileBuffer

    rep movsb ;; Copy (ECX) string characters from ESI to EDI

    pop es

    mov edi, appFileBuffer

    pop esi

    clc

.end:

    ret

;;************************************************************************************

;; Get a file/directory name from list and get entry type
;;
;; Output:
;;
;; ESI - Entry content
;; EAX - Entry type (01h = file, 02h = directory, 00h = reached the end of the list)

readFileList:

    push ds
    pop es

    mov esi, [remainingList]
    mov [currentFile], esi

.findDelimiter:

    lodsb ;; Load byte from [ESI] in AL and increase ESI

    cmp al, 0x90
    je .foundFile

    cmp al, 0x80
    je .foundDirectory

    cmp al, 0 ;; End of string
    je .endList

    jmp .findDelimiter

.foundFile:

    mov byte [esi - 1], 0 ;; End string
    mov [remainingList], esi
    mov eax, 01h

    ret

.foundDirectory:

    mov byte [esi - 1], 0 ;; End string
    mov [remainingList], esi
    mov eax, 02h

    ret

.endList:

    mov dword [currentFile], 0  ;; The list reached the end
    xor eax, eax

    ret

;;************************************************************************************

appFileBuffer: ;; Address for opening files
