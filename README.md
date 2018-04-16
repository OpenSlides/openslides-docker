# Building the Suite

The ```docker-compose.yml``` describes a full system setup with every compnent detached from the other.

You should change the environment variables, according to your setup.

Persistant data will be saved to volumes named ```dbdata```, ```staticfiles``` and ```certs```. As the names tell, ```dbdata``` stores the ```postgres``` daata, ```staticfiles``` collects the static files and the openslides settings and ```certs``` holds the letsencrpyt certificates. If you use this locally, the letsencrypt container will fail, but you still can use the non-encrypted way.

The ```worker``` component is scalable, so you can spawn multiple instances of that and add some load balancing magic to it, to get it running in bigger contexts.

To build the composition run

    docker-compose build

You can bring the network up with

    docker-compose up

You can scale the workers via

    docker-compose scale web=2 worker=8


