# Copyright (c) Digital Imaging Software Solutions, INC
# Dan Sheffner Dan@Sheffner.org
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, dis-
# tribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the fol-
# lowing conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIL-
# ITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
# SHALL THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# I'm torn between using 16.04 and ubuntu rolling
# some of these packages are old
# I'm going to flip these as needed for building
# FROM ubuntu:16.04
FROM ubuntu:rolling

# MAINTAINER Dan Sheffner
# This is a random dev docker container maintained by a crazy person.
# Use it if you want.  Don't complain about it if you have issues
# or it grows to be to big of an image. This is a development container.  Its going to be big.
# make pull requests if you want changes
# time docker build . -t thesheff17/docker_dev:`date +"%m%d%Y"`

# pulling the image
# time docker pull  thesheff17/docker_dev:latest

# I use a local mirror to test
# RUN echo 'Acquire::http::Proxy "http://192.168.1.10:3142";' > /etc/apt/apt.conf.d/01proxy

# 1 package per line/alphabetical order
RUN \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
    apt-utils \
    apache2 \
    apt-utils \
    build-essential \
    curl \
    git-core \
    golang \
    inetutils-ping \
    lib32ncurses5 \
    lib32ncurses5 \
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
    python3-pip \
    screen \
    software-properties-common \
    tmux \
    unzip \
    wget && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# cleanup proxy
# RUN rm /etc/apt/apt.conf.d/01proxy

# Android install
ENV ANDROID_STUDIO /opt/android-studio

# https://developer.android.com/studio/archive.html go here and fill out this info
ENV ANDROID_STUDIO_VERSION 3.2.0.7

# below will get it from the web.  Recommended for remote jenkins builds.  Not recommended for local testing
ENV ANDROID_STUDIO_URL https://dl.google.com/dl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-ide-173.4670218-linux.zip
ADD $ANDROID_STUDIO_URL /tmp/tmp.zip

# setup for local comment out above
# wget https://dl.google.com/dl/android/studio/ide-zips/3.2.0.7/android-studio-ide-173.4670218-linux.zip
# COPY ./android-studio-ide-173.4670218-linux.zip /tmp/tmp.zip

RUN \
    unzip /tmp/tmp.zip -d /opt && \
    rm /tmp/tmp.zip

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

# pip stuff
# pip upgrades
RUN pip3 install --upgrade pip && pip2 install --upgrade pip

# virtualenv
RUN \
    pip2 install virtualenvwrapper virtualenv && \
    cd /root/ && \
    /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh && \
    mkvirtualenv --python=/usr/bin/python3 venv3 && \
    mkvirtualenv venv2" && \
    echo "source /usr/local/bin/virtualenvwrapper.sh" >> /root/.bashrc

# these files get messed up for some reason venv3
RUN \
    echo "#!/bin/bash" > /root/.virtualenvs/preactivate && \
    echo "# This hook is run before every virtualenv is activated." >> /root/.virtualenvs/preactivate && \
    echo "# argument: environment name " >> /root/.virtualenvs/preactivate && \
    echo "#!/bin/bash" > /root/.virtualenvs/venv3/bin/preactivate && \
    echo "# This hook is run before this virtualenv is activated." >> /root/.virtualenvs/venv3/bin/preactivate

# these files get messed up for some reason venv2
RUN \
    echo "#!/bin/bash" > /root/.virtualenvs/preactivate && \
    echo "# This hook is run before every virtualenv is activated." >> /root/.virtualenvs/preactivate && \
    echo "# argument: environment name " >> /root/.virtualenvs/preactivate && \
    echo "#!/bin/bash" > /root/.virtualenvs/venv2/bin/preactivate && \
    echo "# This hook is run before this virtualenv is activated." >> /root/.virtualenvs/venv2/bin/preactivate

# python3 pip
# this package will not install for some reason
# might need to troubleshoot  unicode-slugify
RUN \
    /bin/bash -c " source /root/.virtualenvs/venv3/bin/activate && \
    pip3 install \
    alembic \
    awscli \
    boto \
    boto3 \
    bpython \
    coverage \
    django \
    django-allauth \
    django-autoslug \
    django-axes \
    django-braces \
    django-compressor \
    django-crispy-forms \
    django-debug-toolbar \
    django-environ \
    django-filter \
    django-floppyforms \
    django-model-utils \
    django-nose \
    django-redis \
    django-sass-processor \
    django-secure \
    django-test-plus \
    django_extensions \
    djangorestframework \
    factory_boy \
    flask \
    flask-bcrypt \
    flask-login \
    flask-migrate \
    flask-script \
    flask-sqlalchemy \
    flask-testing \
    flask-wtf \
    gunicorn \
    ipdb \
    itsdangerous \
    jupyter \
    libsass \
    mako \
    markdown \
    markupsafe \
    pillow \
    psycopg2 \
    py-bcrypt \
    pyflakes \
    pylibmc \
    pymysql \
    python-dateutil \
    pytz \
    redis \
    sphinx \
    sqlalchemy \
    werkzeug \
    whitenoise \
    wtforms"

