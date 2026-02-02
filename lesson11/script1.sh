#!/usr/bin/env bash
# ============================================================
# script1.sh
# ------------------------------------------------------------
# Назначение:
#   Создаёт каталог ~/myfolder и файлы 1–5 в соответствии
#   с условиями задания.
#
# Файлы:
#   1 — 2 строки: приветствие и текущие дата/время
#   2 — пустой файл с правами 777
#   3 — одна строка из 20 случайных символов
#   4–5 — пустые файлы
#
# Скрипт идемпотентен:
#   можно запускать в любом порядке и любое количество раз.
# ============================================================

set -euo pipefail

# ---------- КОНСТАНТЫ ----------
readonly TARGET_DIR="${HOME}/myfolder"
readonly FILE_1="${TARGET_DIR}/1"
readonly FILE_2="${TARGET_DIR}/2"
readonly FILE_3="${TARGET_DIR}/3"
readonly FILE_4="${TARGET_DIR}/4"
readonly FILE_5="${TARGET_DIR}/5"

readonly GREETING="Привет!"
readonly RANDOM_LENGTH=20

# ---------- ФУНКЦИИ ----------

# Создаёт рабочий каталог, если он отсутствует
ensure_directory() {
  mkdir -p "$TARGET_DIR"
}

# Создаёт файл 1 с приветствием и текущими датой/временем
write_file_1() {
  {
    echo "$GREETING"
    date "+%F %T %Z"
  } > "$FILE_1"
}

# Создаёт пустой файл 2 и устанавливает права 777
write_file_2() {
  : > "$FILE_2"
  chmod 777 "$FILE_2"
}

# Создаёт файл 3 с одной строкой из 20 случайных символов
write_file_3() {
  local random_string
  random_string="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$RANDOM_LENGTH")"
  echo "$random_string" > "$FILE_3"
}

# Создаёт пустые файлы 4 и 5
write_empty_files() {
  : > "$FILE_4"
  : > "$FILE_5"
}

# ---------- ОСНОВНАЯ ЛОГИКА ----------

main() {
  ensure_directory
  write_file_1
  write_file_2
  write_file_3
  write_empty_files
  echo "OK: файлы созданы/обновлены в каталоге $TARGET_DIR"
}

main "$@"
