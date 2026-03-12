#!/bin/bash

# ========================================
# 🦞 小话梅版小龙虾 - 一键安装
# ========================================

# 版本: 1.0.1 (2026-03-12)
# 更新: 添加 AnyRouter 代理支持

set -e

echo "🦞 欢迎使用小话梅版小龙虾！"
echo "================================"
echo "🌏 全程国内，无需翻墙"
echo ""

# 显示版本信息
echo "📋 当前版本: 1.0.1"
echo ""

# 读取版本历史
echo "📜 版本历史："
echo "  v1.0.1 (2026-03-12) - 添加 AnyRouter 代理支持"
echo "  v1.0.0 (2026-03-11) - 初始版本"
echo ""

# 设置国内镜像源
echo "📦 配置国内镜像源..."
export NPM_REGISTRY=https://registry.npmmirror.com
export NODE_URL=https://npmmirror.com/mirrors/node

# 1. 检查/安装 Node.js
if ! command -v node &> /dev/null; then
    echo "📦 正在安装 Node.js 22..."
    # 使用国内源安装 Node.js
    curl -fsSL https://npmmirror.com/mirrors/node/v22.11.0/node-v22.11.0-linux-x64.tar.xz | tar -xJf - -C /usr/local --strip-components=1
fi

NODE_VERSION=$(node --version)
echo "✅ Node.js 版本: $NODE_VERSION"

# 2. 设置 npm 镜像
echo "📦 配置 npm 国内镜像..."
npm config set registry https://registry.npmmirror.com

# 3. 安装 OpenClaw
echo "📦 正在安装 OpenClaw..."
npm install -g openclaw@latest --registry=https://registry.npmmirror.com

# 4. 配置模型（中文引导）
echo ""
echo "================================"
echo "🎯 配置 AI 模型"
echo "================================"
echo ""
echo "请选择要使用的 AI 模型："
echo ""
echo "  [1] MiniMax (推荐 ⭐ - 国内首选，便宜稳定)"
echo "  [2] Kimi (月之暗面)"
echo "  [3] 硅基流动 (SiliconFlow - 聚合多家模型)"
echo "  [4] 使用预置 AnyRouter 代理（孔总的中转服务）"
echo "  [5] 跳过，稍后手动配置"
echo ""

read -p "请输入选项 (1-5): " choice

# AnyRouter 代理地址（预置，不公开）
ANYROUTER_URL="https://anyrouter.kqtxmaster.workers.dev/v1"

case $choice in
    1)
        echo ""
        read -p "请输入 MiniMax API Key: " API_KEY
        if [ -n "$API_KEY" ]; then
            echo "✅ 正在配置 MiniMax..."
            # 写入配置
            mkdir -p ~/.openclaw
            cat > ~/.openclaw/openclaw.json << EOF
{
  "env": {
    "MINIMAX_API_KEY": "$API_KEY"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.5"
      }
    }
  }
}
EOF
            echo "✅ MiniMax 配置完成！"
        fi
        ;;
    2)
        echo ""
        read -p "请输入 Kimi API Key: " API_KEY
        if [ -n "$API_KEY" ]; then
            mkdir -p ~/.openclaw
            cat > ~/.openclaw/openclaw.json << EOF
{
  "env": {
    "MOONSHOT_API_KEY": "$API_KEY"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "siliconflow/Pro/moonshotai/Kimi-K2.5"
      }
    }
  }
}
EOF
            echo "✅ Kimi 配置完成！"
        fi
        ;;
    3)
        echo ""
        read -p "请输入 SiliconFlow API Key: " API_KEY
        if [ -n "$API_KEY" ]; then
            mkdir -p ~/.openclaw
            cat > ~/.openclaw/openclaw.json << EOF
{
  "env": {
    "SILICONFLOW_API_KEY": "$API_KEY"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.5"
      }
    }
  }
}
EOF
            echo "✅ SiliconFlow 配置完成！"
        fi
        ;;
    4)
        echo ""
        echo "📡 使用孔总预置的 AnyRouter 代理服务"
        echo "   代理地址: $ANYROUTER_URL"
        echo ""
        read -p "请输入您的 API Key: " API_KEY
        if [ -n "$API_KEY" ]; then
            mkdir -p ~/.openclaw
            cat > ~/.openclaw/openclaw.json << EOF
{
  "env": {
    "OPENAI_API_KEY": "$API_KEY"
  },
  "providers": {
    "openai": {
      "apiBase": "$ANYROUTER_URL"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gpt-4o"
      }
    }
  }
}
EOF
            echo "✅ AnyRouter 代理配置完成！"
            echo "   代理地址: $ANYROUTER_URL"
        fi
        ;;
    *)
        echo "跳过配置，稍后可用 openclaw onboard 配置"
        ;;
esac

# 5. 配置飞书/微信（可选）
echo ""
echo "================================"
echo "📱 配置聊天渠道（可选）"
echo "================================"
echo ""
echo "您想通过什么方式与 AI 对话？"
echo ""
echo "  [1] 飞书 (推荐 ⭐ - 企业微信也能用)"
echo "  [2] 企业微信"
echo "  [3] Telegram"
echo "  [4] 不配置，直接用网页版"
echo ""

read -p "请输入选项 (1-4): " choice2

case $choice2 in
    1)
        echo "📝 请参考教程配置飞书机器人："
        echo "   https://docs.openclaw.ai/channels/feishu"
        echo ""
        ;;
    2)
        echo "📝 请参考教程配置企业微信："
        echo "   https://docs.openclaw.ai/channels/wecom"
        echo ""
        ;;
    3)
        echo "📝 请参考教程配置 Telegram："
        echo "   https://docs.openclaw.ai/channels/telegram"
        echo ""
        ;;
esac

# 6. 启动服务
echo ""
echo "================================"
echo "🚀 启动服务..."
echo "================================"
openclaw gateway --port 18789 &

sleep 3

# 7. 完成
echo ""
echo "================================"
echo "🎉 安装完成！"
echo "================================"
echo ""
echo "🌐 网页控制台: http://localhost:18789/"
echo "📖 使用文档: https://www.xiaohuamei.my"
echo ""
echo "常用命令："
echo "  启动服务: openclaw gateway"
echo "  查看状态: openclaw status"
echo "  配置聊天: openclaw onboard"
echo ""
echo "================================"
echo "🦞 小话梅版小龙虾 - 您的私人 AI 助手"
echo "================================"
