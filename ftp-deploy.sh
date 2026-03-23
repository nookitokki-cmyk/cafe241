#!/bin/bash
# 카페24 FTP 스킨 배포 스크립트

set -e

# .env 파일 로드
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "오류: .env 파일이 없습니다. .env.example을 참고하여 .env 파일을 생성해주세요."
    exit 1
fi

echo "=== 카페24 FTP 배포 시작 ==="
echo "서버: ${FTP_HOST}:${FTP_PORT}"
echo "사용자: ${FTP_USER}"
echo "대상: skin/"

lftp -u "${FTP_USER},${FTP_PASS}" -p "${FTP_PORT}" "${FTP_HOST}" <<EOF
set ssl:verify-certificate no
mirror -R --verbose --delete skin/ /skin/
bye
EOF

echo "=== 배포 완료 ==="
