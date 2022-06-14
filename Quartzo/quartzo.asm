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

include "../../../lib/HAPP.s" ;; Aqui está uma estrutura para o cabeçalho HAPP

;; Instância | Estrutura | Arquitetura | Versão | Subversão | Entrada | Tipo  
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 9, 00, Quartzo, 01h

;;************************************************************************************

include "../../../lib/hexagon.s"
include "../../../lib/Estelar/estelar.s"
include "../../../lib/erros.s"
include "../../../lib/dispositivos.s"

;;************************************************************************************

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

;; Aparência

CORDESTAQUE = ROXO_ESCURO

;; Variáveis, constantes e estruturas

VERSAO        equ "2.0.0" 
tamanhoRodape = 46

quartzo:

.formato:             db "UTF-8", 0
.formatoFimLinha:     db "LF", 0
.virgula:             db ", ", 0
.separador:           db " | ", 0
.rodapePrograma:      db "[^F] Sair, [^A] Abrir, [^S] Salvar | Arquivo:               ", 0
.linha:               db "Linha: ", 0
.coluna:              db "Coluna: ", 0
.arquivoSalvo:        db "Arquivo salvo", 0
.solicitarArquivo:    db "Nome do arquivo [ENTER para cancelar]: ", 0
.rodapeNovoArquivo:   db "Novo arquivo", 0
.permissaoNegada:     db "Apenas um usuario administrativo pode alterar este arquivo."
                      db " Pressione alguma tecla para continuar...", 0
.erroDeletando:       db "Erro ao atualizar o arquivo.", 0
.tituloPrograma:      db "Editor de texto Quartzo(R) para Andromeda(R) - Versao ", VERSAO, 0
.corFonte:            dd 0
.corFundo:            dd 0

totalLinhas:          dd 0	;; Contador de linhas no arquivo
linha:                dd 0	;; Linha atual no arquivo
posicaoLinhaAtual:    dd 0	;; Posição da linha atual em todo o arquivo
posicaoAtualNaLinha:  dd 0	;; Posição do cursor na linha atual
tamanhoLinhaAtual:    dd 0	;; Tamanho da linha atual
posicaoLinhaNaTela:   dd 1	;; Posição da linha no display
posicaoPaginaAtual:   dd 0	;; Posição da página atual no arquivo (uma tela)
necessarioRedesenhar: db 1	;; Se não zero, é necessário redesenhar toda a tela
nomeArquivo: times 13 db 0
maxColunas:           db 0 ;; Total de colunas disponíveis no vídeo na resolução atual
maxLinhas:            db 0 ;; Total de linhas disponíveis no vídeo na resolução atual

;;************************************************************************************

;; Função de entrada:

Quartzo:

	Hexagonix obterInfoTela
	
	mov byte[maxColunas], bl
	mov byte[maxLinhas], bh

	Hexagonix obterCor

	mov dword[quartzo.corFonte], eax
	mov dword[quartzo.corFundo], ebx
	
	cmp byte[edi], 0			;; Em caso de falta de argumentos
	je .novoArquivo
	
	mov esi, edi				;; Argumentos do programa
	
	Hexagonix tamanhoString
	
	cmp eax, 12				    ;; Nome de arquivo inválido
	ja .novoArquivo
	
;; Salvar nome do arquivo

	push es
	
	push ds
	pop es					;; DS = ES
	
	mov edi, nomeArquivo
	mov ecx, eax			;; Caracteres no nome do arquivo
	
	inc ecx					;; Incluindo o caractere NULL
	
	rep movsb
	
	pop es

.carregarArquivo:

;; Ler arquivo
	
	mov esi, nomeArquivo
	
	Hexagonix arquivoExiste
	
	jc .novoArquivo				;; O arquivo não existe
	
	mov esi, nomeArquivo
	
	mov edi, bufferArquivo		;; Endereço para o carregamento
	
	Hexagonix abrir
	
	mov esi, nomeArquivo
	
	Hexagonix tamanhoString
	
	mov ecx, eax

;; Adicionar nome do arquivo no rodapé

	push es
	
	push ds
	pop es					   ;; ES = DS

