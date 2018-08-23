# Use the PyPi for Big Mode

The PyPi Package created with the ```build-pypi``` Dockerfile can be used by this setup to test a _Big Mode_ setup of OpenSlides. For this you need to copy the ```*.tar.gz``` PyPi Package to the root of this folder as ```openslides-pypi.tar.gz```.

After that you build the ```docker-compose``` environment:

    docker-compose build

and when that is done you can start your instance with

    docker-compose up
