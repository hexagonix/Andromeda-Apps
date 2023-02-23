#!/bin/bash
# Esse script deve ficar na raiz do projeto
#
#************************************************************************************
#
#                             ┌┐ ┌┐
#                             ││ ││
#                             │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐
#                             │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘
#                             ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
#                             └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
#                                          ┌─┘│                 
#                                          └──┘          
#
#            Sistema Operacional Hexagonix® - Hexagonix® Operating System            
#
#                  Copyright © 2015-2023 Felipe Miguel Nery Lunkes
#                Todos os direitos reservados - All rights reserved.
#
#************************************************************************************
#
# Português:
# 
# O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
# a licença que governa este arquivo e verifique a licença de cada repositório para
# obter mais informações sobre seus direitos e obrigações ao utilizar e reutilizar
# o código deste ou de outros arquivos.
#
# English:
#
# Hexagonix and its components are licensed under a BSD-3-Clause license. Read below
# the license that governs this file and check each repository's license for
# obtain more information about your rights and obligations when using and reusing
# the code of this or other files.
#
#************************************************************************************
#
# BSD 3-Clause License
#
# Copyright (c) 2015-2023, Felipe Miguel Nery Lunkes
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# $HexagonixOS$

gerarBaseGrafica(){

echo
echo -e "\e[1;94mBuilding Hexagonix® graphical applications...\e[0m {"
echo

echo "Building Hexagonix® graphical applications... {" >> $LOG
echo >> $LOG
    
# Vamos agora automatizar a construção dos aplicativos

for i in */
do

    cd $i

    for h in *.asm
    do

    echo -en "Building Hexagonix® graphical application \e[1;94m$(basename $h .asm)\e[0m..."
    
    echo Building Hexagonix® Unix Utility $(basename $h .asm)... >> $LOG
    
    echo >> $LOG
    
    fasm $h ../../../Andromeda/bin/`basename $h .asm` -d $BANDEIRAS >> $LOG || desmontar
    
    echo -e " [\e[32mOk\e[0m]"
    
    echo >> $LOG

    done

cd ..

done

echo
echo -e "} [\e[32mHexagonix applications built successfully\e[0m]."
echo


}

hexagonix()
{

export DESTINO="../../Hexagonix"
#export BANDEIRAS="UNIX=SIM -d TIPOLOGIN=UNIX -d VERBOSE=SIM"

gerarBaseGrafica

}

desmontar()
{

cd ..

cd ..

umount Sistema || exit

# Desmontar tudo"

umount -a

echo "An error occurred while building some system component."
echo
echo "Check the status of the components and use the above error outputs to verify the problem."
echo
echo "View the log file 'log.log', for more information about the error(s)."
echo

exit    
    
}

export LOG="/dev/null"
export DESTINO="../../Andromeda"

case $1 in

hexagonix) hexagonix; exit;;
*) gerarBaseGrafica; exit;;

esac 
