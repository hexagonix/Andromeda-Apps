;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2015-2023 Felipe Miguel Nery Lunkes
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

align 32

msgInicio: ;; Contêm todas as mensagens abaixo

.introducao:           db "About the system", 0
.nomeSistema:          db "Operating System name: ", 0        
.versaoSistema:        db "Operating System version: ", 0
.versao:               db " ", 0
.tipoSistema:          db "Operating System type: 32-bit Operating System", 0
.copyrightAndromeda:   db "Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 0
.direitosReservados:   db "All rights reserved.", 0
.separador:            db "++++++++++++++++++++++++++++++++++++++++", 0
.sobrePC:              db "About the device", 0
.processadorPrincipal: db "Installed processor (considering only the main processor):", 0
.numProcessador:       db "1) ", 0
.operacaoProcessador:  db "Processor in 32-bit mode", 0
.memoriaDisponivel:    db "Total installed memory available: ", 0
.kbytes:               db " megabytes.", 0

;;************************************************************************************

msgGeral:

.mensagemResolucao: db "It is recommended to use this application in 1024x768 resolution for better use of the screen.", 0
.msgErro:           db "Error performing the requested operation.", 0
.msgVersao:         db "You are using a version of Hexagonix(R) that does not support this feature.", 0
.ponto:             db ".", 0
.marcaRegistrada:   db "tm", 0

;;************************************************************************************
 
msgInfo:

.introducao:           db "Detailed Information of the Hexagonix(R) Operating System", 0
.nomeSistema:          db "Installed Operating System name: ", 0
.versaoSistema:        db "Operating System version: ", 0
.buildSistema:         db "Operating System build: ", 0
.tipoSistema:          db "Operating System type:", 0
.modeloSistema:        db " 32-bit", 10, 0
.pacoteAtualizacoes:   db "Update package installed: ", 0
.copyrightAndromeda:   db "Copyright (C) 2016-", __stringano, " Felipe Miguel Nery Lunkes", 0
.direitosReservados:   db "All rights reserved.", 0
.introducaoHardware:   db "Hardware information for this device", 0
.processadorPrincipal: db "Installed processor (considering only the main processor):", 0
.numProcessador:       db "1) ", 0
.operacaoProcessador:  db "Processor in 32-bit mode compatible with protected mode", 0
.memoriaDisponivel:    db "Total installed memory available: ", 0
.kbytes:               db " megabytes.", 0
.Hexagon:              db "Version of Hexagon (kernel): ", 0
.ponto:                db ".", 0
.semCPUID:             db "The processor does not support the CPUID instruction and cannot be identified.", 0
.licenciado:           db "Licensed under BSD-3-Clause", 0

;;************************************************************************************

msgConfig:

.introducao:  db "Here you can change some settings of Hexagonix(R)", 0
.introducao2: db "To get started, select any category listed below:", 0
.categoria1:  db "[1] Change the resolution used by the current monitor.", 0
.categoria2:  db "[2] Check disks and storage.", 0
.categoria3:  db "[3] View and test serial ports.", 0
.categoria4:  db "[4] View parallel port and printer.", 0
.categoria5:  db "[5] Change the default system font.", 0

;;************************************************************************************

msgResolucao:

.introducao:        db "Here you can change the resolution of the computer video, among", 0
.introducao2:       db "the available options.", 0             
.inserir:           db "Choose from one of the options below, inserting the number:", 0
.opcao1:            db "[1] Resolution of 800x600 pixels", 0
.opcao2:            db "[2] Resolution of 1024x768 pixels", 0
.modo1:             db "Current resolution: 800x600 pixels", 0
.modo2:             db "Current resolution: 1024x768 pixels", 0
.resolucaoAlterada: db "The resolution has recently changed.", 0
.alterado:          db "The resolution has been changed. If you don't like it, go back to the previous resolution.", 0

;;************************************************************************************
 
msgDiscos:

