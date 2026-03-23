#!/bin/bash
# 카페24 FTP 접속 스크립트
# 사용법: ./connect-ftp.sh [쇼핑몰ID]

SHOP_ID="${1:-}"

if [ -z "$SHOP_ID" ]; then
    echo "=========================================="
    echo "  카페24 FTP 접속 스크립트"
    echo "=========================================="
    echo ""
    read -p "쇼핑몰 ID를 입력하세요: " SHOP_ID
fi

if [ -z "$SHOP_ID" ]; then
    echo "오류: 쇼핑몰 ID가 필요합니다."
    echo "사용법: ./connect-ftp.sh [쇼핑몰ID]"
    exit 1
fi

FTP_HOST="${SHOP_ID}.cafe24.com"

echo ""
echo "=========================================="
echo "  카페24 FTP 서버에 접속합니다"
echo "  호스트: $FTP_HOST"
echo "=========================================="
echo ""
echo "접속 후 스킨 파일 경로: /skin/"
echo "  - HTML: /skin/layout/, /skin/product/ 등"
echo "  - CSS:  /skin/css/"
echo "  - JS:   /skin/js/"
echo "  - 이미지: /skin/images/"
echo ""

# FTP 접속
ftp "$FTP_HOST"
