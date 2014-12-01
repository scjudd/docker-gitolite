FROM ubuntu:trusty
MAINTAINER Spencer Judd <spencercjudd@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive bash -c ' \
    apt-get update \ 
    && apt-get install -yq \
        git-core \
        gitolite \
' # END RUN

RUN useradd -c gitolite -m -r -s /bin/bash -U git && passwd -l git \
    && mkdir -p /var/run/sshd

VOLUME /home/git
EXPOSE 22
CMD /usr/sbin/sshd -D
