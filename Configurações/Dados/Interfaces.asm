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

msgInicio: ;; Contêm todas as mensagens abaixo

.introducao:           db "Sobre o Sistema Operacional", 0
.nomeSistema:          db "Nome do Sistema Operacional: ", 0		
.versaoSistema:        db "Versao do Sistema Operacional: ", 0
.versao:               db " ", 0
.tipoSistema:          db "Tipo de Sistema Operacional: Sistema Operacional de 32 bits", 0
.copyrightAndromeda:   db "Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 0
.direitosReservados:   db "Todos os direitos reservados.", 0
.separador:            db "++++++++++++++++++++++++++++++++++++++++", 0
.sobrePC:              db "Sobre o Computador", 0
.processadorPrincipal: db "Processador instalado (considerando apenas o processador principal):", 0
.numProcessador:       db "1) ", 0
.operacaoProcessador:  db "Processador em modo 32 bits de operacao", 0
.memoriaDisponivel:    db "Memoria total instalada disponivel: ", 0
.kbytes:               db " megabytes.", 0

;;************************************************************************************

msgGeral:

.mensagemResolucao: db "Recomenda-se utilizar este aplicativo em resolucao de 1024x768 para melhor aproveitamento da tela.", 0
.msgErro:           db "Erro ao realizar a operacao solicitada.", 0
.msgVersao:         db "Voce esta utilizando uma versao do Andromeda(R) que nao oferece suporte a este recurso.", 0
.ponto:             db ".", 0
.marcaRegistrada:   db "tm", 0

;;************************************************************************************
 
msgInfo:

.introducao:           db "Informacoes detalhadas do Sistema Operacional Andromeda(R)", 0
.nomeSistema:          db "Nome do Sistema Operacional instalado: ", 0
.versaoSistema:        db "Versao do Sistema Operacional: ", 0
.buildSistema:         db "Build: ", 0
.tipoSistema:          db "Tipo de Sistema Operacional instalado:", 0
.modeloSistema:        db " 32 bits", 10, 0
.pacoteAtualizacoes:   db "Pacote de atualizacao instalado: ", 0
.copyrightAndromeda:   db "Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes", 0
.direitosReservados:   db "Todos os direitos reservados.", 0
.introducaoHardware:   db "Informacoes do Hardware deste computador", 0
.processadorPrincipal: db "Processador instalado (considerando apenas o processador principal):", 0
.numProcessador:       db "1) ", 0
.operacaoProcessador:  db "Processador em modo 32 bits compativel com modo protegido", 0
.memoriaDisponivel:    db "Memoria total instalada disponivel: ", 0
.kbytes:               db " megabytes.", 0
.Hexagon:              db "Versao do Hexagon: ", 0
.ponto:                db ".", 0

;;************************************************************************************

msgConfig:

.introducao:  db "Aqui voce podera alterar algumas configuracoes do Andromeda(R)", 0
.introducao2: db "Para comecar, selecione alguma categoria listada a seguir:", 0
.categoria1:  db "[1] Alterar a resolucao utilizada pelo monitor atual.", 0
.categoria2:  db "[2] Verificar discos e armazenamento.", 0
.categoria3:  db "[3] Visualizar e testar portas seriais.", 0
.categoria4:  db "[4] Visualizar porta paralela e impressora.", 0
.categoria5:  db "[5] Alterar a fonte padrao do sistema.", 0

;;************************************************************************************

msgResolucao:

.introducao:        db "Aqui voce podera alterar a resolucao do video de computador, dentre as", 0
.introducao2:       db "opcoes disponiveis.", 0             
.inserir:           db "Escolha entre uma das opcoes abaixo, inserindo o numero da mesma:", 0
.opcao1:            db "[1] Resolucao de 800x600 pixels", 0
.opcao2:            db "[2] Resolucao de 1024x768 pixels", 0
.modo1:             db "Resolucao atual do seu video: 800x600 pixels", 0
.modo2:             db "Resolucao atual do seu video: 1024x768 pixels", 0
.resolucaoAlterada: db "A resolucao foi alterada recentemente.", 0
.alterado:          db "A resolucao foi alterada. Caso nao tenha lhe agradado, retorne para a resolucao anterior.", 0

;;************************************************************************************
 
msgDiscos:

.introducao:   db "Aqui voce podera acompanhar informacoes acerca do armazenamento de seu computador e discos", 0
.introducao2:  db "presentes para uso.", 0
.discoAtual:   db "Disco atual montado em [/] utilizado pelo sistema: ", 0
.rotuloVolume: db "Rotulo do volume montado em [/] utilizado pelo sistema: ", 0

