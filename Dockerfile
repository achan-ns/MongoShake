FROM golang:alpine as builder

WORKDIR /go/src/

RUN apk update
RUN apk add bash
RUN apk add git
RUN apk add gcc
RUN apk add musl-dev

ADD src/ ./src
RUN go get -u github.com/kardianos/govendor
RUN cd src && govendor sync
ADD scripts/ ./scripts
ADD build.sh build.sh
RUN ./build.sh

ADD . .

FROM alpine:latest as runner
WORKDIR /app
COPY --from=builder /go/src/ .

ENTRYPOINT ./bin/collector.linux -conf=conf/collector.conf -verbose
