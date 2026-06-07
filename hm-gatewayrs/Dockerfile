ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.1.2
FROM balenalib/raspberrypi4-64-debian:bullseye-run

# Move to working directory
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
        --no-install-recommends && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Pull in latest helium gateway-rs deb file and install
RUN wget https://github.com/helium/gateway-rs/releases/download/"$GATEWAY_RS_RELEASE"/helium-gateway-"$GATEWAY_RS_RELEASE"-raspi01.deb
RUN dpkg -i helium-gateway-*-raspi01.deb

# Copy start script and settings file
COPY start-gatewayrs.sh .
COPY settings.toml.template /etc/helium_gateway/settings.toml.template

# Run start-gatewayrs script
ENTRYPOINT ["/opt/gatewayrs/start-gatewayrs.sh"]
