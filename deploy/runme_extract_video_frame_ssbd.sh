#!/bin/bash

SCRIPT_NAME="$0"
if [[ $# < 4 ]]; then
	echo 'The arguments for the program are not correct!'
	printf 'Usage: %s VIDEO_FOLDER IMG_FOLDER NUM_WORKERS START_CLASS_INDEX [END_CLASS_INDEX]\n' $SCRIPT_NAME
	exit
fi

start=$(date +%s)

# dataset parameters
VIDEO_FOLDER=$1
IMG_FOLDER=$2

# run parameters
NUM_WORKERS=$3
START_CLASS_INDEX=$4
if [[ $# == 5 ]]; then
	END_CLASS_INDEX=$5
else
	END_CLASS_INDEX=3
fi

# parameters of flows, step
STEP=1
NEW_HEIGHT=0
NEW_WIDTH=0

workers_step=$(( (END_CLASS_INDEX - START_CLASS_INDEX)/NUM_WORKERS ))
index=$START_CLASS_INDEX
for i in `seq 1 $NUM_WORKERS`; do
	if [ $i == $NUM_WORKERS ]
		then 
		printf 'executing classes from class index %d to class index %d\n' $index $END_CLASS_INDEX
		python extract_video_frame.py --dataset_folder=$VIDEO_FOLDER --img_folder=$IMG_FOLDER --new_height=$NEW_HEIGHT --new_width=$NEW_WIDTH \
		--step=$STEP --start_index=$index --end_index=$END_CLASS_INDEX --video_format=avi &
		sleep 2s
	else
		printf 'executing classes from class index %d to class index %d\n' $index $((index + workers_step))
		python extract_video_frame.py --dataset_folder=$VIDEO_FOLDER --img_folder=$IMG_FOLDER --new_height=$NEW_HEIGHT --new_width=$NEW_WIDTH \
		--step=$STEP --start_index=$index --end_index=$((index + workers_step)) --video_format=avi &
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