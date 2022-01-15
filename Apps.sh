#!/bin/sh
#
# Este arquivo deve estar em Apps/Andromeda para ser executado. Nese diretório deve
# ser clonado o repositório Andromeda-Apps
#
#;;************************************************************************************
#;;
#;;    
#;;        %#@@%&@@%&@@%@             Sistema Operacional Andromeda®
#;;        #@@@@@@#@#@#@@
#;;        @#@@%    %#@#%
#;;        @#@@@    #@#@@
#;;        #@#@@    !@#@#     Copyright © 2016-2022 Felipe Miguel Nery Lunkes
#;;        @#@%!@&%@&@#@#             Todos os direitos reservados
#;;        !@@%#%&#&@&@%#
#;;        @@#!%&@&@#&*@&
#;;        @#@#%    &%@#@
#;;        @#!@@    !#@#@                    Script versão 0.8
#;;
#;;
#;;************************************************************************************

gerarApps()
{

#;;************************************************************************************

echo "Gerando aplicativos base do Andromeda®... {"
echo

echo "Gerando aplicativos base do Andromeda®... {" >> $LOG
echo >> $LOG

#;;************************************************************************************

cd ASH/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Calculadora/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Desligar/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Fasm/

 cp *.asm ../../../Andromeda

 cd ..
 
#;;************************************************************************************

cd Piano/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Lyoko/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Quartzo/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app  -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Fonte/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd "Configurações"/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done


cd ..

#;;************************************************************************************

cd Serial/

for i in *.asm
do

	echo -n Gerando aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Gerando aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo " [Ok]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

echo
echo "} Aplicativos base gerados com sucesso!"
echo

echo "} Aplicativos base gerados com sucesso!" >> $LOG
echo >> $LOG
echo "----------------------------------------------------------------------" >> $LOG
echo >> $LOG

}

desmontar()
{

cd ..

rm -r *.app

cd ..

umount Sistema || exit

# Desmontar tudo!

umount -a

echo "Um erro ocorreu durante a construção de algum componente do sistema."
echo 
echo "Verifique o status dos componentes e utilize as saídas de erro acima para verificar o problema."
echo 
echo "Visualize o arquivo de log 'log.log', para mais informações sobre o(s) erro(s)."
echo 

exit	
	
}

export LOG="/dev/null"

gerarApps
