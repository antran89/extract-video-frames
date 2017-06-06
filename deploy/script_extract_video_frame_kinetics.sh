#!/bin/bash

# dataset parameters
VIDEO_FOLDER=/media/tranlaman/8TB_DATA/ActivityNet_competition/Kinetics_video/Kinetics_video_val
IMG_FOLDER=/media/tranlaman/8TB_DATA/ActivityNet_competition/Kinetics_frame/img_folder/val

export CUDA_VISIBLE_DEVICES=""
bash runme_extract_video_frame_kinetics.sh $VIDEO_FOLDER $IMG_FOLDER 9 0