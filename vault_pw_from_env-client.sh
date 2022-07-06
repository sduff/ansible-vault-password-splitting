#!/bin/bash

# Get a vault password from an environment variable and send it to STDOUT
# If the environment variable doesn't exisit, return code is 1
#
# Run as
# ./vault_pw_from_env.sh --vault-id vault-name

# Set a prefix for environment namne vars
PREFIX="VAULT_PW_"

VAULT_ID=$2
VAULT_ID=$(echo "$VAULT_ID" | awk -F '/' '{print $NF}')
ENV_VAR_NAME="${PREFIX}${VAULT_ID}"

#echo $@ >> log.txt
#echo "ENV_VAR_NAME: ${ENV_VAR_NAME} ENV_VAR_VALUE: ${!ENV_VAR_NAME}" >> log.txt

if [[ -z ${!ENV_VAR_NAME} ]]; then
  exit 1
fi

echo "${!ENV_VAR_NAME}"
exit 0
