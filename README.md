# Docker-Compose based OpenSlides Suite

The ```docker-compose.yml``` describes a full system setup with every component detached from the other.

The suite consists of the following...

...services:

* ```core``` (Core of OpenSlides, the base image, database migration and creation of the settings is created here)
* ```web``` (Daphne)
* ```postgres``` (Database)
* ```redis``` (Cache Database)
* ```worker``` (Channel Worker)
* ```nginx``` (Proxy and Load Balancer for the Daphne-Instances)
* ```letsencrypt``` (SSL-Certificate appliance)

...networks:

* ```front``` (just for nginx)
* ```back``` (for everything else in the backend)

...volumes:

* ```dbdata``` (the data of the ```postgres``` container)
* ```staticfiles``` (static files and settings of OpenSlides)
* ```certs``` (SSL-Certificates created by ```letsencrypt``` and used by ```nginx```)

The ```core``` service exits on purpose with code ```0``` after it created the settings, collected the static files and migrated changes in the database. 

## How To Use

Firstly, you have to clone the whole repository, with all submodules:

    git clone --recursive -j8 https://github.com/OpenSlides/openslides-docker.git

You should check out at what commit the OpenSlides instance in ```core/OpenSlides``` is and may fix it to your needs by applying (where you replace your wanted commit with ```$COMMIT_SHA```)

    git submodule update -f -checkout $COMMIT_SHA core/OpenSlides

You should change the following entries at the ```web``` service, according to your setup (if you just plan to run it on localhost, the setup is fine):

    environment:
      # Change according to your details
      VIRTUAL_HOST: 'localhost'
      LETSENCRYPT_HOST: 'localhost'
      LETSENCRYPT_EMAIL: 'localhost'

(If you don't run Debian or Arch, you may want to check the location of your ```docker.sock``` and change the location respectively in the ```docker-compse.yml```)

Comming up, you should build the environment with, where ```$PROJECT_NAME``` is the name of this instance. If you want to run multiple instance on one machine,

    docker-compose build

When that has run through, you can start OpenSlides with

    docker-compose up -d

The volumes listed above will hold your persistant data, so you may want to link or mount them to different parts of your system. To find out where they have been linked in your filesystem. You can list the volumes with

    docker volume ls

Your output will look like this (or ```$PROJECT_NAME_certs```... if you specified a project name)

    # docker volume ls
    DRIVER              VOLUME NAME
    local               5cbbf750b3d52a2e19615c96276c1144b27d637ec85ac46488f1f8fb86e259f3
    local               85dc5658e1b7c01f77590f8c0adcb4a23b02eeaef2f76fb83f95fef3efb61082
    local               88d855132874e6af0a5545e099626029a4dfb0501930454895d1846aba6da8fd
    local               a88d6a57b9bc7c43433273421261de32a981d15f997678e94b40ec36f3d14f59
    local               openslides-docker_certs
    local               openslides-docker_dbdata
    local               openslides-docker_staticfiles

Where the buttom three are the ones of interest. You can read the ```Mountpoint``` in your local filesystem via

    docker volume inspect openslides-docker_dbdata

And than use that to redirect the output or build backups.

You can scale the ```web``` and ```worker``` services in an relationship of ```1:2```. Our reccommendation is max. number of worker equal to number of threads on your CPU.

    docker-compose scale web=2 worker=8

## Multiple Instances

You should have a copy of this folder for each instance, and define a ```$PROJECT_NAME``` for each instance. The you can enter you folder and build each instance with

    docker-compose build -p $PROJECT_NAME

All ```docker-compose``` actions work accordingly with the ```-p $PROJECT_NAME``` paramenter attached.