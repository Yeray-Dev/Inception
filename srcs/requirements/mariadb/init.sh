#!/bin/bash

# DECLARAMOS VARIABLES DESDE SECRETS
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# CREAMOS LAS CARPETAS Y DAMOS PERMISOS
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# SI LA BBDD NO EXISTE LA CREAMOS
if [ ! -d /var/lib/mysql/mysql ]; then
  mysql_install_db --user=mysql --datadir=/var/lib/mysql

# LANZAMOS EL PROCESO EN SEGUNDO PLANO
mariadbd --user=mysql &
MARIADB_PID=$!

# INTENTAMOS CONECTAR CON MARIADB, USAMOS UN CONTADOR.
RETRIES=30
while ! mysqladmin ping -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" --silent 2>/dev/null; do
  RETRIES=$((RETRIES - 1))
  if [ "$RETRIES" -le 0 ]; then
    echo "MariaDB is down"
    exit 1
  fi
  sleep 1
done

# CON LA BBDD LEVANTADA CREAMOS LAS TABLAS Y USUARIOS SINO EXISTIERAN
  mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
EOF

  mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
  wait "$MARIADB_PID"
fi

# CUANDO EL SCRIPT ACABE TIENE QUE PASAR MARIADB AL PID 1
exec mariadbd --user=mysql --bind-address=0.0.0.0
