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

mostrarAvisoResolucao:

    Andromeda obterResolucao
	
	cmp eax, 1
	je .modoGrafico1
	
	ret
	
.modoGrafico1:
	
    mov al, byte[maxLinhas]		;; Última linha
	
	dec al
    dec al
	dec al
	
	Andromeda limparLinha
	
	mov esi, msgGeral.mensagemResolucao
	
	imprimirString
	
	ret	

;;************************************************************************************

mostrarLogoSistema:

;; Desenhar um bloco de cor específica
;; Entrada: EAX - X; EBX - Y; ESI - Comprimento
;; Entrada: EDI - Altura; EDX - Cor em hexadecimal

.primeiraLinha:
	
    mov eax, 20      ;; Posição X
    mov ebx, 30      ;; Posição Y
    mov esi, 20      ;; Comprimento
    mov edi, 150     ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Andromeda desenharBloco
 
.segundaLinha:

	mov eax, 89      ;; Posição X
    mov ebx, 30      ;; Posição Y
    mov esi, 20      ;; Comprimento
    mov edi, 150     ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Andromeda desenharBloco

.terceiraLinha:

	mov eax, 39      ;; Posição X
    mov ebx, 30      ;; Posição Y
    mov esi, 50      ;; Comprimento
    mov edi, 20      ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Andromeda desenharBloco
    
.quartaLinha:

	mov eax, 39      ;; Posição X
    mov ebx, 100     ;; Posição Y
    mov esi, 50      ;; Comprimento
    mov edi, 20      ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Andromeda desenharBloco    

	mov dh, 02
	mov dl, 14
	
	Andromeda definirCursor
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor

	mov esi, msgGeral.marcaRegistrada

	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor

ret
