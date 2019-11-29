#!/bin/bash  

echo "┌───────────────────────────────────────┐"
echo "│ Converting oled-icons from SVG to XBM │"
echo "└───────────────────────────────────────┘"
echo -n " * Creating xbm directory ...         "
mkdir -p bitmaps
echo "ok"

echo -n " * Changing directory to svg ...      "
cd svg
echo "ok"

echo -n " * Converting to bitmaps ...          "
mogrify -path ../bitmaps -format xbm  *.svg
echo "ok"

echo -n " * Changing directory to bitmaps ...  "
cd ../bitmaps
echo "ok"

echo -n " * Changing file extensions ...       "
for f in *.xbm; do 
    mv -- "$f" "icon_${f%.*}.cpp"
done
echo "ok"
