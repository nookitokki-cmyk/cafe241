#!/bin/bash
# FTP 서버 설정 스크립트 (vsftpd 기반)

set -e

echo "=== FTP 서버 설정 시작 ==="

# vsftpd 설치
apt-get update -qq
apt-get install -y -qq vsftpd ftp

# FTP 업로드 디렉토리 생성
FTP_ROOT="/home/$(whoami)/ftp"
UPLOAD_DIR="$FTP_ROOT/skin"
mkdir -p "$UPLOAD_DIR"

# vsftpd 설정 백업 및 재설정
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak 2>/dev/null || true

cat > /etc/vsftpd.conf << 'VSFTPD_CONF'
# 기본 설정
listen=YES
listen_ipv6=NO

# 로컬 사용자 로그인 허용
local_enable=YES
write_enable=YES

# 파일 업로드 권한
local_umask=022
file_open_mode=0644

# chroot 설정 (보안)
chroot_local_user=YES
allow_writeable_chroot=YES

# Passive 모드 설정
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100

# 로그 설정
xferlog_enable=YES
xferlog_std_format=YES
log_ftp_protocol=YES
vsftpd_log_file=/var/log/vsftpd.log

# 타임아웃 설정
idle_session_timeout=600
data_connection_timeout=120

# 배너
ftpd_banner=cafe241 FTP Server Ready

# 익명 접근 비활성화
anonymous_enable=NO
VSFTPD_CONF

# 스킨 파일을 FTP 디렉토리에 심볼릭 링크
if [ -d "/home/user/cafe241/skin" ]; then
    ln -sf /home/user/cafe241/skin/* "$UPLOAD_DIR/" 2>/dev/null || true
    echo "스킨 파일이 FTP 디렉토리에 연결되었습니다: $UPLOAD_DIR"
fi

# vsftpd 서비스 시작
service vsftpd start 2>/dev/null || /usr/sbin/vsftpd &
echo "=== FTP 서버 설정 완료 ==="

# 연결 정보 출력
echo ""
echo "========================================="
echo "  FTP 연결 정보"
echo "========================================="
echo "  호스트: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'localhost')"
echo "  포트: 21"
echo "  사용자: $(whoami)"
echo "  FTP 루트: $FTP_ROOT"
echo "  스킨 경로: $UPLOAD_DIR"
echo "========================================="
echo ""
echo "FTP 클라이언트 연결 예시:"
echo "  ftp $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'localhost')"
echo ""
echo "카페24 FTP 업로드 (lftp 사용 시):"
echo "  lftp -u [카페24ID],[비밀번호] ftp://[카페24FTP주소]"
echo "  mirror -R skin/ /skin/"
