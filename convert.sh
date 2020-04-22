#!/bin/bash  

echo "┌───────────────────────────────────────┐"
echo "│ Converting oled-icons from SVG to C++ │"
echo "└───────────────────────────────────────┘"
echo -n " * Creating src directory ........... "
rm -rf ./src
mkdir -p src
echo "ok"

echo -n " * Changing directory to svg ........ "
cd svg
echo "ok"

echo -n " * Converting to bitmaps ............ "
/usr/local/bin/mogrify -path ../src -format xbm  *.svg
echo "ok"

echo -n " * Changing directory to bitmaps .... "
cd ../src
echo "ok"

echo -n " * Changing file extensions ......... "
for f in *.xbm; do 
    mv -- "$f" "icon_${f%.*}.cpp"
done
echo "ok"


echo -n " * Creating bitmaps.h ............... "
touch ./bitmaps.h
# echo "#include <avr/pgmspace.h>" > ./bitmaps.h
# echo "" >> ./bitmaps.h

for f in *.cpp; do 
    echo "extern const unsigned char ${f%.*} [] ;" >> ./bitmaps.h
    # copying and modifying defines
    word="icon_"
    match="#define "
    sed -ne "s/$match/& $word/ p" $f >> ./bitmaps.h
done
echo "ok"


echo -n " * Patching bitmaps ................. "
for f in *.cpp; do
    # removing unwanted defines: they are already in header file
    sed -i '/#define/d' $f

    # prepending file with #include "bitmaps.h"
    prepend="#include \"bitmaps.h\"\n"
    sed -i "1s;^;$prepend;" $f

    #changing variable declaration
    replace="\nconst unsigned char ${f%.*} []  = {"
    sed -i "2s/.*/$replace/" $f
done
echo "ok"
