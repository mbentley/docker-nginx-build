FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget git mercurial libpcre3-dev build-essential libssl-dev libexpat-dev libpam-dev)
ADD build.sh /usr/local/bin/build.sh

CMD ["/usr/local/bin/build.sh"]
