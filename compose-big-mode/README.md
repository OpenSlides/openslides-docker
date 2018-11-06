# Docker-Compose based OpenSlides Suite

The ```docker-compose.yml``` describes a full system setup with every component detached from the other.

The suite consists of the following...

...services:

* ```server``` (Server of OpenSlides, the base image, database migration and creation of the settings is created here)
* ```client``` (Client of OpenSlides)
* ```postgres``` (Database)
* ```redis``` (Cache Database)
* ```proxy``` (Proxy and Load Balancer for the Web-Instances)
* ```letsencrypt``` (SSL-Certificate appliance)
* ```pg-slave``` (Database Slave for Fallback-Server)
* ```filesync``` (Backup Solution for static Files for Fallback-Server)
* ```postfix``` (Mail sending system)

...networks:

* ```front``` (just for nginx)
* ```back``` (for everything else in the backend)

...volumes:

* ```dbdata``` (the data of the ```postgres``` container)
* ```staticfiles``` (static files and settings of OpenSlides)
* ```certs``` (SSL-Certificates created by ```letsencrypt``` and used by ```nginx```)
* ```clientfiles``` (files to deliver the OpenSlides ```client```)

## How To Use

Firstly, you have to clone the repository:

    git clone https://github.com/OpenSlides/openslides-docker.git

To specify a special git repository of OpenSlides, a certain Branch and/or a certain commit, you should change the following entries at the ```core``` service:

    args:
      # Change according to your details
      REPOSITORY_URL: https://github.com/OpenSlides/OpenSlides.git
      BRANCH: master
      COMMIT_SHA: 22d436b6b6db2c50acce924c86976aa026b9d92a

You should change the following entries at the ```web``` service, according to your setup (if you just plan to run it on localhost, the setup is fine):

    environment:
      # Change according to your details
      VIRTUAL_HOST: 'localhost'
      LETSENCRYPT_HOST: 'localhost'
      LETSENCRYPT_EMAIL: 'localhost'

(If you don't run Debian or Arch, you may want to check the location of your ```docker.sock``` and change the location respectively in the ```docker-compse.yml```)

If you don't plan on using a fallback-system, comment out the ```REPLICATION_USER``` and ```REPLICATION_PASSWORD``` entries and delete the ```ports``` entries for the ```postgres``` service.

Comming up, you should build the environment with, where ```$PROJECT_NAME``` is the name of this instance. If you want to run multiple instance on one machine,

    docker-compose build

When that has run through, you can start OpenSlides with

    docker-compose up --scale server=1 --scale redis=1 --scale letsencrypt=0 --scale postgres=1 --scale proxy=1 --scale web=1 --scale pg-slave=0 --scale filesync=0 --scale postfix=1

If you wnat to use the backup-system, you should scale the `filesync` to 1.

The volumes listed above will hold your persistant data, so you may want to link or mount them to different parts of your system. To find out where they have been linked in your filesystem. You can list the volumes with

    docker volume ls

Your output will look like this (or ```$PROJECT_NAME_certs```... if you specified a project name)

    # docker volume ls
    DRIVER              VOLUME NAME
    local               5cbbf750b3d52a2e19615c96276c1144b27d637ec85ac46488f1f8fb86e259f3
    local               85dc5658e1b7c01f77590f8c0adcb4a23b02eeaef2f76fb83f95fef3efb61082
    local               88d855132874e6af0a5545e099626029a4dfb0501930454895d1846aba6da8fd
    local               a88d6a57b9bc7c43433273421261de32a981d15f997678e94b40ec36f3d14f59
    local               openslidesdocker_certs
    local               openslidesdocker_dbdata
    local               openslidesdocker_staticfiles

Where the buttom three are the ones of interest. You can read the ```Mountpoint``` in your local filesystem via

    # docker volume inspect openslidesdocker_dbdata
    [
      {
        "CreatedAt": "2018-04-16T15:07:33+02:00",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "openslidesdocker",
            "com.docker.compose.volume": "dbdata"
        },
        "Mountpoint": "/var/lib/docker/volumes/openslidesdocker_dbdata/_data",
        "Name": "openslidesdocker_dbdata",
        "Options": {},
        "Scope": "local"
      }
    ]

Use the directory from the ```Mountpoint``` to make your backups or any further handling with the files.

Once you are happy with your config, you should change

    LETSENCRYPT_TEST=false

to recieve real certificates from LE. Note, that you can only do 20 requests per week!

You can scale the ```server``` and ```client``` services.

    docker-compose up --scale server=2 --scale client=2

To shut down the instance you simply type

    docker-compose down

## Multiple Instances

You should have a copy of this folder for each instance, and define a ```$PROJECT_NAME``` for each instance. The you can enter you folder and build each instance with

    docker-compose build -p $PROJECT_NAME

All ```docker-compose``` actions work accordingly with the ```-p $PROJECT_NAME``` paramenter attached.

## Fallback-Servers

You can start an fallback-instance, where just the postgres-slave runs and replicates the data from the master, you fix the entries at the ```pg-slave``` entry in your services, according to your setup. Also, change the ```REPLICATION_USER```and ```REPLICATION_PASSWORD``` for both, the ```postgres``` and ```pg-slave``` entries.

Additionally, you can snyc your files with the ```filesync``` service. You should create a new ```htpasswd``` file in the nginx folder, to get rid of the standard passwords. Then you can fix the environment variables in the ```filesync``` service. The User, Password and Host only need to be assigned, when the given role for the ```filesync``` is ```SLAVE```, when you have the ```MASTER``` role assigned, you just need to take care about the ```htpasswd``` file. The user and password specified there are then used for the ```SLAVE``` service.

First start the master-instsance, then start just the ```pg-slave``` and ```filesync``` service on the failover-machine:

    docker-compose up --scale server=0 --scale redis=0 --scale letsencrypt=0 --scale postgres=0 --scale proxy=0 --scale web=0 --scale pg-slave=1 --scale filesync=1 --scale postfix=0
