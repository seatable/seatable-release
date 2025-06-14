#!/usr/bin/env bash

set -euo pipefail

EMAIL=${1:-}

if [ -z "${EMAIL}" ]; then
    echo "ERROR: Email address must be provided"
    echo "USAGE: ${0} <EMAIL>"
    exit 1
fi

source /opt/seatable-compose/.env

QUERY="UPDATE ccnet_db.EmailUser SET is_active = 1 WHERE email = (SELECT user FROM dtable_db.profile_profile WHERE contact_email = '${EMAIL}');"

# -vv for verbose output (matched/changed rows)
docker exec -it mariadb mariadb -uroot -p"${MARIADB_PASSWORD}" -vv -e "${QUERY}"

echo "Success: Activated user ${EMAIL}"
