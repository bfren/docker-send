FROM bfren/node:node16-3.0.0-dev

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-send"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # the URI of the Send instance is required
    BF_SEND_URI=

COPY ./overlay /

RUN bf-install

VOLUME [ "/uploads" ]
