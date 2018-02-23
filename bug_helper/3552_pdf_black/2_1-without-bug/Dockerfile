from python:3.4
 
RUN apt-get update && \
	apt-get upgrade -y && \
        apt-get install -y \
		libpq-dev \
		supervisor \
		curl \
		vim \
		git 

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
RUN git reset --hard bbbad71e2df2615ac33744cf69ee7ad1dfcfd108

USER root
RUN pip install -r requirements_production.txt
RUN pip install "django-redis==4.7.0" \
		"asgi-redis==1.3.0" \
		"django-redis-sessions==0.5.6" \
		"psycopg2==2.6.2" \
		"daphne<2"

USER openslides
RUN sed -i "s/~/=/g" bower.json
RUN sed -i "s/~/=/g" package.json
RUN /tmp/node-v6.11.3-linux-x64/bin/npm install\
	bower@1.8.0 \
	gulp@3.9.1
RUN /tmp/node-v6.11.3-linux-x64/bin/npm install

USER root
RUN su -c 'node_modules/.bin/bower --config.interactive=false install' openslides

USER openslides
RUN node_modules/.bin/gulp 

EXPOSE 8000

USER root
RUN su -c 'node_modules/.bin/bower --allow-root --config.interactive=false list'

USER openslides
CMD python manage.py start --no-browser
