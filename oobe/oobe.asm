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
include "macros.s"
include "console.s"

;;************************************************************************************

versaoOOBE = "1.5.0"

COLOR_LOGO    = VERDE_40
COLOR_DIVIDER = HEXAGONIX_BLOSSOM_VERMELHO
COLOR_ERROR   = ROXO_ESCURO
COLOR_PAGE    = HEXAGONIX_BLOSSOM_VERDE

OOBE:

.divider:

db "****************************************************************************************************", 0

.banner:
db 10
db "  88                                                                                88", 10
db "  88                                                                                ''", 10
db "  88", 10
db "  88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8", 10
db "  88P'    '88 a8P     88  `P8, ,8P'  ''     `P8 a8'    `P88 a8'     '8a 88P'   `'88 88  `P8, ,8P'", 10
db "  88       88 8PP'''''''    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(", 10
db "  88       88 '8b,   ,aa  ,d8' '8b,  88,    ,88 '8a,   ,d88 '8a,   ,a8' 88       88 88  ,d8' '8b,", 10
db "  88       88  `'Pbbd8'' 8P'     `P8 `'8bbdP'P8  `'PbbdP'P8  `'PbbdP''  88       88 88 8P'     `P8", 10
db "                                                 aa,    ,88", 10
db "                                                  'P8bbdP'", 10, 0
.pag1:
db 10
db "Page 1/6", 10, 10, 0
.pag2:
db 10
db "Page 2/6", 10, 10, 0
.pag3:
db 10
db "Page 3/6", 10, 10, 0
.pag4:
db 10
db "Page 4/6", 10, 10, 0
.pag5:
db 10
db "Page 5/6", 10, 10, 0
.pag6:
db 10
db "Page 6/6", 10, 10, 0
.page1:
db "Welcome to Hexagonix Operating System!", 10, 10
db "This must be your first contact with Hexagonix, right?", 10, 10
db "Now let's take a quick tour of Hexagonix, its components and utilities.", 10, 10 ;; '
db "Hexagonix is a system built from scratch, Unix-like and completely developed in x86 Assembly, with", 10
db "a focus on speed and simplicity. The system aims to be easy to use, fully customizable and simple", 10
db "to understand and extend. In addition, it is fully documented and lean, which makes it an excellent", 10
db "choice as a learning tool in operating system development.", 10, 10
db "Furthermore, Hexagonix and all of its components are free and open source software licensed under", 10
db "the BSD-3-Clause License. This allows the code to be reused (with due credit and accompanied by", 10
db "copyright) in other projects, commercial or not, in addition to allowing a wide range of derivative", 10
db "projects. The license also allows the software to be customized and rebuilt. Feel free to build", 10
db "your Hexagonix!", 10, 10
db "See the complete documentation at: https://github.com/hexagonix/Doc.", 0
.page2:
db "As a Unix-like system, you will find in Hexagonix a number of utilities common to this type of", 10
db "system. Utilities such as sh, ps, top, clear, init, login, cat, cowsay, mount, free and man, among", 10
db "others, are available in a standard system installation. Its usage syntax is based on the syntax of", 10
db "FreeBSD utilities. Whenever you are in doubt about the syntax or function of a utility, feel free", 10
db "to use 'man utility_name' and obtain a manual for using this utility.", 0
.page3:
db "In addition to the utilities common to the Unix environment, Hexagonix also comes with a number of", 10
db "unique applications. These applications present a visual environment different from the traditional", 10
db "Unix environment. Here you can find a calculator, a settings application, a virtual piano, graphical", 10
db "shutdown utilities, a powerful text editor and a development environment where you can develop new", 10
db "utilities for the system.", 10, 10
db "This environment is referred to in the Hexagonix documentation as the Hexagonix-Andromeda", 10
db "environment, in case you need this information later or are reading the system documentation.", 0
.page4:
db "In addition, Hexagonix comes with a port of the flat assembler (fasm), here called fasm Hexagonix", 10
db "Edition, or simply fasmX. This assembler is the same one used to build all of Hexagonix, and is used", 10
db "by the Hexagonix IDE (Lyoko) to generate the executable images of the utilities written by it. In", 10
db "the root directory of the system, you can find two sample files, gapp.asm and tapp.asm. Feel free to", 10
db "use fasmX to generate your respective binaries, using 'fasmx gapp.asm' or 'fasmx tapp.asm'. fasm is", 10
db "available under a free license and its sources (and adaptations for Hexagonix) can be found in the", 10
db "system repository on GitHub (https://github.com/hexagonix/fasmX).", 0
.page5:
db "Feel free to contact us to learn more about the system. To do so, use the email", 10
db "hexagonixdev@gmail.com, send a message to @HexagonixOS on Twitter or open an issue in the Hexagonix", 10
db "repository at https://github.com/hexagonix/hexagonix. Also, if you are an Assembly developer (or", 10
db "want to become one), C (to help develop a libc) or even fluent in another language, you can", 10
db "contribute to Hexagonix! You can also contribute by helping to test the system and report bugs. For", 10
db "all this, use the contact channels already mentioned. It will be a pleasure to have more people on", 10
db "the project!", 0
.page6:
db "We have reached the end of the tutorial. When finished, enter an 'ls' in the shell to start", 10
db "exploring the available utilities. Remember: at any time, you can use 'man utility' to learn more", 10
db "about it. Hope you like your experience with the system!", 0
.nextPage:
db 10, 10
db "Press any key to go to the next page...", 0
.finalMessage:
db 10, 10
db "You will no longer see this message on the next boot.", 10, 10
db "Press any key to finish the tour...", 10, 10, 0
.manualUnlink:
db 10, "An error occurred while removing OOBE and you need to remove it manually."
db 10, "For this, enter 'rm oobe' as root after login.", 10, 10, 0
.fileOOBE:
db "oobe", 0
.root:
db "root", 0
.jack:
db "jack", 0

