#!/bin/bash

# Загружаем переменные из ~/.zshrc.local
source ~/.zshrc.local

# Проверяем, что переменная CURSOR_TOKEN установлена
if [ -z "$CURSOR_TOKEN" ]; then
    echo "CURSOR_TOKEN не установлен."
    exit 1
fi

# Извлекаем часть токена до первого появления "::" (не выводим её)
USER="${CURSOR_TOKEN%%::*}"

# Выполняем запрос к API и вычисляем абсолютное оставшееся количество запросов
# и процент использованных запросов
curl -s \
     -H 'Content-Type: application/json' \
     -H "Cookie: WorkosCursorSessionToken=$CURSOR_TOKEN" \
     "https://www.cursor.com/api/usage?user=$USER" | \
jq -r -c -M 'if (.["gpt-4"] and .["gpt-4"].maxRequestUsage != null and .["gpt-4"].numRequests != null) then
      {
        remaining: (.["gpt-4"].maxRequestUsage - .["gpt-4"].numRequests),
        used_percent: ((.["gpt-4"].numRequests / .["gpt-4"].maxRequestUsage) * 100)
      }
    else
      "N/A"
    end'


