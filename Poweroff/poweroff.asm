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
;;            Sistema Operacional Hexagonix® - Hexagonix® Operating System            
;;
;;                  Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                Todos os direitos reservados - All rights reserved.
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

    hx.syscall obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    hx.syscall limparTela

    hx.syscall obterInfoTela
    
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh
    
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface desligar.titulo, desligar.rodape, \
    INDIGO, INDIGO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
    
    novaLinha
    
    fputs desligar.bannerHexagonix

    Andromeda.Estelar.criarLogotipo INDIGO, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    cursorPara 02, 14
    
    fputs desligar.msgFinalizar

    cursorPara 02, 15

    fputs desligar.msgReiniciar
    
    cursorPara 02, 17

    fputs desligar.msgSair

    call obterTeclas

;;************************************************************************************

 finalizarSistema:

    cursorPara 02, 18

    fputs desligar.msgDesligamento

    mov ecx, 500
    
    hx.syscall causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor
    
    fputs desligar.msgPronto

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    fputs desligar.msgFinalizando

    mov ecx, 500
    
    hx.syscall causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor
    
    fputs desligar.msgPronto

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    fputs desligar.msgHexagonix

    mov ecx, 500
    
    hx.syscall causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor
    
    fputs desligar.msgPronto

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    fputs desligar.msgDiscos

    mov ecx, 500
    
    hx.syscall causarAtraso

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor
    
    fputs desligar.msgPronto

    mov eax, VERMELHO
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

    novaLinha

    mov ecx, 500
    
    hx.syscall causarAtraso

    ret

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

    hx.syscall iniciarProcesso

    jc falhaEnergia

;;************************************************************************************

executarEnergiaReinicio:

    mov esi, desligar.energia
    mov edi, desligar.parametroReiniciar
    mov eax, 01h

    hx.syscall iniciarProcesso

    jc falhaEnergia

;;************************************************************************************

falhaEnergia:

    fputs desligar.falhaUtilitarioEnergia

    hx.syscall aguardarTeclado

    jmp Hexagonix_Sair

;;************************************************************************************

Hexagonix_Sair:

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

ENERGIA equ "shutdown"   
VERSAO  equ "1.0.4"

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
.falhaUtilitarioEnergia: db 10, 10, "Failed to run Unix shutdown utility. Try again later.", 10
                         db "Press any key to end this application...", 0
.titulo:                 db "Hexagonix(R) Operating System shutdown options",0
.rodape:                 db "[", VERSAO, "]",0

parametro: dd ?

Andromeda.Interface Andromeda.Estelar.Interface