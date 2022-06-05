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

mostrarInterfacePrincipal:	

	Hexagonix limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Hexagonix definirCor
	
	mov al, 0
	Hexagonix limparLinha
	
	mov esi, TITULO.inicio
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, RODAPE.inicio
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor

	call mostrarLogoSistema
	
    cursorPara 34, 02

	mov esi, msgInicio.introducao
	
    imprimirString	

    cursorPara 18, 04

	mov esi, msgInicio.nomeSistema
	
	imprimirString
	
	mov esi, nomeSistema
	
	imprimirString

    cursorPara 18, 05

	mov esi, msgInicio.versaoSistema
	
	imprimirString
	
	call imprimirVersao
	
	mov esi, msgInicio.versao
	imprimirString

    cursorPara 18, 06

	mov esi, msgInicio.tipoSistema
	
	imprimirString

    cursorPara 18, 08

	mov esi, msgInicio.copyrightAndromeda
	
	imprimirString

    cursorPara 18, 09

	mov esi, msgInicio.direitosReservados
	
	imprimirString

    cursorPara 28, 11

	mov esi, msgInicio.separador
	
	imprimirString

    cursorPara 39, 13

	mov esi, msgInicio.sobrePC
	
	imprimirString

    cursorPara 02, 15

	mov esi, msgInicio.processadorPrincipal
	
	imprimirString

    cursorPara 04, 16

	mov esi, msgInicio.numProcessador
	
	imprimirString

	call exibirProcessadorInstalado

    cursorPara 08, 17

	mov esi, msgInicio.operacaoProcessador
	
	imprimirString
	
    cursorPara 02, 19

	mov esi, msgInfo.memoriaDisponivel
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	Hexagonix usoMemoria
	
	mov eax, ecx
	
	imprimirInteiro
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgInfo.kbytes
	
	imprimirString
	
.obterTeclas:

	Hexagonix aguardarTeclado
	
	cmp al, 'a'
	je mostrarInterfaceInfo
	
	cmp al, 'A'
	je mostrarInterfaceInfo
	
	cmp al, 'b'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'B'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'c'
	je finalizarAPP
	
	cmp al, 'C'
	je finalizarAPP

	jmp .obterTeclas		
	
	
