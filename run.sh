#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --progress plain \
    --build-arg BF_IMAGE=send \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t send-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 -e BF_SEND_URI=http://localhost send-dev sh
