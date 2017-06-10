#!/bin/bash

SCRIPT_NAME="$0"
if [[ $# < 4 ]]; then
	echo 'The arguments for the program are not correct!'
	printf 'Usage: %s VIDEO_FOLDER IMG_FOLDER NUM_WORKERS START_VIDEO_INDEX [END_VIDEO_INDEX]\n' $SCRIPT_NAME
	exit
fi

# dataset parameters
VIDEO_FOLDER=$1
IMG_FOLDER=$2

# run parameters
NUM_WORKERS=$3
START_VIDEO_INDEX=$4
if [[ $# == 5 ]]; then
	END_VIDEO_INDEX=$5
else
	END_VIDEO_INDEX=$(ls -1 $VIDEO_FOLDER/*.mp4 | wc -l)
fi

start=$(date +%s)

# parameters of flows, step
STEP=2
NEW_HEIGHT=128
NEW_WIDTH=171

workers_step=$(( (END_VIDEO_INDEX - START_VIDEO_INDEX)/NUM_WORKERS ))
index=$START_VIDEO_INDEX
for i in `seq 1 $NUM_WORKERS`; do
	if [ $i == $NUM_WORKERS ]
		then 
		printf 'executing from video index %d to video index %d\n' $index $END_VIDEO_INDEX
		python extract_video_frame_activitynet.py --dataset_folder=$VIDEO_FOLDER --img_folder=$IMG_FOLDER --new_height=$NEW_HEIGHT --new_width=$NEW_WIDTH \
		--step=$STEP --start_index=$index --end_index=$END_VIDEO_INDEX --video_format=mp4 &
		sleep 2s
	else
		printf 'executing from video index %d to video index %d\n' $index $((index + workers_step))
		python extract_video_frame_activitynet.py --dataset_folder=$VIDEO_FOLDER --img_folder=$IMG_FOLDER --new_height=$NEW_HEIGHT --new_width=$NEW_WIDTH \
		--step=$STEP --start_index=$index --end_index=$((index + workers_step)) --video_format=mp4 &
		sleep 2s
	fi
	index=$(( index + workers_step ))
done

wait

# measuring time
echo "Done~!"
end=$(date +%s)

let deltatime=end-start
let hours=deltatime/3600
let minutes=(deltatime/60)%60
let seconds=deltatime%60
printf "Time spent: %d:%02d:%02d\n" $hours $minutes $seconds
echo "Experiments finished at $(date)"

exit