#!/usr/bin/env bash

set -euo pipefail

echo ""
echo "********************"
echo "* LDAP Check"
echo "* More details on https://admin.seatable.com/configuration/authentication/ldap/"
echo "********************"

# Set the file path variable for dtable_web_settings.py
SETTINGS_FILE="/opt/seatable-server/seatable/conf/dtable_web_settings.py"
LIMIT_LDAP_ENTRIES=3

# Check if the settings file exists
if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Error: Settings file '$SETTINGS_FILE' not found."
  exit 1
fi

# Check if ldapsearch is available
if ! command -v ldapsearch &> /dev/null; then
  echo "Error: ldapsearch not found. Please install on debian based distributions with: sudo apt install ldap-utils"
  exit 1
fi

# Function to extract and clean variable from the Python file
extract_var() {
  local var_name=$1
  local raw_value=$(grep "^$var_name" "$SETTINGS_FILE" | sed -E "s/^$var_name\s*=\s*(.*)/\1/")
  # Remove surrounding single or double quotes if any
  raw_value="${raw_value#\'}"
  raw_value="${raw_value%\'}"
  raw_value="${raw_value#\"}"
  raw_value="${raw_value%\"}"
  echo "$raw_value"
}

# Extract variables from dtable_web_settings.py
# ... for LDAP Login
ENABLE_LDAP=$(extract_var ENABLE_LDAP)
LDAP_SERVER_URL=$(extract_var LDAP_SERVER_URL)
LDAP_ADMIN_DN=$(extract_var LDAP_ADMIN_DN)
LDAP_ADMIN_PASSWORD=$(extract_var LDAP_ADMIN_PASSWORD)
LDAP_BASE_DN=$(extract_var LDAP_BASE_DN)
LDAP_FILTER=$(extract_var LDAP_FILTER)
LDAP_FILTER=${LDAP_FILTER:-'(objectClass=*)'}
LDAP_PROVIDER=$(extract_var LDAP_PROVIDER)
# ... LDAP User-Creation
LDAP_LOGIN_ATTR=$(extract_var LDAP_LOGIN_ATTR)
LDAP_USER_UNIQUE_ID=$(extract_var LDAP_USER_UNIQUE_ID)
LDAP_CONTACT_EMAIL_ATTR=$(extract_var LDAP_CONTACT_EMAIL_ATTR)
LDAP_USER_FIRST_NAME_ATTR=$(extract_var LDAP_USER_FIRST_NAME_ATTR)
LDAP_USER_LAST_NAME_ATTR=$(extract_var LDAP_USER_LAST_NAME_ATTR)

# Check 0: LDAP enabled
echo ""
echo "Check 0: Is LDAP enabled?"
if [[ -z "$ENABLE_LDAP" ]]; then
  echo "Error: ENABLE_LDAP is not set or not true"
  echo "ENABLE_LDAP: $ENABLE_LDAP"
else
  echo "- LDAP is enabled in dtable_web_settings.py"
fi

# Check 1: LDAP connection
echo ""
echo "Check 1: All variables for LDAP connection available?"
if [[ -z "$LDAP_ADMIN_DN" || -z "$LDAP_ADMIN_PASSWORD" || -z "$LDAP_BASE_DN" || -z "$LDAP_SERVER_URL" ]]; then
  echo "Error: One or more required LDAP variables are not set:"
  echo "LDAP_SERVER_URL: $LDAP_SERVER_URL"
  echo "LDAP_ADMIN_DN: $LDAP_ADMIN_DN"
  echo "LDAP_ADMIN_PASSWORD: $LDAP_ADMIN_PASSWORD"
  echo "LDAP_BASE_DN: $LDAP_BASE_DN"
  exit 2
else
  echo "- all necessary parameters are set. Try this command to search your ldap."
  echo "- it will return only ${LIMIT_LDAP_ENTRIES} entries."
  # Build and display the ldapsearch command (replace placeholders)
  echo "***"
  LDAP_COMMAND="ldapsearch -H '${LDAP_SERVER_URL}' \
    -D '${LDAP_ADMIN_DN}' -w '${LDAP_ADMIN_PASSWORD}' \
    -b '${LDAP_BASE_DN}' -z '${LIMIT_LDAP_ENTRIES}' -s sub '${LDAP_FILTER}' \
    ${LDAP_LOGIN_ATTR} ${LDAP_USER_UNIQUE_ID} ${LDAP_CONTACT_EMAIL_ATTR} ${LDAP_USER_FIRST_NAME_ATTR} ${LDAP_USER_LAST_NAME_ATTR}"
  echo "$LDAP_COMMAND"
  echo "***"
fi

# Show Mapping table
echo ""
echo "Here is your mapping of LDAP attributes:"
echo "Login             (LDAP_LOGIN_ATTR):           ${LDAP_LOGIN_ATTR}"
echo "Unique Identifier (LDAP_USER_UNIQUE_ID):       ${LDAP_USER_UNIQUE_ID}"
echo "Contact e-mail    (LDAP_CONTACT_EMAIL_ATTR):   ${LDAP_CONTACT_EMAIL_ATTR}"
echo "Surname           (LDAP_USER_FIRST_NAME_ATTR): ${LDAP_USER_FIRST_NAME_ATTR}"
echo "Lastname          (LDAP_USER_LAST_NAME_ATTR):  ${LDAP_USER_LAST_NAME_ATTR}"

echo ""

exit 0