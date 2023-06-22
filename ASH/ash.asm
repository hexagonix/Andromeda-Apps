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
;;                    Sistema Operacional Hexagonix® - Hexagonix® Operating System
;;
;;                          Copyright © 2015-2023 Felipe Miguel Nery Lunkes
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

versaoASH           equ "4.3.2" 
compativelHexagonix equ "Raava-CURRENT"
                    
;;**************************

ASH:

.comandoInvalido:
db 10, 10, "[!] Invalid internal command or application not found.", 10, 0
.bannerASH:
db "ASH - Andromeda(R) SHell", 0
.boasVindas:
db "Welcome to Andromeda(R) SHell - ASH", 10, 10
db "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 10
db "All rights reserved.", 10, 0
.direitosAutorais:
db 10, 10, "Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes", 10   
db "All rights reserved.", 10, 0
.limiteProcessos:
db 10, 10, "[!] There is no memory available to run the requested application.", 10
db "[!] Try to terminate applications or their instances first, and try again.", 10, 0                    
.imagemInvalida:
db ": unable to load image. Unsupported executable format.", 10, 0
.prompt:
db "[/]: ", 0
.licenca:
db 10, "Licenced under BSD-3-Clause.", 10, 0

.verboseEntradaASH:
db "[ASH]: Starting Andromeda SHell (ASH) for Hexagonix ", compativelHexagonix, " or superior.", 0
.verboseVersaoASH:
db "[ASH]: Andromeda SHell version ", versaoASH, ".", 0
.verboseAutor:
db "[ASH]: Copyright (C) 2015-", __stringano, " Felipe Miguel Nery Lunkes.", 0
.verboseDireitos:
db "[ASH]: All rights reserved.", 0
.verboseSaida:
db "[ASH]: Terminating the ASH and returning control to the parent process...", 0
.verboseLimite:
db "[ASH]: [!] Memory or process limit reached!", 0
.verboseInterface:
db "[ASH]: [!!!] Performing manipulation of mount points by obsolete function that will be removed.", 0

;;**************************

ASH.comandos:

.alterarDisco:
db "ad", 0
.sair:
db "exit",0
.versao:
db "ver", 0
.ajuda:
db "help", 0

;;**************************

ASH.ajuda:

.introducao:
db 10, 10, "Andromeda SHell version ", versaoASH, 10
db "Compatible with Hexagonix(R) ", compativelHexagonix, " or superior.", 0
.conteudoAjuda:
db 10, 10, "Internal commands available:", 10, 10
db " VER  - Displays information about the running ASH version.", 10
db " EXIT - Terminate this ASH session.", 10, 0
             
;;**************************

ASH.discos:

.hd0:
db "hd0", 0
.hd1:
db "hd1", 0
.hd2:
db "hd2", 0
.hd3:
db "hd3", 0
.info:
db "info", 0
.discoAtual:
db 10, 10, "Current volume used by the system: ", 0
.erroAlterar:
db 10, 10, "A valid volume or parameter was not provided for this command.", 10, 10 
db "Cannot change default volume.", 10, 10
db "Use a device name as an argument or 'info' for current disk information.", 10, 0
.rotuloVolume:
db 10, 10, "Volume label: ", 0
.avisoSairdeLinha:
db 10, 10, "Warning! This is an obsolete built-in Andromeda SHell command.", 10
db "Be aware that it may be removed soon. Use the Unix 'mount' tool instead.", 10
db "You can find documentation for mount using 'man mount' anytime.", 0 
    
;;**************************
 
nomeArquivo: times 13 db 0  
discoAtual:  times 3  db 0        

Andromeda.Interface Andromeda.Estelar.Interface

;;************************************************************************************

inicioShell:    

    logSistema ASH.verboseEntradaASH, 00h, Log.Prioridades.p4
    logSistema ASH.verboseVersaoASH, 00h, Log.Prioridades.p4
    logSistema ASH.verboseAutor, 00h, Log.Prioridades.p4
    logSistema ASH.verboseDireitos, 00h, Log.Prioridades.p4

;; Iniciar a configuração do terminal

    hx.syscall obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    hx.syscall limparTela
    
    hx.syscall obterInfoTela
    
    novaLinha

    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh

    call exibirBannerASH

    fputs ASH.boasVindas

;;************************************************************************************

.obterComando:  
   
    call exibirBannerASH
   
    hx.syscall obterCursor
    
    hx.syscall definirCursor
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHTerminal
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    fputs ASH.prompt
        
    mov ecx, 01h
    
    call alterarCor
    
    mov al, byte[Andromeda.Interface.numColunas]         ;; Máximo de caracteres para obter

    sub al, 20
    
    hx.syscall obterString
    
    hx.syscall cortarString           ;; Remover espaços em branco extras
        
    cmp byte[esi], 0                 ;; Nenhum comando inserido
    je .obterComando
    
