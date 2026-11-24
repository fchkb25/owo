#!/bin/bash
# 用法: ./render.sh box1_classic.scad  -> renders/box1_classic.png
f=$1; n=$(basename $f .scad); cam=${2:-"0,30,0,52,0,30,520"}
xvfb-run -a openscad -o renders/$n.png --imgsize=1800,1200 --camera=$cam \
  --colorscheme=Tomorrow --autocenter --viewall -D 'part="scene"' $f 2>&1 | grep -iE "error|warn"; convert renders/$n.png -trim -bordercolor "#f8f8f8" -border 80 renders/$n.png
