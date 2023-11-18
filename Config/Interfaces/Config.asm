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

mostrarInterfaceConfiguracoes:

    hx.syscall limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface

    hx.syscall definirCor

    mov al, 0
    hx.syscall limparLinha

    fputs TITULO.configuracoes

    mov al, byte[maxLinhas] ;; Última linha

    dec al

    hx.syscall limparLinha

    fputs RODAPE.configuracoes

    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    call mostrarAvisoResolucao

    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    hx.syscall definirCor

    gotoxy 02, 02

    fputs msgConfig.introducao

    gotoxy 02, 05

    fputs msgConfig.introducao2

    gotoxy 04, 07

    fputs msgConfig.categoria1

    gotoxy 04, 08

    fputs msgConfig.categoria2

    gotoxy 04, 09

    fputs msgConfig.categoria3

    gotoxy 04, 10

    fputs msgConfig.categoria4

    gotoxy 04, 11

    fputs msgConfig.categoria5

    gotoxy 04, 12

    fputs msgConfig.categoria6

.obterTeclas:

    hx.syscall aguardarTeclado

    cmp al, 'v'
    je mostrarInterfacePrincipal

    cmp al, 'V'
    je mostrarInterfacePrincipal

    cmp al, 'b'
    je mostrarInterfaceInfo

    cmp al, 'B'
    je mostrarInterfaceInfo

    cmp al, 'c'
    je finalizarAPP

    cmp al, 'C'
    je finalizarAPP

    cmp al, '1'
    je mostrarInterfaceConfigResolucao

    cmp al, '2'
    je mostrarInterfaceConfigTema

    cmp al, '3'
    je mostrarInterfaceDiscos

    cmp al, '4'
    je mostrarInterfaceSerial

    cmp al, '5'
    je mostrarInterfacePortaParalela

    cmp al, '6'
    je mostrarInterfaceFonte

    jmp .obterTeclas
