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

tamanhoParaNomeArquivo = 8

;; Variables, constants and structures

VERSION   equ "2.3.1"
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
.withoutSorceCode:
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

    cmp byte[edi], 0 ;; Em caso de falta de argumentos
    je .criarNovoArquivo

    mov esi, edi ;; Argumentos do programa

    hx.syscall hx.stringSize

    cmp eax, 12 ;; Nome de arquivo inválido
    ja .criarNovoArquivo

.salvarNomeArquivo: ;; Salvar nome do arquivo

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov edi, filename
    mov ecx, eax ;; Caracteres no nome do arquivo

    inc ecx ;; Incluindo o caractere NULL

    rep movsb

    pop es

.carregarArquivo: ;; Open arquivo

    mov esi, filename

    hx.syscall hx.fileExists

    jc .criarNovoArquivo ;; O arquivo não existe

    mov esi, filename

    mov edi, appFileBuffer ;; Endereço para o carregamento

    hx.syscall hx.open

    mov esi, filename

    hx.syscall hx.stringSize

    mov ecx, eax

.configurarRodape: ;; Adicionar nome do arquivo no título do programa

    push es

;; Vamos configurar DS e ES com o segmento de dados do modo usuário

    push ds
    pop es

;; Agora o nome do arquivo aberto será exibido na interface do aplicativo

    mov edi, Lyoko.fileIdentifier+tamanhoParaNomeArquivo ;; Posição
    mov esi, filename

    rep movsb

    pop es

    jmp .iniciarInterface

.criarNovoArquivo:

    mov byte[filename], 0

;; Adicionar 'New file', ao título do programa

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov ecx, 12

    mov esi, Lyoko.newFileTitle
    mov edi, Lyoko.fileIdentifier+tamanhoParaNomeArquivo ;; Posição

    rep movsb

    pop es

.iniciarInterface:

    mov al, 10 ;; Caractere de nova line

    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

    mov dword[currentLinePosition], 0

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha ;; Encontrar tamanho da line atual

    mov byte[currentPositionInLine], dl ;; Cursor no final da line
    mov byte[currentLineSize], dl   ;; Salvar tamanho da line atual

    mov dword[currentPagePosition], 0

.aguardarInteragirPrincipal:

    cmp byte[screenRefreshIsRequired], 00h
    je .outrasLinhasImpressas ;; Não é necessário imprimir outras linhas

;; Imprimir outras linhas

    mov esi, Hexagon.LibASM.Dev.video.tty1

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    mov eax, dword[totalLines]

    cmp dword[line], eax
    je .outrasLinhasImpressas

.imprimirOutrasLinhas:

    mov esi, appFileBuffer

    add esi, dword[currentPagePosition]

    putNewLine

    movzx ecx, byte[maxLines]

    sub ecx, 2

.imprimirOutrasLinhasLoop:

    call imprimirLinha

    jc .imprimirTitulo

    putNewLine

    loop .imprimirOutrasLinhasLoop

.imprimirTitulo:

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs Lyoko.applicationTitle

    mov al, byte[maxLines] ;; Última line

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

;; Atualizar tela

.atualizarBuffer:

    hx.syscall hx.updateScreen

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

.outrasLinhasImpressas:

    mov byte[screenRefreshIsRequired], 0

    mov dl, 0
    mov dh, byte[linePositionOnScreen]

    hx.syscall hx.setCursor

;; Imprimir line atual

    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call imprimirLinha

    mov al, ' '

    hx.syscall hx.printCharacter

;; Imprimir line e coluna atuais

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

    inc eax ;; Contando de 1

    printInteger

    fputs Lyoko.comma

    fputs Lyoko.column

    movzx eax, byte[currentPositionInLine]

    inc eax ;; Contando de 1

    printInteger

    mov al, ' '

    hx.syscall hx.printCharacter

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    cmp byte[Lyoko.firstExecution], 01h
    jne .iniciarProcessamentoEntrada

    call exibirBoasVindas

    jmp .aguardarInteragirPrincipal

