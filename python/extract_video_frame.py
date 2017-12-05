#!/usr/bin/env python

"""
The tool to extract flows and images from videos in a video dataset using dense
flow tools. It works for UCF101, HMDB51, Kinetics datasets.
"""

import os
import glob
import numpy as np
import argparse
import sys

def parse_args():
    """Parse input arguments."""
    parser = argparse.ArgumentParser(description='Extract images and flows from videos.')
    parser.add_argument('--dataset_folder', dest='dataset_folder', help='video dataset folder.', required=True,
                        type=str)
    parser.add_argument('--img_folder', dest='img_folder', help='the folder to resulting images.', required=True,
                        type=str)
    parser.add_argument('--new_height', dest='new_height', help='new height to resize the image', default=0,
                        type=int)
    parser.add_argument('--new_width', dest='new_width', help='new width to resize the image', default=0,
                        type=int)
    parser.add_argument('--step', dest='step', help='step to extract images and flows', default=1, type=int)
    parser.add_argument('--start_index', dest='start_index', help='start index class to extract flows for that class', default=0,
                        type=int)
    parser.add_argument('--end_index', dest='end_index', help='end index class to extract flows for that class', default=101,
                        type=int)
    parser.add_argument('--video_format', dest='video_format', help='video format', default='avi', type=str)
    parser.add_argument('--image_prefix', dest='image_prefix', help='image prefix', default='im_', type=str)
    parser.add_argument('--img_extension', dest='img_extension', help='image extension', default='jpg', type=str)
    
    args = parser.parse_args()

    return args

def main():
    args = parse_args()
    dataset_folder = args.dataset_folder
    img_folder = args.img_folder
    new_height = args.new_height
    new_width = args.new_width
    step = args.step
    start_index = args.start_index
    end_index = args.end_index
    video_format = args.video_format
    image_prefix = args.image_prefix
    img_extension = args.img_extension
    
    if not os.path.isdir(dataset_folder):
        print('Video dataset folder is not a folder. Quitting...\n')
        sys.exit(1)
    if not os.path.isdir(img_folder):
        os.makedirs(img_folder)
    
    actions = os.listdir(dataset_folder)
    actions.sort()
    
    for ind in xrange(start_index, end_index):
        action = actions[ind]
        if not os.path.isdir(os.path.join(dataset_folder, action)):
            continue
        if not os.path.isdir(os.path.join(img_folder, action)):
            os.mkdir(os.path.join(img_folder, action))
        
        videos = glob.glob(os.path.join(dataset_folder, action, '*.%s' % video_format))
        videos.sort()
        
        for vid in videos:
            file_name = os.path.basename(vid)
            file_basename = os.path.splitext(file_name)[0]
            
            img_vid_folder = os.path.join(img_folder, action, file_basename)
            if not os.path.isdir(img_vid_folder):
                os.mkdir(img_vid_folder)
            else:
                continue
            
            print('Extracting frames of video %s' % vid)
            img_file = os.path.join(img_vid_folder, image_prefix)
            cmd = '../src-build/extract_frames -f=\"%s\" -i=\"%s\" -h=%d -w=%d -s=%d -e=%s' \
            % (vid, img_file, new_height, new_width, step, img_extension)
            
            os.system(cmd)
            
if __name__ == '__main__':
    main()