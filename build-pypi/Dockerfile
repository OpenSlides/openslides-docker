from python:3.7

ARG BRANCH
ARG REPOSITORY_URL
ARG COMMIT_HASH

RUN mkdir /app

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget curl xz-utils bzip2 vim sudo
RUN wget https://nodejs.org/dist/v10.5.0/node-v10.5.0-linux-x64.tar.xz -P /tmp && \
  cd /tmp && tar xfvJ node-v10.5.0-linux-x64.tar.xz && \
  ln -sf /tmp/node-v10.5.0-linux-x64/bin/node /usr/bin/node
WORKDIR /app

COPY run.sh /app/run.sh

RUN useradd -m openslides
RUN echo "openslides ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -a -G sudo openslides
RUN chown -R openslides /app
RUN rm -rf /var/lib/apt/lists/*

USER openslides
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

CMD /bin/bash run.sh
