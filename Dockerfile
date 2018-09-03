FROM ubuntu:latest

MAINTAINER Dan Sheffner <Dan@Sheffner.com>

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
    wtforms "

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
    wtforms "

# # compile python3 from source
# WORKDIR /root/
# RUN wget --quiet https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
# RUN tar -xf Python-3.6.3.tar.xz
# WORKDIR /root/Python-3.6.3/
# # RUN ./configure --enable-loadable-sqlite-extensions
# RUN ./configure --enable-optimizations --enable-loadable-sqlite-extensions
# RUN make -j9
# RUN make install

# go
RUN wget --quiet https://dl.google.com/go/go1.11.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.11.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc
RUN echo 'export GOBIN=/root/go/bin' >> /root/.bashrc
RUN echo 'export GOPATH=/root/go/bin' >> /root/.bashrc
RUN rm go1.11.linux-amd64.tar.gz

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
    go get github.com/golang/lint/golint && \
    go get github.com/rogpeppe/godef && \
    go get github.com/kisielk/errcheck && \
    go get github.com/jstemmer/gotags && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/fatih/motion && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl

# ruby install
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN curl -sSL https://get.rvm.io | bash -s stable --rails
# RUN gem install bundler

#  go compile from source
# UN mkdir /root/git/
# ORKDIR /root/git/
# UN git clone https://github.com/golang/go.git
# ORKDIR /root/git/go/src/
# UN GOROOT_BOOTSTRAP=/usr/local/go/ GOOS=linux GOARCH=amd64 ./bootstrap.bash

# # pypy from source
# # This keeps erorring out.  If want to sumbit a patch please do.
# RUN \
#     cd /root/ && \
#     hg clone https://bitbucket.org/pypy/pypy && cd pypy/pypy/goal && \
#     pypy ../../rpython/bin/rpython -Ojit targetpypystandalone && \
#     ln -s /root/pypy/pypy/goal/pypy-c /usr/bin/pypy-c
# 
# # pypy rpython/bin/rpython --opt=jit pypy/goal/targetpypystandalone.py
# # cp -r /usr/include/tcl8.4/* /usr/include/ && \
# # make share location
# RUN mkdir -p /root/git/

# tmux setup
# ADD tmuxinator /root/.tmuxinator
RUN echo 'set-option -g default-shell /bin/bash' > /root/.tmux.conf

# # rust
# RUN curl -sSf https://static.rust-lang.org/rustup.sh > rustup.sh && \
#     chmod +x ./rustup.sh && \
#     ./rustup.sh
# 
# # powershell
# RUN curl -fsSL https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/download.sh > powershell_install && \
#     chmod +x powershell_install && \
#     ./powershell_install

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/
COPY ./versions.sh /root/bin/

# put back public mirror
# COPY ./public.sources.list /etc/apt/sources.list

# gem tmux no longer used
# CMD ["/usr/local/bin/tmuxinator", "start", "default"]

# CMD ["/bin/bash"]
WORKDIR /root/
CMD ["/usr/bin/tmux"]