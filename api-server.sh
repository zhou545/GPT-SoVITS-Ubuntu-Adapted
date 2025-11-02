#!/bin/bash

# GPT-SoVITS API服务器启动脚本 - Linux版本
# 对应Windows版本的接口.bat功能
# 适用于Ubuntu系统

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 颜色定义
RESET="\033[0m"
BOLD="\033[1m"
ERROR="\033[1;31m[ERROR]: $RESET"
WARNING="\033[1;33m[WARNING]: $RESET"
INFO="\033[1;32m[INFO]: $RESET"
SUCCESS="\033[1;34m[SUCCESS]: $RESET"

echo -e "${INFO}启动 GPT-SoVITS API服务器..."

# 检查conda环境
if ! command -v conda &>/dev/null; then
    echo -e "${ERROR}未找到conda，请先安装Anaconda或Miniconda"
    exit 1
fi

# 配置运行环境
if [ -f "setup-env.sh" ]; then
    echo -e "${INFO}加载环境配置..."
    source setup-env.sh
fi

# 激活conda环境
ENV_NAME="GPTSoVits"
if conda info --envs | grep -q "^$ENV_NAME "; then
    echo -e "${INFO}激活conda环境: $ENV_NAME"
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
else
    echo -e "${ERROR}未找到conda环境 '$ENV_NAME'"
    echo -e "${INFO}请先运行 './install-ubuntu.sh' 安装环境"
    exit 1
fi

# 检查并配置FFmpeg路径 (对应Windows版本的FFMPEG_PATH设置)
echo -e "${INFO}配置FFmpeg环境..."
if command -v ffmpeg &>/dev/null; then
    FFMPEG_PATH=$(dirname "$(which ffmpeg)")
    export FFMPEG_PATH
    echo -e "${INFO}FFmpeg路径: $FFMPEG_PATH"
else
    echo -e "${WARNING}系统中未找到ffmpeg，某些功能可能受限"
    echo -e "${INFO}安装ffmpeg: sudo apt install -y ffmpeg"
fi

# 检查Python
if ! command -v python &>/dev/null; then
    echo -e "${ERROR}Python未找到"
    exit 1
fi

# 检查API文件
if [ ! -f "api_v2.py" ]; then
    echo -e "${ERROR}未找到api_v2.py文件"
    exit 1
fi

# 显示服务器信息
echo -e "${INFO}API服务器配置:"
echo "  Python版本: $(python --version)"
echo "  工作目录: $SCRIPT_DIR"
echo "  FFmpeg路径: ${FFMPEG_PATH:-未配置}"
echo ""

# 启动API服务器
echo -e "${INFO}正在启动API服务器..."
echo -e "${INFO}按 Ctrl+C 停止服务器"
echo "========================================"

# 启动API服务器 (对应Windows版本的 runtime\python.exe api_v2.py)
python api_v2.py

echo ""
echo "========================================"
echo -e "${SUCCESS}API服务器已关闭"