.iniciarProcessamentoEntrada:

;; Colocar cursor na posição atual na line

    mov dl, byte[currentPositionInLine]
    mov dh, byte[linePositionOnScreen]

    hx.syscall hx.setCursor

.processarEntrada:

    call processarEntrada

    cmp byte[returnOrigin], 01h
    je .iniciarProcessamentoEntrada

    jmp .aguardarInteragirPrincipal

;;*************************************************************************************************

salvarArquivoEditor:

    cmp byte[filename], 0
    jne .naoNovoArquivo

;; Obter nome de arquivo

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

    mov eax, 12 ;; Máximo de caracteres

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .fim

;; Salvar nome de arquivo

    push es

;; Vamos configurar DS e ES com o segmento de dados do modo usuário

    push ds
    pop es

    mov edi, filename
    mov ecx, eax ;; Caracteres no nome de arquivo

    inc ecx ;; Incluindo NULL

    rep movsb

;; Adicionar ao rodapé

    mov ecx, eax ;; Caracteres do nome do arquivo

    inc ecx

    mov esi, filename
    mov edi, Lyoko.fileIdentifier+tamanhoParaNomeArquivo

    rep movsb

    pop es

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    jmp .continuar

.naoNovoArquivo:

;; Se o arquivo já existe, delete-o

    mov esi, filename

    hx.syscall hx.unlink

    jc .unlinkError

.continuar:

;; Encontrar tamanho do arquivo

    mov esi, appFileBuffer

    hx.syscall hx.stringSize

;; Salvar arquivo

    mov esi, filename
    mov edi, appFileBuffer

    hx.syscall hx.create

;; Exibir mensagem de salvamento

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

    mov byte [Lyoko.changed], 0 ;; Limpar o status de alterado

.fim:

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

    jmp .fim

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

    jmp .fim

;;*************************************************************************************************

abrirArquivoEditor:

;; Obter nome de arquivo

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

    mov eax, 12 ;; Máximo de caracteres

    hx.syscall hx.getString

    hx.syscall hx.stringSize

    cmp eax, 0
    je .fim

;; Salvar nome de arquivo

    push es

;; Vamos configurar DS e ES com o segmento de dados do modo usuário

    push ds
    pop es

    mov edi, filename
    mov ecx, eax ;; Caracteres no nome de arquivo

    inc ecx ;; Incluindo NULL

    rep movsb

;; Adicionar ao rodapé

    mov ecx, eax ;; Caracteres do nome do arquivo

    inc ecx

    mov esi, filename
    mov edi, Lyoko.fileIdentifier+tamanhoParaNomeArquivo

    rep movsb

    pop es

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    call reiniciarBufferVideo

    call reiniciarBufferTexto

    mov byte[screenRefreshIsRequired], 1


    jmp LyokoIDE.carregarArquivo

.fim:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;************************************************************************************

evidenciarEdicao:

    push es

;; Vamos configurar DS e ES com o segmento de dados do modo usuário

    push ds
    pop es

    mov edi, Lyoko.edited
    mov ecx, eax ;; Caracteres no nome de arquivo

    inc ecx ;; Incluindo NULL

    rep movsb

;; Adicionar ao rodapé

    mov ecx, eax ;; Caracteres do nome do arquivo

    inc ecx

    mov esi, Lyoko.edited
    mov edi, Lyoko.fileIdentifier+tamanhoParaNomeArquivo+8

    rep movsb

    pop es

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

realizarMontagem:

    call montarAviso

    fputs Lyoko.runningAssembler

    mov esi, filename

    cmp byte[esi], 0
    je .withoutSorceCode

    mov esi, Lyoko.fasmX
    mov edi, filename

    hx.syscall hx.exec

    jmp .fim

.withoutSorceCode:

    fputs Lyoko.withoutSorceCode

.fim:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

exibirAjuda:

    mov byte[Lyoko.biggerBox], 01h

    call montarAviso

    fputs Lyoko.quickWarning

