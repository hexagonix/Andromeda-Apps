;; Este e um template para a construcao de um app de modo grafico para 
;; o Andromeda(R)!
;;
;; Escrito por Felipe Miguel Nery Lunkes em 04/12/2020
;;
;; Voce pode gerar uma imagem HAPP executavel utilizando o montador
;; FASM incluido. Para isso, utilize a linha de comando abaixo:
;;
;; fasmX gapp.asm
;;       ou
;; fasmX gapp.asm gapp.app

;; Agora, vamos definir o formato da imagem gerada. Como o fasmX nao
;; tem suporte nativo ao formato HAPP, vamos gerar uma imagem binaria
;; simples e vamos adicionar as informacoes especificas do formato com
;; o cabecalho que esta definido abaixo, gerando de forma indireta uma
;; imagem HAPP completa. Tambem vamos definir que o nome da imagem gerada
;; sera o mesmo do arquivo .asm, mas como a extensao .app, que deve ser
;; reconhecida pelo shell. Para isso, devemos usar:
;;
;; format binary as "app". O formato binario ja e o padrao e, caso o
;; usuario insira fasmx gapp.asm gapp.app, toda essa linha pode ser
;; ignorada e a linha abaixo nao precisa estar no codigo.

format binary as "app" ;; Especifica o formato e extensao do arquivo

use32

cabecalhoAPP:

.assinatura:      db "HAPP"    ;; Assinatura
.arquitetura:     db 01h       ;; Arquitetura (i386 = 01h)
.versaoMinima:    db 8         ;; Versao minima do Hexagon(R)
.subversaoMinima: db 40        ;; Subversao minima do Hexagon(R)
.pontoEntrada:    dd inicioAPP ;; Offset do ponto de entrada
.tipoImagem:      db 01h       ;; Imagem executavel
.reservado0:      dd 0         ;; Reservado (Dword)
.reservado1:      db 0         ;; Reservado (Byte)
.reservado2:      db 0         ;; Reservado (Byte)
.reservado3:      db 0         ;; Reservado (Byte)
.reservado4:      dd 0         ;; Reservado (Dword)
.reservado5:      dd 0         ;; Reservado (Dword)
.reservado6:      dd 0         ;; Reservado (Dword)
.reservado7:      db 0         ;; Reservado (Byte)
.reservado8:      dw 0         ;; Reservado (Word)
.reservado9:      dw 0         ;; Reservado (Word)
.reservado10:     dw 0         ;; Reservado (Word)

;;*************************************************************

include "andrmda.s" ;; Incluir as chamadas de sistema
include "estelar.s" ;; Inclui funcoes de criacao de interfaces

;;*************************************************************

;; Variaveis e constantes

;; Agora vamos criar uma instancia da estrutura de controle de interfaces
;; para que possamos criar uma
;; Sintaxe: estrutura para o app (instancia), estrutura original

Andromeda.Interface Andromeda.Estelar.Interface

;; Dentro de gapp estarao todos os dados de texto que serao exibidos ao usuario.

gapp:

.mensagemOla: db 10, 10, "Este e um exemplo de aplicativo HAPP grafico do Andromeda(R)!", 10, 10
              db 10, 10, "Pressione qualquer tecla para finalizar este programa...", 10, 10, 0 

.TITULO:      db "Seja bem-vindo!", 0
.RODAPE:      db "[BETA] | Pressione qualquer tecla para continuar...", 0			 	 

.vd0:         db "vd0", 0 ;; Dispositivo padrao de saida

;;************************************************************************************

inicioAPP:

;; Vamos definir que queremos saida direta para vd0 (similar a tty0 no Linux)
;; Isso nem sempre e necessario. Se o shell foi utilizado para chamar o app, 
;; vd0 ja esta aberto. A menos que seja chamado por um app que esteja usando, por
;; exemplo, vd1

    mov esi, gapp.vd0

    Andromeda abrir ;; Abrir dispositivo

;; Pronto, agora vamos continuar. Primeiro, limpar a saida e obter informacoes
;; de resolucao

    Andromeda limparTela

    Andromeda obterInfoTela
	
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh

;; Vamos salvar o esquema de cores atual do Sistema, para consistencia
;; Isso e importante para definir se estamos em modo claro ou escuro de
;; interface

    Andromeda obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

;; Vamos criar a estrutura de interface com titulo e rodape

;; Formato de recebimento de parametros da funcao de criar interfaces:
;; Vale ressaltar que os parametros devem estar na ordem!
;;
;; titulo, rodape, cor do titulo, cor do rodape, cor do texto no titulo,
;; cor do texto no rodape, cor do texto inicial do app, cor de fundo inicial
;;
;; Vocce pode utilizar '\' para quebrar a linha, caso esteja muito grande, como
;; abaixo

    Andromeda.Estelar.criarInterface gapp.TITULO, gapp.RODAPE, VERMELHO_TIJOLO,\
    VERMELHO_TIJOLO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

;; Agora vamos imprimir na interface uma mensagem simples

    mov esi, gapp.mensagemOla

    imprimirString

;; Vamos aguardar interacao do usuario para finalizar o app

    Andromeda aguardarTeclado

;; Interagiu? Ok, vamos finalizar o app

;; Formato:
;;
;; Codigo de erro (neste caso, 0), tipo de saida (neste caso, 0)

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0
	
;;************************************************************************************

