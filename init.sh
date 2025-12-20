#!/bin/bash

mkdir gitlab
mkdir gitlab/config
mkdir gitlab/data
mkdir gitlab/logs
mkdir gitlab/ssl
mkdir gitlab/trusted_certs

HOSTNAME=$(ls -d /etc/letsencrypt/live/*/ | xargs -n1 basename) # Gathering hostname from letsencrypt certs

cp /etc/letsencrypt/live/${HOSTNAME}/fullchain.pem ./gitlab/ssl/${HOSTNAME}.crt
cp /etc/letsencrypt/live/${HOSTNAME}/privkey.pem ./gitlab/ssl/${HOSTNAME}.key
cp /usr/local/share/ca-certificates/*.crt ./gitlab/trusted-certs/

export VAULT_ADDR=https://$1
export VAULT_TOKEN=$2

ENV_FILE="secrets.env"

S3_ACCESS_KEY=$(vault kv get -field=access_key kv/s3/gitlab)
S3_SECRET_KEY=$(vault kv get -field=secret_key kv/s3/gitlab)
INITIAL_ROOT_PASSWORD=$(vault kv get -field=root_password kv/gitlab)
DB_PASSWORD=$(vault kv get -field=gitlab_user kv/postgresql/users)
BIND_PASSWORD=$(vault kv get -field=ldap_bind_password kv/authentik)

cat > "$ENV_FILE" <<EOF
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
INITIAL_ROOT_PASSWORD=${INITIAL_ROOT_PASSWORD}
DB_PASSWORD=${DB_PASSWORD}
BIND_PASSWORD=${BIND_PASSWORD}
EOF

chmod 600 "$ENV_FILE"

cat secrets.env
