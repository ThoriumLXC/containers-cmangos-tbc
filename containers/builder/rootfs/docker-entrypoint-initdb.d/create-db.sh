#!/bin/bash

echo "[mariadb]: Creating databases"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" < /sql/db_create_mysql.sql

echo "[mariadb]: Import databases"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" tbccharacters < /sql/tbccharacters.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" tbcmangos < /sql/tbcmangos.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" tbcrealmd < /sql/tbcrealmd.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" tbclogs < /sql/tbclogs.sql

echo "[mariadb]: Granting permissions"
SQL_COMMAND=$(cat <<EOF
GRANT ALL ON tbcmangos.* TO '$MARIADB_USER'@'%';
GRANT ALL ON tbccharacters.* TO '$MARIADB_USER'@'%';
GRANT ALL ON tbcrealmd.* TO '$MARIADB_USER'@'%';
GRANT ALL ON tbclogs.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF
)
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "$SQL_COMMAND"

echo "[mariadb]: Configuring default realm"
REALMLIST_NAME=${REALMLIST_NAME:-CMaNGOS}
REALMLIST_PORT=${REALMLIST_PORT:-8085}
REALMLIST_ICON=${REALMLIST_ICON:-1}
REALMLIST_TIMEZONE=${REALMLIST_TIMEZONE:-0}
REALMLIST_ALLOWED_SECURITY_LEVEL=${REALMLIST_ALLOWED_SECURITY_LEVEL:-0}

SQL_COMMAND=$(cat <<EOF
INSERT INTO tbcrealmd.realmlist (name, address, port, icon, timezone, allowedSecurityLevel)
VALUES ('$REALMLIST_NAME', '$REALMLIST_ADDRESS', '$REALMLIST_PORT', '$REALMLIST_ICON', '$REALMLIST_TIMEZONE', '$REALMLIST_ALLOWED_SECURITY_LEVEL');
EOF
)
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "$SQL_COMMAND"

echo "[mariadb]: Executing custom scripts"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classicrealmd < /sql/user_accounts.sql

echo "[mariadb]: $0 completed"
