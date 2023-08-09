FROM bfren/node:node16-2.2.6

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-send"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # set the base URI
    SEND_BASE_URI= \
    # path to uploads storage directory
    SEND_FILE_DIR=/uploads \
    # maximum file size in bytes (default: 2GB)
    SEND_MAX_FILE_SIZE=2147483648 \
    # maximum files per archive (default: 64)
    SEND_MAX_FILES_PER_ARCHIVE=64 \
    # maximum upload expiry time in seconds (default: 7 days)
    SEND_MAX_EXPIRE_SECONDS=604800 \
    # maximum number of downloads (default: 10)
    SEND_MAX_DOWNLOADS=10 \
    # comma-separated download limit options to show in UI dropdown (default: 1, 5, 10)
    SEND_DOWNLOAD_COUNTS=1,5,10 \
    # default download limit in UI (default: 1)
    SEND_DEFAULT_DOWNLOAD_COUNT=1 \
    # comma-separated expiry time options to show in UI dropdown in seconds (default: 1 hour, 1 day, 1 week)
    SEND_EXPIRE_TIMES_SECONDS=3600,86400,604800 \
    # default expiry time in UI (default: 1 day)
    SEND_DEFAULT_EXPIRE_TIME_SECONDS=86400 \
    # set the redis host (default: redis)
    SEND_REDIS_HOST=redis \
    # set the redis port (default: 6379)
    SEND_REDIS_PORT=6379 \
    # set the optional redis username
    SEND_REDIS_USER= \
    # set the optional redis password
    SEND_REDIS_PASSWORD= \
    # set the optional redis database
    SEND_REDIS_DB=

COPY ./overlay /

RUN bf-install

VOLUME [ "/uploads" ]
