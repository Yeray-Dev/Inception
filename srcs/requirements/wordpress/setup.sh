#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)


RETRIES=30
until mysqladmin ping -h mariadb -u $DB_USER -p"$DB_PASSWORD" 2>/dev/null || [ $RETRIES -eq 0 ]; do
  sleep 1
  RETRIES=$((RETRIES - 1))
done
if [ $RETRIES -eq 0 ]; then
  echo "MariaDB is down"
  exit 1
fi

if [ ! -f /var/www/html/wp-login.php ]; then
  wp core download --path=/var/www/html --allow-root
fi

if [ ! -f /var/www/html/wp-config.php ]; then
  wp config create --path=/var/www/html --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb --allow-root
fi
if ! wp core is-installed --path=/var/www/html --allow-root; then
  wp core install --path=/var/www/html --url=https://$DOMAIN_NAME --title=Inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

  wp user create $WP_USER $WP_USER_EMAIL --role=author \
    --user_pass=$WP_USER_PASSWORD --path=/var/www/html --allow-root
fi

chown -R www-data:www-data /var/www/html
exec php-fpm8.2 -F
