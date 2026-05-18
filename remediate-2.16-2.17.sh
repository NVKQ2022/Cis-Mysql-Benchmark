#!/bin/bash
set -euo pipefail

MYSQL_CNF="/etc/mysql/mysql.conf.d/mysqld.cnf"

echo "=== Remediation 2.16: Client-Side Certificates ==="

# Tạo SSL certs nếu chưa tồn tại
if [ ! -f /etc/mysql/ssl/ca.pem ]; then
    echo "Generating SSL certificates..."
    mkdir -p /etc/mysql/ssl
    mysql_ssl_rsa_setup --datadir=/etc/mysql/ssl 2>/dev/null || {
        echo "mysql_ssl_rsa_setup not found, using openssl..."
        cd /etc/mysql/ssl
        openssl rand -writerand .rnd 2>/dev/null || true
        # CA
        openssl genrsa 2048 > ca-key.pem 2>/dev/null
        openssl req -new -x509 -nodes -days 3650 -key ca-key.pem -out ca.pem \
          -subj "/C=VN/CN=MySQL-CA" 2>/dev/null
        # Server
        openssl req -newkey rsa:2048 -days 3650 -nodes -keyout server-key.pem \
          -out server-req.pem -subj "/C=VN/CN=MySQL-Server" 2>/dev/null
        openssl rsa -in server-key.pem -out server-key.pem 2>/dev/null
        openssl x509 -req -in server-req.pem -days 3650 -CA ca.pem -CAkey ca-key.pem \
          -set_serial 01 -out server-cert.pem 2>/dev/null
        rm -f server-req.pem
        # Client
        openssl req -newkey rsa:2048 -days 3650 -nodes -keyout client-key.pem \
          -out client-req.pem -subj "/C=VN/CN=MySQL-Client" 2>/dev/null
        openssl rsa -in client-key.pem -out client-key.pem 2>/dev/null
        openssl x509 -req -in client-req.pem -days 3650 -CA ca.pem -CAkey ca-key.pem \
          -set_serial 02 -out client-cert.pem 2>/dev/null
        rm -f client-req.pem .rnd
    }
    chown -R mysql:mysql /etc/mysql/ssl
    chmod 600 /etc/mysql/ssl/*-key.pem
    chmod 640 /etc/mysql/ssl/*.pem
    echo "SSL certificates generated in /etc/mysql/ssl/"
else
    echo "SSL certificates already exist."
fi

# Thêm SSL paths vào config nếu chưa có
echo "Updating MySQL config..."
declare -A ssl_vars=(
    ["ssl_ca"]="/etc/mysql/ssl/ca.pem"
    ["ssl_cert"]="/etc/mysql/ssl/server-cert.pem"
    ["ssl_key"]="/etc/mysql/ssl/server-key.pem"
)

for var in "${!ssl_vars[@]}"; do
    if grep -qE "^\s*${var}\s*=" "$MYSQL_CNF" 2>/dev/null; then
        sed -i "s|^\s*${var}\s*=.*|${var} = ${ssl_vars[$var]}|" "$MYSQL_CNF"
    else
        sed -i "/^\[mysqld\]/a ${var} = ${ssl_vars[$var]}" "$MYSQL_CNF"
    fi
done

echo ""
echo "=== Remediation 2.17: Approved Ciphers ==="

CIPHER="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"

if grep -qE "^\s*ssl_cipher\s*=" "$MYSQL_CNF" 2>/dev/null; then
    sed -i "s|^\s*ssl_cipher\s*=.*|ssl_cipher = $CIPHER|" "$MYSQL_CNF"
else
    sed -i "/^\[mysqld\]/a ssl_cipher = $CIPHER" "$MYSQL_CNF"
fi

echo "ssl_cipher configured."
echo ""
echo "=== Restarting MySQL ==="
systemctl restart mysql
sleep 2

echo ""
echo "=== Verification ==="
mysql -e "
SELECT VARIABLE_NAME, VARIABLE_VALUE
FROM performance_schema.global_variables
WHERE VARIABLE_NAME IN ('ssl_ca', 'ssl_cert', 'ssl_key', 'ssl_cipher');
" 2>/dev/null || mysql -e "SHOW VARIABLES LIKE 'ssl_%'; SHOW VARIABLES LIKE 'ssl_cipher';" 2>/dev/null

echo ""
echo "=== Done ==="
