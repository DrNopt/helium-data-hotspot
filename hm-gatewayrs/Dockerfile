ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.3.0
FROM balenalib/raspberrypi4-64-debian:bullseye-run

WORKDIR /opt/gatewayrs

ARG SYSTEM_TIMEZONE
ARG GATEWAY_RS_RELEASE
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        wget \
        python3 \
        ca-certificates \
        tar \
        i2c-tools \
        --no-install-recommends && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/helium/gateway-rs/releases/download/"$GATEWAY_RS_RELEASE"/helium-gateway-"${GATEWAY_RS_RELEASE#v}"-aarch64-unknown-linux-musl.tar.gz && \
    tar -xzf helium-gateway-"${GATEWAY_RS_RELEASE#v}"-aarch64-unknown-linux-musl.tar.gz && \
    mv helium_gateway /usr/bin/helium_gateway && \
    mkdir -p /etc/helium_gateway && \
    mv settings.toml /etc/helium_gateway/default.toml && \
    rm helium-gateway-*.tar.gz

COPY start-gatewayrs.sh .
COPY settings.toml.template /etc/helium_gateway/settings.toml.template

ENTRYPOINT ["/opt/gatewayrs/start-gatewayrs.sh"]
