FROM nginx:alpine

RUN apk add --no-cache \
    bash \
    curl \
    tzdata

# instala websocat (binário oficial leve)
RUN wget -O /usr/local/bin/websocat \
    https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl \
    && chmod +x /usr/local/bin/websocat

ENV TZ=America/Sao_Paulo

COPY entrypoint.sh /entrypoint.sh
COPY index.html /usr/share/nginx/html/index.html

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
