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
cabecalhoASH cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioShell, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "erros.s"
include "log.s"
include "macros.s"

;;************************************************************************************
;;
;; Dados, variáveis e constantes utilizadas pelo shell
;;
;;************************************************************************************

;; A versão do ASH é independente da versão do restante do sistema.
;; Ela deve ser utilizada para identificar para qual versão do Hexagonix® o ASH foi
;; desenvolvido. Essa informação pode ser fornecida com o comando 'ajuda'.

ASHPadrao          = VERDE_MAR
ASHTerminal        = VERDE_MAR
ASHAviso           = TOMATE
ASHErro            = VERMELHO_TIJOLO
ASHLimiteProcessos = AMARELO_ANDROMEDA
ASHSucesso         = VERDE

versaoASH           equ "4.1.0" 
compativelHexagonix equ "H2-CURRENT"
                    
;;**************************

ash:

.comandoInvalido:    db 10, 10, "[!] Invalid internal command or HAPP format application not found.", 10, 0
.bannerASH:          db "ASH - Andromeda(R) SHell", 0
.boasVindas:         db "Welcome to Andromeda(R) SHell - ASH", 10, 10
                     db "Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 10
                     db "All rights reserved.", 10, 0
.versaoHexagonix:    db 10, 10, "Hexagonix(R) Operating System", 10 
                     db "Version ", 0
.direitosAutorais:   db 10, 10, "Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 10   
                     db "All rights reserved.", 10, 0
.limiteProcessos:    db 10, 10, "[!] There is no memory available to run the requested application.", 10
                     db "[!] Try to terminate applications or their instances first, and try again.", 10, 0                    
.ponto:              db ".", 0
.imagemInvalida:     db ": unable to load image. Unsupported executable format.", 10, 0
.prompt:             db "[/]: ", 0
.licenca:            db 10, "Licenced under BSD-3-Clause.", 10, 0

;; Verbose 

.verboseEntradaASH:           db "[ASH]: Starting Andromeda SHell (ASH) for Hexagonix ", compativelHexagonix, " or superior.", 0
.verboseVersaoASH:            db "[ASH]: Andromeda SHell version ", versaoASH, ".", 0
.verboseAutor:                db "[ASH]: Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes.", 0
.verboseDireitos:             db "[ASH]: All rights reserved.", 0
.verboseSaida:                db "[ASH]: Terminating the ASH and returning control to the parent process...", 0
.verboseLimite:               db "[ASH]: [!] Memory or process limit reached!", 0
.verboseInterfaceMountAntiga: db "[ASH]: [!!!] Performing manipulation of mount points by obsolete function that will be removed.", 0

;;**************************

comandos:

.alterarDisco:  db "ad", 0
.sair:          db "exit",0
.versao:        db "ver", 0
.ajuda:         db "help", 0

;;**************************

ajuda:

.introducao:    db 10, 10, "Andromeda SHell version ", versaoASH, 10
                db "Compatible with Hexagonix(R) ", compativelHexagonix, " or superior.", 0
.conteudoAjuda: db 10, 10, "Internal commands available:", 10, 10
                db " VER  - Displays information about the running ASH version.", 10
                db " EXIT - Terminate this ASH session.", 10, 0
             
;;**************************

discos:

.hd0:              db "hd0", 0
.hd1:              db "hd1", 0
.hd2:              db "hd2", 0
.hd3:              db "hd3", 0
.info:             db "info", 0
.discoAtual:       db 10, 10, "Current volume used by the system: ", 0
.erroAlterar:      db 10, 10, "A valid volume or parameter was not provided for this command.", 10, 10 
                   db "Cannot change default volume.", 10, 10
                   db "Use a device name as an argument or 'info' for current disk information.", 10, 0
.rotuloVolume:     db 10, 10, "Volume label: ", 0
.avisoSairdeLinha: db 10, 10, "Warning! This is an obsolete built-in Andromeda SHell command.", 10
                   db "Be aware that it may be removed soon. Use the Unix 'mount' tool instead.", 10
                   db "You can find the tool's documentation by typing 'man mount' at any time.", 0 
    
;;**************************
 
nomeArquivo: times 13 db 0  
discoAtual:  times 3  db 0        

Andromeda.Interface Andromeda.Estelar.Interface

;;************************************************************************************

