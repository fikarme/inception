FROM debian:bullseye

RUN apt-get update && apt-get install -y \
        gettext \
        mariadb-client \
        mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql /run/mysqld

COPY conf/server.cnf /etc/mysql/mariadb.conf.d/server.cnf
COPY conf/set.sql /tmp/set.sql
COPY tools/config.sh /usr/local/bin/config.sh

RUN chmod +x /usr/local/bin/config.sh

EXPOSE 3306

CMD ["/usr/local/bin/config.sh"]
