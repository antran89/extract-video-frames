#!/bin/bash

BUILD_FOLDER=src-build
if [ -d $BUILD_FOLDER ]; then
	rm -r $BUILD_FOLDER
fi
mkdir $BUILD_FOLDER

cd $BUILD_FOLDER
cmake ../src
make all