;;************************************************************************************

msgFonte:

.introducao:       db "Aqui voce podera alterar a fonte padrao de exibicao do sistema. Lembrando que a fonte", 0
.introducao2:      db "devera ser compativel com o Sistema Operacional Andromeda(R)", 0
.solicitarArquivo: db "Por favor, insira o nome do arquivo de fonte Andromeda(R) ([ENTER] para cancelar): ", 0
.sucesso:          db "Sucesso a alterar a fonte padrao do sistema para: [", 0
.fechamento:       db "]", 0
.introducaoTeste:  db 10, 10, "Pre-visualizacao da fonte e disposicao dos caracteres: ", 0
.arquivoAusente:   db "O arquivo solicitado nao foi encontrado no disco.", 0
.semArquivo:       db "Um nome de arquivo nao foi fornecido. A operacao foi cancelada.", 0
.ponto:            db ".", 10, 10, 0
.testeFonte: db "Sistema Operacional Andromeda(R)", 10, 10
             db "1234567890-=", 10
             db "!@#$%^&*()_+", 10
             db "QWERTYUIOP{}", 10
             db "qwertyuiop[]", 10
             db 'ASDFGHJKL:"|', 10
             db "asdfghjkl;'\", 10
             db "ZXCVBNM<>?", 10
             db "zxcvbnm,./", 10, 10
             db "Sistema Operacional Andromeda(R)", 10, 10, 0
.falha:      db "O arquivo solicitado nao foi encontrado ou nao e compativel com o Andromeda(R).", 0

;;************************************************************************************
 
nomeSistema: db "Sistema Operacional Andromeda(R)", 0

;;************************************************************************************

msgPortaParalela:

.introducao:       db "Aqui voce pode configurar e visualizar as configuracoes de porta paralela (impressora)", 0
.introducao2:      db "em uso neste computador.", 0
.impressoraPadrao: db "Impressora padrao neste computador: ", 0

;;************************************************************************************
 
msgSerial:

.introducao:         db "Aqui e possivel visualizar e realizar acoes com a porta serial.", 0
.introducao2:        db 0
.portaPadrao:        db "Porta serial padrao para este computador: ", 0
.opcoes:             db "Voce pode solicitar um teste automatico da porta ou pode enviar uma mensagem.", 0
.opcoes2:            db "Para isso, selecione [D] para um teste automatico e [E] para um envio manual.", 0
.opcoes3:            db "Caso nao deseje realizar essas operacoes, basta retornar ao menu anterior.", 0
.mensagemEnviando:   db "Realizando teste de envio de dados via porta serial... ", 0
.enviado:            db " [Enviado]", 0
.erroEnvio:          db "Erro ao realizar o envio para a porta serial.", 0
.erroAbertura:       db "Erro ao abrir o dispositivo para escrita.", 0
.mensagemAutomatica: db "Esta e uma mensagem automatica enviada pelo Painel de Controle do Sistema Operacional Andromeda(R)! ", 10, 0
.insiraMensagem:     db "Insira sua mensagem para ", 0
.doisPontos:         db ": ", 0
.colcheteEsquerdo:   db "[", 0
.colcheteDireito:    db "]",0

;;************************************************************************************
 
TITULO: 

.inicio:        db "Configuracoes do Sistema Operacional Andromeda(R)", 0
.info:          db "Sobre o Sistema Operacional Andromeda(R) e atualizacoes do sistema", 0
.configuracoes: db "Configuracoes do Sistema Operacional Andromeda(R)", 0
.resolucao:     db "Configuracoes de resolucao de video", 0
.discos:        db "Informacoes de discos e armazenamento do Andromeda(R)", 0
.fonte:         db "Alterar a fonte padrao de exibicao do sistema", 0
.portaParalela: db "Configurar portas paralelas (impressoras)", 0
.portaSerial:   db "Configuracoes e diagnosticos de porta serial", 0

;;************************************************************************************

RODAPE: 

.inicio:        db "[Versao ", VERSAOCONFIG, "] | [A] Sobre o Sistema e Atualizacoes [B] Configuracoes do Sistema [C] Sair ", 0
.info:          db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Configuracoes do Sistema [C] Sair", 0
.configuracoes: db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
.resolucao:     db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
.discos:        db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
.fonte:         db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
.portaParalela: db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
.portaSerial:   db "[Versao ", VERSAOCONFIG, "] | [V] Voltar [B] Sobre o Sistema e Atualizacoes [C] Sair", 0
