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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 8, 40, inicioAPP, 01h

;;************************************************************************************

include "../../../LibAPP/andrmda.s"
include "../../../LibAPP/Estelar/estelar.s"
include "../../../LibAPP/macros.s"

;;************************************************************************************

inicioAPP:

	Andromeda obterCor

	mov dword[Andromeda.Interface.corFonte], eax
	mov dword[Andromeda.Interface.corFundo], ebx

	Andromeda limparTela

	Andromeda obterInfoTela
	
	mov byte[Andromeda.Interface.numColunas], bl
	mov byte[Andromeda.Interface.numLinhas], bh
	
;; Imprime o título do programa e rodapé.
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

	Andromeda.Estelar.criarInterface serial.titulo, serial.rodape, \
	AZUL_ROYAL, AZUL_ROYAL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

	Andromeda definirCor
	
	mov dl, 2
	mov dh, 1
	
	Andromeda definirCursor
	
	mov esi, serial.bannerAndromeda

	imprimirString

	Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

	mov dh, 10
	mov dl, 02
	
	Andromeda definirCursor

	mov esi, serial.nomePorta
	
	Andromeda abrir
	
	jc erroAbertura
	
	novaLinha

	mov esi, serial.ajuda
	
	imprimirString
	
	mov esi, serial.prompt
	
	imprimirString
	
	mov esi, serial.separador
	
	imprimirString

    mov al, byte[Andromeda.Interface.numColunas]		;; Máximo de caracteres para obter

	sub al, 20
	
	Andromeda obterString
	
	;; Andromeda cortarString			;; Remover espaços em branco extras
	
	mov [msg], esi
	
	mov si, [msg]
	
	Andromeda escrever
	
	jc erro
	
	mov eax, VERDE_FLORESTA
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor
	
	mov esi, serial.enviado
	
	imprimirString
	
	mov esi, serial.prompt
	
	imprimirString
	
	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor
	
	novaLinha
	novaLinha
	
	jmp obterTeclas

;;************************************************************************************

obterTeclas:

	Andromeda aguardarTeclado
	
	push eax
	
	Andromeda obterEstadoTeclas
	
	bt eax, 0
	jc .teclasControl
	
	pop eax
	
	jmp obterTeclas
	
.teclasControl:

	pop eax
	
	cmp al, 'n'
	je inicioAPP
	
	cmp al, 'N'
	je inicioAPP
	
	cmp al, 's'
	je Andromeda_Sair
	
	cmp al, 'S'
	je Andromeda_Sair

	jmp obterTeclas	

;;************************************************************************************

Andromeda_Sair:

	Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************

erro:

	mov esi, serial.erroPorta
	
	imprimirString

	Andromeda aguardarTeclado

	Andromeda limparTela

	Andromeda encerrarProcesso

;;************************************************************************************

erroAbertura:

	mov esi, serial.erroAbertura
	
	imprimirString

	Andromeda aguardarTeclado

	jmp Andromeda_Sair

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

serial:

.erroPorta:       db 10, 10, "Nao foi possivel utilizar a porta serial.", 10, 0
.erroAbertura:    db 10, 10, "Nao foi possivel abrir o dispositivo para gravacao.", 10, 0
.bannerAndromeda: db 10, 10   
                  db "                                   Sistema Operacional Andromeda(R)", 10, 10, 10, 10
                  db "                           Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10
                  db "                                    Todos os direitos reservados", 0              
.ajuda:           db 10, 10, "Este aplicativo ira te auxiliar a escrever dados via porta serial.", 10, 10, 10, 10, 0
.prompt:          db "[com1]", 0
.separador:       db ": ", 0 
.nomePorta:       db "com1", 0    
.enviado:         db 10, 10, "Dados enviados via porta serial ", 0
.titulo:          db "Utilitario de envio de dados via porta serial do Sistema Operacional Andromeda(R)", 0
.rodape:          db "[BETA] | [^N] Nova mensagem  [^S] Sair", 0

Andromeda.Interface Andromeda.Estelar.Interface

msg:              db 0
