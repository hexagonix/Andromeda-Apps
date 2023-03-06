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
;;                    Sistema Operacional Hexagonix® - Hexagonix® Operating System
;;
;;                          Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                        Todos os direitos reservados - All rights reserved.
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
include "macros.s"
include "console.s"

;;************************************************************************************

versaoOOBE = "1.3.0"

OOBE:

.divisoria:

db "****************************************************************************************************", 0

.banner: 

db 10
db "  88                                                                                88", 10
db "  88                                                                                ''", 10
db "  88", 10
db "  88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8", 10
db "  88P'    '88 a8P     88  `P8, ,8P'  ''     `P8 a8'    `P88 a8'     '8a 88P'   `'88 88  `P8, ,8P'", 10
db "  88       88 8PP'''''''    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(", 10
db "  88       88 '8b,   ,aa  ,d8' '8b,  88,    ,88 '8a,   ,d88 '8a,   ,a8' 88       88 88  ,d8' '8b,", 10
db "  88       88  `'Pbbd8'' 8P'     `P8 `'8bbdP'P8  `'PbbdP'P8  `'PbbdP''  88       88 88 8P'     `P8", 10
db "                                                 aa,    ,88", 10
db "                                                  'P8bbdP'", 10, 0

.pag1:

db 10
db "Page 1/6", 10, 10, 0

.pag2:

db 10
db "Page 2/6", 10, 10, 0

.pag3:

db 10
db "Page 3/6", 10, 10, 0

.pag4:

db 10
db "Page 4/6", 10, 10, 0

.pag5:

db 10
db "Page 5/6", 10, 10, 0

.pag6:

db 10
db "Page 6/6", 10, 10, 0

.pagina1:

db "Welcome to Hexagonix Operating System!", 10, 10
db "This must be your first contact with Hexagonix, right?", 10, 10
db "Now let's take a quick tour of Hexagonix, its components and utilities.", 10, 10 ;; '
db "Hexagonix is a system built from scratch, Unix-like and completely developed in x86 Assembly, with", 10
db "a focus on speed and simplicity. The system aims to be easy to use, fully customizable and simple", 10
db "to understand and extend. In addition, it is fully documented and lean, which makes it an excellent", 10
db "choice as a learning tool in operating system development.", 10, 10
db "Furthermore, Hexagonix and all of its components are free and open source software licensed under", 10
db "the BSD-3-Clause License. This allows the code to be reused (with due credit and accompanied by", 10
db "copyright) in other projects, commercial or not, in addition to allowing a wide range of derivative", 10
db "projects. The license also allows the software to be customized and rebuilt. Feel free to build", 10
db "your Hexagonix!", 0

.pagina2:

db "As a Unix-like system, you will find in Hexagonix a number of utilities common to this type of", 10
db "system. Utilities such as sh, ps, top, clear, init, login, cat, cowsay, mount, free and man, among", 10
db "others, are available in a standard system installation. Its usage syntax is based on the syntax of", 10
db "FreeBSD utilities. Whenever you are in doubt about the syntax or function of a utility, feel free", 10
db "to use 'man utility_name' and obtain a manual for using this utility.", 0

.pagina3:

db "In addition to the utilities common to the Unix environment, Hexagonix also comes with a number of", 10
db "unique applications. These applications present a visual environment different from the traditional", 10
db "Unix environment. Here you can find a calculator, a settings application, a virtual piano, graphical", 10
db "shutdown utilities, a powerful text editor and a development environment so you can develop new", 10
db "utilities for the system.", 10, 10
db "This environment is referred to in the Hexagonix documentation as the Hexagonix-Andromeda", 10
db "environment, in case you need this information later or are reading the system documentation.", 0

.pagina4:

db "In addition, Hexagonix comes with a port of the flat assembler (fasm), here called fasm Hexagonix", 10
db "Edition, or simply fasmx. This assembler is the same one used to build all of Hexagonix, and is used", 10
db "by the Hexagonix IDE (Lyoko) to generate the executable images of the utilities written by it. In", 10
db "the root directory of the system, you can find two sample files, gapp.asm and tapp.asm. Feel free to", 10
db "use fasmx to generate your respective binaries, using 'fasmx gapp.asm' or 'fasmx tapp.asm'. fasm is", 10
db "available under a free license and its sources (and adaptations for Hexagonix) can be found in the", 10
db "system repository on GitHub.", 0

