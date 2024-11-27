#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIRECTORY=/opt/seatable-backup

mkdir -p "${BACKUP_DIRECTORY}"

# TODO: Update commands on admin.seatable.io: mysqldump -> mariadb-dump
# TODO: Add timestamp to filenames?

docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt ccnet_db' > "${BACKUP_DIRECTORY}/ccnet_db.sql"
docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt dtable_db' > "${BACKUP_DIRECTORY}/dtable_db.sql"
docker exec mariadb bash -c 'mariadb-dump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt seafile_db' > "${BACKUP_DIRECTORY}/seafile_db.sql"

echo "Success: Dumped databases into ${BACKUP_DIRECTORY}"
