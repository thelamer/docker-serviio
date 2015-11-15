FROM linuxserver/baseimage.apache

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="dcraw git-core ffmpeg oracle-java8-installer php5-xmlrpc"

# set serviio version, java and location ENV
ENV SERVIIO_VER="1.5.2" JAVA_HOME="/usr/lib/jvm/java-8-oracle" LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Set the locale
RUN locale-gen en_US.UTF-8

# add repositories
RUN add-apt-repository -y ppa:webupd8team/java && \
add-apt-repository ppa:mc3man/trusty-media  && \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections

# install serviio app
RUN mkdir -p /app/serviio && \
curl -o /tmp/serviio.tar.gz -L http://download.serviio.org/releases/serviio-$SERVIIO_VER-linux.tar.gz && \
tar xf /tmp/serviio.tar.gz -C /app/serviio --strip-components=1 && \
mv /app/serviio/plugins /app/serviio/plugins_orig && \

# installpackages
apt-get update && \
apt-get install $APTLIST -qy && \

# cleanup
cd /tmp && \
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

#Adding Custom files
ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh && \

# give abc user a home folder
usermod -d /config/serviio abc

# ports and volumes
EXPOSE 23424/tcp 8895/tcp 1900/udp 8780/tcp
VOLUME /config /transcode

