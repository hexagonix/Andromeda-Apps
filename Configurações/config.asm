;;************************************************************************************
;;
;;    
;;        %#@$%&@$%&@$%$             Sistema Operacional Andromeda®
;;        #$@$@$@#@#@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$    !@#@#     Copyright © 2016-2021 Felipe Miguel Nery Lunkes
;;        @#@%!$&%$&$#@#             Todos os direitos reservados
;;        !@$%#%&#&@&$%#
;;        @$#!%&@&@#&*@&
;;        $#$#%    &%$#@
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************

use32

;; Agora vamos criar um cabeçalho para a imagem HAPP final do aplicativo. Anteriormente,
;; o cabeçalho era criado em cada imagem e poderia diferir de uma para outra. Caso algum
;; campo da especificação HAPP mudasse, os cabeçalhos de todos os aplicativos deveriam ser
;; alterados manualmente. Com uma estrutura padronizada, basta alterar um arquivo que deve
;; ser incluído e montar novamente o aplicativo, sem a necessidade de alterar manualmente
;; arquivo por arquivo. O arquivo contém uma estrutura instanciável com definição de 
;; parâmetros no momento da instância, tornando o cabeçalho tão personalizável quanto antes.

include "../../../LibAPP/HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 8, 40, inicioAPP, 01h

;;************************************************************************************

include "../../../LibAPP/andrmda.s"
include "../../../LibAPP/Estelar/estelar.s"
include "../../../LibAPP/macros.s"
include "../../../LibAPP/log.s"

;; Funções exclusivas de aplicativos base do Andromeda®

include "../../../LibAPP/sistema.s"
include "../../../LibAPP/verUtils.s"

;; Lista de dispositivos do Hexagon®

include "../../../LibAPP/dispositivos.s"

;;************************************************************************************

;; Versão do aplicativo

include "Dados\versao.asm"

;; Interfaces do aplicativo

include "Interfaces\Principal.asm"
include "Interfaces\Info.asm"
include "Interfaces\Config.asm"
include "Interfaces\Resolucao.asm"
include "Interfaces\Video.asm"
include "Interfaces\Discos.asm"
include "Interfaces\Fonte.asm"
include "Interfaces\Paralela.asm"
include "Interfaces\Serial.asm"

;; Dados utilizados no aplicativo

include "Dados\Video.asm"
include "Dados\Interfaces.asm"

;; Os dados de log só serão incluídos no aplicativo se for necessário. O padrão é que
;; sejam incluídos

match =SIM, VERBOSE
{

include "Dados\log.asm"

}

;; Funções de comunicação com o Sistema Operacional Andromeda®

include "Andromeda\Andromeda.asm"

corPadraoInterface = LARANJA_VERMELHO

;;************************************************************************************

inicioAPP:

match =SIM, VERBOSE

{

	logSistema Log.Config.logInicio, 00h, Log.Prioridades.p4
	logSistema Log.Config.logInicioResolucaoCores, 00h, Log.Prioridades.p4

}

	Andromeda obterInfoTela
	
	mov byte[maxColunas], bl
	mov byte[maxLinhas], bh
	
	mov byte[alterado], 0

	Andromeda obterCor

	mov dword[corFonte], eax 
	mov dword[corFundo], ebx

match =SIM, VERBOSE

{

	logSistema Log.Config.logVersaoDistro, 00h, Log.Prioridades.p4

}

	call obterVersaoDistribuicao
	
	jmp mostrarInterfacePrincipal

fonte: times 13 db 0

corFundo: dd 0
corFonte: dd 0

enderecoCarregamento:

Buffers:

;; Buffer para armazenamento de dados temporários 

.msg: db 0

