#! /bin/bash

ffmpeg -re -i bbb_sunflower_1080p_60fps_normal.mp4 -vcodec copy -loop -1 -c:a aac -b:a 160k -ar 44100 -strict -2 -f flv rtmp://127.0.0.1:1935/live/bbb

# -re - Read input consume stream on media's native bitrate (and not as fast as possible)
# -i - select physical device to capture from e.g local webcam OR different rtmp OR file 
# -vcodec copy or -c:v copy - Copy the video format verbatim, that is, video codec to output
# -c:a aac - encode the audio n AAC codec
# -loop -1 - keep looping indefinitely
# -ar 44100 - Set the audio sample rate to 44100 Hz
# -f flv - specify format to output, that FFmpeg will stream
# rtmp://127.0.0.1:1935/live/bbb - Set your RTMP live program