.fim:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

exibirInfo:

    mov byte[Lyoko.biggerBox], 01h

    call montarAviso

    fputs Lyoko.infoLyoko

.fim:

    fputs Lyoko.closeWarning

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    mov byte[screenRefreshIsRequired], 1

    ret

;;*************************************************************************************************

exibirBoasVindas:

    call montarAviso

    fputs Lyoko.welcome

.fim:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.waitKeyboard

    mov byte[screenRefreshIsRequired], 01h

    mov byte[Lyoko.firstExecution], 00h

    ret

;;*************************************************************************************************

montarAviso:

    cmp byte[Lyoko.biggerBox], 01h
    je .checarResolucaoCaixaMaior

.checarResolucaoCaixaMenor:

    cmp dword[resolution], 01h
    je .caixaMenorResolucao1

    cmp dword[resolution], 02h
    je .caixaMenorResolucao2

    jmp .fim

.checarResolucaoCaixaMaior:

    cmp dword[resolution], 01h
    je .caixaMaiorResolucao1

    cmp dword[resolution], 02h
    je .caixaMaiorResolucao2

    jmp .fim

.caixaMenorResolucao1:

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 350 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 200 ;; Altura do bloco
    mov edx, HIGHLIGHT_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 340 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 550 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 22

    hx.syscall hx.setCursor

    jmp .fim

.caixaMenorResolucao2:

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 470  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 250  ;; Altura do bloco
    mov edx, HIGHLIGHT_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 460  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 710  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 30

    hx.syscall hx.setCursor

    jmp .fim

.caixaMaiorResolucao1:

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 200 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 360 ;; Altura do bloco
    mov edx, HIGHLIGHT_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 190 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 550 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 14

    hx.syscall hx.setCursor

    jmp .fim

.caixaMaiorResolucao2:

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 200  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 510  ;; Altura do bloco
    mov edx, HIGHLIGHT_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 190  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 710  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, BANNER_COLOR ;; Cor do bloco

    hx.syscall hx.drawBlock

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HIGHLIGHT_COLOR

    hx.syscall hx.setColor

    mov dl, 0h
    mov dh, 14

    hx.syscall hx.setCursor

    jmp .fim

.fim:

    mov byte[Lyoko.biggerBox], 00h

    ret

;;*************************************************************************************************

processarEntrada:

    hx.syscall hx.waitKeyboard

;; Vamos checar se a tecla CTRL está pressionada e tomar as devidas providências

    push eax

    hx.syscall hx.getKeyState

    bt eax, 0
    jc .teclasControl

    pop eax

;; Vamos agora interpretar os scan codes do teclado

    cmp ah, 28
    je .teclasReturn

    cmp ah, 15 ;; Tab
    je .caractereImprimivel

    cmp ah, 71
    je .teclaHome

    cmp ah, 79
    je .teclaEnd

    cmp ah, 14
    je .teclaBackspace

    cmp ah, 83
    je .teclaDelete

    cmp ah, 75
    je .teclaEsquerda

    cmp ah, 77
    je .teclaDireita

    cmp ah, 72
    je .teclaCima

    cmp ah, 80
    je .teclaBaixo

    cmp ah, 81
    je .teclaPageDown

    cmp ah, 73
    je .teclaPageUp

;; Se o caractere não foi imprimível

    cmp al, ' '
    jl .prepararRetorno

    cmp al, '~'
    ja .prepararRetorno

;; Outra tecla

.caractereImprimivel:

;; Não são suportados mais de 79 caracteres por line

    mov byte [Lyoko.changed], 1

    mov bl, byte[maxColumns]

    dec bl

    cmp byte[currentLineSize], bl
    jae .prepararRetorno

    mov edx, 0
    movzx esi, byte[currentPositionInLine] ;; Posição para inserir caracteres

    add esi, dword[currentLinePosition]
    add esi, appFileBuffer

    hx.syscall hx.insertCharacter ;; Inserir char na string

    inc byte[currentPositionInLine] ;; Um caractere foi adicionado
    inc byte[currentLineSize]

