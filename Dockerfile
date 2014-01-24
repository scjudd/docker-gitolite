FROM ubuntu
# MAINTAINER Spencer Judd <spencercjudd@gmail.com>

# Enable the universe repository and apply any available updates.
RUN \
    sed -i "/main/s/$/ universe/g" /etc/apt/sources.list ;\
    export DEBIAN_FRONTEND="noninteractive" ;\
    apt-get update && apt-get upgrade -y ;\
# END RUN

# Install git and gitolite.
RUN \
    apt-get install -y git-core ;\
    apt-get install -y gitolite ;\
    useradd -c gitolite -m -r -s /bin/bash -U git ;\
    passwd -l git ;\
# END RUN

# Install vim and set it as the default editor.
RUN \
    apt-get install -y vim ;\
    update-alternatives --set editor /usr/bin/vim.basic ;\
# END RUN

# Finish configuration.
RUN \
    mkdir -p /var/run/sshd ;\
    export LANGUAGE=en_US.UTF-8 ;\
    export LANG=en_US.UTF-8 ;\
    export LC_ALL=en_US.UTF-8 ;\
    locale-gen en_US.UTF-8 ;\
    dpkg-reconfigure locales ;\
# END RUN

# Install curl (for the post-receive hook).
RUN apt-get install -y curl

# Add the post-receive hook.
ADD post-receive /home/git/.gitolite/hooks/common/

# Fix permissions.
RUN \
    chmod +x /home/git/.gitolite/hooks/common/post-receive ;\
    chown -R git:git /home/git/.gitolite/ ;\
# END RUN

VOLUME /home/git
EXPOSE 22
CMD /usr/sbin/sshd -D
