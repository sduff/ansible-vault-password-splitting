# Demonstration of password splitting in Ansible Vault
# Simon Duff

This repo illustrates how to do password splitting in Ansible Vault. 2 vault
files can be created by separate parties, which can then be checked into a repo
or placed on a host. When the ansible playbook is run, it can access multiple
vaults and combine fragments of each secret into a single secret for each
variable.

The benefit of this approach is that the full password is not exposed to a
single individual at any one time.



### `group_vars/alpha/vars.yml`

```
---
admin_password: "{{ vault_admin_password_part_1 }}{{ vault_admin_password_part_2 }}"
```


### `group_vars/alpha/vault1.yml` unencrypted

```
---
vault_admin_password_part_1: "white"
```

### `group_vars/alpha/vault2.yml` unencrypted

```
---
vault_admin_password_part_2: "apple"
```

## `vault_pw_from_env-client.sh`

This is a sample of how to provide vault passwords to ansible without
prompting. Assuming the passwords are stored in Environment variables, this
script will pass those passwords to the script as required.

It assumes that Environment variables begin with a given prefix, for example,
`PREFIX="VAULT_PW_"` and a vault-id of `vault1`, the expected Environment
variable would be `VAULT_PW_vault1=mysecretpassword`.

```
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
```

*N.B.* This script's filename must end with `-client` for it to work correctly.

*N.B.* You really shouldn't use this in production. You should really be using something more Enterprise-y like Hashicorp Vault.

# Process

## Encrypt YAML files

```
#!/bin/bash

ansible-vault encrypt --vault-id vault1@./vault_pw_from_env-client.sh vault1.yml
ansible-vault encrypt --vault-id vault2@./vault_pw_from_env-client.sh vault2.yml
```

## Run Ansible to acess vaults

```
#!/bin/bash

set -v

ansible alpha -m debug -a "var=admin_password" \
   --vault-id group_vars/alpha/vault1@./vault_pw_from_env-client.sh \
   --vault-id group_vars/alpha/vault2@./vault_pw_from_env-client.sh
```


