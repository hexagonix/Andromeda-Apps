;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
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
;; Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.

use32

Log.Config:

.logInicio:                  db "[Config]: Iniciando o Configuracoes do Hexagonix(R)...", 0
.logInicioResolucaoCores:    db "[Config]: Obtendo a resolucao atual inicial do video...", 0
.logVersaoDistro:            db "[Config]: Obtendo versao do sistema...", 0 
.logErroVersaoDistro:        db "[Config]: Impossivel obter informacoes de versao junto ao arquivo de dados.", 0 
.logDiscos:                  db "[Config]: Requisitando dados de volumes junto ao Hexagon(R)...", 0
.logPedirArquivoFonte:       db "[Config]: Solicitando do usuario um nome de arquivo que contenha uma fonte compativel...", 0
.logFontes:                  db "[Config]: Configurando e solicitando troca de fonte de exibicao...", 0
.logSucessoFonte:            db "[Config]: Sucesso ao alterar a fonte de exibicao junto ao servidor grafico.", 0
.logFalhaFonte:              db "[Config]: Uma falha ocorreu ao trocar a fonte. Verifique se o arquivo existe e se e compativel.", 0
.logParalela:                db "[Config]: Obtendo identificacao e status das portas parelelas...", 0
.logResolucao:               db "[Config]: Obtendo resolucao atual de exibicao junto ao Hexagon(R)...", 0
.logTrocarResolucao800x600:  db "[Config]: Iniciando troca para resolucao de 800x600 pixels. Baixa resolucao.", 0
.logTrocarResolucao1024x768: db "[Config]: Iniciando troca para resolucao de 1024x768 pixels.", 0
.logSerial:                  db "[Config]: Obtendo identificacao e status das portas seriais...", 0
.logSerialAutomatico:        db "[Config]: O Configuracoes do Hexagonix(R) ira enviar um teste automatico via porta serial agora.", 0
.logSerialManual:            db "[Config]: O Configuracoes do Hexagonix(R) ira enviar um teste com entrada manual do usuario.", 0
.logFalha:                   db "[Config]: Falha na operacao anterior.", 0
.logSucesso:                 db "[Config]: Sucesso na operacao anterior.", 0
.logFalhaArquivos:           db "[Config]: Falha ao encontrar o arquivo solicitado.", 0
.logFinalizando:             db "[Config]: Finalizando o Configuracoes do Hexagonix(R)...", 0
.logFonteAusente:            db "[Config]: O arquivo de fonte nao foi encontrado no disco.", 0
