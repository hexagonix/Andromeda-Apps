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
;; Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.

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
;; Dados, variáveis e constantes utilizadas pelo Shell
;;
;;************************************************************************************

;; A versão do DOSsh é independente da versão do restante do Sistema.
;; Ela deve ser utilizada para identificar para qual versão do Andromeda® o DOSsh foi
;; desenvolvido. Essa informação pode ser fornecida com o comando 'ajuda'.

versaoDOSsh           equ "0.1" 
compativelAndromeda equ "H1 H1.R6 (Helius)"
                    
;;**************************

DOSsh:

.extensaoProgramas:  db ".app", 0 ;; Extensão de aplicativos (executáveis Hexagon®)
.comandoInvalido:    db 10, "Comando interno ou arquivo nao encontrado.", 10, 0
.boasVindas:         db "DOSsh, um shell no estilo DOS para o Hexagonix", 10, 10
                     db "Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes", 10
                     db "Todos os direitos reservados.", 10, 0
.direitosAutorais:   db 10, 10, "Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes", 10   
                     db "Todos os direitos reservados.", 10, 0
.limiteProcessos:    db 10, 10, "Nao existe memoria disponivel para executar o aplicativo solicitado.", 10
                     db "Tente primeiramente finalizar aplicativos ou suas instancias, e tente novamente.", 10, 0                    
.ponto:              db ".", 0
.imagemInvalida:     db ": nao e possivel carregar a imagem. Formato executavel nao suportado.", 10, 0
.prompt:             db "C:/> ", 0
.erroArquivo:        db 10, "Arquivo nao encontrado.", 10, 0

.extensaoCOW:        db ".COW",0
.extensaoMAN:        db ".MAN",0
.extensaoOCL:        db ".OCL",0

;; Verbose 

.verboseEntradaDOSsh: db "[DOSsh]: DOSsh para Andromeda versao ", compativelAndromeda, " ou superior.", 0
.verboseVersaoDOSsh:  db "[DOSsh]: DOSsh versao ", versaoDOSsh, ".", 0
.verboseAutor:        db "[DOSsh]: Copyright (C) 2022-", __stringano, " Felipe Miguel Nery Lunkes.", 0
.verboseDireitos:     db "[DOSsh]: Todos os direitos reservados.", 0
.verboseSaida:        db "[DOSsh]: Finalizando o DOSsh e retornando o controle ao processo pai...", 0
.verboseLimite:       db "[DOSsh]: Limite de memoria ou de processos atingido!", 0
.verboseInterfaceMountAntiga: db "[DOSsh]: Realizando manipulacao de pontos de montagem por funcao obsoleta e que sera removida.", 0

;;**************************

comandos:

.alterarDisco:  db "chdir", 0
.sair:          db "sair",0
.versao:        db "ver", 0
.ajuda:         db "ajuda", 0
.cls:           db "cls", 0
.dir:           db "dir", 0
.type:          db "type", 0

;;**************************

ajuda:

.introducao:    db 10, 10, "DOSsh versao ", versaoDOSsh, 10
                db "Compativel com Andromeda(R) ", compativelAndromeda, " ou superior.", 0
.conteudoAjuda: db 10, 10, "Comandos internos disponiveis:", 10, 10
                db " DIR  - Exibe os arquivos do volume atual.", 10
                db " TYPE - Exibe o conteudo de um arquivo fornecido como parametro.", 10
                db " CLS  - Limpa a tela (no caso do Hexagonix, o terminal aberto em vd0).", 10
                db " VER  - Exibe informacoes da versao do DOSsh em execucao.", 10
                db " SAIR - Finalizar essa sessao do DOSsh.", 10, 10, 0
             
;;**************************

discos:

.hd0:              db "hd0", 0
.hd1:              db "hd1", 0
.hd2:              db "hd2", 0
.hd3:              db "hd3", 0
.info:             db "info", 0
.discoAtual:       db 10, 10, "Volume atual utilizado pelo sistema: ", 0
.erroAlterar:      db 10, 10, "Um volume valido ou parametro nao foram fornecidos para este comando.", 10, 10
                   db "Impossivel alterar o volume Unix padrao.", 10, 10
                   db "Utilize como argumento um nome de dispositivo ou entao 'info' para informacoes do disco atual.", 10, 0
.rotuloVolume:     db 10, 10, "Rotulo do volume: ", 0
.avisoSairdeLinha: db 10, 10, "Aviso! Este e um comando interno obsoleto do DOSsh.", 10
                   db "Fique ciente que ele pode ser removido em breve. Em substituicao, utilize a ferramenta Unix 'mount'.", 10
                   db "Voce pode encontrar a documentacao da ferramenta digitando 'man mount' a qualquer momento.", 0
    
;;**************************
 
nomeArquivo: times 13 db 0  
discoAtual:  times 3  db 0        
listaRemanescente: dd ?
arquivoAtual:      dd ' '

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
    
    ;; Comando CHDIR
    
    mov edi, comandos.alterarDisco
    
    Hexagonix compararPalavrasString

    jc .comandoAD

    ;; Comando CLS
    
    mov edi, comandos.cls
    
    Hexagonix compararPalavrasString

    jc .comandoCLS

    ;; Comando DIR
    
    mov edi, comandos.dir
    
    Hexagonix compararPalavrasString

    jc .comandoDIR

    ;; Comando TYPE
    
    mov edi, comandos.type
    
    Hexagonix compararPalavrasString

    jc .comandoTYPE

;;************************************************************************************

