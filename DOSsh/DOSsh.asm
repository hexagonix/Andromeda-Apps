;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 sistema Operacional Hexagonix®
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
cabecalhoDOSsh cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioShell, 01h

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

;; A versão do DOSsh é independente da versão do restante do sistema.
;; Ela deve ser utilizada para identificar para qual versão do Hexagonix® o DOSsh foi
;; desenvolvido. Essa informação pode ser fornecida com o comando 'ajuda'.

versaoDOSsh         equ "0.4.5" 
compativelHexagonix equ "H2"
                    
;;**************************

DOSsh:

.extensaoProgramas:  db ".app", 0 ;; Extensão de aplicativos (executáveis Hexagon®)
.comandoInvalido:    db 10, "Internal command or file not found.", 10, 0
.boasVindas:         db "DOSsh, a DOS-style shell for Hexagonix", 10, 10
                     db "Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes", 10
                     db "All rights reserved.", 10, 0
.direitosAutorais:   db 10, 10, "Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes", 10   
                     db "All rights reserved.", 10, 0
.limiteProcessos:    db 10, 10, "There is not enough memory available to run the requested application.", 10
                     db "Try to terminate applications or their instances first, and try again.", 10, 0                    
.ponto:              db ".", 0
.imagemInvalida:     db ": unable to load image. Unsupported executable format.", 10, 0
.prompt:             db "C:/> ", 0
.erroGeralArquivo:   db 10, "File not found.", 10, 0
.licenca:            db 10, "Licenced under BSD-3-Clause.", 10, 0
.extensaoCOW:        db ".COW",0
.extensaoMAN:        db ".MAN",0
.extensaoOCL:        db ".OCL",0

;; Verbose 

.verboseEntradaDOSsh: db "[DOSsh]: DOSsh for Hexagonix version ", compativelHexagonix, " or superior.", 0
.verboseVersaoDOSsh:  db "[DOSsh]: DOSsh version ", versaoDOSsh, ".", 0
.verboseAutor:        db "[DOSsh]: Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes.", 0
.verboseDireitos:     db "[DOSsh]: All rights reserved.", 0
.verboseSaida:        db "[DOSsh]: Terminating DOSsh and returning control to the parent process...", 0
.verboseLimite:       db "[DOSsh]: Memory or process limit reached!", 0

DOSsh.comandos:

.sair:          db "exit",0
.versao:        db "ver", 0
.ajuda:         db "help", 0
.cls:           db "cls", 0
.dir:           db "dir", 0
.type:          db "type", 0

DOSsh.ajuda:

.introducao:    db 10, 10, "DOSsh version ", versaoDOSsh, 10
                db "Compatible with Hexagonix(R) ", compativelHexagonix, " or superior.", 0
.conteudoAjuda: db 10, 10, "Internal commands available:", 10, 10
                db " DIR  - Displays files on the current volume.", 10
                db " TYPE - Displays the contents of a file given as a parameter.", 10
                db " CLS  - Clears the screen (in the case of Hexagonix, the terminal opened at vd0).", 10
                db " VER  - Displays version information of DOSsh running.", 10
                db " EXIT - Terminate this DOSsh session.", 10, 10, 0
             
;;**************************
 
nomeArquivo: times 13 db 0  
discoAtual:  times 3  db 0        
listaRemanescente:    dd ?
arquivoAtual:         dd ' '

Andromeda.Interface Andromeda.Estelar.Interface

;;************************************************************************************

inicioShell:    

    logSistema DOSsh.verboseEntradaDOSsh, 00h, Log.Prioridades.p4
    logSistema DOSsh.verboseVersaoDOSsh, 00h, Log.Prioridades.p4
    logSistema DOSsh.verboseAutor, 00h, Log.Prioridades.p4
    logSistema DOSsh.verboseDireitos, 00h, Log.Prioridades.p4

;; Iniciar a configuração do terminal

    Hexagonix obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    Hexagonix limparTela
    
    Hexagonix obterInfoTela
    
    novaLinha

    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh

    mov esi, DOSsh.boasVindas
    
    imprimirString

    novaLinha

;;************************************************************************************

obterComando:  
    
    mov esi, DOSsh.prompt
    
    imprimirString
    
    mov al, byte[Andromeda.Interface.numColunas]         ;; Máximo de caracteres para obter

    sub al, 20
    
    Hexagonix obterString
    
    Hexagonix cortarString           ;; Remover espaços em branco extras
        
    cmp byte[esi], 0                 ;; Nenhum comando inserido
    je obterComando
    
;; Comparar com comandos internos disponíveis

    ;; Comando SAIR
    
    mov edi, DOSsh.comandos.sair  

    Hexagonix compararPalavrasString

    jc finalizarShell

    ;; Comando VER
    
    mov edi, DOSsh.comandos.versao    

    Hexagonix compararPalavrasString

    jc comandoVER

    ;; Comando AJUDA
    
    mov edi, DOSsh.comandos.ajuda 

    Hexagonix compararPalavrasString

    jc comandoAJUDA

    ;; Comando CLS
    
    mov edi, DOSsh.comandos.cls
    
    Hexagonix compararPalavrasString

    jc comandoCLS

    ;; Comando DIR
    
    mov edi, DOSsh.comandos.dir
    
    Hexagonix compararPalavrasString

    jc comandoDIR

    ;; Comando TYPE
    
    mov edi, DOSsh.comandos.type
    
    Hexagonix compararPalavrasString

    jc comandoTYPE

;;************************************************************************************

carregarImagem:

