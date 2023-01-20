;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2023 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
;; utilizar qualquer trecho deste arquivo.
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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, LyokoIDE, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "erros.s"
include "dispositivos.s"
include "macros.s"

;;************************************************************************************

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

;; Aparência (cores)

CORDESTAQUE = VERMELHO_TIJOLO
CORLISTRA   = LARANJA

tamanhoParaNomeArquivo = 8

;; Constantes e estruturas

VERSAO        equ "1.5.1" 
MONTADOR      equ "fasmX"
AUTOR         equ "Copyright (C) 2017-", __stringano, " Felipe Miguel Nery Lunkes"
DIREITOS      equ "All rights reserved."

;; Área de mensagens e variáveis globais

Lyoko:

.rodapeNovoArquivo:   db "New file", 0
.avisoRapido:         db "Lyoko's IDE uses the '", MONTADOR, "' assembler for building applications.", 10
                      db "This open source assembler has been ported and is fully compatible with Hexagonix(R).", 10, 10
                      db "You can use keyboard shortcuts to interact with Lyoko.", 10
                      db "Shortcuts are triggered by the Ctrl (Control, ^) key, along with an action indicator key.", 10
                      db "These key combinations can be (the Ctrl key represented by ^):", 10, 10
                      db " [^A] - Requests to open a previously saved file on disk.", 10
                      db " [^S] - Request to save changes to a file on disk.", 10
                      db " [^F] - Close Lyoko after saving confirmation.", 10
                      db " [^M] - Call '", MONTADOR, "' assembler to build the executable image.", 10
                      db " [^V] - Version information and more about Lyoko.", 10, 10
                      db "After building an image, you will receive the operation status directly on the screen and, if all", 10
                      db "is correct, you will find the image with the .app extension on the disk containing your application.", 10
                      db "You can use the 'lshapp' tool to verify image information if necessary.", 10
                      db "To learn more about the information the utility can provide when analyzing an image,", 10
                      db "see manual ('man lshapp') or use 'lshapp ?'.", 0
.formato:             db "UTF-8", 0
.formatoFimLinha:     db "LF", 0
.virgula:             db ", ", 0
.separador:           db " | ", 0
.rodapePrograma:      db "[^F] Exit | [^A] Open | [^S] Save | [^M] Assemble", 0
.linha:               db "Line: ", 0
.coluna:              db "Column: ", 0
.arquivoSalvo:        db "File saved", 0
.solicitarArquivo:    db "File name [ENTER to cancel]: ", 0
.permissaoNegada:     db "Only an administrative user can change this file."
                      db " Press any key to continue...", 0
.erroDeletando:       db "Error updating file.", 0
.tituloPrograma:      db "Lyoko - An IDE for Hexagonix(R) - Version ", VERSAO, 0
.fasmX:               db MONTADOR, 0
.semFonte:            db "No source file specified. Try saving your file to disk first.", 10, 10
                      db 0
.avisoSalvamento:     db "The contents of the file have been changed and not saved. This may lead to data loss.", 10, 10
                      db "Do you want to save your changes to the file? (Y/n)", 10, 0
.saida:               db "appX.app", 0
.tamanhoLinha:        dd 0
.identificador:       db "| File:               ", 0
.nomeMontador:        db "| ", MONTADOR, 0
.fecharAviso:         db 10, 10, "Press [ESC] to close this warning.", 10, 0
.infoLyoko:           db "The name Lyoko comes from a series that marked me a lot in childhood, called Code Lyoko.", 10
                      db "In a way, this series made me fall even more in love with computing and nothing else", 10
                      db "It's fair to pay a symbolic tribute.", 10, 10
                      db "Lyoko was designed to be a simple and easy to use IDE for developing applications", 10
                      db "natives for Hexagonix on the system itself. It is also being used for development", 10
                      db "various components of the operating system itself.", 10
                      db "Lyoko is gaining more and more functions and is also constantly updated.", 10, 10
                      db "Version of this edition of Lyoko: ", VERSAO, 10, 10
                      db AUTOR, 10
                      db DIREITOS, 10, 0
