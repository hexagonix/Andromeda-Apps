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

;; Imprime o título do programa e rodapé.
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface piano.titulo, piano.rodape, \
    HEXAGONIX_BLOSSOM_AZUL, HEXAGONIX_BLOSSOM_AZUL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

.blocoTeclado:

    mov eax, 80  ;; Início do bloco em X
    mov ebx, 80  ;; Início do bloco em Y
    mov esi, 635 ;; Comprimento do bloco
    mov edi, 450 ;; Altura do bloco
    mov edx, HEXAGONIX_BLOSSOM_LAVANDA ;; Cor do bloco

    hx.syscall desenharBloco

    call montarTeclas

.novamente:

    hx.syscall aguardarTeclado

.semtecla: ; Procura as teclas e emite os sons

    cmp al, 'q'
    jne .w

    call evidenciarTeclas.evidenciarQ

    tocarNota 4000

    jmp .novamente

.w:

    cmp al, 'w'
    jne .e

    call evidenciarTeclas.evidenciarW

    tocarNota 3600

    jmp .novamente

.e:

    cmp al, 'e'
    jne .r

    call evidenciarTeclas.evidenciarE

    tocarNota 3200

    jmp .novamente


.r:

    cmp al, 'r'
    jne .t

    call evidenciarTeclas.evidenciarR

    tocarNota 3000

    jmp .novamente

.t:

    cmp al, 't'
    jne .y

    call evidenciarTeclas.evidenciarT

    tocarNota 2700

    jmp .novamente

.y:

    cmp al, 'y'
    jne .u

    call evidenciarTeclas.evidenciarY

    tocarNota 2400

    jmp .novamente

.u:

    cmp al, 'u'
    jne .i

    call evidenciarTeclas.evidenciarU

    tocarNota 2100

    jmp .novamente

.i:

    cmp al, 'i'
    jne .espaco

    call evidenciarTeclas.evidenciarI

    tocarNota 2000

    jmp .novamente

.espaco:

    cmp al, ' '
    jne .informacoes

    call evidenciarTeclas.evidenciarEspaco

    finalizarNota

    jmp .novamente

.informacoes:

    cmp al, 'a'
    jne .sair

    jmp exibirInterfaceSobre

.sair:

    cmp al, 'x'
    je .fim

    cmp al, 'X'
    je .fim

    jmp .agora

.agora:

    jmp .novamente

.fim:

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    hx.syscall desligarSom

    hx.syscall limparTela

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************

montarTeclas:

.primeiraTecla:

    mov eax, 144
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.segundaTecla:

    mov eax, 204
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.terceiraTecla:

    mov eax, 264
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.quartaTecla:

    mov eax, 324
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.quintaTecla:

    mov eax, 384
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.sextaTecla:

    mov eax, 444
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.setimaTecla:

    mov eax, 504
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.oitavaTecla:

    mov eax, 564
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO

    hx.syscall desenharBloco

.blocoEspaco:

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, PRETO

    hx.syscall desenharBloco

.legenda:

    mov eax, PRETO
    mov ebx, HEXAGONIX_BLOSSOM_LAVANDA

    hx.syscall definirCor

.teclaQ:

    mov dl, 19
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaQ

.teclaW:

    mov dl, 27 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaW

.teclaE:

    mov dl, 34 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaE

.teclaR:

    mov dl, 42 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaR

.teclaT:

    mov dl, 49 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaT

.teclaY:

    mov dl, 57 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaY

.teclaU:

    mov dl, 64 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaU

.teclaI:

    mov dl, 72 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!

    hx.syscall definirCursor

    fputs piano.teclaI

.teclaEspaco:

    mov eax, BRANCO_ANDROMEDA
    mov ebx, PRETO

    hx.syscall definirCor

    mov dl, 45
    mov dh, 29

    hx.syscall definirCursor

    fputs piano.teclaEspaco

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    ret

;;************************************************************

evidenciarTeclas:

.evidenciarQ:

    call montarTeclas

    mov eax, 144
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarW:

    call montarTeclas

    mov eax, 204
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarE:

    call montarTeclas

    mov eax, 264
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarR:

    call montarTeclas

    mov eax, 324
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarT:

    call montarTeclas

    mov eax, 384
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarY:

    call montarTeclas

    mov eax, 444
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarU:

    call montarTeclas

    mov eax, 504
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarI:

    call montarTeclas

    mov eax, 564
    mov ebx, 84 ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO

    hx.syscall desenharBloco

    ret

.evidenciarEspaco:

    call montarTeclas

    mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, VERMELHO

    hx.syscall desenharBloco

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERMELHO

    hx.syscall definirCor

    mov dl, 45
    mov dh, 29

    hx.syscall definirCursor

    mov esi, piano.teclaEspaco

    imprimirString

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    ret

;;************************************************************

exibirInterfaceSobre:

    hx.syscall desligarSom

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    hx.syscall limparTela

    ;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, HEXAGONIX_BLOSSOM_AZUL

    hx.syscall definirCor

    mov al, 0

    hx.syscall limparLinha

    fputs piano.titulo

    mov al, byte[Andromeda.Interface.numLinhas] ;; Última linha

    dec al

    hx.syscall limparLinha

    fputs piano.rodapeInfo

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    mov dh, 02
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.sobreTeclado

    mov dh, 03
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.versaoTeclado

    mov dh, 05
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.autor

    mov dh, 06
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.direitos

    mov dh, 08
    mov dl, 04

    hx.syscall definirCursor

    fputs piano.ajuda

    mov dh, 10
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topico1

    mov dh, 11
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topico2

    mov dh, 12
    mov dl, 02

    hx.syscall definirCursor

    fputs piano.topico3

.obterTeclas:

    hx.syscall aguardarTeclado

    cmp al, 'b'
    je inicioAPP

    cmp al, 'B'
    je inicioAPP

    cmp al, 'x'
    je inicioAPP.fim

    cmp al, 'X'
    je inicioAPP.fim

    jmp .obterTeclas

;;************************************************************

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "1.7.0"

piano:

.sobreTeclado:
db "Virtual Piano 'return PIANO;' for Hexagonix", 0
.versaoTeclado:
db "Version ", VERSAO, 0
.autor:
db "Copyright (C) 2017-", __stringano, " Felipe Miguel Nery Lunkes", 0
.direitos:
db "All rights reserved.", 0
.ajuda:
db "A small help topic for this program:", 0
.topico1:
db "+ Use the [QWERTYUI] keys to issue notes.", 0
.topico2:
db "+ Use the [SPACE] key to mute notes when necessary.", 0
.topico3:
db "+ Finally, use the [Z] key to terminate this application at any time.", 0
.titulo:
db "Virtual Piano 'return PIANO;' for Hexagonix", 0
.rodape:
db "[", VERSAO, "] Press [X] to exit and [SPACE] to mute. Use [A] for more information", 0
.rodapeInfo:
db "[", VERSAO, "] Press [B] to return or [X] to end this application", 0

.teclaQ:
db "Q", 0
.teclaW:
db "W", 0
.teclaE:
db "E", 0
.teclaR:
db "R", 0
.teclaT:
db "T", 0
.teclaY:
db "Y", 0
.teclaU:
db "U", 0
.teclaI:
db "I", 0
.teclaEspaco:
db "[SPACE]", 0
.teclaZ:
db "Z", 0