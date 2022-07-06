#!/bin/bash

set -v

export VAULT_PW_vault1=abc123
export VAULT_PW_vault2=def456

ansible alpha -m debug -a "var=admin_password" \
   --vault-id group_vars/alpha/vault1@./vault_pw_from_env-client.sh \
   --vault-id group_vars/alpha/vault2@./vault_pw_from_env-client.sh

