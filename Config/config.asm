;;*************************************************************************************************
;;
;; 88                                                                                88              
;; 88                                                                                ""              
;; 88                                                                                                
;; 88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8  
;; 88P'    "88 a8P     88  `P8, ,8P'  ""     `P8 a8"    `P88 a8"     "8a 88P'   `"88 88  `P8, ,8P'   
;; 88       88 8PP"""""""    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(     
;; 88       88 "8b,   ,aa  ,d8" "8b,  88,    ,88 "8a,   ,d88 "8a,   ,a8" 88       88 88  ,d8" "8b,   
;; 88       88  `"Pbbd8"' 8P'     `P8 `"8bbdP"P8  `"PbbdP"P8  `"PbbdP"'  88       88 88 8P'     `P8  
;;                                               aa,    ,88                                         
;;                                                "P8bbdP"       
;;
;;                    Sistema Operacional Hexagonix® - Hexagonix® Operating System
;;
;;                          Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                        Todos os direitos reservados - All rights reserved.
;;
;;*************************************************************************************************
;;
;; Português:
;; 
;; O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
;; a licença que governa este arquivo e verifique a licença de cada repositório para
;; obter mais informações sobre seus direitos e obrigações ao utilizar e reutilizar
;; o código deste ou de outros arquivos.
;;
;; English:
;;
;; Hexagonix and its components are licensed under a BSD-3-Clause license. Read below
;; the license that governs this file and check each repository's license for
;; obtain more information about your rights and obligations when using and reusing
;; the code of this or other files.
;;
;;*************************************************************************************************
;;
;; BSD 3-Clause License
;;
;; Copyright (c) 2015-2023, Felipe Miguel Nery Lunkes
;; All rights reserved.
;; 
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;; 
;; 1. Redistributions of source code must retain the above copyright notice, this
;;    list of conditions and the following disclaimer.
;;
;; 2. Redistributions in binary form must reproduce the above copyright notice,
;;    this list of conditions and the following disclaimer in the documentation
;;    and/or other materials provided with the distribution.
;;
;; 3. Neither the name of the copyright holder nor the names of its
;;    contributors may be used to endorse or promote products derived from
;;    this software without specific prior written permission.
;; 
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;
;; $HexagonixOS$

use32

;; Agora vamos criar um cabeçalho para a imagem HAPP final do aplicativo. Anteriormente,
;; o cabeçalho era criado em cada imagem e poderia diferir de uma para outra. Caso algum
;; campo da especificação HAPP mudasse, os cabeçalhos de todos os aplicativos deveriam ser
;; alterados manualmente. Com uma estrutura padronizada, basta alterar um arquivo que deve
;; ser incluído e montar novamente o aplicativo, sem a necessidade de alterar manualmente
;; arquivo por arquivo. O arquivo contém uma estrutura instanciável com definição de 
;; parâmetros no momento da instância, tornando o cabeçalho tão personalizável quanto antes.

include "HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioAPP, 01h

;;************************************************************************************

inicioAPP:

    jmp entradaConfig

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"
include "log.s"

;; Funções de gerenciamento de versão

include "verUtils.s"

;; Lista de dispositivos do Hexagon®

include "dispositivos.s"

;;************************************************************************************

;; Versão do aplicativo

include "Dados\versao.asm"

;; Dados de gerenciamento

include "Dados\Video.asm"

;; Os dados de log só serão incluídos no aplicativo se for necessário. O padrão é que
;; sejam incluídos

match =SIM, VERBOSE
{

include "Dados\log.asm"

}

;; Funções de comunicação com o Sistema Operacional Hexagonix®

include "Hexagonix\Hexagonix.asm"
include "Hexagonix\hardware.asm"


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

;; Mensagens do aplicativo 

include "Dados\Interfaces.asm"

corPadraoInterface = AZUL_CADET

;;************************************************************************************

entradaConfig:

match =SIM, VERBOSE

{

    logSistema Log.Config.logInicio, 00h, Log.Prioridades.p4
    logSistema Log.Config.logInicioResolucaoCores, 00h, Log.Prioridades.p4

}

    hx.syscall obterInfoTela
    
    mov byte[maxColunas], bl
    mov byte[maxLinhas], bh
    
    mov byte[alterado], 0

    hx.syscall obterCor

    mov dword[corFonte], eax 
    mov dword[corFundo], ebx

match =SIM, VERBOSE

{

    logSistema Log.Config.logVersaoDistro, 00h, Log.Prioridades.p4

}

    call obterVersaoDistribuicao
    
    jc .erroVersao

    jmp .continuar

.erroVersao:

match =SIM, VERBOSE

{

    logSistema Log.Config.logErroVersaoDistro, 00h, Log.Prioridades.p4

}

.continuar:

    jmp mostrarInterfacePrincipal
    
fonte: times 13 db 0

corFundo: dd 0
corFonte: dd 0

enderecoCarregamento:

Buffers:

;; Buffer para armazenamento de dados temporários 

.msg: db 0

