FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY server.conf /etc/mysql/mariadb.conf.d/server.cnf
COPY init.sh /init.sh
RUN chmod +x /init.sh


CMD ["/init.sh"]
