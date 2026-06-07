ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.3.0
FROM balenalib/raspberrypi4-64-debian:bullseye-run

WORKDIR /opt/gatewayrs

ARG SYSTEM_TIMEZONE
ARG GATEWAY_RS_RELEASE
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Install dependencies
RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        wget \
        python3 \
        ca-certificates \
        tar \
        --no-install-recommends && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Download and install helium gateway-rs
RUN wget https://github.com/helium/gateway-rs/releases/download/"$GATEWAY_RS_RELEASE"/helium-gateway-"$GATEWAY_RS_RELEASE"-aarch64-unknown-linux-musl.tar.gz && \
    tar -xzf helium-gateway-"$GATEWAY_RS_RELEASE"-aarch64-unknown-linux-musl.tar.gz && \
    mv helium_gateway /usr/bin/helium_gateway && \
    rm helium-gateway-*.tar.gz

# Copy start script and settings file
COPY start-gatewayrs.sh .
COPY settings.toml.template /etc/helium_gateway/settings.toml.template

ENTRYPOINT ["/opt/gatewayrs/start-gatewayrs.sh"]