.pagina5:

db "Feel free to contact us to learn more about the system. To do so, use the email", 10
db "hexagonixdeev@gmail.com, send a message to @HexagonixOS on Twitter or open an Issue in the Hexagonix", 10
db "repository at https://github.com/hexagonix/hexagonix. Also, if you are an Assembly developer (or", 10
db "want to become one), C (to help develop a libc) or even fluent in another language, you can", 10
db "contribute to Hexagonix! You can also contribute by helping to test the system and report bugs. For", 10
db "all this, use the contact channels already mentioned. It will be a pleasure to have more people on", 10
db "the project!", 0

.pagina6:

db "Tuor is running out :(. When finished, enter an 'ls' in the shell to start exploring the available", 10
db "utilities. Remember: at any time, you can use 'man utility' to learn more about it. Hope you like", 10
db "your experience with the system!", 0

.proximaPagina:

db 10, 10
db "Press any key to go to the next page...", 0

.mensagemFinal:

db 10, 10
db "You will no longer see this message on the next boot.", 10, 10
db "Now let's take you to the login prompt. Press any key to log in.", 10, 10, 0 ;;'

.deletarManual:

db 10, "An error occurred while removing OOBE. Remove it manually. For this, enter 'rm oobe'.", 10, 10, 0

.arquivoOOBE: db "oobe", 0
.root:        db "root", 0
.jack:        db "jack", 0

;;************************************************************************************

inicioAPP:

    salvarConsole

.pagina1:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag1

    restaurarCorConsole

    fputs OOBE.pagina1

    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado


.pagina2:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag2

    restaurarCorConsole

    fputs OOBE.pagina2

    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado

.pagina3:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag3

    restaurarCorConsole

    fputs OOBE.pagina3

    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado

.pagina4:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag4

    restaurarCorConsole

    fputs OOBE.pagina4

    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado

.pagina5:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag5

    restaurarCorConsole

    fputs OOBE.pagina5
    
    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado

.pagina6:

    call exibirBanner

    definirCorConsole AMARELO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.pag6

    restaurarCorConsole

    fputs OOBE.pagina6
    
    fputs OOBE.proximaPagina

    call exibirDivisoria

    hx.syscall aguardarTeclado

;;************************************************************************************

.removerOOBE:

;; Vamos logar automaticamente como root para escluir o oobe. Depois, vamos logar
;; como um usuário normal, "jack".

.root:

    mov eax, 777 ;; Código de um usuário raiz
    
    mov esi, OOBE.root
    
    hx.syscall definirUsuario

    mov esi, OOBE.arquivoOOBE

    hx.syscall deletarArquivo

    jc .erroDeletando

    fputs OOBE.mensagemFinal

    definirCorConsole VERMELHO_TIJOLO, [Lib.Console.corFundo]

    fputs OOBE.divisoria

    restaurarCorConsole

    mov eax, 555 ;; Código de um usuário comum

    mov esi, OOBE.jack
    
    hx.syscall definirUsuario

    hx.syscall aguardarTeclado

    jmp terminar

.erroDeletando:

    definirCorConsole ROXO_ESCURO, [Lib.Console.corFundo]

    fputs OOBE.deletarManual

    fputs OOBE.mensagemFinal

    definirCorConsole VERMELHO_TIJOLO, [Lib.Console.corFundo]

    fputs OOBE.divisoria

    restaurarCorConsole

    hx.syscall aguardarTeclado

;;************************************************************************************

terminar:

    restaurarConsoleLimpar ;; Macro que restaura o comportamento do console e limpa o terminal

    hx.syscall encerrarProcesso

;;************************************************************************************

exibirBanner:

    hx.syscall limparTela

    definirCorConsole VERMELHO_TIJOLO, [Lib.Console.corFundo]

    fputs OOBE.divisoria

    definirCorConsole VERDE_ANDROMEDA, [Lib.Console.corFundo]

    fputs OOBE.banner 

    definirCorConsole VERMELHO_TIJOLO, [Lib.Console.corFundo]

    fputs OOBE.divisoria

    restaurarCorConsole

    ret

;;************************************************************************************

exibirDivisoria:

    definirCorConsole VERMELHO_TIJOLO, [Lib.Console.corFundo]

    novaLinha
    novaLinha

    fputs OOBE.divisoria

    restaurarCorConsole

    ret