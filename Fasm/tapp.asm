;; Este e um template para a construcao de um app de modo texto para 
;; o Andromeda(R)!
;;
;; Escrito por Felipe Miguel Nery Lunkes em 04/12/2020
;;
;; Voce pode gerar uma imagem HAPP executavel utilizando o montador
;; FASM incluido. Para isso, utilize a linha de comando abaixo:
;;
;; fasmX tapp.asm
;;       ou
;; fasmX tapp.asm tapp.app


;; Agora, vamos definir o formato da imagem gerada. Como o fasmX nao
;; tem suporte nativo ao formato HAPP, vamos gerar uma imagem binaria
;; simples e vamos adicionar as informacoes especificas do formato com
;; o cabecalho que esta definido abaixo, gerando de forma indireta uma
;; imagem HAPP completa. Tambem vamos definir que o nome da imagem gerada
;; sera o mesmo do arquivo .asm, mas como a extensao .app, que deve ser
;; reconhecida pelo shell. Para isso, devemos usar:
;;
;; format binary as "app". O formato binario ja e o padrao e, caso o
;; usuario insira fasmx tapp.asm tapp.app, toda essa linha pode ser
;; ignorada e a linha abaixo nao precisa estar no codigo.

format binary as "app" ;; Especifica o formato e extensao do arquivo

use32

cabecalhoAPP:

.assinatura:      db "HAPP"    ;; Assinatura
.arquitetura:     db 01h       ;; Arquitetura (i386 = 01h)
.versaoMinima:    db 9         ;; Versao minima do Hexagon(R)
.subversaoMinima: db 00        ;; Subversao minima do Hexagon(R)
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

include "hexagon.s" ;; Incluir as chamadas de sistema

;;*************************************************************

;; Variaveis e constantes

msg: db 10, 10, "Este e um template com um exemplo de aplicativo HAPP simples!", 10, 0

;;*************************************************************

;; Ponto de entrada

inicioAPP:

    mov esi, msg

    imprimirString

    Hexagonix encerrarProcesso
