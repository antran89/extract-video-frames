#!/bin/bash

# dataset parameters
VIDEO_FOLDER=/media/data1/video/ssbd/ssbd_clip_segment/
IMG_FOLDER=/media/data1/video/ssbd/ssbd_clip_segment_frames/

export CUDA_VISIBLE_DEVICES=""
bash runme_extract_video_frame_ssbd.sh $VIDEO_FOLDER $IMG_FOLDER 1 0