.boasVindas:          db "Welcome to Lyoko, the official IDE for Hexagonix(R)!", 10, 10
                      db "With Lyoko, you can quickly write and build wonderful applications for Hexagonix(R).", 10
                      db "You can at any time press [^X] (Ctrl+X) for help.", 10, 10
                      db "Shall we start?", 10, 10
                      db "You can start by pressing Ctrl-A [^A] to open a file or press [ESC] and start", 10
                      db "encode your project right now!" , 10, 10
                      db "Press [ESC] to close the welcome and go directly to the editor.", 10, 0
.solicitandoMontagem: db "Running the assembler (", MONTADOR, ") to generate your app...", 10, 10, 0
.editado:             db " *", 0 ;; O arquivo foi editado?
.tituloAlterado:      db 0  ;; Título alterado?
.caixaMaior:          db 0  ;; Tamanho da caixa (relativo à resolução da tela)
.corFonte:            dd 0  ;; Cor a ser utilizada na fonte
.corFundo:            dd 0  ;; Cor a ser utilizada no fundo
.alterado:            db 0  ;; Armazenará se o buffer foi alterado pelo usuário
.primeiraExecucao:    db 0  ;; Primeira vez que a função inicial é chamada?

totalLinhas:          dd 0  ;; Contador de linhas no arquivo
linha:                dd 0  ;; Linha atual no arquivo
posicaoLinhaAtual:    dd 0  ;; Posição da linha atual em todo o arquivo
posicaoAtualNaLinha:  dd 0  ;; Posição do cursor na linha atual
tamanhoLinhaAtual:    dd 0  ;; Tamanho da linha atual
posicaoLinhaNaTela:   dd 1  ;; Posição da linha no display
posicaoPaginaAtual:   dd 0  ;; Posição da página atual no arquivo (uma tela)
necessarioRedesenhar: db 1  ;; Se não zero, é necessário redesenhar toda a tela
nomeArquivo: times 13 db 0  ;; Espaço para armazenamento do nome do arquivo
maxColunas:           db 0  ;; Total de colunas disponíveis no vídeo na resolução atual
maxLinhas:            db 0  ;; Total de linhas disponíveis no vídeo na resolução atual
linhaParametros:      db 30 ;; Tamanho de parâmetro
resolucao:            dd 0  ;; Resolução de vídeo

;;************************************************************************************

;; Função inicial

LyokoIDE:

    hx.syscall obterInfoTela
    
    mov byte[maxColunas], bl
    mov byte[maxLinhas], bh
    
    mov byte[Lyoko.primeiraExecucao], 01h

    hx.syscall obterCor

    mov dword[Lyoko.corFonte], eax
    mov dword[Lyoko.corFundo], ebx

    hx.syscall obterResolucao

    mov dword[resolucao], eax

    cmp byte[edi], 0            ;; Em caso de falta de argumentos
    je .novoArquivo
    
    mov esi, edi                ;; Argumentos do programa
    
    hx.syscall tamanhoString
    
    cmp eax, 12                 ;; Nome de arquivo inválido
    ja .novoArquivo
    
;; Salvar nome do arquivo

    push es
    
    push ds
    pop es                  ;; DS = ES
    
    mov edi, nomeArquivo
    mov ecx, eax            ;; Caracteres no nome do arquivo
    
    inc ecx                 ;; Incluindo o caractere NULL
    
    rep movsb
    
    pop es

.carregarArquivo:

;; Ler arquivo
    
    mov esi, nomeArquivo
    
    hx.syscall arquivoExiste
    
    jc .novoArquivo             ;; O arquivo não existe
    
    mov esi, nomeArquivo
    
    mov edi, bufferArquivo      ;; Endereço para o carregamento
    
    hx.syscall abrir
    
    mov esi, nomeArquivo
    
    hx.syscall tamanhoString
    
    mov ecx, eax

;; Adicionar nome do arquivo no rodapé

    push es
    
    push ds
    pop es                     ;; ES = DS