;; Mais teclas

    jmp .prepararRetorno

;; Tecla Return ou Enter

.teclasReturn:

    mov byte[screenRefreshIsRequired], 1

    mov edx, 0

    movzx esi, byte[currentPositionInLine]

    add esi, appFileBuffer
    add esi, dword[currentLinePosition]

    mov al, 10

    hx.syscall hx.insertCharacter

;; Nova line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para essa line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha ;; Encontrar tamanho para essa line

    mov byte[currentPositionInLine], 0 ;; Cursor no fim da line
    mov byte[currentLineSize], dl  ;; Salvar o tamanho atual da line

    mov al, 10 ;; Caractere de nova line
    mov esi, appFileBuffer

    hx.syscall hx.findCharacter

    mov dword[totalLines], eax

;; Tentar mover o cursor para baixo

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jb .teclasReturn.cursorProximaLinha

;; Se for última line, rode a tela

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[linePositionOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    jmp .prepararRetorno

.teclasReturn.cursorProximaLinha:

    inc byte[linePositionOnScreen]

    jmp .prepararRetorno

;; Teclas Control

.teclasControl:

    pop eax

    cmp al, 's'
    je .teclaControlS

    cmp al, 'S'
    je .teclaControlS

    cmp al, 'x'
    je .teclaControlX

    cmp al, 'X'
    je .teclaControlX

    cmp al, 'a'
    je .teclaControlA

    cmp al, 'A'
    je .teclaControlA

    cmp al, 'v'
    je .teclaControlV

    cmp al, 'V'
    je .teclaControlV

    cmp al, 'm'
    je .teclaControlM

    cmp al, 'M'
    je .teclaControlM

    cmp al, 'f'
    je fimPrograma

    cmp al, 'F'
    je fimPrograma

    jmp .prepararRetorno

.teclaBackspace:

;; Se na primeira coluna, não fazer nada

    cmp byte[currentPositionInLine], 0
    je .teclaBackspace.primeiraColuna

;; Remover caractere da esquerda

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[currentPositionInLine] ;; Um caractere foi removido
    dec byte[currentLineSize]

    jmp .prepararRetorno

.teclaBackspace.primeiraColuna:

    cmp byte[line], 0
    je .prepararRetorno

;; Calcular tamanho anterior da line

    mov esi, appFileBuffer
    mov eax, dword[line]

    dec eax ;; Linha anterior

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov edx, 0

    add esi, appFileBuffer

    call tamanhoLinha ;; Encontrar tamanho

    push edx ;; Salvar tamanho da line

    add dl, byte[currentLineSize]

;; Backspace não habilitado (suporte de até 79 caracteres por line)

    mov bl, byte[maxColumns]

    dec bl

    cmp dl, bl ;; Contando de 0
    jnae .continuar

    pop edx

    ret

.continuar:

;; Remover caractere de nova line

    mov byte[screenRefreshIsRequired], 1

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    dec eax

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[totalLines] ;; Uma line foi removida
    dec dword[line]

;; Linha anterior

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .retornoPush

    sub esi, appFileBuffer

    push esi

;; Calcular valores para essa line

    mov edx, 0

    pop esi

    push esi

    add esi, appFileBuffer

    call tamanhoLinha ;; Encontrar tamanho da line atual

    mov byte[currentLineSize], dl ;; Salvar tamanho da line

    pop dword[currentLinePosition]

    pop edx

    mov byte[currentPositionInLine], dl

    jmp .teclaCima.cursorMovido

.retornoPush:

    pop edx

    ret

.teclaDelete:

;; Se na última coluna, não fazer nada

    mov dl, byte[currentLineSize]

    cmp byte[currentPositionInLine], dl
    jae .prepararRetorno

    movzx eax, byte[currentPositionInLine]

    add eax, dword[currentLinePosition]

    mov esi, appFileBuffer

    hx.syscall hx.removeCharacterString

    dec byte[currentLineSize] ;; Um caractere foi removido

    inc byte[currentPositionInLine]

.teclaEsquerda:

;; Se na primeira coluna, não fazer nada

    cmp byte[currentPositionInLine], 0
    jne .teclaEsquerda.moverEsquerda

    cmp byte[line], 0
    je .prepararRetorno

    mov bl, byte[maxColumns]
    mov byte[currentPositionInLine], bl

    jmp .teclaCima

;; Mover cursor para a esquerda

.teclaEsquerda.moverEsquerda:

    dec byte[currentPositionInLine]

    jmp .prepararRetorno

.teclaDireita:

;; Se na última coluna, não fazer nada

    mov dl, byte[currentLineSize]

    cmp byte[currentPositionInLine], dl
    jnae .teclaDireita.moverDireita

;; Nova line não permitida

    mov eax, dword[line]

    inc eax

    cmp dword[totalLines], eax
    je .prepararRetorno

;; Nova line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para essa line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentPositionInLine], 0 ;; Cursor no fim da line
    mov byte[currentLineSize], dl  ;; Salvar tamanho da line

    jmp .teclaBaixo.proximo

