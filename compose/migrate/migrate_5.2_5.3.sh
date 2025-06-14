#!/bin/bash

set -euo pipefail

NOW=$(date +"%Y-%m-%d-%H-%M-%S")
CONFIG_DIRECTORY="/opt/seatable-server/seatable/conf"
BACKUP_DIRECTORY="/opt/seatable-server/seatable/conf-${NOW}.bak"

echo "Backing up ${CONFIG_DIRECTORY} to ${BACKUP_DIRECTORY}"
cp -R "${CONFIG_DIRECTORY}" "${BACKUP_DIRECTORY}"

private_key=$(grep -oP '"private_key"\s*:\s*"\K[^"]+' "${CONFIG_DIRECTORY}/dtable_server_config.json")
if [ -n "$private_key" ]; then
    echo "I attach your private key to your .env file. Your private key is: $private_key"
    echo "JWT_PRIVATE_KEY=$private_key" >> /opt/seatable-compose/.env
fi 

echo "Removing private key from dtable_server_config.json and dtable_web_settings.py"
sed -i '/private_key.*/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/DTABLE_PRIVATE_KEY.*/d' "${CONFIG_DIRECTORY}/dtable_web_settings.py"

echo "Cleaning up dtable_server_config.json"
sed -i 's/SEATABLE_MYSQL_ROOT_PASSWORD=/MARIADB_PASSWORD=/' /opt/seatable-compose/.env
sed -i '/"host":/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/"user":/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/"password":/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/"database":/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/"port":/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"
sed -i '/redis_/d' "${CONFIG_DIRECTORY}/dtable_server_config.json"

echo "Removing ccnet.conf"
rm -f "${CONFIG_DIRECTORY}/ccnet.conf"

echo 'Removing [REDIS] section from dtable-events.conf'
awk '
/^\[REDIS\]/ {skip=1; next}
/^\[/ {skip=0}
!skip
' "${CONFIG_DIRECTORY}/dtable-events.conf" > /tmp/dtable-events.conf
mv /tmp/dtable-events.conf "${CONFIG_DIRECTORY}/dtable-events.conf"

echo 'Removing [DATABASE] section from dtable-events.conf'
awk '
/^\[DATABASE\]/ {skip=1; next}
/^\[/ {skip=0}
!skip
' "${CONFIG_DIRECTORY}/dtable-events.conf" > /tmp/dtable-events.conf
mv /tmp/dtable-events.conf "${CONFIG_DIRECTORY}/dtable-events.conf"

echo "Removing DATABASES from dtable_web_settings.py"
sed -i '/^DATABASES = {/,/^}/d' "${CONFIG_DIRECTORY}/dtable_web_settings.py"

echo "Removing CACHES from dtable_web_settings.py"
sed -i '/^CACHES = {/,/^}/d' "${CONFIG_DIRECTORY}/dtable_web_settings.py"

echo "Generating REDIS_PASSWORD using pwgen"
REDIS_PASSWORD=$(pwgen 32 1)
echo "Adding REDIS_PASSWORD to /opt/seatable-compose/.env"
echo "REDIS_PASSWORD=${REDIS_PASSWORD}" >> /opt/seatable-compose/.env

echo "Done!"
echo "Please verify your configuration files."
echo "You can use \"diff --unified --color ${BACKUP_DIRECTORY} ${CONFIG_DIRECTORY}\" to compare both directories."
