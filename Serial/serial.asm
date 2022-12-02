;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
;; utilizar qualquer trecho deste arquivo.
;;
;; BSD 3-Clause License
;;
;; Copyright (c) 2015-2022, Felipe Miguel Nery Lunkes
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

;; Agora vamos criar um cabeçalho para a imagem HAPP final do aplicativo. Anteriormente,
;; o cabeçalho era criado em cada imagem e poderia diferir de uma para outra. Caso algum
;; campo da especificação HAPP mudasse, os cabeçalhos de todos os aplicativos deveriam ser
;; alterados manualmente. Com uma estrutura padronizada, basta alterar um arquivo que deve
;; ser incluído e montar novamente o aplicativo, sem a necessidade de alterar manualmente
;; arquivo por arquivo. O arquivo contém uma estrutura instanciável com definição de 
;; parâmetros no momento da instância, tornando o cabeçalho tão personalizável quanto antes.

include "HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioAPP, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"

;;************************************************************************************

inicioAPP:

    Hexagonix obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    Hexagonix limparTela

    Hexagonix obterInfoTela
    
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh
    
;; Imprime o título do programa e rodapé.
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface serial.titulo, serial.rodape, \
    AZUL_ROYAL, AZUL_ROYAL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    Hexagonix definirCor
    
    cursorPara 02, 01
    
    mov esi, serial.bannerHexagonix

    imprimirString

    Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    cursorPara 02, 10

    mov esi, serial.nomePorta
    
    Hexagonix abrir
    
    jc erroAbertura
    
    novaLinha

    mov esi, serial.ajuda
    
    imprimirString
    
    mov esi, serial.prompt
    
    imprimirString
    
    mov esi, serial.separador
    
    imprimirString

    mov al, byte[Andromeda.Interface.numColunas]        ;; Máximo de caracteres para obter

    sub al, 20
    
    Hexagonix obterString
    
    ;; Hexagonix cortarString           ;; Remover espaços em branco extras
    
    mov [msg], esi
    
    mov si, [msg]
    
    Hexagonix escrever
    
    jc erro
    
    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    Hexagonix definirCor
    
    mov esi, serial.enviado
    
    imprimirString
    
    mov esi, serial.prompt
    
    imprimirString
    
    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    Hexagonix definirCor
    
    novaLinha
    novaLinha
    
    jmp obterTeclas

;;************************************************************************************

obterTeclas:

    Hexagonix aguardarTeclado
    
    push eax
    
    Hexagonix obterEstadoTeclas
    
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

    mov esi, serial.erroPorta
    
    imprimirString

    Hexagonix aguardarTeclado

    Hexagonix limparTela

    Hexagonix encerrarProcesso

;;************************************************************************************

erroAbertura:

    mov esi, serial.erroAbertura
    
    imprimirString

    Hexagonix aguardarTeclado

    jmp Andromeda_Sair

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "1.0.1"

serial:

.erroPorta:       db 10, 10, "Unable to use the serial port.", 10, 0
.erroAbertura:    db 10, 10, "Unable to open device for writing.", 10, 0
.bannerHexagonix: db 10 
                  db "                                   Hexagonix(R) Operating System", 10, 10, 10, 10
                  db "                           Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 10
                  db "                                         All rights reserved.", 0   
.ajuda:           db 10, 10, "This application will help you to write data via serial port.", 10, 10, 10, 10, 0
.prompt:          db "[com1]", 0
.separador:       db ": ", 0 
.nomePorta:       db "com1", 0    
.enviado:         db 10, 10, "Data sent via serial port ", 0
.titulo:          db "Utility for sending data via the serial port of the Hexagonix(R) Operating System", 0
.rodape:          db "[", VERSAO, "] | [^N] New message  [^S] Exit", 0

Andromeda.Interface Andromeda.Estelar.Interface

msg:              db 0
