#!/bin/bash  

echo "┌───────────────────────────────────────┐"
echo "│ Converting oled-icons from SVG to XBM │"
echo "└───────────────────────────────────────┘"
echo -n " * Creating xbm directory ...         "
mkdir -p xbm
echo "ok"

echo -n " * Changing directory to svg ...      "
cd svg
echo "ok"

echo -n " * Converting to xbm ...              "
mogrify -path ../xbm -format xbm  *.svg 
echo "ok"