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

	Andromeda limparTela
	
	Andromeda encerrarProcesso	

;;************************************************************************************


