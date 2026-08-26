FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php8.2-cli \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        curl \
        mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY setup.sh /setup.sh
COPY ./www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN chmod +x /setup.sh


CMD ["/setup.sh"]
