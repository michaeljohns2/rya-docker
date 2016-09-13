FROM local/tomcat
MAINTAINER michaeljohns2

## Rya Docker from Vagrant example at <https://github.com/apache/incubator-rya/blob/master/extras/vagrantExample/src/main/vagrant/Vagrantfile>
# <<< MOST WORK IS DONE IN `entrypoint.sh` >>>

##########################################################
# START ::: FOR ALPINE
##########################################################

# JAVA_HOME already set
# keep CATALINA_BASE as CATALINA_ROOT


RUN apk add --update \
    python \
    bash \
    sudo \
    vim \
    curl \
    wget \
    which \
    git \
    unzip \
    less \
    findutils

# installed less for colors in terminal

# latest maven as of SEP 2016
ENV MAVEN_VERSION 3.3.9
ENV MAVEN_BASE apache-maven-${MAVEN_VERSION}

RUN wget http://www.eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_BASE}-bin.tar.gz \
         -O /tmp/maven.tgz && \
    tar zxvf /tmp/maven.tgz && mv ${MAVEN_BASE} /maven && \
    ln -s /maven/bin/mvn /usr/bin/ && \
    rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi && \
    rm /tmp/maven.tgz /var/cache/apk/*

# remove all cached packages

##########################################################
# END ::: FOR ALPINE
##########################################################

## List of dependency versions
ENV APP_ROOT /opt
ENV ACCUMULO_VERSION 1.6.5
ENV HADOOP_VERSION 2.7.2
ENV RYA_EXAMPLE_VERSION 3.2.10-SNAPSHOT
ENV SESAME_VERSION 2.7.6
ENV ZOOKEEPER_VERSION 3.4.5-cdh4.5.0

## ENVIRONMENT VARS
# JAVA_HOME ALREADY ADDED
ENV HADOOP_HOME ${APP_ROOT}/hadoop-${HADOOP_VERSION}
ENV ZOOKEEPER_HOME ${APP_ROOT}/zookeeper-${ZOOKEEPER_VERSION}
ENV ZOO_LOG_DIR ${ZOOKEEPER_HOME}/logs/
ENV ACCUMULO_HOME ${APP_ROOT}/accumulo-${ACCUMULO_VERSION}
ENV PATHADD "$JAVA_HOME/bin:$ZOOKEEPER_HOME/bin:$ACCUMULO_HOME/bin:$HADOOP_HOME/bin"
ENV PATH "$PATH:$PATHADD"

ENV HADOOP_PREFIX "$HADOOP_HOME"
ENV HADOOP_CONF_DIR "$HADOOP_PREFIX/etc/hadoop"
ENV ACCUMULO_LOG_DIR $ACCUMULO_HOME/logs
ENV ACCUMULO_TSERVER_OPTS="-Xmx384m -Xms384m"
ENV ACCUMULO_MASTER_OPTS="-Xmx128m -Xms128m"
ENV ACCUMULO_MONITOR_OPTS="-Xmx64m -Xms64m"
ENV ACCUMULO_GC_OPTS="-Xmx64m -Xms64m"
ENV ACCUMULO_GENERAL_OPTS="-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -Djava.net.preferIPv4Stack=true"
ENV ACCUMULO_OTHER_OPTS="-Xmx128m -Xms64m"
ENV ACCUMULO_KILL_CMD="kill -9 %p"

# Expose ports (for documentation)
#EXPOSE 8080
#EXPOSE 2181

# Add custom files, set permissions
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

