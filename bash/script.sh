#!/bin/bash

# Записываем время начала выполнения скрипта
start_time=$(date +%s)
echo "Скрипт запущен: $(date -d @$start_time '+%Y-%m-%d %H:%M:%S')"

# Директория для поиска логов (измените при необходимости)
LOG_DIR="/var/log"

# Проверка существования директории
if [ ! -d "$LOG_DIR" ]; then
    echo "Ошибка: директория $LOG_DIR не существует!" >&2
    exit 1
fi

# Поиск и подсчёт строк с 'php7.4' во всех файлах директории
total_matches=$(grep -r -w --count 'php7.4' "$LOG_DIR" 2>/dev/null | awk -F: '{sum += $2} END {print sum}')

# Записываем время завершения
end_time=$(date +%s)
echo "Скрипт завершён: $(date -d @$end_time '+%Y-%m-%d %H:%M:%S')"

# Рассчитываем продолжительность
duration=$((end_time - start_time))
echo "Общее время выполнения: $duration секунд"

# Выводим результат поиска
echo "Количество строк с 'php7.4': ${total_matches:-0}"
