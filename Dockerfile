FROM jrei/systemd-ubuntu:24.04

ARG URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7290-a654bcc2adfa27c4e020fc915a1a6343c3b4f921/fx.tar.xz

VOLUME [ "/FXServer" ]

WORKDIR /defaults

RUN apt-get update -y
RUN apt install software-properties-common git -y
RUN add-apt-repository ppa:fex-emu/fex -y
RUN apt install fex-emu-armv8.4 -y
RUN git clone https://github.com/citizenfx/cfx-server-data.git server-data
RUN apt-get purge software-properties-common git -y
RUN curl -L $URL -o fx.tar.xz
RUN tar xf fx.tar.xz
RUN rm -f fx.tar.xz

COPY server.cfg /defaults/server-data/
COPY startscript.sh /
WORKDIR /

CMD ["sh", "/startscript.sh"]

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40120/tcp
EXPOSE 40120/udp