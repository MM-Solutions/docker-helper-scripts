FROM --platform=arm64 ubuntu:24.04 AS arm-ubuntu24

SHELL ["/bin/bash", "-c"]

ARG ARG_HTTPS_PROXY
ENV https_proxy=${ARG_HTTPS_PROXY}

ARG ARG_HTTP_PROXY
ENV http_proxy=${ARG_HTTP_PROXY}

ARG ARG_NO_PROXY
ENV no_proxy=${ARG_NO_PROXY}

RUN [ -n "${http_proxy}" ]                                                                      && \
    echo "Acquire::http::Proxy \"${http_proxy}\";" > /etc/apt/apt.conf                          && \
    echo "Acquire::https::Proxy \"${http_proxy}\";" >> /etc/apt/apt.conf                        || \
    true

RUN apt-get update                                                                              && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y                                              \
            bash-completion file tree wget curl wget sudo locales unzip adduser                 && \
    apt autoremove -y                                                                           && \
    apt clean                                                                                   && \
    locale-gen "en_US.UTF-8"                                                                    && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

RUN addgroup devs                                                                               && \
    useradd -s /bin/bash -m -g devs dev                                                         && \
    usermod -aG sudo dev                                                                        && \
    echo dev:dev | chpasswd

USER dev:devs

####################################################################################################
FROM ubuntu:24.04 AS x86-ubuntu24

SHELL ["/bin/bash", "-c"]

ARG ARG_HTTPS_PROXY
ENV https_proxy=${ARG_HTTPS_PROXY}

ARG ARG_HTTP_PROXY
ENV http_proxy=${ARG_HTTP_PROXY}

ARG ARG_NO_PROXY
ENV no_proxy=${ARG_NO_PROXY}

RUN [ -n "${http_proxy}" ]                                                                      && \
    echo "Acquire::http::Proxy \"${http_proxy}\";" > /etc/apt/apt.conf                          && \
    echo "Acquire::https::Proxy \"${http_proxy}\";" >> /etc/apt/apt.conf                        || \
    true

RUN apt-get update                                                                              && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y                                              \
            bash-completion file tree wget curl wget sudo locales unzip adduser                 && \
    apt autoremove -y                                                                           && \
    apt clean                                                                                   && \
    locale-gen "en_US.UTF-8"                                                                    && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

RUN addgroup devs                                                                               && \
    useradd -s /bin/bash -m -g devs dev                                                         && \
    usermod -aG sudo dev                                                                        && \
    echo dev:dev | chpasswd

USER dev:devs