;; Agora o nome do arquivo aberto será exibido na interface do aplicativo
	
	mov edi, quartzo.rodapePrograma+tamanhoRodape ;; Posição
	mov esi, nomeArquivo
	
	rep movsb
	
	pop es
	
	jmp .inicio	
	
.novoArquivo:

	mov byte[nomeArquivo], 0
	
;; Adicionar 'Novo arquivo', ao rodapé do programa

	push es
	
	push ds
	pop es					
	
	mov ecx, 12
	
	mov esi, quartzo.rodapeNovoArquivo
	mov edi, quartzo.rodapePrograma+tamanhoRodape
	
	rep movsb
	
	pop es
	
.inicio:

	mov al, 10				;; Caractere de nova linha
	
	mov esi, bufferArquivo
	
	Hexagonix encontrarCaractere
	
	mov dword[totalLinhas], eax
	
	mov dword[posicaoLinhaAtual], 0
	
	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				    ;; Encontrar tamanho da linha atual
	
	mov byte[posicaoAtualNaLinha], dl	;; Cursor no final da linha
	mov byte[tamanhoLinhaAtual], dl	    ;; Salvar tamanho da linha atual
	
	mov dword[posicaoPaginaAtual], 0
	
	jmp .obterTecla

;; Leitura

.obterTecla:

	cmp byte[necessarioRedesenhar], 0
	je .outrasLinhasImpressas			;; Não é necessário imprimir outras linhas
	
;; Imprimir outras linhas

	mov esi, video.vd1
	
	Hexagonix abrir
	
	Hexagonix limparTela
	Hexagonix limparTela
	
	mov eax, dword[totalLinhas]
	
	cmp dword[linha], eax
	je .outrasLinhasImpressas
	
.imprimirOutrasLinhas:
	
	mov esi, bufferArquivo
	
	add esi, dword[posicaoPaginaAtual]
	
	novaLinha
	
	movzx ecx, byte[maxLinhas]
	
	sub ecx, 2
	
.imprimirOutrasLinhasLoop:

	call imprimirLinha
	
	jc .imprimirTitulo
	
	novaLinha
	
	loop .imprimirOutrasLinhasLoop

.imprimirTitulo:

;; Imprime o título do programa e rodapé

	mov eax, BRANCO_ANDROMEDA
	mov ebx, CORDESTAQUE
	
	Hexagonix definirCor
	
	mov al, 0
	
	Hexagonix limparLinha
	
	mov esi, quartzo.tituloPrograma
	
	imprimirString
	
	mov al, byte[maxLinhas]		;; Última linha
	
	dec al
	
	Hexagonix limparLinha
	
	mov esi, quartzo.rodapePrograma
	
	imprimirString
	
	Hexagonix obterCursor

	mov dl, byte[maxColunas]

	sub dl, 41

	Hexagonix definirCursor

	mov esi, quartzo.separador

	imprimirString

	mov esi, quartzo.formato

	imprimirString

	mov esi, quartzo.separador

	imprimirString

	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor
	
;; Atualizar tela

.atualizarBuffer:

	Hexagonix atualizarTela
	 
	mov esi, video.vd0
	
	Hexagonix abrir
	
.outrasLinhasImpressas:
	
	mov byte[necessarioRedesenhar], 0

	mov dl, 0
	mov dh, byte[posicaoLinhaNaTela]
	
	Hexagonix definirCursor
		
;; Imprimir linha atual

	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call imprimirLinha
	
	mov al, ' '

	Hexagonix imprimirCaractere
	
;; Imprimir linha e coluna atuais

	mov eax, BRANCO_ANDROMEDA
	mov ebx, CORDESTAQUE
	
	Hexagonix definirCor

	mov dl, byte[maxColunas]
	
	sub dl, 30
	
	mov dh, byte[maxLinhas]
	
	dec dh
	
	Hexagonix definirCursor

	mov esi, quartzo.linha
	
	imprimirString
	
	mov eax, dword[linha]
	
	inc eax					;; Contando de 1
	
	imprimirInteiro
	
	mov esi, quartzo.virgula

	imprimirString

	mov esi, quartzo.coluna
	
	imprimirString
	
	movzx eax, byte[posicaoAtualNaLinha]
	
	inc eax					;; Contando de 1
	
	imprimirInteiro
	
	mov al, ' '
	
	Hexagonix imprimirCaractere
	
	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor

