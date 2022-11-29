echo off
echo ****************************
echo * creating core .pot files *
echo ****************************
echo * 
find ../sdk ../src | grep -F .cpp | grep -v svn-base | grep -v .svn | grep -v .cpp.org | xargs xgettext --keyword=_ -o codeblocks1.pot 2> log.txt
find ../sdk ../src ../include | grep -F .h  | grep -v svn-base | grep -v .svn | grep -v .h.org | grep -v html | xargs xgettext --keyword=_ -o codeblocks2.pot 2>> log.txt
find ../scripts | grep -F .script | grep -v svn-base | grep -v .svn | xargs xgettext --keyword=_ -o codeblocks3.pot 2>> log.txt
find ../plugins/scriptedwizard/resources | grep -F .script | grep -v svn-base | grep -v .svn | xargs xgettext --keyword=_ -o codeblocks4.pot 2>> log.txt
find codeblocks1.pot > files.txt
find codeblocks2.pot >> files.txt
find codeblocks3.pot >> files.txt
find codeblocks4.pot >> files.txt

find ../plugins | grep -v contrib | grep -F .cpp | grep -v .svn | grep -v svn-base | grep -v .patch | xargs xgettext --keyword=_ -o coreplugins1.pot 2>> log.txt
find ../plugins | grep -v contrib | grep -F .h   | grep -v .svn | grep -v svn-base | grep -v html   | xargs xgettext --keyword=_ -o coreplugins2.pot 2>> log.txt
find coreplugins1.pot >> files.txt
find coreplugins2.pot >> files.txt

echo *
echo *******************************
echo * creating contrib .pot files *
echo *******************************
echo *

find ../plugins/contrib	| grep -F .cpp | grep -v .svn | grep -v svn-base > file_c.txt
find ../plugins/contrib | grep -F .h   | grep -v .svn | grep -v svn-base | grep -v html | grep -v .gch >> file_c.txt
xgettext -f file_c.txt --keyword=_ -o  contribplugins.pot 2>> log.txt
find contribplugins.pot >> files.txt

echo *
echo ***************************************
echo * creating .cpp files from .xrc files *
echo ***************************************
echo *
find ../src/resources | grep -F .xrc | grep -v .svn | grep -v svn-base | xargs wxrc -g -o src_xrc.cpp 2>> log.txt
find ../sdk/resources | grep -F .xrc | grep -v .svn | grep -v svn-base | xargs wxrc -g -o sdk_xrc.cpp 2>> log.txt
find ../plugins | grep -F .xrc | grep -v .svn | grep -v svn-base | xargs wxrc -g -o plugins_xrc2.cpp 2>> log.txt
REM Why next lines? modifications in recent wxrc? string modif? Only one line (1515) in compiler_options.xrc has a problem, though the same syntax in a previous line (1151) is OK!
sed -i 's/\"Compiling <file>...\"/\\\"Compiling <file>...\\\"/g' plugins_xrc2.cpp
REM Eliminate a truncated string containing only "At ".
sed -i 's/\"else\"/\\\"else\\\"/g' plugins_xrc2.cpp
REM In .xrc files, there is no direct way to indicate that a string is translatable or not. So those following grep - v try to eliminate some lines.
grep -v msp430x plugins_xrc2.cpp | grep -v dragon_ | grep -v msp430x | grep -v cc430x | grep -v jtag1 | grep -v jtag2 | grep -v jtagm | grep -v atxmega | grep -v atmega | grep -v attiny | grep -v at86 | grep -v at90 | grep -v AT90 | grep -v TC1 > plugins_xrc.cpp

del plugins_xrc2.cpp

echo *
echo *************************************************
echo * creating .pot files from those local new .cpp *
echo *************************************************
echo *
find . | grep -F .cpp | xargs xgettext --keyword=_ -o xrc.pot 2>> log.txt
sed "s/\$\$*/\$/g" xrc.pot > xrc.pox
sed 's/\\\\\\\\/\\\\/g' xrc.pox > xrc.pot
find xrc.pot >> files.txt

REM Extracting strings from files as .xml, .xrc need more work because there is nothing to specify than a string is translatable or not.
REM May also need additionnal filters if the searched string is on several lines.

