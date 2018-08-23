# OpenSlides Docker

This Repository contains multiple Dockerfiles and Docker and Orchestration related files to run OpenSlides.

## ```compose-big-mode```

This is a ```docker-compose``` file to run the _Big Mode_ of OpenSlides. This is an example-setup that can be used in a production environment as is.

## ```build-pypi```

This image builds a ```pip``` usable package to release to ```pipy``` or to use it by yourself to build a ```pip``` package of OpenSlides.

## ```big-mode-pypi```

This is a ```docker-compose``` file to run the OpenSlides-3 Server based on the ```pip``` package build with ```build-pypi```
