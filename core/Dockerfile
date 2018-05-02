from python:3.5

ARG BRANCH
ARG REPOSITORY_URL
ARG COMMIT_HASH

RUN mkdir /app

RUN apt-get update && \
	apt-get upgrade -y &&\
	apt-get install -y libpq-dev supervisor curl vim
RUN wget https://nodejs.org/dist/v6.11.3/node-v6.11.3-linux-x64.tar.xz -P /tmp
RUN cd /tmp && tar xfvJ node-v6.11.3-linux-x64.tar.xz
RUN ln -sf /tmp/node-v6.11.3-linux-x64/bin/node /usr/bin/node
RUN useradd -m openslides
RUN chown -R openslides /app
WORKDIR /app

USER openslides
RUN git clone -b $BRANCH $REPOSITORY_URL .
RUN git reset --hard $COMMIT_HASH
RUN rm -rf .git

USER root
RUN pip install -r requirements_big_mode.txt
RUN rm -rf /var/lib/apt/lists/*
 
USER openslides
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN $HOME/.yarn/bin/yarn --non-interactive

RUN node_modules/.bin/gulp --production
RUN rm -fr bower_components
RUN rm -fr node_modules

USER openslides
RUN python manage.py createsettings
RUN sed -i 's/use_redis = False/use_redis= True/' personal_data/var/settings.py
RUN sed -i 's#redis://127.0.0.1:6379/0#redis://redis:6379/0#' personal_data/var/settings.py
RUN sed -i 's/EMAIL_HOST =/#EMAIL_HOST =/' personal_data/var/settings.py
RUN sed -i 's/EMAIL_PORT =/#EMAIL_PORT =/' personal_data/var/settings.py
RUN sed -i 's/EMAIL_HOST_USER =/#EMAIL_HOST_USER =/' personal_data/var/settings.py
RUN sed -i 's/EMAIL_HOST_PASSWORD =/#EMAIL_HOST_PASSWORD =/' personal_data/var/settings.py
RUN echo "\
CHANNEL_LAYERS['default']['CONFIG']['hosts'] = [('redis', 6379)]\
" >> personal_data/var/settings.py

RUN echo "\
SESSION_ENGINE = 'redis_sessions.session'\
" >> personal_data/var/settings.py
RUN echo "\
SESSION_REDIS_HOST = 'redis'\
" >> personal_data/var/settings.py
RUN echo "\
SESSION_REDIS_PORT = 6379\
" >> personal_data/var/settings.py
RUN echo "\
SESSION_REDIS_DB = 0\
" >> personal_data/var/settings.py

RUN echo "DATABASES = {\ 
   'default': {\
        'ENGINE': 'django.db.backends.postgresql',\
        'NAME': 'openslides',\
        'USER': 'openslides',\
        'PASSWORD': 'openslides',\
        'HOST': 'postgres',\
        'PORT': '5432',\
    }\
}\
\
" >> personal_data/var/settings.py
RUN echo "\
EMAIL_HOST = 'postfix'\
" >> personal_data/var/settings.py
RUN echo "\
EMAIL_PORT = 25\
" >> personal_data/var/settings.py
RUN echo "\
EMAIL_HOST_USER = 'openslides'\
" >> personal_data/var/settings.py
RUN echo "\
EMAIL_HOST_PASSWORD = 'openslides'\
" >> personal_data/var/settings.py
