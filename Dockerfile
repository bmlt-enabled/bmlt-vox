FROM debian:8.3

RUN apt-get update \
  && apt-get install -y curl \
  && curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - \
  && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list

RUN apt-get clean \
  && apt-get update 

RUN apt-get install -y --force-yes nano git 

RUN git config --global pull.rebase true \
  && cd /usr/local/src \
  && git clone https://freeswitch.org/stash/scm/fs/freeswitch.git

RUN apt-get install -y --force-yes freeswitch-video-deps-most autoconf

WORKDIR /usr/local/src/freeswitch
RUN git checkout -b v1.6.6 v1.6.6
RUN ./bootstrap.sh -j
RUN curl -H "Accept: application/vnd.github.v3.raw" https://api.github.com/repos/radius314/bmlt.vox/contents/modules.conf?ref=master > modules.conf
RUN ./configure -C
RUN make && make install
RUN make cd-sounds-install && make cd-moh-install
RUN echo "nameserver 4.2.2.2" >> /etc/resolve.conf

EXPOSE 5060/tcp
EXPOSE 5060/udp
EXPOSE 5080/tcp
EXPOSE 5080/udp
EXPOSE 8080/tcp
EXPOSE 16400-16410/udp

#docker run -it --name freeswitch -p 5060:5060/tcp -p 5060:5060/udp -p 5080:5080/tcp -p 5080:5080/udp -p 8080:8080/tcp -p 16400-16410:16400-16410/udp radius314/bmlt.vox:latest /bin/bash
