FROM ubuntu:latest
MAINTAINER Marcelo Bittencourt <mab@mab.net>

RUN apt-get update \
	&& apt-get install -y supervisor nagios-nrpe-server nagios-plugins \
        && apt-get clean \
        && rm -rf /var/lib/apt /tmp/* /var/tmp/*

EXPOSE 5666

# Add custom files
COPY files/root /

# Start command
CMD ["/start"]

