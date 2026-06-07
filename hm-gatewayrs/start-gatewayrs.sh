#!/bin/bash
echo "Starting start-gatewayrs.sh"
rm -f settings.toml
rm -f /etc/helium_gateway/settings.toml

echo "Setting REGION_OVERRIDE"
if [[ -v REGION_OVERRIDE ]]
then
  echo "REGION_OVERRIDE is set to ${REGION_OVERRIDE}"
  echo 'region = "'"${REGION_OVERRIDE}\"" >> settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

# Always use file-based keypair for gateway-rs v1.3.0+
echo "Using file-based keypair"
echo 'keypair = "/var/data/gateway_key.bin"' >> settings.toml

cat /etc/helium_gateway/settings.toml.template >> settings.toml
cp settings.toml /etc/helium_gateway/settings.toml

echo "=== settings.toml contents ==="
cat /etc/helium_gateway/settings.toml
echo "=============================="

echo "Calling helium_gateway server ..."
/usr/bin/helium_gateway -c /etc/helium_gateway server &

sleep 5
echo "Checking key info..."
if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info)
then
  echo "Can't get miner key info"
else
  echo "$PUBLIC_KEYS" > /var/data/key_json
  cat /var/data/key_json
fi

wait
