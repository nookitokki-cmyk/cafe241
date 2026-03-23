#!/bin/bash
# FTP 서버 설정 및 테스트 스크립트

set -e

echo "=== FTP 서버 설정 및 테스트 시작 ==="

# vsftpd 설치
apt-get update -qq
apt-get install -y -qq vsftpd ftp

# 필요한 디렉토리 생성
mkdir -p /var/ftp/pub
mkdir -p /etc/vsftpd

# vsftpd 설정
cat > /etc/vsftpd.conf << 'CONF'
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
ftpd_banner=cafe241 FTP Server
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100
seccomp_sandbox=NO
CONF

echo "vsftpd 설정 완료"

# FTP 테스트용 사용자 생성
FTP_USER="ftptest"
FTP_PASS="ftptest123"

if ! id "$FTP_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    echo "FTP 테스트 사용자 생성 완료: $FTP_USER"
else
    echo "FTP 테스트 사용자가 이미 존재합니다: $FTP_USER"
fi

# 테스트용 파일 생성
TEST_DIR="/home/$FTP_USER"
echo "cafe241 FTP 테스트 파일입니다." > "$TEST_DIR/test.txt"
chown "$FTP_USER:$FTP_USER" "$TEST_DIR/test.txt"

# vsftpd 서비스 시작
service vsftpd restart 2>/dev/null || /usr/sbin/vsftpd &
sleep 1

echo "=== FTP 서버 시작 완료 ==="

# FTP 연결 테스트
echo "=== FTP 연결 테스트 ==="

ftp -n localhost <<FTP_COMMANDS
user $FTP_USER $FTP_PASS
pwd
ls
get test.txt /tmp/ftp-downloaded.txt
quit
FTP_COMMANDS

if [ -f /tmp/ftp-downloaded.txt ]; then
    echo "FTP 다운로드 테스트 성공!"
    echo "다운로드된 파일 내용:"
    cat /tmp/ftp-downloaded.txt
    rm -f /tmp/ftp-downloaded.txt
else
    echo "FTP 다운로드 테스트 실패!"
    exit 1
fi

# 업로드 테스트
echo "FTP 업로드 테스트 파일입니다." > /tmp/ftp-upload.txt

ftp -n localhost <<FTP_COMMANDS
user $FTP_USER $FTP_PASS
put /tmp/ftp-upload.txt upload-test.txt
ls
quit
FTP_COMMANDS

if [ -f "$TEST_DIR/upload-test.txt" ]; then
    echo "FTP 업로드 테스트 성공!"
    rm -f /tmp/ftp-upload.txt
else
    echo "FTP 업로드 테스트 실패!"
    rm -f /tmp/ftp-upload.txt
    exit 1
fi

echo "=== 모든 FTP 테스트 완료 ==="
echo "FTP 사용자: $FTP_USER"
echo "FTP 비밀번호: $FTP_PASS"
echo "FTP 포트: 21"
