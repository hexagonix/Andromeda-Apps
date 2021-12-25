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

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.fonte
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.fonte
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	call mostrarAvisoResolucao
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov dh, 02
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgFonte.introducao
	
	imprimirString
	
	mov dh, 03
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgFonte.introducao2
	
	imprimirString

    mov dh, 06
	mov dl, 02
	
	Andromeda definirCursor
	
    mov esi, msgFonte.solicitarArquivo
    
    imprimirString

match =SIM, VERBOSE
{

	logSistema Log.Config.logPedirArquivoFonte, 00h, Log.Prioridades.p4

}

	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor

    mov al, 13
	
	Andromeda obterString
	
	Andromeda cortarString ;; Remover espaços em branco extras
	
	mov dword[fonte], esi

	cmp byte[esi], 0
	je .semArquivo

match =SIM, VERBOSE
{

	logSistema Log.Config.logFontes, 00h, Log.Prioridades.p4

}	

	mov esi, dword[fonte]
	
	clc

	Andromeda arquivoExiste

	jc .erroArquivo
	
	clc 

	Andromeda alterarFonte
	
	jc .erroFonte

match =SIM, VERBOSE
{

	logSistema Log.Config.logSucessoFonte, 00h, Log.Prioridades.p4

}

	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor

	mov esi, msgFonte.sucesso
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, dword[fonte]
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgFonte.fechamento
	
	imprimirString
	
	mov esi, msgFonte.introducaoTeste
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, dword[fonte]
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgFonte.ponto
	
	imprimirString
	
	mov esi, msgFonte.testeFonte
	
	imprimirString
	
	jmp .novaLinha

.semArquivo:

	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor

	mov esi, msgFonte.semArquivo
	
	imprimirString
	
	jmp .novaLinha

.erroArquivo:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFonteAusente, 00h, Log.Prioridades.p4

}

	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]

	Andromeda definirCor
	
	mov esi, msgFonte.arquivoAusente
	
	imprimirString
	
	jmp .novaLinha

.erroFonte:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFalhaFonte, 00h, Log.Prioridades.p4

}

	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgFonte.falha
	
	imprimirString
	
	jmp .novaLinha
	
.novaLinha:
  
    novaLinha
	
.obterTeclas:

	Andromeda aguardarTeclado
	
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
	

