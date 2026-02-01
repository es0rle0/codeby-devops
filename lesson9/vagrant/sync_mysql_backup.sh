#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source /etc/rsync_mysql_backup.conf

rsync -avz --delete -e "ssh ${SSH_OPTS}" "${SRC_DIR}" "${SSH_USER}@${DEST_HOST}:${DEST_DIR}"
