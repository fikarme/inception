#!/bin/bash

set -euo pipefail

log_info() { echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"; }
log_error() { echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2; exit 1; }

log_info "Reading secrets..."
for secret in wp_admin_password wp_user_password db_password; do
    [ -f "/run/secrets/$secret" ] || log_error "Secret file /run/secrets/$secret not found!"
done

export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_password)

[ -z "$WP_ADMIN_PASSWORD" ] && log_error "WP_ADMIN_PASSWORD is empty!"
[ -z "$WP_USER_PASSWORD" ] && log_error "WP_USER_PASSWORD is empty!"
[ -z "$MYSQL_PASSWORD" ] && log_error "MYSQL_PASSWORD is empty!"

: "${MYSQL_USER:=wpuser}"
: "${MYSQL_DATABASE:=wordpress}"
: "${MYSQL_HOSTNAME:=mariadb}"
: "${DOMAIN_NAME:=ibkocak.42.fr}"
: "${WP_TITLE:=INCEPTION BLOG}"
: "${WP_ADMIN_USER:=ibkocak}"
: "${WP_ADMIN_EMAIL:=ibkocak@student.42istanbul.com.tr}"
: "${WP_USER_NAME:=phintest}"
: "${WP_USER_EMAIL:=phintest@gmail.com}"

command -v wp >/dev/null 2>&1 || log_error "WP-CLI is not installed!"

cd /var/www/html || log_error "Cannot change to /var/www/html!"

if [[ ! -f wp-config.php ]]; then
    log_info "Downloading WordPress..."
    wget -q https://wordpress.org/latest.tar.gz || log_error "Failed to download WordPress."

    log_info "Extracting WordPress..."
    tar xfz latest.tar.gz && mv wordpress/* . && rm -rf latest.tar.gz wordpress || log_error "Failed to extract WordPress."

    log_info "Configuring wp-config.php..."
    [ -f wp-config-sample.php ] || log_error "wp-config-sample.php not found!"
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config.php
    [ -s wp-config.php ] || log_error "Failed to create wp-config.php!"
    log_info "wp-config.php generated successfully."
fi

log_info "Waiting for MariaDB to be ready..."
timeout 60 bash -c "until mysqladmin ping -h ${MYSQL_HOSTNAME} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do sleep 1; done" || log_error "MariaDB failed to start within 60 seconds!"

if ! wp core is-installed --allow-root --path=/var/www/html 2>/dev/null; then
    log_info "Installing WordPress core..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root \
        --path=/var/www/html || log_error "WordPress installation failed."

    log_info "Creating WordPress user..."
    if ! wp user get "${WP_USER_NAME}" --allow-root --path=/var/www/html >/dev/null 2>&1; then
        wp user create "${WP_USER_NAME}" "${WP_USER_EMAIL}" \
            --user_url="https://${DOMAIN_NAME}" \
	    --role=author \
            --user_pass="${WP_USER_PASSWORD}" \
            --allow-root \
            --path=/var/www/html || log_error "Failed to create WordPress user."
    else
        log_info "User ${WP_USER_NAME} already exists, skipping creation."
    fi
else
    log_info "WordPress is already installed, skipping installation."
fi

log_info "Fixing file permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

log_info "Starting PHP-FPM..."

exec "$@"
