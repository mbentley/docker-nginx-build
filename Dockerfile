FROM debian:stretch
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN (apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget git mercurial libpcre3-dev build-essential libssl-dev libexpat-dev libpam-dev zlib1g zlib1g-dev &&\
  rm -rf /var/lib/apt/lists/*)
COPY build.sh /usr/local/bin/build.sh

CMD ["/usr/local/bin/build.sh"]
