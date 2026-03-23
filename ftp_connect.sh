#!/bin/bash
# Cafe24 FTP 접속 스크립트
# 사용법: bash ftp_connect.sh

FTP_HOST="ecudemo392518.ftp.cafe24.com"
FTP_USER="ecudemo392518"
FTP_PASS="1q2w3e4r5t!"

# lftp가 설치되어 있는지 확인
if command -v lftp &> /dev/null; then
    echo "lftp로 접속합니다..."
    lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST"

# ftp 클라이언트 확인
elif command -v ftp &> /dev/null; then
    echo "ftp로 접속합니다..."
    echo "호스트: $FTP_HOST"
    echo "사용자: $FTP_USER"
    echo "비밀번호는 자동 입력됩니다."
    ftp -n "$FTP_HOST" <<SCRIPT
user $FTP_USER $FTP_PASS
binary
ls
SCRIPT

# curl로 디렉토리 목록 확인
elif command -v curl &> /dev/null; then
    echo "curl로 FTP 디렉토리 목록을 확인합니다..."
    curl --ftp-pasv -u "$FTP_USER:$FTP_PASS" "ftp://$FTP_HOST/"

else
    echo "FTP 클라이언트가 설치되어 있지 않습니다."
    echo "다음 중 하나를 설치하세요:"
    echo "  sudo apt install lftp    (추천)"
    echo "  sudo apt install ftp"
    exit 1
fi