;;************************************************************************************

applicationStart:

    saveConsole

.page1:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag1

    restoreConsoleColor

    fputs OOBE.page1

    fputs OOBE.nextPage

    call showDivider

    hx.syscall hx.waitKeyboard

.page2:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag2

    restoreConsoleColor

    fputs OOBE.page2

    fputs OOBE.nextPage

    call showDivider

    hx.syscall hx.waitKeyboard

.page3:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag3

    restoreConsoleColor

    fputs OOBE.page3

    fputs OOBE.nextPage

    call showDivider

    hx.syscall hx.waitKeyboard

.page4:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag4

    restoreConsoleColor

    fputs OOBE.page4

    fputs OOBE.nextPage

    call showDivider

    hx.syscall hx.waitKeyboard

.page5:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag5

    restoreConsoleColor

    fputs OOBE.page5

    fputs OOBE.nextPage

    call showDivider

    hx.syscall hx.waitKeyboard

.page6:

    call showBanner

    setConsoleColor COLOR_PAGE, [Lib.Console.backgroundColor]

    fputs OOBE.pag6

    restoreConsoleColor

    fputs OOBE.page6

;;************************************************************************************

.unlinkOOBE:

;; We will automatically login as root to unlink oobe file.
;; Then, let's login as a normal user, "jack"

.root:

    mov eax, 777 ;; Root user code

    mov esi, OOBE.root

    hx.syscall hx.setUser

    mov esi, OOBE.fileOOBE

    hx.syscall hx.unlink

    jc .unlinkError

    fputs OOBE.finalMessage

    setConsoleColor COLOR_DIVIDER, [Lib.Console.backgroundColor]

    fputs OOBE.divider

    restoreConsoleColor

    mov eax, 555 ;; Common user code

    mov esi, OOBE.jack

    hx.syscall hx.setUser

    hx.syscall hx.waitKeyboard

    jmp finish

.unlinkError:

    setConsoleColor COLOR_ERROR, [Lib.Console.backgroundColor]

    fputs OOBE.manualUnlink

    setConsoleColor COLOR_DIVIDER, [Lib.Console.backgroundColor]

    fputs OOBE.divider

    restoreConsoleColor

    hx.syscall hx.waitKeyboard

    jmp finish

;;************************************************************************************

finish:

    restoreConsole ;; Macro that restores console behavior and cleans up the console

    hx.syscall hx.exit

;;************************************************************************************

showBanner:

    hx.syscall hx.clearConsole

    setConsoleColor COLOR_DIVIDER, [Lib.Console.backgroundColor]

    fputs OOBE.divider

    setConsoleColor COLOR_LOGO, [Lib.Console.backgroundColor]

    fputs OOBE.banner

    setConsoleColor COLOR_DIVIDER, [Lib.Console.backgroundColor]

    fputs OOBE.divider

    restoreConsoleColor

    ret

;;************************************************************************************

showDivider:

    setConsoleColor COLOR_DIVIDER, [Lib.Console.backgroundColor]

    putNewLine
    putNewLine

    fputs OOBE.divider

    restoreConsoleColor

    ret