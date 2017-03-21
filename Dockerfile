FROM debian:8.3

RUN echo "nameserver 8.8.8.8" >> /etc/resolve.conf

RUN echo \
   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
    deb http://security.debian.org jessie/updates main\n' \
    > /etc/apt/sources.list

RUN apt-get clean \
  && apt-get update \
  && apt-get install -y curl git net-tools

RUN git config --global pull.rebase true \
  && cd /usr/local/src \
  && git clone https://freeswitch.org/stash/scm/fs/freeswitch.git

RUN curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - \
  && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list \
  && apt-get check \
  && apt-get update \
  && apt-get install -y  --force-yes freeswitch-video-deps-most autoconf

WORKDIR /usr/local/src/freeswitch
RUN git checkout -b v1.6.9 v1.6.9
RUN ./bootstrap.sh -j
ADD modules.conf .
RUN ./configure -C
RUN make && make install
#RUN make cd-sounds-install && make cd-moh-install
# need external DNS for resolving host names for BMLTs


RUN touch /usr/local/freeswitch/log/freeswitch.log \
  && echo "export TERM=xterm" >> /root/.bashrc \
  && echo "export PATH=$PATH:/usr/local/freeswitch/bin" >> /root/.bashrc \
  && apt-get install nano

EXPOSE 5060/tcp
EXPOSE 5060/udp
EXPOSE 5080/tcp
EXPOSE 5080/udp
EXPOSE 8080/tcp
EXPOSE 16400-16410/udp

COPY conf/ /usr/local/freeswitch/conf/
COPY scripts/ /usr/local/freeswitch/scripts

ENTRYPOINT ["./entrypoint.sh"]
