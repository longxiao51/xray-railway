FROM alpine:3.20
RUN apk add --no-cache curl unzip ca-certificates \
 && curl -sL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && unzip -o /tmp/xray.zip -d /usr/local/bin/ xray \
 && chmod +x /usr/local/bin/xray \
 && rm /tmp/xray.zip \
 && apk del curl unzip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
