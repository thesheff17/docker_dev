FROM thesheff17/docker_powershell

MAINTAINER Dan Sheffner <Dan@Sheffner.com>

# tmux setup
# ADD tmuxinator /root/.tmuxinator
RUN echo 'set-option -g default-shell /bin/bash' > /root/.tmux.conf

# Copy over samples
COPY ./webserver.go /root/bin/
COPY ./webserver.py /root/bin/
COPY ./versions.sh /root/bin/

WORKDIR /root/
CMD ["/usr/bin/tmux"]