;; Agora o nome do arquivo aberto será exibido na interface do aplicativo
    
    mov edi, Lyoko.identificador+tamanhoParaNomeArquivo ;; Posição
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
    
    mov esi, Lyoko.rodapeNovoArquivo
    mov edi, Lyoko.identificador+tamanhoParaNomeArquivo ;; Posição
    
    rep movsb
    
    pop es
    
.inicio:

    mov al, 10              ;; Caractere de nova linha
    
    mov esi, bufferArquivo
    
    hx.syscall encontrarCaractere
    
    mov dword[totalLinhas], eax
    
    mov dword[posicaoLinhaAtual], 0
    
    mov edx, 0
    mov esi, bufferArquivo
    
    add esi, dword[posicaoLinhaAtual]
    
    call tamanhoLinha                   ;; Encontrar tamanho da linha atual
    
    mov byte[posicaoAtualNaLinha], dl   ;; Cursor no final da linha
    mov byte[tamanhoLinhaAtual], dl     ;; Salvar tamanho da linha atual
    
    mov dword[posicaoPaginaAtual], 0

    jmp .obterTecla
    
;; Leitura

.obterTecla:

    cmp byte[necessarioRedesenhar], 00h
    je .outrasLinhasImpressas           ;; Não é necessário imprimir outras linhas

;; Imprimir outras linhas

    mov esi, video.vd1
    
    hx.syscall abrir
    
    hx.syscall limparTela
    
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
    
    hx.syscall definirCor
    
    mov al, 0
    
    hx.syscall limparLinha
    
    mov esi, Lyoko.tituloPrograma
    
    imprimirString
    
    mov al, byte[maxLinhas]     ;; Última linha
    
    dec al
    
    hx.syscall limparLinha
    
    mov esi, Lyoko.rodapePrograma
    
    imprimirString

    hx.syscall obterCursor

    mov dl, byte[maxColunas]

    sub dl, 48

    hx.syscall definirCursor

    mov esi, Lyoko.nomeMontador

    imprimirString

    mov dl, byte[maxColunas]

    sub dl, 41

    hx.syscall definirCursor

    mov esi, Lyoko.separador

    imprimirString

    mov esi, Lyoko.formato

    imprimirString

    mov esi, Lyoko.separador

    imprimirString

    mov dl, byte[maxColunas]
    
    sub dl, 30
    
    mov dh, 0
    
    hx.syscall definirCursor

    mov esi, Lyoko.identificador
    
    imprimirString

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
;; Atualizar tela

.atualizarBuffer:

    hx.syscall atualizarTela
     
    mov esi, video.vd0
    
    hx.syscall abrir
    
.outrasLinhasImpressas:
    
    mov byte[necessarioRedesenhar], 0

    mov dl, 0
    mov dh, byte[posicaoLinhaNaTela]
    
    hx.syscall definirCursor
        
;; Imprimir linha atual

    mov esi, bufferArquivo
    
    add esi, dword[posicaoLinhaAtual]
    
    call imprimirLinha
    
    mov al, ' '

    hx.syscall imprimirCaractere
    
;; Imprimir linha e coluna atuais

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor

    mov dl, byte[maxColunas]
    
    sub dl, 30
    
    mov dh, byte[maxLinhas]
    
    dec dh
    
    hx.syscall definirCursor

    mov esi, Lyoko.linha
    
    imprimirString
    
    mov eax, dword[linha]
    
    inc eax                 ;; Contando de 1
    
    imprimirInteiro
    
    mov esi, Lyoko.virgula

    imprimirString

    mov esi, Lyoko.coluna
    
    imprimirString
    
    movzx eax, byte[posicaoAtualNaLinha]
    
    inc eax                 ;; Contando de 1
    
    imprimirInteiro
    
    mov al, ' '
    
    hx.syscall imprimirCaractere
    
    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor

    cmp byte[Lyoko.primeiraExecucao], 01h
    je exibirBoasVindas

.proximo1:

;; Colocar cursor na posição atual na linha

    mov dl, byte[posicaoAtualNaLinha]
    mov dh, byte[posicaoLinhaNaTela]
    
    hx.syscall definirCursor

;; Obter teclas
    
