#include "opencv2/video/video.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/core/version.hpp"

#include <stdio.h>
#include <iostream>
#include <string>
#include <climits>

using namespace std;
using namespace cv;

/**
 * Program to extract frames from a video.
 * The program can extract frames with different steps and also start
 * second and end second to extract frames.
 */
int main(int argc, char** argv){
    // IO operation
#if CV_MAJOR_VERSION == 2
    const char* keys =
    {
        "{ f | vidFile      | ex2.avi | filename of video }"
        "{ i | imgFile      |<none>| filename of flow image}"
        "{ s | step         | 1  | specify the step for frame sampling}"
        "{ h | new_height       | 0  | new height of images and flows}"
        "{ w | new_width        | 0  | new width of images and flows}"
        "{ ss | start_second      | 0  | start second to extract flows}"
        "{ es | end_second        | -1 | end second to extract flows}"
    };
#elif CV_MAJOR_VERSION == 3
    const char* keys =
    {
        "{ f  vidFile      | ex2.avi | filename of video }"
        "{ i  imgFile      |<none>| filename of flow image}"
        "{ s  step         | 1  | specify the step for frame sampling}"
        "{ h  new_height       | 0  | new height of images and flows}"
        "{ w  new_width        | 0  | new width of images and flows}"
        "{ ss start_second      | 0  | start second to extract flows}"
        "{ es end_second        | -1 | end second to extract flows}"
    };
#endif

    CommandLineParser cmd(argc, argv, keys);
    string vidFile = cmd.get<string>("vidFile");
    string imgFile = cmd.get<string>("imgFile");
    int step = cmd.get<int>("step");
    int new_height = cmd.get<int>("new_height");
    int new_width = cmd.get<int>("new_width");
    float start_second = cmd.get<float>("start_second");
    float end_second = cmd.get<float>("end_second");
    bool has_end_second = end_second >= 0;
    int start_frame, end_frame;

    if (imgFile.empty()) {
        cout << "There is not image file output... " << imgFile << endl;
        return -1;
    }

    VideoCapture capture(vidFile);
    if(!capture.isOpened()) {
        printf("Could not initialize capturing...%s\n", vidFile.c_str());
        return -1;
    }

    float fps = capture.get(CV_CAP_PROP_FPS);
    start_frame = int(start_second * fps);
    if (has_end_second)
        end_frame = int(end_second * fps);
    else end_frame = INT_MAX;

    new_height = (new_height > 0) ? new_height : capture.get(CV_CAP_PROP_FRAME_HEIGHT);
    new_width = (new_width > 0) ? new_width : capture.get(CV_CAP_PROP_FRAME_WIDTH);
    cv::Size new_size(new_width, new_height);

    int frame_index = -1, result_index = 0;
    Mat raw_frame, frame;

    while(true) {
        capture >> raw_frame;
        frame_index++;
        if (raw_frame.empty())
            break;

        if (frame_index >= end_frame)
            break;
        if (frame_index < start_frame)
            continue;

        // resize frame
        resize(raw_frame, frame, new_size);

        char tmp[20];
        sprintf(tmp,"_%04d.jpg",int(++result_index));
        imwrite(imgFile + tmp, frame);

        int step_t = step;
        while (step_t > 1){
            capture >> raw_frame;
            frame_index++;
            step_t--;
        }
    }
    return 0;
}
