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
;;                         Copyright (c) 2015-2023 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2023, Felipe Miguel Nery Lunkes
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

mostrarInterfaceConfigResolucao:

    hx.syscall limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface

    hx.syscall definirCor

    mov al, 0

    hx.syscall limparLinha

    fputs TITULO.resolucao

    mov al, byte[maxLinhas] ;; Última linha

    dec al

    hx.syscall limparLinha

    fputs RODAPE.resolucao

    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    call mostrarAvisoResolucao

    call exibirResolucao

    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    gotoxy 02, 02

    fputs msgResolucao.introducao

    gotoxy 02, 03

    fputs msgResolucao.introducao2

    gotoxy 02, 06

    fputs msgResolucao.inserir

    gotoxy 04, 08

    fputs msgResolucao.opcao1

    gotoxy 04, 09

    fputs msgResolucao.opcao2

    mov ah, byte[alterado]

    cmp byte ah, 1
    je .alterou

.obterTeclas:

    hx.syscall aguardarTeclado

    cmp al, 'b'
    je mostrarInterfaceConfiguracoes

    cmp al, 'B'
    je mostrarInterfaceConfiguracoes

    cmp al, 'x'
    je finalizarAPP

    cmp al, 'X'
    je finalizarAPP

    cmp al, '1'
    je modoGrafico1

    cmp al, '2'
    je modoGrafico2


    jmp .obterTeclas

.alterou:

    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    mov dh, 15
    mov dl, 02

    hx.syscall definirCursor

    fputs msgResolucao.resolucaoAlterada

    mov dh, 17
    mov dl, 02

    hx.syscall definirCursor

    fputs msgResolucao.alterado

    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    jmp .obterTeclas

modoGrafico1:

match =SIM, VERBOSE
{

    logSistema Log.Config.logTrocarResolucao800x600, 00h, Log.Prioridades.p4

}

    mov eax, 1

    hx.syscall definirResolucao

    hx.syscall obterInfoTela

    mov byte[maxColunas], bl
    mov byte[maxLinhas], bh

    mov byte[alterado], 1

    mov dh, 15
    mov dl, 02

    jmp mostrarInterfaceConfigResolucao

modoGrafico2:

match =SIM, VERBOSE
{

    logSistema Log.Config.logTrocarResolucao1024x768, 00h, Log.Prioridades.p4

}

    mov eax, 2
    hx.syscall definirResolucao

    hx.syscall obterInfoTela

    mov byte[maxColunas], bl
    mov byte[maxLinhas], bh

    mov byte[alterado], 1

    jmp mostrarInterfaceConfigResolucao

exibirResolucao:

    mov dh, 13
    mov dl, 02

    hx.syscall definirCursor

    hx.syscall obterResolucao

    cmp eax, 1
    je .modoGrafico1

    cmp eax, 2
    je .modoGrafico2

    ret

.modoGrafico1:

    fputs msgResolucao.modo1

    ret

.modoGrafico2:

    fputs msgResolucao.modo2

   ret

alterado: dd 0