.proximo1:

;; Colocar cursor na posição atual na linha

	mov dl, byte[posicaoAtualNaLinha]
	mov dh, byte[posicaoLinhaNaTela]
	
	Hexagonix definirCursor

;; Obter teclas
	
.prontoParaTecla:

	Hexagonix aguardarTeclado
	
	push eax
	
	Hexagonix obterEstadoTeclas
	
	bt eax, 0
	jc .teclasControl
	
	pop eax
	
	cmp al, 10
	je .teclasReturn
	
	cmp al, 9
	je .caractereImprimivel
	
	cmp ah, 71		
	je .teclaHome
	
	cmp ah, 79
	je .teclaEnd
	
	cmp ah, 14		
	je .teclaBackspace
		
	cmp ah, 83
	je .teclaDelete
	
	cmp ah, 75
	je .teclaEsquerda
	
	cmp ah, 77
	je .teclaDireita
	
	cmp ah, 72
	je .teclaCima
	
	cmp ah, 80
	je .teclaBaixo
	
	cmp ah, 81
	je .teclaPageDown
	
	cmp ah, 73
	je .teclaPageUp
	
;; Se o caractere não foi imprimível

	cmp al, ' '
	jl .obterTecla
	
	cmp al, '~'
	ja .obterTecla

;; Outra tecla

.caractereImprimivel:
	
;; Não são suportados mais de 79 caracteres por linha

	mov bl, byte[maxColunas]
	
	dec bl
	
	cmp byte[tamanhoLinhaAtual], bl
	jae .obterTecla
	
	mov edx, 0
	movzx esi, byte[posicaoAtualNaLinha]	;; Posição para inserir caracteres
	
	add esi, dword[posicaoLinhaAtual]
	add esi, bufferArquivo
	
	Hexagonix inserirCaractere			;; Inserir char na string
	
	inc byte[posicaoAtualNaLinha]		;; Um caractere foi adicionado
	inc byte[tamanhoLinhaAtual]

;; Mais teclas

	jmp .obterTecla

;; Tecla Return ou Enter

.teclasReturn:

	mov byte[necessarioRedesenhar], 1
	
	mov edx, 0
	
	movzx esi, byte[posicaoAtualNaLinha]
	
	add esi, bufferArquivo
	add esi, dword[posicaoLinhaAtual]
	
	mov al, 10
	
	Hexagonix inserirCaractere
	
;; Nova linha

	inc dword[linha]
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi

;; Calcular valores para essa linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				    ;; Encontrar tamanho para essa linha
	
	mov byte[posicaoAtualNaLinha], 0	;; Cursor no fim da linha
	mov byte[tamanhoLinhaAtual], dl		;; Salvar o tamanho atual da linha

	mov al, 10				            ;; Caractere de nova linha
	mov esi, bufferArquivo
	
	Hexagonix encontrarCaractere
	
	mov dword[totalLinhas], eax
	
;; Tentar mover o cursor para baixo

	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	cmp byte[posicaoLinhaNaTela], bl
	jb .teclasReturn.cursorProximaLinha
	
;; Se for última linha, rode a tela

	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	mov byte[posicaoLinhaNaTela], bl
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	sub eax, ebx
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoPaginaAtual], esi
		
	jmp .obterTecla
	
.teclasReturn.cursorProximaLinha:
	
	inc byte[posicaoLinhaNaTela]
	
	jmp .obterTecla

;; Teclas Control

.teclasControl:

	pop eax
	
	cmp al, 's'
	je .teclaControlS
	
	cmp al, 'S'
	je .teclaControlS

	cmp al, 'a'
	je .teclaControlA
	
	cmp al, 'A'
	je .teclaControlA
	
	cmp al, 'f'
	je fimPrograma
	
	cmp al, 'F'
	je fimPrograma
	
	jmp .obterTecla

