docker-gitolite
===============

Run gitolite in a docker container. See below for setup instructions.

Build the docker image.

    docker build -rm -t gitolite .

Run the image, creating a new container.

    ID=$(docker run -d -p 2222:22 gitolite)

Run a temporary container, mounting the previous container's volumes so that
we can perform the final initialization steps. Be sure to replace "username" in
username.pub with an actual username you'd like to use.

    docker run -i -t -rm -volumes-from=$ID gitolite /bin/bash
    su - git
    cat > username.pub

Paste public key, adding a newline if necessary, then hit CTRL-D.

    gl-setup username.pub

This will spawn Vim with the gitolite config file loaded. Make changes as
necessary and quit. Finally, remove the public key file we created earlier. It's
already been imported into gitolite.

    rm username.pub

Hit CTRL-D twice to kill and remove the temporary container. The gitolite
instance is now configured and running over SSH on port 2222. To confirm:

    ssh -T -p 2222 git@localhost

You should see a message like the following:

    hello sjudd, this is gitolite 2.2-1 (Debian) running on git 1.7.9.5
    the gitolite config gives you the following access:
         R   W  gitolite-admin
        @R_ @W_    testing

