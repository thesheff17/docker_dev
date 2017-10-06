FROM thehseff17/docker_rust

MAINTAINER Dan Sheffner <Dan@Sheffner.com>

# tmux setup
# ADD tmuxinator /root/.tmuxinator
RUN echo 'set-option -g default-shell /bin/bash' > /root/.tmux.conf

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/

# put back public mirror
COPY ./public.sources.list /etc/apt/sources.list

# gem tmux no longer used
# CMD ["/usr/local/bin/tmuxinator", "start", "default"]

# CMD ["/bin/bash"]
WORKDIR /root/
CMD ["/usr/bin/tmux"]
