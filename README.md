# ARM and x86 Ubuntu

Arm Ubuntu docker uses qemu for executing on pc
X86 Ubuntu docker uses CDI for executing on pc

## Install Docker

### Cleanup Old Versions

```bash
sudo apt remove docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop
```

### Setup Docker Remote Repository

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Install Docker Engine

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli docker-compose
```

### Add User to Docker Group

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

***Please note that until PC reboot, *newgrp docker* should be invoked on every new console open***

### Add internal docker registry mirror. (optional)

#### Note: Using a tab instead of space and other invisible whitespace characters may break the proper work of json configuration files and later may lead to 'docker.service failed to start' error.

1. Add corresponding *docker-registry-mirror-url* value in the tag "registry-mirrors" in: /etc/docker/daemon.json

```json
{
        "registry-mirrors": [<docker-registry-mirror-url>]
}
```

2. Restart the docker service to take the new settings.

```bash
sudo fromdos /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### Enable CDI

#### Note: Using a tab instead of space and other invisible whitespace characters may break the proper work of json configuration files and later may lead to 'docker.service failed to start' error.

1. Add *cdi* in *features* in: /etc/docker/daemon.json

```json
{
    "features": {
        "cdi": true
    }
}
```

2. Restart the docker service to take the new settings.

```bash
sudo fromdos -f /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### Proxy. (optional)

#### Note: Using a tab instead of space and other invisible whitespace characters may break the proper work of json configuration files and later may lead to 'docker.service failed to start' error.

1. Add corresponding *http-proxy-url*, *https-proxy-url* and *no-proxy-url* values in the tag "http-proxy", *https-proxy* and *no-proxy* in: /etc/docker/daemon.json

```json
{
    "proxies": {
        "http-proxy": <http-proxy-url>,
        "https-proxy": <https-proxy-url>,
        "no-proxy": <no-proxy-url>
    }
}
```

2. Restart the docker service to take the new settings.

```bash
sudo fromdos -f /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
```

3. Set proxy related environment variables in bash, before invoking docker build commands

```bash
export http_proxy=<http-proxy-url>
export https_proxy=<https-proxy-url>
export no_proxy=<no-proxy-url>
```

## Install qemu

Following commands are needed to install qemu for arm and docker driver for it

```bash
sudo apt-get install qemu-user-static qemu-system-arm
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm builder
docker buildx create --name builder --driver docker-container --use
docker buildx inspect --bootstrap
```

## Host OS functions

There are helper shell functions for docker manipulations in *qemu.sh*

### docker-build-arm-ubuntu24

This function builds Arm Ubuntu docker image

### docker-run-arm-ubuntu24

This function runs Arm Ubuntu docker container

### docker-build-x86-ubuntu24

This function builds x86 Ubuntu docker image

### docker-run-x86-ubuntu24

This function runs x86 Ubuntu docker container

**Please note that cdi.json needs to be propagated to /etc/cdi**

### docker-images-clean-up

This function cleans up all dangling docker images
