#!/usr/bin/env bash
set -euo pipefail

MYFOLDER="${HOME}/myfolder"

mkdir -p "$MYFOLDER"

{
  echo "Привет!"
  date "+%F %T %Z"
} > "${MYFOLDER}/1"

: > "${MYFOLDER}/2"
chmod 777 "${MYFOLDER}/2"

RAND20="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)"
echo "$RAND20" > "${MYFOLDER}/3"

: > "${MYFOLDER}/4"
: > "${MYFOLDER}/5"

echo "Done: created/updated files in $MYFOLDER"