.prontoParaTecla:

    hx.syscall aguardarTeclado
    
    push eax
    
    hx.syscall obterEstadoTeclas
    
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

    mov byte [Lyoko.alterado], 1

    mov bl, byte[maxColunas]
    
    dec bl
    
    cmp byte[tamanhoLinhaAtual], bl
    jae .obterTecla
    
    mov edx, 0
    movzx esi, byte[posicaoAtualNaLinha]    ;; Posição para inserir caracteres
    
    add esi, dword[posicaoLinhaAtual]
    add esi, bufferArquivo
    
    hx.syscall inserirCaractere          ;; Inserir char na string
    
    inc byte[posicaoAtualNaLinha]       ;; Um caractere foi adicionado
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
    
    hx.syscall inserirCaractere
    
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
    
    call tamanhoLinha                   ;; Encontrar tamanho para essa linha
    
    mov byte[posicaoAtualNaLinha], 0    ;; Cursor no fim da linha
    mov byte[tamanhoLinhaAtual], dl     ;; Salvar o tamanho atual da linha

    mov al, 10                          ;; Caractere de nova linha
    mov esi, bufferArquivo
    
    hx.syscall encontrarCaractere
    
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

    cmp al, 'x'
    je .teclaControlX
    
    cmp al, 'X'
    je .teclaControlX

    cmp al, 'a'
    je .teclaControlA
    
    cmp al, 'A'
    je .teclaControlA

    cmp al, 'v'
    je .teclaControlV
    
    cmp al, 'V'
    je .teclaControlV

    cmp al, 'm'
    je .teclaControlM
    
    cmp al, 'M'
    je .teclaControlM
    
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
    
    hx.syscall removerCaractereString
    
    dec byte[posicaoAtualNaLinha]   ;; Um caractere foi removido
    dec byte[tamanhoLinhaAtual]

    jmp .obterTecla

.teclaBackspace.primeiraColuna:
    
    cmp byte[linha], 0
    je .obterTecla

;; Calcular tamanho anterior da linha

    mov esi, bufferArquivo
    mov eax, dword[linha]
    
    dec eax                         ;; Linha anterior
    
    call posicaoLinha
    
    jc .obterTecla

    sub esi, bufferArquivo
    
    mov edx, 0
    
    add esi, bufferArquivo
    
    call tamanhoLinha               ;; Encontrar tamanho
    
    push edx                        ;; Salvar tamanho da linha
    
    add dl, byte[tamanhoLinhaAtual]
    
;; Backspace não habilitado (suporte de até 79 caracteres por linha)

    mov bl, byte[maxColunas]
    
    dec bl
    
    cmp dl, bl                      ;; Contando de 0
    jae .obterTecla

;; Remover caractere de nova linha

    mov byte[necessarioRedesenhar], 1
    
    movzx eax, byte[posicaoAtualNaLinha]
    
    add eax, dword[posicaoLinhaAtual]
    
    dec eax

    mov esi, bufferArquivo
    
    hx.syscall removerCaractereString
    
    dec byte[totalLinhas]           ;; Uma linha foi removida
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
    
    call tamanhoLinha                   ;; Encontrar tamanho da linha atual
    
    mov byte[tamanhoLinhaAtual], dl     ;; Salvar tamanho da linha
    
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
    
    hx.syscall removerCaractereString
    
    dec byte[tamanhoLinhaAtual] ;; Um caractere foi removido
    
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
    
    mov byte[posicaoAtualNaLinha], 0    ;; Cursor no fim da linha
    mov byte[tamanhoLinhaAtual], dl     ;; Salvar tamanho da linha
    
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
    
    jmp .teclaCima.cursorMovido         ;; Não alterar a coluna do cursor
    
.teclaCima.moverCursorAteOFim:

    mov byte[posicaoAtualNaLinha], dl   ;; Cursor ao fim da linha
    
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
    
    jmp .teclaBaixo.cursorMovido            ;; Não alterar a coluna
    