.teclaBackspace:
	
;; Se na primeira coluna, não fazer nada

	cmp byte[posicaoAtualNaLinha], 0
	je .teclaBackspace.primeiraColuna

;; Remover caractere da esquerda

	movzx eax, byte[posicaoAtualNaLinha]
	
	add eax, dword[posicaoLinhaAtual]
	
	dec eax

	mov esi, bufferArquivo
	
	Hexagonix removerCaractereString
	
	dec byte[posicaoAtualNaLinha]	;; Um caractere foi removido
	dec byte[tamanhoLinhaAtual]

	jmp .obterTecla

.teclaBackspace.primeiraColuna:
	
	cmp byte[linha], 0
	je .obterTecla

;; Calcular tamanho anterior da linha

	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	dec eax					        ;; Linha anterior
	
	call posicaoLinha
	
	jc .obterTecla

	sub esi, bufferArquivo
	
	mov edx, 0
	
	add esi, bufferArquivo
	
	call tamanhoLinha				;; Encontrar tamanho
	
	push edx				        ;; Salvar tamanho da linha
	
	add dl, byte[tamanhoLinhaAtual]
	
;; Backspace não habilitado (suporte de até 79 caracteres por linha)

	mov bl, byte[maxColunas]
	
	dec bl
	
	cmp dl, bl				        ;; Contando de 0
	jae .obterTecla

;; Remover caractere de nova linha

	mov byte[necessarioRedesenhar], 1
	
	movzx eax, byte[posicaoAtualNaLinha]
	
	add eax, dword[posicaoLinhaAtual]
	
	dec eax

	mov esi, bufferArquivo
	
	Hexagonix removerCaractereString
	
	dec byte[totalLinhas]			;; Uma linha foi removida
	dec dword[linha]

;; Linha anterior

	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha

	jc .obterTecla
	
	sub esi, bufferArquivo
	
	push esi
	
;; Calcular valores para essa linha

	mov edx, 0
	
	pop esi
	
	push esi
	
	add esi, bufferArquivo
	
	call tamanhoLinha				    ;; Encontrar tamanho da linha atual
	
	mov byte[tamanhoLinhaAtual], dl		;; Salvar tamanho da linha
	
	pop dword[posicaoLinhaAtual]
	
	pop edx
	
	mov byte[posicaoAtualNaLinha], dl
	
	jmp .teclaCima.cursorMovido

.teclaDelete:

;; Se na última coluna, não fazer nada

	mov dl, byte[tamanhoLinhaAtual]
	
	cmp byte[posicaoAtualNaLinha], dl
	jae .obterTecla

	movzx eax, byte[posicaoAtualNaLinha]
	
	add eax, dword[posicaoLinhaAtual]
	
	mov esi, bufferArquivo
	
	Hexagonix removerCaractereString
	
	dec byte[tamanhoLinhaAtual]	;; Um caractere foi removido
	
	inc byte[posicaoAtualNaLinha]

.teclaEsquerda:

;; Se na primeira coluna, não fazer nada

	cmp byte[posicaoAtualNaLinha], 0
	jne .teclaEsquerda.moverEsquerda
	
	cmp byte[linha], 0
	je .obterTecla
	
	mov bl, byte[maxColunas]
	mov byte[posicaoAtualNaLinha], bl
	
	jmp .teclaCima
	
;; Mover cursor para a esquerda

.teclaEsquerda.moverEsquerda:

	dec byte[posicaoAtualNaLinha]
	
	jmp .obterTecla

.teclaDireita:

;; Se na última coluna, não fazer nada

	mov dl, byte[tamanhoLinhaAtual]
	
	cmp byte[posicaoAtualNaLinha], dl
	jnae .teclaDireita.moverDireita

;; Nova linha não permitida
	
	mov eax, dword[linha]
	
	inc eax
	
	cmp dword[totalLinhas], eax
	je .obterTecla
	
;; Nova linha
	
	inc dword[linha]
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi
	
