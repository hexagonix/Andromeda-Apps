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

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.inicio
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.inicio
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor

	call mostrarLogoSistema
	
	mov dh, 02
	mov dl, 34
	
	Andromeda definirCursor

	mov esi, msgInicio.introducao
	
    imprimirString	

	mov dh, 04
	mov dl, 18
	
	Andromeda definirCursor

	mov esi, msgInicio.nomeSistema
	
	imprimirString
	
	mov esi, nomeSistema
	
	imprimirString

	mov dh, 05
	mov dl, 18
	
	Andromeda definirCursor

	mov esi, msgInicio.versaoSistema
	
	imprimirString
	
	call imprimirVersao
	
	mov esi, msgInicio.versao
	imprimirString

	mov dh, 06
	mov dl, 18
	
	Andromeda definirCursor

	mov esi, msgInicio.tipoSistema
	
	imprimirString

	mov dh, 08
	mov dl, 18
	
	Andromeda definirCursor

	mov esi, msgInicio.copyrightAndromeda
	
	imprimirString

	mov dh, 09
	mov dl, 18
	
	Andromeda definirCursor

	mov esi, msgInicio.direitosReservados
	
	imprimirString

	mov dh, 11
	mov dl, 28
	
	Andromeda definirCursor

	mov esi, msgInicio.separador
	
	imprimirString

	mov dh, 13
	mov dl, 39
	
	Andromeda definirCursor

	mov esi, msgInicio.sobrePC
	
	imprimirString

	mov dh, 15
	mov dl, 02
	
	Andromeda definirCursor

	mov esi, msgInicio.processadorPrincipal
	
	imprimirString

	mov dh, 16
	mov dl, 04
	
	Andromeda definirCursor

	mov esi, msgInicio.numProcessador
	
	imprimirString

	mov esi, processadores.proc0
	
	Andromeda abrir
    
    imprimirString

	mov dh, 17
	mov dl, 08
	
	Andromeda definirCursor

	mov esi, msgInicio.operacaoProcessador
	
	imprimirString

	mov dh, 18
	mov dl, 02
	
	Andromeda definirCursor
	
	mov dh, 19
	mov dl, 02
	
	Andromeda definirCursor

	mov esi, msgInfo.memoriaDisponivel
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	Andromeda usoMemoria
	
	mov eax, ecx
	
	imprimirInteiro
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgInfo.kbytes
	
	imprimirString
	
.obterTeclas:

	Andromeda aguardarTeclado
	
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
	
	
