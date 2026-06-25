#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
RESET_COLOR='\033[0m'

NOW=$(date +"%Y-%m-%d-%H-%M-%S")
CONFIG_DIRECTORY="/opt/seatable-server/seatable/conf"
BACKUP_DIRECTORY="/opt/seatable-server/seatable/conf-${NOW}.bak"

declare -A DEPRECATED_CONFIG_FILES=(
    ["${CONFIG_DIRECTORY}/dtable-api-gateway.conf"]="https://admin.seatable.com/configuration/components/dtable-api-gateway/"
    ["${CONFIG_DIRECTORY}/dtable-db.conf"]="https://admin.seatable.com/configuration/components/dtable-db/"
    ["${CONFIG_DIRECTORY}/dtable-events.conf"]="https://admin.seatable.com/configuration/components/dtable-events/"
    ["${CONFIG_DIRECTORY}/dtable-storage-server.conf"]="https://admin.seatable.com/configuration/components/dtable-storage-server/"
    ["${CONFIG_DIRECTORY}/dtable_server_config.json"]="https://admin.seatable.com/configuration/components/dtable-server/"
)

DTABLE_STORAGE_SERVER_CONF="${CONFIG_DIRECTORY}/dtable-storage-server.conf"
DTABLE_WEB_SETTINGS="${CONFIG_DIRECTORY}/dtable_web_settings.py"
SEAFILE_CONF="${CONFIG_DIRECTORY}/seafile.conf"
ENV_FILE="/opt/seatable-compose/.env"

echo -e "Backing up ${CONFIG_DIRECTORY} to ${BACKUP_DIRECTORY}\n"
cp -R "${CONFIG_DIRECTORY}" "${BACKUP_DIRECTORY}"

echo "Extracting SECRET_KEY from dtable_web_settings.py..."
SECRET_KEY=$(awk -F"'" '/^SECRET_KEY/ {print $2}' "$DTABLE_WEB_SETTINGS")
if [ -n "${SECRET_KEY}" ]; then
    echo "Adding SECRET_KEY to .env..."

    echo '' >> "${ENV_FILE}"
    echo '# SeaTable v6.2' >> "${ENV_FILE}"
    echo "SECRET_KEY='${SECRET_KEY}'" >> "${ENV_FILE}"
fi

echo -e "Removing SECRET_KEY from dtable_web_settings.py...\n"
sed -i '/SECRET_KEY.*/d' "${DTABLE_WEB_SETTINGS}"

echo -e "Removing unused variables from dtable_web_settings.py...\n"
sed -i '/IS_PRO_VERSION = True.*/d' "${DTABLE_WEB_SETTINGS}"
sed -i '/NEW_DTABLE_IN_STORAGE_SERVER.*/d' "${DTABLE_WEB_SETTINGS}"
sed -i '/ENABLE_USER_TO_SET_NUMBER_SEPARATOR.*/d' "${DTABLE_WEB_SETTINGS}"
sed -i '/DISABLE_ADDRESSBOOK_V1.*/d' "${DTABLE_WEB_SETTINGS}"
sed -i '/ENABLE_ADDRESSBOOK_V2 = True.*/d' "${DTABLE_WEB_SETTINGS}"

if grep -q "EMAIL_HOST" "${DTABLE_WEB_SETTINGS}"; then
    echo -e "${RED}[Deprecated]${RESET_COLOR} Detected email settings inside $(basename ${DTABLE_WEB_SETTINGS})"
    echo -e "Please migrate your email configuration to environment variables!"
    echo -e "-> https://admin.seatable.com/configuration/sending-email/#configuration\n"
fi

if grep -q "TEMPLATE_BASE_API_TOKEN" "${DTABLE_WEB_SETTINGS}"; then
    echo -e "${RED}[Deprecated]${RESET_COLOR} Detected template base configuration inside $(basename ${DTABLE_WEB_SETTINGS})"
    echo -e "Please migrate the template base configuration to environment variables!"
    echo -e "-> https://admin.seatable.com/customization/templates/#activate-templates-in-seatable\n"
fi

if grep -q "^SEATABLE_AI_LLM_TYPE" "${ENV_FILE}"; then
    echo -e "${RED}[Deprecated]${RESET_COLOR} Detected AI configuration inside $(basename ${ENV_FILE})"
    echo -e "Please migrate your AI configuration to the new seatable_config.yaml file!"
    echo -e "-> https://admin.seatable.com/installation/components/seatable-ai/#llm-provider-configuration\n"
fi

if [ -f "${DTABLE_STORAGE_SERVER_CONF}" ] && grep -q "type = s3" "${DTABLE_STORAGE_SERVER_CONF}"; then
    echo -e "${RED}[Deprecated]${RESET_COLOR} Detected S3 config inside $(basename ${DTABLE_STORAGE_SERVER_CONF})"
    echo -e "Please migrate your S3 configuration to environment variables!"
    echo -e "-> https://admin.seatable.com/installation/advanced/s3/#environment-variables\n"
fi

if grep -q "bucket" "${SEAFILE_CONF}"; then
    echo -e "${RED}[Deprecated]${RESET_COLOR} Detected S3 config inside $(basename ${SEAFILE_CONF})"
    echo -e "Please migrate your S3 configuration to environment variables!"
    echo -e "-> https://admin.seatable.com/installation/advanced/s3/#environment-variables\n"
fi

for file in "${!DEPRECATED_CONFIG_FILES[@]}"; do
    if [ -f "${file}" ]; then
        echo -e "${RED}[Deprecated]${RESET_COLOR} Detected $(basename "${file}") config file"
        echo -e "Please migrate these configuration settings to environment variables and remove $(basename "${file}")"
        echo -e "-> ${DEPRECATED_CONFIG_FILES[$file]}\n"
    fi
done