.teclaDireita.moverDireita:

    inc byte[currentPositionInLine]

    jmp .prepararRetorno

.teclaCima:

;; Linha anterior não permitida

    cmp dword[line], 0
    je .prepararRetorno

;; Linha anterior

    dec dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para essa line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentLineSize], dl

    cmp dl, byte[currentPositionInLine]
    jb .teclaCima.moverCursorAteOFim

    jmp .teclaCima.cursorMovido ;; Não alterar a coluna do cursor

.teclaCima.moverCursorAteOFim:

    mov byte[currentPositionInLine], dl ;; Cursor ao fim da line

.teclaCima.cursorMovido:

;; Tentar mover o cursor para cima

    cmp byte[linePositionOnScreen], 1
    ja .teclaCima.cursorLinhaAnterior

;; Se o cursor estiver na primeira line, role a tela para cima

    mov byte[linePositionOnScreen], 1
    mov eax, dword[currentLinePosition]
    mov dword[currentPagePosition], eax

    mov byte[screenRefreshIsRequired], 1

    jmp .prepararRetorno

.teclaCima.cursorLinhaAnterior:

    dec byte[linePositionOnScreen]

    jmp .prepararRetorno

.teclaBaixo:

;; Próxima line não disponível

    mov eax, dword[line]

    inc eax

    cmp dword[totalLines], eax
    je .prepararRetorno

;; Próxima line

    inc dword[line]

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para a line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentLineSize], dl

    cmp dl, byte[currentPositionInLine]
    jb .teclaBaixo.moverCursorAteOFim

    jmp .teclaBaixo.cursorMovido ;; Não alterar a coluna

.teclaBaixo.moverCursorAteOFim:

    mov byte[currentPositionInLine], dl ;; Cursor ao fim da line

.teclaBaixo.cursorMovido:

.teclaBaixo.proximo:

;; Tentar mover o cursor para baixo

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jb .teclaBaixo.cursorProximaLinha

;; Se na última line, girar tela para baixo

    mov bl, byte[maxLines]

    sub bl, 2

    mov byte[linePositionOnScreen], bl

    mov esi, appFileBuffer
    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    mov byte[screenRefreshIsRequired], 1

    jmp .prepararRetorno

.teclaBaixo.cursorProximaLinha:

    inc byte[linePositionOnScreen]

    jmp .prepararRetorno

.teclaHome:

;; Mover cursor para primeira coluna

    mov byte[currentPositionInLine], 0

    jmp .prepararRetorno

.teclaEnd:

;; Mover cursor para última coluna

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentPositionInLine], dl

    jmp .prepararRetorno

.teclaPageUp:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3
    sub eax, ebx

    cmp eax, 0
    jle .teclaPageUp.irParaPrimeiraLinha

