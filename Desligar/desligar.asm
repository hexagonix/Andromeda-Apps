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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 9, 00, inicioAPP, 01h

;;************************************************************************************

include "../../../LibAPP/hexagon.s"
include "../../../LibAPP/Estelar/estelar.s"
include "../../../LibAPP/macros.s"
include "../../../LibAPP/log.s"

;;************************************************************************************

inicioAPP:	

	push ds
	pop es			
	
	mov	[parametro], edi ;; Salvar os parâmetros da linha de comando para uso futuro
	
	mov esi, [parametro]

	jmp iniciarInterface

;;************************************************************************************
	
iniciarInterface:

	Hexagonix obterCor

	mov dword[Andromeda.Interface.corFonte], eax
	mov dword[Andromeda.Interface.corFundo], ebx

	Hexagonix limparTela

	Hexagonix obterInfoTela
	
	mov byte[Andromeda.Interface.numColunas], bl
	mov byte[Andromeda.Interface.numLinhas], bh
	
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

	Andromeda.Estelar.criarInterface desligar.titulo, desligar.rodape, \
	INDIGO, INDIGO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
	
	novaLinha
	
	mov esi, desligar.bannerAndromeda

	imprimirString

	Andromeda.Estelar.criarLogotipo INDIGO, BRANCO_ANDROMEDA,\
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

	cursorPara 02, 14
	
	mov esi, desligar.msgFinalizar

	imprimirString

	cursorPara 02, 15

	mov esi, desligar.msgReiniciar

	imprimirString
	
	cursorPara 02, 17

	mov esi, desligar.msgSair

	imprimirString

	call obterTeclas

;;************************************************************************************

 finalizarSistema:

	cursorPara 02, 18

	mov esi, desligar.msgDesligamento

	imprimirString

	mov ecx, 500
	
	Hexagonix causarAtraso

	mov eax, VERDE_FLORESTA
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor
	
	mov esi, desligar.msgPronto

	imprimirString

	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor

	mov esi, desligar.msgFinalizando

	imprimirString

	mov ecx, 500
	
	Hexagonix causarAtraso

	mov eax, VERDE_FLORESTA
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor
	
	mov esi, desligar.msgPronto

	imprimirString

	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor

	mov esi, desligar.msgAndromeda

	imprimirString

	mov ecx, 500
	
	Hexagonix causarAtraso

	mov eax, VERDE_FLORESTA
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor
	
	mov esi, desligar.msgPronto

	imprimirString

	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor

	mov esi, desligar.msgDiscos

	imprimirString

	mov ecx, 500
	
	Hexagonix causarAtraso

	mov eax, VERDE_FLORESTA
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor
	
	mov esi, desligar.msgPronto

	imprimirString

	mov eax, VERMELHO
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor

	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]

	Hexagonix definirCor

	novaLinha

	mov ecx, 500
	
	Hexagonix causarAtraso

	ret

;;************************************************************************************

obterTeclas:

	Hexagonix aguardarTeclado
	
	push eax
	
	Hexagonix obterEstadoTeclas
	
	bt eax, 0
	jc .teclasControl
	
	pop eax
	
	jmp obterTeclas
	
.teclasControl:

	pop eax
	
	cmp al, 'd'
	je Andromeda_Desligar
	
	cmp al, 'D'
	je Andromeda_Desligar
	
	cmp al, 'r'
	je Andromeda_Reiniciar
	
	cmp al, 'R'
	je Andromeda_Reiniciar
	
	cmp al, 's'
	je Andromeda_Sair
	
	cmp al, 'S'
	je Andromeda_Sair

	jmp obterTeclas	
	
;;************************************************************************************	
	
Andromeda_Desligar:

	call finalizarSistema

	call executarEnergiaDesligamento

	jmp Andromeda_Sair

;;************************************************************************************

Andromeda_Reiniciar:

	call finalizarSistema

	call executarEnergiaReinicio

	jmp Andromeda_Sair

;;************************************************************************************

executarEnergiaDesligamento:

	mov esi, desligar.energia
	mov edi, desligar.parametroDesligar
	mov eax, 01h

	Hexagonix iniciarProcesso

	jc falhaEnergia

;;************************************************************************************

executarEnergiaReinicio:

	mov esi, desligar.energia
	mov edi, desligar.parametroReiniciar
	mov eax, 01h

	Hexagonix iniciarProcesso

	jc falhaEnergia

;;************************************************************************************

falhaEnergia:

	mov esi, desligar.falhaUtilitarioEnergia

	imprimirString

	Hexagonix aguardarTeclado

	jmp Andromeda_Sair

;;************************************************************************************

Andromeda_Sair:

	Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

ENERGIA equ "energia.app"   
VERSAO  equ "1.0.1"

align 16

desligar:

.bannerAndromeda:        db 10 
                         db "                                   Sistema Operacional Andromeda(R)", 10, 10, 10, 10
                         db "                           Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10
                         db "                                    Todos os direitos reservados", 0
.energia:                db ENERGIA, 0
.parametroDesligar:      db "-de", 0 ;; Parâmetro que indica que não deve haver eco
.parametroReiniciar:     db "-re", 0 ;; Parâmetro que indica que não deve haver eco
.msgDesligamento:        db 10, 10, "!> Preparando para desligar seu computador... ", 0
.msgFinalizando:         db 10, 10, "#> Finalizando todos os processos ainda em execucao...  ", 0
.msgAndromeda:           db 10, 10, "#> Finalizando o Sistema Operacional Andromeda(R)...    ", 0
.msgDiscos:              db 10, 10, "#> Finalizando os discos e desligando seu computador... ", 0
.msgReinicio:            db "Reiniciando seu computador...", 10, 10, 0
.msgFinalizar:           db "Pressione [Ctrl-D] para desligar seu computador.", 10, 0
.msgReiniciar:           db "Pressione [Ctrl-R] para reiniciar seu computador.", 10, 0
.msgSair:                db "Pressione [Ctrl-S] ou [F1] para retornar ao Andromeda(R)", 0
.msgPronto:              db "[Concluido]", 0
.msgFalha:               db "[Falha]", 0
.falhaUtilitarioEnergia: db 10, 10, "Falha ao executar o utilitario Unix energia. Tente novamente mais tarde.", 10
                         db "Pressione qualquer tecla para finalizar este aplicativo...", 0

.titulo: db "Opcoes de desligamento do Sistema Operacional Andromeda(R)",0
.rodape: db "[", VERSAO, "]",0

parametro: dd ?

Andromeda.Interface Andromeda.Estelar.Interface