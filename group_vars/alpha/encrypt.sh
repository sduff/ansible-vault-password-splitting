#!/bin/bash

set -v

# --- Copying plain text file to YAML
cp vault1.yml.original vault1.yml
cp vault2.yml.original vault2.yml

# --- Plain YAML files containing password portions
head -n 2 vault1.yml vault2.yml


# --- Encrypting each file
ansible-vault encrypt --vault-id vault1@../../vault_pw_from_env-client.sh vault1.yml
ansible-vault encrypt --vault-id vault2@../../vault_pw_from_env-client.sh vault2.yml

# --- YAML files are now encrypted
head -n 2 vault1.yml vault2.yml
