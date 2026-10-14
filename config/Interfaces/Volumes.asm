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

showVolumeInterface:

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs TITLE.volumes

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.volumes

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    call showResolutionWarning

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 02, volumesInterfaceData.intro

.infoVolumes:

match =YES, VERBOSE
{

    systemLog Log.Config.logDiscos, 00h, Log.Priorities.p4

}

    xyfputs 04, 06, volumesInterfaceData.columnMountPoint
    xyfputs 22, 06, volumesInterfaceData.columnDevice
    xyfputs 44, 06, volumesInterfaceData.columnLabel
    xyfputs 58, 06, volumesInterfaceData.columnType

    mov ebx, volumesInterfaceData.mountsBufferSize

    call malloc

    cmp eax, 0
    je .mallocError

    mov dword[volumesInterfaceData.mountsBuffer], ebx
    mov esi, ebx

    hx.syscall hx.getMounts

    mov dword[volumesInterfaceData.mountsCount], eax
    mov eax, dword[volumesInterfaceData.mountsBuffer]
    mov dword[volumesInterfaceData.mountsPointer], eax
    mov byte[volumesInterfaceData.mountsRow], 07

.mountsLoop:

    cmp dword[volumesInterfaceData.mountsCount], 0
    je .mountsDone

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov dl, 04
    mov dh, byte[volumesInterfaceData.mountsRow]

    hx.syscall hx.setCursor

    mov esi, dword[volumesInterfaceData.mountsPointer] ;; Mount point path, offset 0

    printString

    mov dl, 22
    mov dh, byte[volumesInterfaceData.mountsRow]

    hx.syscall hx.setCursor

    mov esi, dword[volumesInterfaceData.mountsPointer]

    add esi, hx.mount.record.deviceName

    printString

    mov dl, 44
    mov dh, byte[volumesInterfaceData.mountsRow]

    hx.syscall hx.setCursor

    mov esi, dword[volumesInterfaceData.mountsPointer]

    add esi, hx.mount.record.volumeLabel

    printString

    mov dl, 58
    mov dh, byte[volumesInterfaceData.mountsRow]

    hx.syscall hx.setCursor

    mov esi, dword[volumesInterfaceData.mountsPointer]
    movzx eax, byte[esi + hx.mount.record.filesystemType]

    call printFilesystemType

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov eax, dword[volumesInterfaceData.mountsPointer]

    add eax, hx.mount.record.size

    mov dword[volumesInterfaceData.mountsPointer], eax

    inc byte[volumesInterfaceData.mountsRow]
    dec dword[volumesInterfaceData.mountsCount]

    jmp .mountsLoop

.mountsDone:

    mov ebx, dword[volumesInterfaceData.mountsBuffer]
    mov ecx, volumesInterfaceData.mountsBufferSize

    call free

    jmp .getKeys

.mallocError:

    xyfputs 04, 07, volumesInterfaceData.mallocError

.getKeys:

    hx.syscall hx.waitKeyboard

    cmp al, 'b'
    je showConfigInterface

    cmp al, 'B'
    je showConfigInterface

    cmp al, 'x'
    je finishApplication

    cmp al, 'X'
    je finishApplication

    jmp .getKeys

;;************************************************************************************

;; Prints the filesystem name for a mount record's type code at the current
;; cursor position
;;
;; Input:
;;
;; AL - Filesystem type code

printFilesystemType:

    cmp al, 01h
    je .fat12

    cmp al, 04h
    je .fat16_32

    cmp al, 06h
    je .fat16

    cmp al, 0FFh ;; Hexagon.VFS.FS.DEVFS
    je .devfs

    fputs volumesInterfaceData.unknownFilesystem

    ret

.fat12:

    fputs volumesInterfaceData.fat12

    ret

.fat16_32:

    fputs volumesInterfaceData.fat16_32

    ret

.fat16:

    fputs volumesInterfaceData.fat16

    ret

.devfs:

    fputs volumesInterfaceData.devfs

    ret
