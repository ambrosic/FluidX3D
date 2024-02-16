#!/bin/bash
BASEDIR="/mnt/c/Users/harrierpigeon/Documents/GitHub/FluidX3D"
OUTFOLDER="videoOutput"
VIDFOLDER="$BASEDIR/$OUTFOLDER/"
DATADIR="export/"
DIRECTORY="$BASEDIR/$DATADIR"

mkdir -p $BASEDIR/$OUTFOLDER
cd $DIRECTORY 
echo $VIDFOLDER
find . -maxdepth 1 -mindepth 1 -type d -printf '%P\n' | parallel 'echo {1} && cd $DIRECTORY/{1} && ffmpeg -hide_banner -framerate 30 -pattern_type glob -i "*.png" -c:v libx264 -pix_fmt yuv420p $VIDFOLDER/{1}1.mp4'
find . -maxdepth 1 -mindepth 1 -type d | parallel 'echo {1} && cd $DIRECTORY/{1} && ffmpeg -hide_banner -framerate 30 -pattern_type glob -i "*.png" -c:v libx264 -pix_fmt yuv420p $VIDFOLDER/{1}1.mp4'
#echo "$VIDFOLDER"
#find . -maxdepth 1 -mindepth 1 -type d | parallel 'cd $DIRECTORY{1} && mv {1}.mp4 "$VIDFOLDER"'