FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/db_init.sql /

RUN service mariadb start && mariadb < /db_init.sql && rm -f /db_init.sql;

CMD ["mysqld"]