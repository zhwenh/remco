#!/bin/bash
set -e
ROOT_TOKEN=$(vault read -field id auth/token/lookup-self)
sed -i -- "s/§§token§§/${ROOT_TOKEN}/g" integration/vault/vault.toml


vault mount -path database generic
vault mount -path upstream generic

vault write database/host value=127.0.0.1
vault write database/port value=3306
vault write database/username value=remco
vault write database/password value=p@sSw0rd
vault write upstream/app1 value=10.0.1.10:8080
vault write upstream/app2 value=10.0.1.11:8080

remco --config integration/vault/vault.toml
cat /tmp/remco-basic-test.conf
