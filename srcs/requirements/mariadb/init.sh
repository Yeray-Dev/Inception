#!/bin/bash

#DECLARAMOS VARIABLES DESDE SECRETS
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

#SI LA BBDD NO EXISTE LA CREAMOS
if [ ! -d /var/lib/mysql/mysql ]; then
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
# LANZAMOS EL PROCESO EN SEGUNDO PLANO
mariadbd --user=mysql &

# INTENTAMOS CONECTAR CON MARIADB, USAMOS UN CONTADOR, SI EN 30 INTENTOS NO SE CONSIGUE CONTACTAR TERMINAMOS EL PROCESO
RETRIES=30
until mysql -u root -e "SELECT 1;" 2>/dev/null || [ $RETRIES -eq 0 ]; do
  sleep 1
  RETRIES=$((RETRIES - 1))
done

if [ $RETRIES -eq 0 ]; then
  echo "MariaDB is down"
  exit 1
fi

# CON LA BBDD LEVANTADA CREAMOS LAS TABLAS Y USUARIOS SINO EXISTIERAN
mysql -u root <<EOF
  CREATE DATABASE IF NOT EXISTS $DB_NAME;
  CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
  GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
  FLUSH PRIVILEGES;
  ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
EOF

# CUANDO EL SCRIPT ACABE TIENE QUE PASAR MARIADB AL PID 1
# PARA ELLO PRIMERO TERMINAR CON EL PROCESO QUE OCUPA EL PUETO 3306 Y LUEGO LO LEVANTA COMO PID1
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
exec mariadbd --user=mysql
