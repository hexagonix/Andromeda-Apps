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

mostrarInterfaceInfo:	

	Hexagonix limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Hexagonix definirCor
	
	mov al, 0
	Hexagonix limparLinha
	
	mov esi, TITULO.info
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, RODAPE.info
	
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
	mov dl, 20
	
	Hexagonix definirCursor

	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgInfo.introducao
	
    imprimirString	

	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov dh, 04
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.nomeSistema
	
	imprimirString
	
	mov esi, nomeSistema
	
	imprimirString
	
	mov dh, 05
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.versaoSistema
	
	imprimirString
	
	call imprimirVersao
	
	mov al, ' '

	Hexagonix imprimirCaractere

	mov al, '['

	Hexagonix imprimirCaractere

	mov esi, codigoObtido

	imprimirString

	mov al, ']'

	Hexagonix imprimirCaractere

	mov dh, 06
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.buildSistema
	
	imprimirString
	
	mov esi, buildObtida
	
	imprimirString
	
	mov dh, 07
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.tipoSistema
	
	imprimirString
	
	mov esi, msgInfo.modeloSistema
	
	imprimirString
	
	mov dh, 08
	mov dl, 18
	
	Hexagonix definirCursor
 
    mov esi, msgInfo.pacoteAtualizacoes
    
	imprimirString
	
	mov esi, pacoteAtualizacoes
	
	imprimirString
    
    mov al, ' '
    
    Hexagonix imprimirCaractere
    
    mov esi, dataHora

	imprimirString

;; Agora vamos exibir informações sobre o Hexagon

	mov dh, 09
	mov dl, 18
	
	Hexagonix definirCursor
 
    mov esi, msgInfo.Hexagon
    
	imprimirString

	Hexagonix retornarVersao
	
	push ecx
	push ebx
	
	imprimirInteiro
	
	mov esi, msgInfo.ponto
	
	imprimirString
	
	pop eax
	
	imprimirInteiro
	
	pop ecx
	
	mov al, ch
	
	Hexagonix imprimirCaractere

;; Voltamos à programação normal

	mov dh, 11
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, nomeSistema
	
	imprimirString
 
    mov dh, 13
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.copyrightAndromeda
	
	imprimirString
	
	mov dh, 14
	mov dl, 18
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.direitosReservados
	
	imprimirString
	
	mov dh, 16
	mov dl, 28
	
	Hexagonix definirCursor
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgInfo.introducaoHardware
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov dh, 18
	mov dl, 02
	
	Hexagonix definirCursor
	
	mov esi, msgInfo.processadorPrincipal
	
	imprimirString

	mov dh, 19
	mov dl, 04
	
	Hexagonix definirCursor

	mov esi, msgInfo.numProcessador
	
	imprimirString

	mov esi, processadores.proc0
	
	Hexagonix abrir
    
    imprimirString
	
	mov dh, 20
	mov dl, 08
	
	Hexagonix definirCursor

	mov esi, msgInfo.operacaoProcessador
	
	imprimirString
	
	mov dh, 22
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
	
	cmp al, 'v'
	je mostrarInterfacePrincipal
	
	cmp al, 'V'
	je mostrarInterfacePrincipal
	
	cmp al, 'b'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'B'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'c'
	je finalizarAPP
	
	cmp al, 'C'
	je finalizarAPP

	jmp .obterTeclas		
	
