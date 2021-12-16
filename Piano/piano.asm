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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 8, 40, inicioAPP, 01h

;;************************************************************************************

include "../../../LibAPP/andrmda.s"
include "../../../LibAPP/Estelar/estelar.s"
include "../../../LibAPP/macros.s"

;;************************************************************************************

inicioAPP:
	
	Andromeda obterCor

	mov dword[Andromeda.Interface.corFonte], eax
	mov dword[Andromeda.Interface.corFundo], ebx

	Andromeda limparTela

	Andromeda obterInfoTela
	
	mov byte[Andromeda.Interface.numColunas], bl
	mov byte[Andromeda.Interface.numLinhas], bh

;; Imprime o título do programa e rodapé.
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

	Andromeda.Estelar.criarInterface piano.titulo, piano.rodape, \
	AZUL_METALICO, AZUL_METALICO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
	[Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

.blocoTeclado:
		
	mov eax, 80  ;; Início do bloco em X
	mov ebx, 80  ;; Início do bloco em Y
	mov esi, 635 ;; Comprimento do bloco
	mov edi, 450 ;; Altura do bloco
	mov edx, LAVANDA_PASTEL ;; Cor do bloco
	
	Andromeda desenharBloco
	
	call montarTeclas
    
.novamente:

	Andromeda aguardarTeclado

.semtecla:				; Procura as teclas e emite os sons

	cmp al, 'q'
	jne .w
	
	call evidenciarTeclas.evidenciarQ
	
	tocarNota 4000
	
	jmp .novamente

.w:

	cmp al, 'w'
	jne .e
	
	call evidenciarTeclas.evidenciarW
	
	tocarNota 3600
	
	jmp .novamente

.e:

	cmp al, 'e'
	jne .r
	
	call evidenciarTeclas.evidenciarE
	
	tocarNota 3200
	
	jmp .novamente


.r:

	cmp al, 'r'
	jne .t
	
	call evidenciarTeclas.evidenciarR
	
	tocarNota 3000
	
	jmp .novamente

.t:

	cmp al, 't'
	jne .y
	
	call evidenciarTeclas.evidenciarT
	
	tocarNota 2700
	
	jmp .novamente

.y:

	cmp al, 'y'
	jne .u
	
	call evidenciarTeclas.evidenciarY
	
	tocarNota 2400
	
	jmp .novamente

.u:

	cmp al, 'u'
	jne .i
	
	call evidenciarTeclas.evidenciarU
	
	tocarNota 2100
	
	jmp .novamente

.i:

	cmp al, 'i'
	jne .espaco
	
	call evidenciarTeclas.evidenciarI
	
	tocarNota 2000
	
	jmp .novamente

.espaco:

	cmp al, ' '
	jne .informacoes
	
	call evidenciarTeclas.evidenciarEspaco
	
	finalizarNota
	
	jmp .novamente
	
.informacoes:

	cmp al, 'a'
	jne .sair
	
	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor
	
	jmp exibirInterfaceSobre

.sair:

	cmp al, 'z'
	je .fim
	
	cmp al, 'Z'
	je .fim
	
	jmp .agora

.agora:

	jmp .novamente

.fim:

	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor
	
	Andromeda desligarSom

	Andromeda limparTela
	
	Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************

montarTeclas:

.primeiraTecla:
	
    mov eax, 144
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
 
.segundaTecla:

	mov eax, 204
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco

.terceiraTecla:

	mov eax, 264
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.quartaTecla:

	mov eax, 324
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.quintaTecla:

	mov eax, 384
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.sextaTecla:

	mov eax, 444
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.setimaTecla:

	mov eax, 504
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.oitavaTecla:
   
    mov eax, 564
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.blocoEspaco:

	mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, PRETO
    
    Andromeda desenharBloco
    
.legenda:
    
    mov eax, PRETO
	mov ebx, LAVANDA_PASTEL
	
	Andromeda definirCor

.teclaQ:
	
	mov dl, 19
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaQ
    
    imprimirString

.teclaW:
    
    mov dl, 27 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaW
    
    imprimirString

.teclaE:
    
    mov dl, 34 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaE
    
    imprimirString
	
.teclaR:

	mov dl, 42 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaR
    
    imprimirString

.teclaT:

	mov dl, 49 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaT
    
    imprimirString
    
.teclaY:

	mov dl, 57 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaY
    
    imprimirString   
    
.teclaU:

	mov dl, 64 ;; Anterior + 7
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaU
    
    imprimirString      	
    
.teclaI:

	mov dl, 72 ;; Anterior + 8
    mov dh, 22 ;; Não alterar! Esta é a posição Y!
    
    Andromeda definirCursor
	
    mov esi, piano.teclaI
    
    imprimirString  
  
.teclaEspaco:
        
    mov eax, BRANCO_ANDROMEDA
	mov ebx, PRETO
	
	Andromeda definirCor
	    
    mov dl, 45 
    mov dh, 29 
    
    Andromeda definirCursor
	
    mov esi, piano.teclaEspaco
    
    imprimirString 
    
	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor

    ret
    
;;************************************************************
 
evidenciarTeclas:

.evidenciarQ:
	
	call montarTeclas
	
    mov eax, 144
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
 
	ret
	
.evidenciarW:

	call montarTeclas
	
	mov eax, 204
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret

.evidenciarE:

	call montarTeclas
	
	mov eax, 264
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarR:

	call montarTeclas
	
	mov eax, 324
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarT:

	call montarTeclas
	
	mov eax, 384
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarY:

	call montarTeclas
	
	mov eax, 444
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarU:

	call montarTeclas
	
	mov eax, 504
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarI:
   
    call montarTeclas
    
    mov eax, 564
    mov ebx, 84  ;; Não deve ser alterado
    mov esi, 30
    mov edi, 250
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    ret
    
.evidenciarEspaco:

	call montarTeclas
	
	mov eax, 145
    mov ebx, 460
    mov esi, 500
    mov edi, 40
    mov edx, VERMELHO
    
    Andromeda desenharBloco
    
    mov eax, BRANCO_ANDROMEDA
	mov ebx, VERMELHO
	
	Andromeda definirCor
	    
    mov dl, 45 
    mov dh, 29 
    
    Andromeda definirCursor
	
    mov esi, piano.teclaEspaco
    
    imprimirString 
    
	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]
	
	Andromeda definirCor

    ret

