FROM ubuntu:latest

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

# MAINTAINER Dan Sheffner <Dan@Sheffner.com>

# time docker build . dsheffner/docker_dev

# helper ENV variables
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV EDITOR vim
ENV SHELL bash

# build date
RUN echo `date` > /root/build_date.txt

# sort by name
RUN \
    apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -yq \
    automake \
    bison \
    build-essential \
    curl \
    ffmpeg \
    gawk \
    gcc \
    git \
    libbz2-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    libffi-dev \
    libffi-dev \
    libffi-dev \
    libgc-dev \
    libgdbm-dev \
    libgmp-dev \
    libjpeg-dev \
    liblttng-ust0 \
    liblzma-dev \
    libmemcached-dev \
    libncurses-dev \
    libncurses5-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libsqlite3-dev \
    libssl-dev \
    libssl-dev \
    libssl-dev\
    libtool \
    libunwind8 \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    libz-dev \
    lsb-release \
    make \
    man \
    mercurial \
    mysql-client \
    net-tools \
    openjdk-8-jdk \
    openssl \
    php \
    php-cli \
    php-mysql \
    pkg-config  \
    pypy \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    screen \
    sqlite3 \
    sudo \
    tcl-dev \
    tk-dev \
    tmux \
    vim \
    wget \
    zlib1g-dev && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# pip upgrades
RUN pip3 install --upgrade pip && pip2 install --upgrade pip

# virtualenv
RUN pip2 install virtualenvwrapper virtualenv && \
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
RUN \
    /bin/bash -c " source /root/.virtualenvs/venv3/bin/activate && \
    pip3 install \
    alembic \
    boto3 \
    bpython \
    coverage \
    django \
    django-autoslug \
    django-braces \
    django-compressor \
    django-crispy-forms \
    django-debug-toolbar \
    django-environ \
    django-floppyforms \
    django-model-utils \
    django-nose django-axes \
    django-redis \
    django-sass-processor \
    django-secure \
    django-test-plus \
    django_extensions \
    factory_boy \
    flask \
    flask-admin \
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
    markupsafe \
    pillow django-allauth \
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
    wtforms \
    zappa "

# python2 pip
RUN \
    /bin/bash -c " source /root/.virtualenvs/venv2/bin/activate && \
    pip install \
    alembic \
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
    django-floppyforms \
    django-model-utils \
    django-nose \
    django-redis \
    django-sass-processor \
    django-secure \
    django-test-plus \
    django_extensions \
    factory_boy \
    flask \
    flask-admin \
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
    wtforms \
    zappa "

# go
RUN wget --quiet https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc
RUN echo 'export GOBIN=/root/go/bin' >> /root/.bashrc
RUN echo 'export GOPATH=/root/go/bin' >> /root/.bashrc
RUN rm go1.12.5.linux-amd64.tar.gz

# vim modules
RUN mkdir -p /root/.vim/autoload /root/.vim/bundle /root/.vim/colors/ /root/.vim/ftplugin/
RUN curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
WORKDIR /root/.vim/bundle/
RUN git clone https://github.com/tpope/vim-sensible.git && \
    git clone https://github.com/ctrlpvim/ctrlp.vim.git  && \
    git clone https://github.com/scrooloose/nerdtree  && \
    git clone https://github.com/Lokaltog/vim-powerline.git  && \
    git clone https://github.com/jistr/vim-nerdtree-tabs.git  && \
    git clone https://github.com/python-mode/python-mode.git  && \
    git clone https://github.com/fatih/vim-go.git  && \
    git clone https://github.com/vim-syntastic/syntastic.git

# RUN git clone --recursive https://github.com/davidhalter/jedi-vim.git

WORKDIR /root/.vim/colors/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/wombat256mod.vim
WORKDIR /root/.vim/ftplugin/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/python_editing.vim
WORKDIR /root/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/vimrc2
RUN mv vimrc2 .vimrc

# go packages
RUN export PATH=$PATH:/usr/local/go/bin && \
    export GOPATH=/root/go/bin && \
    export GOBIN=/root/go/bin && \
    go get github.com/nsf/gocode && \
    go get github.com/alecthomas/gometalinter && \
    go get golang.org/x/tools/cmd/goimports && \
    go get golang.org/x/tools/cmd/guru && \
    go get golang.org/x/tools/cmd/gorename && \
    go get golang.org/x/lint/golint && \
    go get github.com/rogpeppe/godef && \
    go get github.com/kisielk/errcheck && \
    go get github.com/jstemmer/gotags && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/fatih/motion && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl

# ruby install
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN curl -sSL https://get.rvm.io | bash -s stable --rails
# RUN gem install bundler

# tmux setup
# ADD tmuxinator /root/.tmuxinator
RUN echo 'set-option -g default-shell /bin/bash' > /root/.tmux.conf

# rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/
COPY ./versions.sh /root/bin/

WORKDIR /root/
CMD ["/usr/bin/tmux"]