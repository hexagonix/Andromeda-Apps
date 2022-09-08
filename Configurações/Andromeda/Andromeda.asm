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

;; Solicita a versão do Sistema, a decodifica e exibe para o usuário
    
imprimirVersao:
    
    mov esi, versaoObtida
    
    imprimirString
    
    ret

;;************************************************************************************

finalizarAPP:

match =SIM, VERBOSE

{

    logSistema Log.Config.logFinalizando, 00h, Log.Prioridades.p4

}

    Hexagonix limparTela
    
    Hexagonix encerrarProcesso  

;;************************************************************************************

definirCorTema:

    mov eax, corPadraoInterface
    mov ebx, dword[corFundo]

    Hexagonix definirCor

    ret 

;;************************************************************************************

definirCorPadrao:

    mov eax, dword[corFonte]
    mov ebx, dword[corFundo]

    Hexagonix definirCor
    
    ret

