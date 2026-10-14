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

showResolutionInterface:

    hx.syscall hx.clearConsole

;; Display program title and footer

    mov eax, BRANCO_ANDROMEDA
    mov ebx, interfaceDefaultColor

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs TITLE.resolution

    mov al, byte[maxRows] ;; Last row

    dec al

    hx.syscall hx.clearLine

    fputs FOOTER.resolution

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    call showResolutionWarning

    call showResolution

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    xyfputs 02, 02, resolutionInterfaceData.intro
    xyfputs 02, 03, resolutionInterfaceData.intro2
    xyfputs 02, 06, resolutionInterfaceData.insert
    xyfputs 04, 08, resolutionInterfaceData.option1
    xyfputs 04, 09, resolutionInterfaceData.option2

    mov ah, byte[changed]

    cmp byte ah, 1
    je .hasChanged

    cmp byte ah, 2
    je .writeFailed

    cmp byte ah, 3
    je .denied

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

    cmp al, '1'
    je graphicMode1

    cmp al, '2'
    je graphicMode2

    jmp .getKeys

.hasChanged:

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov dh, 15
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.resolutionChanged

    mov dh, 17
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.restartRequired

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp .getKeys

.writeFailed:

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov dh, 15
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.writeError

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp .getKeys

.denied:

    mov eax, interfaceDefaultColor
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    mov dh, 15
    mov dl, 02

    hx.syscall hx.setCursor

    fputs resolutionInterfaceData.permissionDenied

    mov eax, dword[fontColor]
    mov ebx, dword[backgroundColor]

    hx.syscall hx.setColor

    jmp .getKeys

graphicMode1:

match =YES, VERBOSE
{

    systemLog Log.Config.logTrocarResolucao800x600, 00h, Log.Priorities.p4

}

    mov esi, bootCfgData.value1

    call writeBootCfg

    jmp showResolutionInterface

graphicMode2:

match =YES, VERBOSE
{

    systemLog Log.Config.logTrocarResolucao1024x768, 00h, Log.Priorities.p4

}

    mov esi, bootCfgData.value2

    call writeBootCfg

    jmp showResolutionInterface

;;************************************************************************************

;; Loads boot/boot.cfg, replaces only the value on its "resolution=" line and
;; writes the file back, so any other content in it is preserved. HBoot reads
;; the file before the kernel starts and sets the mode itself, so nothing here
;; touches the console already running. Changing the boot configuration needs
;; administrative privileges, the same rule shutdown uses, and boot.cfg is also
;; permission-protected on disk
;;
;; Input:
;;
;; ESI - Pointer to the new resolution value (value only, null-terminated)

writeBootCfg:

    mov dword[bootCfgData.valuePtr], esi

;; Only root may change the boot configuration

    hx.syscall hx.getUser

    cmp eax, 0
    jne .denied

    mov esi, bootCfgData.file

    hx.syscall hx.stat

    jc .writeError ;; No file to edit

    mov dword[bootCfgData.readSize], eax
    mov esi, bootCfgData.file
    mov edi, bootCfgData.readBuffer

    hx.syscall hx.open

    jc .writeError

    call replaceResolutionLine

;; hx.create's own overwrite behavior is never relied on, the same reason
;; adduser removes its file before recreating it

    mov esi, bootCfgData.file

    hx.syscall hx.unlink

    mov eax, dword[bootCfgData.writeSize]
    mov esi, bootCfgData.file
    mov edi, bootCfgData.writeBuffer

    hx.syscall hx.create

    jc .writeError

    mov byte[changed], 1

    ret

.denied:

    mov byte[changed], 3

    ret

.writeError:

    mov byte[changed], 2

    ret

;;************************************************************************************

;; Builds writeBuffer from readBuffer, replacing only the value that follows
;; the first "resolution=" at the start of a line. A commented line is never
;; matched, since the scan only tests the beginning of each line. If no such
;; line exists, one is appended at the end
;;
;; Input:
;;
;; readBuffer holds readSize bytes, bootCfgData.valuePtr points to the value
;;
;; Output:
;;
;; writeBuffer holds the new content, writeSize is set

replaceResolutionLine:

    mov esi, bootCfgData.readBuffer

.findLine:

    mov eax, bootCfgData.readBuffer
    add eax, dword[bootCfgData.readSize]

    cmp esi, eax
    jae .notFound

    mov edi, bootCfgData.key

    call matchPrefix

    jc .found

;; Not this line, skip past its newline and try the next one

.skipLine:

    mov eax, bootCfgData.readBuffer
    add eax, dword[bootCfgData.readSize]

    cmp esi, eax
    jae .notFound

    mov al, byte[esi]

    inc esi

    cmp al, 10
    jne .skipLine

    jmp .findLine

.found:

    add esi, 11 ;; Past "resolution="

    mov dword[bootCfgData.valueStart], esi

