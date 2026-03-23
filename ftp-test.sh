#!/bin/bash
# FTP 연결 테스트 스크립트

set -e

# 기본값 설정
FTP_HOST="${FTP_HOST:-localhost}"
FTP_PORT="${FTP_PORT:-21}"
FTP_USER="${FTP_USER:-}"
FTP_PASS="${FTP_PASS:-}"
REMOTE_DIR="${REMOTE_DIR:-/}"
TEST_FILE="ftp-test-$(date +%s).tmp"

usage() {
    echo "사용법: $0 [-h 호스트] [-p 포트] [-u 사용자] [-P 비밀번호] [-d 원격디렉토리]"
    echo ""
    echo "옵션:"
    echo "  -h    FTP 호스트 (기본값: localhost)"
    echo "  -p    FTP 포트 (기본값: 21)"
    echo "  -u    FTP 사용자"
    echo "  -P    FTP 비밀번호"
    echo "  -d    원격 디렉토리 (기본값: /)"
    echo ""
    echo "환경변수로도 설정 가능: FTP_HOST, FTP_PORT, FTP_USER, FTP_PASS, REMOTE_DIR"
    exit 1
}

while getopts "h:p:u:P:d:" opt; do
    case $opt in
        h) FTP_HOST="$OPTARG" ;;
        p) FTP_PORT="$OPTARG" ;;
        u) FTP_USER="$OPTARG" ;;
        P) FTP_PASS="$OPTARG" ;;
        d) REMOTE_DIR="$OPTARG" ;;
        *) usage ;;
    esac
done

if [ -z "$FTP_USER" ]; then
    echo "오류: FTP 사용자를 지정해주세요 (-u 또는 FTP_USER)"
    usage
fi

echo "=== FTP 연결 테스트 시작 ==="
echo "호스트: $FTP_HOST:$FTP_PORT"
echo "사용자: $FTP_USER"
echo "원격 디렉토리: $REMOTE_DIR"
echo ""

# curl이 설치되어 있는지 확인
if ! command -v curl &> /dev/null; then
    echo "오류: curl이 설치되어 있지 않습니다."
    exit 1
fi

# 1. 연결 테스트
echo "[1/4] FTP 연결 테스트..."
if curl -s --connect-timeout 10 -u "$FTP_USER:$FTP_PASS" "ftp://$FTP_HOST:$FTP_PORT/" > /dev/null 2>&1; then
    echo "  ✓ 연결 성공"
else
    echo "  ✗ 연결 실패"
    exit 1
fi

# 2. 디렉토리 목록 조회
echo "[2/4] 디렉토리 목록 조회..."
if curl -s --connect-timeout 10 -u "$FTP_USER:$FTP_PASS" "ftp://$FTP_HOST:$FTP_PORT$REMOTE_DIR" 2>&1; then
    echo "  ✓ 목록 조회 성공"
else
    echo "  ✗ 목록 조회 실패"
    exit 1
fi

# 3. 파일 업로드 테스트
echo "[3/4] 파일 업로드 테스트..."
echo "FTP upload test - $(date)" > "/tmp/$TEST_FILE"
if curl -s --connect-timeout 10 -u "$FTP_USER:$FTP_PASS" \
    -T "/tmp/$TEST_FILE" \
    "ftp://$FTP_HOST:$FTP_PORT$REMOTE_DIR$TEST_FILE" > /dev/null 2>&1; then
    echo "  ✓ 업로드 성공: $TEST_FILE"
else
    echo "  ✗ 업로드 실패"
    rm -f "/tmp/$TEST_FILE"
    exit 1
fi

# 4. 업로드된 파일 삭제
echo "[4/4] 업로드된 테스트 파일 삭제..."
if curl -s --connect-timeout 10 -u "$FTP_USER:$FTP_PASS" \
    "ftp://$FTP_HOST:$FTP_PORT" \
    -Q "DELE $REMOTE_DIR$TEST_FILE" > /dev/null 2>&1; then
    echo "  ✓ 삭제 성공"
else
    echo "  △ 삭제 실패 (수동으로 $TEST_FILE 삭제 필요)"
fi

# 임시 파일 정리
rm -f "/tmp/$TEST_FILE"

echo ""
echo "=== FTP 연결 테스트 완료 ==="
echo "모든 테스트를 통과했습니다."
