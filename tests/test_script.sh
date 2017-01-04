#!/bin/bash

IMG_FOLDER='img_folder'
if [ ! -d $IMG_FOLDER ]; then
	mkdir $IMG_FOLDER
fi
IMG_FOLDER2='img_folder2'
if [ ! -d $IMG_FOLDER2 ]; then
	mkdir $IMG_FOLDER2
fi

../src-build/extract_frames_with_segment -f=v_ApplyEyeMakeup_g14_c04.avi -i=$IMG_FOLDER2/im -s=1 -ss=1 -es=3 -h=128 -w=171
../src-build/extract_frames -f=Megamind_bugy.avi -i=$IMG_FOLDER/im -s=2 -h=128 -w=171