;; Find the end of the value, either the line's newline or the buffer's end

.findEOL:

    mov eax, bootCfgData.readBuffer

    add eax, dword[bootCfgData.readSize]

    cmp esi, eax
    jae .eol

    mov al, byte[esi]

    cmp al, 10
    je .eol

    inc esi

    jmp .findEOL

.eol:

    mov dword[bootCfgData.lineEnd], esi
    mov edi, bootCfgData.writeBuffer

;; Prefix, everything up to and including "resolution="

    mov esi, bootCfgData.readBuffer
    mov ecx, dword[bootCfgData.valueStart]

    sub ecx, esi

    call copyBytes

;; The new value

    mov esi, dword[bootCfgData.valuePtr]

    call appendString

;; Suffix, from the old value's line end to the end of the file

    mov esi, dword[bootCfgData.lineEnd]
    mov ecx, bootCfgData.readBuffer

    add ecx, dword[bootCfgData.readSize]
    sub ecx, esi

    call copyBytes

    mov eax, edi

    sub eax, bootCfgData.writeBuffer

    mov dword[bootCfgData.writeSize], eax

    ret

.notFound:

;; No resolution line at all, keep the file and append one

    mov edi, bootCfgData.writeBuffer
    mov esi, bootCfgData.readBuffer
    mov ecx, dword[bootCfgData.readSize]

    call copyBytes

    mov eax, dword[bootCfgData.readSize]

    test eax, eax
    jz .appendKey

    mov esi, bootCfgData.readBuffer

    add esi, eax
    dec esi

    cmp byte[esi], 10
    je .appendKey

    mov byte[edi], 10

    inc edi

.appendKey:

    mov esi, bootCfgData.key

    call appendString

    mov esi, dword[bootCfgData.valuePtr]

    call appendString

    mov byte[edi], 10

    inc edi

    mov eax, edi

    sub eax, bootCfgData.writeBuffer

    mov dword[bootCfgData.writeSize], eax

    ret

;;************************************************************************************

;; Tests whether the text at ESI begins with the null-terminated key at EDI,
;; without disturbing either pointer
;;
;; Output:
;;
;; CF - Set when the text starts with the whole key

matchPrefix:

    push esi
    push edi
    push eax
    push ebx

.compare:

    mov bl, byte[edi]

    test bl, bl
    jz .match ;; Key ended, the whole prefix matched

    mov al, byte[esi]

    cmp al, bl
    jne .noMatch

    inc esi
    inc edi

    jmp .compare

.match:

    stc

    jmp .end

.noMatch:

    clc

.end:

    pop ebx
    pop eax
    pop edi
    pop esi

    ret

;;************************************************************************************

;; Copies ECX bytes from ESI to EDI, advancing both
;;
;; Input:
;;
;; ESI - Source, EDI - destination, ECX - byte count

copyBytes:

    push eax

.copy:

    test ecx, ecx
    jz .done

    mov al, byte[esi]
    mov byte[edi], al

    inc esi
    inc edi
    dec ecx

    jmp .copy

.done:

    pop eax

    ret

;;************************************************************************************

;; Copies the null-terminated string at ESI into EDI, stopping before the
;; terminator and leaving EDI on the next free byte
;;
;; Input:
;;
;; ESI - Source, EDI - destination
;;
;; Output:
;;
;; EDI - The next free destination byte

appendString:

    push eax

.copy:

    mov al, byte[esi]

    test al, al
    jz .done

    mov byte[edi], al

    inc esi
    inc edi

    jmp .copy

.done:

    pop eax

    ret

;;************************************************************************************

showResolution:

    mov dh, 13
    mov dl, 02

    hx.syscall hx.setCursor

    hx.syscall hx.getResolution

    cmp eax, 1
    je .graphicMode1

    cmp eax, 2
    je .graphicMode2

    ret

.graphicMode1:

    fputs resolutionInterfaceData.mode1

    ret

.graphicMode2:

    fputs resolutionInterfaceData.mode2

   ret

;;************************************************************************************

;; 0 nothing written yet, 1 boot.cfg updated, 2 the write failed, 3 not root

changed: dd 0

bootCfgData:

.file: db "/boot/boot.cfg", 0
.key:  db "resolution=", 0

;; Only the value, the "resolution=" part is already in the file

.value1: db "800x600x32", 0
.value2: db "1024x768x32", 0

.valuePtr:   dd 0 ;; The value chosen for this change
.readSize:   dd 0 ;; Bytes of the current file on disk
.writeSize:  dd 0 ;; Bytes of the edited content to write back
.valueStart: dd 0 ;; Where the old value begins, right after "resolution="
.lineEnd:    dd 0 ;; Where the old value's line ends

.readBuffer:
times 1024 db 0
.writeBuffer:
times 1024 db 0
