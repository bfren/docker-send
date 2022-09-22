FROM bfren/node:node18-2.0.12

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-send"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # set the base URL
    SEND_BASE_URL= \
    # path to uploads storage directory
    SEND_FILE_DIR=/uploads \
    # maximum file size (default: 2GB)
    SEND_MAX_FILE_SIZE=2147483648 \
    # maximum files per archive (default: 64)
    SEND_MAX_FILES_PER_ARCHIVE=64 \
    # maximum upload expiry time (default: 7 days)
    SEND_MAX_EXPIRE_SECONDS=604800 \
    # maximum number of downloads (default: 100)
    SEND_MAX_DOWNLOADS=100 \
    # download limit options to show in UI dropdown
    SEND_DOWNLOAD_COUNTS= \
    # expiry time options to show in UI dropdown (default: 1 hour, 1 day, 1 week)
    SEND_EXPIRE_TIMES_SECONDS=3600,86400,604800 \
    # default download limit in UI (default: 1)
    SEND_DEFAULT_DOWNLOADS=1 \
    # default expiry time in UI (default: 1 day)
    SEND_DEFAULT_EXPIRE_SECONDS=86400

COPY ./overlay /

RUN bf-install

VOLUME [ "/uploads" ]
