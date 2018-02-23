from python:3.5

RUN apt-get update && \
	apt-get upgrade -y &&\
	apt-get install -y libpq-dev supervisor curl vim git
RUN wget https://nodejs.org/dist/v6.11.3/node-v6.11.3-linux-x64.tar.xz -P /tmp
RUN cd /tmp && tar xfvJ node-v6.11.3-linux-x64.tar.xz
RUN ln -sf /tmp/node-v6.11.3-linux-x64/bin/node /usr/bin/node

RUN mkdir /app
WORKDIR /app
RUN useradd -m openslides
RUN chown openslides /app

USER openslides
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN git clone https://github.com/OpenSlides/OpenSlides.git .
RUN git reset --hard d185e05ab194f05214e677bb1a537d142fa75389 

USER root
RUN pip install -r /app/requirements_big_mode.txt

USER openslides
ARG BOWERFILE
ADD $BOWERFILE bower.json

RUN $HOME/.yarn/bin/yarn --non-interactive
RUN node_modules/.bin/gulp --production

EXPOSE 8000

RUN pip freeze
RUN node_modules/.bin/bower list

RUN python manage.py createsettings

CMD python manage.py start --no-browser
