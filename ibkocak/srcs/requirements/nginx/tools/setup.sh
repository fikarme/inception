#!/bin/bash
set -euo pipefail
log_info() { echo -e "\033[32m[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m"; }
log_error() { echo -e "\033[31m[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m" >&2; exit 1; }
: "${DOMAIN_NAME:?DOMAIN_NAME is required in .env file}"
log_info "Creating SSL directory: /etc/nginx/ssl"
mkdir -p /etc/nginx/ssl || log_error "Failed to create SSL directory"
chmod 755 /etc/nginx/ssl
if [[ ! -f /etc/nginx/ssl/nginx.crt || ! -f /etc/nginx/ssl/nginx.key ]]; then
    log_info "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=TR/ST=ISTANBUL/L=ESENLER/O=42Istanbul/CN=${DOMAIN_NAME}" || log_error "Failed to generate SSL certificate"
    chmod 600 /etc/nginx/ssl/nginx.key
    chmod 644 /etc/nginx/ssl/nginx.crt
    log_info "SSL certificate generated."
fi
log_info "Generating Nginx configuration..."
cat > /etc/nginx/conf.d/default.conf <<EOL
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ${DOMAIN_NAME};
    server_tokens off;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    root /var/www/html;
    index index.php index.html index.htm;
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
    location ~ /\.ht {
        deny all;
    }
    error_log /var/log/nginx/error.log info;
    access_log /var/log/nginx/access.log;
}
EOL
log_info "Testing Nginx configuration..."
nginx -t || log_error "Nginx configuration test failed!"
log_info "Starting NGINX service..."
exec "$@"
