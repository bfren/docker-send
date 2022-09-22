FROM bfren/node:node18-2.0.12

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-send"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # override the port that Send binds to
    PORT=3000

COPY ./overlay /

RUN bf-install

VOLUME [ "/uploads" ]
