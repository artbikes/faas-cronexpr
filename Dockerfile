FROM alpine:latest

RUN apk --no-cache add \
    ca-certificates

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN buildDeps=' \
        go \
        git \
        gcc \
        g++ \
        libc-dev \
        libgcc \
    ' \
    set -x \
    && apk --no-cache add $buildDeps \
    && go get github.com/gorhill/cronexpr \
    && go install github.com/gorhill/cronexpr \
    && cd /go/src/github.com/gorhill/cronexpr/cronexpr \
    && go build . \
	&& mv /go/src/github.com/gorhill/cronexpr/cronexpr /bin/ \
    && apk del $buildDeps \
    && echo "Build complete."
ADD https://github.com/openfaas/faas/releases/download/0.6.15/fwatchdog /usr/bin
RUN chmod +x /usr/bin/fwatchdog


ENV fproces="cronexpr"
CMD [ "/bin/fwatchdog" ]

