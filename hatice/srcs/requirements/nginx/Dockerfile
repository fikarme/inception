FROM debian:bullseye

RUN apt -y update && apt install -y nginx && apt install openssl -y

COPY ./conf/hozkaya.conf /etc/nginx/sites-enabled/

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/ssl.key \
    -out /etc/ssl/certs/ssl.crt \
    -subj "/C=TR/ST=ISTANBUL/L=SARIYER/O=42/CN=hozkaya.42.fr"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]