cmake_minimum_required(VERSION 2.8)
project(extract_video_frame)

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
message(STATUS "OpenCV found (${OpenCV_CONFIG_PATH})")

add_executable(extract_frames extract_frames.cpp)
target_link_libraries(extract_frames ${OpenCV_LIBS} ${External_LIBS})

add_executable(extract_frames_with_segment extract_frames_with_segment.cpp)
target_link_libraries(extract_frames_with_segment ${OpenCV_LIBS} ${External_LIBS})