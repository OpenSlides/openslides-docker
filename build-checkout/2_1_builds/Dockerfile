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
ARG COMMIT_SHA
RUN git reset --hard $COMMIT_SHA

USER root
RUN pip install -r /app/requirements_big_mode.txt
RUN pip install django-redis asgi-redis django-redis-sessions psycopg2
RUN pip install 'daphne<2'

USER openslides
RUN /tmp/node-v6.11.3-linux-x64/bin/npm install; exit 0
USER root
RUN su -c 'node_modules/.bin/bower --config.interactive=false install' openslides
USER openslides
RUN node_modules/.bin/gulp --production

EXPOSE 8000

CMD python manage.py start --no-browser
