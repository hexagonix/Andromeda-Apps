;;************************************************************************************
;;
;;    
;;        %#@$%&@$%&@$%$             Sistema Operacional Andromeda®
;;        #$@$@$@#@#@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$    !@#@#     Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;;        @#@%!$&%$&$#@#             Todos os direitos reservados
;;        !@$%#%&#&@&$%#
;;        @$#!%&@&@#&*@&
;;        $#$#%    &%$#@
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************

use32

;; Agora vamos criar um cabeçalho para a imagem HAPP final do aplicativo. Anteriormente,
;; o cabeçalho era criado em cada imagem e poderia diferir de uma para outra. Caso algum
;; campo da especificação HAPP mudasse, os cabeçalhos de todos os aplicativos deveriam ser
;; alterados manualmente. Com uma estrutura padronizada, basta alterar um arquivo que deve
;; ser incluído e montar novamente o aplicativo, sem a necessidade de alterar manualmente
;; arquivo por arquivo. O arquivo contém uma estrutura instanciável com definição de 
;; parâmetros no momento da instância, tornando o cabeçalho tão personalizável quanto antes.

include "../../../LibAPP/HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoASH cabecalhoHAPP HAPP.Arquiteturas.i386, 8, 58, inicioShell, 01h

;;************************************************************************************

include "../../../LibAPP/hexagon.s"
include "../../../LibAPP/Estelar/estelar.s"
include "../../../LibAPP/erros.s"
include "../../../LibAPP/log.s"
include "../../../LibAPP/macros.s"

align 32

;;************************************************************************************
;;
;; Dados, variáveis e constantes utilizadas pelo Shell
;;
;;************************************************************************************

;; A versão do ASH é independente da versão do restante do Sistema.
;; Ela deve ser utilizada para identificar para qual versão do Andromeda® o ASH foi
;; desenvolvido. Essa informação pode ser fornecida com o comando 'ajuda'.

ASHPadrao          = VERDE_MAR
ASHTerminal        = VERDE_MAR
ASHAviso           = TOMATE
ASHErro            = VERMELHO_TIJOLO
ASHLimiteProcessos = AMARELO_ANDROMEDA
ASHSucesso         = VERDE

versaoASH           equ "3.4-beta" 
compativelAndromeda equ "1.0.4-beta"
                    
;;**************************

ash:

.prompt:             db "[/]: ", 0
.extensaoProgramas:  db ".app", 0 ;; Extensão de aplicativos (executáveis Hexagon®)
.comandoInvalido:    db 10, 10, "[!] Comando interno invalido ou aplicativo no formato HAPP nao encontrado.", 10, 0
.bannerASH:          db "ASH - Andromeda(R) SHell", 0
.boasVindas:         db "Seja Bem Vindo ao Andromeda(R) SHell - ASH", 10, 10
                     db "Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10
			         db "Todos os direitos reservados.", 10, 0
.versaoAndromeda:    db 10, 10, "Sistema Operacional Andromeda(R)", 10 
                     db "Versao ", 0
.direitosAutorais:   db 10, 10, "Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10   
                     db "Todos os direitos reservados.", 10, 0
.limiteProcessos:    db 10, 10, "[!] Nao existe memoria disponivel para executar o aplicativo solicitado.", 10
                     db "[!] Tente primeiramente finalizar aplicativos ou suas instancias, e tente novamente.", 10, 0		             
.ponto:              db ".", 0
.imagemInvalida:     db ": nao e possivel carregar a imagem. Formato executavel nao suportado.", 10, 0

match =SIM, VERBOSE
{

.verboseEntradaASH: db "[ASH]: Iniciando o Andromeda SHell (ASH) para Andromeda ", compativelAndromeda, " ou superior.", 0
.verboseVersaoASH:  db "[ASH]: Andromeda SHell versao ", versaoASH, ".", 0
.verboseAutor:      db "[ASH]: Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes.", 0
.verboseDireitos:   db "[ASH]: Todos os direitos reservados.", 0
.verboseSaida:      db "[ASH]: Finalizando o ASH e retornando o controle ao processo pai...", 0
.verboseLimite:     db "[ASH]: [!] Limite de memoria ou de processos atingido!", 0
.verboseInterfaceMountAntiga: db "[ASH]: [!!!] Realizando manipulacao de pontos de montagem por funcao obsoleta e que sera removida.", 0

}

;;**************************

comandos:

.alterarDisco:  db "ad", 0
.sair:		    db "sair",0
.versao:	    db "ver", 0
.ajuda:		    db "ajuda", 0

;;**************************

ajuda:

.introducao:    db 10, 10, "Andromeda SHell versao ", versaoASH, 10
                db "Compativel com Andromeda(R) ", compativelAndromeda, " ou superior.", 0
