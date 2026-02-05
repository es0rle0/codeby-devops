#!/usr/bin/env bash
set -euo pipefail

MYFOLDER="${HOME}/myfolder"

if [[ ! -d "$MYFOLDER" ]]; then
  echo "Folder not found: $MYFOLDER (nothing to do)"
  exit 0
fi

FILE_COUNT="$(find "$MYFOLDER" -maxdepth 1 -type f | wc -l | tr -d ' ')"
echo "Files in $MYFOLDER: $FILE_COUNT"

if [[ -f "${MYFOLDER}/2" ]]; then
  chmod 664 "${MYFOLDER}/2"
  echo "Fixed perms: ${MYFOLDER}/2 -> 664"
else
  echo "File ${MYFOLDER}/2 not found (skip chmod)"
fi

EMPTY_COUNT="$(find "$MYFOLDER" -maxdepth 1 -type f -empty | wc -l | tr -d ' ')"
if [[ "$EMPTY_COUNT" != "0" ]]; then
  find "$MYFOLDER" -maxdepth 1 -type f -empty -print -delete
  echo "Deleted empty files: $EMPTY_COUNT"
else
  echo "No empty files to delete"
fi

while IFS= read -r -d '' f; do
  if [[ -s "$f" ]]; then
    head -n 1 "$f" > "${f}.tmp"
    mv "${f}.tmp" "$f"
  fi
done < <(find "$MYFOLDER" -maxdepth 1 -type f -print0)

echo "Done"
