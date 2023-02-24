;;*************************************************************************************************
;;
;; 88                                                                                88              
;; 88                                                                                ""              
;; 88                                                                                                
;; 88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8  
;; 88P'    "88 a8P     88  `P8, ,8P'  ""     `P8 a8"    `P88 a8"     "8a 88P'   `"88 88  `P8, ,8P'   
;; 88       88 8PP"""""""    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(     
;; 88       88 "8b,   ,aa  ,d8" "8b,  88,    ,88 "8a,   ,d88 "8a,   ,a8" 88       88 88  ,d8" "8b,   
;; 88       88  `"Pbbd8"' 8P'     `P8 `"8bbdP"P8  `"PbbdP"P8  `"PbbdP"'  88       88 88 8P'     `P8  
;;                                               aa,    ,88                                         
;;                                                "P8bbdP"       
;;
;;            Sistema Operacional Hexagonix® - Hexagonix® Operating System            
;;
;;                  Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                Todos os direitos reservados - All rights reserved.
;;
;;*************************************************************************************************
;;
;; Português:
;; 
;; O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
;; a licença que governa este arquivo e verifique a licença de cada repositório para
;; obter mais informações sobre seus direitos e obrigações ao utilizar e reutilizar
;; o código deste ou de outros arquivos.
;;
;; English:
;;
;; Hexagonix and its components are licensed under a BSD-3-Clause license. Read below
;; the license that governs this file and check each repository's license for
;; obtain more information about your rights and obligations when using and reusing
;; the code of this or other files.
;;
;;*************************************************************************************************
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
cabecalhoAPP cabecalhoHAPP HAPP.Arquiteturas.i386, 1, 00, inicioAPP, 01h

;;************************************************************************************

include "hexagon.s"
include "Estelar/estelar.s"
include "macros.s"

;;************************************************************************************

inicioAPP:

    hx.syscall obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx
    
    hx.syscall limparTela

    hx.syscall obterInfoTela
    
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh
    
;; Formato: titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo

    Andromeda.Estelar.criarInterface calc.titulo, calc.rodape, \
    VERDE_ESCURO, VERDE_ESCURO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
    
    fputs calc.bannerHexagonix

    call mostrarLogoSistema

    cursorPara 00, 13

;;************************************************************************************

calcular:

;; Obter primeiro número

    fputs calc.primeiroNumero
    
    call obterNumero
    
    mov dword[primeiroNumero], eax      ;; Salvar primeiro número
    
    cmp eax, 0
    je fim

;; Obter segundo número
    
    fputs calc.segundoNumero
    
    call obterNumero
    
    mov dword[segundoNumero], eax       ;; Salvar segundo número
    
    cmp eax, 0
    je fim
    
;; Perguntar qual operação executar

    fputs calc.operacao
    
    hx.syscall aguardarTeclado
    
    cmp al, '0'
    je adicionarNumeros
    
    cmp al, '1'
    je subtrair
    
    cmp al, '2'
    je multiplicar
    
    cmp al, '3'
    je dividir
    
    cmp al, '4'
    je fim

;;************************************************************************************

adicionarNumeros:

    mov eax, dword[primeiroNumero]
    mov ebx, dword[segundoNumero]
    
    add eax, ebx        ;; EAX = EAX + EBX
    
    mov dword[resposta], eax
    
    jmp imprimirResposta

;;************************************************************************************
    
subtrair:

    mov eax, dword[primeiroNumero]
    mov ebx, dword[segundoNumero]
    
    sub eax, ebx        ;; EAX = EAX - EBX
    
    mov dword[resposta], eax
    
    jmp imprimirResposta

;;************************************************************************************
    
multiplicar:

    mov eax, dword[primeiroNumero]
    mov ebx, dword[segundoNumero]
    
    mul ebx             ;; EAX = EAX * EBX
    
    mov dword[resposta], eax
    
    jmp imprimirResposta

;;************************************************************************************
    
dividir:

    cmp ebx, 0
    je .dividirPorZero
        
    mov eax, dword[primeiroNumero]
    mov ebx, dword[segundoNumero]
    mov edx, 0
    
    div ebx             ;; EAX = EAX / EBX
    
    mov dword[resposta], eax

    jmp imprimirResposta

;;************************************************************************************
    
.dividirPorZero:

    fputs calc.dividirPorZero
    
    jmp imprimirResposta.proximo

;;************************************************************************************
    
imprimirResposta:

    novaLinha
    
    fputs calc.resultado
        
    mov eax, dword[resposta]
    
    imprimirInteiro
    
.proximo:

    novaLinha
    novaLinha

    fputs calc.solicitarTecla
    
    hx.syscall aguardarTeclado
    
    jmp inicioAPP

;;************************************************************************************
    
;; Obter um número do teclado
;;
;; Saída:
;;
;; EAX - Número

obterNumero:

    mov al, 10          ;; Máximo de 10 caracteres
    
    hx.syscall obterString
    
    hx.syscall cortarString
    
    hx.syscall stringParaInt
    
    push eax
    
    novaLinha
    
    pop eax
    
    ret

;;************************************************************************************
    
fim:

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0

;;************************************************************************************

mostrarLogoSistema:
    
    Andromeda.Estelar.criarLogotipo VERDE_ESCURO, BRANCO_ANDROMEDA, \
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]
    
    ret

;;************************************************************************************

;;************************************************************************************
;;
;; Dados do aplicativo
;;
;;************************************************************************************

VERSAO equ "1.6.3"

calc:

.dividirPorZero:  db "Division by zero not allowed!", 0
.primeiroNumero:  db "Enter the first number (0 to exit): ", 0
.segundoNumero:   db "Enter the second number (0 to exit): ", 0
.operacao:        db 10, "Enter the operation code, according to the list below:", 10, 10    
                  db "[0] SUM (+)", 10
                  db "[1] SUB  (-)", 10
                  db "[2] MUL  (*)", 10
                  db "[3] DIV  (/)", 10
                  db "[4] EXIT", 10
                  db 10, "Option: ", 0 
.resultado:       db 10, 10, "The result is = ", 0
.solicitarTecla:  db 10, 10, "Press any key to continue...", 10, 10, 0

.bannerHexagonix: db 10, 10   
                  db "                                     Hexagonix(R) Operating System", 10, 10, 10, 10
                  db "                           Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 10
                  db "                                         All rights reserved.", 0              
.marcaRegistrada: db "tm", 0

.titulo:          db "Hexagonix(R) Operating System Basic Calculator",0
.rodape:          db "[", VERSAO, "] | [F1] Exit",0

primeiroNumero:   dd 0
segundoNumero:    dd 0
resposta:         dd 0

Andromeda.Interface Andromeda.Estelar.Interface 

