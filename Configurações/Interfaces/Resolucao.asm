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

mostrarInterfaceConfigResolucao:    

    Hexagonix limparTela

;; Imprime o título do programa e rodapé

    mov eax, BRANCO_ANDROMEDA
    mov ebx, corPadraoInterface
    
    Hexagonix definirCor
    
    mov al, 0
    Hexagonix limparLinha
    
    mov esi, TITULO.resolucao
    
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, RODAPE.resolucao
    
    imprimirString
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    call mostrarAvisoResolucao
    
    call exibirResolucao
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    cursorPara 02, 02
    
    mov esi, msgResolucao.introducao
    
    imprimirString
    
    cursorPara 02, 03
    
    mov esi, msgResolucao.introducao2
    
    imprimirString
    
    cursorPara 02, 06
    
    mov esi, msgResolucao.inserir
    
    imprimirString
    
    cursorPara 04, 08
    
    mov esi, msgResolucao.opcao1
    
    imprimirString
    
    cursorPara 04, 09
    
    mov esi, msgResolucao.opcao2
    
    imprimirString
    
    mov ah, byte[alterado]
    
    cmp byte ah, 1
    je .alterou
        
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
    
    cmp al, '1'
    je modoGrafico1
    
    cmp al, '2'
    je modoGrafico2


    jmp .obterTeclas        
    
.alterou:
    
    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    mov dh, 15
    mov dl, 02
    
    Hexagonix definirCursor
    
    mov esi, msgResolucao.resolucaoAlterada
    
    imprimirString
    
    mov dh, 17
    mov dl, 02
    
    Hexagonix definirCursor
    
    mov esi, msgResolucao.alterado
    
    imprimirString
    
    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    jmp .obterTeclas
    
modoGrafico1:

match =SIM, VERBOSE
{

    logSistema Log.Config.logTrocarResolucao800x600, 00h, Log.Prioridades.p4

}

    mov eax, 1
    Hexagonix definirResolucao
    
    Hexagonix obterInfoTela
    
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
    Hexagonix definirResolucao
    
    Hexagonix obterInfoTela
    
    mov byte[maxColunas], bl
    mov byte[maxLinhas], bh

    mov byte[alterado], 1
    
    jmp mostrarInterfaceConfigResolucao

exibirResolucao:

    mov dh, 13
    mov dl, 02
    
    Hexagonix definirCursor
    
    Hexagonix obterResolucao

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