;;************************************************************
    
exibirInterfaceSobre:

	Andromeda desligarSom
	
    Andromeda limparTela

	;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, AZUL_METALICO
	
	Andromeda definirCor
	
	mov al, 0
	Andromeda limparLinha
	
	mov esi, piano.titulo
	imprimirString
	
	mov al, byte[Andromeda.Interface.numLinhas]		;; Última linha
	
	dec al
	
	Andromeda limparLinha
	
	mov esi, piano.rodapeInfo
	imprimirString
	
	mov eax, dword[Andromeda.Interface.corFonte]
	mov ebx, dword[Andromeda.Interface.corFundo]

	Andromeda definirCor
	
	mov dh, 02
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.sobreTeclado
	
	imprimirString
	
	mov dh, 03
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.versaoTeclado
	
	imprimirString
	
	mov dh, 05
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.autor
	
	imprimirString
	
	mov dh, 06
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.direitos
	
	imprimirString
	
	mov dh, 08
	mov dl, 04
	
	Andromeda definirCursor
	
	mov esi, piano.ajuda
	
	imprimirString
	
	mov dh, 10
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.topico1
	
	imprimirString
	
	mov dh, 11
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.topico2
	
	imprimirString
	
	mov dh, 12
	mov dl, 02
	
	Andromeda definirCursor
	
	mov esi, piano.topico3
	
	imprimirString
	
	
.obterTeclas:

	Andromeda aguardarTeclado
	
	cmp al, 'v'
	je inicioAPP
	
	cmp al, 'V'
	je inicioAPP
	
	cmp al, 'z'
	je inicioAPP.fim
	
	cmp al, 'Z'
	je inicioAPP.fim

	jmp .obterTeclas		

;;************************************************************	

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "10047.09g"

piano:

.sobreTeclado:  db "Piano Virtual 'return PIANO;'(R) para Sistema Operacional Andromeda(R)", 0
.versaoTeclado: db "Versao ", VERSAO, 0
.autor:         db "Copyright (C) 2017-2022 Felipe Miguel Nery Lunkes", 0
.direitos:      db "Todos os direitos reservados.", 0
.ajuda:         db "Um pequeno topico de ajuda para este programa:", 0
.topico1:       db "+ Utilize as teclas [QWERTYUI] para emitir notas.", 0
.topico2:       db "+ Utilize a tecla [ESPACO] para silenciar as notas, quando necessario.", 0
.topico3:       db "+ Por fim, utilize a tecla [Z] para finalizar este aplicativo a qualquer momento.", 0
.titulo:        db "Piano Virtual 'return PIANO;'(R) para Andromeda(R) versao ", VERSAO, 0
.rodape:        db "Pressione [Z] para sair e [ESPACO] para silenciar. Use [A] para mais informacoes", 0
.rodapeInfo:    db "Pressione [V] para retornar ou [Z] para finalizar este aplicativo", 0

.teclaQ:        db "Q", 0
.teclaW:        db "W", 0
.teclaE:        db "E", 0
.teclaR:        db "R", 0
.teclaT:        db "T", 0
.teclaY:        db "Y", 0
.teclaU:        db "U", 0
.teclaI:        db "I", 0
.teclaEspaco:   db "[ESPACO]", 0
.teclaZ:        db "Z", 0

Andromeda.Interface Andromeda.Estelar.Interface