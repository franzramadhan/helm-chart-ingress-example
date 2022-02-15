# /usr/bin/env bash

db_port="3306"
db_name=$(pwgen -0 -A 8 1)
table_name=$(pwgen -0 -A 16 1)
db_user=$(pwgen -0 -A 8 1 | base64)
db_password=$(pwgen -sB 32 1 | base64)
mysql_root_password=$(pwgen -sB 64 1 | base64)

## generate configmap
cat <<EOF | kubectl apply -f -
kind: ConfigMap 
apiVersion: v1 
metadata:
  name: app-configmap
data:
  DB_HOSTNAME: db-service
  DB_PORT: '${db_port}'
  DB_NAME: ${db_name}
  DB_TABLE_NAME: ${table_name}
---
kind: ConfigMap 
apiVersion: v1 
metadata:
  name: db-configmap
data:
  MYSQL_DATABASE: ${db_name}
  init.sql: |
    CREATE TABLE IF NOT EXISTS \`${table_name}\` (
      \`id\` int(11) NOT NULL,   
      \`uid\` varchar(36) NOT NULL,       
      \`coin_name\` varchar(16)  NOT NULL default '',     
      \`acronym\`  varchar(16)  NOT NULL default '',
      \`logo\`  text  NOT NULL,   
       PRIMARY KEY  (\`id\`)
    );

EOF

## generate secrets

kubectl create secret generic app-secrets \
  --from-literal=DB_USER=${db_user} \
  --from-literal=DB_PASSWORD=${db_password} \
  2>&1 >/dev/null &

kubectl create secret generic db-secrets \
  --from-literal=MYSQL_USER=${db_user} \
  --from-literal=MYSQL_PASSWORD=${db_password} \
  --from-literal=MYSQL_ROOT_PASSWORD=${mysql_root_password} \
  2>&1 >/dev/null &

# cat <<EOF | kubectl apply -f -
# apiVersion: v1
# kind: Secret
# metadata:
#   name: app-secrets
#   labels:
#     app: app
# type: Opaque
# data:
#   DB_USER: ${db_user}
#   DB_PASSWORD: ${db_password}
# ---
# apiVersion: v1
# kind: Secret
# metadata:
#   name: db-secrets
#   labels:
#     app: db
# type: Opaque
# data:
#   MYSQL_ROOT_PASSWORD:  ${mysql_root_password}
#   MYSQL_USER: ${db_user}
#   MYSQL_PASSWORD: ${db_password}
# EOF
