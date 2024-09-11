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

align 32

mainInterfaceData:

.intro:
db "Welcome to Config! Here you can get more information about Hexagonix or change system settings.", 0
.intro2:
db "To get started, select one of the options below:", 0
.category1:
db "[1] Change general system settings.", 0
.category2:
db "[2] View more information about this version of Hexagonix.", 0

;;************************************************************************************

generalData:

.resolutionWarning:
db "It is recommended to use this application in 1024x768 resolution for better use of the screen.", 0
.msgError:
db "Error performing the requested operation.", 0
.msgVersion:
db "You are using a version of Hexagonix that does not support this feature.", 0
.dot:
db ".", 0
.logo:
db "  88                                                                                88", 10
db "  88                                                                                ''", 10
db "  88", 10
db "  88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8", 10
db "  88P'    '88 a8P     88  `P8, ,8P'  ''     `P8 a8'    `P88 a8'     '8a 88P'   `'88 88  `P8, ,8P'", 10
db "  88       88 8PP'''''''    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(", 10
db "  88       88 '8b,   ,aa  ,d8' '8b,  88,    ,88 '8a,   ,d88 '8a,   ,a8' 88       88 88  ,d8' '8b,", 10
db "  88       88  `'Pbbd8'' 8P'     `P8 `'8bbdP'P8  `'PbbdP'P8  `'PbbdP''  88       88 88 8P'     `P8", 10
db "                                                 aa,    ,88", 10
db "                                                  'P8bbdP'", 0
.flatLogo:
db "88", 10
db "88", 10
db "88", 10
db "88,dPPPba,", 10
db "88P'    '88", 10
db "88       88", 10
db "88       88", 10
db "88       88", 0

;;************************************************************************************

infoInterfaceData:

.intro:
db "Detailed Information of the Hexagonix Operating System", 0
.systemName:
db "Installed Operating System name: ", 0
.systemVersion:
db "Operating System version: ", 0
.systemBuild:
db "Operating System build: ", 0
.systemType:
db "Operating System type:", 0
.systemModel:
db " 32-bit", 10, 0
.updatePackage:
db "Update package installed: ", 0
.copyright:
db "Copyright (C) 2015-", __stringYear, " Felipe Miguel Nery Lunkes", 0
.trademark:
db "All rights reserved.", 0
.hardwareIntro:
db "Hardware information for this device", 0
.mainProcessor:
db "Installed processor (considering only the main processor):", 0
.processorNumber:
db "1) ", 0
.processorOperationMode:
db "Processor in 32-bit protected mode", 0
.availableMemory:
db "Total installed memory available: ", 0
.kbytes:
db " megabytes.", 0
.Hexagon:
db "Hexagon (kernel) version: ", 0
.dot:
db ".", 0
.withoutCPUID:
db "The processor does not support the CPUID instruction and cannot be identified.", 0
.license:
db "Licensed under BSD-3-Clause", 0

;;************************************************************************************

configInterfaceData:

.intro:
db "Here you can change some settings of Hexagonix", 0
.intro2:
db "To get started, select any category listed below:", 0
.category1:
db "[1] Change the resolution used by the current monitor.", 0
.category2:
db "[2] Change the default console color scheme.", 0
.category3:
db "[3] Check disks and storage.", 0
.category4:
db "[4] View and test serial ports.", 0
.category5:
db "[5] View parallel port and printer.", 0
.category6:
db "[6] Change the default system font.", 0

;;************************************************************************************

resolutionInterfaceData:

.intro:
db "Here you can change the resolution of the computer video, among", 0
.intro2:
db "the available options.", 0
.insert:
db "Choose from one of the options below, inserting the number:", 0
.option1:
db "[1] Resolution of 800x600 pixels", 0
.option2:
db "[2] Resolution of 1024x768 pixels", 0
.mode1:
db "Current resolution: 800x600 pixels", 0
.mode2:
db "Current resolution: 1024x768 pixels", 0
.resolutionChanged:
db "The resolution has recently changed.", 0
.changed:
db "The resolution has been changed. If you don't like it, go back to the previous resolution.", 0

