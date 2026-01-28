#!/usr/bin/env bash
set -eux

ROLE="${1:-}"

DOMAIN="test.local"
WWW_DOMAIN="www.test.local"
SERVER_IP="192.168.56.20"

ensure_hosts_entries() {
  local hosts_file="$1"
  # remove old entries to avoid duplicates
  sed -i "/[[:space:]]${DOMAIN}[[:space:]]*$/d" "$hosts_file" || true
  sed -i "/[[:space:]]${WWW_DOMAIN}[[:space:]]*$/d" "$hosts_file" || true
  echo "${SERVER_IP} ${DOMAIN} ${WWW_DOMAIN}" >> "$hosts_file"
}

if [ "$ROLE" = "server" ]; then
  apt-get update
  apt-get install -y apache2 openssl

  ensure_hosts_entries /etc/hosts

  # Site content
  install -d -m 755 /var/www/test.local
  cat > /var/www/test.local/index.html <<'HTML'
<!doctype html>
<html lang="ru">
<head><meta charset="utf-8"><title>test.local</title></head>
<body>
  <h1>HTTPS работает: test.local</h1>
</body>
</html>
HTML

  # Self-signed cert (CN=test.local)
  install -d -m 700 /etc/ssl/test.local

  cat > /etc/ssl/test.local/openssl.cnf <<EOF
[req]
distinguished_name=req_distinguished_name
x509_extensions=v3_req
prompt=no

[req_distinguished_name]
CN=${DOMAIN}

[v3_req]
subjectAltName=@alt_names

[alt_names]
DNS.1=${DOMAIN}
DNS.2=${WWW_DOMAIN}
EOF

  openssl req -newkey rsa:2048 -nodes \
    -keyout /etc/ssl/test.local/test.local.key \
    -x509 -days 365 \
    -out /etc/ssl/test.local/test.local.crt \
    -config /etc/ssl/test.local/openssl.cnf

  chmod 600 /etc/ssl/test.local/test.local.key

  # Enable modules
  a2enmod ssl rewrite

  # Remove default sites
  a2dissite 000-default.conf || true
  a2dissite default-ssl.conf || true

  # Ensure ports.conf is clean and deterministic (no duplicate Listen)
  cat > /etc/apache2/ports.conf <<'EOF'
# ports.conf for lesson8
Listen 80
Listen 443
EOF

  # Virtual hosts: HTTP->HTTPS and www->non-www
  cat > /etc/apache2/sites-available/test.local.conf <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN}
    ServerAlias ${WWW_DOMAIN}

    RewriteEngine On
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName ${DOMAIN}
    ServerAlias ${WWW_DOMAIN}

    DocumentRoot /var/www/test.local

    SSLEngine on
    SSLCertificateFile /etc/ssl/test.local/test.local.crt
    SSLCertificateKeyFile /etc/ssl/test.local/test.local.key

    <Directory /var/www/test.local>
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.test\.local$ [NC]
    RewriteRule ^ https://${DOMAIN}%{REQUEST_URI} [R=301,L]

    ErrorLog \${APACHE_LOG_DIR}/test.local_error.log
    CustomLog \${APACHE_LOG_DIR}/test.local_access.log combined
</VirtualHost>
</IfModule>
EOF

  a2ensite test.local.conf

  apache2ctl configtest
  systemctl enable --now apache2
  systemctl restart apache2

  # Export public cert for client trust
  cp /etc/ssl/test.local/test.local.crt /vagrant/test.local.crt

elif [ "$ROLE" = "client" ]; then
  apt-get update
  apt-get install -y ca-certificates curl

  ensure_hosts_entries /etc/hosts

  # Wait for server cert to appear in shared folder
  for i in $(seq 1 30); do
    [ -f /vagrant/test.local.crt ] && break
    sleep 2
  done

  if [ ! -f /vagrant/test.local.crt ]; then
    echo "ERROR: /vagrant/test.local.crt not found (provision server first)" >&2
    exit 1
  fi

  cp /vagrant/test.local.crt /usr/local/share/ca-certificates/test.local.crt
  update-ca-certificates

  # Optional quick checks
  curl -I "http://${DOMAIN}" || true
  curl -I "https://${DOMAIN}" || true
  curl -I "https://${WWW_DOMAIN}" || true

else
  echo "Usage: provision.sh server|client" >&2
  exit 2
fi
