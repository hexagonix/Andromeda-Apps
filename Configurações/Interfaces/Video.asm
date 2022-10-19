;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
;; utilizar qualquer trecho deste arquivo.
;;
;; Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.

mostrarAvisoResolucao:

    Hexagonix obterResolucao
    
    cmp eax, 1
    je .modoGrafico1
    
    ret
    
.modoGrafico1:
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    dec al
    dec al
    
    Hexagonix limparLinha
    
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
    
    Hexagonix desenharBloco
 
.segundaLinha:

    mov eax, 89      ;; Posição X
    mov ebx, 30      ;; Posição Y
    mov esi, 20      ;; Comprimento
    mov edi, 150     ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Hexagonix desenharBloco
    
.terceiraLinha:

    mov eax, 39      ;; Posição X
    mov ebx, 90      ;; Posição Y
    mov esi, 50      ;; Comprimento
    mov edi, 30      ;; Altura
    mov edx, corPadraoInterface ;; Cor
    
    Hexagonix desenharBloco    

    cursorPara 14, 02
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    mov esi, msgGeral.marcaRegistrada

    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor

ret
