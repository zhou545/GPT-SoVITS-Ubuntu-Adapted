#!/bin/bash

# GPT-SoVITS API接口启动脚本 - Linux版本
# 直接对应Windows版本的接口.bat

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 配置FFmpeg路径 (对应Windows版本的 SET FFMPEG_PATH=%cd%\runtime\ffmpeg\bin)
if command -v ffmpeg &>/dev/null; then
    export FFMPEG_PATH=$(dirname "$(which ffmpeg)")
    export PATH="$FFMPEG_PATH:$PATH"
fi

# 激活conda环境 (如果存在)
if command -v conda &>/dev/null; then
    ENV_NAME="GPTSoVits"
    if conda info --envs | grep -q "^$ENV_NAME "; then
        source "$(conda info --base)/etc/profile.d/conda.sh"
        conda activate "$ENV_NAME" 2>/dev/null
    fi
fi

# 启动API服务器 (对应Windows版本的 runtime\python.exe api_v2.py)
python api_v2.py

# 等待用户按键 (对应Windows版本的 pause)
echo "按任意键继续..."
read -n 1 -s