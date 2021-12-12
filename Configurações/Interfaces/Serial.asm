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

mostrarInterfaceSerial:	

match =SIM, VERBOSE
{

	logSistema Log.Config.logSerial, 00h, Log.Prioridades.p4

}

	Andromeda limparTela

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, corPadraoInterface
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, TITULO.portaSerial
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, RODAPE.portaSerial
	
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
	
	mov esi, msgSerial.introducao
	
	imprimirString
	
	mov dh, 03
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, msgSerial.introducao2
	
	imprimirString
	
	mov dh, 04
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgSerial.portaPadrao
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov esi, portasSeriais.com1
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov dh, 05
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgSerial.opcoes
	
	imprimirString
	
	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgSerial.opcoes2
	
	imprimirString
	
	mov dh, 09
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgSerial.opcoes3
	
	imprimirString
	
	
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
	
	cmp al, 'd'
	je testeSerial
	
	cmp al, 'D'
	je testeSerial
	
	cmp al, 'e'
	je enviarSerial
	
	cmp al, 'E'
	je enviarSerial
	
	jmp .obterTeclas	

;;************************************************************************************
	
testeSerial: ;; Realizar envio automático de dados para a porta serial padrão

match =SIM, VERBOSE
{

	logSistema Log.Config.logSerialAutomatico, 00h, Log.Prioridades.p4

}

	mov dh, 10
	mov dl, 04
	
	Andromeda definirCursor
	
    mov esi, msgSerial.mensagemEnviando
	
	imprimirString
	
	mov esi, portasSeriais.com1
	
	Andromeda abrir
	
	jc erroAbertura
	
	mov esi, msgSerial.mensagemAutomatica
	
	mov [Buffers.msg], esi
	
	mov si, [Buffers.msg]
	
	Andromeda escrever
	
	jc erro
	
	mov eax, VERDE_FLORESTA
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov esi, msgSerial.enviado
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	jmp mostrarInterfaceSerial.obterTeclas
	
;;************************************************************************************
		
enviarSerial: ;; Realiza o envio manual de dados pela porta serial

match =SIM, VERBOSE
{

	logSistema Log.Config.logSerialManual, 00h, Log.Prioridades.p4

}

	mov esi, portasSeriais.com1
	
	Andromeda abrir
	
	jc erroAbertura
	
	mov al, 10
	
	Andromeda limparLinha
	
	mov dh, 10
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, msgSerial.insiraMensagem
	
	imprimirString
	
	mov esi, msgSerial.colcheteEsquerdo
	
	imprimirString
	
	mov eax, corPadraoInterface
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov esi, portasSeriais.com1
	
	imprimirString
			
	mov eax,  Andromeda.Estelar.Tema.Fonte.fontePadrao
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov esi, msgSerial.colcheteDireito
	
	imprimirString
	
	mov esi, msgSerial.doisPontos
	
	imprimirString

    mov al, byte[maxColunas]		;; Máximo de caracteres para obter
	sub al, 20
	
	Andromeda obterString
	
	;; Andromeda cortarString		;; Remover espaços em branco extras (por enquanto isso nao será feito!)

	mov [Buffers.msg], esi
	
	mov si, [Buffers.msg]
	
	Andromeda escrever
	
	jc erro
	
	mov eax, VERDE_FLORESTA
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	mov esi, msgSerial.enviado
	
	imprimirString
	
	mov eax, dword[corFonte]
	mov ebx, dword[corFundo]
	
	Andromeda definirCor
	
	jmp mostrarInterfaceSerial.obterTeclas

;;************************************************************************************

;; Manipuladores de erro gerais para as portas seriais

erro:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFalha, 00h, Log.Prioridades.p4

}

	mov esi, msgSerial.erroEnvio
	
	imprimirString

	jmp mostrarInterfaceSerial.obterTeclas

erroAbertura:

match =SIM, VERBOSE
{

	logSistema Log.Config.logFalha, 00h, Log.Prioridades.p4

}

	mov esi, msgSerial.erroAbertura
	
	imprimirString

	jmp mostrarInterfaceSerial.obterTeclas		
