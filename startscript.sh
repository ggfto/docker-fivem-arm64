#!/bin/sh

if [ -z "$KEY" ]; then
    echo
    echo "ERROR: \$KEY environment variable is not set. You can set it using the \"-e KEY=changeme\" parameter."
    echo
    exit 1
fi

# Copia os arquivos da pasta default para FXServer (somente se ainda não estiverem lá)
if [ -z "$(ls -A /FXServer)" ]; then
    cp -r /defaults/* /FXServer/
fi

# Garante que o rootfs do FEX está disponível
if [ -d "/FXServer/fex-emu/" ]; then
    echo "Found the root filesystem for FEX-Emu in /FXServer/fex-emu."
    mkdir -p /root/.fex-emu/
    cp -r /FXServer/fex-emu/* /root/.fex-emu
    elif [ ! -d "/root/.fex-emu/" ] || [ -z "$(ls -A /root/.fex-emu/)" ]; then
    echo "Downloading the root filesystem for FEX-Emu (headless)..."
    FEXRootFSFetcher --headless -x || {
        echo "Failed to fetch RootFS. Aborting."
        exit 2
    }
    mkdir -p /FXServer/fex-emu/
    cp -r /root/.fex-emu/* /FXServer/fex-emu
fi

# Limpa a pasta default após uso
rm -rf /defaults

# Atualiza a license key
sed -i '/^sv_licenseKey/d' /FXServer/server-data/server.cfg
echo "sv_licenseKey ${KEY:-}" >> /FXServer/server-data/server.cfg

# Inicia o servidor
FEXServer &

# Executa o script principal via FEXInterpreter
FEXInterpreter /FXServer/run.sh
