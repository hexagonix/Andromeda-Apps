;;************************************************************************************
;;
;;    
;;        %#@$%&@$%&@$%$             Sistema Operacional Andromeda®
;;        #$@$@$@#@#@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$    !@#@#     Copyright © 2016-2021 Felipe Miguel Nery Lunkes
;;        @#@%!$&%$&$#@#             Todos os direitos reservados
;;        !@$%#%&#&@&$%#
;;        @$#!%&@&@#&*@&
;;        $#$#%    &%$#@
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************

mostrarInterfaceInfo:	

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.info
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.info
	
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
	mov dl, 20
	
	Andromeda definirCursor

	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgInfo.introducao
	
    imprimirString	

	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 04
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.nomeSistema
	
	imprimirString
	
	mov esi, nomeSistema
	
	imprimirString
	
	mov dh, 05
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.versaoSistema
	
	imprimirString
	
	call imprimirVersao
	
	mov al, ' '

	Andromeda imprimirCaractere

	mov al, '['

	Andromeda imprimirCaractere

	mov esi, codigoObtido

	imprimirString

	mov al, ']'

	Andromeda imprimirCaractere

	mov dh, 06
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.buildSistema
	
	imprimirString
	
	mov esi, buildObtida
	
	imprimirString
	
	mov dh, 07
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.tipoSistema
	
	imprimirString
	
	mov esi, msgInfo.modeloSistema
	
	imprimirString
	
	mov dh, 08
	mov dl, 18
	
	Andromeda definirCursor
 
    mov esi, msgInfo.pacoteAtualizacoes
    
	imprimirString
	
	mov esi, pacoteAtualizacoes
	
	imprimirString
    
    mov al, ' '
    
    Andromeda imprimirCaractere
    
    mov esi, dataHora

	imprimirString

	mov dh, 10
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, nomeSistema
	
	imprimirString
 
    mov dh, 12
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.copyrightAndromeda
	
	imprimirString
	
	mov dh, 13
	mov dl, 18
	
	Andromeda definirCursor
	
	mov esi, msgInfo.direitosReservados
	
	imprimirString
	
	mov dh, 15
	mov dl, 28
	
	Andromeda definirCursor
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgInfo.introducaoHardware
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 17
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgInfo.processadorPrincipal
	
	imprimirString

	mov dh, 18
	mov dl, 04
	
	Andromeda definirCursor

	mov esi, msgInfo.numProcessador
	
	imprimirString

	mov esi, processadores.proc0
	
	Andromeda abrir
    
    imprimirString
	
	mov dh, 19
	mov dl, 08
	
	Andromeda definirCursor

	mov esi, msgInfo.operacaoProcessador
	
	imprimirString
	
	mov dh, 21
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
	