;; Tentar carregar um programa
    
    call obterArgumentos              ;; Separar comando e argumentos
    
    push esi
    push edi
    
    jmp .carregarPrograma
    
.falhaExecutando:

;; Agora o erro enviado pelo Sistema será analisado, para que o Shell conheça
;; sua natureza

    cmp eax, Hexagon.limiteProcessos ;; Limite de processos em execução atingido
    je .limiteAtingido               ;; Se sim, exibir a mensagem apropriada
    
    cmp eax, Hexagon.imagemInvalida
    je .imagemHAPPInvalida
    
    push esi
    
    novaLinha
    novaLinha
    
    pop esi
    
    imprimirString
    
    mov esi, DOSsh.comandoInvalido
    
    imprimirString
    
    jmp obterComando   
    
.limiteAtingido:
    
    mov esi, DOSsh.limiteProcessos
    
    imprimirString
    
    jmp obterComando   

.imagemHAPPInvalida:

    push esi
    
    novaLinha
    novaLinha
    
    pop esi
    
    imprimirString

    mov esi, DOSsh.imagemInvalida
    
    imprimirString
    
    jmp obterComando   

.carregarPrograma:
    
    pop edi

    mov esi, edi
    
    Hexagonix cortarString
    
    pop esi
    
    mov eax, edi
    
    stc
    
    Hexagonix iniciarProcesso
    
    jc .falhaExecutando
    
    jmp obterComando

;;************************************************************************************
    
comandoAJUDA:

    mov esi, DOSsh.ajuda.conteudoAjuda
    
    imprimirString
    
    jmp obterComando

;;************************************************************************************

comandoCLS:

    Hexagonix limparTela
    
    jmp obterComando

;;************************************************************************************

comandoDIR:
    
    Hexagonix listarArquivos    ;; Obter arquivos em ESI
    
   ;; jc .erroLista
    
    mov [listaRemanescente], esi
    
    push eax

    pop ebx

    xor ecx, ecx
    xor edx, edx

.loopArquivos:
    
    push ds
    pop es
    
    push ebx
    push ecx

    call lerListaArquivos
    
    push esi
    
    sub esi, 5
    
    mov edi, DOSsh.extensaoMAN
    
    Hexagonix compararPalavrasString  ;; Checar por extensão .MAN
    
    jc .ocultar

    mov edi, DOSsh.extensaoOCL
    
    Hexagonix compararPalavrasString  ;; Checar por extensão .OCL
    
    jc .ocultar

    mov edi, DOSsh.extensaoCOW
    
    Hexagonix compararPalavrasString  ;; Checar por extensão .COW
    
    jc .ocultar

    pop esi 

    mov esi, [arquivoAtual]
    
    imprimirString

    push ecx
    push ebx
    push eax

    novaLinha

    pop eax 
    pop ebx
    pop ecx 

    jmp .contar 

.ocultar:

    pop esi 

    inc ecx 

.contar:

    pop ecx
    pop ebx
    
    cmp ecx, ebx
    je .terminado

    inc ecx

    jmp .loopArquivos

.terminado:

    jmp obterComando

;;************************************************************************************

comandoTYPE:
    
    call obterArgumentos

    push edi

    mov esi, edi

    Hexagonix arquivoExiste

    jc erroGeralArquivo

    mov esi, edi
    mov edi, bufferArquivo

    Hexagonix abrir
    
    jc erroGeralArquivo
    
    novaLinha
    novaLinha
    
    mov esi, bufferArquivo
    
    imprimirString

    novaLinha

    jmp obterComando

;;************************************************************************************

comandoVER:
    
    mov esi, DOSsh.ajuda.introducao
    
    imprimirString
    
    mov esi, DOSsh.direitosAutorais
    
    imprimirString

    mov esi, DOSsh.licenca
    
    imprimirString

    novaLinha

    jmp obterComando

;;************************************************************************************
    
finalizarShell:

    logSistema DOSsh.verboseSaida, 00h, Log.Prioridades.p4

    novaLinha

    mov ebx, 00h
    
    Hexagonix encerrarProcesso
    
    jmp obterComando
    
    Hexagonix aguardarTeclado
    
    Hexagonix encerrarProcesso

;;************************************************************************************

erroGeralArquivo:

    mov esi, DOSsh.erroGeralArquivo

    imprimirString

    jmp obterComando

;;************************************************************************************
;;
;; Fim dos comandos internos do DOSsh
;;
;; Funções úteis para o manipulação de dados no shell do DOSsh
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

;; Obtem os parâmetros necessários para o funcionamento do programa, diretamente da linha
;; de comando fornecida pelo sistema

lerListaArquivos:

    push ds
    pop es
    
    mov esi, [listaRemanescente]
    mov [arquivoAtual], esi
    
    mov al, ' '
    
    Hexagonix encontrarCaractere
    
    jc .pronto

    mov al, ' '
    
    call encontrarCaractereListaArquivos
    
    mov [listaRemanescente], esi
    
    jmp .pronto
    
.pronto:

    clc
    
    ret

;;************************************************************************************  

;; Realiza a busca de um caractere específico na String fornecida
;;
;; Entrada:
;;
;; ESI - String à ser verificada
;; AL  - Caractere para procurar
;;
;; Saída:
;;
;; ESI - Posição do caractere na String fornecida

encontrarCaractereListaArquivos:

    lodsb
    
    cmp al, ' '
    je .pronto
    
    jmp encontrarCaractereListaArquivos
    
.pronto:

    mov byte[esi-1], 0
    
    ret

;;************************************************************************************

bufferArquivo:  ;; Endereço para carregamento de arquivos
