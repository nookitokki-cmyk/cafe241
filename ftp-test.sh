#!/bin/bash
# 카페24 외부 FTP 서버 접속 테스트 스크립트 (lftp 사용)

set -e

# 카페24 FTP 접속 정보
FTP_HOST="ecudemo392518.ftp.cafe24.com"
FTP_USER="ecudemo392518"
FTP_PASS='1q2w3e4r5t!'

LOCAL_DIR="/tmp/ftp-test"
REMOTE_TEST_DIR="/www"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TEST_FILE="ftp-test-${TIMESTAMP}.txt"

echo "=== 카페24 FTP 테스트 시작 ==="
echo "호스트: $FTP_HOST"
echo "사용자: $FTP_USER"

# lftp 설치
if ! command -v lftp &>/dev/null; then
    echo "lftp 설치 중..."
    apt-get update -qq
    apt-get install -y -qq lftp
fi

# 로컬 작업 디렉토리 생성
mkdir -p "$LOCAL_DIR"

# 테스트용 업로드 파일 생성
echo "cafe241 FTP 업로드 테스트 - ${TIMESTAMP}" > "$LOCAL_DIR/$TEST_FILE"

# lftp 공통 설정 (타임아웃 등)
LFTP_SETTINGS="
set net:timeout 10;
set net:max-retries 2;
set net:reconnect-interval-base 3;
set ssl:verify-certificate no;
set ftp:passive-mode yes;
"

# 1. 연결 및 디렉토리 목록 테스트
echo ""
echo "--- [1/4] FTP 연결 및 디렉토리 목록 확인 ---"
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" -e "
$LFTP_SETTINGS
ls;
quit
"
echo "[1/4] 연결 성공"

# 2. 파일 업로드 테스트
echo ""
echo "--- [2/4] 파일 업로드 테스트 ---"
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" -e "
$LFTP_SETTINGS
cd $REMOTE_TEST_DIR;
put $LOCAL_DIR/$TEST_FILE;
quit
"
echo "[2/4] 업로드 성공: $TEST_FILE -> $REMOTE_TEST_DIR/"

# 3. 파일 다운로드 테스트
echo ""
echo "--- [3/4] 파일 다운로드 테스트 ---"
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" -e "
$LFTP_SETTINGS
cd $REMOTE_TEST_DIR;
get $TEST_FILE -o $LOCAL_DIR/downloaded-${TEST_FILE};
quit
"

if [ -f "$LOCAL_DIR/downloaded-${TEST_FILE}" ]; then
    echo "[3/4] 다운로드 성공"
    echo "다운로드된 파일 내용:"
    cat "$LOCAL_DIR/downloaded-${TEST_FILE}"
else
    echo "[3/4] 다운로드 실패!"
    exit 1
fi

# 4. 업로드한 테스트 파일 정리 (원격 삭제)
echo ""
echo "--- [4/4] 원격 테스트 파일 정리 ---"
lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" -e "
$LFTP_SETTINGS
cd $REMOTE_TEST_DIR;
rm $TEST_FILE;
quit
"
echo "[4/4] 원격 테스트 파일 삭제 완료"

# 로컬 임시 파일 정리
rm -rf "$LOCAL_DIR"

echo ""
echo "=== 모든 FTP 테스트 완료 ==="
