# Building the Suite

The ```docker-compose.yml``` describes a full system setup with every compnent detached from the other.

The ```worker``` component is scalable, so you can spawn multiple instances of that and add some load balancing magic to it, to get it running in bigger contexts.

To build the composition run

    docker-compose build

After the db is correctly filled, you can bring the network up with

    docker-compose up

If you want to use this in an productional environment, you need to change the ```docker-compose.yml```, to persistently store your data.

You can scale the workers via

    docker-compose scale web=2 worker=8
