# Main

* Different Types of Streaming:-
  * RTMP live
  * RTMP VOD
  * HTTP live including 
    * HLS live
    * DASH live
  * HTTP VOD including 
    * HLS VOD
    * DASH VOD
* Each client can only play a certain type of video:-
  * All browsers today that is capable of media source extensions can play MPEG-DASH
    * MP4 is simple because it is a file that can be delivered through HTTP
  * Apple devices like iPhone and iPad can play HLS
  * Old browsers that have the Adobe Flash plugin can play RTMP
* Stream video in multiple formats, including :-
  * Real-Time Messaging Protocol (RTMP)
  * HTTP Live Streaming (HLS)
  * Dynamic Adaptive Streaming over HTTP (DASH)
* You can configure NGINX (eNGINe-X) to stream video using all of the protocols
  * PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
  * zlib – Supports header compression. Required by the NGINX Gzip module.
  * OpenSSL – Supports the HTTPS protocol. Required by the NGINX SSL module and others.

* https://learn.microsoft.com/en-us/azure/media-services/previous/media-services-media-encoder-standard-formats
  * Codecs are the software that implements the compression/decompression algorithms whereas file formats are containers that hold the compressed video.
* https://learn.microsoft.com/en-us/azure/media-services/previous/media-services-dynamic-packaging-overview
  * The following diagram shows the traditional encoding and static packaging workflow.
    ![image](https://user-images.githubusercontent.com/8818025/210056657-1cd5847b-0d72-4765-9a35-2c66515fe801.png)
  * The following diagram shows the `dynamic packaging` workflow
    ![image](https://user-images.githubusercontent.com/8818025/210056697-6539cefc-d8aa-4cfe-a725-b7ca42f10d04.png)
  * https://learn.microsoft.com/en-us/azure/media-services/previous/media-services-deliver-streaming-content
    * Dynamic:- Gives links to HLS, MPEG-DASH and SS and HTML player will automatically select the segement which will be stripped from the MP4 [on the fly](https://www.nginx-cn.net/blog/streaming-hls-dash-nginx/#Agenda)
    * Progressive :- Gives links to all multi-bitrate MP4 and HTML video element will download single file progressively


## Adaptive bitrate streaming

* It is a technique used in streaming multimedia over computer networks. 
* While in the past most video or audio streaming technologies utilized streaming protocols such as RTP with RTSP.
* Today's adaptive streaming technologies are almost exclusively based on HTTP and designed to work efficiently over large distributed HTTP networks such as the Internet. 
* It works
  * by detecting a user's bandwidth and CPU capacity in real time, adjusting the quality of the media stream accordingly.
  * It requires the use of an encoder which encodes a single source media (video or audio) at multiple bit rates. 
  * The player client switches between streaming the different encodings depending on available resources.
  *  "The result: very little buffering, fast start time and a good experience for both high-end and low-end connections

* Implementations
  1. Dynamic Adaptive Streaming over HTTP (DASH)
    * MPEG-4 AVC OR Advanced Video Coding (AVC) OR  H.264 OR MPEG-4 Part 10, is a video compression standard based on block-oriented, motion-compensated coding
  2. Apple HTTP Live Streaming (HLS)
  3. Adobe HTTP Dynamic Streaming (HDS)
  4. Microsoft Smooth Streaming (MSS)
  5. Common Media Application Format (CMAF)
  6. QuavStreams Adaptive Streaming over HTTP
  7. Uplynk
  8. Moving Picture Experts Group - Dynamic Adaptive Streaming over HTTP (MPEG-DASH)


### Step1: Build RTMP Server

* Build Image and Run Container:-
  ```sh
  docker build  --build-arg UID=`id -u` -t nginx-rtmp-stretch-img -f Dockerfile .
  docker run -p 3000:3000 -p 8085:80 -p 8086:1935 --rm -it nginx-rtmp-stretch-img:latest /bin/bash
  ```

### Step2: Start RTMP Server

* Build and Start the container:- 
  ```sh
  sudo /usr/local/nginx/sbin/nginx -t
  sudo /usr/local/nginx/sbin/nginx
  ```
### Step3: Sending Video to  RTMP Server
* There are following options to Streaming Video to RTMP Server `rtmp://localhost:8086/live/bbb` :-
  * ffmpeg
    * Using file e.g bbb.mp4
      ```sh
      ./stream.sh
      ```
    * Using Hardware e.g WebCam
    * Using another stream
  * OBS
      * Using Hardware e.g WebCam
        * TODO:
* The following streams will be eventually available:-
  * RTMP – rtmp://localhost:8086/live/bbb
  * HLS – http://localhost:8085/hls/bbb/index.m3u8
  * DASH – http://localhost:8085/dash/bbb/index.mpd
* Additional info:-
<details>
```sh
root@b91e571417bb:/# tree /tmp
/tmp
|-- dash
|   |-- bbb-536490.m4a
|   |-- bbb-536490.m4v
|   |-- bbb-553156.m4a
|   |-- bbb-553156.m4v
|   |-- bbb-566172.m4a
|   |-- bbb-566172.m4v
|   |-- bbb-582323.m4a
|   |-- bbb-582323.m4v
|   |-- bbb-593363.m4a
|   |-- bbb-593363.m4v
|   |-- bbb-611490.m4a
|   |-- bbb-611490.m4v
|   |-- bbb-627056.m4a
|   |-- bbb-627056.m4v
|   |-- bbb-init.m4a
|   |-- bbb-init.m4v
|   |-- bbb-raw.m4a
|   |-- bbb-raw.m4v
|   `-- bbb.mpd
`-- hls
    |-- bbb-33.ts
    |-- bbb-34.ts
    |-- bbb-35.ts
    |-- bbb-36.ts
    |-- bbb-37.ts
    |-- bbb-38.ts
    `-- bbb.m3u8

2 directories, 26 files
```
```xml
<?xml version="1.0"?>
<MPD
    type="dynamic"
    xmlns="urn:mpeg:dash:schema:mpd:2011"
    availabilityStartTime="2022-12-28T10:42:58Z"
    publishTime="2022-12-28T10:55:26Z"
    minimumUpdatePeriod="PT5S"
    minBufferTime="PT5S"
    timeShiftBufferDepth="PT21S"
    profiles="urn:hbbtv:dash:profile:isoff-live:2012,urn:mpeg:dash:profile:isoff-live:2011"
    xmlns:xsi="http://www.w3.org/2011/XMLSchema-instance"
    xsi:schemaLocation="urn:mpeg:DASH:schema:MPD:2011 DASH-MPD.xsd">
  <Period start="PT0S" id="dash">
    <AdaptationSet
        id="1"
        segmentAlignment="true"
        maxWidth="1280"
        maxHeight="720"
        maxFrameRate="30">
      <Representation
          id="stream_H264"
          mimeType="video/mp4"
          codecs="avc1.64001f"
          width="1280"
          height="720"
          frameRate="30"
          startWithSAP="1"
          bandwidth="2500000">
        <SegmentTemplate
            timescale="1000"
            media="$Time$.m4v"
            initialization="init.m4v">
          <SegmentTimeline>
             <S t="713966" d="8333"/>
             <S t="722299" d="8333"/>
             <S t="730632" d="8334"/>
             <S t="738966" d="8333"/>
             <S t="747299" d="8333"/>
             <S t="755632" d="8334"/>
          </SegmentTimeline>
        </SegmentTemplate>
      </Representation>
    </AdaptationSet>
    <AdaptationSet
        id="2"
        segmentAlignment="true">
      <AudioChannelConfiguration
          schemeIdUri="urn:mpeg:dash:23003:3:audio_channel_configuration:2011"
          value="1"/>
      <Representation
          id="stream_AAC"
          mimeType="audio/mp4"
          codecs="mp4a.40.2"
          audioSamplingRate="48000"
          startWithSAP="1"
          bandwidth="160000">
        <SegmentTemplate
            timescale="1000"
            media="$Time$.m4a"
            initialization="init.m4a">
          <SegmentTimeline>
             <S t="713966" d="8333"/>
             <S t="722299" d="8333"/>
             <S t="730632" d="8334"/>
             <S t="738966" d="8333"/>
             <S t="747299" d="8333"/>
             <S t="755632" d="8334"/>
          </SegmentTimeline>
        </SegmentTemplate>
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>
```
</details>

### Step4a: View RTMP
* It can be tested via `rtmp://localhost:8086/live/bbb` :-
  * VLC

### Step4b: Test HLS

* It can be tested via
  * VLC:- `http://localhost:8085/hls/bbb/index.m3u8`
  * Open Chrome:- [hls.html](./hls.html)
### Step4c: Test DASH
* It can be tested via
  * VLC :- `http://localhost:8085/dash/bbb/index.mpd`
  * Open Chrome:- [dash.html](./dash.html)


## Links

* https://www.nginx.com/blog/video-streaming-for-remote-learning-with-nginx => Tutorial inspired for this repo
  * https://gist.github.com/outcast/13289bd872b06700089d9fe1a94441ce => nginx.conf used in above tutorial
* https://www.nginx-cn.net/blog/streaming-hls-dash-nginx/#Agenda => Very good introduction to all concepts
* https://docs.peer5.com/guides/setting-up-hls-live-streaming-server-using-nginx/
* https://mpolinowski.github.io/docs/DevOps/NGINX/2019-11-07--nginx-rtmp-streaming-container/2019-11-07/ => Good tutorial of HLS
* https://unix.stackexchange.com/questions/628717/why-cant-open-the-stream-with-hls-url => ffplay to stream rtsp
* https://www.digitalocean.com/community/tutorials/how-to-set-up-a-video-streaming-server-using-nginx-rtmp-on-ubuntu-20-04 => Very good introduction of RTMP and then for 
* https://dzone.com/articles/hls-streaming-by-nginx-and-apche-tomcat => RTSP -> RTMP -> HLS
* Working Setups:- 
  * https://github.com/ustoopia/Live-stream-server-portable-Windows-Nginx-RTMP-HLS-Dash => Using Windows with RTMP, DASH and DLS
    * It works as following:-
      ```sh
      git clone --single-branch --branch v2.0 git@github.com:ustoopia/Live-stream-server-portable-Windows-Nginx-RTMP-HLS-Dash.git C:\livestream2
      Change conf/nginx.conf
      Start NGINX.exe
      OBS:- http://localhost:8087/live/stream
      VLC:- http://localhost:8087/live/stream
      ```
  * https://hub.docker.com/r/tiangolo/nginx-rtmp => WorkingLinuxContainer but only RTMP
    ```sh
    docker pull tiangolo/nginx-rtmp
    docker run --rm -p 8088:1935 --name nginx-rtmp tiangolo/nginx-rtmp

    root@ef731ef3526d:/# netstat -anlp
        Active Internet connections (servers and established)
        Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
        tcp        0      0 0.0.0.0:1935            0.0.0.0:*               LISTEN      1/nginx: master pro 
        tcp6       0      0 :::1935                 :::*                    LISTEN      1/nginx: master pro 
    OBS:- http://localhost:8088/live/bbb
    VLC:- http://localhost:8088/live/bbb
    ```
