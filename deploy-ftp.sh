#!/bin/bash
# 카페24 FTP 스킨 배포 스크립트
# 사용법: ./deploy-ftp.sh [FTP호스트] [사용자ID] [비밀번호]
#   또는 환경변수 설정: FTP_HOST, FTP_USER, FTP_PASS

set -e

# 환경변수 또는 인자에서 FTP 정보 읽기
FTP_HOST="${1:-$FTP_HOST}"
FTP_USER="${2:-$FTP_USER}"
FTP_PASS="${3:-$FTP_PASS}"
SKIN_DIR="$(cd "$(dirname "$0")" && pwd)/skin"
REMOTE_DIR="/skin"

# 필수 값 확인
if [ -z "$FTP_HOST" ] || [ -z "$FTP_USER" ]; then
    echo "사용법: $0 [FTP호스트] [사용자ID] [비밀번호]"
    echo ""
    echo "또는 환경변수를 설정하세요:"
    echo "  export FTP_HOST=your-cafe24-ftp-host"
    echo "  export FTP_USER=your-cafe24-id"
    echo "  export FTP_PASS=your-password"
    echo ""
    echo "카페24 FTP 주소 예시: your-shop-id.cafe24.com"
    exit 1
fi

# 비밀번호가 없으면 입력 받기
if [ -z "$FTP_PASS" ]; then
    read -sp "FTP 비밀번호 입력: " FTP_PASS
    echo ""
fi

# 스킨 디렉토리 확인
if [ ! -d "$SKIN_DIR" ]; then
    echo "오류: 스킨 디렉토리를 찾을 수 없습니다: $SKIN_DIR"
    exit 1
fi

echo "=== 카페24 FTP 스킨 배포 ==="
echo "호스트: $FTP_HOST"
echo "사용자: $FTP_USER"
echo "로컬 경로: $SKIN_DIR"
echo "원격 경로: $REMOTE_DIR"
echo ""

# lftp 설치 확인
if ! command -v lftp &> /dev/null; then
    echo "lftp 설치 중..."
    apt-get update -qq && apt-get install -y -qq lftp
fi

# lftp를 이용한 미러 업로드
echo "스킨 파일 업로드 시작..."
lftp -u "$FTP_USER","$FTP_PASS" "ftp://$FTP_HOST" << LFTP_SCRIPT
set ssl:verify-certificate no
set ftp:passive-mode yes
set net:timeout 30
set net:max-retries 3
set net:reconnect-interval-base 5
mirror --reverse --verbose --delete "$SKIN_DIR" "$REMOTE_DIR"
quit
LFTP_SCRIPT

echo ""
echo "=== 배포 완료 ==="
