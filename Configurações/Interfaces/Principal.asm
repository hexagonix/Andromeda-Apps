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
	
	mov dh, 02
	mov dl, 34
	
	Hexagonix definirCursor

	mov esi, msgInicio.introducao
	
    imprimirString	

	mov dh, 04
	mov dl, 18
	
	Hexagonix definirCursor

	mov esi, msgInicio.nomeSistema
	
	imprimirString
	
	mov esi, nomeSistema
	
	imprimirString

	mov dh, 05
	mov dl, 18
	
	Hexagonix definirCursor

	mov esi, msgInicio.versaoSistema
	
	imprimirString
	
	call imprimirVersao
	
	mov esi, msgInicio.versao
	imprimirString

	mov dh, 06
	mov dl, 18
	
	Hexagonix definirCursor

	mov esi, msgInicio.tipoSistema
	
	imprimirString

	mov dh, 08
	mov dl, 18
	
	Hexagonix definirCursor

	mov esi, msgInicio.copyrightAndromeda
	
	imprimirString

	mov dh, 09
	mov dl, 18
	
	Hexagonix definirCursor

	mov esi, msgInicio.direitosReservados
	
	imprimirString

	mov dh, 11
	mov dl, 28
	
	Hexagonix definirCursor

	mov esi, msgInicio.separador
	
	imprimirString

	mov dh, 13
	mov dl, 39
	
	Hexagonix definirCursor

	mov esi, msgInicio.sobrePC
	
	imprimirString

	mov dh, 15
	mov dl, 02
	
	Hexagonix definirCursor

	mov esi, msgInicio.processadorPrincipal
	
	imprimirString

	mov dh, 16
	mov dl, 04
	
	Hexagonix definirCursor

	mov esi, msgInicio.numProcessador
	
	imprimirString

	mov esi, processadores.proc0
	
	Hexagonix abrir
    
    imprimirString

	mov dh, 17
	mov dl, 08
	
	Hexagonix definirCursor

	mov esi, msgInicio.operacaoProcessador
	
	imprimirString

	mov dh, 18
	mov dl, 02
	
	Hexagonix definirCursor
	
	mov dh, 19
	mov dl, 02
	
	Hexagonix definirCursor

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
	
	
