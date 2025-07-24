FROM docker.io/library/golang:alpine as builder
LABEL maintainer="Christer Warén/Warén Group <no-reply@waren.io>"

ENV CGO_ENABLED=0

RUN apk update && \
    apk upgrade && \
    apk cache clean && \
    rm -rf /var/cache/apk/*

RUN apk add --no-cache git

WORKDIR /src

RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git -b "master" . && \
    ./build

FROM docker.io/library/alpine:latest
LABEL maintainer="Christer Warén/Warén Group <no-reply@waren.io>"

RUN apk update && \
    apk upgrade && \
    apk cache clean && \
    rm -rf /var/cache/apk/*

COPY --from=builder /src/yggdrasil /usr/bin/yggdrasil
COPY --from=builder /src/yggdrasilctl /usr/bin/yggdrasilctl
COPY --from=builder /src/contrib/docker/entrypoint.sh /usr/bin/entrypoint.sh

VOLUME [ "/etc/yggdrasil-network" ]

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
