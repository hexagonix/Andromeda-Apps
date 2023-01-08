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

mostrarInterfaceFonte:  

    Hexagonix limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface
    
    Hexagonix definirCor
    
    mov al, 0
    Hexagonix limparLinha
    
    mov esi, TITULO.fonte
    
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, RODAPE.fonte
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    call mostrarAvisoResolucao
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    cursorPara 02, 02

    mov esi, msgFonte.introducao
    
    imprimirString
    
    cursorPara 02, 03
    
    mov esi, msgFonte.introducao2
    
    imprimirString

    cursorPara 02, 06
    
    mov esi, msgFonte.solicitarArquivo
    
    imprimirString

match =SIM, VERBOSE
{

    logSistema Log.Config.logPedirArquivoFonte, 00h, Log.Prioridades.p4

}

    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    mov al, 13
    
    Hexagonix obterString
    
    Hexagonix cortarString ;; Remover espaços em branco extras
    
    mov dword[fonte], esi

    cmp byte[esi], 0
    je .semArquivo

match =SIM, VERBOSE
{

    logSistema Log.Config.logFontes, 00h, Log.Prioridades.p4

}   

    mov esi, dword[fonte]
    
    clc

    Hexagonix arquivoExiste

    jc .erroArquivo
    
    clc 

    Hexagonix alterarFonte
    
    jc .erroFonte

match =SIM, VERBOSE
{

    logSistema Log.Config.logSucessoFonte, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    mov esi, msgFonte.sucesso
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, dword[fonte]
    
    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, msgFonte.fechamento
    
    imprimirString
    
    mov esi, msgFonte.introducaoTeste
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, dword[fonte]
    
    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, msgFonte.ponto
    
    imprimirString
    
    mov esi, msgFonte.testeFonte
    
    imprimirString
    
    jmp .novaLinha

.semArquivo:

    cursorPara 04, 08
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    mov esi, msgFonte.semArquivo
    
    imprimirString
    
    jmp .novaLinha

.erroArquivo:

match =SIM, VERBOSE
{

    logSistema Log.Config.logFonteAusente, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov esi, msgFonte.arquivoAusente
    
    imprimirString
    
    jmp .novaLinha

.erroFonte:

match =SIM, VERBOSE
{

    logSistema Log.Config.logFalhaFonte, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
    
    mov esi, msgFonte.falha
    
    imprimirString
    
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
    

