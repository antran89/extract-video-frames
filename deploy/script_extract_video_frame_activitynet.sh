#!/bin/bash

# dataset parameters
VIDEO_FOLDER=/media/tranlaman/LDC2014E26/ActivityNet/
IMG_FOLDER=/media/tranlaman/data/ActivityNet_competition/ActivityNet_frame/img_folder/

export CUDA_VISIBLE_DEVICES=""
bash runme_extract_video_frame_activitynet.sh $VIDEO_FOLDER $IMG_FOLDER 1 0