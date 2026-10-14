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
;;                         Copyright (c) 2015-2026 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2026, Felipe Miguel Nery Lunkes
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

;; Architecture | Version | Subversion | Entry point | Image type | BSS size
headerHAPP HAPP.Architectures.i386, 1, 8, shellStart, 01h, HAPP.bss.none

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "errors.s"
include "log.s"
include "macros.s"
include "string.s"
include "malloc.s"
include "mount.s"
include "shell.s"

;;************************************************************************************
;;
;;                        Application variables and data
;;
;;************************************************************************************

VERSION             equ "0.3.0"
compatibleHexagonix equ "Hylia"

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
.listError:
db 10, "Error listing the files present on the volume.", 0
.mallocError:
db 10, "Failed to allocate a buffer for the file listing.", 0

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
.set:
db "set", 0

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

remainingList:  dd ?
currentFile:    dd ' '
listBuffer:     dd 0
listBufferSize: dd ?

DOSsh.resolvedPath: dd 0 ;; Command path after Shell.resolveCommandPath, across the shebang check

currentDirBuffer: ;; Dir command own volume-label lookup
times 64 db 0

mountsBufferSize = 4096

mountsBuffer:     dd ?
mountsCount:      dd ?
mountsPointer:    dd ?
bestMatchLength:  dd ?
bestMatchRecord:  dd ?

commandLine: dd 0

;;************************************************************************************

shellStart:

    mov [commandLine], edi

    systemLog DOSsh.verboseStartingDOSsh, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseDOSshVersion, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseAuthor, 00h, Log.Priorities.p4
    systemLog DOSsh.verboseCopyright, 00h, Log.Priorities.p4

    mov esi, [commandLine]

    cmp byte[esi], 0
    je .start

;; Launched with a single existing file as an argument: run it as a
;; script instead of starting an interactive prompt. This is how a
;; shebang dispatch from Shell.checkShebang hands a script off to the
;; shell named on its "#!" line

    hx.syscall hx.stat

    jc .start ;; Not a file (or some other argument shape). Interactive as usual

    mov esi, [commandLine]

    call Shell.runScriptFile

    jmp finishShell

.start:

;; Start console configuration

    Andromeda.Estelar.getConsoleInfo

    hx.syscall hx.clearConsole

    fputs DOSsh.starting

    putNewLine

    call Shell.loadRc

;;************************************************************************************

getCommand:

    putNewLine

.withoutNewLine:

    fputs DOSsh.prompt

    mov al, byte[Andromeda.Interface.numColumns] ;; Maximum characters to get

    sub al, 20

    mov edi, typedLine

    hx.syscall hx.getString

    mov esi, typedLine

    call trimString ;; Remove extra spaces

    cmp byte[esi], 0 ;; No command inserted
    je getCommand

;; Compare with available internal commands

    ;; EXIT command

    mov edi, DOSsh.commands.exit

    call compareWordsInString

    jc finishShell

    ;; VER command

    mov edi, DOSsh.commands.version

    call compareWordsInString

    jc commandVER

    ;; HELP command

    mov edi, DOSsh.commands.help

    call compareWordsInString

    jc commandHELP

    ;; CLS command

    mov edi, DOSsh.commands.cls

    call compareWordsInString

    jc commandCLS

    ;; DIR command

    mov edi, DOSsh.commands.dir

    call compareWordsInString

    jc commandDIR

    ;; TYPE command

    mov edi, DOSsh.commands.type

    call compareWordsInString

    jc commandTYPE

    ;; CD command

    mov edi, DOSsh.commands.cd

    call compareWordsInString

    jc commandCD

    ;; SET command

    mov edi, DOSsh.commands.set

    call compareWordsInString

    jc commandSET

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

    call trimString

    pop esi

;; Protect the arguments from Shell.checkShebang before it opens the
;; resolved command's own file into a buffer of its own

    call Shell.protectArguments

;; Resolve the command name against PATH if it isn't already valid as
;; given, then check for a "#!name" shebang on the resolved file

    call Shell.resolveCommandPath

    mov [DOSsh.resolvedPath], esi

    call Shell.checkShebang

    jc .noShebang

;; ESI = shell name from the shebang line. Run that shell with the
;; resolved script as its own argument, ignoring any arguments this
;; command line itself may have had

    mov edi, dword[DOSsh.resolvedPath]

    mov eax, 1

    stc

    hx.syscall hx.exec

    jc .failedToExecute

    jmp getCommand

.noShebang:

    mov esi, dword[DOSsh.resolvedPath]
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

    call printCurrentVolumeLabel

    fputs DOSsh.dir.dirLine2

    fputs DOSsh.dir.dirLine3

.obterListaArquivos:

    mov dword[listBufferSize], 32768 ;; Arbitrary starting guess

.allocateBuffer:

    mov ebx, dword[listBufferSize]

    call malloc

    cmp eax, 0
    je .listMallocError

    mov dword[listBuffer], ebx
    mov esi, ebx
    mov ecx, dword[listBufferSize]

    hx.syscall hx.listFiles ;; EAX = entry count, or exact size needed if CF is set

    jnc .haveList

    cmp eax, 0
    je .listError ;; A real filesystem error, not an undersized buffer

