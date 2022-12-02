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
include "log.s"

;;************************************************************************************

inicioAPP:  

    push ds
    pop es          
    
    mov [parametro], edi ;; Salvar os parâmetros da linha de comando para uso futuro
    
    mov esi, [parametro]

    jmp iniciarInterface

;;************************************************************************************
    
iniciarInterface:

    Hexagonix obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    Hexagonix limparTela

    Hexagonix obterInfoTela
    
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh
    
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface desligar.titulo, desligar.rodape, \
    INDIGO, INDIGO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
    
    novaLinha
    
    mov esi, desligar.bannerHexagonix

    imprimirString

    Andromeda.Estelar.criarLogotipo INDIGO, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    cursorPara 02, 14
    
    mov esi, desligar.msgFinalizar

    imprimirString

    cursorPara 02, 15

    mov esi, desligar.msgReiniciar

    imprimirString
    
    cursorPara 02, 17

    mov esi, desligar.msgSair

    imprimirString

    call obterTeclas

;;************************************************************************************

 finalizarSistema:

    cursorPara 02, 18

    mov esi, desligar.msgDesligamento

    imprimirString

    mov ecx, 500
    
    Hexagonix causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor
    
    mov esi, desligar.msgPronto

    imprimirString

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor

    mov esi, desligar.msgFinalizando

    imprimirString

    mov ecx, 500
    
    Hexagonix causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor
    
    mov esi, desligar.msgPronto

    imprimirString

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor

    mov esi, desligar.msgHexagonix

    imprimirString

    mov ecx, 500
    
    Hexagonix causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor
    
    mov esi, desligar.msgPronto

    imprimirString

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor

    mov esi, desligar.msgDiscos

    imprimirString

    mov ecx, 500
    
    Hexagonix causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor
    
    mov esi, desligar.msgPronto

    imprimirString

    mov eax, VERMELHO
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    Hexagonix definirCor

    novaLinha

    mov ecx, 500
    
    Hexagonix causarAtraso

    ret

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
    
    cmp al, 'd'
    je Hexagonix_Desligar
    
    cmp al, 'D'
    je Hexagonix_Desligar
    
    cmp al, 'r'
    je Hexagonix_Reiniciar
    
    cmp al, 'R'
    je Hexagonix_Reiniciar
    
    cmp al, 's'
    je Hexagonix_Sair
    
    cmp al, 'S'
    je Hexagonix_Sair

    jmp obterTeclas 
    
;;************************************************************************************  
    
Hexagonix_Desligar:

    call finalizarSistema

    call executarEnergiaDesligamento

    jmp Hexagonix_Sair

;;************************************************************************************

Hexagonix_Reiniciar:

    call finalizarSistema

    call executarEnergiaReinicio

    jmp Hexagonix_Sair

;;************************************************************************************

executarEnergiaDesligamento:

    mov esi, desligar.energia
    mov edi, desligar.parametroDesligar
    mov eax, 01h

    Hexagonix iniciarProcesso

    jc falhaEnergia

;;************************************************************************************

executarEnergiaReinicio:

    mov esi, desligar.energia
    mov edi, desligar.parametroReiniciar
    mov eax, 01h

    Hexagonix iniciarProcesso

    jc falhaEnergia

;;************************************************************************************

falhaEnergia:

    mov esi, desligar.falhaUtilitarioEnergia

    imprimirString

    Hexagonix aguardarTeclado

    jmp Hexagonix_Sair

;;************************************************************************************

Hexagonix_Sair:

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

ENERGIA equ "energia"   
VERSAO  equ "1.0.2"

desligar:

.bannerHexagonix:        db 10 
                         db "                                     Hexagonix(R) Operating System", 10, 10, 10, 10
                         db "                           Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 10
                         db "                                         All rights reserved.", 0              
.energia:                db ENERGIA, 0
.parametroDesligar:      db "-de", 0 ;; Parâmetro que indica que não deve haver eco
.parametroReiniciar:     db "-re", 0 ;; Parâmetro que indica que não deve haver eco
.msgDesligamento:        db 10, 10, "!> Preparing to shut down your computer...  ", 0
.msgFinalizando:         db 10, 10, "#> Terminating all processes still running...  ", 0
.msgHexagonix:           db 10, 10, "#> Shutting down the Hexagonix(R) Operating System...    ", 0
.msgDiscos:              db 10, 10, "#> Stoping disks and shutting down your computer... ", 0
.msgReinicio:            db "Rebooting your computes...", 10, 10, 0
.msgReiniciar:           db "Press [Ctrl-R] to restart your computer.", 10, 0
.msgFinalizar:           db "Press [Ctrl-D] to shut down your computer.", 10, 0
.msgSair:                db "Press [Ctrl-S] or [F1] to return to Hexagonix(R)", 0
.msgPronto:              db "[Done]", 0
.msgFalha:               db "[Fail]", 0
.falhaUtilitarioEnergia: db 10, 10, "Failed to run Unix energia utility. Try again later.", 10
                         db "Press any key to end this application...", 0
.titulo:                 db "Hexagonix(R) Operating System shutdown options",0
.rodape:                 db "[", VERSAO, "]",0

parametro: dd ?

Andromeda.Interface Andromeda.Estelar.Interface