;; Calcular valores para essa linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				
	
	mov byte[posicaoAtualNaLinha], 0	;; Cursor no fim da linha
	mov byte[tamanhoLinhaAtual], dl		;; Salvar tamanho da linha
	
	jmp .teclaBaixo.proximo
	
.teclaDireita.moverDireita:

	inc byte[posicaoAtualNaLinha]
	
	jmp .obterTecla

.teclaCima:

;; Linha anterior não permitida
	
	cmp dword[linha], 0
	je .obterTecla
	
;; Linha anterior

	dec dword[linha]
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi

;; Calcular valores para essa linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				
	
	mov byte[tamanhoLinhaAtual], dl		
	
	cmp dl, byte[posicaoAtualNaLinha]
	jb .teclaCima.moverCursorAteOFim
	
	jmp .teclaCima.cursorMovido			;; Não alterar a coluna do cursor
	
.teclaCima.moverCursorAteOFim:

	mov byte[posicaoAtualNaLinha], dl	;; Cursor ao fim da linha
	
.teclaCima.cursorMovido:

;; Tentar mover o cursor para cima

	cmp byte[posicaoLinhaNaTela], 1
	ja .teclaCima.cursorLinhaAnterior
	
;; Se o cursor estiver na primeira linha, role a tela para cima

	mov byte[posicaoLinhaNaTela], 1
	mov eax, dword[posicaoLinhaAtual]
	mov dword[posicaoPaginaAtual], eax
	
	mov byte[necessarioRedesenhar], 1
	
	jmp .obterTecla

.teclaCima.cursorLinhaAnterior:
	
	dec byte[posicaoLinhaNaTela]
	
	jmp .obterTecla

.teclaBaixo:

;; Próxima linha não disponível

	mov eax, dword[linha]
	
	inc eax
	
	cmp dword[totalLinhas], eax
	je .obterTecla
	
;; Próxima linha
	
	inc dword[linha]
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi
	
;; Calcular valores para a linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				
	
	mov byte[tamanhoLinhaAtual], dl		
	
	cmp dl, byte[posicaoAtualNaLinha]
	jb .teclaBaixo.moverCursorAteOFim
	
	jmp .teclaBaixo.cursorMovido			;; Não alterar a coluna
	
.teclaBaixo.moverCursorAteOFim:

	mov byte[posicaoAtualNaLinha], dl	;; Cursor ao fim da linha
	
.teclaBaixo.cursorMovido:

.teclaBaixo.proximo:

;; Tentar mover o cursor para baixo

	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	cmp byte[posicaoLinhaNaTela], bl
	jb .teclaBaixo.cursorProximaLinha
	
;; Se na última linha, girar tela para baixo

	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	mov byte[posicaoLinhaNaTela], bl
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	sub eax, ebx
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoPaginaAtual], esi
	
	mov byte[necessarioRedesenhar], 1
	
	jmp .obterTecla
	
.teclaBaixo.cursorProximaLinha:

	inc byte[posicaoLinhaNaTela]
	
	jmp .obterTecla

.teclaHome:

;; Mover cursor para primeira coluna

	mov byte[posicaoAtualNaLinha], 0
	
	jmp .obterTecla

.teclaEnd:

;; Mover cursor para última coluna

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha
	
	mov byte[posicaoAtualNaLinha], dl
	
	jmp .obterTecla

.teclaPageUp:
	
	mov eax, dword[linha]
	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	sub eax, ebx
	
	cmp eax, 0
	jle .teclaPageUp.irParaPrimeiraLinha

;; Não redesenhar se na última linha
	
	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	cmp byte[posicaoLinhaNaTela], bl
	jae .teclaPageUp.naoNecessarioRedesenhar
	
	mov byte[necessarioRedesenhar], 1
	
.teclaPageUp.naoNecessarioRedesenhar:
	
;; Linha anterior

	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	sub dword[linha], ebx
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi

;; Calcular valores para essa linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				
	
	mov byte[posicaoAtualNaLinha], dl	;; Cursor no fim da linha
	mov byte[tamanhoLinhaAtual], dl		
		
