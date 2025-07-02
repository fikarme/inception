FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        iputils-ping \
        nginx \
        openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /var/log/nginx && \
    chown -R www-data:www-data /var/log/nginx /etc/nginx/ssl && \
    chmod -R 755 /var/log/nginx /etc/nginx/ssl && \
    rm -f /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

COPY ./tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
