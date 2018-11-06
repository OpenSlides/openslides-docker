# Building the PyPi Package

This Docker Image builds a ```pip``` usable package.

First you need to build the image itself. It will be tagger ```os-buildpypi```.

    docker build -t os-buildpypi .

Finally you run the ```os-buildpypi``` image to build the ```pip``` package. You need to define some variables for the build script. You can change them to your needs.

 * ```NEWUID``` is the user id the created ```pip``` package will be chowned to
 * ```REPOSITORY_URL``` is the URL of the GIT Repository of OpenSlides
 * ```BRANCH``` is the branch in the GIT Repository
 * ```COMMIT_HASH``` is the hash of the commit in the branch you want to use

This is an example that builds a development version of OpenSlides 2.3

    docker run --env NEWUID=`id -u` \
      --env REPOSITORY_URL=https://github.com/OpenSlides/OpenSlides.git \
      --env BRANCH=master \
      --env COMMIT_HASH=123b7c702b44f1376853a0171f1f247088a24a88 \
      -v `pwd`/build:/app/build \
      -it os-buildpypi
