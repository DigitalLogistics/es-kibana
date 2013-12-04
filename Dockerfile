FROM boothead/saucy
MAINTAINER Ben Ford <ben@dlstartup.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-6-jre wget
ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
RUN (cd /tmp && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.tar.gz -O pkg.tar.gz && tar zxf pkg.tar.gz && mv elasticsearch-* /opt/elasticsearch)
RUN rm -rf /tmp/*

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx unzip

ADD http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip /kibana.zip

# RUN "unzip -d /usr/share/nginx/html kibana.zip"
RUN unzip kibana.zip
RUN mv kibana-latest /usr/share/nginx/html/kibana
RUN chown -R www-data.www-data /usr/share/nginx/html

EXPOSE 9200
EXPOSE 9300
CMD nginx; /opt/elasticsearch/bin/elasticsearch -f