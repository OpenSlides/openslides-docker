from python:3.7-slim

RUN mkdir /app

RUN apt -y update && \
  apt -y upgrade && \
  apt install -y sudo libpq-dev supervisor curl wget xz-utils bzip2 git gcc gnupg2 make g++
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt -y install nodejs
WORKDIR /app

COPY run.sh /app/run.sh

RUN useradd -m openslides
RUN echo "openslides ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -a -G sudo openslides
RUN chown -R openslides /app
RUN rm -rf /var/lib/apt/lists/*

USER openslides
CMD /bin/bash run.sh
