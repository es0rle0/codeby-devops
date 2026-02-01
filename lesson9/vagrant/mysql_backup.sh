#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/opt/mysql_backup"
DB_NAME="lesson9db"
TS="$(date +%F_%H-%M-%S)"
OUT="${BACKUP_DIR}/${DB_NAME}_${TS}.sql.gz"

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

# дамп базы + gzip
mysqldump --databases "$DB_NAME" | gzip > "$OUT"

# оставить только последние 48 бэкапов (примерно 2 суток при hourly)
ls -1t "${BACKUP_DIR}/${DB_NAME}_"*.sql.gz 2>/dev/null | tail -n +49 | xargs -r rm -f
echo "Backup created: $OUT"
