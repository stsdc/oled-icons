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
mogrify -path ../src -format xbm  *.svg
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
echo "#include <avr/pgmspace.h>" > ./bitmaps.h
echo "" >> ./bitmaps.h

for f in *.cpp; do 
    echo "extern const unsigned char ${f%.*} [] PROGMEM;" >> ./bitmaps.h
done
echo "ok"


echo -n " * Patching bitmaps ................. "
for f in *.cpp; do
    prepend="#include \"bitmaps.h\"\n\n"
    sed -i "1s;^;$prepend;" $f

    replace="\nconst unsigned char ${f%.*} [] PROGMEM = {"
    sed -i "5s/.*/$replace/" $f
done
echo "ok"
