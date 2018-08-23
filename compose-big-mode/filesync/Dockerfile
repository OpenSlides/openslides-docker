FROM debian:stretch

RUN mkdir /app

RUN apt-get update && \
	apt-get upgrade -y &&\
	apt-get install -y zip wget 

COPY run.sh /app/run.sh
RUN useradd -m openslides
WORKDIR /app

CMD ["/app/run.sh"]
