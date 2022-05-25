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

