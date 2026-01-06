# syntax=docker/dockerfile:1
FROM alpine:latest

RUN set -eux && \
    wget https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh && \
    sh install-opentofu.sh --install-method standalone --skip-verify --opentofu-version 1.11.2 && \
    rm -f install-opentofu.sh
COPY terraform /terraform/
ARG CACHE_BUSTER_VERSION=unknown
RUN set -eux; \
    \
    cd /terraform; \
    tofu providers lock