;; The buffer was too small. EAX already holds the exact size needed,
;; reported by the kernel before it wrote anything

    push eax

    mov ebx, dword[listBuffer]
    mov ecx, dword[listBufferSize]

    call free

    pop eax

    mov dword[listBufferSize], eax

    jmp .allocateBuffer

.haveList:

    mov esi, dword[listBuffer]
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

    call compareWordsInString ;; Check for .MAN extension

    jc .hide

    mov edi, DOSsh.extensionOCL

    call compareWordsInString ;; Check for .OCL extension

    jc .hide

    mov edi, DOSsh.extensionCOW

    call compareWordsInString ;; Check for .COW extension

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

    mov ebx, dword[listBuffer]
    mov ecx, dword[listBufferSize]

    call free

    mov dword[listBuffer], 0

    jmp getCommand.withoutNewLine

.listError:

    mov ebx, dword[listBuffer]
    mov ecx, dword[listBufferSize]

    call free

    mov dword[listBuffer], 0

    fputs DOSsh.dir.listError

    jmp getCommand.withoutNewLine

.listMallocError:

    fputs DOSsh.dir.mallocError

    jmp getCommand.withoutNewLine

;;************************************************************************************

;; Prints the volume label of whichever mount owns the current directory,
;; at the current cursor position. Prints nothing if it can't be
;; determined (allocation failure, or somehow no mount matches at all)

printCurrentVolumeLabel:

    mov edi, currentDirBuffer

    hx.syscall hx.getCurrentDirectory

    mov ebx, mountsBufferSize

    call malloc

    cmp eax, 0
    je .done ;; Best effort, no label rather than a hard error here

    mov dword[mountsBuffer], ebx
    mov esi, ebx

    hx.syscall hx.getMounts

    mov dword[mountsCount], eax
    mov eax, dword[mountsBuffer]
    mov dword[mountsPointer], eax
    mov dword[bestMatchLength], 0
    mov dword[bestMatchRecord], 0

.matchLoop:

    cmp dword[mountsCount], 0
    je .matchDone

    mov esi, currentDirBuffer
    mov edi, dword[mountsPointer] ;; Mount point path, offset 0

    call .prefixLength

    cmp eax, dword[bestMatchLength]
    jbe .matchNext

    mov dword[bestMatchLength], eax
    mov eax, dword[mountsPointer]
    mov dword[bestMatchRecord], eax

.matchNext:

    mov eax, dword[mountsPointer]

    add eax, hx.mount.record.size
    
    mov dword[mountsPointer], eax

    dec dword[mountsCount]

    jmp .matchLoop

.matchDone:

    mov ebx, dword[mountsBuffer]
    mov ecx, mountsBufferSize

    call free

    cmp dword[bestMatchRecord], 0
    je .done

    mov esi, dword[bestMatchRecord]

    add esi, hx.mount.record.volumeLabel

    printString

.done:

    ret

;; Returns the length of EDI's own NUL-terminated string if it's a genuine
;; prefix of ESI's string, or 0 if it isn't
;;
;; Input: ESI - String to check against, EDI - Candidate prefix
;; Output: EAX - Length of EDI if it matched, otherwise 0

.prefixLength:

    push esi
    push edi
    push ecx

    xor ecx, ecx

.prefixLoop:

    mov al, byte[edi + ecx]

    cmp al, 0
    je .prefixMatched

    cmp al, byte[esi + ecx]
    jne .prefixNotMatched

    inc ecx

    jmp .prefixLoop

.prefixMatched:

    mov eax, ecx

    jmp .prefixDone

.prefixNotMatched:

    xor eax, eax

.prefixDone:

    pop ecx
    pop edi
    pop esi

    ret

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

commandSET:

    add esi, 03h

    call trimString

    call Shell.handleSet

    jmp getCommand

;;************************************************************************************

commandTYPE:

    call getArguments

    push edi

    mov esi, edi

    hx.syscall hx.stat ;; EAX = size

    jc fileNotFound

;; Room for exactly this file, rather than whatever happens to sit past the
;; end of this image

    mov [fileSize], eax

    inc eax ;; The terminator, in memory the kernel hands over already zeroed

    mov ebx, eax

    call malloc

    cmp eax, 0
    je fileNotFound

    mov [fileBuffer], ebx
    mov esi, edi
    mov edi, ebx

    mov ecx, [fileSize] ;; Never past what was asked for

    hx.syscall hx.open

    jc fileNotFound

    putNewLine
    putNewLine

    fputs [fileBuffer]

    mov ebx, [fileBuffer]

    call free

    mov dword[fileBuffer], 0

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

    call stringSize

    mov ecx, eax

    inc ecx ;; Including the last character (NULL)

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov esi, ebx
    mov edi, argumentsBuffer

    rep movsb ;; Copy (ECX) string characters from ESI to EDI

    pop es

    mov edi, argumentsBuffer

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

typedLine: ;; hx.getString writes the typed line into a buffer of the caller's own
times 256 db 0

;; Where a command's arguments are copied to, out of the typed line, so that
;; opening a file cannot land on top of them

argumentsBuffer:
times 256 db 0

fileBuffer: dd 0
fileSize:   dd 0

