FROM ghcr.io/bfren/node:node16-3.4.4

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-send"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

COPY ./overlay /

ENV \
    # the URI of the Send instance is required
    BF_SEND_URI=

RUN bf-install

VOLUME [ "/uploads" ]
