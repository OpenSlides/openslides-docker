# Bug 3552

These files are specifically to help resolving the Bug https://github.com/OpenSlides/OpenSlides/issues/3552

# Build the docker Files to inject something in it

    docker build -f folder/Dockerfile -t os-074559ba --build-arg BOWERFILE=my_bower.json .