.teclaPageUp.fim:

	mov byte[posicaoLinhaNaTela], 1
	mov eax, dword[posicaoLinhaAtual]
	mov dword[posicaoPaginaAtual], eax
	
	jmp .obterTecla

.teclaPageUp.irParaPrimeiraLinha:
	
;; Page Up não disponível
	
	cmp dword[linha], 0
	je .obterTecla
	
	mov byte[necessarioRedesenhar], 1
	
	mov esi, bufferArquivo
	mov eax, 0
	mov dword[linha], eax
	
	call posicaoLinha
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi
	
;; Calcular valores para a linha
	
	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha			
	
	mov byte[posicaoAtualNaLinha], dl	;; Cursor no fim da linha
	mov byte[tamanhoLinhaAtual], dl		
	
	jmp .teclaPageUp.fim


.teclaPageDown:
	
	mov eax, dword[linha]
	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	
	add eax, ebx
	
	cmp eax, dword[totalLinhas]
	jae .teclaPageDown.irParaUltimaLinha
	
;; Não redesenhar se primeira linha
	
	cmp byte[posicaoLinhaNaTela], 1
	jle .teclaPageDown.naoNecessarioRedesenhar
	
	mov byte[necessarioRedesenhar], 1
	
.teclaPageDown.naoNecessarioRedesenhar:
	
;; Próxima linha

	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	
	add dword[linha], ebx
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi

;; Calcular valores para a linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				

	mov byte[posicaoAtualNaLinha], dl	
	mov byte[tamanhoLinhaAtual], dl		

	mov bl, byte[maxLinhas]
	
	sub bl, 2
	
	mov byte[posicaoLinhaNaTela], bl

	mov eax, dword[linha]
	movzx ebx, byte[maxLinhas]
	
	sub bl, 3
	sub eax, ebx
	
	mov esi, bufferArquivo
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoPaginaAtual], esi
	
	jmp .obterTecla

.teclaPageDown.irParaUltimaLinha:

;; Page Down não disponível
	
	mov eax, dword[linha]
	
	inc eax
	
	cmp eax, dword[totalLinhas]
	jae .obterTecla

	mov byte[necessarioRedesenhar], 1

;; Próxima linha

	mov eax, dword[totalLinhas]		;; Última linha é o total de linhas - 1
	
	dec eax
	
	mov dword[linha], eax		;; Fazer da última linha a linha atual
	
	mov esi, bufferArquivo
	mov eax, dword[linha]
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoLinhaAtual], esi

;; Calcular valores para essa linha

	mov edx, 0
	mov esi, bufferArquivo
	
	add esi, dword[posicaoLinhaAtual]
	
	call tamanhoLinha				

	mov byte[posicaoAtualNaLinha], dl	
	mov byte[tamanhoLinhaAtual], dl		
	
	movzx ebx, byte[maxLinhas]
	
	sub ebx, 3
	
	cmp dword[totalLinhas], ebx		;; Checar por arquivos pequenos ou grandes
	jae .maisQueUmaPagina
	
;; Se arquivo pequeno

	mov ebx, dword[totalLinhas]
	
	dec ebx

;; Se arquivo grande

.maisQueUmaPagina:
	
	inc bl
	
	mov byte[posicaoLinhaNaTela], bl
	
	mov eax, dword[linha]
	
	sub eax, ebx
	
	inc eax
	
	mov esi, bufferArquivo
	
	call posicaoLinha
	
	jc .obterTecla
	
	sub esi, bufferArquivo
	
	mov dword[posicaoPaginaAtual], esi
	
	jmp .obterTecla
	
.teclaControlS:

	call salvarArquivoEditor
	
	jmp .proximo1

.teclaControlA:

	call abrirArquivoEditor

	jmp .obterTecla
	
;;************************************************************************************
	
fimPrograma:

	;; call salvarArquivoEditor
	
	Hexagonix rolarTela
	
	mov ebx, 00h
	
	Hexagonix encerrarProcesso

