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

mostrarInterfaceDiscos:	

	Hexagonix limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Hexagonix definirCor
	
	mov al, 0
	Hexagonix limparLinha
	
	mov esi, TITULO.discos
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, RODAPE.discos
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov dh, 02
	mov dl, 02
	
	Hexagonix definirCursor
	
	mov esi, msgDiscos.introducao
	
	imprimirString
	
	mov dh, 03
	mov dl, 02
	
	Hexagonix definirCursor
	
	mov esi, msgDiscos.introducao2
	
	imprimirString
	
.infoDisco:

    mov dh, 06
	mov dl, 04
	
	Hexagonix definirCursor
	
    mov esi, msgDiscos.discoAtual
  
    imprimirString  

match =SIM, VERBOSE
{

	logSistema Log.Config.logDiscos, 00h, Log.Prioridades.p4

}

	Hexagonix obterDisco
	
	push edi ;; Rótulo do disco
	push esi ;; Nome do dispositivo segundo o sistema


    mov eax, corPadraoInterface
	mov ebx, dword[corFundo]
	
	Hexagonix definirCor
	
	pop esi
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]
	
	Hexagonix definirCor
	
	mov dh, 07
	mov dl, 04
	
	Hexagonix definirCursor
	
	mov esi, msgDiscos.rotuloVolume
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]
	
	Hexagonix definirCor
	
	pop esi
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]
	
	Hexagonix definirCor
	
	jmp .novaLinha
	
.novaLinha:
  
    novaLinha
	
.obterTeclas:

	Hexagonix aguardarTeclado
	
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

	jmp .obterTeclas		
	
	
