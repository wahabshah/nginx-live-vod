FROM debian:stretch

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME

 
RUN  sudo apt update                                                                                                                                      && \
     sudo apt install -y build-essential git wget nano tree lsof procps ffmpeg                                                                            && \
     sudo apt install -y libpcre3-dev libssl-dev zlib1g-dev

RUN  wget http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4

ENV NGINX_VERSION=nginx-1.23.2
ENV NGINX_RTMP_MODULE_VERSION=1.2.2
RUN  mkdir -p nginx-build                                                                                                                                 && \ 
     cd nginx-build                                                                                                                                       && \
     wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz                                                                   && \
     tar -zxf ${NGINX_VERSION}.tar.gz                                                                                                                     && \
     wget -O nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
     tar -zxf nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz                                                                                       && \
     cd ${NGINX_VERSION}                                                                                                                                  && \
     ./configure  --with-threads --with-http_ssl_module --add-module=../nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}                                    && \
     make -j`nproc`                                                                                                                                       && \
     sudo make install                                                                                                                                    && \
     mkdir -p /tmp/dash /tmp/hls

RUN sudo apt install -y curl                                          && \
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -   && \
    sudo apt install -y nodejs

COPY package.json /tmp
RUN cd /tmp && npm install
COPY index.js /tmp

COPY nginx.conf /usr/local/nginx/conf/
COPY stream.sh /home/$USERNAME

EXPOSE 80
EXPOSE 1935
EXPOSE 3000
# CMD ["/usr/local/nginx/sbin/nginx", "-g","daemon off;"]