;;************************************************************************************
;;
;; Demais funções do aplicativo
;;
;;************************************************************************************

;; Imprimir uma linha da String
;;
;; Entrada:
;;
;; ESI - Endereço do buffer
;;
;; Saída:
;;
;; ESI - Próximo buffer
;; Carry definido no fim do arquivo

imprimirLinha:

	mov edx, 0		;; Contador de caracteres
	
.loopImprimir:

	lodsb
	
	cmp al, 10		;; Fim da linha
	je .fim
	
	cmp al, 0		;; Fim da String
	je .fimArquivo
	
	movzx ebx, byte[maxColunas]
	dec bl
	
	cmp edx, ebx
	jae .tamanhoMaximoLinha
	
	pushad
	
	mov ebx, 01h
	
	Hexagonix imprimirCaractere		;; Imprimir caractere em AL
	
	popad
	
	inc edx
	
	jmp .loopImprimir		;; Mais caracteres
	
.tamanhoMaximoLinha:

	jmp .loopImprimir
	
.fimArquivo:

	stc
	
.fim:	

	ret

;;************************************************************************************

;; Encontrar tamanho da linha
;;
;; Entrada:
;;
;; ESI - Endereço do buffer
;;
;; Saída:
;;
;; ESI - Próximo buffer
;; EDX - += tamanho da linha

tamanhoLinha:
	
	mov al, byte[esi]

	inc esi
	
	cmp al, 10		;; Fim da linha
	je .fim
	
	cmp al, 0		;; Fim da string
	je .fim
	
	inc edx
	
	jmp tamanhoLinha		;; Mais caracteres

.fim:	

	ret
	
;;************************************************************************************

;; Encontrar endereço da linha na string
;;
;; Entrada:
;;
;; ESI - String
;; EAX - Número da linha (contando de 0)
;;
;; Saída:
;;
;; ESI - Posição da string na linha
;; Carry definido em linha não encontrada

posicaoLinha:

	push ebx
	
	cmp eax, 0
	je .linhaDesejadaEncontrada	;; Já na primeira linha
	
	mov edx, 0		;; Contador de linhas
	mov ebx, eax	;; Salvar linha
	
	dec ebx
	
.proximoCaractere:
	
	mov al, byte[esi]
	
	inc esi
	
	cmp al, 10		;; Caractere de nova linha
	je .linhaEncontrada
	
	cmp al, 0		;; Fim da string
	je .linhaNaoEncontrada
	
	jmp .proximoCaractere
	
.linhaEncontrada:

	cmp edx, ebx
	je .linhaDesejadaEncontrada
	
	inc edx			;; Contador de linhas
	
	jmp .proximoCaractere
	
.linhaDesejadaEncontrada:

	clc
	
	jmp .fim
	
.linhaNaoEncontrada:

	stc
	
.fim:

	pop ebx
	
	ret

;;************************************************************************************

salvarArquivoEditor:

	cmp byte[nomeArquivo], 0
	jne .naoNovoArquivo

;; Obter nome de arquivo

	mov eax, PRETO
	mov ebx, CINZA_CLARO
	
	Hexagonix definirCor
	
	mov al, byte[maxLinhas]
	
	sub al, 2
	
	Hexagonix limparLinha

	mov dl, 0
	mov dh, byte[maxLinhas]
	
	sub dh, 2
	
	Hexagonix definirCursor
	
	mov esi, quartzo.solicitarArquivo
	
	imprimirString
	
	mov eax, 12				;; Máximo de caracteres
	
	Hexagonix obterString
	
	Hexagonix tamanhoString
	
	cmp eax, 0
	je .fim
	
;; Salvar nome de arquivo

	push es
	
	push ds
	pop es					;; ES = DS
	
	mov edi, nomeArquivo
	mov ecx, eax				;; Caracteres no nome de arquivo
	
	inc ecx					    ;; Incluindo NULL
	
	rep movsb
	
;; Adicionar ao rodapé

	mov ecx, eax			;; Caracteres do nome do arquivo
	
	inc ecx					
	
	mov esi, nomeArquivo
	mov edi, quartzo.rodapePrograma+tamanhoRodape
	
	rep movsb
	
	pop es
	
	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor
	
	jmp .continuar
	