inicioShell:    

    logSistema ash.verboseEntradaASH, 00h, Log.Prioridades.p4
    logSistema ash.verboseVersaoASH, 00h, Log.Prioridades.p4
    logSistema ash.verboseAutor, 00h, Log.Prioridades.p4
    logSistema ash.verboseDireitos, 00h, Log.Prioridades.p4

;; Iniciar a configuração do terminal

    Hexagonix obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    Hexagonix limparTela
    
    Hexagonix obterInfoTela
    
    novaLinha

    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh

    call exibirBannerASH

    mov esi, ash.boasVindas
    
    imprimirString

;;************************************************************************************

.obterComando:  
   
    call exibirBannerASH
   
    Hexagonix obterCursor
    
    Hexagonix definirCursor
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHTerminal
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    mov esi, ash.prompt
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
    mov al, byte[Andromeda.Interface.numColunas]         ;; Máximo de caracteres para obter

    sub al, 20
    
    Hexagonix obterString
    
    Hexagonix cortarString           ;; Remover espaços em branco extras
        
    cmp byte[esi], 0                 ;; Nenhum comando inserido
    je .obterComando
    
;; Comparar com comandos internos disponíveis

    ;; Comando SAIR
    
    mov edi, comandos.sair  

    Hexagonix compararPalavrasString

    jc .finalizarShell

    ;; Comando VER
    
    mov edi, comandos.versao    

    Hexagonix compararPalavrasString

    jc .comandoVER

    ;; Comando AJUDA
    
    mov edi, comandos.ajuda 

    Hexagonix compararPalavrasString

    jc .comandoAJUDA
    
    ;; Comando AD
    
    mov edi, comandos.alterarDisco
    
    Hexagonix compararPalavrasString

    jc .comandoAD

;;************************************************************************************

;; Tentar carregar um programa
    
    call obterArgumentos              ;; Separar comando e argumentos
    
    push esi
    push edi
    
    jmp .carregarPrograma
    
.falhaExecutando:

;; Agora o erro enviado pelo sistema será analisado, para que o shell conheça
;; sua natureza

    cmp eax, Hexagon.limiteProcessos ;; Limite de processos em execução atingido
    je .limiteAtingido               ;; Se sim, exibir a mensagem apropriada
    
    cmp eax, Hexagon.imagemInvalida  ;; Limite de processos em execução atingido
    je .imagemHAPPInvalida           ;; Se sim, exibir a mensagem apropriada
    
    Hexagonix obterCursor
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHErro          
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    mov esi, ash.comandoInvalido
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
    jmp .obterComando   

.imagemHAPPInvalida:

    push esi
    
    novaLinha
    novaLinha
    
    pop esi
    
    imprimirString
    
    push ecx 

    xor ecx, ecx
    
    mov eax, ASHErro          
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx

    mov esi, ash.imagemInvalida
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor

    jmp .obterComando   

.limiteAtingido:

    logSistema ash.verboseLimite, 00h, Log.Prioridades.p4
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHLimiteProcessos        
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    mov esi, ash.limiteProcessos
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
    jmp .obterComando   

.carregarPrograma:
    
    pop edi

    mov esi, edi
    
    Hexagonix cortarString
    
    pop esi
    
    mov eax, edi
    
    stc
    
    Hexagonix iniciarProcesso
    
    jc .falhaExecutando
    
    jmp .obterComando

;;************************************************************************************
    
.comandoAJUDA:

    mov esi, ajuda.conteudoAjuda
    
    imprimirString
    
    jmp .obterComando

;;************************************************************************************

.comandoAD:
    
    push esi
    push edi

    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHAviso        
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    mov esi, discos.avisoSairdeLinha

    imprimirString

    mov ecx, 01h
    
    call alterarCor

    pop edi
    pop esi

    add esi, 02h
    
    Hexagonix cortarString
    
    mov edi, discos.hd0 
        
    Hexagonix compararPalavrasString
    
    jc .alterarParaHD0
    
    mov edi, discos.hd1 
        
    Hexagonix compararPalavrasString    
    
    jc .alterarParaHD1
    
    mov edi, discos.hd2 
    
    Hexagonix compararPalavrasString
    
    jc .alterarParaHD2
    
    mov edi, discos.hd3 
    
    Hexagonix compararPalavrasString    
    
    jc .alterarParaHD3
    
    mov edi, discos.info    
        
    Hexagonix compararPalavrasString
    
    jc .infoDisco
    
    jmp .erroAlterar

