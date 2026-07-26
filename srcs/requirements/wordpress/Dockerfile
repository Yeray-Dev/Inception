FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysql \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        curl \
        php-zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

##  COPY .conf /etc/mysql/mariadb.conf.d/.cnf // SI ES NECESARIO
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh


CMD ["/setup.sh"]