;; Não redesenhar se na última line

    mov bl, byte[maxLines]

    sub bl, 2

    cmp byte[linePositionOnScreen], bl
    jae .teclaPageUp.naoNecessarioRedesenhar

    mov byte[screenRefreshIsRequired], 1

.teclaPageUp.naoNecessarioRedesenhar:

;; Linha anterior

    movzx ebx, byte[maxLines]

    sub bl, 3
    sub dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para essa line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentPositionInLine], dl ;; Cursor no fim da line
    mov byte[currentLineSize], dl

.teclaPageUp.fim:

    mov byte[linePositionOnScreen], 1
    mov eax, dword[currentLinePosition]
    mov dword[currentPagePosition], eax

    jmp .prepararRetorno

.teclaPageUp.irParaPrimeiraLinha:

;; Page Up não disponível

    cmp dword[line], 0
    je .prepararRetorno

    mov byte[screenRefreshIsRequired], 1

    mov esi, appFileBuffer
    mov eax, 0
    mov dword[line], eax

    call posicaoLinha

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para a line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentPositionInLine], dl ;; Cursor no fim da line
    mov byte[currentLineSize], dl

    jmp .teclaPageUp.fim

.teclaPageDown:

    mov eax, dword[line]
    movzx ebx, byte[maxLines]

    sub bl, 3

    add eax, ebx

    cmp eax, dword[totalLines]
    jae .teclaPageDown.irParaUltimaLinha

;; Não redesenhar se primeira line

    cmp byte[linePositionOnScreen], 1
    jle .teclaPageDown.naoNecessarioRedesenhar

    mov byte[screenRefreshIsRequired], 1

.teclaPageDown.naoNecessarioRedesenhar:

;; Próxima line

    movzx ebx, byte[maxLines]

    sub bl, 3

    add dword[line], ebx

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para a line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

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

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    jmp .prepararRetorno

.teclaPageDown.irParaUltimaLinha:

;; Page Down não disponível

    mov eax, dword[line]

    inc eax

    cmp eax, dword[totalLines]
    jae .prepararRetorno

    mov byte[screenRefreshIsRequired], 1

;; Próxima line

    mov eax, dword[totalLines] ;; Última line é o total de linhas - 1

    dec eax

    mov dword[line], eax ;; Fazer da última line a line atual

    mov esi, appFileBuffer
    mov eax, dword[line]

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentLinePosition], esi

;; Calcular valores para essa line

    mov edx, 0
    mov esi, appFileBuffer

    add esi, dword[currentLinePosition]

    call tamanhoLinha

    mov byte[currentPositionInLine], dl
    mov byte[currentLineSize], dl

    movzx ebx, byte[maxLines]

    sub ebx, 3

    cmp dword[totalLines], ebx ;; Checar por arquivos pequenos ou grandes
    jae .maisQueUmaPagina

;; Se arquivo pequeno

    mov ebx, dword[totalLines]

    dec ebx

;; Se arquivo grande

.maisQueUmaPagina:

    inc bl

    mov byte[linePositionOnScreen], bl

    mov eax, dword[line]

    sub eax, ebx

    inc eax

    mov esi, appFileBuffer

    call posicaoLinha

    jc .prepararRetorno

    sub esi, appFileBuffer

    mov dword[currentPagePosition], esi

    jmp .prepararRetorno

.teclaControlS:

    call salvarArquivoEditor

    jmp .prepararRetornoEspecial

.teclaControlX:

    call exibirAjuda

    jmp .prepararRetornoEspecial

.teclaControlV:

    call exibirInfo

    jmp .prepararRetornoEspecial

.teclaControlM:

    call realizarMontagem

    jmp .prepararRetornoEspecial

.teclaControlA:

    call abrirArquivoEditor

    jmp .prepararRetorno

.prepararRetorno:

    mov byte[returnOrigin], 00h

    ret

.prepararRetornoEspecial:

    hx.syscall hx.waitKeyboard

    mov byte[returnOrigin], 00h

    ret

;;*************************************************************************************************

