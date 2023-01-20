;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2023 Felipe Miguel Nery Lunkes
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
    
    mov esi, TITULO.configuracoes
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    hx.syscall limparLinha
    
    mov esi, RODAPE.configuracoes
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    hx.syscall definirCor
    
    call mostrarAvisoResolucao
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    hx.syscall definirCor
    
    cursorPara 02, 02
    
    mov esi, msgConfig.introducao
    
    imprimirString
    
    cursorPara 02, 05
    
    mov esi, msgConfig.introducao2
    
    imprimirString
    
    cursorPara 04, 07 
    
    mov esi, msgConfig.categoria1
    
    imprimirString
    
    cursorPara 04, 08
    
    mov esi, msgConfig.categoria2
    
    imprimirString
    
    cursorPara 04, 09 
    
    mov esi, msgConfig.categoria3
    
    imprimirString
    
    cursorPara 04, 10
    
    mov esi, msgConfig.categoria4
    
    imprimirString
    
    cursorPara 04, 11
    
    mov esi, msgConfig.categoria5
    
    imprimirString
    
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
    je mostrarInterfaceDiscos
    
    cmp al, '3'
    je mostrarInterfaceSerial
    
    cmp al, '4'
    je mostrarInterfacePortaParalela
    
    cmp al, '5'
    je mostrarInterfaceFonte


    jmp .obterTeclas        
