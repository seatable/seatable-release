#!/usr/bin/env bash

set -euo pipefail

echo "Checking dtable-web..."

docker exec -it seatable-server /templates/seatable.sh python-env /opt/seatable/seatable-server-latest/dtable-web/manage.py check
