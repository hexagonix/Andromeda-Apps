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

;;************************************************************************************

inicioAPP:

	mov [regES], es
	
	push ds
	pop es			
	
	Hexagonix obterCor

	mov dword[Andromeda.Interface.corFonte], eax
	mov dword[Andromeda.Interface.corFundo], ebx

		
.executarInterface:

    Hexagonix limparTela

    Hexagonix obterInfoTela
	
	mov byte[Andromeda.Interface.numColunas], bl
	mov byte[Andromeda.Interface.numLinhas], bh
	
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

	Andromeda.Estelar.criarInterface fonte.titulo, fonte.rodape, AZUL_ROYAL, AZUL_ROYAL, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
	
	mov esi, fonte.bannerAndromeda

	imprimirString

	Andromeda.Estelar.criarLogotipo AZUL_ROYAL, BRANCO_ANDROMEDA, [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

	cursorPara 02, 10
	
	mov esi, fonte.boasVindas
	
	imprimirString
	
	mov esi, fonte.nomeFonte
	
	imprimirString
	
	mov al, byte[Andromeda.Interface.numColunas]		;; Máximo de caracteres para obter
	
	sub al, 20
	
	Hexagonix obterString
	
	Hexagonix cortarString			;; Remover espaços em branco extras
	
	mov [arquivoFonte], esi

	call validarFonte

	jc erroFormato

	Hexagonix alterarFonte
	
	jc erroFonte
	
	mov esi, fonte.sucesso
	
	imprimirString

	jmp finalizarAPP
	
erroFonte:

	mov esi, fonte.falha
		
	imprimirString
	
	jmp finalizarAPP

erroFormato:

	mov esi, fonte.falhaFormato
		
	imprimirString
	
	jmp finalizarAPP

;;************************************************************************************

finalizarAPP:

	Hexagonix aguardarTeclado

	Andromeda.Estelar.finalizarProcessoGrafico 0, 0
	
;;************************************************************************************

validarFonte:

	mov esi, [arquivoFonte]
	mov edi, bufferArquivo

	Hexagonix abrir

	jc .erroSemFonte

	mov edi, bufferArquivo

	cmp byte[edi+0], "H"
	jne .naoHFNT

	cmp byte[edi+1], "F"
	jne .naoHFNT

	cmp byte[edi+2], "N"
	jne .naoHFNT

	cmp byte[edi+3], "T"
	jne .naoHFNT

.verificarTamanho:

	Hexagonix arquivoExiste

;; Em EAX, o tamanho do arquivo. Ele não deve ser maior que 2000 bytes, o que poderia
;; sobrescrever dados na memória do Hexagon

	mov ebx, 2000

	cmp eax, ebx
	jng .continuar

	jmp .tamanhoSuperior

.continuar:

	clc 
	
	ret

.erroSemFonte:
	
	mov esi, fonte.falha
	
	imprimirString

	jmp finalizarAPP

.naoHFNT:

	stc

	ret

.tamanhoSuperior:

	mov esi, fonte.tamanhoSuperior
	
	imprimirString

	jmp finalizarAPP

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "2.1"

fonte:

.boasVindas:      db 10, 10, "Use este programa para alterar a fonte padrao de exibicao do Sistema.", 10, 10
                  db "Lembrando que apenas fontes desenhadas para o Andromeda(R) podem ser utilizadas.", 10, 10, 10, 10, 0

.nomeArquivo:     db 10, "Nome do arquivo de fonte: ", 0	

.nomeFonte:       db "Nome do arquivo: ", 0

.sucesso:         db 10, 10, "Fonte alterada com sucesso.", 10, 10
                  db "Pressione qualquer tecla para continuar...", 10, 10, 0

.falha:           db 10, 10, "O arquivo nao pode ser localizado.", 10, 10
                  db 10, 10, "Pressione qualquer tecla para continuar...", 10, 10, 0

.falhaFormato:    db 10, 10, "O arquivo fornecido nao contem uma fonte no formato Hexagon(R).", 10, 10
                  db "Pressione qualquer tecla para continuar...", 10, 10, 0

.bannerAndromeda: db 10, 10   
                  db "                                   Sistema Operacional Andromeda(R)", 10, 10, 10, 10
                  db "                           Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 10
                  db "                                    Todos os direitos reservados", 0
                
.titulo:          db "Utilitario para troca de fonte padrao do Sistema Operacional Andromeda(R)", 0
.rodape:          db "[", VERSAO, "] | Utilize [F1] para cancelar o carregamento de uma nova fonte", 0
.introducaoTeste: db 10, "Pre-visualizacao da fonte e disposicao dos caracteres: ", 0
.testeFonte:      db "Sistema Operacional Andromeda(R)", 10, 10
                  db "1234567890-=", 10
                  db "!@#$%^&*()_+", 10
                  db "QWERTYUIOP{}", 10
                  db "qwertyuiop[]", 10
                  db 'ASDFGHJKL:"|', 10
                  db "asdfghjkl;'\", 10
                  db "ZXCVBNM<>?", 10
                  db "zxcvbnm,./", 10, 10
                  db "Sistema Operacional Andromeda(R)", 10, 0
.modoTexto:       db 0
.tamanhoSuperior: db 10, 10, "Este arquivo de fonte excede o tamanho maximo de 2 Kb.", 10, 0

linhaComando:     dd 0
arquivoFonte:     dd ?
regES:	          dw 0

Andromeda.Interface Andromeda.Estelar.Interface

bufferArquivo:
