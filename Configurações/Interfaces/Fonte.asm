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

mostrarInterfaceFonte:	

	Hexagonix limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Hexagonix definirCor
	
	mov al, 0
	Hexagonix limparLinha
	
	mov esi, TITULO.fonte
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, RODAPE.fonte
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
    cursorPara 02, 02

	mov esi, msgFonte.introducao
	
	imprimirString
	
    cursorPara 02, 03
	
	mov esi, msgFonte.introducao2
	
	imprimirString

    cursorPara 02, 06
	
    mov esi, msgFonte.solicitarArquivo
    
    imprimirString

match =SIM, VERBOSE
{

	logSistema Log.Config.logPedirArquivoFonte, 00h, Log.Prioridades.p4

}

	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor

    mov al, 13
	
	Hexagonix obterString
	
	Hexagonix cortarString ;; Remover espaços em branco extras
	
	mov dword[fonte], esi

	cmp byte[esi], 0
	je .semArquivo

match =SIM, VERBOSE
{

	logSistema Log.Config.logFontes, 00h, Log.Prioridades.p4

}	

	mov esi, dword[fonte]
	
	clc

	Hexagonix arquivoExiste

	jc .erroArquivo
	
	clc 

	Hexagonix alterarFonte
	
	jc .erroFonte

match =SIM, VERBOSE
{

	logSistema Log.Config.logSucessoFonte, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor

	mov esi, msgFonte.sucesso
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, dword[fonte]
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgFonte.fechamento
	
	imprimirString
	
	mov esi, msgFonte.introducaoTeste
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, dword[fonte]
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgFonte.ponto
	
	imprimirString
	
	mov esi, msgFonte.testeFonte
	
	imprimirString
	
	jmp .novaLinha

.semArquivo:

    cursorPara 04, 08
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor

	mov esi, msgFonte.semArquivo
	
	imprimirString
	
	jmp .novaLinha

.erroArquivo:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFonteAusente, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Hexagonix definirCor
	
	mov esi, msgFonte.arquivoAusente
	
	imprimirString
	
	jmp .novaLinha

.erroFonte:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFalhaFonte, 00h, Log.Prioridades.p4

}

    cursorPara 04, 08
	
	mov esi, msgFonte.falha
	
	imprimirString
	
	jmp .novaLinha
	
.novaLinha:
  
    novaLinha
	
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

	jmp .obterTeclas		
	

