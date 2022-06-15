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

include "HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 9, 00, inicioAPP, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"

;;************************************************************************************

inicioAPP:

	Hexagonix obterCor

	mov dword[Andromeda.Interface.corFonte], eax
	mov dword[Andromeda.Interface.corFundo], ebx
	
	Hexagonix limparTela

	Hexagonix obterInfoTela
	
	mov byte[Andromeda.Interface.numColunas], bl
	mov byte[Andromeda.Interface.numLinhas], bh
	
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

	Andromeda.Estelar.criarInterface calc.titulo, calc.rodape, \
	VERDE_ESCURO, VERDE_ESCURO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
	
	mov esi, calc.bannerAndromeda

	imprimirString

	call mostrarLogoSistema

	cursorPara 00, 13

;;************************************************************************************

calcular:

;; Obter primeiro número

	mov esi, calc.primeiroNumero
	
	imprimirString
	
	call obterNumero
	
	mov dword[primeiroNumero], eax		;; Salvar primeiro número
	
	cmp eax, 0
	je fim

;; Obter segundo número
	
	mov esi, calc.segundoNumero
	
	imprimirString
	
	call obterNumero
	
	mov dword[segundoNumero], eax		;; Salvar segundo número
	
	cmp eax, 0
	je fim
	
;; Perguntar qual operação executar

	mov esi, calc.operacao
	
	imprimirString
	
	Hexagonix aguardarTeclado
	
	cmp al, '0'
	je adicionarNumeros
	
	cmp al, '1'
	je subtrair
	
	cmp al, '2'
	je multiplicar
	
	cmp al, '3'
	je dividir
	
	cmp al, '4'
	je fim

;;************************************************************************************

adicionarNumeros:

	mov eax, dword[primeiroNumero]
	mov ebx, dword[segundoNumero]
	
	add eax, ebx		;; EAX = EAX + EBX
	
	mov dword[resposta], eax
	
	jmp imprimirResposta

;;************************************************************************************
	
subtrair:

	mov eax, dword[primeiroNumero]
	mov ebx, dword[segundoNumero]
	
	sub eax, ebx		;; EAX = EAX - EBX
	
	mov dword[resposta], eax
	
	jmp imprimirResposta

;;************************************************************************************
	
multiplicar:

	mov eax, dword[primeiroNumero]
	mov ebx, dword[segundoNumero]
	
	mul ebx			    ;; EAX = EAX * EBX
	
	mov dword[resposta], eax
	
	jmp imprimirResposta

;;************************************************************************************
	
dividir:

	cmp ebx, 0
	je .dividirPorZero
		
	mov eax, dword[primeiroNumero]
	mov ebx, dword[segundoNumero]
	mov edx, 0
	
	div ebx			    ;; EAX = EAX / EBX
	
	mov dword[resposta], eax

	jmp imprimirResposta

;;************************************************************************************
	
.dividirPorZero:

	mov esi, calc.dividirPorZero
	
	imprimirString
	
	jmp imprimirResposta.proximo

;;************************************************************************************
	
imprimirResposta:

	novaLinha
	
	mov esi, calc.resultado
	
	imprimirString
	
	mov eax, dword[resposta]
	
	imprimirInteiro
	
.proximo:

	novaLinha
	novaLinha

	mov esi, calc.solicitarTecla
	
	imprimirString
	
	Hexagonix aguardarTeclado
	
	jmp inicioAPP

;;************************************************************************************
	
;; Obter um número do teclado
;;
;; Saída:
;;
;; EAX - Número

obterNumero:

	mov al, 10			;; Máximo de 10 caracteres
	
	Hexagonix obterString
	
	Hexagonix cortarString
	
	Hexagonix stringParaInt
	
	push eax
	
	novaLinha
	
	pop eax
	
	ret

;;************************************************************************************
	
fim:

	Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************

mostrarLogoSistema:
	
	Andromeda.Estelar.criarLogotipo VERDE_ESCURO, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
	
	ret

;;************************************************************************************

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "1.6.1"

calc:

.dividirPorZero:  db "Divisao por zero nao permitida!", 0
.primeiroNumero:  db "Entre com o primeiro numero (0 para sair): ", 0
.segundoNumero:   db "Entre com o segundo numero (0 para sair) : ", 0
.operacao:        db 10, "Entre com o codigo da operacao, de acordo com a lista abaixo:", 10, 10    
                  db "[0] SOMA (+)", 10
                  db "[1] SUB  (-)", 10
                  db "[2] MUL  (*)", 10
                  db "[3] DIV  (/)", 10
                  db "[4] SAIR", 10
				  db 10, "Opcao: ", 0 
.resultado:       db 10, 10, "O resultado e = ", 0
.solicitarTecla:  db 10, 10, "Pressione qualquer tecla para continuar...", 10, 10, 0

.bannerAndromeda: db 10, 10   
                  db "                                   Sistema Operacional Andromeda(R)", 10, 10, 10, 10
                  db "                           Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10
                  db "                                    Todos os direitos reservados", 0              
.marcaRegistrada: db "tm", 0

.titulo:          db "Calculadora basica do Sistema Operacional Andromeda(R)",0
.rodape:          db "[", VERSAO, "] | [F1] Sair",0

primeiroNumero:   dd 0
segundoNumero:	  dd 0
resposta:         dd 0

Andromeda.Interface Andromeda.Estelar.Interface 

