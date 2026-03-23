#!/bin/bash
# FTP 서버 설정 스크립트 (vsftpd)
# 터미널에서 FTP로 카페24 스킨 파일을 관리할 수 있도록 설정

set -e

echo "=== FTP 서버 설정 시작 ==="

# vsftpd 설치
apt-get update -qq
apt-get install -y -qq vsftpd ftp

# vsftpd 설정 백업
if [ -f /etc/vsftpd.conf ]; then
    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
fi

# FTP 사용자 디렉토리 설정
FTP_ROOT="/home/user/cafe241/skin"
mkdir -p "$FTP_ROOT"

# vsftpd 설정 파일 작성
cat > /etc/vsftpd.conf << 'VSFTPD_CONF'
# 기본 설정
listen=YES
listen_ipv6=NO

# 로컬 사용자 로그인 허용
local_enable=YES
write_enable=YES

# 익명 접속 비활성화
anonymous_enable=NO

# chroot 설정 (사용자를 홈 디렉토리에 제한)
chroot_local_user=YES
allow_writeable_chroot=YES

# 패시브 모드 설정
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30100

# 로그 설정
xferlog_enable=YES
xferlog_std_format=YES
vsftpd_log_file=/var/log/vsftpd.log

# 파일 권한 설정
local_umask=022
file_open_mode=0644

# UTF-8 파일 이름 지원
utf8_filesystem=YES

# 타임아웃 설정
idle_session_timeout=600
data_connection_timeout=120

# 보안 설정
ssl_enable=NO
seccomp_sandbox=NO
VSFTPD_CONF

# vsftpd 시작
echo "FTP 서버를 시작합니다..."
if command -v service &> /dev/null; then
    service vsftpd restart 2>/dev/null || /usr/sbin/vsftpd &
else
    /usr/sbin/vsftpd &
fi

echo "=== FTP 서버 설정 완료 ==="
echo ""
echo "=========================================="
echo "  FTP 접속 정보"
echo "=========================================="
echo "  호스트: localhost (또는 서버 IP)"
echo "  포트:   21"
echo "  사용자: $(whoami)"
echo "  루트:   $FTP_ROOT"
echo "=========================================="
echo ""
echo "터미널에서 FTP 접속 방법:"
echo "  ftp localhost"
echo ""
echo "또는 카페24 FTP 서버에 접속:"
echo "  ftp [쇼핑몰ID].cafe24.com"
echo "=========================================="
