FROM centos:latest

LABEL maintainer="maciej.gasiorowski@gmail.con"

ARG PHORONIX_VERSION=8.4.1

RUN yum -y install epel-release &&\
    yum update -y &&\
    yum install -y epel-releas which php php-xml php-gd php-sqlite3 php-posix php-cli supervisor && \
    yum autoremove -y &&\
    yum clean all &&\
    rm -rf /var/cache/yum &&\
    alternatives --install /usr/bin/php php /usr/bin/php 100

ENV PHOROMATIC_HOME="/var/lib/phoromatic"
RUN useradd -u 1000 -d $PHOROMATIC_HOME -m -s /bin/bash phoromatic

RUN curl -o /tmp/phoronix-test-suite.tar.gz https://phoronix-test-suite.com/releases/phoronix-test-suite-$PHORONIX_VERSION.tar.gz &&\
    tar xzfv /tmp/phoronix-test-suite.tar.gz -C /tmp/ &&\
    (cd /tmp/phoronix-test-suite && ./install-sh) &&\
    rm -fr phoronix-test-suite phoronix-test-suite-$PHORONIX_VERSION.tar.gz &&\
    chown -R phoromatic:phoromatic /usr/share/phoronix-test-suite

# ADD resources/phoromatic-user-config.xml /etc/phoronix-test-suite.xml
ADD resources/supervisord.conf /etc/supervisor/supervisord.conf
ADD --chown=phoromatic:phoromatic resources/phoromatic-user-config.xml $PHOROMATIC_HOME/.phoronix-test-suite/user-config.xml
ADD --chown=phoromatic:phoromatic resources/phoromatic_tests.txt $PHOROMATIC_HOME
ADD --chown=phoromatic:phoromatic resources/run.sh $PHOROMATIC_HOME
RUN chmod +x $PHOROMATIC_HOME/run.sh

USER phoromatic
WORKDIR $PHOROMATIC_HOME

EXPOSE 8088 8089

VOLUME ["/.phoronix-test-suite"]

ENV PTS_SILENT_MODE=1
ENV PTS_IS_DAEMONIZED_SERVER_PROCESS=1
CMD ["./run.sh"]