.teclaBaixo.moverCursorAteOFim:

    mov byte[posicaoAtualNaLinha], dl   ;; Cursor ao fim da linha
    
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
    
    mov byte[posicaoAtualNaLinha], dl   ;; Cursor no fim da linha
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
    
    mov byte[posicaoAtualNaLinha], dl   ;; Cursor no fim da linha
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

    mov eax, dword[totalLinhas]     ;; Última linha é o total de linhas - 1
    
    dec eax
    
    mov dword[linha], eax       ;; Fazer da última linha a linha atual
    
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
    
    cmp dword[totalLinhas], ebx     ;; Checar por arquivos pequenos ou grandes
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

.teclaControlX:

    call exibirAjuda
    
    jmp .proximo1

.teclaControlV:

    call exibirInfo
    
    jmp .proximo1

.teclaControlM:

    call realizarMontagem
    
    jmp .proximo1

.teclaControlA:

    call abrirArquivoEditor

    jmp .obterTecla
    
;;************************************************************************************
    
fimPrograma:

    mov ah, byte[Lyoko.alterado]

    cmp ah, 0
    je .terminar 

    call montarAviso

    mov esi, Lyoko.avisoSalvamento

    imprimirString

.loopTeclas:

    hx.syscall aguardarTeclado
    
    cmp al, 's'
    je .iniciarSalvamento

    cmp al, 'S'
    je .iniciarSalvamento

    cmp al, 'n'
    je .terminar

    cmp al, 'N'
    je .terminar

jmp .loopTeclas

.iniciarSalvamento:

    call salvarArquivoEditor

.terminar: 

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor

    hx.syscall rolarTela
    
    mov ebx, 00h
    
    hx.syscall encerrarProcesso

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

    mov edx, 0      ;; Contador de caracteres
    
.loopImprimir:

    lodsb
    
    cmp al, 10      ;; Fim da linha
    je .fim
    
    cmp al, 0       ;; Fim da String
    je .fimArquivo
    
    movzx ebx, byte[maxColunas]
    dec bl
    
    cmp edx, ebx
    jae .tamanhoMaximoLinha
    
    pushad
    
    mov ebx, 01h
    
    hx.syscall imprimirCaractere     ;; Imprimir caractere em AL
    
    popad
    
    inc edx
    
    jmp .loopImprimir       ;; Mais caracteres
    
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
    
    cmp al, 10      ;; Fim da linha
    je .fim
    
    cmp al, 0       ;; Fim da string
    je .fim
    
    inc edx
    
    jmp tamanhoLinha        ;; Mais caracteres

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
    je .linhaDesejadaEncontrada ;; Já na primeira linha
    
    mov edx, 0      ;; Contador de linhas
    mov ebx, eax    ;; Salvar linha
    
    dec ebx
    
.proximoCaractere:
    
    mov al, byte[esi]
    
    inc esi
    
    cmp al, 10      ;; Caractere de nova linha
    je .linhaEncontrada
    
    cmp al, 0       ;; Fim da string
    je .linhaNaoEncontrada
    
    jmp .proximoCaractere
    
.linhaEncontrada:

    cmp edx, ebx
    je .linhaDesejadaEncontrada
    
    inc edx         ;; Contador de linhas
    
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
    
    hx.syscall definirCor
    
    mov al, byte[maxLinhas]
    
    sub al, 2
    
    hx.syscall limparLinha

    mov dl, 0
    mov dh, byte[maxLinhas]
    
    sub dh, 2
    
    hx.syscall definirCursor
    
    mov esi, Lyoko.solicitarArquivo
    
    imprimirString
    
    mov eax, 12             ;; Máximo de caracteres
    
    hx.syscall obterString
    
    hx.syscall tamanhoString
    
    cmp eax, 0
    je .fim
    
;; Salvar nome de arquivo

    push es
    
    push ds
    pop es                  ;; ES = DS
    
    mov edi, nomeArquivo
    mov ecx, eax                ;; Caracteres no nome de arquivo
    
    inc ecx                     ;; Incluindo NULL
    
    rep movsb
    
;; Adicionar ao rodapé

    mov ecx, eax            ;; Caracteres do nome do arquivo
    
    inc ecx                 
    
    mov esi, nomeArquivo
    mov edi, Lyoko.identificador+tamanhoParaNomeArquivo
    
    rep movsb
    
    pop es
    
    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    jmp .continuar
    
