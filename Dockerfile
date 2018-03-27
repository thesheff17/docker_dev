FROM ubuntu:16.04

# MAINTAINER Dan Sheffner
# This is a random dev docker container maintained by a crazy person.
# Use it if you want.  Don't complain about it if you have issues
# or it groes to be to big of an image. This is a development container.  Its going to be big
# make pull requests if you want changes
# time docker build . -t thesheff17/docker_dev:`date +"%m%d%Y"`

# 1 package per line/alphabetical order
RUN \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
    apache2 \
    apt-utils \
    build-essential \
    curl \
    git-core \
    golang \
    inetutils-ping \
    lib32ncurses5 \
    lib32ncurses5 \
    lib32stdc++6 && \
    lib32stdc++6 \
    lib32z1 \
    lib32z1 \
    libapache2-mod-wsgi \
    libjpeg-dev \
    libmemcached-dev \
    libmysqlclient-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    lsb-release \
    mysql-client \
    net-tools \
    openjdk-8-jdk \
    openssl \
    python \
    python-dev \
    python-pip \
    screen \
    tmux \
    unzip \
    vim \
    wget && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Android install
ENV ANDROID_STUDIO /opt/android-studio

# https://developer.android.com/studio/archive.html go here and fill out this info
ENV ANDROID_STUDIO_VERSION 3.2.0.7

# below will get it from the web.  Recommended for remote jenkins builds.  Not recommended for local testing
ENV ANDROID_STUDIO_URL https://dl.google.com/dl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-ide-173.4670218-linux.zip
ADD $ANDROID_STUDIO_URL /tmp/tmp.zip

RUN unzip /tmp/tmp.zip -d /opt && rm /tmp/tmp.zip

ENV USER ubuntu
ENV UID 1000

RUN useradd -m -u $UID $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# chmod -R a+w /opt/android-studio
#USER $USER

# node/ionic
# Install node as a javascript runtime for asset compilation. Blatantly
# ripped off from the official Node Docker image's Dockerfile.
# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.3
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash \
   && . $NVM_DIR/nvm.sh \
   && nvm install $NODE_VERSION \
   && nvm alias default $NODE_VERSION \
   && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

# install ionic
RUN npm install -g ionic
RUN ionic -v

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/
COPY ./versions.sh /root/bin/

WORKDIR /root/
CMD ["/bin/bash"]
