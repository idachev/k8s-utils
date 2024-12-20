FROM ubuntu:20.04

WORKDIR /work

# need to force apt update so here aways copy something new
COPY version.txt /work

COPY .aliases /root/.bash_aliases

RUN apt update -y

RUN apt upgrade -y

RUN apt install -y vim wget bash netcat-traditional curl ca-certificates gnupg2 lsb-release

RUN apt install -y apt-utils htop software-properties-common apache2-utils unzip tzdata

RUN apt install -y openssh-client ncdu simpleproxy net-tools psmisc tmux jq

RUN update-ca-certificates

RUN apt install -y openjdk-17-jdk

RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN add-apt-repository ppa:redislabs/redis

RUN apt update -y

RUN apt install -y postgresql-client redis-tools

RUN mkdir -p /etc/apt/keyrings

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update -y

RUN apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN systemctl disable docker.service
RUN systemctl disable docker.socket

# etcd

ARG ETCD_RELEASE=v3.4.20

RUN wget -q https://github.com/etcd-io/etcd/releases/download/${ETCD_RELEASE}/etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    tar xvf etcd-${ETCD_RELEASE}-linux-amd64.tar.gz && \
    cd etcd-${ETCD_RELEASE}-linux-amd64 && \
    mv etcdctl /usr/local/bin && \
    cd ../ && rm -rf etcd-${ETCD_RELEASE}-linux-amd64*

# Jmeter

ARG JMETER_VERSION=5.5

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

# Mongo Shell

RUN wget -q -O - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -

RUN sh -c 'echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/6.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-6.0.list'

RUN apt update -y

RUN apt install -y mongodb-mongosh mongodb-clients

RUN apt install -y python3-pip libpq-dev python3-dev

RUN python3 -m pip install --upgrade pip

RUN pip install psycopg2

RUN apt upgrade -y

# Cleanup

RUN apt clean all -y

ENTRYPOINT ["tail", "-f", "/dev/null"]
