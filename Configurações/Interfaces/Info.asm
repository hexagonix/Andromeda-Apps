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
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, RODAPE.info
    
    imprimirString
    
    call definirCorTema
    
    call mostrarAvisoResolucao
    
    call definirCorPadrao
    
    call mostrarLogoSistema
    
    cursorPara 20, 02

    call definirCorTema
    
    mov esi, msgInfo.introducao
    
    imprimirString  

    call definirCorPadrao
    
    cursorPara 18, 04
    
    mov esi, msgInfo.nomeSistema
    
    imprimirString
    
    call definirCorTema
    
    mov esi, nomeSistema
    
    imprimirString
    
    call definirCorPadrao

    cursorPara 18, 05
    
    mov esi, msgInfo.versaoSistema
    
    imprimirString
    
    call definirCorTema
    
    call imprimirVersao
    
    mov al, ' '

    Hexagonix imprimirCaractere

    mov al, '['

    Hexagonix imprimirCaractere

    mov esi, codigoObtido

    imprimirString

    mov al, ']'

    Hexagonix imprimirCaractere

    call definirCorPadrao

    cursorPara 18, 06
    
    mov esi, msgInfo.buildSistema
    
    imprimirString
    
    call definirCorTema
    
    mov esi, buildObtida
    
    imprimirString
    
    call definirCorPadrao

    cursorPara 18, 07
    
    mov esi, msgInfo.tipoSistema
    
    imprimirString
    
    call definirCorTema

    mov esi, msgInfo.modeloSistema
    
    imprimirString
    
    call definirCorPadrao

    cursorPara 18, 08
 
    mov esi, msgInfo.pacoteAtualizacoes
    
    imprimirString
    
    call definirCorTema
    
    mov esi, pacoteAtualizacoes
    
    imprimirString
    
    mov al, ' '
    
    Hexagonix imprimirCaractere
    
    mov esi, dataHora

    imprimirString

    call definirCorPadrao

;; Agora vamos exibir informações sobre o Hexagon

    cursorPara 18, 09
 
    mov esi, msgInfo.Hexagon
    
    imprimirString

    call definirCorTema
    
    Hexagonix retornarVersao
    
    push ecx
    push ebx
    
    imprimirInteiro
    
    mov esi, msgInfo.ponto
    
    imprimirString
    
    pop eax
    
    imprimirInteiro
    
    pop ecx
    
    cmp ch, 0
    je .continuar

    push ecx

    mov esi, msgInfo.ponto
    
    imprimirString
    
    pop ecx 
    
    mov al, ch
    
    Hexagonix imprimirCaractere

.continuar:

    call definirCorPadrao

;; Voltamos à programação normal

    cursorPara 18, 11
    
    mov esi, nomeSistema
    
    imprimirString
 
    cursorPara 18, 13
    
    mov esi, msgInfo.copyrightAndromeda
    
    imprimirString
    
    cursorPara 18, 14
    
    mov esi, msgInfo.direitosReservados
    
    imprimirString
    
    cursorPara 28, 16
    
    call definirCorTema
    
    mov esi, msgInfo.introducaoHardware
    
    imprimirString
    
    call definirCorPadrao
    
    cursorPara 02, 18
    
    mov esi, msgInfo.processadorPrincipal
    
    imprimirString

    cursorPara 04, 19

    mov esi, msgInfo.numProcessador
    
    imprimirString

    call exibirProcessadorInstalado
    
    cursorPara 08, 20

    mov esi, msgInfo.operacaoProcessador
    
    imprimirString
    
    cursorPara 02, 22

    mov esi, msgInfo.memoriaDisponivel
    
    imprimirString
    
    call definirCorTema
    
    Hexagonix usoMemoria
    
    mov eax, ecx
    
    imprimirInteiro
    
    call definirCorPadrao
    
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
    
