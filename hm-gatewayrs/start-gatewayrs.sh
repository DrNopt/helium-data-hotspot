#!/bin/bash
echo "Starting start-gatewayrs.sh"

echo "=== default.toml contents ==="
cat /etc/helium_gateway/default.toml
echo "=============================="

rm -f /etc/helium_gateway/settings.toml

echo "Setting REGION_OVERRIDE"
if [[ -v REGION_OVERRIDE ]]
then
  echo "REGION_OVERRIDE is set to ${REGION_OVERRIDE}"
  echo 'region = "'"${REGION_OVERRIDE}\"" >> /etc/helium_gateway/settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

echo "Using file-based keypair"
echo 'keypair = "/var/data/gateway_key.bin"' >> /etc/helium_gateway/settings.toml

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
