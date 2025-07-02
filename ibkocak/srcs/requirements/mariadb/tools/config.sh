#!/bin/bash
set -euo pipefail
log_info() { echo "[INFO] $(date "+%Y-%m-%d %H:%M:%S") - $1"; }
log_error() { echo "[ERROR] $(date "+%Y-%m-%d %H:%M:%S") - $1" >&2; exit 1; }
log_info "Reading secrets..."
for secret in db_root_password db_password; do
    [ -f "/run/secrets/$secret" ] || log_error "Secret file /run/secrets/$secret not found!"
    value=$(cat "/run/secrets/$secret")
    [ -z "$value" ] && log_error "Secret $secret is empty!"
done
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
export MYSQL_USER=${MYSQL_USER:-wpuser}
if [ ! -d "/var/lib/mysql/mysql" ]; then
    log_info "MariaDB directory not found. Initializing..."
    mysqld --initialize-insecure --user=mysql || log_error "Failed to initialize MariaDB database!"
fi
log_info "Starting MariaDB in the background..."
mysqld --user=mysql &
PID=$!
log_info "Waiting for MariaDB to be ready..."
timeout 30 bash -c 'until mysqladmin ping --silent; do sleep 1; done' || log_error "MariaDB failed to start within 30 seconds!"
log_info "Setting root password..."
cat <<EOF > /root/.my.cnf
[client]
user=root
password=${MYSQL_ROOT_PASSWORD}
EOF
chmod 600 /root/.my.cnf
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" || log_error "Failed to set root password!"
log_info "Preparing init SQL file..."
if [ -f "/tmp/set.sql" ]; then
    envsubst < /tmp/set.sql > /docker-entrypoint-initdb.d/init.sql
    [ -s /docker-entrypoint-initdb.d/init.sql ] || log_error "Generated init.sql is empty!"
else
    log_error "set.sql file not found!"
fi
log_info "Executing init SQL file..."
mysql -e "SOURCE /docker-entrypoint-initdb.d/init.sql" || log_error "Failed to execute init.sql!"
log_info "Cleaning up..."
rm -f /root/.my.cnf /docker-entrypoint-initdb.d/init.sql
log_info "Setup completed. Waiting for mysqld process..."
wait "$PID"
