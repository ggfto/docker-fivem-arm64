FROM jrei/systemd-ubuntu:24.04

ARG URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7290-a654bcc2adfa27c4e020fc915a1a6343c3b4f921/fx.tar.xz

VOLUME [ "/FXServer" ]

WORKDIR /defaults

# Atualiza e instala dependências mínimas
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    git \
    curl \
    ca-certificates

# Instala o FEX-Emu
RUN add-apt-repository ppa:fex-emu/fex -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends fex-emu-armv8.4 zenity

# Clona os dados do servidor
RUN git clone https://github.com/citizenfx/cfx-server-data.git server-data

# Baixa e extrai os binários do FXServer
RUN curl -L $URL -o fx.tar.xz && \
    tar xf fx.tar.xz && \
    rm -f fx.tar.xz

# Remove pacotes desnecessários para imagem mais leve
RUN apt-get purge -y software-properties-common git && apt-get autoremove -y

COPY server.cfg /defaults/server-data/
COPY startscript.sh /startscript.sh

# Extrai RootFS se incluído manualmente
RUN mkdir -p /root/.fex-emu && \
    tar xzf /tmp/fex-emu-rootfs.tar.gz -C /root/ || echo "RootFS externo não incluído"

WORKDIR /

CMD ["sh", "/startscript.sh"]

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40120/tcp
EXPOSE 40120/udp