.naoNovoArquivo:

;; Se o arquivo já existe, delete-o

    mov esi, nomeArquivo
    
    hx.syscall deletarArquivo
    
    jc .erroDeletando

.continuar:
    
;; Encontrar tamanho do arquivo

    mov esi, bufferArquivo
    
    hx.syscall tamanhoString
    
;; Salvar arquivo

    mov esi, nomeArquivo
    mov edi, bufferArquivo
    
    hx.syscall salvarArquivo

;; Exibir mensagem de salvamento

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERDE
    
    hx.syscall definirCor
    
    mov al, byte[maxLinhas]
    
    sub al, 2
    
    hx.syscall limparLinha

    mov dl, 0
    mov dh, byte[maxLinhas]
    
    sub dh, 2
    
    hx.syscall definirCursor

    mov esi, Lyoko.arquivoSalvo
    
    imprimirString

    mov byte [Lyoko.alterado], 0 ;; Limpar o status de alterado

.fim:

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1
    
    ret

.erroDeletando:
    
    cmp eax, IO.operacaoNegada
    je .permissaoNegada
    
    mov eax, PRETO
    mov ebx, CINZA_CLARO
    
    hx.syscall definirCor
    
    mov al, byte[maxLinhas]
    
    sub al, 2
    
    hx.syscall limparLinha

    mov dl, 0
    mov dh, byte[maxLinhas]
    
    sub dh, 2
    
    hx.syscall definirCursor
    
    mov esi, Lyoko.erroDeletando
    
    imprimirString
    
    hx.syscall aguardarTeclado
    
    jmp .fim
    
.permissaoNegada:

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor
    
    mov al, byte[maxLinhas]
    
    sub al, 2
    
    hx.syscall limparLinha

    mov dl, 0
    mov dh, byte[maxLinhas]
    
    sub dh, 2
    
    hx.syscall definirCursor
    
    mov esi, Lyoko.permissaoNegada
    
    imprimirString
    
    jmp .fim
    
;;************************************************************************************

abrirArquivoEditor:

;; Obter nome de arquivo

    mov eax, BRANCO_ANDROMEDA
    mov ebx, VERDE
    
    hx.syscall definirCor
    
    mov al, byte[maxLinhas]
    
    sub al, 2
    
    hx.syscall limparLinha

    mov dl, 0
    mov dh, byte[maxLinhas]
    
    sub dh, 2
    
    hx.syscall definirCursor
    
    mov esi, Lyoko.solicitarArquivo
    
    imprimirString
    
    mov eax, 12             ;; Máximo de caracteres
    
    hx.syscall obterString
    
    hx.syscall tamanhoString
    
    cmp eax, 0
    je .fim
    
;; Salvar nome de arquivo

    push es
    
    push ds
    pop es                  ;; ES = DS
    
    mov edi, nomeArquivo
    mov ecx, eax                ;; Caracteres no nome de arquivo
    
    inc ecx                     ;; Incluindo NULL
    
    rep movsb
    
;; Adicionar ao rodapé

    mov ecx, eax            ;; Caracteres do nome do arquivo
    
    inc ecx                 
    
    mov esi, nomeArquivo
    mov edi, Lyoko.identificador+tamanhoParaNomeArquivo
    
    rep movsb
    
    pop es
    
    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor

    mov byte[necessarioRedesenhar], 1

    jmp LyokoIDE.carregarArquivo

.fim:

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1
    
    ret
    
;;************************************************************************************

evidenciarEdicao:

    push es
    
    push ds
    pop es                  ;; ES = DS
    
    mov edi, Lyoko.editado
    mov ecx, eax                ;; Caracteres no nome de arquivo
    
    inc ecx                     ;; Incluindo NULL
    
    rep movsb
    
;; Adicionar ao rodapé

    mov ecx, eax            ;; Caracteres do nome do arquivo
    
    inc ecx                 
    
    mov esi, Lyoko.editado
    mov edi, Lyoko.identificador+tamanhoParaNomeArquivo+8
    
    rep movsb
    
    pop es

    mov byte[necessarioRedesenhar], 1
    
    ret

