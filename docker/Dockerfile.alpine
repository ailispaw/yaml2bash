FROM alpine:3.4

ARG BRANCH="master"

RUN apk --no-cache --update add --virtual build-deps build-base yaml-dev git && \
    git clone --depth 1 --branch ${BRANCH} https://github.com/ailispaw/yaml2bash /work && \
    STATIC=1 make -C /work/src install && \
    apk del build-deps && \
    rm -rf /work

ENTRYPOINT [ "yaml2bash" ]
