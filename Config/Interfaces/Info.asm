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

mostrarInterfaceInfo:   

    hx.syscall limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface
    
    hx.syscall definirCor
    
    mov al, 0
    hx.syscall limparLinha
    
    fputs TITULO.info
        
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    hx.syscall limparLinha
    
    fputs RODAPE.info
        
    call definirCorTema
    
    call mostrarAvisoResolucao
    
    call definirCorPadrao
    
    call mostrarLogoSistema
    
    cursorPara 20, 02

    call definirCorTema
    
    fputs msgInfo.introducao
    
    call definirCorPadrao
    
    cursorPara 18, 04
    
    fputs msgInfo.nomeSistema
        
    call definirCorTema
    
    fputs nomeSistema
        
    call definirCorPadrao

    cursorPara 18, 05
    
    fputs msgInfo.versaoSistema
        
    call definirCorTema
    
    call imprimirVersao
    
    mov al, ' '

    hx.syscall imprimirCaractere

    mov al, '['

    hx.syscall imprimirCaractere

    fputs codigoObtido

    mov al, ']'

    hx.syscall imprimirCaractere

    call definirCorPadrao

    cursorPara 18, 06
    
    fputs msgInfo.buildSistema
        
    call definirCorTema
    
    fputs buildObtida
        
    call definirCorPadrao

    cursorPara 18, 07
    
    fputs msgInfo.tipoSistema
        
    call definirCorTema

    fputs msgInfo.modeloSistema
        
    call definirCorPadrao

    cursorPara 18, 08
 
    fputs msgInfo.pacoteAtualizacoes
        
    call definirCorTema
    
    fputs pacoteAtualizacoes
        
    mov al, ' '
    
    hx.syscall imprimirCaractere
    
    fputs dataHora

    call definirCorPadrao

;; Agora vamos exibir informações sobre o Hexagon

    cursorPara 18, 09
 
    fputs msgInfo.Hexagon
    
    call definirCorTema
    
    hx.syscall retornarVersao
    
    push ecx
    push ebx
    
    imprimirInteiro
    
    fputs msgInfo.ponto
        
    pop eax
    
    imprimirInteiro
    
    pop ecx
    
    cmp ch, 0
    je .continuar

    push ecx

    fputs msgInfo.ponto
        
    pop ecx 
    
    mov al, ch
    
    hx.syscall imprimirCaractere

.continuar:

    call definirCorPadrao

;; Voltamos à programação normal

    cursorPara 18, 11
    
    fputs nomeSistema
     
    call definirCorTema

;; Exibir licenciamento

    cursorPara 18, 13
    
    fputs msgInfo.licenciado

    call definirCorPadrao
    
    cursorPara 18, 15

    fputs msgInfo.copyrightAndromeda
        
    cursorPara 18, 16
    
    fputs msgInfo.direitosReservados
        
    cursorPara 28, 18
    
    call definirCorTema
    
    fputs msgInfo.introducaoHardware
        
    call definirCorPadrao
    
    cursorPara 02, 20
    
    fputs msgInfo.processadorPrincipal
    
    cursorPara 04, 22

    fputs msgInfo.numProcessador
    
    call definirCorTema

    call exibirProcessadorInstalado
    
    call definirCorPadrao

    cursorPara 08, 23

    fputs msgInfo.operacaoProcessador
    
    cursorPara 02, 25

    fputs msgInfo.memoriaDisponivel
        
    call definirCorTema
    
    hx.syscall usoMemoria
    
    mov eax, ecx
    
    imprimirInteiro
    
    call definirCorPadrao
    
    fputs msgInfo.kbytes
        
.obterTeclas:

    hx.syscall aguardarTeclado
    
    cmp al, 'v'
    je mostrarInterfacePrincipal
    
    cmp al, 'V'
    je mostrarInterfacePrincipal
    
    cmp al, 'b'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'B'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'c'
    je finalizarAPP
    
    cmp al, 'C'
    je finalizarAPP

    jmp .obterTeclas        
    
