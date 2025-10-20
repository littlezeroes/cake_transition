#!/bin/bash

# Script này đọc API key từ biến môi trường GEMINI_API_KEY.
# Cách dùng: GEMINI_API_KEY="your_key_here" ./flash.sh "Your prompt"
API_KEY="${GEMINI_API_KEY}"

# Kiểm tra xem người dùng có nhập prompt không
if [ -z "$1" ]; then
  echo "Cách dùng: ./flash.sh \"Câu lệnh của bạn ở đây\""
  exit 1
fi

PROMPT_TEXT="$1"

# Gọi API Gemini 1.5 Flash
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${API_KEY}" \
  -H 'Content-Type: application/json' \
  -d @- << EOF
{
  "contents": [{
    "parts": [{"text": "${PROMPT_TEXT}"}]
  }]
}
EOF