.conteudoAjuda: db 10, 10, "Comandos internos disponiveis:", 10, 10
				db " VER  - Exibe informacoes da versao do ASH em execucao.", 10
				db " SAIR - Finalizar essa sessao do ASH.", 10, 10
				db "Tente digitar 'ls' para ver outros utilitarios e aplicativos disponiveis!", 10, 0
		     
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
.avisoSairdeLinha: db 10, 10, "Aviso! Este e um comando interno obsoleto do Andromeda SHell.", 10
                   db "Fique ciente que ele pode ser removido em breve. Em substituicao, utilize a ferramenta Unix 'mount'.", 10
				   db "Voce pode encontrar a documentacao da ferramenta digitando 'man mount' a qualquer momento.", 0
	
;;**************************
 
nomeArquivo: times 13 db 0	

discoAtual:  times 3  db 0		  

Andromeda.Interface Andromeda.Estelar.Interface

;;************************************************************************************

inicioShell:	

match =SIM, VERBOSE
{

	logSistema ash.verboseEntradaASH, 00h, Log.Prioridades.p4
	logSistema ash.verboseVersaoASH, 00h, Log.Prioridades.p4
	logSistema ash.verboseAutor, 00h, Log.Prioridades.p4
	logSistema ash.verboseDireitos, 00h, Log.Prioridades.p4

}

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
	
	mov al, byte[Andromeda.Interface.numColunas]		 ;; Máximo de caracteres para obter

	sub al, 20
	
	Hexagonix obterString
	
	Hexagonix cortarString			 ;; Remover espaços em branco extras
		
	cmp byte[esi], 0		         ;; Nenhum comando inserido
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
	
	call obterArgumentos		      ;; Separar comando e argumentos
	
	push esi
	push edi
	
	Hexagonix tamanhoString
	
	add esi, eax

	sub esi, 4
	
	mov edi, ash.extensaoProgramas
	
	Hexagonix compararPalavrasString  ;; Checar por extensão .APP
	
	jc .carregarPrograma
	
	pop edi
	pop esi
	
.semExtensao:
		
;; Tentar adicionar extensão

	Hexagonix tamanhoString
	
	mov ebx, eax

	mov al, byte[ash.extensaoProgramas+0]
	
	mov byte[esi+ebx+0], al
	
	mov al, byte[ash.extensaoProgramas+1]
	
	mov byte[esi+ebx+1], al
	
	mov al, byte[ash.extensaoProgramas+2]
	
	mov byte[esi+ebx+2], al
	
	mov al, byte[ash.extensaoProgramas+3]
	
	mov byte[esi+ebx+3], al
	
	mov byte[esi+ebx+4], 0		;; Fim da string
	
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

	Hexagonix obterCursor
	
	mov dl, byte[Andromeda.Interface.numColunas]    ;; Máximo de caracteres para obter

	sub dl, 17
	
	Hexagonix definirCursor
	
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

match =SIM, VERBOSE
{

	logSistema ash.verboseLimite, 00h, Log.Prioridades.p4
	
}

	Hexagonix obterCursor
	
	mov dl, byte[Andromeda.Interface.numColunas]    ;; Máximo de caracteres para obter

	sub dl, 17
	
	Hexagonix definirCursor
	
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

match =SIM, VERBOSE
{

	logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
	
}

    mov esi, discos.hd0
	
    Hexagonix abrir

	novaLinha

    jmp .obterComando
	
.alterarParaHD1:

match =SIM, VERBOSE
{

	logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
	
}

    mov esi, discos.hd1
	
    Hexagonix abrir

	novaLinha

    jmp .obterComando

.alterarParaHD2:

match =SIM, VERBOSE
{

	logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
	
}

    mov esi, discos.hd2
	
    Hexagonix abrir

	novaLinha

    jmp .obterComando

.alterarParaHD3:

match =SIM, VERBOSE
{

	logSistema ash.verboseInterfaceMountAntiga, 00h, Log.Prioridades.p4
	
}

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

	jmp .obterComando

;;************************************************************************************
	
.finalizarShell:

match =SIM, VERBOSE
{

	logSistema ash.verboseSaida, 00h, Log.Prioridades.p4

}

	novaLinha

	mov ebx, 00h
	
	Hexagonix encerrarProcesso
	
	jmp .obterComando
	
	Hexagonix aguardarTeclado
	
	Hexagonix encerrarProcesso

;;************************************************************************************

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

	lodsb			;; mov AL, byte[ESI] & inc ESI
	
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
	
	inc ecx			;; Incluindo o último caractere (NULL)
	
	push es
	
	push ds
	pop es
	
	mov esi, ebx
	mov edi, bufferArquivo
	
	rep movsb		;; Copiar (ECX) caracteres da string de ESI para EDI
	
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
;; ECX - 01h para restaurar ao padrão do Sistema
 
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

	Hexagonix definirCursor

	ret 

;;************************************************************************************

bufferArquivo:  ;; Endereço para carregamento de arquivos
