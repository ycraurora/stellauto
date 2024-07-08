#! /bin/bash
set -e
# 添加 docker官方 GPG key:
echo "添加 Docker 官方 GPG key"
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo -E curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# 添加apt源
echo "添加 apt 源"
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
# 安装最新版本docker
echo "安装 Docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# 添加docker用户组
echo "添加 Docker 用户组"
result=$(cat /etc/group | grep docker)
if [ ! -n "$result" ]; then
    sudo groupadd docker
fi
# 将当前用户添加至docker用户组
echo "将当前用户添加至 Docker 用户组"
sudo usermod -aG docker $USER
echo "安装成功, 注销并重新登录后生效"
exit 0