;;************************************************************************************

themeInterfaceData:

.intro:
db "Here you can set the default Hexagonix console color scheme.", 0
.insert:
db "Choose from one of the options below, inserting the number:", 0
.option1:
db "[1] Dark mode", 0
.option2:
db "[2] Light mode", 0

;;************************************************************************************

volumesInterfaceData:

.intro:
db "Here you can track information about your computer's storage and disks", 0
.intro2:
db "available for use.", 0
.currentVolume:
db "Current disk mounted at [/] used by system: ", 0
.volumeLabel:
db "Label of the volume mounted at [/] used by the system: ", 0

;;************************************************************************************

fontInterfaceData:

.intro:
db "Here you can change the default system display font. Remembering that the font", 0
.intro2:
db "must be compatible with the Hexagonix Operating System", 0
.requestFile:
db "Please enter the name of the Hexagonix font file ([ENTER] to cancel): ", 0
.success:
db "Successfully changing system default font to: [", 0
.closure:
db "]", 0
.testIntro:
db 10, 10, "Font and character layout preview: ", 0
.fileNotFound:
db "The requested file was not found on this volume.", 0
.withoutFile:
db "A filename was not provided. The operation was cancelled.", 0
.dot:
db ".", 10, 10, 0
.fontTest:
db "Hexagonix Operating System", 10, 10
db "1234567890-=", 10
db "!@#$%^&*()_+", 10
db "QWERTYUIOP{}", 10
db "qwertyuiop[]", 10
db 'ASDFGHJKL:"|', 10
db "asdfghjkl;'\", 10
db "ZXCVBNM<>?", 10
db "zxcvbnm,./", 10, 10
db "Hexagonix Operating System", 10, 10, 0
.invalidFile:
db "The requested file is not compatible with Hexagonix.", 0
.unknownError:
db "An unknown error has occurred.", 0

;;************************************************************************************

systemName:
db "Hexagonix", 0
systemFullName:
db "Hexagonix Operating System", 0

;;************************************************************************************

parallelInterfaceData:

.intro:
db "Here you can configure and view the parallel port (printer) settings", 0
.intro2:
db "in use on this computer.", 0
.impressoraPadrao:
db "Default printer on this computer: ", 0

;;************************************************************************************

serialInterfaceData:

.intro:
db "Here you can view and perform actions with the serial port.", 0
.intro2: db 0
.defaultPort:
db "Standard serial port for this computer: ", 0
.options:
db "You can request an automatic port test or you can send a message.", 0
.options2:
db "To do so, select [D] for an automatic test and [E] for a manual submission.", 0
.options3:
db "If you do not wish to carry out these operations, simply return to the previous menu.", 0
.msgSending:
db "Performing data sending test via serial port... ", 0
.sent:
db " [Sent]", 0
.sendError:
db "Error sending to serial port.", 0
.openError:
db "Error opening device for writing.", 0
.automaticMessage:
db "This is an automated message from the Hexagonix Operating System Control Panel! ", 10, 0
.insertMessage:
db "Enter your message to ", 0
.colon:
db ": ", 0
.leftBracket:
db "[", 0
.rightBracket:
db "]",0

;;************************************************************************************

TITLE:

.main:
db "Hexagonix Settings", 0
.info:
db "About the Hexagonix Operating System and system updates", 0
.config:
db "Hexagonix Settings", 0
.resolution:
db "Video resolution settings", 0
.volumes:
db "Hexagonix disk and storage information", 0
.font:
db "Change the default system display font", 0
.parallelPort:
db "Configure parallel ports (printers)", 0
.serialPort:
db "Serial port settings and diagnostics", 0
.theme:
db "Set console color scheme", 0

;;************************************************************************************

FOOTER:

.main:
db "[Version ", VERSION, "] | [X] Exit", 0
.info:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.config:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.resolution:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.volumes:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.font:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.parallelPort:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.serialPort:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
.theme:
db "[Version ", VERSION, "] | [B] Back, [X] Exit", 0