echo *
echo *************************************************
echo * extracting strings from .xml compilers files  *
echo *************************************************
echo *
find ../plugins/compilergcc/resources/compilers | grep -F .xml | xargs grep -F "CodeBlocks_compiler name" > src_xml.cpp 2>> log.txt
find ../plugins/compilergcc/resources/compilers | grep -F .xml | xargs grep -F "Option name"   >>  src_xml.cpp 2>> log.txt
find ../plugins/compilergcc/resources/compilers | grep -F .xml | xargs grep -F "Category name" >>  src_xml.cpp 2>> log.txt
find ../plugins/compilergcc/resources/compilers | grep -F .xml | xargs grep -F "checkMessage"  >>  src_xml.cpp 2>> log.txt
REM In .xml files, there is no way to indicate that a string is translatable or not. So those following grep - v try to eliminate some lines.
grep -v mabi src_xml.cpp | grep -v mno | grep -v apcs | grep -v mtpcs | grep -v mshed | grep -v msoft | grep -v mhard | grep -v mfpe | grep -v msched | grep -v mlong | grep -v mpic | grep -v mcirrus | grep -v mcalle | grep -v mpoke | grep -v mwords | grep -v "MSP430 1" | grep -v "MSP430 2" | grep -v "MSP430 3" | grep -v "MSP430 4" | grep -v "MSP430 5" | grep -v "MSP430 6" | grep -v "MSP430 E" | grep -v "MSP430 W" | grep -v "MSP430 MS" | grep -v "MSP430 G4" | grep -v "CC430 5" | grep -v "CC430 6" | grep -v ATmega | grep -v Atmega | grep -v atmega | grep -v ATXmega | grep -v AT90 | grep -v AT43 | grep -v AT86 | grep -v AT76 | grep -v ATA | grep -v ata | grep -v ATtiny | grep -v Attiny | grep -v attiny | grep -v mcpu | grep -v TC1 > src_xml2.cpp
xgettext -a -o xml.pox src_xml2.cpp
sed "s/&quot;/\\\\""/g" xml.pox > xml1.pot
find xml1.pot >> files.txt

echo *
echo *************************************************"
echo * extracting strings from manifest*.xml files   *"
echo *************************************************"
echo *

REM On Windows, the find option -name manifest*.xml is not (still) accepted (msys2 version), so the output is filtered with 2 -F options.

find ../plugins | grep -F manifest | grep -F .xml | grep -v svn-base | grep -v .svn | xargs grep -F "title"  >>  src_xml_title.cpp 2>> log.txt
xgettext -a -s -o xml2_a.pot src_xml_title.cpp
find xml2_a.pot >> files.txt
REM The find for "title" does not work correctly for "description" if the string expands on several lines ! Only the first line is kept => the extracted text is truncated.
REM With the following version, the string begin with "description" line and ends on "author" line => this implies than the order of the fields are the same in all manifests.
REM More, if in manifest*.xml, in the extracted string, there is a CR/LF, it should be kept in the original string, because even if poedit "complains" the translation takes it into account.
REM Nevertheless, it seems that the CR is eliminated (may be by recent sed versions). No problem with description field but thanksTo, though extracted, are not translated (missing \r !)
find ../plugins | grep -F manifest | grep -F .xml | grep -v svn-base | grep -v .svn | xargs sed -n -e "/description/,/>/p" | sed '/author/d' | sed ":a;N;$!ba;s/\n/\\\n/g" | sed 's/""//g' | sed "s/&quot;/\\\\""/g" | sed "s/&amp;/\&/g" > src_xml_desc.cpp     2>> log.txt
xgettext -a -s -o xml2_b.pot src_xml_desc.cpp
find xml2_b.pot >> files.txt

REM for keyword thanksTo
find ../plugins | grep -F manifest | grep -F .xml | grep -v svn-base | grep -v .svn | xargs sed -n -e "/thanksTo/,/>/p" | sed '/license/d'   | sed ":a;N;$!ba;s/\n/\\\n/g" | sed 's/""//g' | sed "s/&quot;/\\\\""/g" | sed "s/&amp;/\&/g" >  src_xml_thanks.cpp  2>> log.txt
xgettext -a -s -o xml2_c.pot src_xml_thanks.cpp
find xml2_c.pot >> files.txt

REM for keyword author : need to modify manifest.xml in wxSmithAUI because author contains characters with accents.
REM Add the = sign to avoid authorEmail and/or authorWeb lines which does not need to be translated
find ../plugins | grep -F manifest | grep -F .xml | grep -v svn-base | grep -v .svn | xargs sed -n -e "/author=/,/>/p" | sed '/authorEmail/d' | sed ":a;N;$!ba;s/\n/\\\n/g" | sed 's/""//g' | sed "s/&quot;/\\\\""/g" | sed "s/&amp;/\&/g" >  src_xml_author.cpp 2>> log.txt
xgettext -a -s -o xml2_d.pot src_xml_author.cpp
find xml2_d.pot >> files.txt

REM for keyword license (single line); include the = sign to be sure that lines containing the word license in a sentence are not kept.
find ../plugins | grep -F manifest | grep -F .xml | grep -v svn-base | grep -v .svn | xargs grep -F "license="  >>  src_xml_lic.cpp 2>> log.txt
xgettext -a -s -o xml2_e.pot src_xml_lic.cpp
find xml2_e.pot >> files.txt

echo *
echo **********************************
echo * Merging and sorting .pot files *
echo **********************************
echo *
msgcat -s -f files.txt -o All_codeblocks.pox 2>> log.txt
rm -f *.pot *.cpp files.txt file_c.txt
sed "s/#, c-format//g" All_codeblocks.pox > All_codeblocks.pot

rm -f *.pox

echo *
echo ***************
echo * The END !!! *
echo ***************
echo on