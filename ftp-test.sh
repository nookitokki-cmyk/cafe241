#!/bin/bash
# 카페24 FTP 접속 테스트 스크립트

set -e

# .env 파일 로드
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "오류: .env 파일이 없습니다. .env.example을 참고하여 .env 파일을 생성해주세요."
    exit 1
fi

echo "=== FTP 접속 테스트 ==="
echo "서버: ${FTP_HOST}:${FTP_PORT}"
echo "사용자: ${FTP_USER}"

lftp -u "${FTP_USER},${FTP_PASS}" -p "${FTP_PORT}" "${FTP_HOST}" <<EOF
set ssl:verify-certificate no
set net:timeout 10
set net:max-retries 2
pwd
ls
bye
EOF

echo "=== 접속 테스트 완료 ==="
