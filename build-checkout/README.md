# OpenSlides-buildCheckout

Images to test specific checkouts of OpenSlides

## build the image

Search for the commit you want to build i.E 074559ba23cb7627697024bb78519f42f4dc4eff and build the image:

    docker build -t os-074559ba --build-arg COMMIT_SHA=074559ba23cb7627697024bb78519f42f4dc4eff .

## run the image

After you build your image, run it and expose the post for testing issues

    docker run -p 8000:8000 os-074559ba

## Old Image

In older checkouts you may need some additional dependencies. That whats the "Dockerfile" old is for. You can select this to build your image with `-f Dockefile.old`:

    docker build -f Dockerfile.old -t os-074559ba --build-arg COMMIT_SHA=074559ba23cb7627697024bb78519f42f4dc4eff .
