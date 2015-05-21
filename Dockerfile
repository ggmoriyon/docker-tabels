FROM tutum/tomcat:7.0

MAINTAINER Guillermo Gonzalez-Moriyon "guillermo.gonzalez@fundacionctic.org"

ENV CATALINA_BASE /tomcat
ENV TABELS_VERSION 0.6-SNAPSHOT
ENV TABELS_DATA /data
ENV JAVA_MAXMEMORY 256

RUN apt-get update && apt-get install -y wget

RUN wget http://sourceforge.net/projects/sesame/files/Sesame%202/$TABELS_VERSION/openrdf-sesame-$TABELS_VERSION-sdk.tar.gz/download -O /tmp/sesame.tar.gz && tar xzf /tmp/sesame.tar.gz -C /opt && ln -s /opt/openrdf-sesame-$TABELS_VERSION /opt/sesame && rm /tmp/sesame.tar.gz

# Remove docs and examples
RUN rm -rf $CATALINA_BASE/webapps/docs && rm -rf $CATALINA_BASE/webapps/examples

# Deploy 
RUN mkdir ${CATALINA_BASE}/webapps/openrdf-sesame && cd ${CATALINA_BASE}/webapps/openrdf-sesame && jar xf /opt/sesame/war/openrdf-sesame.war &&  mkdir ${CATALINA_BASE}/webapps/openrdf-workbench && cd ${CATALINA_BASE}/webapps/openrdf-workbench && jar xf /opt/sesame/war/openrdf-workbench.war

COPY run.sh /run.sh

VOLUME /data