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
RUN mv openslides-3* openslides
RUN cd openslides && \
  pip install -r requirements/big_mode.txt

USER openslides
RUN openslides createsettings
RUN sed -i "s/EMAIL_HOST = 'localhost'/EMAIL_HOST = 'postfix'/" /home/openslides/.config/openslides/settings.py
RUN sed -i 's/EMAIL_PORT = 587/EMAIL_PORT = 25/' /home/openslides/.config/openslides/settings.py
RUN sed -i "s/#EMAIL_HOST_USER = ''/EMAIL_HOST_USER = 'openslides'/" /home/openslides/.config/openslides/settings.py
RUN sed -i "s/#EMAIL_HOST_PASSWORD = ''/EMAIL_HOST_PASSWORD = 'openslides'/" /home/openslides/.config/openslides/settings.py
RUN sed -i 's/use_redis = False/use_redis= True/' /home/openslides/.config/openslides/settings.py
RUN sed -i 's#redis://127.0.0.1#redis://redis:6379/0#' /home/openslides/.config/openslides/settings.py
RUN sed -i "s/'host': '127.0.0.1',/'host': 'redis',/" /home/openslides/.config/openslides/settings.py
RUN sed -i "s/'ENGINE': 'django.db.backends.sqlite3',/'ENGINE': 'django.db.backends.postgresql',/" /home/openslides/.config/openslides/settings.py
RUN sed -i "s/'NAME': os.path.join(OPENSLIDES_USER_DATA_DIR, 'db.sqlite3'),/'NAME': 'openslides',\n        'USER': 'openslides',\n        'PASSWORD': 'openslides',\n        'HOST': 'postgres',\n        'PORT': '5432'/" /home/openslides/.config/openslides/settings.py
