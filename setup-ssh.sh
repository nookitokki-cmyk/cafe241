#!/bin/bash
# SSH 서버 설정 스크립트

set -e

echo "=== SSH 서버 설정 시작 ==="

# openssh-server 설치
apt-get update -qq
apt-get install -y -qq openssh-server

# 필요한 디렉토리 생성
mkdir -p /run/sshd
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# SSH 키 생성 (없는 경우)
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$(whoami)@$(hostname)"
    echo "SSH 키 생성 완료"
else
    echo "SSH 키가 이미 존재합니다"
fi

# 호스트 키 생성
ssh-keygen -A

# 공개키를 authorized_keys에 등록
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# SSH 서버 설정
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# SSH 데몬 시작
/usr/sbin/sshd
echo "=== SSH 서버 설정 완료 ==="
echo "공개키:"
cat ~/.ssh/id_ed25519.pub
