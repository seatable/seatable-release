#!/usr/bin/env bash

set -euo pipefail

source /opt/seatable-compose/.env

LICENSE_FILE="/opt/seatable-compose/seatable-license.txt"
LICENSE_FILE="seatable-license.txt"

USER_LIMIT=$(grep -Po '(?<=MaxUsers = \")(\d+)' ${LICENSE_FILE})
echo "User limit according to license file: ${USER_LIMIT}"

QUERY="SELECT COUNT(*) AS users, (SELECT COUNT(*) FROM ccnet_db.EmailUser WHERE is_active = 1) AS active_users FROM ccnet_db.EmailUser;"

echo -e "\nUsers in database:"
docker exec -it mariadb mariadb -uroot -p"${MARIADB_PASSWORD}" -e "${QUERY}"
