#!/usr/bin/env bash

set -euo pipefail

docker exec -it mariadb bash -c 'mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}"'
