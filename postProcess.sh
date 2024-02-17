#!/bin/bash
#SBATCH --nodes=1 --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=14G
# don't need GPUs for this lol
##SBATCH --gres=gpu:2
BASEDIR="PLACEHOLDER"
# to execute this script from somewhere else, 
if [[ -z "$SLURMD_NODENAME"]]; then
    BASEDIR="$PWD"
else
    BASEDIR="$HOME/ambrosic/FluidX3D"
fi
# VARIABLES FOR SETUP
# make sure not to have trailing slashes.
# gets current working directory
# BASEDIR="$PWD"
INPUTFOLDER="$BASEDIR/bin/export"
OUTFOLDERNAME="videoOutput"
# everything below here shouldn't need tweaks...
DIVIDER="=========================="
# use date as a identifier so you don't have to rename all your mp4s all the time
date=$(date '+%Y-%m-%d_%H_%M_%S')
echo $date
OUTPUTFOLDER="$BASEDIR/$OUTFOLDERNAME/$date"
mkdir -p "${OUTPUTFOLDER}"
printf "RECURSIVE SUBDIR IN FOLDER: ${INPUTFOLDER} \nWITH OUTPUT TO:             ${OUTPUTFOLDER} \n$DIVIDER\nFolders to target:\n"
cd $INPUTFOLDER
# print folders
find . -maxdepth 1 -mindepth 1 -type d -printf '%P\n'
printf "GENERATING MP4 FILES \n$DIVIDER\n"
for D in $(find . -maxdepth 1 -mindepth 1 -type d -printf '%P\n'); do
    echo "starting {D}" && cd {D} && ffmpeg -hide_banner -loglevel error -framerate 30 -pattern_type glob -i "*.png" -c:v libx264 -pix_fmt yuv420p {D}.mp4 && echo "{D}.mp4 complete"
    echo "moving {D}"
    mv "$INPUTFOLDER/{D}/{D}.mp4" "$OUTPUTFOLDER/{D}.mp4"
    echo "$DIVIDER"
done

# old parallel
# find . -maxdepth 1 -mindepth 1 -type d -printf '%P\n' | parallel 'echo "starting {1}" && cd {1} && ffmpeg -hide_banner -loglevel error -framerate 30 -pattern_type glob -i "*.png" -c:v libx264 -pix_fmt yuv420p {1}.mp4 && echo "{1}.mp4 complete"'
# go back to base CWD
cd $BASEDIR
# make moving happen in its own step
# man am I thankful for stackOverflow
# printf "$DIVIDER\nMOVING MP4 FILES\n"
# eval lets you use environment and piped variables together, which is a necessity for this

# stuff for running in parallel
# find "$INPUTFOLDER/" -maxdepth 1 -mindepth 1 -type d -printf '%P\n' | eval "parallel --jobs 8 'mv $INPUTFOLDER/{}/{}.mp4 $OUTPUTFOLDER/{}.mp4'"
printf "COMPLETE 🤩\n"
#theoretical next step: delete original images