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
#;;              ┌─┘│          
#;;              └──┘                             Versão 1.0
#;;
#;;
#;;************************************************************************************

gerarApps()
{

#;;************************************************************************************

echo "Construindo aplicativos base do Andromeda®... {"
echo

echo "Construindo aplicativos base do Andromeda®... {" >> $LOG
echo >> $LOG

#;;************************************************************************************

cd ASH/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Calculadora/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Desligar/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
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

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Lyoko/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Quartzo/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app  -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd Fonte/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

cd "Configurações"/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done


cd ..

#;;************************************************************************************

cd Serial/

for i in *.asm
do

	echo -n Construindo aplicativo base do Andromeda® $(basename $i .asm).app...
	
	echo Construindo aplicativo base do Andromeda® $(basename $i .asm).app... >> $LOG
	
	echo >> $LOG
	
	fasm $i ../../`basename $i .asm`.app -d $BANDEIRAS >> $LOG || desmontar
	
	echo -e " [\e[32mOk\e[0m]"
	
	echo >> $LOG
	
done

cd ..

#;;************************************************************************************

echo
echo -e "} [\e[32mAplicativos Andromeda construídos com sucesso\e[0m]."

echo

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
