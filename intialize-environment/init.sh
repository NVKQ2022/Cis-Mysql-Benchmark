#!/bin/bash
# ============================================================
# MySQL Initialization Script (Ubuntu)
# Installs + Secures + Configures MySQL 8.x
# ============================================================

set -euo pipefail

# ---------- CONFIG ----------
MYSQL_ROOT_PASSWORD="RootPass123!"
MYSQL_DATABASE="app_db"
MYSQL_USER="app_user"
MYSQL_USER_PASSWORD="UserPass123!"

LOG_FILE="/var/log/mysql-init.log"

# ---------- LOG FUNCTION ----------
log() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ---------- CHECK ROOT ----------
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

log "Starting MySQL initialization..."

# ---------- UPDATE SYSTEM ----------
log "Updating packages..."
apt update -y >> "$LOG_FILE" 2>&1

# ---------- INSTALL MYSQL ----------
log "Installing MySQL server..."
DEBIAN_FRONTEND=noninteractive apt install -y mysql-server >> "$LOG_FILE" 2>&1

# ---------- START SERVICE ----------
log "Starting MySQL service..."
systemctl enable mysql
systemctl start mysql

# ---------- WAIT FOR MYSQL ----------
log "Waiting for MySQL to be ready..."
sleep 5

# ---------- SECURE MYSQL ----------
log "Securing MySQL installation..."

mysql --user=root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';

DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

FLUSH PRIVILEGES;
EOF

# ---------- CREATE DATABASE + USER ----------
log "Creating database and user..."

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE ${MYSQL_DATABASE};

CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

# ---------- CONFIGURE BIND ADDRESS ----------
log "Configuring MySQL bind-address..."

sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# ---------- RESTART MYSQL ----------
log "Restarting MySQL..."
systemctl restart mysql

# ---------- FIREWALL (OPTIONAL) ----------
if command -v ufw >/dev/null 2>&1; then
    log "Allowing MySQL port in firewall..."
    ufw allow 3306/tcp || true
fi

# ---------- STATUS ----------
log "Checking MySQL status..."
systemctl status mysql --no-pager

# ---------- DONE ----------
log "MySQL initialization completed successfully!"
echo "========================================="
echo " MySQL Root Password: ${MYSQL_ROOT_PASSWORD}"
echo " Database: ${MYSQL_DATABASE}"
echo " User: ${MYSQL_USER}"
echo " User Password: ${MYSQL_USER_PASSWORD}"
echo "========================================="
