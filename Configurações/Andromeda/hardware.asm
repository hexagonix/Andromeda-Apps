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

exibirProcessadorInstalado:

;; Vamos verificar se existe um processador reconhecido. Se não, exibir que o mesmo
;; não suporta a instrução CPUID

    mov esi, processadores.proc0
	
	Hexagonix abrir

    cmp byte [esi], 0
    je .semCPUID

    imprimirString

    ret 

.semCPUID:

    call definirCorTema

    mov esi, msgInfo.semCPUID

    imprimirString

    call definirCorPadrao
    
    ret 

;;************************************************************************************
  