.introducao:   db "Here you can track information about your computer's storage and disks", 0
.introducao2:  db "available for use.", 0
.discoAtual:   db "Current disk mounted at [/] used by system: ", 0
.rotuloVolume: db "Label of the volume mounted at [/] used by the system: ", 0

;;************************************************************************************

msgFonte:

.introducao:       db "Here you can change the default system display font. Remembering that the source", 0
.introducao2:      db "must be compatible with the Hexagonix(R) Operating System", 0
.solicitarArquivo: db "Please enter the name of the Hexagonix(R) font file ([ENTER] to cancel): ", 0
.sucesso:          db "Successfully changing system default font to: [", 0
.fechamento:       db "]", 0
.introducaoTeste:  db 10, 10, "Font and character layout preview: ", 0
.arquivoAusente:   db "The requested file was not found on disk.", 0
.semArquivo:       db "A filename was not provided. The operation was cancelled.", 0
.ponto:            db ".", 10, 10, 0
.testeFonte: db "Hexagonix(R) Operating System", 10, 10
             db "1234567890-=", 10
             db "!@#$%^&*()_+", 10
             db "QWERTYUIOP{}", 10
             db "qwertyuiop[]", 10
             db 'ASDFGHJKL:"|', 10
             db "asdfghjkl;'\", 10
             db "ZXCVBNM<>?", 10
             db "zxcvbnm,./", 10, 10
             db "Hexagonix(R) Operating System", 10, 10, 0
.falha:      db "The requested file was not found or is not compatible with Hexagonix(R).", 0

;;************************************************************************************
 
nomeSistema: db "Hexagonix(R) Operating System", 0

;;************************************************************************************

msgPortaParalela:

.introducao:       db "Here you can configure and view the parallel port (printer) settings", 0
.introducao2:      db "in use on this computer.", 0
.impressoraPadrao: db "Default printer on this computer: ", 0

;;************************************************************************************
 
msgSerial:

.introducao:         db "Here you can view and perform actions with the serial port.", 0
.introducao2:        db 0
.portaPadrao:        db "Standard serial port for this computer: ", 0
.opcoes:             db "You can request an automatic port test or you can send a message.", 0
.opcoes2:            db "To do so, select [D] for an automatic test and [E] for a manual submission.", 0
.opcoes3:            db "If you do not wish to carry out these operations, simply return to the previous menu.", 0
.mensagemEnviando:   db "Performing data sending test via serial port... ", 0
.enviado:            db " [Sent]", 0
.erroEnvio:          db "Error sending to serial port.", 0
.erroAbertura:       db "Error opening device for writing.", 0
.mensagemAutomatica: db "This is an automated message from the Hexagonix(R) Operating System Control Panel! ", 10, 0
.insiraMensagem:     db "Enter your message to ", 0
.doisPontos:         db ": ", 0
.colcheteEsquerdo:   db "[", 0
.colcheteDireito:    db "]",0

;;************************************************************************************
 
TITULO: 

.inicio:        db "Hexagonix(R) Operating System Settings", 0
.info:          db "About the Hexagonix(R) Operating System and system updates", 0
.configuracoes: db "Hexagonix(R) Operating System Settings", 0
.resolucao:     db "Video resolution settings", 0
.discos:        db "Hexagonix(R) disk and storage information", 0
.fonte:         db "Change the default system display font", 0
.portaParalela: db "Configure parallel ports (printers)", 0
.portaSerial:   db "Serial port settings and diagnostics", 0

;;************************************************************************************

RODAPE: 

.inicio:        db "[Version ", VERSAOCONFIG, "] | [A] About system and updates [B] System settings [C] Exit", 0
.info:          db "[Version ", VERSAOCONFIG, "] | [V] Back [B] System settings [C] Exit", 0
.configuracoes: db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
.resolucao:     db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
.discos:        db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
.fonte:         db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
.portaParalela: db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
.portaSerial:   db "[Version ", VERSAOCONFIG, "] | [V] Back [B] About System and updates [C] Exit", 0
