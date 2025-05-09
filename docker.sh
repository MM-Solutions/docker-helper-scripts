#!/bin/bash

function docker-build-arm-ubuntu24() {
    (
        cd ${DOCKER_UBUNTU_DIR}

        set -o pipefail

        DOCKER_BUILDKIT=1 docker build --progress=plain                                            \
                --build-arg ARG_HTTPS_PROXY=${https_proxy}                                         \
                --build-arg ARG_HTTP_PROXY=${http_proxy}                                           \
                --build-arg ARG_NO_PROXY=${no_proxy}                                               \
                --target arm-ubuntu24 -t arm-ubuntu24 ${DOCKER_UBUNTU_DIR}                         \
                -f ${DOCKER_UBUNTU_DIR}/Dockerfile
    ) && echo "Docker image build completed !!!"
}

function docker-run-arm-ubuntu24() {
    docker run -it -d -h arm-ubuntu24                                                              \
            -e https_proxy=${https_proxy} -e http_proxy=${http_proxy} -e no_proxy=${no_proxy}      \
            --user dev --name arm-ubuntu24 arm-ubuntu24 bash                                    && \
        echo "Docker container run completed !!!"
}

function docker-build-x86-ubuntu24() {
    (
        cd ${DOCKER_UBUNTU_DIR}

        set -o pipefail

        DOCKER_BUILDKIT=1 docker build --progress=plain                                            \
                --build-arg ARG_HTTPS_PROXY=${https_proxy}                                         \
                --build-arg ARG_HTTP_PROXY=${http_proxy}                                           \
                --build-arg ARG_NO_PROXY=${no_proxy}                                               \
                --target x86-ubuntu24 -t x86-ubuntu24 ${DOCKER_UBUNTU_DIR}                         \
                -f ${DOCKER_UBUNTU_DIR}/Dockerfile
    ) && echo "Docker image build completed !!!"
}

function docker-run-x86-ubuntu24() {
    docker run -it -d -h x86-ubuntu24                                                              \
            --device experiment.com/device=my                                                      \
            --user dev --name x86-ubuntu24 x86-ubuntu24 bash                                    && \
        echo "Docker container run completed !!!"
}

function docker-images-clean-up() {
    docker images -f 'dangling=true' -q
    docker builder prune -a -f

    echo "Docker image clean-up completed !!!"
}

DOCKER_UBUNTU_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

echo "Docker enviroment for ARM Ubuntu 24"
echo "==================================="
echo "docker-build-arm-ubuntu24"
echo "    Builds docker image"
echo "docker-run-arm-ubuntu24"
echo "    Runs docker image"
echo "docker-images-clean-up"
echo "    Docker images clean up"
echo "docker-build-x86-ubuntu24"
echo "    Builds docker image"
echo "docker-run-x86-ubuntu24"
echo "    Runs docker image"
