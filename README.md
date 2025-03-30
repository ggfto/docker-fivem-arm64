A Docker image for running a FiveM server with FEX-Emu in Docker on ARM64, based on systemd-ubuntu.

## Usage:

To use this image, run: ```docker pull moodpatcher/fivem-arm64:latest```

Podman CLI:

```bash 
podman run -it \
  -e KEY=changeme \
  -p 30120:30120/tcp \
  -p 30120:30120/udp \
  -p 40120:40120/tcp \
  -v ${PWD}/FXServer:/FXServer \
  --name fivem-arm64 \
  --replace \
  --rm \
  moodpatcher/fivem-arm64:latest
```

Docker Hub page: https://hub.docker.com/r/moodpatcher/fivem-arm64

