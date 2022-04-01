# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Execute during the build of the image
ARG TEMPIO_VERSION BUILD_ARCH
RUN \
    curl -sSLf -o /usr/bin/tempio \
    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# Install Erlang since gleam gets compiled to erlang
RUN \
    apk update \
    && apk add erlang erlang-dev \ 
    && rm -rf /var/cache/apk/*

# Install gleam
WORKDIR /usr/local/bin

RUN \
    curl -Lo gleam.tar.gz https://github.com/gleam-lang/gleam/releases/download/v0.20.1/gleam-v0.20.1-linux-amd64.tar.gz \
    && tar xf gleam.tar.gz \
    && chmod a+x gleam

WORKDIR /

# Install rebar3 as it is needed by glome dependencies
RUN set -xe \
    && curl -fSL -o rebar3 "https://s3.amazonaws.com/rebar3-nightly/rebar3" \
    && chmod +x ./rebar3 \
    && ./rebar3 local install \
    && rm ./rebar3

ENV PATH "$PATH:/root/.cache/rebar3/bin"

# Copy root filesystem
COPY rootfs /