;; Tentar carregar um programa
    
    call obterArgumentos              ;; Separar comando e argumentos
    
    push esi
    push edi
    
    Hexagonix tamanhoString
    
    add esi, eax

    sub esi, 4
    
    mov edi, DOSsh.extensaoProgramas
    
    Hexagonix compararPalavrasString  ;; Checar por extensão .APP
    
    jc .carregarPrograma
    
    pop edi
    pop esi
    
.semExtensao:
        
;; Tentar adicionar extensão

    Hexagonix tamanhoString
    
    mov ebx, eax

    mov al, byte[DOSsh.extensaoProgramas+0]
    
    mov byte[esi+ebx+0], al
    
    mov al, byte[DOSsh.extensaoProgramas+1]
    
    mov byte[esi+ebx+1], al
    
    mov al, byte[DOSsh.extensaoProgramas+2]
    
    mov byte[esi+ebx+2], al
    
    mov al, byte[DOSsh.extensaoProgramas+3]
    
    mov byte[esi+ebx+3], al
    
    mov byte[esi+ebx+4], 0      ;; Fim da string
    
    push esi
    push edi
    
    jmp .carregarPrograma
    
.falhaExecutando:

;; Agora o erro enviado pelo Sistema será analisado, para que o Shell conheça
;; sua natureza

    cmp eax, Hexagon.limiteProcessos ;; Limite de processos em execução atingido
    je .limiteAtingido               ;; Se sim, exibir a mensagem apropriada
    
    cmp eax, Hexagon.imagemInvalida  ;; Limite de processos em execução atingido
    je .imagemHAPPInvalida           ;; Se sim, exibir a mensagem apropriada
    
    Hexagonix obterCursor
    
    mov dl, byte[Andromeda.Interface.numColunas]    ;; Máximo de caracteres para obter

    sub dl, 17
    
    Hexagonix definirCursor
    
    mov esi, DOSsh.comandoInvalido
    
    imprimirString
    
    jmp obterComando   

.imagemHAPPInvalida:

    push esi

    Hexagonix obterCursor
    
    mov dl, byte[Andromeda.Interface.numColunas]    ;; Máximo de caracteres para obter

    sub dl, 17
    
    Hexagonix definirCursor
    
    novaLinha
    novaLinha
    
    pop esi
    
    imprimirString

    mov esi, DOSsh.imagemInvalida
    
    imprimirString

    jmp obterComando   

.limiteAtingido:

    logSistema DOSsh.verboseLimite, 00h, Log.Prioridades.p4

    Hexagonix obterCursor
    
    mov dl, byte[Andromeda.Interface.numColunas]    ;; Máximo de caracteres para obter

    sub dl, 17
    
    Hexagonix definirCursor
    
    mov esi, DOSsh.limiteProcessos
    
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
    
.comandoAJUDA:

    mov esi, ajuda.conteudoAjuda
    
    imprimirString
    
    jmp obterComando

;;************************************************************************************

.comandoCLS:

    Hexagonix limparTela
    
    jmp obterComando

;;************************************************************************************

.comandoDIR:
    
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

.comandoTYPE:
    
    call obterArgumentos

    push edi

    mov esi, edi

    Hexagonix arquivoExiste

    jc .erroArquivo

    mov esi, edi
    mov edi, bufferArquivo

    Hexagonix abrir
    
    jc .erroArquivo
    
    novaLinha
    novaLinha
    
    mov esi, bufferArquivo
    
    imprimirString

    novaLinha

    jmp obterComando

;;************************************************************************************

.comandoAD:
    
    push esi
    push edi
    
    mov esi, discos.avisoSairdeLinha

    imprimirString

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

    logSistema DOSsh.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd0
    
    Hexagonix abrir

    novaLinha

    jmp obterComando
    
.alterarParaHD1:

    logSistema DOSsh.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd1
    
    Hexagonix abrir

    novaLinha

    jmp obterComando

.alterarParaHD2:

    logSistema DOSsh.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
    
    mov esi, discos.hd2
    
    Hexagonix abrir

    novaLinha

    jmp obterComando

.alterarParaHD3:

    logSistema DOSsh.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4

    mov esi, discos.hd3
    
    Hexagonix abrir

    novaLinha

    jmp obterComando   
    
.erroAlterar:

    mov esi, discos.erroAlterar

    imprimirString

    jmp obterComando   
    
.infoDisco:

    mov esi, discos.discoAtual
  
    imprimirString  
    
    Hexagonix obterDisco
    
    push edi
    push esi
    
    pop esi
    
    imprimirString
    
    mov esi, discos.rotuloVolume
    
    imprimirString
    
    pop edi
    
    mov esi, edi
    
    imprimirString
    
.novaLinha:
  
    novaLinha

    jmp obterComando   

;;************************************************************************************
    
.comandoVER:
    
    mov esi, ajuda.introducao
    
    imprimirString
    
    mov esi, DOSsh.direitosAutorais
    
    imprimirString

    novaLinha

    jmp obterComando

;;************************************************************************************
    
.finalizarShell:

    logSistema DOSsh.verboseSaida, 00h, Log.Prioridades.p4

    novaLinha

    mov ebx, 00h
    
    Hexagonix encerrarProcesso
    
    jmp obterComando
    
    Hexagonix aguardarTeclado
    
    Hexagonix encerrarProcesso

;;************************************************************************************

.erroArquivo:

    mov esi, DOSsh.erroArquivo

    imprimirString

    jmp obterComando

;;************************************************************************************
;;
;; Fim dos comandos internos do Shell do Andromeda®
;;
;; Funções úteis para o manipulação de dados no Shell do Andromeda® 
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
;; de comando fornecida pelo Sistema

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

bufferArquivo:  ;; Endereço para carregamento de arquivos