# python2 pip
RUN \
    /bin/bash -c " source /root/.virtualenvs/venv2/bin/activate && \
    pip install \
    alembic \
    awscli \
    boto \
    boto3 \
    bpython \
    coverage \
    django \
    django-allauth \
    django-autoslug \
    django-axes \
    django-braces \
    django-compressor \
    django-crispy-forms \
    django-debug-toolbar \
    django-environ \
    django-filter \
    django-floppyforms \
    django-model-utils \
    django-nose \
    django-redis \
    django-sass-processor \
    django-secure \
    django-test-plus \
    django_extensions \
    djangorestframework \
    factory_boy \
    flask \
    flask-bcrypt \
    flask-login \
    flask-migrate \
    flask-script \
    flask-sqlalchemy \
    flask-testing \
    flask-wtf \
    gunicorn \
    ipdb \
    itsdangerous \
    jupyter \
    libsass \
    mako \
    markdown \
    markupsafe \
    pillow \
    psycopg2 \
    py-bcrypt \
    pyflakes \
    pylibmc \
    pymysql \
    python-dateutil \
    pytz \
    redis \
    sphinx \
    sqlalchemy \
    unicode-slugify \
    werkzeug \
    whitenoise \
    wtforms"

# vim for root
RUN \
    mkdir -p \
    /root/.vim/autoload \
    /root/.vim/bundle \
    /root/.vim/colors/ \
    /root/.vim/ftplugin/ && \
    cd /root/.vim/bundle/ && \
    curl -LSso /root/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/tpope/vim-sensible.git && \
    git clone https://github.com/ctrlpvim/ctrlp.vim.git && \
    git clone https://github.com/scrooloose/nerdtree && \
    git clone https://github.com/Lokaltog/vim-powerline.git && \
    git clone https://github.com/jistr/vim-nerdtree-tabs.git && \
    git clone https://github.com/python-mode/python-mode.git && \
    git clone https://github.com/fatih/vim-go.git && \
    git clone https://github.com/vim-syntastic/syntastic.git && \
    cd /root/.vim/colors/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/wombat256mod.vim && \
    cd /root/.vim/ftplugin/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/python_editing.vim && \
    cd /root/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/vimrc2 && \
    mv /root/vimrc2  /root/.vimrc

# vim for ubuntu
 RUN \
    mkdir -p \
    /home/ubuntu/.vim/autoload \
    /home/ubuntu/.vim/bundle \
    /home/ubuntu/.vim/colors/ \
    /home/ubuntu/.vim/ftplugin/ && \
    curl -LSso /home/ubuntu/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    cd /home/ubuntu/.vim/bundle/ && \
    git clone https://github.com/tpope/vim-sensible.git && \
    git clone https://github.com/ctrlpvim/ctrlp.vim.git && \
    git clone https://github.com/scrooloose/nerdtree && \
    git clone https://github.com/Lokaltog/vim-powerline.git && \
    git clone https://github.com/jistr/vim-nerdtree-tabs.git && \
    git clone https://github.com/python-mode/python-mode.git && \
    git clone https://github.com/fatih/vim-go.git && \
    git clone https://github.com/vim-syntastic/syntastic.git && \
    cd /home/ubuntu/.vim/colors/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/wombat256mod.vim && \
    cd /home/ubuntu/.vim/ftplugin/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/python_editing.vim && \
    cd /home/ubuntu/ && \
    wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/vimrc2 && \
    mv /home/ubuntu/vimrc2  /root/.vimrc

# go packages
RUN \
    export PATH=$PATH:/usr/local/go/bin && \
    export GOPATH=/root/go/bin && \
    export GOBIN=/root/go/bin && \
    go get github.com/nsf/gocode && \
    go get github.com/alecthomas/gometalinter && \
    go get golang.org/x/tools/cmd/goimports && \
    go get golang.org/x/tools/cmd/guru && \
    go get golang.org/x/tools/cmd/gorename && \
    go get github.com/golang/lint/golint && \
    go get github.com/rogpeppe/godef && \
    go get github.com/kisielk/errcheck && \
    go get github.com/jstemmer/gotags && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/fatih/motion && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl

# go packages
RUN \
    export PATH=$PATH:/usr/local/go/bin && \
    export GOPATH=/home/ubuntu/go/bin && \
    export GOBIN=/home/ubuntu/go/bin && \
    go get github.com/nsf/gocode && \
    go get github.com/alecthomas/gometalinter && \
    go get golang.org/x/tools/cmd/goimports && \
    go get golang.org/x/tools/cmd/guru && \
    go get golang.org/x/tools/cmd/gorename && \
    go get github.com/golang/lint/golint && \
    go get github.com/rogpeppe/godef && \
    go get github.com/kisielk/errcheck && \
    go get github.com/jstemmer/gotags && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/fatih/motion && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl

# going to try to fix vim
RUN \
    add-apt-repository ppa:jonathonf/vim && \
    apt-get -y update && \
    apt-get install -y vim-nox-py2 && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    vim --version

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/
COPY ./versions.sh /root/bin/

WORKDIR /root/
CMD ["/bin/bash"]
