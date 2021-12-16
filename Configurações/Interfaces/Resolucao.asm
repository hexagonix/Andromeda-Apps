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

mostrarInterfaceConfigResolucao:	

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.resolucao
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.resolucao
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	call mostrarAvisoResolucao
	
	call exibirResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 02
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.introducao
	
	imprimirString
	
	mov dh, 03
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.introducao2
	
	imprimirString
	
	mov dh, 06
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.inserir
	
	imprimirString
	
	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.opcao1
	
	imprimirString
	
	mov dh, 09
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.opcao2
	
	imprimirString
	
	mov ah, byte[alterado]
	
	cmp byte ah, 1
	je .alterou
		
.obterTeclas:

	Andromeda aguardarTeclado
	
	cmp al, 'v'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'V'
	je mostrarInterfaceConfiguracoes
	
	cmp al, 'b'
	je mostrarInterfaceInfo
	
	cmp al, 'B'
	je mostrarInterfaceInfo
	
	cmp al, 'c'
	je finalizarAPP
	
	cmp al, 'C'
	je finalizarAPP
	
	cmp al, '1'
	je modoGrafico1
	
	cmp al, '2'
	je modoGrafico2


	jmp .obterTeclas		
	
.alterou:
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 15
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.resolucaoAlterada
	
	imprimirString
	
	mov dh, 17
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgResolucao.alterado
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	jmp .obterTeclas
	
modoGrafico1:

match =SIM, VERBOSE
{

	logSistema Log.Config.logTrocarResolucao800x600, 00h, Log.Prioridades.p4

}

    mov eax, 1
    Andromeda definirResolucao
	
	Andromeda obterInfoTela
	
	mov byte[maxColunas], bl
	mov byte[maxLinhas], bh
	
	mov byte[alterado], 1
	
	mov dh, 15
	mov dl, 02

    jmp mostrarInterfaceConfigResolucao

modoGrafico2:

match =SIM, VERBOSE
{

	logSistema Log.Config.logTrocarResolucao1024x768, 00h, Log.Prioridades.p4

}

    mov eax, 2
    Andromeda definirResolucao
	
	Andromeda obterInfoTela
	
	mov byte[maxColunas], bl
	mov byte[maxLinhas], bh

	mov byte[alterado], 1
	
    jmp mostrarInterfaceConfigResolucao

exibirResolucao:

    mov dh, 13
	mov dl, 02
	
	Andromeda definirCursor
	
    Andromeda obterResolucao

    cmp eax, 1
    je .modoGrafico1

    cmp eax, 2
    je .modoGrafico2

    ret	
	
.modoGrafico1:

    mov esi, msgResolucao.modo1
    
    imprimirString

    ret
	
.modoGrafico2:

    mov esi, msgResolucao.modo2
    
    imprimirString

   ret	
	
alterado: dd 0	
