FROM ubuntu:24.04

WORKDIR /work

COPY .aliases /root/.bash_aliases

RUN apt update -y

RUN apt upgrade -y

RUN apt install -y vim wget bash netcat-traditional curl ca-certificates gnupg2 lsb-release

RUN apt install -y apt-utils htop software-properties-common apache2-utils unzip tzdata

RUN apt install -y openssh-client ncdu simpleproxy net-tools psmisc tmux jq tinyproxy

RUN update-ca-certificates

RUN mkdir -p /etc/apt/keyrings

# APT PostgreSQL

RUN mkdir -p /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \
    --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

RUN echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > \
    /etc/apt/sources.list.d/pgdg.list

# APT Docker

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# APT Mongo Shell

ARG MONGO_RELEASE=8.0

RUN wget -q -O - https://www.mongodb.org/static/pgp/server-${MONGO_RELEASE}.asc | apt-key add -

RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/${MONGO_RELEASE} multiverse" > \
    /etc/apt/sources.list.d/mongodb-org-${MONGO_RELEASE}.list

# APT Redis

RUN add-apt-repository ppa:redislabs/redis

# Final APT update

RUN apt update -y

# tinyproxy config

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
RUN mkdir -p /var/log/tinyproxy /var/run/tinyproxy && \
    chown -R nobody:nogroup /var/log/tinyproxy /var/run/tinyproxy

# Install packages

RUN apt install -y openjdk-21-jdk

RUN apt install -y postgresql-client redis-tools

# Docker

RUN apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN systemctl disable docker.service
RUN systemctl disable docker.socket

# etcd

ARG ETCD_RELEASE=v3.6.5

RUN wget -q https://github.com/etcd-io/etcd/releases/download/${ETCD_RELEASE}/etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    tar xvf etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    cd etcd-${ETCD_RELEASE}-linux-amd64 && \
    mv etcdctl /usr/local/bin && \
    cd ../ && rm -rf etcd-${ETCD_RELEASE}-linux-amd64*

# Jmeter

ARG JMETER_VERSION=5.6.3

ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}

ENV JMETER_CUSTOM_PLUGINS_FOLDER=/plugins

ENV JMETER_BIN=/opt/jmeter/bin

ENV JMETER_DOWNLOAD_URL=https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

ENV TZ=Europe/Sofia

RUN mkdir -p /tmp/dependencies && \
    curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt && \
    tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
    rm -rf /tmp/dependencies

ENV PATH=${PATH}:${JMETER_HOME}/bin

RUN jmeter --version

# Mongo Shell

RUN apt install -y mongodb-mongosh

# Python and Psycopg2

RUN apt install -y python3-pip libpq-dev python3-dev

RUN rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED

RUN pip install --break-system-packages psycopg2

# need to force apt update so here aways copy something new
COPY version.txt /work

RUN apt update -y

RUN apt upgrade -y

# Cleanup

RUN apt clean all -y

ENTRYPOINT ["tail", "-f", "/dev/null"]
