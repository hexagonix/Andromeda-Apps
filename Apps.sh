#!/bin/bash
# Esse script deve ficar na raiz do projeto
#
#;;************************************************************************************
#;;
#;;    
#;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
#;; ││ ││
#;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
#;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
#;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
#;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
#;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
#;;              └──┘          
#;;                                                Versão 1.1
#;;
#;;************************************************************************************
#;;
#;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
#;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
#;; utilizar qualquer trecho deste arquivo.
#;;
#;; BSD 3-Clause License
#;;
#;; Copyright (c) 2015-2022, Felipe Miguel Nery Lunkes
#;; All rights reserved.
#;; 
#;; Redistribution and use in source and binary forms, with or without
#;; modification, are permitted provided that the following conditions are met:
#;; 
#;; 1. Redistributions of source code must retain the above copyright notice, this
#;;    list of conditions and the following disclaimer.
#;;
#;; 2. Redistributions in binary form must reproduce the above copyright notice,
#;;    this list of conditions and the following disclaimer in the documentation
#;;    and/or other materials provided with the distribution.
#;;
#;; 3. Neither the name of the copyright holder nor the names of its
#;;    contributors may be used to endorse or promote products derived from
#;;    this software without specific prior written permission.
#;; 
#;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#;;
#;; $HexagonixOS$

gerarApps()
{

#;;************************************************************************************

echo -e "\e[1;94mBuilding Hexagonix Applications...\e[0m {"
echo

echo "Building Hexagonix Applications... {" >> $LOG
echo >> $LOG

#;;************************************************************************************

cd ASH/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd DOSsh/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Calculadora/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Desligar/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..
 
#;;************************************************************************************

cd Piano/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Lyoko/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Quartzo/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Fonte/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd "Configurações"/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done


cd ..

#;;************************************************************************************

cd Serial/

for i in *.asm
do

	echo -en "Building application \e[1;94m$(basename $i .asm)\e[0m..."
	
	echo Building application $(basename $i .asm)... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../../Andromeda/bin/`basename $i .asm` -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

echo
echo -e "} [\e[32mSuccessfully built Hexagonix-Andromeda applications\e[0m]."

echo

}

desmontar()
{

cd ..

cd ..

umount Sistema || exit

# Desmontar tudo!

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

gerarApps
