# ========================================
# 🦞 小话梅版小龙虾 - Windows 一键安装
# ========================================

Write-Host "🦞 欢迎使用小话梅版小龙虾！" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

# 1. 检查 Node.js
$nodeCheck = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCheck) {
    Write-Host "📦 正在安装 Node.js 22..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

$nodeVersion = node --version
Write-Host "✅ Node.js 版本: $nodeVersion" -ForegroundColor Green

# 2. 安装 OpenClaw
Write-Host "📦 正在安装 OpenClaw..." -ForegroundColor Yellow
npm install -g openclaw@latest

# 3. 配置模型
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "🎯 请选择模型配置:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "1. MiniMax (推荐，国内模型)" 
Write-Host "2. Kimi (月之暗面)"
Write-Host "3. OpenRouter (国外模型)"
Write-Host "4. 稍后手动配置"

$choice = Read-Host "请输入选项 (1-4)"

switch ($choice) {
    "1" { 
        Write-Host "配置 MiniMax..." -ForegroundColor Yellow
        $apiKey = Read-Host "请输入 MiniMax API Key"
        # 配置...
    }
    "2" { Write-Host "配置 Kimi..." -ForegroundColor Yellow }
    "3" { Write-Host "配置 OpenRouter..." -ForegroundColor Yellow }
    "4" { Write-Host "跳过配置..." -ForegroundColor Gray }
}

# 4. 启动
Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "🚀 启动服务..." -ForegroundColor Green
Start-Process -FilePath "openclaw" -ArgumentList "gateway","--port","18789"

# 5. 完成
Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "🎉 安装完成！" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 控制台: http://localhost:18789/" -ForegroundColor Cyan
Write-Host "📱 配置聊天: openclaw onboard" -ForegroundColor Cyan
Write-Host ""

# 打开浏览器
Start-Process "http://localhost:18789/"
