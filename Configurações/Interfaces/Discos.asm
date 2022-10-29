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

mostrarInterfaceDiscos: 

    Hexagonix limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface
    
    Hexagonix definirCor
    
    mov al, 0
    Hexagonix limparLinha
    
    mov esi, TITULO.discos
    
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, RODAPE.discos
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    call mostrarAvisoResolucao
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    cursorPara 02, 02
    
    mov esi, msgDiscos.introducao
    
    imprimirString
    
    cursorPara 02, 03
    
    mov esi, msgDiscos.introducao2
    
    imprimirString
    
.infoDisco:

    cursorPara 04, 06
    
    mov esi, msgDiscos.discoAtual
  
    imprimirString  

match =SIM, VERBOSE
{

    logSistema Log.Config.logDiscos, 00h, Log.Prioridades.p4

}

    Hexagonix obterDisco
    
    push edi ;; Rótulo do disco
    push esi ;; Nome do dispositivo segundo o sistema


    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]
    
    Hexagonix definirCor
    
    pop esi
    
    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]
    
    Hexagonix definirCor
    
    cursorPara 04, 07
    
    mov esi, msgDiscos.rotuloVolume
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]
    
    Hexagonix definirCor
    
    pop esi
    
    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]
    
    Hexagonix definirCor
    
    jmp .novaLinha
    
.novaLinha:
  
    novaLinha
    
.obterTeclas:

    Hexagonix aguardarTeclado
    
    cmp al, 'v'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'V'
    je mostrarInterfaceConfiguracoes
    
    cmp al, 'b'
    je mostrarInterfaceInfo
    
    cmp al, 'B'
    je mostrarInterfaceInfo
    
    cmp al, 'c'
    je finalizarAPP
    
    cmp al, 'C'
    je finalizarAPP

    jmp .obterTeclas        
    
    
