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

mostrarInterfaceConfiguracoes:	

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.configuracoes
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.configuracoes
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 02
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgConfig.introducao
	
	imprimirString
	
	mov dh, 05
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgConfig.introducao2
	
	imprimirString
	
	mov dh, 07
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgConfig.categoria1
	
	imprimirString
	
	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgConfig.categoria2
	
	imprimirString
	
	mov dh, 09
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgConfig.categoria3
	
	imprimirString
	
	mov dh, 10
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgConfig.categoria4
	
	imprimirString
	
	mov dh, 11
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgConfig.categoria5
	
	imprimirString
	
.obterTeclas:

	Andromeda aguardarTeclado
	
	cmp al, 'v'
	je mostrarInterfacePrincipal
	
	cmp al, 'V'
	je mostrarInterfacePrincipal
	
	cmp al, 'b'
	je mostrarInterfaceInfo
	
	cmp al, 'B'
	je mostrarInterfaceInfo
	
	cmp al, 'c'
	je finalizarAPP
	
	cmp al, 'C'
	je finalizarAPP
	
	cmp al, '1'
	je mostrarInterfaceConfigResolucao
	
	cmp al, '2'
	je mostrarInterfaceDiscos
	
	cmp al, '3'
	je mostrarInterfaceSerial
	
	cmp al, '4'
	je mostrarInterfacePortaParalela
	
	cmp al, '5'
	je mostrarInterfaceFonte


	jmp .obterTeclas		
