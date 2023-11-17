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

use32

;; Agora vamos criar um cabeçalho para a imagem HAPP final do aplicativo.

include "HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioAPP, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"

;;************************************************************************************

inicioAPP:

    Andromeda.Estelar.obterInfoConsole

    hx.syscall limparTela

    hx.syscall obterInfoTela

;; Imprime o título do programa e rodapé.
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface serial.titulo, serial.rodape, \
    AZUL_ROYAL, AZUL_ROYAL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    hx.syscall definirCor

    gotoxy 02, 01

    xyfputs 39, 4, serial.bannerHexagonix
    xyfputs 27, 5, serial.copyright
    xyfputs 41, 6, serial.marcaRegistrada

    Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    gotoxy 02, 10

    mov esi, serial.nomePorta

    hx.syscall abrir

    jc erroAbertura

    novaLinha

    fputs serial.ajuda

    fputs serial.prompt

    fputs serial.separador

    mov al, byte[Andromeda.Interface.numColunas] ;; Máximo de caracteres para obter

    sub al, 20

    hx.syscall obterString

    ;; hx.syscall cortarString ;; Remover espaços em branco extras

    mov [msg], esi

    mov si, [msg]

    hx.syscall escrever

    jc erro

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    fputs serial.enviado

    fputs serial.prompt

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    novaLinha
    novaLinha

    jmp obterTeclas

;;************************************************************************************

obterTeclas:

    hx.syscall aguardarTeclado

    push eax

    hx.syscall obterEstadoTeclas

    bt eax, 0
    jc .teclasControl

    pop eax

    jmp obterTeclas

.teclasControl:

    pop eax

    cmp al, 'n'
    je inicioAPP

    cmp al, 'N'
    je inicioAPP

    cmp al, 's'
    je Andromeda_Sair

    cmp al, 'S'
    je Andromeda_Sair

    jmp obterTeclas

;;************************************************************************************

Andromeda_Sair:

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************

erro:

    fputs serial.erroPorta

    hx.syscall aguardarTeclado

    hx.syscall limparTela

    hx.syscall encerrarProcesso

;;************************************************************************************

erroAbertura:

    fputs serial.erroAbertura

    hx.syscall aguardarTeclado

    jmp Andromeda_Sair

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "1.2.0"

serial:

.erroPorta:
db 10, 10, "Unable to use the serial port.", 10, 0
.erroAbertura:
db 10, 10, "Unable to open device for writing.", 10, 0
.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.marcaRegistrada:
db "All rights reserved.", 0
.ajuda:
db 10, 10, "This application will help you to write data via serial port.", 10, 10, 10, 10, 0
.prompt:
db "[com1]", 0
.separador:
db ": ", 0
.nomePorta:
db "com1", 0
.enviado:
db 10, 10, "Data sent via serial port ", 0
.titulo:
db "Utility for sending data via the serial port of the Hexagonix Operating System", 0
.rodape:
db "[", VERSAO, "] | [^N] New message  [^S] Exit", 0

msg: db 0 ;; Buffer
