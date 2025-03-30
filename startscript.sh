#!/bin/sh

if [ -z "$KEY" ]; then
    echo
    echo "ERROR: \$KEY environment variable is not set. You can set it using the \"-e KEY=changeme\" parameter."
    echo

    exit 1
else
    :
fi

if [ -z "$(ls -A /FXServer)" ]; then
    cp -r /defaults/* /FXServer/
else
    :
fi

if [ -d "/FXServer/fex-emu/" ]; then
    echo "Found the root filesystem for FEX-Emu."
    mkdir -p /root/.fex-emu/
    cp -r /FXServer/fex-emu/* /root/.fex-emu
else
    echo "Downloading the root filesystem for FEX-Emu."
    FEXRootFSFetcher -yx
    mkdir -p /FXServer/fex-emu/
    cp -r /root/.fex-emu/* /FXServer/fex-emu
fi

rm -rf /defaults
sed -i '/^sv_licenseKey/d' /FXServer/server-data/server.cfg
echo "sv_licenseKey ${KEY:-}" >> /FXServer/server-data/server.cfg
FEXServer &
FEXInterpreter /FXServer/run.sh