fimPrograma:

    mov ah, byte[Lyoko.changed]

    cmp ah, 0
    je .terminar

    call montarAviso

    fputs Lyoko.saveWarning

.loopTeclas:

    hx.syscall hx.waitKeyboard

    cmp al, 's'
    je .iniciarSalvamento

    cmp al, 'S'
    je .iniciarSalvamento

    cmp al, 'n'
    je .terminar

    cmp al, 'N'
    je .terminar

jmp .loopTeclas

.iniciarSalvamento:

    call salvarArquivoEditor

.terminar:

    mov eax, dword[Lyoko.fontColor]
    mov ebx, dword[Lyoko.backgroundColor]

    hx.syscall hx.setColor

    hx.syscall hx.scrollConsole

    mov ebx, 00h

    hx.syscall hx.exit

;;*************************************************************************************************

;;*************************************************************************************************
;;
;; Demais funções do aplicativo
;;
;;*************************************************************************************************

;; Imprimir uma line da String
;;
;; Entrada:
;;
;; ESI - Endereço do buffer
;;
;; Saída:
;;
;; ESI - Próximo buffer
;; Carry definido no fim do arquivo

imprimirLinha:

    mov edx, 0 ;; Contador de caracteres

.loopImprimir:

    lodsb

    cmp al, 10 ;; Fim da line
    je .fim

    cmp al, 0 ;; Fim da String
    je .fimArquivo

    movzx ebx, byte[maxColumns]
    dec bl

    cmp edx, ebx
    jae .tamanhoMaximoLinha

    pushad

    mov ebx, 01h

    hx.syscall hx.printCharacter ;; Imprimir caractere em AL

    popad

    inc edx

    jmp .loopImprimir ;; Mais caracteres

.tamanhoMaximoLinha:

    jmp .loopImprimir

.fimArquivo:

    stc

.fim:

    ret

;;*************************************************************************************************

;; Encontrar tamanho da line
;;
;; Entrada:
;;
;; ESI - Endereço do buffer
;;
;; Saída:
;;
;; ESI - Próximo buffer
;; EDX - += tamanho da line

tamanhoLinha:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; Fim da line
    je .fim

    cmp al, 0 ;; Fim da string
    je .fim

    inc edx

    jmp tamanhoLinha ;; Mais caracteres

.fim:

    ret

;;*************************************************************************************************

;; Encontrar endereço da line na string
;;
;; Entrada:
;;
;; ESI - String
;; EAX - Número da line (contando de 0)
;;
;; Saída:
;;
;; ESI - Posição da string na line
;; Carry definido em line não encontrada

posicaoLinha:

    push ebx

    cmp eax, 0
    je .linhaDesejadaEncontrada ;; Já na primeira line

    mov edx, 0   ;; Contador de linhas
    mov ebx, eax ;; Salvar line

    dec ebx

.proximoCaractere:

    mov al, byte[esi]

    inc esi

    cmp al, 10 ;; Caractere de nova line
    je .linhaEncontrada

    cmp al, 0 ;; Fim da string
    je .linhaNaoEncontrada

    jmp .proximoCaractere

.linhaEncontrada:

    cmp edx, ebx
    je .linhaDesejadaEncontrada

    inc edx ;; Contador de linhas

    jmp .proximoCaractere

.linhaDesejadaEncontrada:

    clc

    jmp .fim

.linhaNaoEncontrada:

    stc

.fim:

    pop ebx

    ret


;;*************************************************************************************************

reiniciarBufferVideo:

    mov esi, Hexagon.LibASM.Dev.video.tty1

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    mov esi, Hexagon.LibASM.Dev.video.tty0

    hx.syscall hx.open

    hx.syscall hx.clearConsole

    ret

;;************************************************************************************

reiniciarBufferTexto:

    mov dword[appFileBuffer], 10 ;; Vamos zerar o buffer de texto

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
;; Buffer para armazenamento do arquivo solicitado
;;
;;*************************************************************************************************

appFileBuffer: db 10
