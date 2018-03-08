# Building the Suite

The ```docker-compose.yml``` describes a full system setup with every compnent detached from the other.

The ```core``` and the ```worker``` component is scalable, so you can spawn multiple instances of that and add some load balancing magic to it, to get it running in bigger contexts.
