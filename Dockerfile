FROM ubuntu:20.04

WORKDIR /work

ARG ETCD_RELEASE=v3.4.20

RUN apt-get update -y

RUN apt-get upgrade -y

RUN apt-get install -y vim wget bash netcat-traditional curl ca-certificates gnupg2 lsb-release

RUN apt-get install -y apt-utils htop software-properties-common apache2-utils

RUN apt-get update -y

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN add-apt-repository ppa:redislabs/redis

RUN apt-get update -y

RUN apt-get install -y postgresql-client redis-tools

RUN wget https://github.com/etcd-io/etcd/releases/download/${ETCD_RELEASE}/etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    tar xvf etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    cd etcd-${ETCD_RELEASE}-linux-amd64 && \
    mv etcdctl /usr/local/bin && \
    cd ../ && rm -rf etcd-${ETCD_RELEASE}-linux-amd64*

RUN apt-get clean all -y

ENTRYPOINT ["tail", "-f", "/dev/null"]
