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

	Hexagonix limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Hexagonix definirCor
	
	mov al, 0
	Hexagonix limparLinha
	
	mov esi, TITULO.configuracoes
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, RODAPE.configuracoes
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	cursorPara 02, 02
	
	mov esi, msgConfig.introducao
	
	imprimirString
	
	cursorPara 02, 05
	
	mov esi, msgConfig.introducao2
	
	imprimirString
	
	cursorPara 04, 07 
	
	mov esi, msgConfig.categoria1
	
	imprimirString
	
	cursorPara 04, 08
	
	mov esi, msgConfig.categoria2
	
	imprimirString
	
    cursorPara 04, 09 
	
	mov esi, msgConfig.categoria3
	
	imprimirString
	
    cursorPara 04, 10
	
	mov esi, msgConfig.categoria4
	
	imprimirString
	
    cursorPara 04, 11
	
	mov esi, msgConfig.categoria5
	
	imprimirString
	
.obterTeclas:

	Hexagonix aguardarTeclado
	
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
