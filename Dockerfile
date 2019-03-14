FROM golang:1.12 as build

ENV GOROOT /build
ENV GOROOT_FINAL /usr/local/go
ENV GOROOT_BOOTSTRAP /usr/local/go

WORKDIR /build
COPY go ./

WORKDIR /build/src
RUN ./make.bash

FROM buildpack-deps:stretch-scm

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.12.1

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR "$GOPATH"

COPY --from=build /build /usr/local/go
