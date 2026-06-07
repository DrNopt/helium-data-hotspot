# Packet Forwarder Docker File
# Updated for kernel 6.x compatibility
FROM balenalib/raspberry-pi-debian-python:bullseye-build as pktfwd-builder

ENV INPUT_DIR=/opt/input
ENV OUTPUT_DIR=/opt/output/pktfwd-dependencies

WORKDIR "$INPUT_DIR"

COPY requirements.txt requirements.txt
RUN pip3 install --target="$OUTPUT_DIR" --no-cache-dir -r requirements.txt

FROM balenalib/raspberry-pi-debian-python:bullseye-run as pktfwd-runner

ENV ROOT_DIR=/opt
ENV SX1301_PACKET_FORWARDER_OUTPUT_DIR=/opt/output
ENV SX1302_HAL_OUTPUT_DIR=/opt/output
ENV PKTFWD_BUILDER_OUTPUT_DIR=/opt/output/pktfwd-dependencies
ENV SX1301_DIR="$ROOT_DIR/sx1301"
ENV SX1302_DIR="$ROOT_DIR/sx1302"
ENV PYTHON_APP_DIR="$ROOT_DIR/pktfwd"
ENV PYTHON_DEPENDENCIES_DIR="$ROOT_DIR/pktfwd-dependencies"
ENV SX1301_RESET_LGW_FILEPATH="$SX1301_DIR/reset_lgw.sh"
ENV SX1301_REGION_CONFIGS_DIR="$PYTHON_APP_DIR/config/lora_templates_sx1301"
ENV SX1302_REGION_CONFIGS_DIR="$PYTHON_APP_DIR/config/lora_templates_sx1302"
ENV SX1302_LORA_PKT_FWD_FILEPATH="$SX1302_DIR/lora_pkt_fwd"
ENV UTIL_CHIP_ID_FILEPATH="$SX1302_DIR/chip_id"
ENV RESET_LGW_FILEPATH="$ROOT_DIR/reset_lgw.sh"

WORKDIR "$ROOT_DIR"

# Install gpiod for kernel 6.x GPIO support
RUN apt-get update && \
    apt-get install -y gpiod && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY pktfwd/ "$PYTHON_APP_DIR"
COPY reset_lgw.sh "$RESET_LGW_FILEPATH"

# hadolint ignore=DL3022
COPY --from=nebraltd/packet_forwarder:b0e1c24414e1564a1d01328b2109e1accb181f97 "$SX1301_PACKET_FORWARDER_OUTPUT_DIR" "$SX1301_DIR"
# hadolint ignore=DL3022
COPY --from=nebraltd/sx1302_hal:9a72ce59c22b0434bdbaf9091542a7d8419bddee "$SX1302_HAL_OUTPUT_DIR" "$SX1302_DIR"

COPY --from=pktfwd-builder "$PKTFWD_BUILDER_OUTPUT_DIR" "$PYTHON_DEPENDENCIES_DIR"

ENV PYTHONPATH="${PYTHONPATH}:${PYTHON_DEPENDENCIES_DIR}"

ENTRYPOINT ["python3", "pktfwd"]
