#!/bin/bash
echo "Starting start-gatewayrs.sh"

echo "Setting REGION_OVERRIDE"
if [[ -v REGION_OVERRIDE ]]
then
  echo "REGION_OVERRIDE is set to ${REGION_OVERRIDE}"
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

echo "Using file-based keypair"

# Write only overrides to settings.toml - default.toml handles the rest
cat > /etc/helium_gateway/settings.toml << EOF
keypair = "/var/data/gateway_key.bin"
region = "${REGION_OVERRIDE}"
listen = "0.0.0.0:1680"
EOF

echo "=== settings.toml contents ==="
cat /etc/helium_gateway/settings.toml
echo "=============================="

echo "Calling helium_gateway server ..."
/usr/bin/helium_gateway server &

sleep 5
echo "Checking key info..."
if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway key info)
then
  echo "Can't get miner key info"
else
  echo "$PUBLIC_KEYS" > /var/data/key_json
  cat /var/data/key_json
fi

wait
