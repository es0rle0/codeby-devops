#!/usr/bin/env bash
# ============================================================
# script2.sh
# ------------------------------------------------------------
# Назначение:
#   Обрабатывает файлы в каталоге ~/myfolder:
#     • считает количество файлов
#     • меняет права файла 2 с 777 на 664
#     • удаляет пустые файлы
#     • оставляет только первую строку в остальных файлах
#
# Скрипт идемпотентен:
#   не падает при повторных запусках и любом порядке.
# ============================================================

set -euo pipefail

# ---------- КОНСТАНТЫ ----------
readonly TARGET_DIR="${HOME}/myfolder"
readonly FILE_2="${TARGET_DIR}/2"
readonly FIXED_PERMS="664"

# ---------- ФУНКЦИИ ----------

# Проверяет существование каталога
folder_exists() {
  [[ -d "$TARGET_DIR" ]]
}

# Подсчитывает количество обычных файлов
count_files() {
  find "$TARGET_DIR" -maxdepth 1 -type f -print0 | tr -cd '\0' | wc -c
}

# Исправляет права файла 2, если он существует
fix_permissions_file_2() {
  if [[ -f "$FILE_2" ]]; then
    chmod "$FIXED_PERMS" "$FILE_2"
    echo "OK: права файла 2 изменены на $FIXED_PERMS"
  else
    echo "INFO: файл 2 отсутствует — пропускаем chmod"
  fi
}

# Удаляет пустые файлы
delete_empty_files() {
  local empty_count
  empty_count="$(find "$TARGET_DIR" -maxdepth 1 -type f -empty -print0 | tr -cd '\0' | wc -c)"

  if [[ "$empty_count" -gt 0 ]]; then
    find "$TARGET_DIR" -maxdepth 1 -type f -empty -print -delete
    echo "OK: удалено пустых файлов: $empty_count"
  else
    echo "INFO: пустых файлов нет"
  fi
}

# Оставляет только первую строку в непустых файлах
truncate_to_first_line() {
  find "$TARGET_DIR" -maxdepth 1 -type f -size +0c -exec sh -c '
    for file do
      tmp="${file}.tmp"
      head -n 1 "$file" > "$tmp" && mv "$tmp" "$file"
    done
  ' sh {} +
}

# ---------- ОСНОВНАЯ ЛОГИКА ----------

main() {
  if ! folder_exists; then
    echo "INFO: каталог $TARGET_DIR не найден — выходим без ошибки"
    exit 0
  fi

  local file_count
  file_count="$(count_files | tr -d ' ')"
  echo "Файлов в $TARGET_DIR: $file_count"

  fix_permissions_file_2
  delete_empty_files
  truncate_to_first_line

  echo "DONE"
}

main "$@"
