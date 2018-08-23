FROM python:3.7-slim

WORKDIR /app
#COPY run.sh /app/run.sh

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y xz-utils build-essential

RUN useradd -m openslides
RUN chown -R openslides /app

COPY openslides-pypi.tar.gz /app/openslides-pypi.tar.gz
RUN pip install openslides-pypi.tar.gz
RUN tar xf openslides-pypi.tar.gz
RUN cd openslides* && pip install -r requirements_big_mode.txt

USER openslides 
RUN openslides createsettings

RUN sed -i 's/use_redis = False/use_redis= True/' /home/openslides/.config/openslides/settings.py
RUN sed -i 's#redis://127.0.0.1:6379/0#redis://redis:6379/0#' /home/openslides/.config/openslides/settings.py
RUN sed -i 's#redis://127.0.0.1#redis://redis#' /home/openslides/.config/openslides/settings.py
RUN sed -i "s/'host': '127.0.0.1',/'host': 'redis',/" /home/openslides/.config/openslides/settings.py
RUN echo "\
CHANNEL_LAYERS['default']['CONFIG']['hosts'] = [('redis', 6379)]\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
SESSION_ENGINE = 'redis_sessions.session'\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
SESSION_REDIS_HOST = 'redis'\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
SESSION_REDIS_PORT = 6379\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
SESSION_REDIS_DB = 0\
" >> /home/openslides/.config/openslides/settings.py

RUN sed -i 's/EMAIL_HOST =/#EMAIL_HOST =/' /home/openslides/.config/openslides/settings.py
RUN sed -i 's/EMAIL_PORT =/#EMAIL_PORT =/' /home/openslides/.config/openslides/settings.py
RUN sed -i 's/EMAIL_HOST_USER =/#EMAIL_HOST_USER =/' /home/openslides/.config/openslides/settings.py
RUN sed -i 's/EMAIL_HOST_PASSWORD =/#EMAIL_HOST_PASSWORD =/' /home/openslides/.config/openslides/settings.py

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
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
EMAIL_HOST = 'postfix'\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
EMAIL_PORT = 25\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
EMAIL_HOST_USER = 'openslides'\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
EMAIL_HOST_PASSWORD = 'openslides'\
" >> /home/openslides/.config/openslides/settings.py
RUN echo "\
ROOT_URLCONF = 'openslides.old_urls'\
" >> /home/openslides/.config/openslides/settings.py
