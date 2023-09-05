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
    
    xyfputs 39, 4, desligar.bannerHexagonix
    xyfputs 27, 5, desligar.copyright
    xyfputs 41, 6, desligar.marcaRegistrada

    Andromeda.Estelar.criarLogotipo INDIGO, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

    xyfputs 02, 14, desligar.msgFinalizar
    
    xyfputs 02, 15, desligar.msgReiniciar
    
    xyfputs 02, 17, desligar.msgSair

    call obterTeclas

;;************************************************************************************

 finalizarSistema:

    xyfputs 02, 18, desligar.msgDesligamento

    mov eax, VERDE_FLORESTA
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor
    
    fputs desligar.msgPronto

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]

    hx.syscall definirCor

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
    je HexagonixDesligar
    
    cmp al, 'D'
    je HexagonixDesligar
    
    cmp al, 'r'
    je HexagonixReiniciar
    
    cmp al, 'R'
    je HexagonixReiniciar
    
    cmp al, 's'
    je terminar
    
    cmp al, 'S'
    je terminar

    jmp obterTeclas 
    
;;************************************************************************************  
    
HexagonixDesligar:

    call finalizarSistema

    call executarEnergiaDesligamento

    jmp terminar

;;************************************************************************************

HexagonixReiniciar:

    call finalizarSistema

    call executarEnergiaReinicio

    jmp terminar

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

    jmp terminar

;;************************************************************************************

terminar:

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

ENERGIA equ "shutdown"   
VERSAO  equ "1.4.0"

desligar:

.bannerHexagonix:
db "Hexagonix Operating System", 0
.copyright:
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 0
.marcaRegistrada:
db "All rights reserved.", 0              
.energia:
db ENERGIA, 0
.parametroDesligar:
db "-de", 0 ;; Parâmetro que indica que não deve haver eco
.parametroReiniciar:
db "-re", 0 ;; Parâmetro que indica que não deve haver eco
.msgDesligamento:
db 10, 10, "The system is coming down. Please wait... ", 0
.msgReinicio:
db "Rebooting the computer...", 10, 10, 0
.msgReiniciar:
db "Press [Ctrl-R] to restart the computer.", 10, 0
.msgFinalizar:
db "Press [Ctrl-D] to shutdown the computer.", 10, 0
.msgSair:
db "Press [Ctrl-S] or [F1] to return to Hexagonix.", 0
.msgPronto:
db "[Done]", 0
.msgFalha:
db "[Fail]", 0
.falhaUtilitarioEnergia:
db 10, 10, "Failed to run Unix shutdown utility. Try again later.", 10
db "Press any key to end this application...", 0
.titulo:
db "Hexagonix Operating System shutdown options",0
.rodape:
db "[", VERSAO, "]",0

parametro: dd ?

Andromeda.Interface Andromeda.Estelar.Interface