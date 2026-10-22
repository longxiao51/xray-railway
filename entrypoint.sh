#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:-}"
WS_PATH="${WS_PATH:-/xray-ws}"
if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
  echo "Generated UUID: $UUID"
fi
mkdir -p /etc/xray
cat > /etc/xray/config.json << JSON
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
JSON
echo "Xray listening on port ${PORT}, ws path ${WS_PATH}"
exec /usr/local/bin/xray run -c /etc/xray/config.json
