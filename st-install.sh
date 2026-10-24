#!/data/data/com.termux/files/usr/bin/bash
# SillyTavern 一键安装脚本（Termux 安卓版）
# 用法：bash st-install.sh
set -e

echo "=== 1/4 更新 Termux 并安装依赖 ==="
pkg update -y && pkg upgrade -y
pkg install -y nodejs-lts git which

echo "=== 2/4 拉取 SillyTavern ==="
if [ -d ~/SillyTavern ]; then
  echo "已存在 ~/SillyTavern，跳过克隆"
else
  git clone https://github.com/SillyTavern/SillyTavern.git ~/SillyTavern
fi
cd ~/SillyTavern

echo "=== 3/4 安装依赖 ==="
npm install --no-audit --no-fund

echo "=== 4/4 配置监听地址 ==="
# 允许局域网访问（可选，给 ChatterUI/其他设备连）
if ! grep -q "listen: true" config.yaml 2>/dev/null; then
  echo "listen: true" >> config.yaml
  echo "whitelistMode: false" >> config.yaml
  echo "basicAuthMode: false" >> config.yaml
fi

IP=$(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

echo ""
echo "============================================"
echo " 安装完成！启动方式："
echo "   cd ~/SillyTavern && bash start.sh"
echo ""
echo " 手机本机访问:  http://localhost:8000"
if [ -n "$IP" ]; then
echo " 局域网访问:    http://$IP:8000"
fi
echo "============================================"
echo ""
echo " 下一步：安装 ChatterUI 跑本地小模型（见教程），"
echo " 然后在 ST 里把 API 类型设为 Chat Completion -> Custom (OpenAI-like)，"
echo " 填 http://127.0.0.1:8080/v1 即可。"
