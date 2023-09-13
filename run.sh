#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --build-arg BF_IMAGE=node \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t send-dev \
    . \
    && \
    docker run -it --name send send-dev sh