;; Comparar com comandos internos disponíveis

    ;; Comando SAIR
    
    mov edi, ASH.comandos.sair  

    hx.syscall compararPalavrasString

    jc .finalizarShell

    ;; Comando VER
    
    mov edi, ASH.comandos.versao    

    hx.syscall compararPalavrasString

    jc .comandoVER

    ;; Comando AJUDA
    
    mov edi, ASH.comandos.ajuda 

    hx.syscall compararPalavrasString

    jc .comandoAJUDA
    
    ;; Comando AD
    
    mov edi, ASH.comandos.alterarDisco
    
    hx.syscall compararPalavrasString

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
    
    hx.syscall obterCursor
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHErro          
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    fputs ASH.comandoInvalido
        
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

    fputs ASH.imagemInvalida
        
    mov ecx, 01h
    
    call alterarCor

    jmp .obterComando   

.limiteAtingido:

    logSistema ASH.verboseLimite, 00h, Log.Prioridades.p4
    
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHLimiteProcessos        
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    fputs ASH.limiteProcessos
        
    mov ecx, 01h
    
    call alterarCor
    
    jmp .obterComando   

.carregarPrograma:
    
    pop edi

    mov esi, edi
    
    hx.syscall cortarString
    
    pop esi
    
    mov eax, edi
    
    stc
    
    hx.syscall iniciarProcesso
    
    jc .falhaExecutando
    
    jmp .obterComando

;;************************************************************************************
    
.comandoAJUDA:

    fputs ASH.ajuda.conteudoAjuda
        
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
    
    fputs ASH.discos.avisoSairdeLinha

    mov ecx, 01h
    
    call alterarCor

    pop edi
    pop esi

    add esi, 02h
    
    hx.syscall cortarString
    
    mov edi, ASH.discos.hd0 
        
    hx.syscall compararPalavrasString
    
    jc .alterarParaHD0
    
    mov edi, ASH.discos.hd1 
        
    hx.syscall compararPalavrasString    
    
    jc .alterarParaHD1
    
    mov edi, ASH.discos.hd2 
    
    hx.syscall compararPalavrasString
    
    jc .alterarParaHD2
    
    mov edi, ASH.discos.hd3 
    
    hx.syscall compararPalavrasString    
    
    jc .alterarParaHD3
    
    mov edi, ASH.discos.info    
        
    hx.syscall compararPalavrasString
    
    jc .infoDisco
    
    jmp .erroAlterar

.alterarParaHD0:

    logSistema ASH.verboseInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.discos.hd0
    
    hx.syscall abrir

    novaLinha

    jmp .obterComando
    
.alterarParaHD1:

    logSistema ASH.verboseInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.discos.hd1
    
    hx.syscall abrir

    novaLinha

    jmp .obterComando

.alterarParaHD2:

    logSistema ASH.verboseInterface, 00h, Log.Prioridades.p4
    
    mov esi, ASH.discos.hd2
    
    hx.syscall abrir

    novaLinha

    jmp .obterComando

.alterarParaHD3:

    logSistema ASH.verboseInterface, 00h, Log.Prioridades.p4

    mov esi, ASH.discos.hd3
    
    hx.syscall abrir

    novaLinha

    jmp .obterComando   
    
.erroAlterar:

    fputs ASH.discos.erroAlterar

    jmp .obterComando   
    
.infoDisco:

    fputs ASH.discos.discoAtual  
    
    hx.syscall obterDisco
    
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
    
    fputs ASH.discos.rotuloVolume
        
    push ecx
    
    xor ecx, ecx
    
    mov eax, ASHPadrao
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    call alterarCor
    
    pop ecx
    
    pop edi
    
    fputs edi
        
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
    
    fputs ASH.ajuda.introducao
        
    mov ecx, 01h
    
    call alterarCor
    
    fputs ASH.direitosAutorais

    fputs ASH.licenca
    
    jmp .obterComando

;;************************************************************************************
    
.finalizarShell:

    logSistema ASH.verboseSaida, 00h, Log.Prioridades.p4

    novaLinha

    mov ebx, 00h
    
    hx.syscall encerrarProcesso
    
    jmp .obterComando
    
    hx.syscall aguardarTeclado
    
    hx.syscall encerrarProcesso

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
    
    hx.syscall tamanhoString
    
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
    
    hx.syscall definirCor
    
    ret
    
.padrao:

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    hx.syscall definirCor

    ret
    
;;************************************************************************************

exibirBannerASH:
    
    hx.syscall obterCursor
    
    push edx
    
    push ecx
    
    xor ecx, ecx

    mov eax, BRANCO_ANDROMEDA
    mov ebx, ASHPadrao
    
    call alterarCor
    
    pop ecx
    
    mov al, 0
    
    hx.syscall limparLinha
    
    fputs ASH.bannerASH
    
    mov ecx, 01h
    
    call alterarCor     
    
    pop edx 
    
    inc dh 

    mov dl, 00h

    hx.syscall definirCursor

    ret 

;;************************************************************************************

bufferArquivo:  ;; Endereço para carregamento de arquivos
