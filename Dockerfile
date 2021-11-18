FROM ubuntu:focal
MAINTAINER MAB <mab@mab.net>

# Keep image updated
ENV REFRESHED_AT 2021-11-18-00-00Z

RUN apt-get update \
    && apt-get install -q -y \
       apt-transport-https \
       ca-certificates \
       curl \
       software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt /tmp/* /var/tmp/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

RUN apt-get update \
    && apt-get upgrade -q -y \
    && apt-get install -q -y \
       supervisor \
       nagios-nrpe-server \
       nagios-plugins \
       docker-ce \
    && apt-get clean \
    && rm -rf /var/lib/apt /tmp/* /var/tmp/*

EXPOSE 5666

# Add custom files
COPY files/root /

# Start command
CMD ["/start"]

