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

mostrarInterfacePrincipal:  

    Hexagonix limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface
    
    Hexagonix definirCor
    
    mov al, 0
    Hexagonix limparLinha
    
    mov esi, TITULO.inicio
    
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, RODAPE.inicio
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    call mostrarAvisoResolucao
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    call mostrarLogoSistema
    
    cursorPara 36, 02

    mov esi, msgInicio.introducao
    
    imprimirString  

    cursorPara 18, 04

    mov esi, msgInicio.nomeSistema
    
    imprimirString
    
    mov esi, nomeSistema
    
    imprimirString

    cursorPara 18, 05

    mov esi, msgInicio.versaoSistema
    
    imprimirString
    
    call imprimirVersao
    
    mov esi, msgInicio.versao
    imprimirString

    cursorPara 18, 06

    mov esi, msgInicio.tipoSistema
    
    imprimirString

    cursorPara 18, 08

    call definirCorTema

    mov esi, msgInfo.licenciado

    imprimirString

    call definirCorPadrao

    cursorPara 18, 10

    mov esi, msgInicio.copyrightAndromeda
    
    imprimirString

    cursorPara 18, 11

    mov esi, msgInicio.direitosReservados
    
    imprimirString

    cursorPara 24, 13

    call definirCorTema

    mov esi, msgInicio.separador

    imprimirString

    call definirCorPadrao

    cursorPara 36, 15

    mov esi, msgInicio.sobrePC
    
    imprimirString

    cursorPara 02, 17

    mov esi, msgInicio.processadorPrincipal
    
    imprimirString

    cursorPara 04, 19

    mov esi, msgInicio.numProcessador
    
    imprimirString

    call definirCorTema

    call exibirProcessadorInstalado

    call definirCorPadrao

    cursorPara 08, 20

    mov esi, msgInicio.operacaoProcessador
    
    imprimirString
    
    cursorPara 02, 22

    mov esi, msgInfo.memoriaDisponivel
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    Hexagonix usoMemoria
    
    mov eax, ecx
    
    imprimirInteiro
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, msgInfo.kbytes
    
    imprimirString
    
.obterTeclas:

    Hexagonix aguardarTeclado
    
    cmp al, 'a'
    je mostrarInterfaceInfo
    
    cmp al, 'A'
    je mostrarInterfaceInfo
    
    cmp al, 'b'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'B'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'c'
    je finalizarAPP
    
    cmp al, 'C'
    je finalizarAPP

    jmp .obterTeclas        
    
    
