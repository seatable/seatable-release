#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIRECTORY=/opt/seatable-backup

mkdir -p "${BACKUP_DIRECTORY}"

TIME=$(date +%Y-%m-%d-%H-%M-%S)

docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt ccnet_db' > "${BACKUP_DIRECTORY}/ccnet_db-${TIME}.sql"
docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt dtable_db' > "${BACKUP_DIRECTORY}/dtable_db-${TIME}.sql"
docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt seafile_db' > "${BACKUP_DIRECTORY}/seafile_db-${TIME}.sql"

echo "Success: Dumped databases into ${BACKUP_DIRECTORY}"
