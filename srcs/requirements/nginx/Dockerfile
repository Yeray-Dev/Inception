FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


##  COPY .conf /etc/mysql/mariadb.conf.d/.cnf // SI ES NECESARIO
COPY nginx.sh /nginx.sh
RUN chmod +x /nginx.sh


CMD ["/nginx.sh"]
