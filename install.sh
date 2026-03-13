#!/bin/bash
# ========================================
# 🦞 小话梅版小龙虾 - 一键安装
# ========================================

# 版本: 1.0.2 (2026-03-13)
# 更新: 支持最新 OpenClaw 2026.3.11

set -e

echo "🦞 小话梅版小龙虾 v1.0.2"
echo "============================"

# 检查系统
if [[ "$EUID" -ne 0 ]]; then
   echo "请使用 root 用户运行: sudo $0"
   exit 1
fi

# 安装依赖
echo "📦 安装依赖..."
apt-get update -qq
apt-get install -y -qq python3 python3-pip git curl > /dev/null 2>&1

# 安装OpenClaw
echo "🤖 安装 OpenClaw 2026.3.11..."
pip3 install openclaw -q

# 启动服务
echo "🚀 启动服务..."
openclaw gateway --port 18789 &
sleep 3

echo ""
echo "============================"
echo "✅ 安装完成！"
echo ""
echo "访问地址: http://localhost:18789"
echo ""
echo "如需配置 API Key，请编辑 ~/.openclaw/openclaw.json"