.naoNovoArquivo:

;; Se o arquivo já existe, delete-o

	mov esi, nomeArquivo
	
	Hexagonix deletarArquivo
	
	jc .erroDeletando

.continuar:
	
;; Encontrar tamanho do arquivo

	mov esi, bufferArquivo
	
	Hexagonix tamanhoString
	
;; Salvar arquivo

	mov esi, nomeArquivo
	mov edi, bufferArquivo
	
	Hexagonix salvarArquivo

;; Exibir mensagem de salvamento

	mov eax, BRANCO_ANDROMEDA
	mov ebx, VERDE
	
	Hexagonix definirCor
	
	mov al, byte[maxLinhas]
	
	sub al, 2
	
	Hexagonix limparLinha

	mov dl, 0
	mov dh, byte[maxLinhas]
	
	sub dh, 2
	
	Hexagonix definirCursor

	mov esi, quartzo.arquivoSalvo
	
	imprimirString

.fim:

	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor
	
	mov byte[necessarioRedesenhar], 1
	
	ret

.erroDeletando:
	
	cmp eax, IO.operacaoNegada
	je .permissaoNegada
	
	mov eax, PRETO
	mov ebx, CINZA_CLARO
	
	Hexagonix definirCor
	
	mov al, byte[maxLinhas]
	
	sub al, 2
	
	Hexagonix limparLinha

	mov dl, 0
	mov dh, byte[maxLinhas]
	
	sub dh, 2
	
	Hexagonix definirCursor
	
	mov esi, quartzo.erroDeletando
	
	imprimirString
	
	Hexagonix aguardarTeclado
	
	jmp .fim
	
.permissaoNegada:

	mov eax, BRANCO_ANDROMEDA
	mov ebx, VERMELHO_TIJOLO
	
	Hexagonix definirCor
	
	mov al, byte[maxLinhas]
	
	sub al, 2
	
	Hexagonix limparLinha

	mov dl, 0
	mov dh, byte[maxLinhas]
	
	sub dh, 2
	
	Hexagonix definirCursor
	
	mov esi, quartzo.permissaoNegada
	
	imprimirString
	
	jmp .fim
	
;;************************************************************************************

abrirArquivoEditor:

;; Obter nome de arquivo

	mov eax, BRANCO_ANDROMEDA
	mov ebx, VERDE
	
	Hexagonix definirCor
	
	mov al, byte[maxLinhas]
	
	sub al, 2
	
	Hexagonix limparLinha

	mov dl, 0
	mov dh, byte[maxLinhas]
	
	sub dh, 2
	
	Hexagonix definirCursor
	
	mov esi, quartzo.solicitarArquivo
	
	imprimirString
	
	mov eax, 12				;; Máximo de caracteres
	
	Hexagonix obterString
	
	Hexagonix tamanhoString
	
	cmp eax, 0
	je .fim
	
;; Salvar nome de arquivo

	push es
	
	push ds
	pop es					;; ES = DS
	
	mov edi, nomeArquivo
	mov ecx, eax				;; Caracteres no nome de arquivo
	
	inc ecx					    ;; Incluindo NULL
	
	rep movsb
	
;; Adicionar ao rodapé

	mov ecx, eax			;; Caracteres do nome do arquivo
	
	inc ecx					
	
	mov esi, nomeArquivo
	mov edi, quartzo.rodapePrograma+tamanhoRodape
	
	rep movsb
	
	pop es
	
	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor

	mov byte[necessarioRedesenhar], 1

	jmp Quartzo.carregarArquivo

.fim:

	mov eax, dword[quartzo.corFonte]
	mov ebx, dword[quartzo.corFundo]
	
	Hexagonix definirCor
	
	mov byte[necessarioRedesenhar], 1
	
	ret
	
;;************************************************************************************

;;************************************************************************************
;;
;; Buffer para armazenamento do arquivo solicitado
;;
;;************************************************************************************

bufferArquivo: db 10
