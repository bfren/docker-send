#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --build-arg BF_IMAGE=send \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t send-dev \
    . \
    && \
    docker run -it -p "127.0.0.1:3000:3000" -e BF_DEBUG=1 -e BF_SEND_URI=http://localhost send-dev sh