.alterarParaHD0:

    logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd0
    
    Hexagonix abrir

    novaLinha

    jmp .obterComando
    
.alterarParaHD1:

    logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd1
    
    Hexagonix abrir

    novaLinha

    jmp .obterComando

.alterarParaHD2:

    logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
    
    mov esi, discos.hd2
    
    Hexagonix abrir

    novaLinha

    jmp .obterComando

.alterarParaHD3:

    logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd3
    
    Hexagonix abrir

    novaLinha

    jmp .obterComando   
    
.erroAlterar:

    mov esi, discos.erroAlterar

    imprimirString

    jmp .obterComando   
    
.infoDisco:

    mov esi, discos.discoAtual
  
    imprimirString  
    
    Hexagonix obterDisco
    
    push edi
    push esi
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHPadrao
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    pop esi
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
    mov esi, discos.rotuloVolume
    
    imprimirString
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHPadrao
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    pop edi
    
    mov esi, edi
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
.novaLinha:
  
    novaLinha

    jmp .obterComando   

;;************************************************************************************
    
.comandoVER:
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHPadrao          
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    mov esi, ajuda.introducao
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor
    
    mov esi, ash.direitosAutorais
    
    imprimirString

    mov esi, ash.licenca
    
    imprimirString

    jmp .obterComando

;;************************************************************************************
    
.finalizarShell:

    logSistema ash.verboseSaida, 00h, Log.Prioridades.p4

    novaLinha

    mov ebx, 00h
    
    Hexagonix encerrarProcesso
    
    jmp .obterComando
    
    Hexagonix aguardarTeclado
    
    Hexagonix encerrarProcesso

;;************************************************************************************

;;************************************************************************************
;;
;; Fim dos comandos internos do ASH
;;
;; Funções úteis para o manipulação de dados no shell do ASH
;;
;;************************************************************************************

;; Separar nome de comando e argumentos
;;
;; Entrada:
;;
;; ESI - Endereço do comando
;; 
;; Saída:
;;
;; ESI - Endereço do comando
;; EDI - Argumentos do comando
;; CF  - Definido em caso de falta de extensão

obterArgumentos:

    push esi
    
.loop:

    lodsb           ;; mov AL, byte[ESI] & inc ESI
    
    cmp al, 0
    je .naoencontrado
    
    cmp al, ' '
    je .espacoEncontrado
    
    jmp .loop
    
.naoencontrado:

    pop esi
    
    mov edi, 0
    
    stc
    
    jmp .fim

.espacoEncontrado:

    mov byte[esi-1], 0
    mov ebx, esi
    
    Hexagonix tamanhoString
    
    mov ecx, eax
    
    inc ecx         ;; Incluindo o último caractere (NULL)
    
    push es
    
    push ds
    pop es
    
    mov esi, ebx
    mov edi, bufferArquivo
    
    rep movsb       ;; Copiar (ECX) caracteres da string de ESI para EDI
    
    pop es
    
    mov edi, bufferArquivo
    
    pop esi
    
    clc
    
.fim:

    ret
    
;;************************************************************************************

;; Altera a cor da fonte e do plano de fundo
;;
;; Entrada:
;;
;; EAX - Cor da fonte
;; EBX - Cor do plano de fundo
;; ECX - 01h para restaurar ao padrão do sistema
 
alterarCor:

    cmp ecx, 01h
    je .padrao
    
    Hexagonix definirCor
    
    ret
    
.padrao:

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    Hexagonix definirCor

    ret
    
;;************************************************************************************

exibirBannerASH:
    
    Hexagonix obterCursor
    
    push edx
    
    push ecx
    
    xor ecx, ecx

    mov eax, BRANCO_ANDROMEDA
    mov ebx, ASHPadrao
    
    call alterarCor
    
    pop ecx
    
    mov al, 0
    
    Hexagonix limparLinha
    
    mov esi, ash.bannerASH
    
    imprimirString
    
    mov ecx, 01h
    
    call alterarCor     
    
    pop edx 
    
    inc dh 

    mov dl, 00h

    Hexagonix definirCursor

    ret 

;;************************************************************************************

bufferArquivo:  ;; Endereço para carregamento de arquivos