;;************************************************************************************

realizarMontagem:

    call montarAviso

    mov esi, Lyoko.solicitandoMontagem

    imprimirString

    mov esi, nomeArquivo

    cmp byte[esi], 0
    je .semFonte

    mov esi, Lyoko.fasmX
    mov edi, nomeArquivo

    hx.syscall iniciarProcesso

    jmp .fim

.semFonte:

    mov esi, Lyoko.semFonte

    imprimirString

.fim:

    mov esi, Lyoko.fecharAviso

    imprimirString

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1
    
    jmp LyokoIDE.proximo1
    
;;************************************************************************************

exibirAjuda:

    mov byte[Lyoko.caixaMaior], 01h

    call montarAviso

    mov esi, Lyoko.avisoRapido

    imprimirString

.fim:

    mov esi, Lyoko.fecharAviso

    imprimirString

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1
    
    ret

;;************************************************************************************

exibirInfo:

    mov byte[Lyoko.caixaMaior], 01h

    call montarAviso

    mov esi, Lyoko.infoLyoko

    imprimirString

.fim:

    mov esi, Lyoko.fecharAviso

    imprimirString

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1
    
    ret
    
;;************************************************************************************

exibirBoasVindas:

    call montarAviso

    mov esi, Lyoko.boasVindas

    imprimirString

.fim:

    mov eax, dword[Lyoko.corFonte]
    mov ebx, dword[Lyoko.corFundo]
    
    hx.syscall definirCor
    
    mov byte[necessarioRedesenhar], 1

    mov byte[Lyoko.primeiraExecucao], 00h
    
    jmp LyokoIDE.proximo1
    
;;************************************************************************************

montarAviso:

    cmp byte[Lyoko.caixaMaior], 01h
    je .checarResolucaoCaixaMaior

.checarResolucaoCaixaMenor:

    cmp dword[resolucao], 01h
    je .caixaMenorResolucao1

    cmp dword[resolucao], 02h
    je .caixaMenorResolucao2

    jmp .fim

.checarResolucaoCaixaMaior:

    cmp dword[resolucao], 01h
    je .caixaMaiorResolucao1

    cmp dword[resolucao], 02h
    je .caixaMaiorResolucao2

    jmp .fim

.caixaMenorResolucao1:

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 350 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 200 ;; Altura do bloco
    mov edx, CORDESTAQUE ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 340 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 550 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor

    mov dl, 0h
    mov dh, 22

    hx.syscall definirCursor

    jmp .fim

.caixaMenorResolucao2:

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 470  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 250  ;; Altura do bloco
    mov edx, CORDESTAQUE ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 460  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 710  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor

    mov dl, 0h
    mov dh, 30

    hx.syscall definirCursor

    jmp .fim

.caixaMaiorResolucao1:

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 200 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 360 ;; Altura do bloco
    mov edx, CORDESTAQUE ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 190 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0   ;; Início do bloco em X
    mov ebx, 550 ;; Início do bloco em Y
    mov esi, 800 ;; Comprimento do bloco
    mov edi, 10  ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor

    mov dl, 0h
    mov dh, 14

    hx.syscall definirCursor

    jmp .fim

.caixaMaiorResolucao2:

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 200  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 510  ;; Altura do bloco
    mov edx, CORDESTAQUE ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 190  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, 0    ;; Início do bloco em X
    mov ebx, 710  ;; Início do bloco em Y
    mov esi, 1024 ;; Comprimento do bloco
    mov edi, 10   ;; Altura do bloco
    mov edx, CORLISTRA ;; Cor do bloco
    
    hx.syscall desenharBloco

    mov eax, BRANCO_ANDROMEDA
    mov ebx, CORDESTAQUE
    
    hx.syscall definirCor

    mov dl, 0h
    mov dh, 14

    hx.syscall definirCursor

    jmp .fim

.fim:

    mov byte[Lyoko.caixaMaior], 00h

    ret

;;************************************************************************************

;;************************************************************************************
;;
;; Buffer para armazenamento do arquivo solicitado
;;
;;************************************************************************************

bufferArquivo: db 10
