

# I assume, that 
# - /opt/seatable-compose/.env is mounted to /tmp/.env
# - /opt/seatable-server/seatable/conf is mounted to /tmp/conf/

# JWT_PRIVATE_KEY
# TODO: add JWT_PRIVATE_KEY only, if not empty...
private_key=$(grep -oP '"private_key"\s*:\s*"\K[^"]+' /tmp/conf/dtable_server_config.json)
if [ -n "$private_key" ]; then
    echo "I attach your private key to your .env file. Your private key is: $private_key"
    echo "JWT_PRIVATE_KEY=$private_key" >> /tmp/.env
fi 
sed -i '/private_key.*/d' /tmp/conf/dtable_server_config.json
sed -i '/DTABLE_PRIVATE_KEY.*/d' /tmp/conf/dtable_web_settings.py

# MARIADB (dtable_server_config.json)
sed -i 's/SEATABLE_MYSQL_ROOT_PASSWORD=/MARIADB_PASSWORD=/' /tmp/.env
sed -i '/"host":/d' /tmp/conf/dtable_server_config.json
sed -i '/"user":/d' /tmp/conf/dtable_server_config.json
sed -i '/"password":/d' /tmp/conf/dtable_server_config.json
sed -i '/"database":/d' /tmp/conf/dtable_server_config.json
sed -i '/"port":/d' /tmp/conf/dtable_server_config.json

# REDIS (dtable_server_config.json)
sed -i '/redis_/d' /tmp/conf/dtable_server_config.json

# ccnet.conf
rm -f /tmp/conf/ccnet.conf

# [REDIS] from dtable-events.conf
awk '
/^\[REDIS\]/ {skip=1; next}
/^\[/ {skip=0}
!skip
' /tmp/conf/dtable-events.conf > /tmp/conf/dtable-events.conf

# [DATABASE] from dtable-events.conf
awk '
/^\[DATABASE\]/ {skip=1; next}
/^\[/ {skip=0}
!skip
' /tmp/conf/dtable-events.conf > /tmp/conf/dtable-events.conf

# REMOVE from dtable_web_settings.py
awk '
/^(DATABASES|CACHES)[[:space:]]*=/ {inblock=1; brace=0}
inblock {
    brace += gsub(/\{/, "{")
    brace -= gsub(/\}/, "}")
    if (brace == 0) {inblock=0}
    next
}
{print}
' /tmp/conf/dtable_web_settings.py > /tmp/conf/dtable_web_settings.py

# backup copy of nginx.conf and then recreate it
# ...
